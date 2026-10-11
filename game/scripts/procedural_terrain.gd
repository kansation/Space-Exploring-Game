extends Node3D

@export var seed := 1337
@export_range(0.5, 12.0, 0.5) var terrain_height := 2.5
@export_range(0.005, 0.08, 0.005) var noise_scale := 0.025
@export_range(0.0, 2.0, 0.05) var detail_height := 0.35
@export_range(0.02, 0.3, 0.01) var detail_noise_scale := 0.09
@export_range(16, 128, 1) var mesh_resolution := 96
@export var terrain_size := 100.0
@export_range(0.0, 2.0, 0.01) var rock_density := 0.18
@export_range(0.15, 4.0, 0.05) var rock_min_size := 0.3
@export_range(0.15, 4.0, 0.05) var rock_max_size := 0.9
@export var rock_spawn_exclusion_radius := 10.0

@onready var terrain_mesh: MeshInstance3D = $TerrainMesh
@onready var terrain_collision: CollisionShape3D = $TerrainCollision/CollisionShape3D
@onready var player: CharacterBody3D = $Player

func _ready() -> void:
	for argument in OS.get_cmdline_args():
		if argument.begins_with("--terrain-seed="):
			seed = int(argument.trim_prefix("--terrain-seed="))
	_generate_terrain()

func _generate_terrain() -> void:
	var noise := FastNoiseLite.new()
	noise.seed = seed
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.frequency = noise_scale
	var detail_noise := FastNoiseLite.new()
	detail_noise.seed = seed + 7919
	detail_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	detail_noise.frequency = detail_noise_scale

	var grid_size := mesh_resolution + 1
	var heights := PackedFloat32Array()
	heights.resize(grid_size * grid_size)
	for z in range(grid_size):
		for x in range(grid_size):
			var world_x := _grid_to_world(x)
			var world_z := _grid_to_world(z)
			heights[z * grid_size + x] = _sample_height(noise, detail_noise, world_x, world_z)

	var vertices := PackedVector3Array()
	vertices.resize(grid_size * grid_size)
	var normals := PackedVector3Array()
	normals.resize(grid_size * grid_size)
	for z in range(grid_size):
		for x in range(grid_size):
			vertices[z * grid_size + x] = _vertex(x, z, heights, grid_size)

	var indices := PackedInt32Array()
	for z in range(mesh_resolution):
		for x in range(mesh_resolution):
			var a := z * grid_size + x
			var b := z * grid_size + x + 1
			var c := (z + 1) * grid_size + x
			var d := (z + 1) * grid_size + x + 1
			_add_face(indices, normals, vertices, a, c, b)
			_add_face(indices, normals, vertices, b, c, d)

	for index in range(normals.size()):
		normals[index] = normals[index].normalized()

	var mesh_arrays := []
	mesh_arrays.resize(Mesh.ARRAY_MAX)
	mesh_arrays[Mesh.ARRAY_VERTEX] = vertices
	mesh_arrays[Mesh.ARRAY_NORMAL] = normals
	mesh_arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_arrays)

	terrain_mesh.mesh = mesh
	var collision_shape := HeightMapShape3D.new()
	collision_shape.map_width = grid_size
	collision_shape.map_depth = grid_size
	collision_shape.map_data = heights
	terrain_collision.shape = collision_shape
	terrain_collision.scale = Vector3(terrain_size / mesh_resolution, 1.0, terrain_size / mesh_resolution)

	var center_height := _sample_height(noise, detail_noise, 0.0, 0.0)
	player.position = Vector3(0.0, center_height + 2.0, 0.0)
	_generate_rocks(noise, detail_noise)

func _generate_rocks(broad_noise: FastNoiseLite, detail_noise: FastNoiseLite) -> void:
	var rock_rng := RandomNumberGenerator.new()
	rock_rng.seed = seed + 104729
	var rock_material := StandardMaterial3D.new()
	rock_material.albedo_color = Color(0.3, 0.31, 0.29, 1.0)
	rock_material.roughness = 1.0
	rock_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	var rock_meshes: Array[Mesh] = [
		_make_rock_mesh(rock_material, 7, 0.58, 0.7, 0.34),
		_make_rock_mesh(rock_material, 8, 0.52, 0.62, 0.42),
		_make_rock_mesh(rock_material, 6, 0.64, 0.5, 0.28)
	]

	var target_count := int(round(terrain_size * terrain_size / 100.0 * rock_density))
	var placed_count := 0
	var attempts := 0
	var maximum_attempts := maxi(target_count * 12, 12)
	var placement_signature := 17
	while placed_count < target_count and attempts < maximum_attempts:
		attempts += 1
		var x := rock_rng.randf_range(-terrain_size * 0.5 + 2.0, terrain_size * 0.5 - 2.0)
		var z := rock_rng.randf_range(-terrain_size * 0.5 + 2.0, terrain_size * 0.5 - 2.0)
		if Vector2(x, z).length() < rock_spawn_exclusion_radius:
			continue
		var size := rock_rng.randf_range(rock_min_size, rock_max_size)
		var height := _sample_height(broad_noise, detail_noise, x, z)
		var rock := StaticBody3D.new()
		rock.name = "Rock_%02d" % placed_count
		rock.position = Vector3(x, height, z)
		rock.rotation_degrees = Vector3(rock_rng.randf_range(-8.0, 8.0), rock_rng.randf_range(0.0, 360.0), rock_rng.randf_range(-8.0, 8.0))
		rock.scale = Vector3.ONE * size
		placement_signature = placement_signature * 31 + int(round(x * 100.0))
		placement_signature = placement_signature * 31 + int(round(z * 100.0))
		placement_signature = placement_signature * 31 + int(round(size * 100.0))
		$Rocks.add_child(rock)
		var mesh_instance := MeshInstance3D.new()
		mesh_instance.mesh = rock_meshes[rock_rng.randi_range(0, rock_meshes.size() - 1)]
		rock.add_child(mesh_instance)
		if size >= 0.65:
			var collision := CollisionShape3D.new()
			var shape := BoxShape3D.new()
			shape.size = Vector3.ONE
			collision.shape = shape
			rock.add_child(collision)
		placed_count += 1
	print("Procedural rocks: seed=%d count=%d signature=%d" % [seed, placed_count, placement_signature])

