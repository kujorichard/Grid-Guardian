extends Control

# ─── Node references ──────────────────────────────────────────────────────────
@onready var screen_menu    : Control = $Screens/MenuScreen
@onready var screen_game    : Control = $Screens/GameScreen
@onready var screen_gameover: Control = $Screens/GameOverScreen
@onready var screen_win     : Control = $Screens/WinScreen

# GameScreen children
@onready var lbl_time_of_day  : Label        = $Screens/GameScreen/TopBar/LblTimeOfDay
@onready var lbl_timer        : Label        = $Screens/GameScreen/TopBar/LblTimer
@onready var lbl_score        : Label        = $Screens/GameScreen/TopBar/LblScore
@onready var lbl_coins        : Label        = $Screens/GameScreen/TopBar/LblCoins
@onready var lbl_streak       : Label        = $Screens/GameScreen/TopBar/LblStreak

# Meters
@onready var bar_stability    : ProgressBar  = $Screens/GameScreen/Meters/StabilityRow/StabilityBar
@onready var bar_pollution    : ProgressBar  = $Screens/GameScreen/Meters/PollutionRow/PollutionBar
@onready var bar_satisfaction : ProgressBar  = $Screens/GameScreen/Meters/SatisfactionRow/SatisfactionBar
@onready var lbl_stab_val     : Label        = $Screens/GameScreen/Meters/StabilityRow/StabilityBar/LblVal
@onready var lbl_poll_val     : Label        = $Screens/GameScreen/Meters/PollutionRow/PollutionBar/LblVal
@onready var lbl_sat_val      : Label        = $Screens/GameScreen/Meters/SatisfactionRow/SatisfactionBar/LblVal

# Contracts
@onready var lbl_contract_coal  : Label   = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Contracts/RowCoal/LblOffer
@onready var lbl_contract_solar : Label   = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Contracts/RowSolar/LblOffer
@onready var lbl_contract_wind  : Label   = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Contracts/RowWind/LblOffer
@onready var btn_contract_coal  : Button  = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Contracts/RowCoal/BtnAccept
@onready var btn_contract_solar : Button  = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Contracts/RowSolar/BtnAccept
@onready var btn_contract_wind  : Button  = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Contracts/RowWind/BtnAccept

# Show contracts popup
@onready var popup_contracts : PopupPanel = $Screens/GameScreen/ContractsPopup
@onready var opt_contract_plant : OptionButton = $Screens/GameScreen/ContractsPopup/Margin/VBox/RowPlant/OptPlant
@onready var lbl_contracts_list : Label = $Screens/GameScreen/ContractsPopup/Margin/VBox/RowList/LblContracts
@onready var lbl_contracts_total : Label = $Screens/GameScreen/ContractsPopup/Margin/VBox/LblTotals

# Capacity
@onready var lbl_cap_coal   : Label = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Capacity/RowCoal/LblCap
@onready var lbl_cap_solar  : Label = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Capacity/RowSolar/LblCap
@onready var lbl_cap_wind   : Label = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Capacity/RowWind/LblCap
@onready var btn_cap_coal   : Button = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Capacity/RowCoal/BtnBuy
@onready var btn_cap_solar  : Button = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Capacity/RowSolar/BtnBuy
@onready var btn_cap_wind   : Button = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Capacity/RowWind/BtnBuy

# Emergency boost
@onready var lbl_boost_status : Label = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Boost/RowStatus/LblStatus
@onready var btn_boost_coal   : Button = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Boost/RowButtons/BtnBoostCoal
@onready var btn_boost_solar  : Button = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Boost/RowButtons/BtnBoostSolar
@onready var btn_boost_wind   : Button = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Boost/RowButtons/BtnBoostWind

# Supply/demand
@onready var lbl_demand       : Label        = $Screens/GameScreen/SupplyDemand/LblDemand
@onready var lbl_supply       : Label        = $Screens/GameScreen/SupplyDemand/LblSupply
@onready var lbl_balance      : Label        = $Screens/GameScreen/SupplyDemand/LblBalance
@onready var lbl_event_status : Label        = get_node_or_null("Screens/GameScreen/SupplyDemand/LblEventStatus")

