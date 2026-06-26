class_name Asteroid
extends Area2D

# Movement
var ROTATION_SPEED: float = 3
var OPPOSITE_ROTATION_SPEED: float = 20
var MAX_ROTATION: float = 400

var ACCELERATION: float = 60
var MAX_SPEED: float = 200
var DECELERATION: float = 0.9998

# Negative for left, pos for right
var rotational_velocity: float = 0

var movement_direction: Vector2
var DIRECTION_CHANGE_ALLOWANCE: float = 10


# Bullet
var bullet_eject_buildup: float = 0
var MAX_BUILDUP: float = 100

# Storage
var storage: Array[Matter]
var allocated: int = 0
var storage_size: int = 10000

var Collider: CollisionShape2D
var Camera: Camera2D
var Arrow: Sprite2D

var radius: float = 1

static var instance: Asteroid  # a self-registering singleton

func _exit_tree():
	instance = null

func _ready():
	instance = self
	Collider = $AsteroidHitbox
	Camera = $MainCam
	Arrow = $Arrow

func calculate_radius(matter: Matter) -> void:
	radius = matter.position.length()
	Collider.shape.radius = max(1,radius)
	
	#Camera.zoom = Vector2(100/radius,100/radius)
	#print("pos: " + str(global_position))
	#print("mat: " + str(matter.global_position.length()))
	#print(new_hitbox_size)
	

func collect_dust(dust: Dust) -> void:
	# Get type
	var matter: Matter = dust.collect()
	
	# Do we have room?
	if allocated >= storage_size:
		return
		
	# Yes, determine location
	var c: float = 2.7 # Determines how tight the spiral is
	var r = c * sqrt(allocated) # Idk
	var theta = allocated * 2.39996 # Golden ratio?
	var pos: Vector2 = Vector2(round(r * cos(theta)), round(r * sin(theta)))
	
	matter.position = pos
	#matter.Nugget.z_index = index + 1
	matter.Outline.z_index = -1
	
	var rot = randi_range(0, 3)
	matter.rotation_degrees = 90 * rot
	
	# Add to storage
	storage.insert(allocated, matter)
	allocated += 1
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
	rotational_velocity *= 0.999
	# Move along rotation
	position += movement_direction * delta
	
	# Calculate eject
	bullet_eject_buildup += 100 * abs(pow(rotational_velocity, 2)) * delta
	#print(bullet_eject_buildup)
	if (bullet_eject_buildup > MAX_BUILDUP):
		shoot()
		
	Arrow.top_level = true
	Arrow.rotation = rotation
	
	if (rotational_velocity > 0):
		Arrow.rotation += PI
		
	var direction_from_center: Vector2 = Vector2.from_angle(rotation).normalized() * 1.2
	Arrow.position = (radius * direction_from_center) + global_position
	
	
		
func shoot() -> void:
	bullet_eject_buildup = 0
	if (allocated == 0):
		#print("You are dead")
		return
	
	var matter: Matter = storage[allocated - 1]
	var bullet: Bullet = matter.shoot()
	
	var a: Vector2 = Vector2.from_angle(rotation).normalized()
	bullet.position = radius * a + global_position
	if rotational_velocity > 0:
		# Left
		a = Vector2(-a.y, a.x)
	else:
		a = Vector2(a.y, -a.x)
	

	bullet.velocity = a
	bullet.velocity *= 50 * abs(rotational_velocity)
	bullet.velocity += movement_direction
	
	bullet.top_level = true
	add_child(bullet, false)
	
	storage[allocated - 1].queue_free()
	storage.remove_at(allocated - 1)
	allocated -= 1
	
	if (allocated == 0):
		#print("You are dead")
		return
		
	calculate_radius(storage.get(allocated - 1))
	


func _on_area_entered(area: Area2D) -> void:
	if area is Dust:
		collect_dust(area)
