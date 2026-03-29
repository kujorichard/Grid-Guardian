extends Control

# ─── Node references ──────────────────────────────────────────────────────────
@onready var screen_menu    : Control = $Screens/MenuScreen
@onready var screen_game    : Control = $Screens/GameScreen
@onready var screen_gameover: Control = $Screens/GameOverScreen
@onready var screen_win     : Control = $Screens/WinScreen

@onready var background      : ColorRect   = $Background
@onready var menu_background : TextureRect = $Background/MenuBackground
@onready var game_over_background : TextureRect = $Background/GameOverBackground

# GameScreen children
@onready var lbl_time_of_day  : Label        = %LblTimeOfDay
@onready var lbl_timer        : Label        = %LblTimer
@onready var lbl_score        : Label        = %LblScore
@onready var lbl_coins        : Label        = %LblCoins
@onready var lbl_streak       : Label        = %LblStreak

# Meters
@onready var bar_stability    : ProgressBar  = %StabilityBar
@onready var bar_pollution    : ProgressBar  = %PollutionBar
@onready var bar_satisfaction : ProgressBar  = %SatisfactionBar
@onready var lbl_stab_title   : Label        = %LblStabTitle
@onready var lbl_poll_title   : Label        = %LblPollTitle
@onready var lbl_sat_title    : Label        = %LblSatTitle
@onready var lbl_stab_val     : Label        = %LblStabVal
@onready var lbl_poll_val     : Label        = %LblPollVal
@onready var lbl_sat_val      : Label        = %LblSatVal

# Contracts
@onready var lbl_contract_coal  : Label   = %LblCoalOffer
@onready var lbl_contract_solar : Label   = %LblSolarOffer
@onready var lbl_contract_wind  : Label   = %LblWindOffer
@onready var btn_contract_coal  : Button  = %BtnAcceptCoalContract
@onready var btn_contract_solar : Button  = %BtnAcceptSolarContract
@onready var btn_contract_wind  : Button  = %BtnAcceptWindContract

# Show contracts popup
@onready var popup_contracts : PopupPanel = %ContractsPopup
@onready var opt_contract_plant : OptionButton = %OptContractPlant
@onready var lbl_contracts_list : Label = %LblContracts
@onready var lbl_contracts_total : Label = %LblTotals

# Capacity
@onready var lbl_cap_coal   : Label = %LblCapCoal
@onready var lbl_cap_solar  : Label = %LblCapSolar
@onready var lbl_cap_wind   : Label = %LblCapWind
@onready var btn_cap_coal   : Button = %BtnBuyCoalCap
@onready var btn_cap_solar  : Button = %BtnBuySolarCap
@onready var btn_cap_wind   : Button = %BtnBuyWindCap

# Emergency boost
@onready var lbl_boost_status : Label = %LblStatus
@onready var btn_boost_coal   : Button = %BtnBoostCoal
@onready var btn_boost_solar  : Button = %BtnBoostSolar
@onready var btn_boost_wind   : Button = %BtnBoostWind

# Supply/demand
@onready var lbl_demand       : Label        = %LblDemand
@onready var lbl_supply       : Label        = %LblSupply
@onready var lbl_balance      : Label        = %LblBalance
@onready var bar_balance      : ProgressBar  = %BalanceBar
@onready var lbl_event_status : Label        = get_node_or_null("%LblEventStatus")

# Energy supply meters
@onready var bar_coal_supply   : ProgressBar  = %CoalSupplyBar
@onready var bar_solar_supply  : ProgressBar  = %SolarSupplyBar
@onready var bar_wind_supply   : ProgressBar  = %WindSupplyBar
@onready var lbl_coal_sup_val  : Label        = %LblCoalSupVal
@onready var lbl_solar_sup_val : Label        = %LblSolarSupVal
@onready var lbl_wind_sup_val  : Label        = %LblWindSupVal
@onready var btn_buy_coal      : Button       = %BtnBuyCoal
@onready var lbl_oc_warning    : Label        = %LblOCWarning

# Event panel
@onready var panel_event      : PanelContainer = %EventOverlay
@onready var lbl_event_title  : Label          = %LblEventTitle
@onready var lbl_event_desc   : Label          = %LblEventDesc
@onready var timer_event_hide : Timer          = %HideTimer
@onready var event_panel      : PanelContainer = %EventOverlay

# Flash contract panel
@onready var panel_flash      : PanelContainer = %FlashPanel
@onready var lbl_flash_title  : Label          = %LblFlashTitle
@onready var lbl_flash_desc   : Label          = %LblFlashDesc
@onready var bar_flash_timer  : ProgressBar    = %FlashTimerBar
@onready var btn_flash_accept : Button         = %BtnFlashAccept

