class_name Asteroid
extends CharacterBody2D

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
var copy: CollisionShape2D
var ended: Sprite2D
var Camera: Camera2D
var Arrow: Sprite2D

var radius: float = 10

var dust_spawner
var last_change: int

var xp: float = 0
var level: int = 1

static var instance: Asteroid  # a self-registering singleton

@export var iron_scene: PackedScene

func _exit_tree():
	instance = null

func _ready():
	instance = self
	Collider = %AsteroidHitbox
	copy = %CopyForBoundary
	Camera = $MainCam
	Arrow = $Arrow
	dust_spawner = %Dust_Spawner
	ended = %YouDeid
	add_iron(5)

func calculate_radius_up(matter: Matter) -> void:
	if matter == null:
		return
	var new_radius = matter.position.length()
	if (new_radius > radius):
		radius = max(10,new_radius)
		Collider.shape.radius = max(3,radius)
		copy.shape.radius = max(3,radius)
	#print("pos: " + str(global_position))
	#print("mat: " + str(matter.global_position.length()))
	#print(new_hitbox_size)
	
func calculate_radius_down(matter: Matter) -> void:
	if matter == null:
		return
	var new_radius = matter.position.length()
	if (new_radius < radius):
		radius = max(10,new_radius)
		Collider.shape.radius = max(3,radius)
		copy.shape.radius = max(3,radius)
	
func get_position_allocated(index: int) -> Vector2:
	var c: float = 2.7 # Determines how tight the spiral is
	var r = c * sqrt(index) # Idk
	var theta = index * 2.39996 # Golden ratio?
	var pos: Vector2 = Vector2(round(r * cos(theta)), round(r * sin(theta)))
	return pos

func collect_dust(dust: Dust) -> void:
	if CardDisplayer.paused:
		return
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
	dust_spawner.total_dust -= 1
	
func add_iron(amount: int) -> void:
	for i in range(amount):
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

func damage(amount: int) -> void:
	if CardDisplayer.paused:
		return
	for i in range(0,amount):
		remove_from_storage()
	
	if allocated != 0:
		calculate_radius_down(storage.get(allocated - 1))
	flash()
	
func flash():
	var time_changed = Time.get_ticks_msec()
	last_change = time_changed
	material.set("shader_parameter/tint_color",Vector3(255,0,0));
	material.set("shader_parameter/intensity",1.0);
	await get_tree().create_timer(0.2).timeout
	
	if last_change == time_changed:
		material.set("shader_parameter/intensity",0.0);

func _physics_process(delta: float) -> void:
	
	if CardDisplayer.paused:
		return
		
	ROTATION_SPEED = StatManager.rotation_acceleration
	OPPOSITE_ROTATION_SPEED = ROTATION_SPEED * 4
	ACCELERATION = StatManager.acceleration
	MAX_SPEED = StatManager.max_velocity
	
	
	storage_size = StatManager.max_matter_storage
	
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
	movement_direction = movement_direction.limit_length(MAX_SPEED)
	movement_direction *= DECELERATION
		
	# Apply rotation
	rotation += rotational_velocity * delta
	rotational_velocity = max(min(StatManager.max_rotation, rotational_velocity), -StatManager.max_rotation)
	rotational_velocity *= 0.999
	# Move along rotation
	
	velocity = movement_direction
	var m = move_and_collide(velocity * delta, true)
	if m != null:
		# This has to be a world collision so, reflect on that!
		# Up and down
		if m.get_normal().abs().is_equal_approx(Vector2(0,1)):
			movement_direction *= Vector2(1,-1)
		elif m.get_normal().abs().is_equal_approx(Vector2(1,0)):
			movement_direction *= Vector2(-1,1)
	move_and_collide(velocity * delta, false)
	# Calculate eject
	bullet_eject_buildup += 100 * abs(pow(abs(rotational_velocity), 1.5)) * delta
	#print(bullet_eject_buildup)
	if (bullet_eject_buildup > MAX_BUILDUP):
		for i in range(0, StatManager.bullet_streams):
			if (Input.is_action_pressed("Shoot")):
				shoot(i * PI/2)
		
	Arrow.top_level = true
	Arrow.rotation = rotation
	
	if (rotational_velocity > 0):
		Arrow.rotation += PI
		
	var direction_from_center: Vector2 = Vector2.from_angle(rotation).normalized() * 1.2
	Arrow.position = (radius * direction_from_center) + global_position
		
func shoot(angle_change: float) -> void:
	bullet_eject_buildup = 0
	if (allocated == 0):
		ended.visible = true
		get_tree().quit()
		return
	
	var matter: Matter = storage[allocated - 1]
	var bullet: Bullet = matter.shoot()
	
	if bullet == null:
		# We are iron, do nothing
		return
	
	var a: Vector2 = Vector2.from_angle(rotation + angle_change).normalized()
	bullet.position = radius * a + global_position
	if rotational_velocity > 0:
		# Left
		a = Vector2(-a.y, a.x)
	else:
		a = Vector2(a.y, -a.x)
	
	# Speed and direction
	bullet.velocity = a
	bullet.velocity *= max(30 * abs(rotational_velocity), 50)
	# Movement
	bullet.velocity += movement_direction
	
	bullet.top_level = true
	add_child(bullet, false)
	
	if matter.destroy():
		remove_from_storage()
		
	calculate_radius_down(storage.get(allocated - 1))

func killed_enemy():
	xp += round(StatManager.xp_mult * 1)
	if xp - StatManager.xp_required >= -0.2:
		level_up()
	
func level_up():
	xp = StatManager.xp_required + 10
	CardDisplayer.start()
	level += 1
	pass

func remove_from_storage():
	if (allocated == 0):
		ended.visible = true
		get_tree().quit()
		return
	
	storage[allocated - 1].queue_free()
	storage.remove_at(allocated - 1)
	allocated -= 1
	
	if (allocated == 0):
		ended.visible = true
		get_tree().quit()
		return

func end_level_up():
	if level < 65:
		StatManager.xp_required = (level/1.4) + 3
	else:
		StatManager.xp_required = pow(1.1, level) + 2
	xp = 0

func _on_area_2d_area_entered(area: Area2D) -> void:
	if CardDisplayer.paused:
		return
	if area is Dust:
		collect_dust(area)
