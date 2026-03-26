# Grid Guardian — Complete Game Mechanics Guide

## 🎯 Objective

Survive **6 minutes** (360 seconds) without triggering any lose condition.

---

## ⚡ Core Loop: Supply vs Demand

Every **2 seconds** (one "tick"), the game calculates:

- **Demand** — how much MW the city needs (varies by time of day + events)
- **Supply** — how much MW your three plants generate

| Time of Day  | Base Demand | Duration |
| ------------ | ----------- | -------- |
| 🌅 Morning   | 70 MW       | 45s      |
| ☀️ Afternoon | 80 MW       | 45s      |
| 🌆 Evening   | 90 MW       | 45s      |
| 🌙 Night     | 60 MW       | 45s      |

A full day cycle = 180 seconds. You go through ~2 full cycles per game.

---

## 🏭 Energy Sources

Each source has a **Capacity** (base MW output) and a **Stock** (fuel reserve, 0–100%).

| Source   | Start Capacity | Start Stock | Max Capacity |
| -------- | -------------- | ----------- | ------------ |
| 🏭 Coal  | 40 MW          | 50%         | 100 MW       |
| ☀️ Solar | 30 MW          | 10%         | 80 MW        |
| 🌬️ Wind  | 20 MW          | 20%         | 60 MW        |

### Binary Gate Rule

Stock acts as an **on/off switch**:

- Stock > 0% → Plant outputs at **full capacity**
- Stock = 0% → Plant outputs **zero MW**

### Output Calculation

```
Coal Output  = (Coal Capacity + Contract MW) × Plant Multiplier
Solar Output = (Solar Capacity + Contract MW) × Time-of-Day Factor × Solar Modifier × Plant Multiplier
Wind Output  = (Wind Capacity + Contract MW) × Wind Noise × Wind Modifier × Plant Multiplier
```

---

## 🔋 Energy Stock System

Each tick, stock is consumed and (for solar/wind) recharged:

### Consumption (per tick)

- **Coal**: `(coal_capacity / 100) × 2.0 × coal_consume_modifier`
- **Solar**: `max((solar_capacity / 80) × 1.8, 0.8)` — minimum 0.8 floor, **always drains**
- **Wind**: `max((wind_capacity / 60) × 1.5, 0.4)` — minimum 0.4 floor, **always drains**

### Recharge (per tick)

- **Coal**: No recharge. Must **buy coal** (💰 40–85 coins → +20% stock)
- **Solar**: `4.5 × time_of_day_factor × solar_recharge_modifier`
  - Morning: ×0.6, Afternoon: ×0.8, Evening: ×0.4, **Night: ×0.0 (no recharge)**
- **Wind**: `(wind_gust / 100) × 3.5 × wind_recharge_modifier`
  - Wind gust: random value (10–60) that refreshes every 20s

> **Key insight**: Solar drains at night but does NOT recharge. It can hit 0% during long nights. Wind recharge depends on constantly-changing wind gust values.

---

## 📊 City Meters (0–100)

### ⚡ Power Stability

- Surplus → stability **rises** (up to +2.5/tick, or +5.0 with Battery upgrade)
- Deficit → stability **drops** (severity × 0.25, halved with Grid upgrade)
- **Lose at 0%** → Blackout

### 🌫️ Pollution

- Coal output drives pollution: `(coal_ratio × 3.5 × plant_pollution_mult) - 1.2` per tick
- Active contracts add `risk_pollution` per tick
- **Lose at 100%** → Pollution Crisis

### 😊 Public Satisfaction

- Pulled by stability: `(stability - 50) × 0.06`
- Hurt by pollution: `(pollution - 40) × 0.04`
- Penalized by large deficits (< -10 MW): `-3.0` per tick
- **Lose at 0%** → Public Revolt

---

## 💰 Economy

- **Passive income**: 8 coins per tick
- **Balance streak bonuses**: extra coins/score when supply ≈ demand (within ±6 MW)

