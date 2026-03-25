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

# Meters
@onready var bar_stability    : ProgressBar  = $Screens/GameScreen/Meters/StabilityRow/StabilityBar
@onready var bar_pollution    : ProgressBar  = $Screens/GameScreen/Meters/PollutionRow/PollutionBar
@onready var bar_satisfaction : ProgressBar  = $Screens/GameScreen/Meters/SatisfactionRow/SatisfactionBar
@onready var lbl_stab_val     : Label        = $Screens/GameScreen/Meters/StabilityRow/StabilityBar/LblVal
@onready var lbl_poll_val     : Label        = $Screens/GameScreen/Meters/PollutionRow/PollutionBar/LblVal
@onready var lbl_sat_val      : Label        = $Screens/GameScreen/Meters/SatisfactionRow/SatisfactionBar/LblVal

# Sliders
@onready var slider_coal      : HSlider      = $Screens/GameScreen/Controls/CoalRow/CoalSlider
@onready var slider_solar     : HSlider      = $Screens/GameScreen/Controls/SolarRow/SolarSlider
@onready var slider_wind      : HSlider      = $Screens/GameScreen/Controls/WindRow/WindSlider
@onready var lbl_coal_val     : Label        = $Screens/GameScreen/Controls/CoalRow/CoalSlider/LblVal
@onready var lbl_solar_val    : Label        = $Screens/GameScreen/Controls/SolarRow/SolarSlider/LblVal
@onready var lbl_wind_val     : Label        = $Screens/GameScreen/Controls/WindRow/WindSlider/LblVal

# Supply/demand
@onready var lbl_demand       : Label        = $Screens/GameScreen/SupplyDemand/LblDemand
@onready var lbl_supply       : Label        = $Screens/GameScreen/SupplyDemand/LblSupply
@onready var lbl_balance      : Label        = $Screens/GameScreen/SupplyDemand/LblBalance

# Event panel
@onready var panel_event      : PanelContainer = $Screens/GameScreen/EventPanel
@onready var lbl_event_title  : Label          = $Screens/GameScreen/EventPanel/VBox/LblTitle
@onready var lbl_event_desc   : Label          = $Screens/GameScreen/EventPanel/VBox/LblDesc
@onready var timer_event_hide : Timer          = $Screens/GameScreen/EventPanel/HideTimer

# Upgrade buttons
@onready var btn_battery      : Button = $Screens/GameScreen/Upgrades/BtnBattery
@onready var btn_grid         : Button = $Screens/GameScreen/Upgrades/BtnGrid
@onready var btn_better_solar : Button = $Screens/GameScreen/Upgrades/BtnBetterSolar
@onready var btn_stable_wind  : Button = $Screens/GameScreen/Upgrades/BtnStableWind

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

func _ready() -> void:
	GM = get_node("/root/GameManager")
	GM.meters_updated.connect(_on_meters_updated)
	GM.demand_updated.connect(_on_demand_updated)
	GM.event_triggered.connect(_on_event_triggered)
	GM.game_over.connect(_on_game_over)
	GM.game_won.connect(_on_game_won)
	GM.time_updated.connect(_on_time_updated)
	GM.upgrade_purchased.connect(_on_upgrade_purchased)

	slider_coal.value_changed.connect(func(v):
		GM.set_coal(v)
		_update_slider_label(lbl_coal_val, v)
		map.update_city(GM.coal_level, GM.solar_level, GM.wind_level, GM.pollution)
	)

	slider_solar.value_changed.connect(func(v):
		GM.set_solar(v)
		_update_slider_label(lbl_solar_val, v)
		map.update_city(GM.coal_level, GM.solar_level, GM.wind_level, GM.pollution)
	)

	slider_wind.value_changed.connect(func(v):
		GM.set_wind(v)
		_update_slider_label(lbl_wind_val, v)
		map.update_city(GM.coal_level, GM.solar_level, GM.wind_level, GM.pollution)
	)

	_show_screen("menu")
	panel_event.hide()

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
	slider_coal.value  = GM.coal_level
	slider_solar.value = GM.solar_level
	slider_wind.value  = GM.wind_level
	_update_slider_label(lbl_coal_val,  GM.coal_level)
	_update_slider_label(lbl_solar_val, GM.solar_level)
	_update_slider_label(lbl_wind_val,  GM.wind_level)
	lbl_blackout.hide()
	_refresh_upgrade_buttons()

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

func _update_slider_label(lbl: Label, val: float) -> void:
	lbl.text = "%.0f%%" % val
