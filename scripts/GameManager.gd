extends Node

# ─── Signals ───────────────────────────────────────────────────────────────────
signal meters_updated(stability: float, pollution: float, satisfaction: float)
signal demand_updated(demand: float, supply: float)
signal event_triggered(event: Dictionary)
signal game_over(reason: String)
signal game_won()
signal time_updated(elapsed: float, total: float)
signal upgrade_purchased(upgrade_id: String)
signal energy_supply_updated(coal_sup: float, solar_sup: float, wind_sup: float)
signal coal_price_updated(price: int)

# ─── Constants ─────────────────────────────────────────────────────────────────
const GAME_DURATION := 360.0 # 6 minutes to win
const TICK_INTERVAL := 2.0 # game logic tick every 2s
const EVENT_MIN_INTERVAL := 20.0
const EVENT_MAX_INTERVAL := 35.0
const MAX_COAL_OUTPUT := 100.0
const MAX_SOLAR_OUTPUT := 80.0
const MAX_WIND_OUTPUT := 60.0

# Energy supply consumption / recharge rates (per tick at 100% utilization)
const COAL_CONSUME_RATE := 2.0
const SOLAR_CONSUME_RATE := 1.8
const WIND_CONSUME_RATE := 1.5
const DEBUFF_CONSUME_MULTIPLIER := 1.5
const SOLAR_RECHARGE_RATE := 4.5
const WIND_RECHARGE_RATE := 3.5

# Coal market defaults
const COAL_PRICE_MIN_DEFAULT := 40
const COAL_PRICE_MAX_DEFAULT := 85
const WIND_GUST_INTERVAL := 20.0
const COAL_PRICE_INTERVAL := 10.0

# ─── Energy sliders (0–100 = percentage of max output) ─────────────────────────
var coal_level: float = 50.0
var solar_level: float = 30.0
var wind_level: float = 20.0

# ─── Upgrades ──────────────────────────────────────────────────────────────────
var upgrades := {
	"battery": {"owned": false, "cost": 500, "label": "🔋 Battery Storage", "desc": "Store excess energy. Reduces blackout risk."},
	"grid": {"owned": false, "cost": 400, "label": "🔌 Grid Upgrade", "desc": "Absorbs demand spikes better."},
	"better_solar": {"owned": false, "cost": 350, "label": "🌞 Better Solar", "desc": "Solar works during cloudy conditions too."},
	"stable_wind": {"owned": false, "cost": 300, "label": "🌬️ Stable Wind", "desc": "Wind output is more predictable."},
}

# ─── Meters (0–100) ────────────────────────────────────────────────────────────
var stability: float = 80.0 # ⚡ Power stability
var pollution: float = 20.0 # 🌫️ Pollution level
var satisfaction: float = 70.0 # 😊 Public satisfaction
var score: int = 0
var coins: int = 200

# ─── Energy Supply (0–100%) ────────────────────────────────────────────────────
var coal_supply: float = 50.0
var solar_supply: float = 10.0
var wind_supply: float = 20.0

# Wind gust (recharge rate for wind, randomized every 20s)
var wind_gust: float = 30.0 # 0–100 %
var wind_gust_timer: float = 0.0

# Coal market
var coal_price: int = 60
var coal_price_timer: float = 0.0
var coal_price_min: int = COAL_PRICE_MIN_DEFAULT
var coal_price_max: int = COAL_PRICE_MAX_DEFAULT

# Absolute Dryness state
var drought_active: bool = false
var drought_timer: float = 0.0

# Event-based supply modifiers (per-tick multipliers, reset when event clears)
var solar_recharge_modifier: float = 1.0
var wind_recharge_modifier: float = 1.0
var coal_consume_modifier: float = 1.0

# ─── Internal state ────────────────────────────────────────────────────────────
var game_running: bool = false
var elapsed_time: float = 0.0
var tick_timer: float = 0.0
var event_timer: float = 0.0
var next_event_in: float = 25.0
var time_of_day: String = "morning" # morning / afternoon / evening / night
var day_cycle_timer: float = 0.0

# Active modifiers from events (reset each tick or after duration)
var solar_modifier: float = 1.0
var wind_modifier: float = 1.0
var demand_modifier: float = 1.0

var active_event: Dictionary = {}
var event_duration: float = 0.0

# ─── Demand curve ──────────────────────────────────────────────────────────────
var base_demand: float = 60.0

func _ready() -> void:
	randomize()

