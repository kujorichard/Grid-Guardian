extends Node

# ─── Signals ───────────────────────────────────────────────────────────────────
signal meters_updated(stability: float, pollution: float, satisfaction: float)
signal demand_updated(demand: float, supply: float)
signal event_triggered(event: Dictionary)
signal game_over(reason: String)
signal game_won()
signal time_updated(elapsed: float, total: float)
signal upgrade_purchased(upgrade_id: String)

# ─── Constants ─────────────────────────────────────────────────────────────────
const GAME_DURATION     := 360.0   # 6 minutes to win
const TICK_INTERVAL     := 2.0     # game logic tick every 2s
const EVENT_MIN_INTERVAL := 20.0
const EVENT_MAX_INTERVAL := 35.0
const MAX_COAL_OUTPUT   := 100.0
const MAX_SOLAR_OUTPUT  := 80.0
const MAX_WIND_OUTPUT   := 60.0

# ─── Energy sliders (0–100 = percentage of max output) ─────────────────────────
var coal_level  : float = 50.0
var solar_level : float = 30.0
var wind_level  : float = 20.0

# ─── Upgrades ──────────────────────────────────────────────────────────────────
var upgrades := {
	"battery":      { "owned": false, "cost": 500, "label": "🔋 Battery Storage",  "desc": "Store excess energy. Reduces blackout risk." },
	"grid":         { "owned": false, "cost": 400, "label": "🔌 Grid Upgrade",      "desc": "Absorbs demand spikes better." },
	"better_solar": { "owned": false, "cost": 350, "label": "🌞 Better Solar",       "desc": "Solar works during cloudy conditions too." },
	"stable_wind":  { "owned": false, "cost": 300, "label": "🌬️ Stable Wind",        "desc": "Wind output is more predictable." },
}

# ─── Meters (0–100) ────────────────────────────────────────────────────────────
var stability    : float = 80.0   # ⚡ Power stability
var pollution    : float = 20.0   # 🌫️ Pollution level
var satisfaction : float = 70.0   # 😊 Public satisfaction
var score        : int   = 0
var coins        : int   = 200

# ─── Internal state ────────────────────────────────────────────────────────────
var game_running   : bool  = false
var elapsed_time   : float = 0.0
var tick_timer     : float = 0.0
var event_timer    : float = 0.0
var next_event_in  : float = 25.0
var time_of_day    : String = "morning"  # morning / afternoon / evening / night
var day_cycle_timer: float = 0.0

# Active modifiers from events (reset each tick or after duration)
var solar_modifier : float = 1.0
var wind_modifier  : float = 1.0
var demand_modifier: float = 1.0

var active_event   : Dictionary = {}
var event_duration : float = 0.0

# ─── Demand curve ──────────────────────────────────────────────────────────────
var base_demand : float = 60.0

func _ready() -> void:
	randomize()

func start_game() -> void:
	coal_level  = 50.0
	solar_level = 30.0
	wind_level  = 20.0
	stability    = 80.0
	pollution    = 20.0
	satisfaction = 70.0
	score        = 0
	coins        = 200
	elapsed_time = 0.0
	tick_timer   = 0.0
	event_timer  = 0.0
	next_event_in = randf_range(EVENT_MIN_INTERVAL, EVENT_MAX_INTERVAL)
	day_cycle_timer = 0.0
	time_of_day = "morning"
	solar_modifier = 1.0
	wind_modifier  = 1.0
	demand_modifier = 1.0
	active_event = {}
	for k in upgrades:
		upgrades[k]["owned"] = false
	game_running = true
	emit_signal("meters_updated", stability, pollution, satisfaction)
	emit_signal("demand_updated", base_demand, _get_supply())