# Overclock popup
@onready var btn_overclock_open : Button = %BtnOverclock
@onready var popup_overclock : PopupPanel = %OverclockPopup
@onready var opt_oc_plant : OptionButton = %OptOcPlant
@onready var slider_oc_voltage : HSlider = %VoltageSlider
@onready var slider_oc_cooling : HSlider = %CoolingSlider
@onready var lbl_oc_voltage : Label = %LblVoltageVal
@onready var lbl_oc_cooling : Label = %LblCoolingVal
@onready var bar_oc_heat : ProgressBar = %HeatBar
@onready var bar_oc_damage : ProgressBar = %DamageBar
@onready var lbl_oc_state : Label = %LblState
@onready var lbl_oc_mult : Label = %LblMult
@onready var btn_oc_safe : Button = %BtnSafe
@onready var btn_oc_close : Button = %BtnOcClose

# Upgrade buttons
@onready var btn_battery      : Button = %BtnBatteryUpgrade
@onready var btn_grid         : Button = %BtnGridUpgrade
@onready var btn_better_solar : Button = %BtnBetterSolarUpgrade
@onready var btn_stable_wind  : Button = %BtnStableWindUpgrade

# City skyline
@onready var city_overlay     : Control = %CityOverlay
@onready var lbl_blackout     : Label   = %LblBlackout
@onready var ticker_label     : RichTextLabel = %TickerLabel

# Game over / win
@onready var lbl_go_reason    : Label = %LblReason
@onready var lbl_go_score     : Label = %LblGOScore
@onready var lbl_win_score    : Label = %LblWinScore

# ─── SFX Objects ──────────────────────────────────────────────────────────────
@onready var accept_contract_sfx = %AcceptContract
@onready var blackout_warning_sfx = %BlackoutWarning
@onready var buy_coal_sfx = %BuyCoal
@onready var flash_contract_appear_sfx = %FlashContractAppear
@onready var flash_contract_expire_sfx = %FlashContractExpire
@onready var game_over_sfx = %GameOver
@onready var game_won_sfx = %GameWon
@onready var random_event_sfx = %RandomEvent
@onready var boost_coal_sfx = %BoostCoal
@onready var boost_solar_sfx = %BoostSolar
@onready var boost_wind_sfx = %BoostWind
@onready var upgrade_purchase_sfx = %UpgradePurchase
@onready var start_overclock_sfx = %StartOverclock
@onready var bgm_players = [
	%BGM1,
	%BGM2,
	%BGM3
]

# Map Display
@onready var map : Node2D = %Map

var GM : Node
var contract_offers_by_source : Dictionary = {}
var current_overclock_plant : String = "coal"
var current_contract_view_plant : String = "coal"
var last_stability : float = -1.0
var last_pollution : float = -1.0
var last_satisfaction : float = -1.0
var event_border_tween : Tween
var event_border_base_color : Color = Color(0.35, 0.42, 0.5, 1)
var event_history : Array[String] = []
var ticker_scroll_speed : float = 120.0

func _ready() -> void:
	GM = get_node("/root/GameManager")
	GM.meters_updated.connect(_on_meters_updated)
	GM.demand_updated.connect(_on_demand_updated)
	GM.event_triggered.connect(_on_event_triggered)
	GM.balance_streak_updated.connect(_on_balance_streak_updated)
	GM.contract_offers_updated.connect(_on_contract_offers_updated)
	GM.contract_accepted.connect(_on_contract_accepted)
	GM.contract_expired.connect(_on_contract_expired)
	GM.flash_contract_updated.connect(_on_flash_contract_updated)
	GM.flash_contract_ended.connect(_on_flash_contract_ended)
	GM.capacity_updated.connect(_on_capacity_updated)
	GM.boost_state_updated.connect(_on_boost_state_updated)
	GM.game_over.connect(_on_game_over)
	GM.game_won.connect(_on_game_won)
	GM.time_updated.connect(_on_time_updated)
	GM.upgrade_purchased.connect(_on_upgrade_purchased)
	GM.energy_supply_updated.connect(_on_energy_supply_updated)
	GM.coal_price_updated.connect(_on_coal_price_updated)

	_show_screen("menu")
	_safe_hide(panel_event)
	_safe_hide(panel_flash)
	_safe_hide(popup_overclock)
	_safe_hide(popup_contracts)
	_opt_init_overclock()
	_opt_init_contracts()
	_cache_event_border_color()
	
	if ticker_label != null:
		ticker_label.autowrap_mode = TextServer.AUTOWRAP_OFF
		ticker_label.fit_content = true

