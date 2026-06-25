extends CharacterBody2D

# Movement
var ROTATION_SPEED: float = 6
var OPPOSITE_ROTATION_SPEED: float = 25
var MAX_ROTATION: float = 10

var ACCELERATION: float = 200
var MAX_SPEED: float = 80
var DECELERATION: float = 0.9995

# Negative for left, pos for right
var rotational_velocity: float = 1
var speed: float = 10

var movement_direction: Vector2
var DIRECTION_CHANGE_ALLOWANCE: float = 10


# Bullet
var bullet_eject_buildup: float = 0
var MAX_BUILDUP: float = 100

# Storage
var storage: Array[Bullet]
var empty_locations: Array[int] # Maps to indexes in storage

func collect_matter(dust: Dust):
	pass



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
		
	if Input.is_action_pressed("MoveForward"):
		speed += ACCELERATION * delta
		var curr_dir = Vector2(cos(rotation), sin(rotation))
		movement_direction += curr_dir * speed * delta
		movement_direction.limit_length(MAX_SPEED)
		
		# Only update direction when we move 
		
	# Dampen
	speed *= DECELERATION
	speed = min(MAX_SPEED, speed)
		
	# Apply rotation
	rotation += rotational_velocity * delta
	
	# Move along rotation
	position += movement_direction * delta
