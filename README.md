# **Installation**
1. Add the script to a `CharacterBody3D`.  
2. Ensure the node contains:  
   - A **CollisionShape3D** (Capsule recommended)  
   - A **Camera3D** child (or assign one via NodePath)  
3. **Set up the required InputMap actions (see below)**.  
4. Tune behavior using the Inspector categories.
<img width="243" height="116" alt="image" src="https://github.com/user-attachments/assets/0c50a664-fb63-420d-b7f6-073b2c267ffa" />


---

# **Required Input Setup**

These InputMap actions **must be created** under:

> **Project Settings → Input Map**

| Action | Purpose |
|--------|---------|
| `ui_left` / `ui_right` | Strafe movement |
| `ui_up` / `ui_down` | Forward/back movement |
| `ui_accept` | Jump |
| `ui_cancel` | Quit |
| `sprint` | Sprint toggle |
| `walk` | Walk toggle |
| `crouch` | Crouch toggle |

All names are customizable inside the Inspector.

---

# **Inspector Options Explained**

## **Ground Physics**
Controls grounded movement.

| Setting | Description |
|--------|-------------|
| **forward_speed** | Maximum forward/back speed. |
| **strafe_speed** | Maximum left/right speed. |
| **slide** | Enables sliding inertia when releasing movement input. |
| **slide_friction** | How fast you slow down while sliding. |
| **slide_padding** | Direction-reversal responsiveness during slide. |
| **enable_acceleration** | Smooth acceleration instead of instant motion. |
| **forward_accel / strafe_accel** | Acceleration strength. |
| **direction_smoothing** | Curves target direction changes. |

---

## **Air Physics**
Controls airborne movement, including Quake/Source-style strafe mechanics.

| Setting | Description |
|--------|-------------|
| **air_control_multiplier** | 0 = no control, 1 = same as ground. |
| **preserve_air_momentum** | Higher = keep momentum (Source style). |
| **allow_air_start** | Allow gaining speed from zero in air. |
| **air_strafe_boost** | Extra accel when turning camera with strafe. |
| **air_strafe_max_mult** | Max air-strafe speed multiplier. |

---

## **Jump Settings**

| Setting | Description |
|--------|-------------|
| **jump_velocity** | Vertical jump power. |
| **enable_jump** | Toggle jumping. |
| **jump_speed_boost** | Horizontal boost when jumping. |
| **jump_buffer_time** | Jump still triggers if you press early. |
| **coyote_time** | Jump allowed briefly after leaving ground. |

---

## **Crouch Settings**

| Setting | Description |
|--------|-------------|
| **enable_crouch** | Enable/disable crouching. |
| **crouch_speed_mult** | Movement speed multiplier while crouched. |
| **crouch_accel_mult** | Acceleration multiplier. |
| **crouch_camera_offset** | Vertical camera offset while crouched. |
| **crouch_transition_speed** | Speed of crouch smoothing. |

### **Crouch Collision**
| Setting | Description |
|--------|-------------|
| **collision_shape_path** | Path to Capsule `CollisionShape3D`. |
| **standing_collider_height** | Capsule height when standing. |
| **crouch_collider_height** | Capsule height when crouched. |

Supports both **head-drop crouch** and **legs-up mid-air crouch** (camera stays stable).

---

## **Walk Settings**

| Setting | Description |
|--------|-------------|
| **enable_walk** | Enables slow walk toggle. |
| **walk_speed_mult** | Speed multiplier while walking. |
| **walk_accel_mult** | Acceleration multiplier while walking. |

---

## **Sprint Settings**

| Setting | Description |
|--------|-------------|
| **enable_sprint** | Enables sprinting. |
| **sprint_speed_mult** | Speed multiplier while sprinting. |
| **sprint_accel_mult** | Acceleration multiplier while sprinting. |

---

# **Camera Settings**

## **Mouse Look**
| Setting | Description |
|--------|-------------|
| **mouse_sensitivity** | Look sensitivity. |
| **invert_y** | Invert vertical look. |
| **max_pitch_deg** | Maximum look up/down angle. |

## **Camera Effects**
| Setting | Description |
|--------|-------------|
| **enable_bob_on_jump / land** | Camera bob effects. |
| **jump_bob_amount** | Jump dip intensity. |
| **land_bob_multiplier** | Landing dip intensity (scaled by velocity). |
| **bob_down_speed / bob_up_speed** | Bob animation speeds. |
| **enable_strafe_tilt** | Tilts camera while strafing. |
| **strafe_tilt_angle** | Maximum tilt. |
| **strafe_tilt_speed** | How fast tilt transitions. |

---

# **Input Action Settings**

| Setting | Description |
|--------|-------------|
| **move_left_action** | Left movement action. |
| **move_right_action** | Right movement action. |
| **move_forward_action** | Forward movement action. |
| **move_back_action** | Back movement action. |
| **jump_action** | Jump input action. |
| **quit_action** | Quit input action. |
| **sprint_action** | Sprint action. |
| **walk_action** | Walk action. |
| **crouch_action** | Crouch action. |
| **handle_quit_action** | Whether quit_action exits the game. |

---

# **Node References**

| Setting | Description |
|--------|-------------|
| **camera_path** | Assigned Camera3D node (auto-detects if none). |
| **capture_mouse_on_ready** | Captures mouse when scene starts. |

---

# **Movement State Enum**

Useful for animation trees or gameplay logic.

```gdscript
enum MoveState { IDLE, WALK, RUN, SPRINT, CROUCH, AIR }
```

Retrieve the current state:

```gdscript
get_move_state()
```

---

# **Signals**

| Signal | Fired When |
|--------|------------|
| **jumped** | Player jumps. |
| **landed** | Player lands from air. |
| **started_crouch / ended_crouch** | Crouch transitions. |
| **started_sprint / ended_sprint** | Sprint transitions. |
| **quit_requested** | Quit action pressed. |

---

# **Recommended Node Hierarchy**

```
CharacterBody3D
├── MeshInstance3D (Capsule)
├── CollisionShape3D (Capsule)
└── Camera3D

```

Optional:
- AnimationTree  
- Weapon models  
- Audio nodes  

---

# **🏁 Basic Usage Example**

```gdscript
extends CharacterBody3D
@onready var controller = $AdvancedController

func _physics_process(delta):
    if controller.get_move_state() == controller.MoveState.SPRINT:
        print("Sprinting!")
```

---

# **📜 License**
MIT License — free for commercial and personal use.
