extends Node2D

@onready var smoke : GPUParticles2D = $Smoke
var _smoke_active: bool = false

@onready var coal_sprites  : Array = [
	$Buildings/CoalPlant/Coal1,
	$Buildings/CoalPlant/Coal2,
	$Buildings/CoalPlant/Coal3,
	$Buildings/CoalPlant/Coal4
]
@onready var solar_sprites : Array = [
	$Buildings/SolarPlant/Solar1,
	$Buildings/SolarPlant/Solar2,
	$Buildings/SolarPlant/Solar3,
	$Buildings/SolarPlant/Solar4
]
@onready var wind_sprites  : Array = [
	$Buildings/WindPlant/Wind1,
	$Buildings/WindPlant/Wind2,
	$Buildings/WindPlant/Wind3,
	$Buildings/WindPlant/Wind4
]

func _ready():
	# Hide all pre-placed sprites initially
	for s in coal_sprites + solar_sprites + wind_sprites:
		s.visible = false

func _percent_to_count(percent: float) -> int:
	if percent <= 0: return 0
	elif percent <= 25: return 1
	elif percent <= 50: return 2
	elif percent <= 75: return 3
	else: return 4

func update_city(coal: int, solar: int, wind: int, pollution: float) -> void:
	var coal_count  = _percent_to_count(coal)
	var solar_count = _percent_to_count(solar)
	var wind_count  = _percent_to_count(wind)

	for i in range(coal_sprites.size()):
		coal_sprites[i].visible = i < coal_count
	for i in range(solar_sprites.size()):
		solar_sprites[i].visible = i < solar_count
	for i in range(wind_sprites.size()):
		wind_sprites[i].visible = i < wind_count
	
	_update_smoke(pollution)

func _update_smoke(pollution: float) -> void:
	smoke.amount = 10  
	smoke.modulate.a = lerp(0.4, 1.0, pollution / 100.0)
	var scale_factor = lerp(0.3, 1.0, clamp(pollution / 100.0, 0.0, 1.0))
	smoke.scale = Vector2.ONE * scale_factor
	
	if pollution > 5:
		smoke.visible = true
		if not _smoke_active:
			smoke.restart()  # Only restart once
			_smoke_active = true
	else:
		smoke.visible = false
		_smoke_active = false