func _process(delta: float) -> void:
	if not game_running:
		return

	elapsed_time += delta
	tick_timer   += delta
	event_timer  += delta
	day_cycle_timer += delta

	# Update time of day every 45 seconds (full cycle = 180s)
	var cycle_pos := fmod(day_cycle_timer, 180.0)
	if cycle_pos < 45.0:
		time_of_day = "morning"
	elif cycle_pos < 90.0:
		time_of_day = "afternoon"
	elif cycle_pos < 135.0:
		time_of_day = "evening"
	else:
		time_of_day = "night"

	# Expire active event
	if active_event.size() > 0:
		event_duration -= delta
		if event_duration <= 0.0:
			_clear_event()

	# Game tick
	if tick_timer >= TICK_INTERVAL:
		tick_timer = 0.0
		_game_tick()

	# Trigger event
	if event_timer >= next_event_in:
		event_timer = 0.0
		next_event_in = randf_range(EVENT_MIN_INTERVAL, EVENT_MAX_INTERVAL)
		_trigger_random_event()

	emit_signal("time_updated", elapsed_time, GAME_DURATION)

	# Win check
	if elapsed_time >= GAME_DURATION:
		game_running = false
		emit_signal("game_won")

func _get_demand() -> float:
	var d := base_demand
	match time_of_day:
		"morning":   d = 65.0
		"afternoon": d = 75.0
		"evening":   d = 85.0
		"night":     d = 55.0
	d *= demand_modifier
	# Add slight random fluctuation
	d += randf_range(-5.0, 5.0)
	return clamp(d, 10.0, 150.0)

func _get_solar_output() -> float:
	var base := solar_level / 100.0 * MAX_SOLAR_OUTPUT
	var tod_factor := 1.0
	match time_of_day:
		"morning":   tod_factor = 0.6
		"afternoon": tod_factor = 1.0
		"evening":   tod_factor = 0.3
		"night":     tod_factor = 0.0
	if bool(upgrades["better_solar"]["owned"]):
		tod_factor = clamp(tod_factor + 0.3, 0.0, 1.0)
	return base * tod_factor * solar_modifier

func _get_wind_output() -> float:
	var base := wind_level / 100.0 * MAX_WIND_OUTPUT
	var noise := randf_range(0.7, 1.3)
	if bool(upgrades["stable_wind"]["owned"]):
		noise = randf_range(0.85, 1.15)
	return base * noise * wind_modifier

func _get_coal_output() -> float:
	return coal_level / 100.0 * MAX_COAL_OUTPUT

func _get_supply() -> float:
	return _get_coal_output() + _get_solar_output() + _get_wind_output()

func _game_tick() -> void:
	var demand := _get_demand()
	var supply := _get_supply()
	var coal_out  := _get_coal_output()
	var gap       := supply - demand   # positive = surplus, negative = deficit

	# ── Stability ────────────────────────────────────────────────────────────
	var stability_delta := 0.0
	if gap >= 0.0:
		# Surplus: battery can buffer
		if bool(upgrades["battery"]["owned"]):
			stability_delta = min(gap * 0.12, 4.0)
		else:
			stability_delta = min(gap * 0.08, 2.5)
	else:
		# Deficit
		var severity : float = abs(gap)
		if bool(upgrades["grid"]["owned"]):
			severity *= 0.6
		stability_delta = -severity * 0.25

	stability = clamp(stability + stability_delta, 0.0, 100.0)

	# ── Pollution ────────────────────────────────────────────────────────────
	var coal_ratio := coal_out / MAX_COAL_OUTPUT
	var pollution_delta := (coal_ratio * 3.5) - 1.2   # natural recovery if low coal
	pollution = clamp(pollution + pollution_delta, 0.0, 100.0)

	# ── Satisfaction ─────────────────────────────────────────────────────────
	var sat_delta := 0.0
	sat_delta += (stability - 50.0) * 0.06   # stability pulls satisfaction
	sat_delta -= (pollution - 40.0) * 0.04   # high pollution hurts satisfaction
	if gap < -10.0:
		sat_delta -= 3.0   # blackout risk hurts badly
	satisfaction = clamp(satisfaction + sat_delta, 0.0, 100.0)

	# ── Score & coins ─────────────────────────────────────────────────────────
	var tick_score := int(stability * 0.5 + satisfaction * 0.3 - pollution * 0.2)
	score += max(tick_score, 0)
	coins += 10   # passive income

	emit_signal("meters_updated", stability, pollution, satisfaction)
	emit_signal("demand_updated", demand, supply)

	# ── Lose conditions ───────────────────────────────────────────────────────
	if stability <= 0.0:
		game_running = false
		emit_signal("game_over", "blackout")
	elif pollution >= 100.0:
		game_running = false
		emit_signal("game_over", "pollution")
	elif satisfaction <= 0.0:
		game_running = false
		emit_signal("game_over", "satisfaction")