# Energy supply meters
@onready var bar_coal_supply   : ProgressBar  = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/EnergySupply/CoalSupplyRow/CoalSupplyBar
@onready var bar_solar_supply  : ProgressBar  = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/EnergySupply/SolarSupplyRow/SolarSupplyBar
@onready var bar_wind_supply   : ProgressBar  = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/EnergySupply/WindSupplyRow/WindSupplyBar
@onready var lbl_coal_sup_val  : Label        = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/EnergySupply/CoalSupplyRow/CoalSupplyBar/LblVal
@onready var lbl_solar_sup_val : Label        = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/EnergySupply/SolarSupplyRow/SolarSupplyBar/LblVal
@onready var lbl_wind_sup_val  : Label        = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/EnergySupply/WindSupplyRow/WindSupplyBar/LblVal
@onready var btn_buy_coal      : Button       = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/EnergySupply/BtnBuyCoal
@onready var lbl_oc_warning    : Label        = get_node_or_null("Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/LblOCWarning")

# Event panel
@onready var panel_event      : PanelContainer = $Screens/GameScreen/EventOverlay
@onready var lbl_event_title  : Label          = $Screens/GameScreen/EventOverlay/VBox/LblTitle
@onready var lbl_event_desc   : Label          = $Screens/GameScreen/EventOverlay/VBox/LblDesc
@onready var timer_event_hide : Timer          = $Screens/GameScreen/EventOverlay/HideTimer

# Flash contract panel
@onready var panel_flash      : PanelContainer = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/FlashPanel
@onready var lbl_flash_title  : Label          = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/FlashPanel/VBox/LblFlashTitle
@onready var lbl_flash_desc   : Label          = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/FlashPanel/VBox/LblFlashDesc
@onready var bar_flash_timer  : ProgressBar    = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/FlashPanel/VBox/FlashTimerBar
@onready var btn_flash_accept : Button         = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/FlashPanel/VBox/BtnFlashAccept

# Overclock popup
@onready var btn_overclock_open : Button = $Screens/GameScreen/TopBar/BtnOverclock
@onready var popup_overclock : PopupPanel = $Screens/GameScreen/OverclockPopup
@onready var opt_oc_plant : OptionButton = $Screens/GameScreen/OverclockPopup/Margin/VBox/RowPlant/OptPlant
@onready var slider_oc_voltage : HSlider = $Screens/GameScreen/OverclockPopup/Margin/VBox/RowVoltage/VoltageSlider
@onready var slider_oc_cooling : HSlider = $Screens/GameScreen/OverclockPopup/Margin/VBox/RowCooling/CoolingSlider
@onready var lbl_oc_voltage : Label = $Screens/GameScreen/OverclockPopup/Margin/VBox/RowVoltage/LblVoltageVal
@onready var lbl_oc_cooling : Label = $Screens/GameScreen/OverclockPopup/Margin/VBox/RowCooling/LblCoolingVal
@onready var bar_oc_heat : ProgressBar = $Screens/GameScreen/OverclockPopup/Margin/VBox/RowHeat/HeatBar
@onready var bar_oc_damage : ProgressBar = $Screens/GameScreen/OverclockPopup/Margin/VBox/RowDamage/DamageBar
@onready var lbl_oc_state : Label = $Screens/GameScreen/OverclockPopup/Margin/VBox/RowStatus/LblState
@onready var lbl_oc_mult : Label = $Screens/GameScreen/OverclockPopup/Margin/VBox/RowStatus/LblMult
@onready var btn_oc_safe : Button = $Screens/GameScreen/OverclockPopup/Margin/VBox/RowButtons/BtnSafe
@onready var btn_oc_close : Button = $Screens/GameScreen/OverclockPopup/Margin/VBox/RowButtons/BtnClose

# Upgrade buttons
@onready var btn_battery      : Button = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Upgrades/BtnBattery
@onready var btn_grid         : Button = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Upgrades/BtnGrid
@onready var btn_better_solar : Button = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Upgrades/BtnBetterSolar
@onready var btn_stable_wind  : Button = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/Upgrades/BtnStableWind

