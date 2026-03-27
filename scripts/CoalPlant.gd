extends "res://scripts/PowerPlant.gd"
class_name CoalPlant

func _init() -> void:
	plant_id = "coal"
	max_multiplier = 2.05
	base_pollution_mult = 1.15
	heat_rise_rate = 24.0
	heat_cool_rate = 30.0
	damage_rate = 4.6
	repair_rate = 6.5
	failure_cooldown = 12.0

func _on_fail() -> void:
	instant_pollution += 10.0
	instant_satisfaction -= 4.0
