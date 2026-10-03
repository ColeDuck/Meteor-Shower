extends CanvasLayer

var player: Asteroid
var camera: Camera2D
var move: Sprite2D
var start
var level_display: Label
var kills_display: Label

func _ready() -> void:
	player = Asteroid.instance
	camera = %MainCam
	move = %Move
	start = move.position
	level_display = %Level
	kills_display = %Kills

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Calculate size of bright
	var percentage: float = player.xp / StatManager.xp_required
	move.position.x = start.x + percentage * 1920
	
	# Move with camera
	
	level_display.text = "Level: " + str(player.level)
	kills_display.text = "Kills: " + str(StatManager.kills)
