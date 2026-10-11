extends Node3D

@export var world_seed := 1337
@export var planet_radius := 40.0
@export var terrain_height := 2.0
@export_range(8, 64, 1) var patch_resolution := 32
@export var patch_longitude_degrees := 24.0
@export var patch_latitude_degrees := 24.0

@onready var player: CharacterBody3D = $Player

var noise := FastNoiseLite.new()
var planet_center := Vector3.ZERO
var patch_ranges := [Vector2(-24.0, 0.0), Vector2(0.0, 24.0)]

func _ready() -> void:
	noise.seed = world_seed
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.frequency = 0.08
	_generate_patch(0, patch_ranges[0])
	_generate_patch(1, patch_ranges[1])
	var start := _surface_position(deg_to_rad(-12.0), 0.0)
	player.global_position = start + start.normalized() * 2.0
	player.set("planet_center", planet_center)
	print("Curved planet: seed=%d radius=%.1f patches=2 edge_gap=%.6f reproducible=%s" % [world_seed, planet_radius, _edge_gap(), _reproducible()])

func _generate_patch(index: int, longitude_range: Vector2) -> void:
	var grid_size := patch_resolution + 1
	var vertices := PackedVector3Array()
	var normals := PackedVector3Array()
	vertices.resize(grid_size * grid_size)
	normals.resize(grid_size * grid_size)
	for z in range(grid_size):
		var latitude: float = lerp(-patch_latitude_degrees * 0.5, patch_latitude_degrees * 0.5, float(z) / patch_resolution)
		for x in range(grid_size):
			var longitude: float = lerp(longitude_range.x, longitude_range.y, float(x) / patch_resolution)
			var position := _surface_position(deg_to_rad(longitude), deg_to_rad(latitude))
			vertices[z * grid_size + x] = position
			normals[z * grid_size + x] = (position - planet_center).normalized()
	var indices := PackedInt32Array()
	for z in range(patch_resolution):
		for x in range(patch_resolution):
			var a := z * grid_size + x
			var b := a + 1
			var c := (z + 1) * grid_size + x
			var d := c + 1
			indices.append(a); indices.append(b); indices.append(c)
			indices.append(b); indices.append(d); indices.append(c)
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.27, 0.34, 0.20, 1.0)
	material.roughness = 1.0
	var patch := Node3D.new()
	patch.name = "Patch_%d" % index
	$Patches.add_child(patch)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.material_override = material
	patch.add_child(mesh_instance)
	var body := StaticBody3D.new()
	body.name = "Collision"
	patch.add_child(body)
	var shape := ConcavePolygonShape3D.new()
	var faces := PackedVector3Array()
	for index_value in indices:
		faces.append(vertices[index_value])
	shape.set_faces(faces)
	var collision := CollisionShape3D.new()
	collision.shape = shape
	body.add_child(collision)

func _surface_position(longitude: float, latitude: float) -> Vector3:
	var noise_value: float = noise.get_noise_2d(rad_to_deg(longitude), rad_to_deg(latitude))
	var radius := planet_radius + noise_value * terrain_height
	return Vector3(cos(latitude) * cos(longitude), sin(latitude), cos(latitude) * sin(longitude)) * radius

func _edge_gap() -> float:
	var maximum := 0.0
	for sample in range(patch_resolution + 1):
		var latitude: float = lerp(-patch_latitude_degrees * 0.5, patch_latitude_degrees * 0.5, float(sample) / patch_resolution)
		var left := _surface_position(deg_to_rad(0.0), deg_to_rad(latitude))
		var right := _surface_position(deg_to_rad(0.0), deg_to_rad(latitude))
		maximum = max(maximum, left.distance_to(right))
	return maximum

func _reproducible() -> bool:
	var first := _surface_position(deg_to_rad(-12.0), 0.0)
	var second := _surface_position(deg_to_rad(-12.0), 0.0)
	return first == second