func _process(delta: float) -> void:
	if screen_game.visible:
		if popup_overclock.visible:
			_update_overclock_popup()
		if popup_contracts.visible:
			_refresh_show_contracts_popup()
		_update_event_status()
		_update_overclock_warning()
		_update_contract_displays()
		_process_ticker_scroll(delta)

func _process_ticker_scroll(delta: float) -> void:
	if ticker_label == null or ticker_label.text == "": return
	
	# Move text to the left
	ticker_label.position.x -= ticker_scroll_speed * delta
	
	# Get the actual width of the text content
	var text_width = ticker_label.get_content_width()
	
	# If the label has fully scrolled off to the left (with some padding), reset it
	if ticker_label.position.x < -(text_width + 50):
		ticker_label.position.x = ticker_label.get_parent().size.x

# ─── Screen management ────────────────────────────────────────────────────────
func _show_screen(name: String) -> void:
	screen_menu.visible     = (name == "menu")
	screen_game.visible     = (name == "game")
	screen_gameover.visible = (name == "gameover")
	screen_win.visible      = (name == "win")
	menu_background.visible = (name == "menu")
	game_over_background.visible = (name == "gameover")
	background.visible = true

# ─── Menu buttons ─────────────────────────────────────────────────────────────
func _on_btn_play_pressed() -> void:
	GM.start_game()
	_init_game_ui()
	_show_screen("game")

func _on_btn_restart_pressed() -> void:
	GM.start_game()
	_init_game_ui()
	_show_screen("game")

func _init_game_ui() -> void:
	_safe_hide(lbl_blackout)
	lbl_streak.text = "Streak: 0s"
	_refresh_capacity_labels(GM.coal_capacity, GM.solar_capacity, GM.wind_capacity)
	_refresh_contract_labels()
	_refresh_upgrade_buttons()
	_update_buy_coal_button(GM.coal_price)
	_on_energy_supply_updated(GM.coal_supply, GM.solar_supply, GM.wind_supply)
	_safe_hide(panel_flash)
	_safe_hide(popup_overclock)
	_safe_hide(popup_contracts)
	_safe_hide(panel_event)
	_safe_hide(lbl_event_status)
	_safe_hide(lbl_oc_warning)
	_play_random_bgm()
	_on_boost_state_updated(true, 0.0)

# ─── Signal handlers ──────────────────────────────────────────────────────────
func _on_meters_updated(stab: float, poll: float, sat: float) -> void:
	if last_stability >= 0.0 and _crossed_threshold(last_stability, stab):
		_pulse_meter(bar_stability, lbl_stab_val, lbl_stab_title, Color(0.6, 0.9, 1.0))
	if last_pollution >= 0.0 and _crossed_threshold(last_pollution, poll):
		_pulse_meter(bar_pollution, lbl_poll_val, lbl_poll_title, Color(0.9, 0.5, 0.3))
	if last_satisfaction >= 0.0 and _crossed_threshold(last_satisfaction, sat):
		_pulse_meter(bar_satisfaction, lbl_sat_val, lbl_sat_title, Color(0.6, 1.0, 0.7))

	last_stability = stab
	last_pollution = poll
	last_satisfaction = sat

	_set_bar(bar_stability,    lbl_stab_val,  stab, Color(0.2, 0.7, 1.0),  Color(1.0, 0.3, 0.2))
	_set_bar(bar_pollution,    lbl_poll_val,  poll, Color(0.3, 0.8, 0.3),  Color(0.9, 0.2, 0.1), true)
	_set_bar(bar_satisfaction, lbl_sat_val,   sat,  Color(0.3, 0.9, 0.5),  Color(1.0, 0.4, 0.1))

	lbl_score.text = "Score: %d" % GM.score
	lbl_coins.text = "Coins: %d" % GM.coins
	lbl_time_of_day.text = GM.get_time_of_day_label()

	# Blackout warning
	if stab < 20.0:
		lbl_blackout.show()
		blackout_warning_sfx.play()
		lbl_blackout.text = "BLACKOUT RISK!"
	else:
		_safe_hide(lbl_blackout)

	map.update_city(GM.coal_supply, GM.solar_supply, GM.wind_supply, GM.pollution)
	_refresh_contract_buttons()
	_refresh_capacity_buttons()

	_refresh_upgrade_buttons()

