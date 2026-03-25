extends Node2D

@onready var smoke : GPUParticles2D = $Smoke
@onready var buildings : Node2D = $Buildings

func update_city(coal: int, solar: int, wind: int, pollution: float) -> void:
	"""
	coal, solar, wind: counts of buildings
	pollution: 0–100, from GameManager
	"""
	_update_smoke(pollution)
	#_spawn_buildings(coal, solar, wind)

func _update_smoke(pollution: float) -> void:
	# Always emit some particles to avoid Godot errors
	smoke.amount = 10  

	# Fade alpha based on pollution (0 = invisible, 1 = fully opaque)
	smoke.modulate.a = lerp(0.4, 1.0, pollution / 100.0)

	# Optional: scale particles for visual intensity (smaller smoke at low pollution)
	var scale_factor = lerp(0.3, 1.0, clamp(pollution / 100.0, 0.0, 1.0))
	smoke.scale = Vector2.ONE * scale_factor

	# Show/hide smoke for very low pollution
	smoke.visible = pollution > 5

	# Restart to immediately reflect any changes (optional if you adjust scale/alpha only)
	smoke.restart()

#func _spawn_buildings(coal: int, solar: int, wind: int) -> void:
	#buildings.clear()  # remove previous icons
	## placeholder: just print for now
	#print("Coal:", coal, "Solar:", solar, "Wind:", wind)
	## later you can instance building scenes here
