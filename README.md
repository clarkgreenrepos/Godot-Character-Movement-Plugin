# **Advanced 3D Character Controller for Godot 4**

A fully-featured, highly-customizable **3D CharacterBody controller** for Godot 4, designed for first-person and third-person games.  
This controller supports responsive grounded motion, advanced air physics, sliding, sprinting, walking, crouching (with optional legs-up behavior), jump buffering, coyote time, camera effects, and more.

**The repository includes a complete, ready-to-use Player scene**:  
```
Player.tscn
└── CharacterBody3D (root, script attached)
    ├── MeshInstance3D (placeholder body mesh)
    ├── CollisionShape3D (capsule)
    └── Camera3D
```
Just drop the scene into your level. No other set up is needed.

<img width="262" height="133" alt="image" src="https://github.com/user-attachments/assets/067ddfc3-a95a-4af5-b434-f49a01b7595f" />


---

# **Installation**

1. Clone or download this repository.  
2. Drag `Player.tscn` into your Godot project.  
3. Place the Player scene into your game world.  
4. **Set up the required InputMap actions** (see next section).  
5. Press Play — the character is ready to move.

You may replace:
- The `MeshInstance3D` with your own model  
- The `Camera3D` with your own camera rig  
- The `CollisionShape3D` if your character requires a custom collider  

Everything else works out of the box.

---

# **Required Input Setup**

Under:

> **Project Settings → Input Map**

Create these actions:

| Action | Purpose |
|--------|---------|
| `ui_left` / `ui_right` | Strafe |
| `ui_up` / `ui_down` | Forward / backward |
| `ui_accept` | Jump |
| `ui_cancel` | Quit |
| `sprint` | Sprint toggle |
| `walk` | Walk toggle |
| `crouch` | Crouch toggle |

The controller script references these InputActions, but you can rename them in the Inspector.

---

# **Inspector Options Explained**

The controller exposes a large number of tunable variables organized into sections inside the Inspector.

---

## **Ground Physics**

| Setting | Description |
|--------|-------------|
| **forward_speed** | Desired max forward/backward velocity. |
| **strafe_speed** | Desired max left/right velocity. |
| **slide** | Enables sliding inertia after releasing movement keys. |
| **slide_friction** | How quickly sliding motion decays. |
| **slide_padding** | How decisively you can reverse direction while sliding. |
| **enable_acceleration** | Smooth acceleration toward target speed. |
| **forward_accel / strafe_accel** | Strength of acceleration forces. |
| **direction_smoothing** | Smoothly curves direction changes (0 = off). |

---

## **Air Physics**

| Setting | Description |
|--------|-------------|
| **air_control_multiplier** | Scales ground accel while airborne. |
| **preserve_air_momentum** | Source/Quake-style momentum preservation. |
| **allow_air_start** | Can begin accelerating from 0 velocity in air. |
| **air_strafe_boost** | Extra accel when turning camera into a strafe. |
| **air_strafe_max_mult** | Air-strafe max speed multiplier. |

---

## **Jump Settings**

| Setting | Description |
|--------|-------------|
| **jump_velocity** | Vertical jump speed. |
| **enable_jump** | Turns jumping on/off. |
| **jump_speed_boost** | Adds horizontal impulse when jumping. |
| **jump_buffer_time** | Allows early jump input to register. |
| **coyote_time** | Allows jump shortly after stepping off edges. |

---

## **Crouch Settings**

| Setting | Description |
|--------|-------------|
| **enable_crouch** | Toggles crouching behavior. |
| **crouch_speed_mult** | Movement speed multiplier. |
| **crouch_accel_mult** | Acceleration multiplier. |
| **crouch_camera_offset** | How far camera lowers while crouched. |
| **crouch_transition_speed** | Smoothness of crouch animation. |

### **Crouch Collision**

| Setting | Description |
|--------|-------------|
| **collision_shape_path** | Path to the capsule CollisionShape3D (auto-assigned). |
| **standing_collider_height** | Height when standing. |
| **crouch_collider_height** | Height when crouched. |

**Supports both crouch styles:**
- **Head-drops** while crouching  
- **Legs-move-up** (camera stays stable in air — realistic for jumping/falling)  

---

## **Walk Settings**
| Setting | Description |
|--------|-------------|
| **enable_walk** | Enables walk toggle. |
| **walk_speed_mult** | Walk movement speed scale. |
| **walk_accel_mult** | Walk acceleration scale. |

---

## **Sprint Settings**
| Setting | Description |
|--------|-------------|
| **enable_sprint** | Enables sprint mechanic. |
| **sprint_speed_mult** | Speed multiplier during sprint. |
| **sprint_accel_mult** | Acceleration multiplier during sprint. |

---

# **Camera Settings**

## **Mouse Look**

| Setting | Description |
|--------|-------------|
| **mouse_sensitivity** | Mouse look sensitivity. |
| **invert_y** | Invert vertical look direction. |
| **max_pitch_deg** | Limit on up/down view rotation. |

---

## **Camera Effects**

| Setting | Description |
|--------|-------------|
| **enable_bob_on_jump / land** | Camera dip when jumping/landing. |
| **jump_bob_amount** | How far the camera dips upward/downward. |
| **land_bob_multiplier** | Landing bob strength based on falling speed. |
| **bob_down_speed / bob_up_speed** | Speeds for bob animation delay. |
| **enable_strafe_tilt** | Tilt camera when strafing. |
| **strafe_tilt_angle** | Maximum tilt degree. |
| **strafe_tilt_speed** | Tilt transition speed. |

---

# **Input Action Settings**

| Setting | Description |
|--------|-------------|
| **move_left_action** | Input for moving left. |
| **move_right_action** | Input for moving right. |
| **move_forward_action** | Forward movement action. |
| **move_back_action** | Backward movement action. |
| **jump_action** | Jump action. |
| **quit_action** | Quit button. |
| **sprint_action** | Sprint toggle. |
| **walk_action** | Walk toggle. |
| **crouch_action** | Crouch toggle. |
| **handle_quit_action** | Whether quit calls `SceneTree.quit()`. |

---

# **Node References**

| Setting | Description |
|--------|-------------|
| **camera_path** | Player’s Camera3D (auto-detected). |
| **capture_mouse_on_ready** | Captures mouse when gameplay starts. |

---

# **Movement State Enum**

The controller exposes:

```gdscript
enum MoveState { IDLE, WALK, RUN, SPRINT, CROUCH, AIR }
```

Retrieve via:

```gdscript
get_move_state()
```

---

# **Signals**

| Signal | Fired When |
|--------|------------|
| **jumped** | Jump begins. |
| **landed** | Player makes contact with the ground. |
| **started_crouch / ended_crouch** | Crouch transitions. |
| **started_sprint / ended_sprint** | Sprint transitions. |
| **quit_requested** | Quit action pressed. |

---

# **Included Player Scene**

The repository includes a fully assembled player scene:

```
Player.tscn
└── CharacterBody3D
    ├── MeshInstance3D
    ├── CollisionShape3D (Capsule)
    └── Camera3D
```

The controller script is already attached, and all references are correctly assigned.

Just drag **Player.tscn** into your scene and press Play.

---

# **🏁 Usage Example**

```gdscript
extends Node3D

@onready var player = $Player

func _physics_process(delta):
    if player.get_move_state() == player.MoveState.SPRINT:
        print("Player is sprinting!")
```

---

# **📜 License**
MIT License — free for personal and commercial use.

