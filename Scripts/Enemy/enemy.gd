class_name Enemy
extends CharacterBody2D

# Are we burning or anything
var infliction: String
var infliction_length: float
var infliction_so_far: float
var infliction_tick: float
var bubble_vector: Vector2 # Stores angle that we were hit at

@export var base_health: float
@export var base_damage: float
@export var base_speed: float

@export var animator: AnimatedSprite2D
@export var bubble: Sprite2D
@export var ice: Sprite2D
@export var explode: PackedScene
@export var shatter: PackedScene
@export var vaporize: PackedScene

@export var death: PackedScene

var health: float
var damage: float
var speed: float

var colorF: Vector3 = Vector3(1.0,1.0,1.0)
var last_change: int

var enemy_controller
var mat: ShaderMaterial
var can_damage = true

@export var player: Asteroid

func _ready() -> void:
	mat = material
	health = base_health * StatManager.enemy_health_mult
	damage = base_damage * StatManager.enemy_damage_mult
	speed = base_speed * StatManager.enemy_speed_mult
	velocity = Vector2(0,0)
	bubble.visible = false
	ice.visible = false
	animator.play("Move")
	
	mat = animator.shader_material
	mat.set("shader_parameter/intensity",0.0);
	
	player = Asteroid.instance

# Does movement and processes the infliction
func _process(delta: float) -> void:
	infliction_so_far += delta
	infliction_tick += delta
	
	# DO THE INFLICTION
	if infliction == "bubble":
		bubble_move(delta)
		
	elif infliction == "frozen":
		pass # Literally do nothing cuz ur frozen

	elif infliction == "burn":

		if infliction_tick >= StatManager.burn_tick_rate:
			infliction_tick = 0
			damage_me(StatManager.burn_base_damage * StatManager.burn_damage_mult)
		move(delta, 1.0)
	elif infliction == "frostbite":

		if infliction_tick >= StatManager.frostbite_tick_rate:
			infliction_tick = 0
			damage_me(StatManager.frostbite_base_damage * StatManager.frostbite_damage_mult)
		move(delta, StatManager.frostbite_slow_mult)
	else:
		# Regular movement when not inflicted (and also with most inflictions lol)
		move(delta, 1.0)
		
	# End of infliction when the timer runs out
	if (infliction_so_far >= infliction_length):
		end_infliction()
	
# The usual move, used when not frozen or bubbled
func move(delta: float, speed_mult: float) -> void:
	var angle_to: float = position.angle_to_point(player.position)
	velocity += Vector2.from_angle(angle_to) * delta * speed * speed_mult
	velocity *= 0.98 
	var saved = velocity
	move_and_slide()
	
	for i in get_slide_collision_count():
		var coll = get_slide_collision(i)
		if coll.get_collider() is Asteroid:
			if can_damage:
				player.damage(damage)
				can_damage = false
			queue_free()
	
	velocity = saved

	var target_angle = global_position.direction_to(player.global_position).angle() + PI/2
	rotation = lerp_angle(rotation, target_angle, 0.1)
	
	
	
# Move towards a specific target
func bubble_move(delta: float) -> void:
	position += bubble_vector * delta * StatManager.bubble_speed
	
func flash():
	var time_changed = Time.get_ticks_msec()
	last_change = time_changed
	mat.set("shader_parameter/tint_color",colorF);
	mat.set("shader_parameter/intensity",0.7);
	await get_tree().create_timer(0.2).timeout
	
	if last_change == time_changed:
		mat.set("shader_parameter/intensity",0.0);
	
func damage_me(damage: float) -> void:
	health -= damage * StatManager.all_damage_mult
	flash()
	if health <= 0:
		# Animation?
		# Particle?
		player.killed_enemy()
		var explosion_particle = death.instantiate()
		explosion_particle.emitting = true
		explosion_particle.global_position = global_position
		add_sibling(explosion_particle)
		queue_free() # Die
	
	# Play damage amimation here
	
func start_reaction(new_infliction: String):
	var i = infliction
	var ii = new_infliction
	
	# Bubble + frostbite = freeze
	if i == "bubble" and ii == "frostbite" or i == "frostbite" and i == "bubble":
		end_infliction() # This needs to get rid of any other inflictions
		infliction = "frozen"
		ice.visible = true
		infliction_so_far = 0
		infliction_length = StatManager.frozen_infliction_time
		
		return
	# Burn + Bubble = vapemelt
	elif i == "burn" and ii == "bubble" or i == "bubble" and ii == "burn":
		var b: Bullet = vaporize.instantiate()
		b.global_position = global_position
		add_sibling(b)
		end_infliction()
		return
	# frostbite + burn = vapemelt
	elif i == "burn" and ii == "frostbite" or i == "frostbite" and ii == "burn":
		var b: Bullet = vaporize.instantiate()
		b.global_position = global_position
		add_sibling(b)
		end_infliction()
		return
	# freeze + meteor = shatter
	elif i == "freeze" and ii == "meteor":
		var b: Bullet = shatter.instantiate()
		b.global_position = global_position
		add_sibling(b)
		end_infliction()
		return
	# meteor + burn = explode
	elif ii == "meteor" and i == "burn":
		var b: Bullet = explode.instantiate()
		b.global_position = global_position
		add_sibling(b)
		end_infliction()
		return
	 
	# If it doesn't have an associated elemental reaction, do nothing!
	
func start_infliction(type: String, bullet: Bullet):
	infliction = type
	infliction_so_far = 0
	infliction_length = randf_range(StatManager.min_infliction_time,StatManager.max_infliction_time)
	
	# Free the old p
	#kill_p()
	if type == "meteor":
			colorF = Vector3(0.634, 0.328, 0.141)
			#Color(0.634, 0.328, 0.141, 1.0)
			return
	elif type == "burn":
		colorF = Vector3(1.0,0,0)
		return
	elif type == "frostbite":
		colorF = Vector3(0.638, 0.826, 0.936)
		return
		
	elif type == "bubble":
		colorF = Vector3(0.0, 0.0, 1.0,)
		bubble.visible = true
		bubble_vector = bullet.velocity.normalized()
		return

# Ends all inflictions	
func end_infliction():
	# Remove particles and everything lol
	infliction = ""
	bubble.visible = false
	ice.visible = false
	infliction_so_far = 0
	infliction_length = 1

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is not Bullet:
		return
	var b: Bullet = area
	b.destroy()

	# We need to be inflicted!
	var new_infliction = b.infliction()
	if infliction == "":
		end_infliction() # Just in case
		# Meteors don't inflict, they only cause reactions
		
			
		start_infliction(new_infliction, b)
	else:
		# On noes! We need to do an element reaction!
		start_reaction(new_infliction)
	
	damage_me(b.damage())
	
