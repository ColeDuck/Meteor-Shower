extends Area2D

# Movement
var ROTATION_SPEED: float = 3
var OPPOSITE_ROTATION_SPEED: float = 30
var MAX_ROTATION: float = 400

var ACCELERATION: float = 60
var MAX_SPEED: float = 200
var DECELERATION: float = 0.9998

# Negative for left, pos for right
var rotational_velocity: float = 1

var movement_direction: Vector2
var DIRECTION_CHANGE_ALLOWANCE: float = 10


# Bullet
var bullet_eject_buildup: float = 0
var MAX_BUILDUP: float = 100

# Storage
var storage: Array[Matter]
var index: int = -1
var storage_size: int = 100

var Collider: CollisionShape2D
var Camera: Camera2D

func _ready():
	Collider = $AsteroidHitbox
	Camera = $MainCam

func calculate_radius(matter: Matter) -> void:
	var outer: Vector2 = matter.global_position
	var diameter: float = (global_position - outer).length()
	var radius: float = diameter / 2

	var r = matter.position.length()
	Collider.shape.radius = max(1,r)
	
	Camera.zoom = Vector2(100/r,100/r)
	#print("pos: " + str(global_position))
	#print("mat: " + str(matter.global_position.length()))
	#print(new_hitbox_size)
	

func collect_dust(dust: Dust) -> void:
	# Get type
	var matter: Matter = dust.collect()
	# Do we have room?
	if index >= storage_size:
		return
		
	# Yes, determine location
	var c: float = 2.7 # Determines how tight the spiral is
	var r = c * sqrt(index) # Idk
	var theta = index * 2.39996 # Golden ratio?
	var pos: Vector2 = Vector2(round(r * cos(theta)), round(r * sin(theta)))
	
	matter.position = pos
	#matter.Nugget.z_index = index + 1
	matter.Outline.z_index = -1
	
	var rot = randi_range(0, 3)
	matter.rotation_degrees = 90 * rot
	
	# Add to storage
	index += 1
	storage.insert(index, matter)
	calculate_radius(matter)
	add_child(matter, false)
	dust.remove()

func _physics_process(delta: float) -> void:
	# Handle inputs
	if Input.is_action_pressed("RotateRight"):
		if rotational_velocity > 0:
			rotational_velocity += ROTATION_SPEED * delta
		else:
			rotational_velocity += OPPOSITE_ROTATION_SPEED * delta
		
		rotational_velocity = min(MAX_ROTATION, rotational_velocity)
		
	elif Input.is_action_pressed("RotateLeft"):
		if rotational_velocity < 0:
			rotational_velocity -= ROTATION_SPEED * delta
		else:
			rotational_velocity -= OPPOSITE_ROTATION_SPEED * delta
		rotational_velocity = max(-MAX_ROTATION, rotational_velocity)
		
	var dir: Vector2 = Vector2(0,0)
	if Input.is_action_pressed("MoveUp"):
		dir += Vector2.UP
	if Input.is_action_pressed("MoveLeft"):
		dir += Vector2.LEFT
	if Input.is_action_pressed("MoveRight"):
		dir += Vector2.RIGHT
	if Input.is_action_pressed("MoveDown"):
		dir += Vector2.DOWN
		
	# Apply movement
	movement_direction += dir * ACCELERATION * delta
	movement_direction *= DECELERATION
	movement_direction.limit_length(MAX_SPEED)
		
	# Apply rotation
	rotation += rotational_velocity * delta
	
	# Move along rotation
	position += movement_direction * delta
	
	# Calculate eject
	bullet_eject_buildup += abs(rotational_velocity * delta * 400)
	#print(bullet_eject_buildup)
	if (bullet_eject_buildup > MAX_BUILDUP):
		shoot()
		
func shoot() -> void:
	if (index < 0):
		print("You are dead")
		return
	
	bullet_eject_buildup = 0
	print(index)
	storage[index].queue_free()
	storage.remove_at(index)
	index -= 1
	
	if (index < 0):
		print("You are dead")
	


func _on_area_entered(area: Area2D) -> void:
	if area is Dust:
		collect_dust(area)
