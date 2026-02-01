# 📅 Day Flow Scripts Documentation

## 📋 Overview

Dokumentasi lengkap untuk semua script day flow (Day 1-4) sesuai GDD.

---

## 🗂️ File Structure

```
scripts/levels/
├── day1_morning.gd      ✅ (Already exists)
├── day1_night.gd        ✅ (Already exists)
├── day2_morning.gd      ✅ (New)
├── day2_night.gd        ✅ (New)
├── day3_boss.gd         ✅ (New)
├── day3_morning.gd      ✅ (New)
├── day4_boss.gd         ✅ (New)
├── day4_ending.gd       ✅ (New)
└── bad_ending.gd        ✅ (New)
```

---

## 📖 Day Flow Summary

### Day 1 - Tutorial & Introduction
- **Morning**: Serra bangun, kamar berantakan (pertama kali), beberes → pergi kerja
- **Night**: Pulang kerja, ganti baju, beberes sedikit → tidur

### Day 2 - Build Up & Choice
- **Morning**: Bangun lagi berantakan (mulai kesal), beberes → pergi kerja
- **Night**: Pulang capek, pilihan penting:
  - ✅ **Choice 1**: Coba begadang → lanjut story (good path)
  - ❌ **Choice 2**: Bodo amat → bad ending

### Day 3 - Escalation & Help
- **Boss (Tidur)**: Alter ego fight vs Serra yang tidur (boss fight 1)
- **Morning**: Bangun lelah, frustrasi, ajak teman Tarri → beberes bareng → tidur bareng

### Day 4 - Climax & Resolution
- **Boss (Tidur)**: Alter ego vs Tarri (tag game) → tertangkap → revealed
- **Ending**: Serra bangun, Tarri tunjukkan bukti foto → TAMAT

---

## 🎮 Script Details

### 1. Day 1 Morning (`day1_morning.gd`)

**Flow:**
```
Dialog Wake Up → Gameplay (beberes) → All tasks done → Dialog Go Work → Door trigger → Timeskip → Day 1 Night
```

**Key Components:**
- DialogueControl
- LevelManager (track tasks)
- DoorTrigger (Area2D)
- Player spawn di kasur

**Dialogs Needed:**
- `Dialogue - Day 1 Wake Up.json`
- `Dialogue - Day 1 Go Work.json`

**Transition:**
```gdscript
DayManager.next_scene() // → Day 1 Night
```

---

### 2. Day 1 Night (`day1_night.gd`)

**Flow:**
```
Dialog Back Home → Gameplay (beberes + ganti baju) → All tasks done → Wardrobe available → Ganti baju → Bed available → Sleep → Day 2 Morning
```

**Key Components:**
- DialogueControl
- LevelManager (track tasks)
- Wardrobe (timed interaction)
- Bed (sleep trigger)
- Player spawn di pintu

**Important Logic:**
- Tasks → Wardrobe unlocks
- Wardrobe done → Bed unlocks
- Bed NOT a task!

**Dialogs Needed:**
- `Dialogue - Day 1 Back Home.json`

**Transition:**
```gdscript
DayManager.next_scene() // → Day 2 Morning (with "DAY 2" counter)
```

---

### 3. Day 2 Morning (`day2_morning.gd`)

**Flow:**
```
"DAY 2" label → Dialog Wake Up (kesal) → Gameplay (beberes) → All tasks done → Dialog Go Work → Door trigger → Day 2 Night
```

**Key Components:**
- DialogueControl
- LevelManager (track tasks)
- DoorTrigger
- Player spawn di kasur

**Dialogs Needed:**
- `Dialogue - Day 2 Wake Up.json` (Serra kesal kamar berantakan lagi)
- `Dialogue - Day 2 Go Work.json`

**Transition:**
```gdscript
DayManager.next_scene() // → Day 2 Night
```

---

### 4. Day 2 Night (`day2_night.gd`)