func start_game() -> void:
	coal_level = 50.0
	solar_level = 30.0
	wind_level = 20.0
	stability = 80.0
	pollution = 20.0
	satisfaction = 70.0
	score = 0
	coins = 200
	elapsed_time = 0.0
	tick_timer = 0.0
	event_timer = 0.0
	next_event_in = randf_range(EVENT_MIN_INTERVAL, EVENT_MAX_INTERVAL)
	day_cycle_timer = 0.0
	time_of_day = "morning"
	solar_modifier = 1.0
	wind_modifier = 1.0
	demand_modifier = 1.0
	active_event = {}
	# Energy supply reset
	coal_supply = 50.0
	solar_supply = 10.0
	wind_supply = 20.0
	wind_gust = randf_range(10.0, 60.0)
	wind_gust_timer = 0.0
	coal_price_min = COAL_PRICE_MIN_DEFAULT
	coal_price_max = COAL_PRICE_MAX_DEFAULT
	coal_price = randi_range(coal_price_min, coal_price_max)
	coal_price_timer = 0.0
	drought_active = false
	drought_timer = 0.0
	solar_recharge_modifier = 1.0
	wind_recharge_modifier = 1.0
	coal_consume_modifier = 1.0
	for k in upgrades:
		upgrades[k]["owned"] = false
	game_running = true
	emit_signal("meters_updated", stability, pollution, satisfaction)
	emit_signal("demand_updated", base_demand, _get_supply())
	emit_signal("energy_supply_updated", coal_supply, solar_supply, wind_supply)
	emit_signal("coal_price_updated", coal_price)

func _process(delta: float) -> void:
	if not game_running:
		return

	elapsed_time += delta
	tick_timer += delta
	event_timer += delta
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

	# ── Wind gust refresh (every 20s) ────────────────────────────────────────
	wind_gust_timer += delta
	if wind_gust_timer >= WIND_GUST_INTERVAL:
		wind_gust_timer = 0.0
		if drought_active:
			wind_gust = randf_range(0.0, 5.0)
		else:
			wind_gust = randf_range(10.0, 60.0)

	# ── Coal price refresh (every 10s) ───────────────────────────────────────
	coal_price_timer += delta
	if coal_price_timer >= COAL_PRICE_INTERVAL:
		coal_price_timer = 0.0
		coal_price = randi_range(coal_price_min, coal_price_max)
		emit_signal("coal_price_updated", coal_price)

	# ── Absolute Dryness countdown ───────────────────────────────────────────
	if drought_active:
		drought_timer -= delta
		if drought_timer <= 0.0:
			drought_active = false
			wind_gust = randf_range(10.0, 60.0) # restore normal gust

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
		"morning": d = 65.0
		"afternoon": d = 75.0
		"evening": d = 85.0
		"night": d = 55.0
	d *= demand_modifier
	# Add slight random fluctuation
	d += randf_range(-5.0, 5.0)
	return clamp(d, 10.0, 150.0)

# ─── Effective levels (binary gate — full output if stock > 0, zero if empty) ──
func _get_effective_coal_level() -> float:
	if coal_supply <= 0.0:
		return 0.0
	return coal_level

func _get_effective_solar_level() -> float:
	if solar_supply <= 0.0:
		return 0.0
	return solar_level

func _get_effective_wind_level() -> float:
	if wind_supply <= 0.0:
		return 0.0
	return wind_level

func _get_solar_tod_factor() -> float:
	var tod_factor := 1.0
	match time_of_day:
		"morning": tod_factor = 0.6
		"afternoon": tod_factor = 0.8
		"evening": tod_factor = 0.4
		"night": tod_factor = 0.0
	if bool(upgrades["better_solar"]["owned"]):
		if time_of_day == "night":
			tod_factor = -0.2
		else:
			tod_factor = clamp(tod_factor + 0.3, 0.0, 1.0)
		
	return tod_factor

func _get_solar_output() -> float:
	var base := _get_effective_solar_level() / 100.0 * MAX_SOLAR_OUTPUT
	return base * _get_solar_tod_factor() * solar_modifier

func _get_wind_output() -> float:
	var base := _get_effective_wind_level() / 100.0 * MAX_WIND_OUTPUT
	var noise := randf_range(0.7, 1.3)
	if bool(upgrades["stable_wind"]["owned"]):
		noise = randf_range(0.90, 1.2)
	return base * noise * wind_modifier

func _get_coal_output() -> float:
	return _get_effective_coal_level() / 100.0 * MAX_COAL_OUTPUT

