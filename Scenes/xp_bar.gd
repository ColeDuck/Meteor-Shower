extends Node2D

var player: Asteroid
var camera: Camera2D
var move: Sprite2D
var start
var level_display: Label
var OutOfDisplay: Label

func _ready() -> void:
	player = Asteroid.instance
	camera = %MainCam
	move = %Move
	start = move.position
	level_display = %Level
	OutOfDisplay = %OutOf

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Calculate size of bright
	var percentage: float = player.xp / StatManager.xp_required
	move.position.x = start.x + percentage * 384
	
	# Move with camera
	global_position = camera.get_screen_center_position()
	
	level_display.text = "Level: " + str(player.level)
	OutOfDisplay.text = str(player.xp) + " / " + str(StatManager.xp_required)