# ─── Events ────────────────────────────────────────────────────────────────────
func _trigger_random_event() -> void:
	var events := [
		{
			"id": "storm",
			"title": "⛈️ Storm Warning",
			"desc": "Heavy storm hits the city!\nSolar drops, Wind surges.",
			"solar_mod": 0.2, "wind_mod": 1.8, "demand_mod": 1.1,
			"duration": 20.0, "color": Color(0.3, 0.4, 0.8)
		},
		{
			"id": "heatwave",
			"title": "🔥 Heatwave Alert",
			"desc": "Record temperatures!\nDemand spikes as ACs run full blast.",
			"solar_mod": 1.1, "wind_mod": 0.7, "demand_mod": 1.5,
			"duration": 18.0, "color": Color(0.9, 0.4, 0.1)
		},
		{
			"id": "factory",
			"title": "🏭 Factory Boom",
			"desc": "New factory opens!\nIndustrial demand rises sharply.",
			"solar_mod": 1.0, "wind_mod": 1.0, "demand_mod": 1.35,
			"duration": 22.0, "color": Color(0.6, 0.5, 0.3)
		},
		{
			"id": "policy",
			"title": "🌱 Green Policy Reward",
			"desc": "Government rewards clean energy!\nBonus coins if pollution is low.",
			"solar_mod": 1.0, "wind_mod": 1.0, "demand_mod": 1.0,
			"duration": 15.0, "color": Color(0.2, 0.7, 0.3), "special": "policy"
		},
		{
			"id": "calm",
			"title": "🌤️ Perfect Conditions",
			"desc": "Clear skies & steady breeze!\nRenewables perform at peak.",
			"solar_mod": 1.3, "wind_mod": 1.25, "demand_mod": 0.9,
			"duration": 18.0, "color": Color(0.3, 0.8, 0.8)
		},
	]

	var ev : Dictionary = events[randi() % events.size()]
	solar_modifier  = float(ev.get("solar_mod", 1.0))
	wind_modifier   = float(ev.get("wind_mod", 1.0))
	demand_modifier = float(ev.get("demand_mod", 1.0))
	event_duration  = float(ev.get("duration", 15.0))
	active_event    = ev

	# Handle special policy reward
	if str(ev.get("special", "")) == "policy" and pollution < 40.0:
		coins += 150
		score += 200

	emit_signal("event_triggered", ev)

func _clear_event() -> void:
	solar_modifier  = 1.0
	wind_modifier   = 1.0
	demand_modifier = 1.0
	active_event    = {}

# ─── Upgrade purchase ──────────────────────────────────────────────────────────
func try_buy_upgrade(upgrade_id: String) -> bool:
	if bool(upgrades[upgrade_id]["owned"]):
		return false
	var cost : int = int(upgrades[upgrade_id]["cost"])
	if coins < cost:
		return false
	coins -= cost
	upgrades[upgrade_id]["owned"] = true
	emit_signal("upgrade_purchased", upgrade_id)
	return true

# ─── Setters called by UI sliders ──────────────────────────────────────────────
func set_coal(val: float)  -> void: coal_level  = clamp(val, 0.0, 100.0)
func set_solar(val: float) -> void: solar_level = clamp(val, 0.0, 100.0)
func set_wind(val: float)  -> void: wind_level  = clamp(val, 0.0, 100.0)

func get_time_of_day_label() -> String:
	match time_of_day:
		"morning":   return "🌅 Morning"
		"afternoon": return "☀️ Afternoon"
		"evening":   return "🌆 Evening"
		"night":     return "🌙 Night"
	return "—"