func _get_supply() -> float:
	return _get_coal_output() + _get_solar_output() + _get_wind_output()

func _game_tick() -> void:
	# ── Energy Supply consumption & recharge ─────────────────────────────────
	_update_energy_supply()

	var demand := _get_demand()
	var supply := _get_supply()
	var coal_out := _get_coal_output()
	var gap := supply - demand # positive = surplus, negative = deficit

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
		var severity: float = abs(gap)
		if bool(upgrades["grid"]["owned"]):
			severity *= 0.6
		stability_delta = - severity * 0.25

	stability = clamp(stability + stability_delta, 0.0, 100.0)

	# ── Pollution ────────────────────────────────────────────────────────────
	var coal_ratio := coal_out / MAX_COAL_OUTPUT
	var pollution_delta := (coal_ratio * 3.5) - 1.2 # natural recovery if low coal
	pollution = clamp(pollution + pollution_delta, 0.0, 100.0)

	# ── Satisfaction ─────────────────────────────────────────────────────────
	var sat_delta := 0.0
	sat_delta += (stability - 50.0) * 0.06 # stability pulls satisfaction
	sat_delta -= (pollution - 40.0) * 0.04 # high pollution hurts satisfaction
	if gap < -10.0:
		sat_delta -= 3.0 # blackout risk hurts badly
	satisfaction = clamp(satisfaction + sat_delta, 0.0, 100.0)

	# ── Score & coins ─────────────────────────────────────────────────────────
	var tick_score := int(stability * 0.5 + satisfaction * 0.3 - pollution * 0.2)
	score += max(tick_score, 0)
	coins += 10 # passive income

	emit_signal("meters_updated", stability, pollution, satisfaction)
	emit_signal("demand_updated", demand, supply)
	emit_signal("energy_supply_updated", coal_supply, solar_supply, wind_supply)

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

# ─── Energy Supply Update ──────────────────────────────────────────────────────
func _update_energy_supply() -> void:
	# ── Consumption (proportional to slider %) ───────────────────────────────
	var coal_consume := coal_level / 100.0 * COAL_CONSUME_RATE * coal_consume_modifier
	var solar_consume: float = max(solar_level / 100.0 * SOLAR_CONSUME_RATE, 0.8)
	var wind_consume: float = max(wind_level / 100.0 * WIND_CONSUME_RATE, 0.4)

	# ── Recharge ─────────────────────────────────────────────────────────────
	# Solar: only recharges when sun is up
	var solar_tod := _get_solar_tod_factor()
	var solar_recharge := 0.0
	if solar_tod > 0.0:
		solar_recharge = SOLAR_RECHARGE_RATE * solar_tod * solar_recharge_modifier

	# Wind: based on current wind gust
	var wind_recharge := wind_gust / 100.0 * WIND_RECHARGE_RATE * wind_recharge_modifier

	# ── Apply net change ─────────────────────────────────────────────────────
	coal_supply = clamp(coal_supply - coal_consume, 0.0, 100.0)
	solar_supply = clamp(solar_supply - solar_consume + solar_recharge, 0.0, 100.0)
	wind_supply = clamp(wind_supply - wind_consume + wind_recharge, 0.0, 100.0)

# ─── Coal Market ───────────────────────────────────────────────────────────────
func buy_coal() -> bool:
	if coins < coal_price:
		return false
	coins -= coal_price
	coal_supply = clamp(coal_supply + 20.0, 0.0, 100.0)
	emit_signal("energy_supply_updated", coal_supply, solar_supply, wind_supply)
	return true

