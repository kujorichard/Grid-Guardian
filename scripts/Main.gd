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

# Energy supply meters
@onready var bar_coal_supply   : ProgressBar  = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/EnergySupply/CoalSupplyRow/CoalSupplyBar
@onready var bar_solar_supply  : ProgressBar  = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/EnergySupply/SolarSupplyRow/SolarSupplyBar
@onready var bar_wind_supply   : ProgressBar  = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/EnergySupply/WindSupplyRow/WindSupplyBar
@onready var lbl_coal_sup_val  : Label        = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/EnergySupply/CoalSupplyRow/CoalSupplyBar/LblVal
@onready var lbl_solar_sup_val : Label        = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/EnergySupply/SolarSupplyRow/SolarSupplyBar/LblVal
@onready var lbl_wind_sup_val  : Label        = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/EnergySupply/WindSupplyRow/WindSupplyBar/LblVal
@onready var btn_buy_coal      : Button       = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/EnergySupply/BtnBuyCoal

# Event panel
@onready var panel_event      : PanelContainer = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/EventPanel
@onready var lbl_event_title  : Label          = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/EventPanel/VBox/LblTitle
@onready var lbl_event_desc   : Label          = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/EventPanel/VBox/LblDesc
@onready var timer_event_hide : Timer          = $Screens/GameScreen/RightSidebar/Margin/Scroll/VBox/EventPanel/HideTimer

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

# Map Display
@onready var map : Node2D = $Screens/GameScreen/Map

var GM : Node
var contract_offers_by_source : Dictionary = {}
var current_overclock_plant : String = "coal"

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
	panel_event.hide()
	panel_flash.hide()
	popup_overclock.hide()
	_opt_init_overclock()

func _process(_delta: float) -> void:
	if screen_game.visible:
		if popup_overclock.visible:
			_update_overclock_popup()

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
	lbl_blackout.hide()
	lbl_streak.text = "Streak: 0s"
	_refresh_capacity_labels(GM.coal_capacity, GM.solar_capacity, GM.wind_capacity)
	_refresh_contract_labels()
	_refresh_upgrade_buttons()
	_update_buy_coal_button(GM.coal_price)
	_on_energy_supply_updated(GM.coal_supply, GM.solar_supply, GM.wind_supply)
	panel_flash.hide()
	popup_overclock.hide()

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
		lbl_blackout.text = "⚠️ BLACKOUT RISK!"
	else:
		lbl_blackout.hide()

	map.update_city(GM.coal_capacity, GM.solar_capacity, GM.wind_capacity, GM.pollution)
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
	lbl_event_title.text = ev.get("title", "Event")
	lbl_event_desc.text  = ev.get("desc",  "")
	panel_event.show()
	timer_event_hide.start(6.0)

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
	panel_flash.show()

func _on_flash_contract_ended(_reason: String) -> void:
	panel_flash.hide()

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
	_show_screen("gameover")

func _on_game_won() -> void:
	lbl_win_score.text = "🏆 Final Score: %d" % GM.score
	_show_screen("win")

func _on_upgrade_purchased(_id: String) -> void:
	_refresh_upgrade_buttons()

func _on_hide_timer_timeout() -> void:
	panel_event.hide()

func _on_energy_supply_updated(coal_sup: float, solar_sup: float, wind_sup: float) -> void:
	_set_bar(bar_coal_supply,  lbl_coal_sup_val,  coal_sup, Color(0.8, 0.6, 0.3), Color(0.4, 0.2, 0.1))
	_set_bar(bar_solar_supply, lbl_solar_sup_val, solar_sup, Color(1.0, 0.9, 0.2), Color(0.5, 0.3, 0.1))
	_set_bar(bar_wind_supply,  lbl_wind_sup_val,  wind_sup,  Color(0.4, 0.8, 1.0), Color(0.2, 0.3, 0.5))
	_update_buy_coal_button(GM.coal_price)

func _on_coal_price_updated(price: int) -> void:
	_update_buy_coal_button(price)

func _on_btn_buy_coal_pressed() -> void:
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

func _on_contract_expired(_offer: Dictionary) -> void:
	_refresh_contract_buttons()

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
func _on_btn_battery_pressed()      -> void: _try_upgrade("battery")
func _on_btn_grid_pressed()         -> void: _try_upgrade("grid")
func _on_btn_better_solar_pressed() -> void: _try_upgrade("better_solar")
func _on_btn_stable_wind_pressed()  -> void: _try_upgrade("stable_wind")

func _try_upgrade(id: String) -> void:
	GM.try_buy_upgrade(id)

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
	GM.accept_contract(str(offer.get("id", "")))

func _on_btn_buy_cap_coal_pressed() -> void: GM.buy_capacity("coal")
func _on_btn_buy_cap_solar_pressed() -> void: GM.buy_capacity("solar")
func _on_btn_buy_cap_wind_pressed() -> void: GM.buy_capacity("wind")

func _on_btn_boost_coal_pressed() -> void: GM.activate_boost("coal")
func _on_btn_boost_solar_pressed() -> void: GM.activate_boost("solar")
func _on_btn_boost_wind_pressed() -> void: GM.activate_boost("wind")

func _on_btn_flash_accept_pressed() -> void:
	GM.accept_flash_contract()

func _on_btn_overclock_pressed() -> void:
	popup_overclock.popup_centered()
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
	_apply_overclock_safe_defaults()
	popup_overclock.hide()

func _on_overclock_popup_hide() -> void:
	_apply_overclock_safe_defaults()

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
	_set_contract_label(lbl_contract_coal, contract_offers_by_source.get("coal", {}))
	_set_contract_label(lbl_contract_solar, contract_offers_by_source.get("solar", {}))
	_set_contract_label(lbl_contract_wind, contract_offers_by_source.get("wind", {}))

func _refresh_contract_buttons() -> void:
	_set_contract_btn(btn_contract_coal, contract_offers_by_source.get("coal", {}))
	_set_contract_btn(btn_contract_solar, contract_offers_by_source.get("solar", {}))
	_set_contract_btn(btn_contract_wind, contract_offers_by_source.get("wind", {}))

func _set_contract_label(lbl: Label, offer: Dictionary) -> void:
	if offer.size() == 0:
		lbl.text = "No offer"
		return
	var out := float(offer.get("output", 0.0))
	var dur := float(offer.get("duration", 0.0))
	var upfront := int(offer.get("upfront", 0))
	var upkeep := int(offer.get("upkeep", 0))
	lbl.text = "+%.0f MW | %.0fs | 💰 %d | Upkeep %d" % [out, dur, upfront, upkeep]

func _set_contract_btn(btn: Button, offer: Dictionary) -> void:
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