func _make_rock_mesh(material: Material, points: int, middle_radius: float, top_radius: float, height_variation: float) -> ArrayMesh:
	var surface_tool := SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	var rings := [0.0, 0.52, 1.0]
	var radii := [0.5, middle_radius, top_radius]
	for ring in range(2):
		for point in range(points):
			var a0 := TAU * float(point) / float(points)
			var a1 := TAU * float((point + 1) % points) / float(points)
			var r0: float = radii[ring] * (1.0 + sin(float(point * 17 + ring * 3)) * 0.12)
			var r1: float = radii[ring] * (1.0 + sin(float((point + 1) * 17 + ring * 3)) * 0.12)
			var y0: float = rings[ring]
			var y1: float = rings[ring]
			var next_y0: float = rings[ring + 1] + sin(float(point * 11 + 5)) * height_variation
			var next_y1: float = rings[ring + 1] + sin(float((point + 1) * 11 + 5)) * height_variation
			var p0 := Vector3(cos(a0) * r0, y0, sin(a0) * r0)
			var p1 := Vector3(cos(a1) * r1, y1, sin(a1) * r1)
			var p2 := Vector3(cos(a0) * radii[ring + 1], next_y0, sin(a0) * radii[ring + 1])
			var p3 := Vector3(cos(a1) * radii[ring + 1], next_y1, sin(a1) * radii[ring + 1])
			surface_tool.add_vertex(p0)
			surface_tool.add_vertex(p2)
			surface_tool.add_vertex(p1)
			surface_tool.add_vertex(p1)
			surface_tool.add_vertex(p2)
			surface_tool.add_vertex(p3)
	var bottom_center := Vector3(0.0, 0.0, 0.0)
	var top_center := Vector3(0.0, 1.0, 0.0)
	for point in range(points):
		var a0 := TAU * float(point) / float(points)
		var a1 := TAU * float((point + 1) % points) / float(points)
		var bottom_a := Vector3(cos(a0) * radii[0], 0.0, sin(a0) * radii[0])
		var bottom_b := Vector3(cos(a1) * radii[0], 0.0, sin(a1) * radii[0])
		var top_a := Vector3(cos(a0) * radii[2], 1.0, sin(a0) * radii[2])
		var top_b := Vector3(cos(a1) * radii[2], 1.0, sin(a1) * radii[2])
		surface_tool.add_vertex(bottom_center)
		surface_tool.add_vertex(bottom_b)
		surface_tool.add_vertex(bottom_a)
		surface_tool.add_vertex(top_center)
		surface_tool.add_vertex(top_a)
		surface_tool.add_vertex(top_b)
	surface_tool.generate_normals()
	var mesh := surface_tool.commit()
	mesh.surface_set_material(0, material)
	return mesh

func _sample_height(broad_noise: FastNoiseLite, detail_noise: FastNoiseLite, world_x: float, world_z: float) -> float:
	return broad_noise.get_noise_2d(world_x, world_z) * terrain_height + detail_noise.get_noise_2d(world_x, world_z) * detail_height

func _add_face(indices: PackedInt32Array, normals: PackedVector3Array, vertices: PackedVector3Array, a: int, b: int, c: int) -> void:
	indices.append(a)
	indices.append(b)
	indices.append(c)
	var normal := (vertices[b] - vertices[a]).cross(vertices[c] - vertices[a])
	normals[a] += normal
	normals[b] += normal
	normals[c] += normal

func _vertex(x: int, z: int, heights: PackedFloat32Array, grid_size: int) -> Vector3:
	return Vector3(_grid_to_world(x), heights[z * grid_size + x], _grid_to_world(z))

func _grid_to_world(index: int) -> float:
	return (float(index) / float(mesh_resolution) - 0.5) * terrain_size
