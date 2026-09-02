class_name BlobSpawner
extends Node2D

var goal: Vector2
var velocity: Vector2
var curr_pos: Vector2 = Vector2(0,0)

@export var camera: Camera2D

var BlobScene: PackedScene = preload("res://Scenes//Background/blob.tscn")
@export var p1: CompressedTexture2D
@export var p2: CompressedTexture2D
@export var p3: CompressedTexture2D
@export var p4: CompressedTexture2D
@export var p5: CompressedTexture2D
var p_arr: Array[CompressedTexture2D]

var curr_time: float = 12
var wait_time: float = 10

func _ready():
	global_rotation = 0
	p_arr = [p1,p2,p3,p4,p5]
	
func choose_new_goal():
	goal = Vector2(randf_range(-160, 160), randf_range(-90, 90))

func spawn_blob():
	var b: Blob = BlobScene.instantiate()
	
	# Pick random texture
	var i: int = randi_range(0,4)
	b.texture = p_arr.get(i)
	
	# Pick random time and size
	b.max_time = randf_range(8,14)
	b.max_size = randf_range(0.4, 2)
	
	b.position = curr_pos
	add_sibling(b, false)

func _process(delta: float) -> void:
	curr_time += delta
	
	if (curr_time >= wait_time):
		spawn_blob()
		curr_time = 0
		wait_time = randf_range(0.4,1.4)
	
	if (goal.distance_to(curr_pos) < 30):
		choose_new_goal()
	
	# Dampen
	velocity *= 0.97
	
	# Calculate new direction to move in towards goal
	velocity += Vector2.from_angle(curr_pos.angle_to_point(goal)) * delta
	
	# Move there
	curr_pos += velocity