# City skyline
@onready var city_overlay     : Control = $Screens/GameScreen/CityOverlay
@onready var lbl_blackout     : Label   = $Screens/GameScreen/CityOverlay/LblBlackout

# Game over / win
@onready var lbl_go_reason    : Label = $Screens/GameOverScreen/VBox/LblReason
@onready var lbl_go_score     : Label = $Screens/GameOverScreen/VBox/LblScore
@onready var lbl_win_score    : Label = $Screens/WinScreen/VBox/LblScore

# ─── SFX Objects ──────────────────────────────────────────────────────────────
@onready var accept_contract_sfx = $Screens/GameScreen/Sounds/AcceptContract
@onready var blackout_warning_sfx = $Screens/GameScreen/Sounds/BlackoutWarning
@onready var buy_coal_sfx = $Screens/GameScreen/Sounds/BuyCoal
@onready var flash_contract_appear_sfx = $Screens/GameScreen/Sounds/FlashContractAppear
@onready var flash_contract_expire_sfx = $Screens/GameScreen/Sounds/FlashContractExpire
@onready var game_over_sfx = $Screens/GameScreen/Sounds/GameOver
@onready var game_won_sfx = $Screens/GameScreen/Sounds/GameWon
@onready var random_event_sfx = $Screens/GameScreen/Sounds/RandomEvent
@onready var boost_coal_sfx = $Screens/GameScreen/Sounds/BoostCoal
@onready var boost_solar_sfx = $Screens/GameScreen/Sounds/BoostSolar
@onready var boost_wind_sfx = $Screens/GameScreen/Sounds/BoostWind
@onready var upgrade_purchase_sfx = $Screens/GameScreen/Sounds/UpgradePurchase
@onready var start_overclock_sfx = $Screens/GameScreen/Sounds/StartOverclock
@onready var bgm_players = [
	$Screens/GameScreen/Sounds/BGM1,
	$Screens/GameScreen/Sounds/BGM2,
	$Screens/GameScreen/Sounds/BGM3
]

# Map Display
@onready var map : Node2D = $Screens/GameScreen/Map

var GM : Node
var contract_offers_by_source : Dictionary = {}
var current_overclock_plant : String = "coal"
var current_contract_view_plant : String = "coal"

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

func _process(_delta: float) -> void:
	if screen_game.visible:
		if popup_overclock.visible:
			_update_overclock_popup()
		if popup_contracts.visible:
			_refresh_show_contracts_popup()
		_update_event_status()
		_update_overclock_warning()
		_update_contract_displays()

# ─── Screen management ────────────────────────────────────────────────────────
func _show_screen(name: String) -> void:
	screen_menu.visible     = (name == "menu")
	screen_game.visible     = (name == "game")
	screen_gameover.visible = (name == "gameover")
	screen_win.visible      = (name == "win")

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

# ─── Signal handlers ──────────────────────────────────────────────────────────
func _on_meters_updated(stab: float, poll: float, sat: float) -> void:
	_set_bar(bar_stability,    lbl_stab_val,  stab, Color(0.2, 0.7, 1.0),  Color(1.0, 0.3, 0.2))
	_set_bar(bar_pollution,    lbl_poll_val,  poll, Color(0.3, 0.8, 0.3),  Color(0.9, 0.2, 0.1), true)
	_set_bar(bar_satisfaction, lbl_sat_val,   sat,  Color(0.3, 0.9, 0.5),  Color(1.0, 0.4, 0.1))

	lbl_score.text = "Score: %d" % GM.score
	lbl_coins.text = "💰 %d" % GM.coins
	lbl_time_of_day.text = GM.get_time_of_day_label()

	# Blackout warning
	if stab < 20.0:
		lbl_blackout.show()
		blackout_warning_sfx.play()
		lbl_blackout.text = "⚠️ BLACKOUT RISK!"
	else:
		_safe_hide(lbl_blackout)

	map.update_city(GM.coal_supply, GM.solar_supply, GM.wind_supply, GM.pollution)
	_refresh_contract_buttons()
	_refresh_capacity_buttons()

	_refresh_upgrade_buttons()

