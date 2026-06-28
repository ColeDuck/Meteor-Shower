extends Node

@export var meteor: PackedScene
@export var ice: PackedScene
@export var fire: PackedScene
@export var water: PackedScene

var total_dust: int = 0
var max_dust

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	

	total_dust += 300
	for i in range(1, 300):
		spawn_one_dust()
			
		
func spawn_one_dust() -> void:
	var randX = randi_range(-600, 600)
	var randY = randi_range(-600, 600)
	var dust: Dust
	
	var dust_options: Array[String]
	if StatManager.spawn_meteor:
		dust_options.append("meteor")
	if StatManager.spawn_fire:
		dust_options.append("fire")
	if StatManager.spawn_ice:
		dust_options.append("ice")
	if StatManager.spawn_water:
		dust_options.append("water")
		
	var t = randi_range(0, dust_options.size() - 1)
	var type = dust_options.get(t)
	
	if type == "meteor":
		dust = meteor.instantiate()
	if type == "fire":
		dust = fire.instantiate()
	if type == "ice":
		dust = ice.instantiate()
	if type == "water":
		dust = water.instantiate()
			
	var rot = randi_range(0, 3)
	dust.rotation_degrees = 90 * rot
			
	dust.position.x = randX
	dust.position.y = randY
	add_child(dust, false)
	

func replace_dust(dust: PackedScene):
	var all_dust = get_children()
	
	var total_dust_types = 1
	if StatManager.spawn_fire:
		total_dust_types += 1
	if StatManager.spawn_water:
		total_dust_types += 1
	if StatManager.spawn_ice:
		total_dust_types += 1
	
	for i in range(all_dust.size()):
		
		var d = all_dust.get(i)
		if d is not Dust:
			continue
		
		var random = randi_range(1, total_dust_types)
		if random == 1:
			var new_dust
			new_dust = dust.instantiate()
			new_dust.global_position = d.global_position
			add_child(new_dust, false)
			d.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if CardDisplayer.paused:
		return
	max_dust = StatManager.dust_spawn_mult * 500
	
	if total_dust + 1 > max_dust:
		return
	total_dust += 1
	
	spawn_one_dust()
	
	
