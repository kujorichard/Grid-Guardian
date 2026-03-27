# Grid Guardian

Real-time grid balancing game built in Godot 4.
Manage coal, solar, and wind while keeping the city stable, clean, and satisfied.

## Quick Start

1. Open the project in Godot 4.2+.
2. Run the main scene.
3. Survive 360s without hitting any lose condition.

Lose conditions:
- Stability <= 0
- Pollution >= 100
- Satisfaction <= 0

## Core Loop

Game logic runs every 2 seconds (`TICK_INTERVAL`).
Each tick:
- Demand is sampled from time-of-day profile + event modifier + small randomness.
- Supply is computed from coal + solar + wind output.
- Stability, pollution, satisfaction, score, and coins are updated.

## Supply Model

Stock acts as an on/off gate:
- Stock > 0: source can output
- Stock <= 0: source output is forced to 0

Output formulas:
- Coal: `(effective_coal_capacity + contract_output + coal_event_bonus) * plant_multiplier`
- Solar: `(effective_solar_capacity + contract_output + solar_event_bonus) * solar_tod_factor * solar_modifier * plant_multiplier`
- Wind: `(effective_wind_capacity + contract_output + wind_event_bonus) * wind_tod_factor * wind_noise * wind_modifier * plant_multiplier`

`wind_noise`:
- Default: 0.7 to 1.3
- With Stable Wind upgrade: 0.9 to 1.1

## Time-of-Day

Cycle length: 180s (45s each phase)

Demand baseline:
- Morning: 70
- Afternoon: 80
- Evening: 90
- Night: 65

Solar TOD factor:
- Morning: 0.8
- Afternoon: 1.0
- Evening: 0.6 (0.75 with Better Solar)
- Night: 0.15 (0.45 with Better Solar)

Wind TOD factor:
- Morning: 0.85
- Afternoon: 0.40
- Evening: 0.80
- Night: 1.00

## Starting Values (Current Balance)

From `start_game()` in `scripts/GameManager.gd`:
- `coal_capacity = 40`
- `solar_capacity = 35`
- `wind_capacity = 30`
- `coal_supply = 50`
- `solar_supply = 18`
- `wind_supply = 24`
- `stability = 80`
- `pollution = 20`
- `satisfaction = 70`
- `coins = 200`

## Energy Stock Consumption and Recharge

Per tick at current capacity:
- Coal consume: `(coal_capacity / MAX_COAL_OUTPUT) * COAL_CONSUME_RATE * coal_consume_modifier`
- Solar consume: `max((solar_capacity / MAX_SOLAR_OUTPUT) * SOLAR_CONSUME_RATE, 0.8)`
- Wind consume: `max((wind_capacity / MAX_WIND_OUTPUT) * WIND_CONSUME_RATE, 0.4)`

Recharge:
- Solar: `SOLAR_RECHARGE_RATE * solar_tod_factor * solar_recharge_modifier`
- Wind: `(wind_gust / 100.0) * WIND_RECHARGE_RATE * wind_recharge_modifier * wind_tod_buff`
- Wind night recharge buff: `wind_tod_buff = 1.35`

Coal is refilled only via `buy_coal()`.

## Overclock Mechanics (Updated)

Overclock logic lives in `scripts/PowerPlant.gd` and per-plant tuning in:
- `scripts/CoalPlant.gd`
- `scripts/SolarPlant.gd`
- `scripts/WindPlant.gd`

### Shared Base Behavior (`PowerPlant.gd`)

Current base tuning:
- `heat_rise_rate = 26.0`
- `heat_cool_rate = 30.0`
- `damage_rate = 5.5`
- `repair_rate = 6.8`
- `warn_heat = 75.0`
- `critical_heat = 90.0`

Important safeguards:
- Voltage deadzone: `voltage < 0.05` is treated as 0.0 (prevents accidental heating from tiny slider values).
- Instability is applied only when actively overclocking.
- Idle passive cooling floor: when not overclocking, cooling strength is at least 0.35.

This specifically fixes the issue where wind could appear to build heat while not intentionally overclocked.

