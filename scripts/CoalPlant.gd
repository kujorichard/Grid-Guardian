extends "res://scripts/PowerPlant.gd"
class_name CoalPlant

func _init() -> void:
	plant_id = "coal"
	max_multiplier = 2.2
	base_pollution_mult = 1.2
	heat_rise_rate = 42.0
	heat_cool_rate = 24.0
	damage_rate = 9.0
	repair_rate = 5.0
	failure_cooldown = 12.0

func _on_fail() -> void:
	instant_pollution += 10.0
	instant_satisfaction -= 4.0
