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

var radius: float = 10

static var instance: Asteroid  # a self-registering singleton

@export var iron_scene: PackedScene

func _exit_tree():
	instance = null

func _ready():
	instance = self
	Collider = $AsteroidHitbox
	Camera = $MainCam
	Arrow = $Arrow
	add_iron(5)

func calculate_radius_up(matter: Matter) -> void:
	var new_radius = matter.position.length()
	if (new_radius > radius):
		radius = max(10,new_radius)
		Collider.shape.radius = max(3,radius)
	#print("pos: " + str(global_position))
	#print("mat: " + str(matter.global_position.length()))
	#print(new_hitbox_size)
	
func calculate_radius_down(matter: Matter) -> void:
	var new_radius = matter.position.length()
	if (new_radius < radius):
		radius = max(10,new_radius)
		Collider.shape.radius = max(3,radius)
	
func get_position_allocated(index: int) -> Vector2:
	var c: float = 2.7 # Determines how tight the spiral is
	var r = c * sqrt(index) # Idk
	var theta = index * 2.39996 # Golden ratio?
	var pos: Vector2 = Vector2(round(r * cos(theta)), round(r * sin(theta)))
	return pos

func collect_dust(dust: Dust) -> void:
	# Get type
	var matter: Matter = dust.collect()
	
	# Do we have room?
	if allocated >= storage_size:
		return
	
	matter.position = get_position_allocated(allocated)
	matter.Outline.z_index = -1
	
	var rot = randi_range(0, 3)
	matter.rotation_degrees = 90 * rot
	
	# Add to storage
	storage.insert(allocated, matter)
	allocated += 1
	calculate_radius_up(matter)
	add_child(matter, false)
	dust.remove()
	
func add_iron(amount: int) -> void:
	for i in range(amount):
		print(i)
		if i < allocated:
			storage.get(i).queue_free()
		var new_iron: Matter = iron_scene.instantiate()
		var pos = get_position_allocated(i)
		new_iron.position = pos
		new_iron.Outline.z_index = -1
		var rot = randi_range(0, 3)
		new_iron.rotation_degrees = 90 * rot
		storage.insert(i, new_iron)
		add_child(new_iron, false)
	
	if allocated < amount:
		# We need to set index all the way up here!
		allocated = amount

func _physics_process(delta: float) -> void:
	var current = Camera.zoom.x
	var new_zoom = lerp(current, 100/radius, 4 * delta)
	new_zoom = min(5, new_zoom)
	Camera.zoom = Vector2(new_zoom, new_zoom)
	print(new_zoom)
	
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
	print(storage)
	bullet_eject_buildup = 0
	if (allocated == 0):
		#print("You are dead")
		return
	
	var matter: Matter = storage[allocated - 1]
	var bullet: Bullet = matter.shoot()
	
	if bullet == null:
		# We are iron, do nothing
		return
	
	var a: Vector2 = Vector2.from_angle(rotation).normalized()
	bullet.position = radius * a + global_position
	if rotational_velocity > 0:
		# Left
		a = Vector2(-a.y, a.x)
	else:
		a = Vector2(a.y, -a.x)
	
	# Speed and direction
	bullet.velocity = a
	bullet.velocity *= 30 * abs(rotational_velocity)
	
	# Movement
	bullet.velocity += movement_direction
	
	bullet.top_level = true
	add_child(bullet, false)
	
	storage[allocated - 1].queue_free()
	storage.remove_at(allocated - 1)
	allocated -= 1
	
	if (allocated == 0):
		#print("You are dead")
		return
		
	calculate_radius_down(storage.get(allocated - 1))
	
func _on_area_entered(area: Area2D) -> void:
	if area is Dust:
		collect_dust(area)