func _on_demand_updated(demand: float, supply: float) -> void:
	lbl_demand.text = "Demand: %.0f MW" % demand
	lbl_supply.text = "Supply: %.0f MW" % supply
	var balance := supply - demand
	lbl_balance.text = ("✅ +%.0f MW surplus" % balance) if balance >= 0 else ("❌ %.0f MW deficit" % balance)
	lbl_balance.add_theme_color_override("font_color", Color(0.3, 0.9, 0.3) if balance >= 0 else Color(1.0, 0.3, 0.2))

func _on_event_triggered(ev: Dictionary) -> void:
	if lbl_event_title == null or lbl_event_desc == null:
		return
	random_event_sfx.play()
	lbl_event_title.text = ev.get("title", "Event")
	lbl_event_desc.text  = ev.get("desc",  "")
	if panel_event != null:
		panel_event.show()
	if timer_event_hide != null:
		timer_event_hide.start(3.0)

# Updates the event status line (name + timer) near supply/demand
func _update_event_status() -> void:
	if lbl_event_status == null:
		return
	if GM.active_event_id != "" and GM.event_time_remaining > 0:
		lbl_event_status.text = "🎯 %s: %.0fs" % [GM.active_event_id.capitalize(), GM.event_time_remaining]
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
			warnings.append("🚫 %s OFFLINE (%.0fs)" % [source.capitalize(), state.get("disabled", 0.0)])
		elif voltage > 0.0:  # Only show if actively overclocking
			if plant_state == "failing":
				warnings.append("🔥 %s FAILING (%.0f°C)" % [source.capitalize(), heat])
			elif plant_state == "critical":
				warnings.append("⚠️ %s CRITICAL (%.0f°C)" % [source.capitalize(), heat])
			elif plant_state == "warning":
				warnings.append("🔶 %s Warning (%.0f°C)" % [source.capitalize(), heat])
	
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
	lbl_flash_title.text = "⚡ Flash Contract"
	lbl_flash_desc.text = "%s +%.0f MW | %.0fs | 💰 %d | Upkeep %d" % [source, out, dur, upfront, upkeep]
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
		"blackout":    msg = "💀 Total Blackout!\nThe city went dark."
		"pollution":   msg = "☠️ Pollution Crisis!\nThe city choked on smog."
		"satisfaction":msg = "😡 Public Revolt!\nCitizens lost all faith."
	lbl_go_reason.text = msg
	lbl_go_score.text  = "Final Score: %d" % GM.score
	_stop_all_bgm()
	game_over_sfx.play()
	_show_screen("gameover")

func _on_game_won() -> void:
	lbl_win_score.text = "🏆 Final Score: %d" % GM.score
	_stop_all_bgm()
	game_won_sfx.play()
	_show_screen("win")

func _on_upgrade_purchased(_id: String) -> void:
	_refresh_upgrade_buttons()

func _on_hide_timer_timeout() -> void:
	_safe_hide(panel_event)

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
	btn_buy_coal.text = "⛏️ Buy Coal (+20%%)\n💰 %d" % price
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
		btn.text     = label + " ✓"
		btn.disabled = true
	else:
		btn.text     = "%s\n💰 %d" % [label, cost]
		btn.disabled = GM.coins < cost

func _safe_hide(node: Variant) -> void:
	if node != null and is_instance_valid(node) and node.has_method("hide"):
		node.hide()

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
		lbl.text = "✅ +%.0f MW | %.0fs left | 💸 %d" % [out, remaining, upkeep]
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
	lbl.text = "+%.0f MW | %.0fs | 💰 %d | Upkeep %d" % [out, dur, upfront, upkeep]

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
	lbl_cap_coal.text = "Cap: %.0f MW" % coal
	lbl_cap_solar.text = "Cap: %.0f MW" % solar
	lbl_cap_wind.text = "Cap: %.0f MW" % wind

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
