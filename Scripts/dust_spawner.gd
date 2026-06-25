extends Node

@export var meteor: PackedScene
@export var ice: PackedScene
@export var fire: PackedScene
@export var water: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(1, 200):
		var randX = randf_range(-100, 100)
		var randY = randf_range(-100, 100)
		var type = randi_range(0,3)
		var dust: Dust
		
		if type == 0:
			dust = meteor.instantiate()
		if type == 1:
			dust = ice.instantiate()
		if type == 2:
			dust = fire.instantiate()
		if type == 3:
			dust = water.instantiate()
			
		dust.position.x = randX
		dust.position.y = randY
		add_child(dust, false)
			
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
