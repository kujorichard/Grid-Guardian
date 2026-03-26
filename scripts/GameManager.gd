extends Node

# ─── Signals ───────────────────────────────────────────────────────────────────
signal meters_updated(stability: float, pollution: float, satisfaction: float)
signal demand_updated(demand: float, supply: float)
signal event_triggered(event: Dictionary)
signal balance_streak_updated(streak: float, tier: int)
signal contract_offers_updated(offers: Array)
signal contract_accepted(offer: Dictionary)
signal contract_expired(offer: Dictionary)
signal flash_contract_updated(offer: Dictionary, time_left: float, time_total: float)
signal flash_contract_ended(reason: String)
signal capacity_updated(coal: float, solar: float, wind: float)
signal boost_state_updated(ready: bool, cooldown: float)
signal game_over(reason: String)
signal game_won()
signal time_updated(elapsed: float, total: float)
signal upgrade_purchased(upgrade_id: String)

# ─── Constants ─────────────────────────────────────────────────────────────────
const GAME_DURATION     := 360.0   # 6 minutes to win
const TICK_INTERVAL     := 2.0     # game logic tick every 2s
const EVENT_MIN_INTERVAL := 18.0
const EVENT_MAX_INTERVAL := 26.0
const MAX_COAL_OUTPUT   := 100.0
const MAX_SOLAR_OUTPUT  := 80.0
const MAX_WIND_OUTPUT   := 60.0
const BALANCE_TOLERANCE := 6.0
const CONTRACT_REFRESH_INTERVAL := 10.0
const CONTRACT_MIN_DURATION := 10.0
const CONTRACT_MAX_DURATION := 18.0
const CONTRACT_UPFRONT_MIN := 120
const CONTRACT_UPFRONT_MAX := 240
const CONTRACT_UPKEEP_MIN := 6
const CONTRACT_UPKEEP_MAX := 14
const FLASH_MIN_INTERVAL := 16.0
const FLASH_MAX_INTERVAL := 26.0
const FLASH_WINDOW := 6.0
const CAPACITY_STEP := 6.0
const CAPACITY_COST := 160
const BOOST_DURATION := 8.0
const BOOST_COOLDOWN := 24.0
const BOOST_AMOUNT := 18.0

# ─── Capacity (MW) ────────────────────────────────────────────────────────────
var coal_capacity  : float = 40.0
var solar_capacity : float = 30.0
var wind_capacity  : float = 20.0

