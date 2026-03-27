extends "res://scripts/PowerPlant.gd"
class_name WindPlant

func _init() -> void:
	plant_id = "wind"
	instability = 0.15
	max_multiplier = 1.8
	heat_rise_rate = 34.0
	heat_cool_rate = 26.0
	damage_rate = 8.0
	repair_rate = 6.0
	failure_cooldown = 10.0

func _on_fail() -> void:
	instant_satisfaction -= 6.0
	instant_stability -= 3.0
