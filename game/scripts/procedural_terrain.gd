extends Node3D

@export var seed := 1337
@export_range(0.5, 12.0, 0.5) var terrain_height := 4.0
@export_range(0.005, 0.15, 0.005) var noise_scale := 0.035
@export_range(16, 128, 1) var mesh_resolution := 96
@export var terrain_size := 100.0

@onready var terrain_mesh: MeshInstance3D = $TerrainMesh
@onready var terrain_collision: CollisionShape3D = $TerrainCollision/CollisionShape3D
@onready var player: CharacterBody3D = $Player

func _ready() -> void:
	_generate_terrain()

func _generate_terrain() -> void:
	var noise := FastNoiseLite.new()
	noise.seed = seed
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.frequency = noise_scale

	var grid_size := mesh_resolution + 1
	var heights := PackedFloat32Array()
	heights.resize(grid_size * grid_size)
	for z in range(grid_size):
		for x in range(grid_size):
			heights[z * grid_size + x] = noise.get_noise_2d(_grid_to_world(x), _grid_to_world(z)) * terrain_height

	var vertices := PackedVector3Array()
	vertices.resize(grid_size * grid_size)
	var normals := PackedVector3Array()
	normals.resize(grid_size * grid_size)
	for z in range(grid_size):
		for x in range(grid_size):
			vertices[z * grid_size + x] = _vertex(x, z, heights, grid_size)

	var indices := PackedInt32Array()
	var collision_triangles := PackedVector3Array()
	for z in range(mesh_resolution):
		for x in range(mesh_resolution):
			var a := z * grid_size + x
			var b := z * grid_size + x + 1
			var c := (z + 1) * grid_size + x
			var d := (z + 1) * grid_size + x + 1
			_add_face(indices, normals, vertices, collision_triangles, a, c, b)
			_add_face(indices, normals, vertices, collision_triangles, b, c, d)

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
	var collision_shape := ConcavePolygonShape3D.new()
	collision_shape.data = collision_triangles
	terrain_collision.shape = collision_shape

	var center_height := noise.get_noise_2d(0.0, 0.0) * terrain_height
	player.position = Vector3(0.0, center_height + 2.0, 0.0)

func _add_face(indices: PackedInt32Array, normals: PackedVector3Array, vertices: PackedVector3Array, collision_triangles: PackedVector3Array, a: int, b: int, c: int) -> void:
	indices.append(a)
	indices.append(b)
	indices.append(c)
	var normal := (vertices[b] - vertices[a]).cross(vertices[c] - vertices[a])
	normals[a] += normal
	normals[b] += normal
	normals[c] += normal
	collision_triangles.append(vertices[a])
	collision_triangles.append(vertices[b])
	collision_triangles.append(vertices[c])

func _vertex(x: int, z: int, heights: PackedFloat32Array, grid_size: int) -> Vector3:
	return Vector3(_grid_to_world(x), heights[z * grid_size + x], _grid_to_world(z))

func _grid_to_world(index: int) -> float:
	return (float(index) / float(mesh_resolution) - 0.5) * terrain_size
