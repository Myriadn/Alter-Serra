# 🎬 Scene Transition Guide - GGJ 2026

## 📋 Overview

Proyek ini menggunakan **SceneManager** sebagai sistem utama untuk semua transisi scene. **Jangan pakai Fade langsung!**

---

## ✅ Yang Benar: Pakai SceneManager

### Autoload yang Tersedia:
- `SceneManager` - Handle semua fade & transitions ✅
- `DayManager` - Manage urutan scene per day ✅
- `Fade` - ❌ **JANGAN PAKAI LANGSUNG!** (legacy, SceneManager yang handle)

---

## 🎮 Cara Pakai SceneManager

### 1. Transisi Biasa (Night, Boss, Ending)

```gdscript
# Contoh: Door trigger, bed sleep, boss defeat, etc.
func _on_trigger():
    player.set_physics_process(false)  # Freeze player
    
    # Pakai SceneManager
    await SceneManager._change_scene("res://scenes/levels/master/day2/day2_morning.tscn")
```

**Efek:**
- Fade to black (smooth)
- Change scene
- Fade in otomatis

---

### 2. Transisi dengan Day Counter (Morning Scenes)

```gdscript
# Contoh: Tidur di bed, lanjut ke hari berikutnya
func _on_bed_sleep():
    player.set_physics_process(false)
    
    # Tampilkan "DAY 2" sebelum pindah scene
    await SceneManager._change_scene_w_day_count(
        "res://scenes/levels/master/day2/day2_morning.tscn",
        2  # Day number
    )
```

**Efek:**
1. Fade to black
2. Game pause
3. Show "DAY 2" label (2 detik)
4. Fade out label
5. Change scene
6. Game unpause
7. Fade in otomatis

---

### 3. Pakai DayManager (PALING GAMPANG!)

```gdscript
# Contoh: Automatic progression
func _on_level_complete():
    player.set_physics_process(false)
    
    # DayManager otomatis tau scene mana yang next
    DayManager.next_scene()
    
    # DayManager juga otomatis:
    # - Detect kalau morning scene → tampil day counter
    # - Track current day number
    # - Handle end game (balik ke main menu)
```

**Urutan Scene di DayManager:**
```gdscript
SCENE_ORDER = [
    "res://scenes/levels/master/day1/day1_morning.tscn",   # index 0
    "res://scenes/levels/master/day1/day1_night.tscn",     # index 1
    "res://scenes/levels/master/day2/day2_morning.tscn",   # index 2
    "res://scenes/levels/master/day2/day2_night.tscn",     # index 3
    "res://scenes/levels/master/day3/day3_boss.tscn",      # index 4
    "res://scenes/levels/master/day3/day3_morning.tscn",   # index 5
    "res://scenes/levels/master/day4/day4_boss.tscn",      # index 6
    "res://scenes/levels/master/day4/day4_ending.tscn",    # index 7
]
```

---

## 📝 Template untuk Level Scripts

### Day Morning (dengan dialog awal):

```gdscript
extends Node2D

@onready var dialog_control = $CanvasLayer/DialogueControl
@onready var level_manager = $LevelManager
@onready var player = $Player
@onready var spawn_point = $Marker2D
@onready var door_trigger = $DoorTrigger

var dialog_finished_first: bool = false
var tasks_completed: bool = false

func _ready():
    player.global_position = spawn_point.global_position
    player.set_physics_process(false)
    
    # Connect signals
    dialog_control.dialog_finished.connect(_on_dialog_finished)
    level_manager.all_tasks_completed.connect(_on_tasks_completed)
    door_trigger.body_entered.connect(_on_door_entered)
    
    # ❌ JANGAN: await Fade.fade_in(1.0)
    # ✅ SceneManager udah handle fade in otomatis!
    
    # Start dialog
    dialog_control.play_dialog("res://dialogue-data/...")

func _on_dialog_finished():
    if not dialog_finished_first:
        dialog_finished_first = true
        player.set_physics_process(true)

func _on_tasks_completed():
    tasks_completed = true
    print("✅ Tasks selesai! Bisa pergi kerja.")

func _on_door_entered(body):
    if body is Player and tasks_completed:
        player.set_physics_process(false)
        DayManager.next_scene()  # ← PALING GAMPANG!
```

---

### Day Night (dengan wardrobe & bed):

