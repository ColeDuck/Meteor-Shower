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
var frost_particle: PackedScene = preload("res://Scenes/Particles/frost_bite_particle.tscn")
var burn_particle: PackedScene
var explode: PackedScene
var shatter: PackedScene
var vaporize: PackedScene

var health: float
var damage: float
var speed: float

var p: GPUParticles2D # Stores whatever current particle we are emitting

@export var player: Asteroid

func _ready() -> void:
	health = base_health * StatManager.enemy_health_mult
	damage = base_damage * StatManager.enemy_damage_mult
	speed = base_speed * StatManager.enemy_speed_mult
	velocity = Vector2(0,0)
	bubble.visible = false
	ice.visible = false
	animator.play("Move")
	
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
	
	
	
	velocity = saved

	var target_angle = global_position.direction_to(player.global_position).angle() + PI/2
	rotation = lerp_angle(rotation, target_angle, 0.1)
	
	
	
# Move towards a specific target
func bubble_move(delta: float) -> void:
	position += bubble_vector * delta * StatManager.bubble_speed
	
func damage_me(damage: float) -> void:
	health -= damage * StatManager.all_damage_mult
	
	if health <= 0:
		# Animation?
		# Particle?
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
		infliction_length = randf_range(StatManager.min_infliction_time,StatManager.max_infliction_time)
		
		p = frost_particle.instantiate()
		p.emitting = true
		
		return
	# Burn + Bubble = vaporize
	elif i == "burn" and ii == "bubble" or i == "bubble" and ii == "burn":
		end_infliction()
		return
	# frostbite + bubble = melt
	elif i == "frostbite" and ii == "bubble" or i == "bubble" and ii == "frostbite":
		end_infliction()
		return
	# freeze + meteor = shatter
	elif i == "freeze" and ii == "meteor":
		end_infliction()
		return
	# meteor + burn = explode
	elif i == "meteor" and ii == "burn":
		end_infliction()
		return
	 
	# If it doesn't have an associated elemental reaction, do nothing!
	
func start_infliction(type: String, bullet: Bullet):
	infliction = type
	infliction_so_far = 0
	infliction_length = randf_range(StatManager.min_infliction_time,StatManager.max_infliction_time)
	
	# Free the old p
	#kill_p()
	
	if type == "burn":
		# burnparticle spawn
		return
	elif type == "frostbite":
		p = frost_particle.instantiate()
		add_sibling(p)
		return
		
	elif type == "bubble":
		print(bubble)
		bubble.visible = true
		bubble_vector = bullet.velocity.normalized()
		return

# Ends all inflictions	
func end_infliction():
	# Remove particles and everything lol
	infliction = ""
	bubble.visible = false
	ice.visible = false
	if p != null:
		p.emitting = false
	infliction_so_far = 0
	infliction_length = 1

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is not Bullet:
		return
	var b: Bullet = area
	b.destroy()

	damage_me(b.damage())
	
	# We need to be inflicted!
	var new_infliction = b.infliction()
	if infliction == "":
		end_infliction() # Just in case
		# Meteors don't inflict, they only cause reactions
		if new_infliction == "meteor":
			return
			
		start_infliction(new_infliction, b)
		return
	
	# On noes! We need to do an element reaction!
	start_reaction(new_infliction)
