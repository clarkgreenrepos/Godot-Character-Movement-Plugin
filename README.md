# Godot-Character-Movement-Plugin
A fully-featured, highly-customizable 3D CharacterBody controller for Godot 4.
Designed for FPS, adventure, and mobility-focused games with smooth grounded motion, advanced air physics, jump buffering, coyote time, camera effects, crouching, sprinting, and more.

This controller exposes nearly every movement behavior through the Inspector — no code modification required — making it easy to tune feel, responsiveness, and weight.

📦 Installation

Drop the script into your project (usually onto a CharacterBody3D).

Ensure the node has:

A CollisionShape3D (Capsule recommended)

A Camera3D as a child (or provide a NodePath to one)

Set your custom inputs — Required!

Tune movement behavior using the Inspector categories.

⚠️ Required Input Setup

You must create these actions under:

Project Settings → Input Map

Action	Purpose
ui_left / ui_right	Strafe movement
ui_up / ui_down	Forward/back movement
ui_accept	Jump
ui_cancel	Quit / escape
sprint	Sprint toggle (e.g. Shift)
walk	Walk toggle (e.g. Alt)
crouch	Crouch toggle (e.g. Ctrl)

All InputAction names can be replaced in the Inspector.

🧰 Inspector Options Explained

The controller organizes all tunable settings into clear categories.

🏃 Movement → Ground Physics

Controls movement on the floor.

Setting	Description
forward_speed	Max forward/back speed.
strafe_speed	Max left/right speed.
slide	Enables sliding inertia when you stop pressing movement keys.
slide_friction	How quickly you slow down while sliding.
slide_padding	Helps reverse direction while sliding; higher = snappier reversal.
enable_acceleration	If off = instant movement; if on = easing into max speed.
forward_accel / strafe_accel	Acceleration toward max speeds.
direction_smoothing	Limits how sharp direction changes are (curved movement).
🪂 Movement → Air Physics

Controls behavior while airborne — includes Quake-style strafing.

Setting	Description
air_control_multiplier	Fraction of ground control you retain in air.
preserve_air_momentum	High = strong momentum preservation (Source-engine feel).
allow_air_start	Lets you build speed from zero in air.
air_strafe_boost	Extra acceleration when turning your camera into a strafe.
air_strafe_max_mult	Speed cap multiplier for boosted air strafing.
🦘 Jump Settings
Setting	Description
jump_velocity	Vertical speed applied when jumping.
enable_jump	Turns jumping on/off.
jump_speed_boost	Adds horizontal impulse when you jump.
jump_buffer_time	Press jump slightly early and still jump.
coyote_time	Jump slightly after running off a ledge.
🧎 Crouch Settings

Controls slow movement lowering + collider resizing.

Setting	Description
enable_crouch	Toggles crouching.
crouch_speed_mult	Speed multiplier while crouched.
crouch_accel_mult	Acceleration multiplier while crouched.
crouch_camera_offset	How far camera moves down when crouched.
crouch_transition_speed	Speed of smooth crouch animation.
Crouch Collision

These settings physically shrink the character:

Setting	Description
collision_shape_path	Reference to capsule CollisionShape3D.
standing_collider_height	Capsule height while standing.
crouch_collider_height	Capsule height when crouched.

Note:
The controller supports both:

“Head goes down” crouch

“Legs go up” crouch (camera stays mostly stable mid-air)

This is automatically handled depending on the chosen logic.

🚶 Walk Settings
Setting	Description
enable_walk	Enables slower movement toggle.
walk_speed_mult	Speed multiplier for walk.
walk_accel_mult	Accel multiplier for walk.
🏃‍♂️ Sprint Settings
Setting	Description
enable_sprint	Enables sprint.
sprint_speed_mult	Speed multiplier while sprinting.
sprint_accel_mult	Accel multiplier while sprinting.
🎥 Camera Settings
Mouse Look
Setting	Description
mouse_sensitivity	Look sensitivity.
invert_y	Invert vertical movement.
max_pitch_deg	Maximum look up/down angle.
Camera Effects
Setting	Description
enable_bob_on_jump / land	Enables jump/landing camera motion.
jump_bob_amount	Amount camera dips during jump.
land_bob_multiplier	Dip amount based on landing speed.
bob_down_speed / bob_up_speed	How quickly bobbing transitions.
enable_strafe_tilt	Tilts camera while strafing.
strafe_tilt_angle	Max tilt angle.
strafe_tilt_speed	How fast tilt occurs.
🎮 Input Settings

All actions can be reassigned in the Inspector.

Setting	Description
move_left_action	InputAction for left.
move_right_action	InputAction for right.
move_forward_action	InputAction for forward.
move_back_action	InputAction for back.
jump_action	Jump button.
quit_action	Quit / escape.
sprint_action	Sprint toggle.
walk_action	Walk toggle.
crouch_action	Crouch toggle.
handle_quit_action	Whether pressing quit_action closes the game.
📡 Node References
Setting	Description
camera_path	Optional Camera3D NodePath. If empty, auto-detects child camera.
capture_mouse_on_ready	Captures mouse when the scene starts.
