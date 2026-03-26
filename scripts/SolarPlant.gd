extends "res://scripts/PowerPlant.gd"
class_name SolarPlant

func _init() -> void:
	plant_id = "solar"
	max_multiplier = 1.7
	base_pollution_mult = 0.6
	heat_rise_rate = 28.0
	heat_cool_rate = 32.0
	damage_rate = 7.0
	repair_rate = 7.0
	failure_cooldown = 8.0

func _on_fail() -> void:
	instant_satisfaction -= 5.0
	instant_stability -= 2.0