**Flow:**
```
Dialog Back Home → Gameplay (beberes + ganti baju) → Wardrobe done → Dialog Choice → Branch:
  - Choice 1 (Begadang) → Dialog begadang → Bed available → Sleep → Day 3 Boss
  - Choice 2 (Bodo amat) → Bad Ending
```

**Key Components:**
- DialogueControl
- LevelManager (track tasks)
- Wardrobe
- Bed
- Choice system!

**Important Logic:**
```gdscript
func _on_choice_selected(choice_id: int):
    if choice_id == 1:
        chose_to_stay_awake = true
        // Enable bed
    elif choice_id == 2:
        chose_to_stay_awake = false
        // Trigger bad ending
```

**Dialogs Needed:**
- `Dialogue - Day 2 Back Home.json`
- `Dialogue - Day 2 Choice.json` (with 2 choices)
- `Dialogue - Day 2 Begadang.json` (optional, menceritakan ketiduran & lihat alter ego)

**Transitions:**
```gdscript
// Good path
DayManager.next_scene() // → Day 3 Boss

// Bad path
DayManager.bad_ending() // → Bad Ending scene
```

---

### 5. Day 3 Boss (`day3_boss.gd`)

**Flow:**
```
Dialog Boss Intro → Boss Fight (alter ego vs Serra tidur) → Mess up room → Boss defeated → Dialog Defeat → Day 3 Morning
```

**Key Components:**
- DialogueControl
- BossManager (custom manager untuk boss mechanics)
- AlterEgo (player character)
- Serra (boss - sleeping)
- Spawn point

**Boss Mechanics:**
- Goal: Alter ego membuat kamar berantakan
- Serra tidur adalah "boss" (bisa terbangun kalau terlalu berisik?)
- Fight selesai → Serra terbangun

**Dialogs Needed:**
- `Dialogue - Day 3 Boss Intro.json` (alter ego muncul)
- `Dialogue - Day 3 Boss Defeat.json` (Serra terbangun)

**Transition:**
```gdscript
DayManager.next_scene() // → Day 3 Morning
```

**TODO:**
- Implement BossManager
- Implement AlterEgo character controller
- Boss defeat condition logic

---

### 6. Day 3 Morning (`day3_morning.gd`)

**Flow:**
```
Dialog Wake Up (frustrasi) → Serra keluar → "Beberapa Saat Kemudian" → Dialog Friend Arrive (Serra + Tarri datang) → Gameplay (beberes bareng) → All tasks done → Dialog sleep → Bed trigger → Day 4 Boss
```

**Key Components:**
- DialogueControl
- LevelManager (track tasks)
- Door/Bed trigger
- Player spawn di kasur
- Custom transition "Beberapa Saat Kemudian"

**Important Logic:**
```gdscript
func _trigger_go_out():
    // Custom transition dengan text overlay
    // TODO: Implement custom timeskip with text
    await get_tree().create_timer(2.0).timeout
    // Friend arrives
```

**Dialogs Needed:**
- `Dialogue - Day 3 Wake Up.json` (frustrasi berat)
- `Dialogue - Day 3 Call Friend.json` (minta bantuan teman)
- `Dialogue - Day 3 Friend Arrive.json` (Serra + Tarri)

**Transition:**
```gdscript
DayManager.next_scene() // → Day 4 Boss
```

**TODO:**
- Implement custom timeskip transition dengan text overlay

---

### 7. Day 4 Boss (`day4_boss.gd`)

**Flow:**
```
Dialog Boss Intro → Tag Game (alter ego mess up room while avoiding Tarri) → Mission complete (all items messed) → Auto-caught → Dialog Caught & Reveal → Day 4 Ending
```

**Key Components:**
- DialogueControl
- BossManager (mission tracker)
- AlterEgo (player character)
- Tarri (friend - chaser AI)
- Spawn point

**Boss Mechanics:**
- Goal: Berantakin semua barang sambil hindari Tarri
- Tarri patrol/chase player
- Mission complete → auto-caught
- Caught → reveal alter ego identity