### Per-Plant Overclock Tuning (Current)

Coal (`scripts/CoalPlant.gd`):
- `max_multiplier = 2.05`
- `base_pollution_mult = 1.15`
- `heat_rise_rate = 22.0`
- `heat_cool_rate = 30.0`
- `damage_rate = 4.2`
- `repair_rate = 6.5`
- `failure_cooldown = 12.0`

Solar (`scripts/SolarPlant.gd`):
- `max_multiplier = 1.65`
- `heat_rise_rate = 18.0`
- `heat_cool_rate = 34.0`
- `damage_rate = 4.2`
- `repair_rate = 7.5`
- `failure_cooldown = 8.0`

Wind (`scripts/WindPlant.gd`):
- `instability = 0.07`
- `max_multiplier = 1.8`
- `heat_rise_rate = 19.0`
- `heat_cool_rate = 31.0`
- `damage_rate = 4.8`
- `repair_rate = 7.2`
- `failure_cooldown = 10.0`

## Economy and Progression

Key constants in `scripts/GameManager.gd`:
- `CAPACITY_STEP = 6.0`
- `CAPACITY_COST = 160`
- `BOOST_AMOUNT = 20.0`
- `BOOST_DURATION = 12.0`
- `BOOST_COOLDOWN = 20.0`
- `COIN_INCOME_MULTIPLIER = 1.85`
- `BALANCE_TOLERANCE = 6.0`

Balance streak tiers:
- Tier 1 at 20s
- Tier 2 at 40s
- Tier 3 at 60s

## Events

Random event trigger window:
- `EVENT_MIN_INTERVAL = 18.0`
- `EVENT_MAX_INTERVAL = 26.0`

Flash contracts:
- Interval: 16s to 26s
- Decision window: 6s

Event effects are configured in `_trigger_random_event()` in `scripts/GameManager.gd`.
For balancing, adjust:
- `solar_mod`, `wind_mod`, `demand_mod`
- `duration`
- Special modifiers and bonus ranges per event case

## What to Change and How

Use this as a balancing checklist.

### 1) Make overclock safer or harsher

Edit `scripts/PowerPlant.gd`:
- Safer: lower `heat_rise_rate` / `damage_rate`, increase `heat_cool_rate` / `repair_rate`, raise `warn_heat`.
- Harsher: do the opposite.

Edit per-source files for identity:
- Coal: keep highest output upside, highest pollution pressure.
- Solar: fastest cooling/repair profile.
- Wind: control volatility with `instability`.

### 2) Change early-game difficulty

Edit `start_game()` in `scripts/GameManager.gd`:
- `coal_supply`, `solar_supply`, `wind_supply`
- Starting capacities
- `coins`

### 3) Adjust economy speed

Edit `COIN_INCOME_MULTIPLIER`, `CAPACITY_COST`, and upgrade costs (`upgrades` dictionary).

### 4) Tune demand pressure

Edit `_get_demand()` baselines and `demand_modifier` usage.

### 5) Tune renewable reliability

Edit:
- `_get_solar_tod_factor()`
- `_get_wind_tod_factor()`
- `WIND_GUST_INTERVAL` and gust range logic in `_process()`

### 6) Tune pollution pressure

Edit pollution equation in `_game_tick()`:
- `coal_ratio * ...`
- Constant offset (`-1.2`)
- Event pollution multiplier logic

## Runtime Safety Note (Main UI)

To prevent `Cannot call method 'hide' on a null value` crashes, UI hide calls now go through a guarded helper in `scripts/Main.gd`:
- `_safe_hide(node)`

If you add or remove nodes from the scene tree, keep this pattern for optional UI nodes.

## Main Files

- `scripts/GameManager.gd`: simulation, balancing, events, economy
- `scripts/PowerPlant.gd`: shared overclock model
- `scripts/CoalPlant.gd`: coal profile
- `scripts/SolarPlant.gd`: solar profile
- `scripts/WindPlant.gd`: wind profile
- `scripts/Main.gd`: HUD and UI behavior
- `scenes/Main.tscn`: node tree for UI and map
