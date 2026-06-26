extends Node2D


var enemy_spawn_mult: float = 1.0
var enemy_health_mult: float = 1.0
var enemy_damage_mult: float = 1.0
var enemy_speed_mult: float = 1.0

# Dust and bullets and matter
var max_matter_storage: int = 10

var dust_spawn_mult: float = 1.0 

var spawn_meteor: bool = true
var meteor_dust_mult: float = 1.0 
var meteor_base_damage: float = 3
var meteor_damage_mult: float = 1.0
var meteor_bullet_per: int = 1

var spawn_water: bool = false
var water_dust_mult: float = 1.0 
var water_base_damage: float = 3
var water_damage_mult: float = 1.0
var water_bullet_per: int = 1

var spawn_fire: bool = false
var fire_dust_mult: float = 1.0
var fire_damage_mult: float = 1.0
var fire_base_damage: float = 3
var fire_bullet_per: int = 1

var spawn_ice: bool = false
var ice_dust_must: float = 1.0
var ice_damage_mult: float = 1.0
var ice_base_damage: float = 3
var ice_damage_per: int = 1

var all_damage_mult: float = 1.0
var bullet_streams: int = 1 # Can go to 8
# Warning! Increasing this causes you to use double the bullets!

# Elemental effects
var bubble_infliction_time: float = 1.0
var bubble_speed: float = 10.0

var burn_infliction_time: float = 1.0
var burn_tick_rate: float = 1.0 # Seconds
var burn_base_damage: float = 10.0
var burn_damage_mult: float = 1.0

var frostbite_infliction_time: float = 1.0
var frostbite_tick_rate: float = 0.3
var frostbite_base_damage: float = 1.0
var frostbite_damage_mult: float = 1.0
var frostbite_slow_mult: float = 0.8
# Frostbite + bubble (any order)
var frozen_infliction_time: float = 1.0
# Bubble + burning (in any order)
var vaporize_damage_mult: float = 1.0
var vaporize_base_damage: float = 30.0
# Meteor + burning (must first be burning)
var explode_damage_mult: float = 1.0
var explode_base_damage: float = 30
# Burning + frostbite (any order)
var melt_damage_mult: float = 1.0
var melt_base_damage: float = 20
# Meteor + frozen
var shatter_damage_mult: float = 1.0
var shatter_base_damage: float = 50

var min_infliction_time: float = 2.0
var max_infliction_time: float = 5.0

# Movement
var rotation_acceleration: float = 100
var max_rotation: float = 200
var acceleration: float = 100
var max_velocity: float = 200

# Level up
var xp_mult: float = 1.0
var xp_required: float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