**Signals:**
```gdscript
boss_manager.mission_complete // Semua barang berantakan
boss_manager.player_caught     // Tertangkap oleh Tarri
```

**Dialogs Needed:**
- `Dialogue - Day 4 Boss Intro.json` (alter ego muncul lagi)
- `Dialogue - Day 4 Caught.json` (Tarri tangkep & reveal)

**Transition:**
```gdscript
DayManager.next_scene() // → Day 4 Ending
```

**TODO:**
- Implement BossManager dengan mission tracking
- Implement Tarri AI (patrol, chase, catch)
- Tag game mechanics

---

### 8. Day 4 Ending (`day4_ending.gd`)

**Flow:**
```
Dialog Wake Up (Tarri bangunkan Serra) → Dialog Reveal (Tarri tunjukkan bukti foto) → Dialog End (wrap up) → Credits/Main Menu
```

**Key Components:**
- DialogueControl
- Player (Serra)
- Tarri (friend)
- Spawn point di kasur

**Important Logic:**
```gdscript
func _show_ending():
    await get_tree().create_timer(2.0).timeout
    
    // Option 1: Credits
    // await SceneManager._change_scene("res://scenes/credits.tscn")
    
    // Option 2: Main Menu
    await SceneManager._change_scene("res://scenes/main menu/Main Menu.tscn")
```

**Dialogs Needed:**
- `Dialogue - Day 4 Wake Up.json` (Tarri bangunkan)
- `Dialogue - Day 4 Reveal.json` (tunjukkan bukti foto alter ego)
- `Dialogue - Day 4 End.json` (TAMAT)

**Transition:**
```gdscript
// Back to main menu or credits
await SceneManager._change_scene("res://scenes/main menu/Main Menu.tscn")
```

---

### 9. Bad Ending (`bad_ending.gd`)

**Flow:**
```
Dialog Bad Ending (Serra memilih untuk tidak peduli) → Back to Main Menu
```

**Triggered by:**
- Day 2 Night → Choice 2 ("Bodo amat lah")

**Key Components:**
- DialogueControl
- Player (optional, bisa static scene)
- Spawn point (optional)

**Dialogs Needed:**
- `Dialogue - Bad Ending.json` (Serra memilih untuk tidak peduli, kamar tetap berantakan selamanya)

**Transition:**
```gdscript
await SceneManager._change_scene("res://scenes/main menu/Main Menu.tscn")
```

---

## 🎯 Implementation Checklist

### ✅ Scripts Created
- [x] day1_morning.gd
- [x] day1_night.gd
- [x] day2_morning.gd
- [x] day2_night.gd
- [x] day3_boss.gd
- [x] day3_morning.gd
- [x] day4_boss.gd
- [x] day4_ending.gd
- [x] bad_ending.gd

### 🔨 Components to Implement
- [ ] BossManager (Day 3 & Day 4)
- [ ] AlterEgo character controller
- [ ] Tarri AI (chase/patrol/catch)
- [ ] Custom timeskip dengan text overlay
- [ ] Choice system di DialogueControl
- [ ] Boss defeat conditions
- [ ] Tag game mechanics

### 📝 Dialogs to Create
**Day 1:**
- [x] Dialogue - Day 1 Wake Up.json
- [x] Dialogue - Day 1 Go Work.json
- [x] Dialogue - Day 1 Back Home.json

**Day 2:**
- [ ] Dialogue - Day 2 Wake Up.json
- [ ] Dialogue - Day 2 Go Work.json
- [ ] Dialogue - Day 2 Back Home.json
- [ ] Dialogue - Day 2 Choice.json (with 2 choices)
- [ ] Dialogue - Day 2 Begadang.json (optional)

**Day 3:**
- [ ] Dialogue - Day 3 Boss Intro.json
- [ ] Dialogue - Day 3 Boss Defeat.json
- [ ] Dialogue - Day 3 Wake Up.json
- [ ] Dialogue - Day 3 Call Friend.json
- [ ] Dialogue - Day 3 Friend Arrive.json