func _on_demand_updated(demand: float, supply: float) -> void:
	lbl_demand.text = "%.0f MW" % demand
	lbl_supply.text = "%.0f MW" % supply
	var balance := supply - demand
	
	# Update Balance Text
	if balance >= 0:
		lbl_balance.text = "+%.0f MW surplus" % balance
		lbl_balance.add_theme_color_override("font_color", Color(0.3, 0.9, 0.5))
	else:
		lbl_balance.text = "%.0f MW deficit" % balance
		lbl_balance.add_theme_color_override("font_color", Color(1.0, 0.3, 0.2))
	
	# Update Balance Gauge (50 is center/perfect balance)
	# +/- 50MW covers the bar range roughly for quick visual
	var gauge_val := 50.0 + (balance / 2.0) 
	bar_balance.value = clamp(gauge_val, 0, 100)
	
	# Visual feedback: pulse the bar if in deficit
	if balance < 0:
		_pulse_control(bar_balance, Color(1.0, 0.3, 0.2))

func _on_event_triggered(ev: Dictionary) -> void:
	if lbl_event_title == null or lbl_event_desc == null:
		return
	random_event_sfx.play()
	var title = ev.get("title", "Event")
	lbl_event_title.text = title
	lbl_event_desc.text  = ev.get("desc",  "")

	# Add to ticker history
	var time_str = "[color=#888888][%s][/color] " % GM.get_time_of_day_label()
	var clean_desc = ev.get("desc", "").replace("\n", " ")
	event_history.push_front(time_str + "[color=#ffaa00]" + title.to_upper() + ":[/color] " + clean_desc)
	if event_history.size() > 5:
		event_history.pop_back()
	_update_ticker_display()

	_start_event_border_pulse(ev.get("color", Color(1.0, 0.8, 0.3)))
	if panel_event != null:
		panel_event.show()
	if timer_event_hide != null:
		timer_event_hide.start(3.0)

func _update_ticker_display() -> void:
	var full_text = "  •  ".join(event_history)
	ticker_label.text = full_text


# Updates the event status line (name + timer) near supply/demand
func _update_event_status() -> void:
	if lbl_event_status == null:
		return
	if GM.active_event_id != "" and GM.event_time_remaining > 0:
		lbl_event_status.text = "%s: %.0fs" % [GM.active_event_id.capitalize(), GM.event_time_remaining]
		lbl_event_status.show()
	else:
		_safe_hide(lbl_event_status)

# Shows warning when any overclocked plant is at critical level
func _update_overclock_warning() -> void:
	if lbl_oc_warning == null:
		return
	var warnings : Array[String] = []
	for source in ["coal", "solar", "wind"]:
		var state : Dictionary = GM.overclock_states.get(source, {})
		var voltage : float = state.get("voltage", 0.0)
		var heat : float = state.get("heat", 0.0)
		var plant_state : String = str(state.get("state", "safe"))
		
		# Show warnings for all non-safe states
		if plant_state == "disabled":
			warnings.append("%s OFFLINE (%.0fs)" % [source.capitalize(), state.get("disabled", 0.0)])
		elif voltage > 0.0:  # Only show if actively overclocking
			if plant_state == "failing":
				warnings.append("%s FAILING (%.0fC)" % [source.capitalize(), heat])
			elif plant_state == "critical":
				warnings.append("%s CRITICAL (%.0fC)" % [source.capitalize(), heat])
			elif plant_state == "warning":
				warnings.append("%s Warning (%.0fC)" % [source.capitalize(), heat])
	
	if warnings.size() > 0:
		lbl_oc_warning.text = " | ".join(warnings)
		lbl_oc_warning.add_theme_color_override("font_color", Color(1.0, 0.3, 0.2))
		lbl_oc_warning.show()
	else:
		_safe_hide(lbl_oc_warning)

# Updates contract labels to show active contracts with time remaining
func _update_contract_displays() -> void:
	_refresh_contract_labels()
	_refresh_contract_buttons()

func _on_flash_contract_updated(offer: Dictionary, time_left: float, time_total: float) -> void:
	var source := str(offer.get("source", "")).capitalize()
	var out := float(offer.get("output", 0.0))
	var dur := float(offer.get("duration", 0.0))
	var upfront := int(offer.get("upfront", 0))
	var upkeep := int(offer.get("upkeep", 0))
	lbl_flash_title.text = "Flash Contract"
	lbl_flash_desc.text = "%s +%.0f MW | %.0fs | Upfront %d | Upkeep %d" % [source, out, dur, upfront, upkeep]
	bar_flash_timer.value = (time_left / max(time_total, 0.1)) * 100.0
	btn_flash_accept.disabled = GM.coins < upfront
	if not panel_flash.visible:
		panel_flash.show()
		flash_contract_appear_sfx.play()