| Streak Duration | Tier      | Bonus Score/Tick | Bonus Coins/Tick |
| --------------- | --------- | ---------------- | ---------------- |
| 20s+            | 🥉 Bronze | +10              | +2               |
| 40s+            | 🥈 Silver | +20              | +4               |
| 60s+            | 🥇 Gold   | +30              | +6               |

---

## 📜 Contracts

**Refresh** every 10 seconds with new offers for each source (coal/solar/wind).

Each contract gives:

- **+MW output** for its source (12–28 MW)
- **Duration** (10–18s)
- **Upfront cost** (120–240 coins, modified by events)
- **Upkeep** (6–14 coins per tick)
- **Risk**: Pollution (+1.5 coal, +0.3 solar/wind) and Stability hits per tick

If you can't pay upkeep → contract is forcibly terminated + stability penalty.

### ⚡ Flash Contracts

Time-limited offers (6s window) with:

- Higher output (18–34 MW) but higher risk
- Cheaper upfront (×0.85) but higher upkeep (×1.4)
- Bonus: +40 coins, +80 score, +3 stability on accept
- Penalty: -4 stability, -3 satisfaction, +2 pollution if you let it expire

---

## 🔧 Capacity Upgrades

Buy **+6 MW** to any plant for **160 coins** each.

---

## 🚀 Emergency Boost

Instantly add **+18 MW** to one source for **8 seconds**.

- **Cooldown**: 24 seconds between boosts

---

## ⚡ Overclock System

Each plant has voltage and cooling controls:

- Higher **voltage** → higher output multiplier
- Higher **cooling** → slower heat buildup
- Heat builds based on voltage; damage increases when heat is high
- At high damage, the plant can become **disabled**

States: safe → warning → critical → failing → disabled

---

## 🔬 Permanent Upgrades

| Upgrade         | Cost | Effect                                                    |
| --------------- | ---- | --------------------------------------------------------- |
| 🔋 Battery      | 650  | Stability recovers faster during surplus (×3)             |
| 🔌 Grid         | 550  | Deficit severity halved                                   |
| 🌞 Better Solar | 500  | Solar time-of-day factor +0.35 (works later into evening) |
| 🌬️ Stable Wind  | 450  | Wind output noise reduced (0.9–1.1 instead of 0.7–1.3)    |

---

## 🎲 Random Events (every 18–26s)

| Event                 | Duration | Effect                                                                   |
| --------------------- | -------- | ------------------------------------------------------------------------ |
| ⛈️ Storm              | 20s      | Solar ×0.1, Wind ×1.8, demand +10%. Solar stock -20%, wind recharge ×1.8 |
| 🔥 Heatwave           | 18s      | Solar ×1.1, Wind ×0.7, demand +50%. Wind stock -10%, solar recharge ×1.5 |
| 🏭 Factory Boom       | 22s      | Demand +35%. Coal consumption ×1.5                                       |
| 🌱 Green Policy       | 15s      | If pollution < 40%: +150 coins, +200 score                               |
| 🌤️ Perfect Conditions | 18s      | Solar ×1.3, Wind ×1.25, demand -10%. Solar/wind recharge ×1.4            |
| 🏜️ Absolute Dryness   | 45s      | Wind gust drops to 0–5 for 45s. Demand +30%                              |
| 📈 Inflation          | 10s      | Coal price range permanently increases (+10 to min/max)                  |

---

## 🏆 Winning & Scoring

**Win**: Survive the full 6 minutes.

Per-tick score = `stability × 0.5 + satisfaction × 0.3 - pollution × 0.2` (+ streak bonuses)

**Strategy tips**:

1. Buy coal stock early — it never recharges naturally
2. Watch for night — solar stock drains without recharging
3. Keep supply ≈ demand for streak bonuses (don't overproduce)
4. Save coins for events — storms and heatwaves hit hard
5. Battery + Grid upgrades are high-priority for stability
