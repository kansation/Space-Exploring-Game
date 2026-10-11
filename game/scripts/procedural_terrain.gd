extends Node3D

@export var seed := 1337
@export_range(0.5, 12.0, 0.5) var terrain_height := 4.0
@export_range(0.005, 0.15, 0.005) var noise_scale := 0.035
@export_range(16, 128, 1) var mesh_resolution := 64
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

	var surface_tool := SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	var collision_triangles := PackedVector3Array()
	for z in range(mesh_resolution):
		for x in range(mesh_resolution):
			var a := _vertex(x, z, heights, grid_size)
			var b := _vertex(x + 1, z, heights, grid_size)
			var c := _vertex(x, z + 1, heights, grid_size)
			var d := _vertex(x + 1, z + 1, heights, grid_size)
			_add_triangle(surface_tool, collision_triangles, a, b, c)
			_add_triangle(surface_tool, collision_triangles, b, d, c)

	var mesh := surface_tool.commit()
	terrain_mesh.mesh = mesh
	var collision_shape := ConcavePolygonShape3D.new()
	collision_shape.data = collision_triangles
	terrain_collision.shape = collision_shape

	var center_height := noise.get_noise_2d(0.0, 0.0) * terrain_height
	player.position = Vector3(0.0, center_height + 2.0, 0.0)

func _add_triangle(surface_tool: SurfaceTool, collision_triangles: PackedVector3Array, a: Vector3, b: Vector3, c: Vector3) -> void:
	var normal := (b - a).cross(c - a).normalized()
	surface_tool.set_normal(normal)
	surface_tool.add_vertex(a)
	surface_tool.set_normal(normal)
	surface_tool.add_vertex(b)
	surface_tool.set_normal(normal)
	surface_tool.add_vertex(c)
	collision_triangles.append(a)
	collision_triangles.append(b)
	collision_triangles.append(c)

func _vertex(x: int, z: int, heights: PackedFloat32Array, grid_size: int) -> Vector3:
	return Vector3(_grid_to_world(x), heights[z * grid_size + x], _grid_to_world(z))

func _grid_to_world(index: int) -> float:
	return (float(index) / float(mesh_resolution) - 0.5) * terrain_size