func _on_flash_contract_ended(_reason: String) -> void:
	flash_contract_expire_sfx.play()
	_safe_hide(panel_flash)

func _on_time_updated(elapsed: float, total: float) -> void:
	var remaining := total - elapsed
	var mins := int(remaining) / 60
	var secs := int(remaining) % 60
	lbl_timer.text = "%d:%02d" % [mins, secs]

func _on_game_over(reason: String) -> void:
	var msg := ""
	match reason:
		"blackout":    msg = "Total Blackout!\nThe city went dark."
		"pollution":   msg = "Pollution Crisis!\nThe city choked on smog."
		"satisfaction":msg = "Public Revolt!\nCitizens lost all faith."
	lbl_go_reason.text = msg
	lbl_go_score.text  = "Final Score: %d" % GM.score
	_stop_all_bgm()
	game_over_sfx.play()
	_show_screen("gameover")

func _on_game_won() -> void:
	lbl_win_score.text = "Final Score: %d" % GM.score
	_stop_all_bgm()
	game_won_sfx.play()
	_show_screen("win")

func _on_upgrade_purchased(_id: String) -> void:
	_refresh_upgrade_buttons()

func _on_hide_timer_timeout() -> void:
	_safe_hide(panel_event)
	_stop_event_border_pulse()

func _on_energy_supply_updated(coal_sup: float, solar_sup: float, wind_sup: float) -> void:
	_set_bar(bar_coal_supply,  lbl_coal_sup_val,  coal_sup, Color(0.8, 0.6, 0.3), Color(0.4, 0.2, 0.1))
	_set_bar(bar_solar_supply, lbl_solar_sup_val, solar_sup, Color(1.0, 0.9, 0.2), Color(0.5, 0.3, 0.1))
	_set_bar(bar_wind_supply,  lbl_wind_sup_val,  wind_sup,  Color(0.4, 0.8, 1.0), Color(0.2, 0.3, 0.5))
	_update_buy_coal_button(GM.coal_price)

func _on_coal_price_updated(price: int) -> void:
	_update_buy_coal_button(price)

func _on_btn_buy_coal_pressed() -> void:
	buy_coal_sfx.play()
	GM.buy_coal()

func _update_buy_coal_button(price: int) -> void:
	btn_buy_coal.text = "Buy Coal (+20%%)\nCost: %d" % price
	btn_buy_coal.disabled = GM.coins < price or GM.coal_supply >= 100.0

func _on_balance_streak_updated(streak: float, tier: int) -> void:
	var tier_label := ""
	match tier:
		1: tier_label = " Bronze"
		2: tier_label = " Silver"
		3: tier_label = " Gold"
		_: tier_label = ""
	lbl_streak.text = "Streak: %ds%s" % [int(streak), tier_label]

func _on_contract_offers_updated(offers: Array) -> void:
	contract_offers_by_source.clear()
	for offer in offers:
		contract_offers_by_source[str(offer.get("source", ""))] = offer
	_refresh_contract_labels()
	_refresh_contract_buttons()

func _on_contract_accepted(_offer: Dictionary) -> void:
	_refresh_contract_buttons()
	if popup_contracts.visible:
		_refresh_show_contracts_popup()

func _on_contract_expired(_offer: Dictionary) -> void:
	_refresh_contract_buttons()
	if popup_contracts.visible:
		_refresh_show_contracts_popup()

func _on_capacity_updated(coal: float, solar: float, wind: float) -> void:
	_refresh_capacity_labels(coal, solar, wind)

func _on_boost_state_updated(ready: bool, _cooldown: float) -> void:
	if ready:
		lbl_boost_status.text = "Boost ready"
	else:
		lbl_boost_status.text = "Boost on cooldown"
	btn_boost_coal.disabled = not ready
	btn_boost_solar.disabled = not ready
	btn_boost_wind.disabled = not ready

# ─── Upgrade button handlers ──────────────────────────────────────────────────
func _on_btn_battery_pressed() -> void:
	if GM.try_buy_upgrade("battery"):
		upgrade_purchase_sfx.play()

func _on_btn_grid_pressed() -> void:
	if GM.try_buy_upgrade("grid"):
		upgrade_purchase_sfx.play()

func _on_btn_better_solar_pressed() -> void:
	if GM.try_buy_upgrade("better_solar"):
		upgrade_purchase_sfx.play()

func _on_btn_stable_wind_pressed() -> void:
	if GM.try_buy_upgrade("stable_wind"):
		upgrade_purchase_sfx.play()

