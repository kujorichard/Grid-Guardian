extends RefCounted

var plant_id : String = ""
var output_multiplier : float = 1.0
var voltage : float = 0.0
var cooling : float = 0.0
var heat : float = 0.0
var damage : float = 0.0
var instability : float = 0.0

var max_multiplier : float = 2.0
var base_pollution_mult : float = 1.0
var heat_rise_rate : float = 29.0
var heat_cool_rate : float = 30.0
var cooling_power_scale : float = 0.18
var damage_rate : float = 6.4
var repair_rate : float = 6.8
var warn_heat : float = 60.0
var critical_heat : float = 86.0
var failure_cooldown : float = 10.0

var disabled_time : float = 0.0
var state : String = "safe"
var cooling_power_draw : float = 0.0

var pollution_multiplier : float = 1.0
var instant_pollution : float = 0.0
var instant_satisfaction : float = 0.0
var instant_stability : float = 0.0

func set_targets(voltage_level: float, cooling_level: float) -> void:
	voltage = clamp(voltage_level, 0.0, 1.0)
	cooling = clamp(cooling_level, 0.0, 1.0)

func start_overclock() -> bool:
	if disabled_time > 0.0:
		return false
	set_targets(1.0, cooling)
	return true

func stop_overclock() -> void:
	set_targets(0.0, cooling)

func update(delta: float) -> void:
	if disabled_time > 0.0:
		disabled_time = max(disabled_time - delta, 0.0)
		heat = max(heat - heat_cool_rate * delta, 0.0)
		damage = max(damage - repair_rate * delta * 0.5, 0.0)  # Slow repair while disabled
		output_multiplier = 0.0
		state = "disabled"
		if disabled_time <= 0.0:
			output_multiplier = 1.0
		return

	# Treat very small slider values as zero to avoid accidental passive heating.
	var effective_voltage := voltage if voltage >= 0.05 else 0.0
	if effective_voltage > 0.0:
		effective_voltage += instability

	# Overclock is intentionally demanding: cooling offsets less of the heat load.
	var cooling_strength := cooling * 1.0
	if effective_voltage <= 0.0:
		cooling_strength = max(cooling_strength, 0.35)

	var heat_gain := (heat_rise_rate * effective_voltage) - (heat_cool_rate * cooling_strength)
	heat = clamp(heat + heat_gain * delta, 0.0, 120.0)

	# Damage calculation
	var damage_gain := 0.0
	if heat > warn_heat:
		damage_gain += (heat - warn_heat) * 0.11
	if effective_voltage > 0.8:
		damage_gain += (effective_voltage - 0.8) * 30.0

	# Apply damage or repair
	damage = clamp(damage + (damage_gain * damage_rate * delta / 10.0), 0.0, 120.0)
	
	# Always repair when voltage is low, repair faster when both heat and voltage are low
	if effective_voltage < 0.6:
		var repair_multiplier := 1.0
		if heat < 50.0:
			repair_multiplier = 2.0  # Faster repair when cool
		elif heat < 70.0:
			repair_multiplier = 1.5
		damage = max(damage - repair_rate * delta * repair_multiplier, 0.0)

	if heat >= 100.0 or damage >= 100.0:
		_trigger_failure()
		return

	_update_state()

	output_multiplier = lerp(1.0, max_multiplier, voltage)
	var damage_penalty : float = clamp(1.0 - (damage / 100.0) * 0.6, 0.4, 1.0)
	output_multiplier *= damage_penalty
	# Cooling uses power: stronger cooling reduces net output.
	cooling_power_draw = clamp(cooling * cooling_power_scale, 0.0, 0.4)
	output_multiplier *= (1.0 - cooling_power_draw)

	pollution_multiplier = base_pollution_mult * (1.0 + voltage * 0.5 + (heat / 100.0) * 0.4)

func _update_state() -> void:
	if damage >= 80.0:
		state = "failing"
	elif heat >= critical_heat:
		state = "critical"
	elif heat >= warn_heat:
		state = "warning"
	else:
		state = "safe"

func _trigger_failure() -> void:
	voltage = 0.0
	output_multiplier = 0.0
	disabled_time = failure_cooldown
	heat = min(heat, 90.0)
	damage = min(damage, 100.0)
	state = "disabled"
	_on_fail()

func _on_fail() -> void:
	pass

func pop_instant_effects() -> Dictionary:
	var effects := {
		"pollution": instant_pollution,
		"satisfaction": instant_satisfaction,
		"stability": instant_stability
	}
	instant_pollution = 0.0
	instant_satisfaction = 0.0
	instant_stability = 0.0
	return effects
