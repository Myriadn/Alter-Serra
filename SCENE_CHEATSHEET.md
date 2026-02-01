# 🎬 Scene Transition Cheat Sheet

## ⚡ Quick Reference

### Level Script Template (Copy-Paste Ready!)

```gdscript
extends Node2D

@onready var player = $Player

func _ready():
    # Setup player & signals
    player.set_physics_process(false)
    
    # ✅ NO FADE HERE! SceneManager handles it
    # Start dialog or gameplay immediately
    dialog_control.play_dialog("res://...")

func _on_level_complete():
    player.set_physics_process(false)
    DayManager.next_scene()  # ← USE THIS!
```

---

## 🚀 3 Ways to Change Scene

### 1️⃣ DayManager (RECOMMENDED)
```gdscript
DayManager.next_scene()
```
✅ Auto-detect day counter  
✅ Auto-calculate day number  
✅ Handle game completion  

---

### 2️⃣ SceneManager - Simple Fade
```gdscript
await SceneManager._change_scene("res://scenes/...")
```
✅ Use for: night scenes, boss, endings

---

### 3️⃣ SceneManager - With Day Counter
```gdscript
await SceneManager._change_scene_w_day_count("res://scenes/...", 2)
```
✅ Use for: morning scenes  
✅ Shows "DAY 2" label  

---

## ✅ DO

```gdscript
# ✅ In _ready()
func _ready():
    # Just start gameplay, no fade!
    dialog_control.play_dialog("res://...")

# ✅ When level complete
func _on_complete():
    player.set_physics_process(false)
    DayManager.next_scene()
```

---

## ❌ DON'T

```gdscript
# ❌ NO Fade in _ready()
func _ready():
    await Fade.fade_in(1.0)  # WRONG!

# ❌ NO direct scene change
func _on_complete():
    get_tree().change_scene_to_file("res://...")  # WRONG!

# ❌ NO manual Fade calls
await Fade.fade_out(1.0)  # WRONG!
```

---

## 🐛 Debug Checklist

- [ ] Using DayManager or SceneManager?
- [ ] NOT using Fade directly?
- [ ] NOT using change_scene_to_file()?
- [ ] NOT calling fade_in() in _ready()?
- [ ] Player movement frozen before transition?

---

## 📦 One-Liners

```gdscript
# Door exit
DayManager.next_scene()

# Bed sleep
DayManager.next_scene()

# Boss defeated
DayManager.next_scene()

# Bad ending
DayManager.bad_ending()
```

That's it! 🎉