**Day 4:**
- [ ] Dialogue - Day 4 Boss Intro.json
- [ ] Dialogue - Day 4 Caught.json
- [ ] Dialogue - Day 4 Wake Up.json
- [ ] Dialogue - Day 4 Reveal.json
- [ ] Dialogue - Day 4 End.json

**Bad Ending:**
- [ ] Dialogue - Bad Ending.json

### 🎨 Scenes to Create
- [ ] day2_morning.tscn
- [ ] day2_night.tscn
- [ ] day3_boss.tscn
- [ ] day3_morning.tscn
- [ ] day4_boss.tscn
- [ ] day4_ending.tscn
- [ ] bad_ending.tscn

---

## 🔧 Scene Setup Templates

### Standard Day Scene (Morning/Night)
```
Node2D (Root)
├── CanvasLayer
│   └── DialogueControl
├── LevelManager
├── Player
├── Camera2D (attached to Player)
├── Background
├── Kasur (with Marker2D spawn)
├── DoorTrigger (Area2D)
├── Wardrobe (if night)
├── Bed (if night)
└── Tasks (NODA, BARANG, BOX, RACK)
```

### Boss Scene
```
Node2D (Root)
├── CanvasLayer
│   └── DialogueControl
├── BossManager
├── AlterEgo (Player for Day 3/4)
├── Boss (Serra or room objects)
├── Friend (Tarri for Day 4)
├── Camera2D
├── Background
├── Marker2D (spawn)
└── Room objects
```

### Ending Scene
```
Node2D (Root)
├── CanvasLayer
│   └── DialogueControl
├── Player (Serra)
├── Friend (Tarri)
├── Background
├── Camera2D
├── Kasur (with Marker2D spawn)
└── Props
```

---

## 🎮 Common Patterns

### Dialog → Gameplay Pattern
```gdscript
func _ready():
    player.set_physics_process(false)
    dialog_control.dialog_finished.connect(_on_dialog_finished)
    dialog_control.play_dialog(DIALOG_PATH)

func _on_dialog_finished():
    player.set_physics_process(true)
```

### Tasks → Unlock Pattern
```gdscript
func _on_tasks_completed():
    // Unlock next interaction
    print("✅ Tasks done!")
    // Show next dialog or enable furniture
```

### Scene Transition Pattern
```gdscript
func _on_trigger():
    player.set_physics_process(false)
    DayManager.next_scene()
```

---

## 📚 References

- **Scene Transition Guide**: `SCENE_TRANSITION_GUIDE.md`
- **Scene Cheat Sheet**: `SCENE_CHEATSHEET.md`
- **GDD Flow**: `.gdd/flow.md`
- **DayManager**: `scripts/master/day_manager.gd`
- **SceneManager**: `scripts/ui_effect/screen_manager.gd`

---

## 🚀 Next Steps

1. **Create all scene files** (.tscn) with proper node structure
2. **Implement DialogueControl choice system** untuk Day 2 Night
3. **Create all dialog JSON files** sesuai list di atas
4. **Implement BossManager** untuk Day 3 & Day 4 boss fights
5. **Create AlterEgo character** (player variant untuk boss scenes)
6. **Implement Tarri AI** untuk Day 4 boss
7. **Test full game flow** dari Day 1 sampai ending
8. **Polish transitions** dan add visual effects

---

## 💡 Tips

- **Test per day**: Jangan langsung test semua, test per day dulu
- **Use debug prints**: Setiap script udah ada debug prints yang jelas
- **Scene order di DayManager**: Harus sesuai dengan urutan di `day_manager.gd`
- **Dialog paths**: Pastikan path dialog JSON benar dan file exist
- **Autoload dependencies**: Pastikan DayManager dan SceneManager aktif

---

**Happy developing! 🎉**
