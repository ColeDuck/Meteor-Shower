class_name Bullet
extends Area2D

var velocity: Vector2

var rotate_time: float = 0.25
var last_rotate: float = 0
var rotation_index: int = 0
var time_alive: float = 0

var smash_particle: GPUParticles2D
var trail_particle: GPUParticles2D

@export var health: int

func damage() -> float:
	return 0
	
func destroy() -> void:
	health -= 1
	if health > 0:
		return
	
	# Destroy
	var p: GPUParticles2D = smash_particle.duplicate()
	p.emitting = true
	p.visible = true
	p.global_position = global_position
	p.top_level = true
	p.one_shot = true
	p.z_index = 100
	add_sibling(p)
	
	# Transfer trail to world and wait for it to end
	remove_child(trail_particle)
	get_parent().add_child(trail_particle)
	trail_particle.global_position = global_position
	trail_particle.emitting = false        # Stop spawning new particles
	trail_particle.finished.connect(trail_particle.queue_free)  # Wait for existing ones to die
	queue_free()

func infliction() -> String:
	return ""
	
func _ready():
	trail_particle = $Trail
	smash_particle = $Smash
	
func _physics_process(delta: float) -> void:
	position += velocity * delta
	trail_particle.rotation = velocity.angle() + PI # Set dir of particles to opposite of movement direction
	
	last_rotate += delta
	if last_rotate > rotate_time:
		# Rotate 
		rotation_index = (rotation_index + 1) % 4
		rotation = rotation_index * (PI/4)
		last_rotate = 0
		
	time_alive += delta
	if time_alive > 7:
		queue_free()
		