func _refresh_upgrade_buttons() -> void:
	_set_upgrade_btn(btn_battery,      "battery")
	_set_upgrade_btn(btn_grid,         "grid")
	_set_upgrade_btn(btn_better_solar, "better_solar")
	_set_upgrade_btn(btn_stable_wind,  "stable_wind")

# ─── Contracts & economy UI ─────────────────────────────────────────────────-
func _on_btn_accept_coal_pressed() -> void: _try_accept_contract("coal")
func _on_btn_accept_solar_pressed() -> void: _try_accept_contract("solar")
func _on_btn_accept_wind_pressed() -> void: _try_accept_contract("wind")

func _try_accept_contract(source: String) -> void:
	if not contract_offers_by_source.has(source):
		return
	var offer : Dictionary = contract_offers_by_source[source]
	accept_contract_sfx.play()
	GM.accept_contract(str(offer.get("id", "")))

func _on_btn_buy_cap_coal_pressed() -> void: GM.buy_capacity("coal")
func _on_btn_buy_cap_solar_pressed() -> void: GM.buy_capacity("solar")
func _on_btn_buy_cap_wind_pressed() -> void: GM.buy_capacity("wind")

func _on_btn_boost_coal_pressed() -> void:
	GM.activate_boost("coal")
	boost_coal_sfx.play()

func _on_btn_boost_solar_pressed() -> void:
	GM.activate_boost("solar")
	boost_solar_sfx.play()

func _on_btn_boost_wind_pressed() -> void:
	GM.activate_boost("wind")
	boost_wind_sfx.play()

func _on_btn_flash_accept_pressed() -> void:
	GM.accept_flash_contract()

func _on_contract_plant_selected(index: int) -> void:
	var meta = opt_contract_plant.get_item_metadata(index)
	if meta != null:
		current_contract_view_plant = str(meta)
	_refresh_show_contracts_popup()

func _on_contracts_close_pressed() -> void:
	_safe_hide(popup_contracts)

func _on_btn_overclock_pressed() -> void:
	popup_overclock.popup_centered()
	start_overclock_sfx.play()
	_sync_overclock_popup_from_status()

func _on_overclock_coal_down() -> void:
	GM.start_overclock("coal")

func _on_overclock_coal_up() -> void:
	GM.stop_overclock("coal")

func _on_overclock_solar_down() -> void:
	GM.start_overclock("solar")

func _on_overclock_solar_up() -> void:
	GM.stop_overclock("solar")

func _on_overclock_wind_down() -> void:
	GM.start_overclock("wind")

func _on_overclock_wind_up() -> void:
	GM.stop_overclock("wind")

func _on_oc_plant_selected(index: int) -> void:
	var meta = opt_oc_plant.get_item_metadata(index)
	if meta != null:
		current_overclock_plant = str(meta)
	_sync_overclock_popup_from_status()

func _on_oc_voltage_changed(value: float) -> void:
	GM.set_overclock_targets(current_overclock_plant, value, slider_oc_cooling.value)
	_update_overclock_popup_labels()

func _on_oc_cooling_changed(value: float) -> void:
	GM.set_overclock_targets(current_overclock_plant, slider_oc_voltage.value, value)
	_update_overclock_popup_labels()

func _on_oc_safe_pressed() -> void:
	slider_oc_voltage.value = 0.0
	slider_oc_cooling.value = 1.0
	GM.set_overclock_targets(current_overclock_plant, 0.0, 1.0)
	_update_overclock_popup_labels()

func _on_oc_close_pressed() -> void:
	_safe_hide(popup_overclock)

func _on_overclock_popup_hide() -> void:
	pass # Don't reset overclock settings when menu closes

func _set_upgrade_btn(btn: Button, id: String) -> void:
	var u     : Dictionary = GM.upgrades[id]
	var owned : bool       = bool(u["owned"])
	var cost  : int        = int(u["cost"])
	var label : String     = str(u["label"])
	if owned:
		btn.text     = label + " (Owned)"
		btn.disabled = true
	else:
		btn.text     = "%s\nCost: %d" % [label, cost]
		btn.disabled = GM.coins < cost

func _safe_hide(node: Variant) -> void:
	if node != null and is_instance_valid(node) and node.has_method("hide"):
		node.hide()

func _cache_event_border_color() -> void:
	if event_panel == null:
		return
	var style := event_panel.get_theme_stylebox("panel")
	if style is StyleBoxFlat:
		event_border_base_color = (style as StyleBoxFlat).border_color

