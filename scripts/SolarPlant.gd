extends "res://scripts/PowerPlant.gd"
class_name SolarPlant

func _init() -> void:
	plant_id = "solar"
	max_multiplier = 1.65
	heat_rise_rate = 19.0
	heat_cool_rate = 34.0
	damage_rate = 4.5
	repair_rate = 7.5
	failure_cooldown = 8.0

func _on_fail() -> void:
	instant_satisfaction -= 5.0
	instant_stability -= 2.0