# ─── Events ────────────────────────────────────────────────────────────────────
func _trigger_random_event() -> void:
	var events := [
		{
			"id": "storm",
			"title": "⛈️ Storm Warning",
			"desc": "Heavy storm hits the city!\nSolar drops, Wind surges.\nSolar stock damaged, wind recharge boosted.",
			"solar_mod": 0.1, "wind_mod": 1.8, "demand_mod": 1.1,
			"duration": 20.0, "color": Color(0.3, 0.4, 0.8),
			"special": "storm"
		},
		{
			"id": "heatwave",
			"title": "🔥 Heatwave Alert",
			"desc": "Record temperatures!\nDemand spikes as ACs run full blast.\nWind stock drained, solar recharge boosted.",
			"solar_mod": 1.1, "wind_mod": 0.7, "demand_mod": 1.5,
			"duration": 18.0, "color": Color(0.9, 0.4, 0.1),
			"special": "heatwave"
		},
		{
			"id": "factory",
			"title": "🏭 Factory Boom",
			"desc": "New factory opens!\nIndustrial demand rises sharply.\nCoal consumption increased.",
			"solar_mod": 1.0, "wind_mod": 1.0, "demand_mod": 1.35,
			"duration": 22.0, "color": Color(0.6, 0.5, 0.3),
			"special": "factory"
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
			"desc": "Clear skies & steady breeze!\nRenewables perform at peak.\nSolar & wind recharge boosted.",
			"solar_mod": 1.3, "wind_mod": 1.25, "demand_mod": 0.9,
			"duration": 18.0, "color": Color(0.3, 0.8, 0.8),
			"special": "calm"
		},
		{
			"id": "drought",
			"title": "🏜️ Absolute Dryness",
			"desc": "Intense heat scorches the land!\nWind gust drops to near zero for 45 seconds.\nDemand rises.",
			"solar_mod": 1.2, "wind_mod": 0.3, "demand_mod": 1.3,
			"duration": 45.0, "color": Color(0.85, 0.55, 0.1),
			"special": "drought"
		},
		{
			"id": "inflation",
			"title": "📈 Inflation",
			"desc": "Market prices surge!\nCoal costs permanently increase.",
			"solar_mod": 1.0, "wind_mod": 1.0, "demand_mod": 1.0,
			"duration": 10.0, "color": Color(0.9, 0.2, 0.2),
			"special": "inflation"
		},
	]

	var ev: Dictionary = events[randi() % events.size()]
	solar_modifier = float(ev.get("solar_mod", 1.0))
	wind_modifier = float(ev.get("wind_mod", 1.0))
	demand_modifier = float(ev.get("demand_mod", 1.0))
	event_duration = float(ev.get("duration", 15.0))
	active_event = ev

	# Handle special effects on energy supply
	var special := str(ev.get("special", ""))
	match special:
		"policy":
			if pollution < 40.0:
				coins += 150
				score += 200
		"storm":
			solar_supply = clamp(solar_supply - 20.0 * DEBUFF_CONSUME_MULTIPLIER, 0.0, 100.0)
			solar_recharge_modifier = 0.2
			wind_recharge_modifier = 1.8 # strong gusts boost wind recharge
		"heatwave":
			wind_supply = clamp(wind_supply - 10.0 * DEBUFF_CONSUME_MULTIPLIER, 0.0, 100.0)
			solar_recharge_modifier = 1.5 # intense sun boosts solar recharge
		"factory":
			coal_consume_modifier = DEBUFF_CONSUME_MULTIPLIER # factory burns more coal
		"calm":
			solar_recharge_modifier = 1.4
			wind_recharge_modifier = 1.4
		"drought":
			drought_active = true
			drought_timer = 45.0
			wind_gust = randf_range(0.0, 5.0) # immediately slam gust down
		"inflation":
			coal_price_min += 10
			coal_price_max += 10
			coal_price = randi_range(coal_price_min, coal_price_max)
			emit_signal("coal_price_updated", coal_price)

	emit_signal("event_triggered", ev)

func _clear_event() -> void:
	solar_modifier = 1.0
	wind_modifier = 1.0
	demand_modifier = 1.0
	solar_recharge_modifier = 1.0
	wind_recharge_modifier = 1.0
	coal_consume_modifier = 1.0
	active_event = {}

# ─── Upgrade purchase ──────────────────────────────────────────────────────────
func try_buy_upgrade(upgrade_id: String) -> bool:
	if bool(upgrades[upgrade_id]["owned"]):
		return false
	var cost: int = int(upgrades[upgrade_id]["cost"])
	if coins < cost:
		return false
	coins -= cost
	upgrades[upgrade_id]["owned"] = true
	emit_signal("upgrade_purchased", upgrade_id)
	return true

# ─── Setters called by UI sliders ──────────────────────────────────────────────
func set_coal(val: float) -> void: coal_level = clamp(val, 0.0, 100.0)
func set_solar(val: float) -> void: solar_level = clamp(val, 0.0, 100.0)
func set_wind(val: float) -> void: wind_level = clamp(val, 0.0, 100.0)

func get_time_of_day_label() -> String:
	match time_of_day:
		"morning": return "🌅 Morning"
		"afternoon": return "☀️ Afternoon"
		"evening": return "🌆 Evening"
		"night": return "🌙 Night"
	return "—"
