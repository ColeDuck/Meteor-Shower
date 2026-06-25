class_name BlobSpawner
extends Node2D

var goal: Vector2
var velocity: Vector2

var BlobScene: PackedScene = preload("res://Scenes/blob.tscn")
@export var p1: CompressedTexture2D
@export var p2: CompressedTexture2D
@export var p3: CompressedTexture2D
@export var p4: CompressedTexture2D
@export var p5: CompressedTexture2D
var p_arr: Array[CompressedTexture2D]

var curr_time: float = 12
var wait_time: float = 10

var player: Node2D

func _ready():
	player = $"../Asteroid"
	global_rotation = 0
	p_arr = [p1,p2,p3,p4,p5]
	
func choose_new_goal():
	goal = Vector2(randf_range(-400, 400), randf_range(-400, 400))

func spawn(pos: Vector2):
	#print("Spawned")
	var b: Blob = BlobScene.instantiate()
	
	# Pick random texture
	var i: int = randi_range(0,4)
	b.texture = p_arr.get(i)
	b.z_index = -10
	
	print(b.texture)
	print(p1)
	
	b.position = player.global_position + position
	
	# Determine max size and time
	var time: float = randf_range(10,20)
	var size: float = randf_range(1, 7)
	
	b.max_time = time
	b.max_size = size
	b.top_level
	
	add_child(b, false)

func _process(delta: float) -> void:
	curr_time += delta
	
	if (curr_time >= wait_time):
		spawn(position)
		curr_time = 0
		wait_time = randf_range(0.2,3)
	
	if (goal.distance_to(position) < 30):
		choose_new_goal()
	
	# Dampen
	velocity *= 0.95 * delta
	
	# Calculate new direction to move in towards goal
	velocity += Vector2.from_angle(position.angle_to(goal)) * 40 * delta
	
	# Move there
	position += velocity