```gdscript
extends Node2D

@onready var dialog_control = $CanvasLayer/DialogueControl
@onready var level_manager = $LevelManager
@onready var player = $Player
@onready var spawn_point = $Marker2D
@onready var wardrobe = $Wardrobe
@onready var bed = $Bed

func _ready():
    player.global_position = spawn_point.global_position
    player.set_physics_process(false)
    
    # Connect signals
    dialog_control.dialog_finished.connect(_on_dialog_finished)
    level_manager.all_tasks_completed.connect(_on_tasks_completed)
    wardrobe.wardrobe_completed.connect(_on_wardrobe_completed)
    bed.sleep_started.connect(_on_bed_sleep)
    
    # ❌ JANGAN: await Fade.fade_in(1.0)
    # ✅ SceneManager udah handle!
    
    # Start dialog
    dialog_control.play_dialog("res://dialogue-data/...")

func _on_dialog_finished():
    player.set_physics_process(true)

func _on_tasks_completed():
    print("✅ Tasks selesai! Ganti baju di wardrobe.")

func _on_wardrobe_completed():
    print("👕 Ganti baju selesai! Tidur di bed.")

func _on_bed_sleep():
    player.set_physics_process(false)
    DayManager.next_scene()  # ← Auto ke next day dengan day counter!
```

---

## 🚫 JANGAN LAKUKAN INI!

### ❌ Pakai Fade langsung:
```gdscript
# SALAH! Ini bikin double fade
await Fade.fade_in(1.0)
await Fade.fade_out(1.0)
```

### ❌ Manual change_scene_to_file:
```gdscript
# SALAH! Gak ada fade effect
get_tree().change_scene_to_file("res://scenes/...")
```

### ❌ Fade in di _ready():
```gdscript
# SALAH! SceneManager udah handle fade in otomatis
func _ready():
    await Fade.fade_in(1.0)  # ← GAUSAH!
    # ...
```

---

## ✅ LAKUKAN INI!

### ✅ Pakai DayManager:
```gdscript
DayManager.next_scene()  # ← Simple & auto detect day counter
```

### ✅ Atau SceneManager langsung:
```gdscript
# Transisi biasa
await SceneManager._change_scene(path)

# Dengan day counter
await SceneManager._change_scene_w_day_count(path, day_num)
```

### ✅ Scene _ready() langsung mulai gameplay:
```gdscript
func _ready():
    # Setup player, signals, dll
    # ...
    
    # Langsung play dialog atau mulai gameplay
    # SceneManager udah handle fade in!
    dialog_control.play_dialog("res://dialogue-data/...")
```

---

## 🔧 Debug Tips

### Kalau stuck di black screen:
1. Cek console: ada error di AnimationPlayer?
2. Pastikan SceneManager autoload aktif
3. Cek animation "Fadew" ada di SceneManager scene

### Kalau gak ada fade effect:
1. Pastikan pakai SceneManager, bukan change_scene_to_file langsung
2. Cek SceneManager layer = 10 saat transition

### Kalau day counter gak muncul:
1. Cek scene path ada kata "morning"
2. Atau manual call `_change_scene_w_day_count()` dengan day number

---

## 📊 Flow Chart

```
Player Action (sleep/door/boss defeat)
    ↓
Freeze player movement
    ↓
Call DayManager.next_scene()
    ↓
DayManager detect next scene
    ↓
Is morning scene?
    ├─ YES → SceneManager._change_scene_w_day_count()
    │          ├─ Fade to black
    │          ├─ Pause game
    │          ├─ Show "DAY X"
    │          ├─ Fade out label
    │          ├─ Change scene
    │          ├─ Unpause
    │          └─ Fade in
    │
    └─ NO  → SceneManager._change_scene()
               ├─ Fade to black
               ├─ Change scene
               └─ Fade in
    ↓
New scene _ready()
    ↓
Start gameplay immediately
```

---

## 📚 Reference

- **SceneManager**: `scripts/ui_effect/screen_manager.gd`
- **DayManager**: `scripts/master/day_manager.gd`
- **Example**: `scripts/levels/day1_morning.gd`
- **Example**: `scripts/levels/day1_night.gd`

---

## 🎯 Summary

1. **Pakai DayManager.next_scene()** untuk progression normal
2. **Pakai SceneManager** kalau perlu control manual
3. **JANGAN pakai Fade langsung** di level scripts
4. **JANGAN fade_in di _ready()**, SceneManager udah handle otomatis
5. **Test dengan console output** untuk debug issues

**Happy coding! 🚀**