func _start_event_border_pulse(event_color: Color) -> void:
	if event_panel == null:
		return
	if event_border_tween != null:
		event_border_tween.kill()
		event_border_tween = null
	var style := event_panel.get_theme_stylebox("panel")
	if not (style is StyleBoxFlat):
		return
	var style_box := (style as StyleBoxFlat).duplicate() as StyleBoxFlat
	style_box.border_color = event_border_base_color
	event_panel.add_theme_stylebox_override("panel", style_box)
	var pulse_color := event_border_base_color.lerp(event_color, 0.6)
	event_border_tween = create_tween()
	event_border_tween.set_loops()
	event_border_tween.tween_property(style_box, "border_color", pulse_color, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	event_border_tween.tween_property(style_box, "border_color", event_border_base_color, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _stop_event_border_pulse() -> void:
	if event_border_tween != null:
		event_border_tween.kill()
		event_border_tween = null
	if event_panel != null:
		var style := event_panel.get_theme_stylebox("panel")
		if style is StyleBoxFlat:
			(style as StyleBoxFlat).border_color = event_border_base_color

func _crossed_threshold(prev: float, cur: float) -> bool:
	return (prev >= 20.0 and cur < 20.0) or (prev <= 80.0 and cur > 80.0)

func _pulse_meter(bar: Control, val: Control, title: Control, glow: Color) -> void:
	_pulse_control(bar, glow)
	_pulse_control(val, glow)
	_pulse_control(title, glow)

func _pulse_control(ctrl: Control, glow: Color) -> void:
	var base_scale := ctrl.scale
	var base_mod := ctrl.self_modulate
	var tween := create_tween()
	tween.tween_property(ctrl, "scale", base_scale * 1.03, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(ctrl, "self_modulate", base_mod.lerp(glow, 0.35), 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(ctrl, "scale", base_scale, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(ctrl, "self_modulate", base_mod, 0.18).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

# ─── Helpers ──────────────────────────────────────────────────────────────────
func _set_bar(bar: ProgressBar, lbl: Label, val: float,
			  good_color: Color, bad_color: Color, invert: bool = false) -> void:
	bar.value = val
	lbl.text  = "%.0f%%" % val
	var t     := val / 100.0
	if invert:
		t = 1.0 - t
	bar.add_theme_color_override("fill_color",       good_color.lerp(bad_color, 1.0 - t))
	bar.add_theme_color_override("fill_color_hover", good_color.lerp(bad_color, 1.0 - t))

func _refresh_contract_labels() -> void:
	_set_contract_label(lbl_contract_coal, "coal", contract_offers_by_source.get("coal", {}))
	_set_contract_label(lbl_contract_solar, "solar", contract_offers_by_source.get("solar", {}))
	_set_contract_label(lbl_contract_wind, "wind", contract_offers_by_source.get("wind", {}))

func _refresh_contract_buttons() -> void:
	_set_contract_btn(btn_contract_coal, "coal", contract_offers_by_source.get("coal", {}))
	_set_contract_btn(btn_contract_solar, "solar", contract_offers_by_source.get("solar", {}))
	_set_contract_btn(btn_contract_wind, "wind", contract_offers_by_source.get("wind", {}))

func _set_contract_label(lbl: Label, source: String, offer: Dictionary) -> void:
	# Check if there's an active contract for this source
	var active : Array = GM.get_active_contracts_for_source(source)
	if active.size() > 0:
		# Show active contract status
		var c : Dictionary = active[0]
		var out := float(c.get("output", 0.0))
		var remaining := maxf(float(c.get("remaining", 0.0)), 0.0)
		var upkeep := int(c.get("upkeep", 0))
		lbl.text = "Active +%.0f MW | %.0fs left | Upkeep %d" % [out, remaining, upkeep]
		lbl.add_theme_color_override("font_color", Color(0.3, 0.9, 0.4))
		return
	
	# No active contract - show offer
	lbl.remove_theme_color_override("font_color")
	if offer.size() == 0:
		lbl.text = "No offer"
		return
	var out := float(offer.get("output", 0.0))
	var dur := float(offer.get("duration", 0.0))
	var upfront := int(offer.get("upfront", 0))
	var upkeep := int(offer.get("upkeep", 0))
	lbl.text = "+%.0f MW | %.0fs | Upfront %d | Upkeep %d" % [out, dur, upfront, upkeep]

func _set_contract_btn(btn: Button, source: String, offer: Dictionary) -> void:
	# Hide button if active contract exists for this source
	var active : Array = GM.get_active_contracts_for_source(source)
	if active.size() > 0:
		btn.text = "Active"
		btn.disabled = true
		return
	
	if offer.size() == 0:
		btn.text = "No offer"
		btn.disabled = true
		return
	var upfront := int(offer.get("upfront", 0))
	btn.text = "Accept"
	btn.disabled = GM.coins < upfront

func _refresh_capacity_labels(coal: float, solar: float, wind: float) -> void:
	lbl_cap_coal.text = "Coal Cap: %.0f MW" % coal
	lbl_cap_solar.text = "Solar Cap: %.0f MW" % solar
	lbl_cap_wind.text = "Wind Cap: %.0f MW" % wind

func _refresh_capacity_buttons() -> void:
	var can_buy = GM.coins >= 160
	btn_cap_coal.disabled = not can_buy
	btn_cap_solar.disabled = not can_buy
	btn_cap_wind.disabled = not can_buy

func _opt_init_overclock() -> void:
	opt_oc_plant.clear()
	opt_oc_plant.add_item("Coal")
	opt_oc_plant.set_item_metadata(0, "coal")
	opt_oc_plant.add_item("Solar")
	opt_oc_plant.set_item_metadata(1, "solar")
	opt_oc_plant.add_item("Wind")
	opt_oc_plant.set_item_metadata(2, "wind")
	opt_oc_plant.select(0)

func _opt_init_contracts() -> void:
	opt_contract_plant.clear()
	opt_contract_plant.add_item("Coal")
	opt_contract_plant.set_item_metadata(0, "coal")
	opt_contract_plant.add_item("Solar")
	opt_contract_plant.set_item_metadata(1, "solar")
	opt_contract_plant.add_item("Wind")
	opt_contract_plant.set_item_metadata(2, "wind")
	opt_contract_plant.select(0)

func _refresh_show_contracts_popup() -> void:
	var contracts : Array = GM.get_active_contracts_for_source(current_contract_view_plant)
	var lines : Array[String] = []
	var total_upkeep := 0
	for c in contracts:
		var out := float(c.get("output", 0.0))
		var remaining : float = maxf(float(c.get("remaining", 0.0)), 0.0)
		var upkeep := int(c.get("upkeep", 0))
		total_upkeep += upkeep
		lines.append("• +%.0f MW | %.0fs left | Upkeep %d" % [out, remaining, upkeep])

	if lines.is_empty():
		lbl_contracts_list.text = "No active contracts for %s." % current_contract_view_plant.capitalize()
	else:
		lbl_contracts_list.text = "\n".join(lines)

	lbl_contracts_total.text = "Active: %d | Total upkeep/tick: %d" % [contracts.size(), total_upkeep]

func _sync_overclock_popup_from_status() -> void:
	var s : Dictionary = GM.get_plant_status(current_overclock_plant)
	slider_oc_voltage.value = float(s.get("voltage", 0.0))
	slider_oc_cooling.value = float(s.get("cooling", 0.0))
	_update_overclock_popup_labels()
	_update_overclock_popup()

func _update_overclock_popup_labels() -> void:
	lbl_oc_voltage.text = "%.2f" % slider_oc_voltage.value
	lbl_oc_cooling.text = "%.2f" % slider_oc_cooling.value

func _update_overclock_popup() -> void:
	var s : Dictionary = GM.get_plant_status(current_overclock_plant)
	var heat := float(s.get("heat", 0.0))
	var damage := float(s.get("damage", 0.0))
	var mult := float(s.get("multiplier", 1.0))
	var state := str(s.get("state", "safe"))
	var disabled := float(s.get("disabled", 0.0))
	bar_oc_heat.value = heat
	bar_oc_damage.value = damage
	lbl_oc_mult.text = "x%.2f" % mult
	if disabled > 0.0:
		lbl_oc_state.text = "disabled"
	else:
		lbl_oc_state.text = state
	var color := Color(0.5, 0.8, 0.6)
	if state == "warning":
		color = Color(1.0, 0.7, 0.2)
	elif state == "critical":
		color = Color(1.0, 0.35, 0.25)
	elif state == "failing":
		color = Color(1.0, 0.2, 0.2)
	if disabled > 0.0:
		color = Color(0.7, 0.7, 0.7)
	lbl_oc_state.add_theme_color_override("font_color", color)

func _apply_overclock_safe_defaults() -> void:
	GM.set_overclock_targets(current_overclock_plant, 0.0, 0.5)

# Background music functions
func _play_random_bgm():
	_stop_all_bgm()

	var player = bgm_players.pick_random()
	player.play()

func _stop_all_bgm():
	for p in bgm_players:
		if p.playing:
			p.stop()
