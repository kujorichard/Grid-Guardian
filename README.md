# ⚡ Grid Guardian — QS Impact Game

A real-time energy grid management game built in **Godot 4**.  
Balance coal, solar, and wind power. Keep the city alive — and the air clean.

---

## 🚀 Quick Setup (5 minutes)

### Requirements
- [Godot 4.2+](https://godotengine.org/download) (use the standard version, not .NET)

### Steps
1. Download / clone this folder
2. Open **Godot 4**
3. Click **"Import"** → select the `GridGuardian/` folder → **"Import & Edit"**
4. Press **F5** (or the ▶ Play button) to run

> No plugins, no dependencies, no extra setup needed.

---

## 🎮 How to Play

| Control | Action |
|---------|--------|
| 🏭 Coal slider | Increase = more power, more pollution |
| ☀️ Solar slider | Clean energy — only works during daytime |
| 🌬️ Wind slider | Clean energy — unpredictable output |
| 💰 Coins | Earned over time, spent on upgrades |

### Win Condition
Survive **6 minutes** without:
- Power stability hitting 0 (blackout)
- Pollution hitting 100% (city crisis)
- Satisfaction hitting 0 (public revolt)

### The Three Meters
| Meter | Goes up when... | Goes down when... |
|-------|-----------------|-------------------|
| ⚡ Stability | Supply ≥ Demand | Deficit / blackout |
| 🌫️ Pollution | Coal is high | Coal is reduced |
| 😊 Satisfaction | Stable + clean | Unstable or dirty |

---

## 🌍 Time of Day Cycle (every 45s)

| Time | Solar | Demand |
|------|-------|--------|
| 🌅 Morning | 60% | Medium |
| ☀️ Afternoon | 100% | High |
| 🌆 Evening | 30% | Very High |
| 🌙 Night | 0% | Low |

---

## 💥 Random Events (every 20–35s)

| Event | Effect |
|-------|--------|
| ⛈️ Storm | Solar ↓ 80%, Wind ↑ 80% |
| 🔥 Heatwave | Demand ↑ 50% |
| 🏭 Factory Boom | Demand ↑ 35% |
| 🌱 Green Policy | Bonus coins if pollution < 40% |
| 🌤️ Perfect Conditions | Solar +30%, Wind +25%, Demand ↓ 10% |

---

## 🔧 Upgrades

| Upgrade | Cost | Effect |
|---------|------|--------|
| 🔋 Battery Storage | 500 | Surplus energy improves stability |
| 🔌 Grid Upgrade | 400 | Deficit impact reduced 40% |
| 🌞 Better Solar | 350 | Solar works during cloudy conditions |
| 🌬️ Stable Wind | 300 | Wind output less random |

---

## 📁 Project Structure

```
GridGuardian/
├── project.godot          ← Godot project config + autoloads
├── icon.svg               ← App icon
├── scenes/
│   └── Main.tscn          ← Full UI scene tree
└── scripts/
    ├── GameManager.gd     ← Core game logic (autoloaded singleton)
    └── Main.gd            ← UI controller
```

---

## 🎨 Extending the Game

### Add a new event
In `GameManager.gd`, find `_trigger_random_event()` and add a new dictionary to the `events` array:
```gdscript
{
    "id": "my_event",
    "title": "🌊 Flood Warning",
    "desc": "Flooding reduces wind farm access.",
    "solar_mod": 1.0, "wind_mod": 0.4, "demand_mod": 1.2,
    "duration": 18.0, "color": Color(0.2, 0.5, 0.9)
}
```

### Add a new upgrade
1. Add an entry to the `upgrades` dictionary in `GameManager.gd`
2. Add a Button node in `Main.tscn` under `Screens/GameScreen/Upgrades`
3. Wire the button's `pressed` signal to a new handler in `Main.gd`
4. Handle the upgrade effect in `_get_solar_output()`, `_get_wind_output()`, or `_game_tick()`

### Adjust difficulty
In `GameManager.gd`:
- `GAME_DURATION` — how long to survive (seconds)
- `MAX_COAL_OUTPUT`, `MAX_SOLAR_OUTPUT`, `MAX_WIND_OUTPUT` — power capacities
- Pollution delta multiplier in `_game_tick()` (currently `3.5`)
- Demand values per time of day in `_get_demand()`

---

## 🏆 SDG Connection (for QS Impact judging)

This game directly demonstrates **SDG 7 (Affordable and Clean Energy)** and **SDG 13 (Climate Action)**:

- Players *feel* why coal is still used (reliability vs. consequence)
- Tradeoffs are visceral: no perfect solution exists
- Renewable unpredictability is simulated, not just stated
- The consequence meter system makes abstract climate metrics tangible