# ─── Upgrades ──────────────────────────────────────────────────────────────────
var upgrades := {
	"battery":      { "owned": false, "cost": 650, "label": "🔋 Battery Storage",  "desc": "Store excess energy. Stronger surplus buffer." },
	"grid":         { "owned": false, "cost": 550, "label": "🔌 Grid Upgrade",      "desc": "Absorbs demand spikes better." },
	"better_solar": { "owned": false, "cost": 500, "label": "🌞 Better Solar",       "desc": "Solar works longer into evening." },
	"stable_wind":  { "owned": false, "cost": 450, "label": "🌬️ Stable Wind",        "desc": "Wind output is more predictable." },
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

var contract_offers : Array = []
var active_contracts : Array = []
var contract_timer : float = 0.0

var flash_active : bool = false
var flash_offer : Dictionary = {}
var flash_time_left : float = 0.0
var flash_timer : float = 0.0
var next_flash_in : float = 20.0

var boost_active : bool = false
var boost_source : String = ""
var boost_time_left : float = 0.0
var boost_cooldown_left : float = 0.0

var balance_streak : float = 0.0
var balance_tier   : int = 0

var coal_plant : CoalPlant
var solar_plant : SolarPlant
var wind_plant : WindPlant

# ─── Demand curve ──────────────────────────────────────────────────────────────
var base_demand : float = 65.0

func _ready() -> void:
	randomize()
	_init_plants()

func _init_plants() -> void:
	coal_plant = load("res://scripts/CoalPlant.gd").new()
	solar_plant = load("res://scripts/SolarPlant.gd").new()
	wind_plant = load("res://scripts/WindPlant.gd").new()

func start_game() -> void:
	_init_plants()
	coal_capacity  = 40.0
	solar_capacity = 30.0
	wind_capacity  = 20.0
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
	contract_offers = []
	active_contracts = []
	contract_timer = 0.0
	flash_active = false
	flash_offer = {}
	flash_time_left = 0.0
	flash_timer = 0.0
	next_flash_in = randf_range(FLASH_MIN_INTERVAL, FLASH_MAX_INTERVAL)
	boost_active = false
	boost_source = ""
	boost_time_left = 0.0
	boost_cooldown_left = 0.0
	balance_streak = 0.0
	balance_tier = 0
	for k in upgrades:
		upgrades[k]["owned"] = false
	game_running = true
	emit_signal("meters_updated", stability, pollution, satisfaction)
	emit_signal("demand_updated", base_demand, _get_supply())
	emit_signal("capacity_updated", coal_capacity, solar_capacity, wind_capacity)
	_refresh_contract_offers()

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

	_update_plants(delta)

	# Refresh contract offers
	contract_timer += delta
	if contract_timer >= CONTRACT_REFRESH_INTERVAL:
		contract_timer = 0.0
		_refresh_contract_offers()

	# Flash contract timing
	if flash_active:
		flash_time_left = max(flash_time_left - delta, 0.0)
		emit_signal("flash_contract_updated", flash_offer, flash_time_left, FLASH_WINDOW)
		if flash_time_left <= 0.0:
			_expire_flash_contract("timeout")
	else:
		flash_timer += delta
		if flash_timer >= next_flash_in:
			flash_timer = 0.0
			next_flash_in = randf_range(FLASH_MIN_INTERVAL, FLASH_MAX_INTERVAL)
			_spawn_flash_contract()

	# Boost cooldown
	if boost_cooldown_left > 0.0:
		boost_cooldown_left = max(boost_cooldown_left - delta, 0.0)
		if boost_cooldown_left <= 0.0:
			emit_signal("boost_state_updated", true, 0.0)

	if boost_active:
		boost_time_left = max(boost_time_left - delta, 0.0)
		if boost_time_left <= 0.0:
			boost_active = false
			boost_source = ""

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
		"morning":   d = 70.0
		"afternoon": d = 80.0
		"evening":   d = 90.0
		"night":     d = 60.0
	d *= demand_modifier
	# Add slight random fluctuation
	d += randf_range(-3.0, 3.0)
	return clamp(d, 10.0, 150.0)

func _get_solar_output() -> float:
	var base := (solar_capacity + _get_contract_output("solar"))
	var tod_factor := 1.0
	match time_of_day:
		"morning":   tod_factor = 0.6
		"afternoon": tod_factor = 1.0
		"evening":   tod_factor = 0.3
		"night":     tod_factor = 0.0
	if bool(upgrades["better_solar"]["owned"]):
		tod_factor = clamp(tod_factor + 0.35, 0.0, 1.0)
	return base * tod_factor * solar_modifier * _get_plant_multiplier("solar")

func _get_wind_output() -> float:
	var base := (wind_capacity + _get_contract_output("wind"))
	var noise := randf_range(0.7, 1.3)
	if bool(upgrades["stable_wind"]["owned"]):
		noise = randf_range(0.9, 1.1)
	return base * noise * wind_modifier * _get_plant_multiplier("wind")

func _get_coal_output() -> float:
	return (coal_capacity + _get_contract_output("coal")) * _get_plant_multiplier("coal")

func _get_contract_output(source: String) -> float:
	var total := 0.0
	for c in active_contracts:
		if str(c.get("source", "")) == source:
			total += float(c.get("output", 0.0))
	if boost_active and boost_source == source:
		total += BOOST_AMOUNT
	return total

func _get_supply() -> float:
	return _get_coal_output() + _get_solar_output() + _get_wind_output()

func _game_tick() -> void:
	var demand := _get_demand()
	var supply := _get_supply()
	var coal_out  := _get_coal_output()
	var gap       := supply - demand   # positive = surplus, negative = deficit
	_process_contracts()

	# ── Stability ────────────────────────────────────────────────────────────
	var stability_delta := 0.0
	if gap >= 0.0:
		# Surplus: battery can buffer
		if bool(upgrades["battery"]["owned"]):
			stability_delta = min(gap * 0.15, 5.0)
		else:
			stability_delta = min(gap * 0.08, 2.5)
	else:
		# Deficit
		var severity : float = abs(gap)
		if bool(upgrades["grid"]["owned"]):
			severity *= 0.5
		stability_delta = -severity * 0.25

	stability = clamp(stability + stability_delta, 0.0, 100.0)

	# ── Pollution ────────────────────────────────────────────────────────────
	var coal_ratio := coal_out / MAX_COAL_OUTPUT
	var pollution_delta : float = (coal_ratio * 3.5 * coal_plant.pollution_multiplier) - 1.2   # natural recovery if low coal
	pollution = clamp(pollution + pollution_delta, 0.0, 100.0)

	# ── Satisfaction ─────────────────────────────────────────────────────────
	var sat_delta := 0.0
	sat_delta += (stability - 50.0) * 0.06   # stability pulls satisfaction
	sat_delta -= (pollution - 40.0) * 0.04   # high pollution hurts satisfaction
	if gap < -10.0:
		sat_delta -= 3.0   # blackout risk hurts badly
	satisfaction = clamp(satisfaction + sat_delta, 0.0, 100.0)

	_apply_plant_instant_effects()

	# ── Score & coins ─────────────────────────────────────────────────────────
	var tick_score := int(stability * 0.5 + satisfaction * 0.3 - pollution * 0.2)
	score += max(tick_score, 0)
	coins += 8   # passive income

	# ── Balance streak (planning + stability) ────────────────────────────────
	if abs(gap) <= BALANCE_TOLERANCE:
		balance_streak += TICK_INTERVAL
	else:
		balance_streak = 0.0

	var new_tier := 0
	if balance_streak >= 60.0:
		new_tier = 3
	elif balance_streak >= 40.0:
		new_tier = 2
	elif balance_streak >= 20.0:
		new_tier = 1

	var tier_bonus_score := 0
	var tier_bonus_coins := 0
	match new_tier:
		1:
			tier_bonus_score = 10
			tier_bonus_coins = 2
		2:
			tier_bonus_score = 20
			tier_bonus_coins = 4
		3:
			tier_bonus_score = 30
			tier_bonus_coins = 6

	score += tier_bonus_score
	coins += tier_bonus_coins

	if new_tier != balance_tier:
		balance_tier = new_tier

	emit_signal("balance_streak_updated", balance_streak, balance_tier)

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

func _update_plants(delta: float) -> void:
	coal_plant.update(delta)
	solar_plant.update(delta)
	wind_plant.update(delta)

func _get_plant_multiplier(plant_id: String) -> float:
	match plant_id:
		"coal": return coal_plant.output_multiplier
		"solar": return solar_plant.output_multiplier
		"wind": return wind_plant.output_multiplier
	return 1.0

func _apply_plant_instant_effects() -> void:
	var effects : Dictionary = coal_plant.pop_instant_effects()
	pollution = clamp(pollution + float(effects["pollution"]), 0.0, 100.0)
	satisfaction = clamp(satisfaction + float(effects["satisfaction"]), 0.0, 100.0)
	stability = clamp(stability + float(effects["stability"]), 0.0, 100.0)
	
	effects = solar_plant.pop_instant_effects()
	pollution = clamp(pollution + float(effects["pollution"]), 0.0, 100.0)
	satisfaction = clamp(satisfaction + float(effects["satisfaction"]), 0.0, 100.0)
	stability = clamp(stability + float(effects["stability"]), 0.0, 100.0)

	effects = wind_plant.pop_instant_effects()
	pollution = clamp(pollution + float(effects["pollution"]), 0.0, 100.0)
	satisfaction = clamp(satisfaction + float(effects["satisfaction"]), 0.0, 100.0)
	stability = clamp(stability + float(effects["stability"]), 0.0, 100.0)

func start_overclock(plant_id: String) -> void:
	match plant_id:
		"coal": coal_plant.start_overclock()
		"solar": solar_plant.start_overclock()
		"wind": wind_plant.start_overclock()

func stop_overclock(plant_id: String) -> void:
	match plant_id:
		"coal": coal_plant.stop_overclock()
		"solar": solar_plant.stop_overclock()
		"wind": wind_plant.stop_overclock()

func set_overclock_targets(plant_id: String, voltage: float, cooling: float) -> void:
	match plant_id:
		"coal": coal_plant.set_targets(voltage, cooling)
		"solar": solar_plant.set_targets(voltage, cooling)
		"wind": wind_plant.set_targets(voltage, cooling)

func get_plant_status(plant_id: String) -> Dictionary:
	var plant = coal_plant
	if plant_id == "solar":
		plant = solar_plant
	elif plant_id == "wind":
		plant = wind_plant
	return {
		"voltage": plant.voltage,
		"cooling": plant.cooling,
		"heat": plant.heat,
		"damage": plant.damage,
		"multiplier": plant.output_multiplier,
		"state": plant.state,
		"disabled": plant.disabled_time,
		"overclocking": plant.voltage > 0.0
	}

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

func _refresh_contract_offers() -> void:
	contract_offers = []
	contract_offers.append(_make_offer("coal"))
	contract_offers.append(_make_offer("solar"))
	contract_offers.append(_make_offer("wind"))
	emit_signal("contract_offers_updated", contract_offers)

func _make_offer(source: String) -> Dictionary:
	var output := randf_range(12.0, 28.0)
	var duration := randf_range(CONTRACT_MIN_DURATION, CONTRACT_MAX_DURATION)
	var upfront := randi_range(CONTRACT_UPFRONT_MIN, CONTRACT_UPFRONT_MAX)
	var upkeep := randi_range(CONTRACT_UPKEEP_MIN, CONTRACT_UPKEEP_MAX)
	var price_mult := _contract_price_multiplier(source)
	return {
		"id": str(source, "_", Time.get_ticks_msec()),
		"source": source,
		"output": output,
		"duration": duration,
		"upfront": int(round(upfront * price_mult)),
		"upkeep": int(round(upkeep * price_mult)),
		"risk_pollution": 1.5 if source == "coal" else 0.3,
		"risk_stability": -0.8 if source == "wind" else -0.4
	}

func _make_flash_offer() -> Dictionary:
	var source = ["coal", "solar", "wind"][randi() % 3]
	var output := randf_range(18.0, 34.0)
	var duration := randf_range(10.0, 16.0)
	var upfront := randi_range(CONTRACT_UPFRONT_MIN, CONTRACT_UPFRONT_MAX)
	var upkeep := randi_range(CONTRACT_UPKEEP_MIN, CONTRACT_UPKEEP_MAX)
	var price_mult := _contract_price_multiplier(source)
	return {
		"id": str("flash_", source, "_", Time.get_ticks_msec()),
		"source": source,
		"output": output,
		"duration": duration,
		"upfront": int(round(upfront * 0.85 * price_mult)),
		"upkeep": int(round(upkeep * 1.4 * price_mult)),
		"risk_pollution": 2.0 if source == "coal" else 0.5,
		"risk_stability": -1.2 if source == "wind" else -0.6,
		"flash": true
	}

func _contract_price_multiplier(source: String) -> float:
	if active_event.size() == 0:
		return 1.0
	var id := str(active_event.get("id", ""))
	match id:
		"storm":
			return 1.25 if source == "solar" else (0.85 if source == "wind" else 1.05)
		"heatwave":
			return 1.2 if source != "wind" else 1.05
		"factory":
			return 1.25 if source == "coal" else 1.1
		"policy":
			return 0.8 if source != "coal" else 1.1
		"calm":
			return 0.85 if source != "coal" else 1.0
	return 1.0

func accept_contract(offer_id: String) -> bool:
	for i in range(contract_offers.size()):
		var offer : Dictionary = contract_offers[i]
		if str(offer.get("id", "")) == offer_id:
			var cost := int(offer.get("upfront", 0))
			if coins < cost:
				return false
			coins -= cost
			var active := offer.duplicate(true)
			active["remaining"] = float(offer.get("duration", 0.0))
			active_contracts.append(active)
			contract_offers.remove_at(i)
			emit_signal("contract_accepted", active)
			emit_signal("contract_offers_updated", contract_offers)
			return true
	return false

func accept_flash_contract() -> bool:
	if not flash_active or flash_time_left <= 0.0:
		return false
	var cost := int(flash_offer.get("upfront", 0))
	if coins < cost:
		return false
	coins -= cost
	var active := flash_offer.duplicate(true)
	active["remaining"] = float(flash_offer.get("duration", 0.0))
	active_contracts.append(active)
	coins += 40
	score += 80
	stability = clamp(stability + 3.0, 0.0, 100.0)
	flash_active = false
	flash_offer = {}
	flash_time_left = 0.0
	emit_signal("flash_contract_ended", "accepted")
	return true

func _spawn_flash_contract() -> void:
	flash_offer = _make_flash_offer()
	flash_time_left = FLASH_WINDOW
	flash_active = true
	emit_signal("flash_contract_updated", flash_offer, flash_time_left, FLASH_WINDOW)

func _expire_flash_contract(reason: String) -> void:
	flash_active = false
	flash_offer = {}
	flash_time_left = 0.0
	stability = clamp(stability - 4.0, 0.0, 100.0)
	satisfaction = clamp(satisfaction - 3.0, 0.0, 100.0)
	pollution = clamp(pollution + 2.0, 0.0, 100.0)
	emit_signal("meters_updated", stability, pollution, satisfaction)
	emit_signal("flash_contract_ended", reason)

func _process_contracts() -> void:
	var to_remove : Array = []
	for c in active_contracts:
		var upkeep := int(c.get("upkeep", 0))
		if coins >= upkeep:
			coins -= upkeep
			pollution = clamp(pollution + float(c.get("risk_pollution", 0.0)), 0.0, 100.0)
			stability = clamp(stability + float(c.get("risk_stability", 0.0)), 0.0, 100.0)
		else:
			stability = clamp(stability - 3.0, 0.0, 100.0)
			to_remove.append(c)
			continue
		c["remaining"] = float(c.get("remaining", 0.0)) - TICK_INTERVAL
		if float(c.get("remaining", 0.0)) <= 0.0:
			to_remove.append(c)

	for c in to_remove:
		active_contracts.erase(c)
		emit_signal("contract_expired", c)

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

# ─── Economy actions ──────────────────────────────────────────────────────────
func buy_capacity(source: String) -> bool:
	var cost := CAPACITY_COST
	if coins < cost:
		return false
	coins -= cost
	match source:
		"coal":  coal_capacity  = clamp(coal_capacity + CAPACITY_STEP, 0.0, MAX_COAL_OUTPUT)
		"solar": solar_capacity = clamp(solar_capacity + CAPACITY_STEP, 0.0, MAX_SOLAR_OUTPUT)
		"wind":  wind_capacity  = clamp(wind_capacity + CAPACITY_STEP, 0.0, MAX_WIND_OUTPUT)
		_:
			return false
	emit_signal("capacity_updated", coal_capacity, solar_capacity, wind_capacity)
	return true

func activate_boost(source: String) -> bool:
	if boost_cooldown_left > 0.0 or boost_active:
		return false
	boost_active = true
	boost_source = source
	boost_time_left = BOOST_DURATION
	boost_cooldown_left = BOOST_COOLDOWN
	emit_signal("boost_state_updated", false, boost_cooldown_left)
	return true

func get_time_of_day_label() -> String:
	match time_of_day:
		"morning":   return "🌅 Morning"
		"afternoon": return "☀️ Afternoon"
		"evening":   return "🌆 Evening"
		"night":     return "🌙 Night"
	return "—"
