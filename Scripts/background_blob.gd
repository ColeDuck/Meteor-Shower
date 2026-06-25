extends Node2D





var g1 = preload("res://assets/Background/g1.png")
var g2 = preload("res://assets/Background/g2.png")
var g3 = preload("res://assets/Background/g3.png")
var g4 = preload("res://assets/Background/g4.png")

var pi1 = preload("res://assets/Background/pi1.png")
var pi2 = preload("res://assets/Background/pi2.png")
var pi3 = preload("res://assets/Background/pi3.png")
var pi4 = preload("res://assets/Background/pi4.png")
var pi5 = preload("res://assets/Background/pi5.png")

var p_arr = [p1,p2,p3,p4,p5]
var g_arr = [g1,g2,g3,g4]
var pi_arr = [pi1,pi2,pi3,pi4,pi5]

var purple_spawner: BlobSpawner
var green_spawner: BlobSpawner
var pi_spawner: BlobSpawner
var purple_time: float
var green_time: float
var pink_time: float
var purple_wait: float
var green_wait: float
var pink_wait: float

func spawn_purple(b: Blob):
	var rand: int = randi_range(0,4)
	b.BlobImg = p_arr.get(rand)
	
func spawn_green(b: Blob):
	var rand: int = randi_range(0,3)
	b.BlobImg = g_arr.get(rand)
	
func spawn_pink(b: Blob):
	var rand: int = randi_range(0,4)
	b.BlobImg = pi_arr.get(rand)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	purple_wait = randf_range(0.3,5)
	green_wait = randf_range(0.3,5)
	pink_wait = randf_range(0.3,5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	purple_time += delta
	purple_time += delta
	purple_time += delta
