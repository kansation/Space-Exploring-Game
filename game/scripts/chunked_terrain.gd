extends Node3D

@export var world_seed := 1337
@export_range(16, 128, 1) var chunk_resolution := 64
@export var chunk_size := 100.0
@export_range(0.5, 12.0, 0.5) var terrain_height := 2.5
@export_range(0.005, 0.08, 0.005) var noise_scale := 0.025
@export_range(0.0, 2.0, 0.05) var detail_height := 0.35
@export_range(0.02, 0.3, 0.01) var detail_noise_scale := 0.09

@onready var chunks_root: Node3D = $Chunks
@onready var player: CharacterBody3D = $Player

func _ready() -> void:
	_generate_grid()

func _generate_grid() -> void:
	var broad_noise := FastNoiseLite.new()
	broad_noise.seed = world_seed
	broad_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	broad_noise.frequency = noise_scale
	var detail_noise := FastNoiseLite.new()
	detail_noise.seed = world_seed + 7919
	detail_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	detail_noise.frequency = detail_noise_scale
	var ground_material := ShaderMaterial.new()
	ground_material.shader = preload("res://shaders/terrain_slope_blend.gdshader")
	ground_material.set_shader_parameter("soil_texture", preload("res://assets/textures/rock_ground_1k.jpg"))
	ground_material.set_shader_parameter("rock_texture", preload("res://assets/textures/rocks_ground_01_1k.jpg"))
	ground_material.set_shader_parameter("texture_scale", 0.08)
	ground_material.set_shader_parameter("rock_slope_start", 0.015)
	ground_material.set_shader_parameter("rock_slope_end", 0.08)

	for chunk_z in range(-1, 2):
		for chunk_x in range(-1, 2):
			_generate_chunk(chunk_x, chunk_z, broad_noise, detail_noise, ground_material)
	_verify_shared_edges(broad_noise, detail_noise)

	var center_height := _sample_height(broad_noise, detail_noise, 0.0, 0.0)
	player.position = Vector3(0.0, center_height + 2.0, 0.0)

func _verify_shared_edges(broad_noise: FastNoiseLite, detail_noise: FastNoiseLite) -> void:
	var maximum_edge_gap := 0.0
	for boundary in range(-1, 1):
		for sample in range(chunk_resolution + 1):
			var offset := (float(sample) / float(chunk_resolution) - 0.5) * chunk_size
			var vertical_gap: float = abs(_sample_height(broad_noise, detail_noise, (boundary + 1) * chunk_size, offset) - _sample_height(broad_noise, detail_noise, boundary * chunk_size + chunk_size, offset))
			var horizontal_gap: float = abs(_sample_height(broad_noise, detail_noise, offset, (boundary + 1) * chunk_size) - _sample_height(broad_noise, detail_noise, offset, boundary * chunk_size + chunk_size))
			maximum_edge_gap = max(maximum_edge_gap, max(vertical_gap, horizontal_gap))
	var first_signature := _sample_signature(broad_noise, detail_noise)
	var second_signature := _sample_signature(broad_noise, detail_noise)
	assert(maximum_edge_gap == 0.0)
	assert(first_signature == second_signature)
	print("Chunked terrain: seed=%d chunks=9 edge_gap=%.6f reproducible=%s" % [world_seed, maximum_edge_gap, first_signature == second_signature])

func _sample_signature(broad_noise: FastNoiseLite, detail_noise: FastNoiseLite) -> int:
	var signature := 17
	for coordinate in range(-2, 3):
		var height := _sample_height(broad_noise, detail_noise, coordinate * chunk_size * 0.37, coordinate * chunk_size * -0.23)
		signature = signature * 31 + int(round(height * 10000.0))
	return signature

func _generate_chunk(chunk_x: int, chunk_z: int, broad_noise: FastNoiseLite, detail_noise: FastNoiseLite, ground_material: Material) -> void:
	var grid_size := chunk_resolution + 1
	var chunk_origin := Vector2(chunk_x * chunk_size, chunk_z * chunk_size)
	var heights := PackedFloat32Array()
	heights.resize(grid_size * grid_size)
	var vertices := PackedVector3Array()
	vertices.resize(grid_size * grid_size)
	var normals := PackedVector3Array()
	normals.resize(grid_size * grid_size)
	var step := chunk_size / float(chunk_resolution)
	for z in range(grid_size):
		for x in range(grid_size):
			var local_x := (float(x) / float(chunk_resolution) - 0.5) * chunk_size
			var local_z := (float(z) / float(chunk_resolution) - 0.5) * chunk_size
			var world_x := chunk_origin.x + local_x
			var world_z := chunk_origin.y + local_z
			var height := _sample_height(broad_noise, detail_noise, world_x, world_z)
			heights[z * grid_size + x] = height
			vertices[z * grid_size + x] = Vector3(local_x, height, local_z)
			normals[z * grid_size + x] = _sample_normal(broad_noise, detail_noise, world_x, world_z, step)

	var indices := PackedInt32Array()
	for z in range(chunk_resolution):
		for x in range(chunk_resolution):
			var a := z * grid_size + x
			var b := z * grid_size + x + 1
			var c := (z + 1) * grid_size + x
			var d := (z + 1) * grid_size + x + 1
			indices.append(a)
			indices.append(c)
			indices.append(b)
			indices.append(b)
			indices.append(c)
			indices.append(d)

	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	var chunk := Node3D.new()
	chunk.name = "Chunk_%d_%d" % [chunk_x, chunk_z]
	chunk.position = Vector3(chunk_x * chunk_size, 0.0, chunk_z * chunk_size)
	chunks_root.add_child(chunk)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.material_override = ground_material
	chunk.add_child(mesh_instance)

	var body := StaticBody3D.new()
	body.name = "Collision"
	chunk.add_child(body)
	var collision := CollisionShape3D.new()
	var heightmap := HeightMapShape3D.new()
	heightmap.map_width = grid_size
	heightmap.map_depth = grid_size
	heightmap.map_data = heights
	collision.shape = heightmap
	collision.scale = Vector3(chunk_size / chunk_resolution, 1.0, chunk_size / chunk_resolution)
	body.add_child(collision)

func _sample_height(broad_noise: FastNoiseLite, detail_noise: FastNoiseLite, world_x: float, world_z: float) -> float:
	return broad_noise.get_noise_2d(world_x, world_z) * terrain_height + detail_noise.get_noise_2d(world_x, world_z) * detail_height

func _sample_normal(broad_noise: FastNoiseLite, detail_noise: FastNoiseLite, world_x: float, world_z: float, step: float) -> Vector3:
	var left := _sample_height(broad_noise, detail_noise, world_x - step, world_z)
	var right := _sample_height(broad_noise, detail_noise, world_x + step, world_z)
	var back := _sample_height(broad_noise, detail_noise, world_x, world_z - step)
	var front := _sample_height(broad_noise, detail_noise, world_x, world_z + step)
	return Vector3(left - right, step * 2.0, back - front).normalized()
