extends Node2D

@onready var smoke : GPUParticles2D = $Smoke
@onready var buildings : Node2D = $Buildings

var _smoke_active: bool = false
var _parallax_time: float = 0.0
var _base_buildings_pos: Vector2
var _base_smoke_pos: Vector2

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
	# Start all buildings as visible but grayed out
	for s in coal_sprites + solar_sprites + wind_sprites:
		s.visible = true
		s.modulate = Color(0.2, 0.2, 0.2) 
	_base_buildings_pos = buildings.position
	_base_smoke_pos = smoke.position

func _process(delta: float) -> void:
	_parallax_time += delta
	var viewport := get_viewport()
	var size := viewport.get_visible_rect().size
	if size.x <= 0.0 or size.y <= 0.0:
		return
	var mouse := viewport.get_mouse_position()
	var norm := (mouse / size) * 2.0 - Vector2.ONE
	var drift := Vector2(sin(_parallax_time * 0.3), cos(_parallax_time * 0.2)) * 0.25
	var target := (norm + drift) * 6.0
	_apply_parallax(target)

func _apply_parallax(target: Vector2) -> void:
	var buildings_target := _base_buildings_pos + target * 0.65
	var smoke_target := _base_smoke_pos + target * 0.7
	buildings.position = buildings.position.lerp(buildings_target, 0.08)
	smoke.position = smoke.position.lerp(smoke_target, 0.08)

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

	_update_sprites_modulate(coal_sprites, coal_count)
	_update_sprites_modulate(solar_sprites, solar_count)
	_update_sprites_modulate(wind_sprites, wind_count)
	
	_update_smoke(pollution)

func _update_sprites_modulate(sprites: Array, active_count: int) -> void:
	for i in range(sprites.size()):
		if i < active_count:
			sprites[i].modulate = Color(1, 1, 1) # Active
		else:
			sprites[i].modulate = Color(0.2, 0.2, 0.2) # Grayed out

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
