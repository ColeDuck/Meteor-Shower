extends Node

@export var one: PackedScene
@export var two: PackedScene
@export var three: PackedScene
@export var four: PackedScene
@export var five: PackedScene

var player: Asteroid

var total_enemies: int = 0
var max_enemies: int = 50

var time: float = 0
var time_since_start: float = 0

func _ready() -> void:
	player = Asteroid.instance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_since_start += delta
	harder(time_since_start)
	
	if total_enemies + 1 > max_enemies:
		return
	time += delta
	if time < 5 / StatManager.enemy_spawn_mult:
		return
	time = 0
	
	var camera = %MainCam
	var center = camera.get_screen_center_position()
	var xs = 384 / 2
	var ys = 216 / 2
	
	var randX
	var randY
	var side = randi_range(0,3)
	if side == 0: # Top
		randX = randi_range(-xs, xs)
		randY = -ys - 10
	if side == 1: # Bottom
		randX = randi_range(-xs, xs)
		randY = ys + 10
	if side == 2: # Left
		randX = xs + 10
		randY = randi_range(-ys, ys)
	if side == 3: # Right
		randX = -xs - 10
		randY = randi_range(-ys, ys)
		
	var max_type = min(time_since_start / 60, 4)
		
	var type = randi_range(0,max_type)
	var dust: Enemy
		
	if type == 0:
		dust = one.instantiate()
	if type == 1:
		dust = two.instantiate()
	if type == 2:
		dust = three.instantiate()
	if type == 3:
		dust = four.instantiate()
	if type == 4:
		dust = five.instantiate()	
			
	dust.global_position.x = randX + center.x
	dust.global_position.y = randY + center.y
	add_child(dust, false)
	
func harder(time: float):
	var new_value: float = pow(2, time_since_start / 60.0)
	StatManager.enemy_damage_mult = new_value / 2.0
	StatManager.enemy_spawn_mult = new_value
	StatManager.enemy_speed_mult = new_value / 2.0
	
