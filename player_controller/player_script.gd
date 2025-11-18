extends CharacterBody3D

signal jumped
signal landed
signal quit_requested
signal started_crouch
signal ended_crouch
signal started_sprint
signal ended_sprint

# Simple movement state enum for animation/state machines
enum MoveState { IDLE, WALK, RUN, SPRINT, CROUCH, AIR }

# -----------------------------
# Movement settings
# -----------------------------
@export_category("Movement")

# -------------------------------------------------
# Ground Physics
# -------------------------------------------------
@export_group("Ground Physics")
## Max speed when moving forward/back.
@export var forward_speed: float = 5.0

## Max speed when strafing left/right.
@export var strafe_speed: float = 5.0

## If true, releasing movement keys will cause the character to slide instead of stopping instantly.
@export var slide: bool = false

## How quickly velocity slows down when sliding. Higher = stops sooner.
@export var slide_friction: float = 1.0

## How quickly the character can reverse direction while sliding. Higher = faster reversal; lower = heavier feel.
@export var slide_padding: float = 20.0

## If true, apply forward/strafe acceleration buildup. If false, movement is instant to max speed.
@export var enable_acceleration: bool = false

## How fast you accelerate toward forward_speed (on ground).
@export var forward_accel: float = 40.0

## How fast you accelerate toward strafe_speed (on ground).
@export var strafe_accel: float = 40.0

## How quickly movement direction can rotate toward input, in degrees/second.
## 0 = no smoothing (instant), lower values = slower, smoother turns.
@export_range(0.0, 720.0, 5.0)
var direction_smoothing: float = 0.0




# -------------------------------------------------
# Air Physics
# -------------------------------------------------
@export_group("Air Physics")
## Multiplier for control while in the air (0 = no standard air control, 1 = same as ground).
@export var air_control_multiplier: float = 0.3

## Air momentum preservation factor: 0 = almost no ability to fight momentum, 1 = strong preserve-air behavior.
@export_range(0.0, 1.0, 0.05)
var preserve_air_momentum: float = 1.0

## If true, allows building horizontal speed in air even from standstill when preserving air momentum.
@export var allow_air_start: bool = true

## Extra acceleration when air-strafing and turning the camera in the same direction (Quake/CS style).
@export var air_strafe_boost: float = 10.0

## Max speed multiplier for air-strafe boost, relative to strafe_speed.
@export var air_strafe_max_mult: float = 1.5


# -------------------------------------------------
# Jump
# -------------------------------------------------
@export_group("Jump")
## Vertical velocity applied when jumping from the ground.
@export var jump_velocity: float = 4.5

## If false, jumping is disabled entirely.
@export var enable_jump: bool = true

## Extra horizontal speed added in your movement direction when you press jump (on ground).
@export var jump_speed_boost: float = 0.0

## How long (in seconds) a jump input is buffered while in the air (0 = no buffering).
@export var jump_buffer_time: float = 0.15

## How long after leaving the ground you can still jump (coyote time).
@export var coyote_time: float = 0.08


# -------------------------------------------------
# Crouch
# -------------------------------------------------
@export_group("Crouch")
## If true, crouching is enabled.
@export var enable_crouch: bool = true

## Multiplier applied to forward/strafe speed while crouched.
@export var crouch_speed_mult: float = 0.5

## Multiplier applied to forward/strafe accel while crouched.
@export var crouch_accel_mult: float = 0.8

## How far the camera moves down when crouched (relative to standing).
@export var crouch_camera_offset: float = -0.6

## How fast the camera transitions between standing and crouching.
@export var crouch_transition_speed: float = 10.0

@export_group("Crouch Collision")
## Collision shape used for crouching (e.g. a CapsuleShape3D).
@export var collision_shape_path: NodePath

## Standing collider height (for a CapsuleShape3D).
@export var standing_collider_height: float = 1.6

## Crouched collider height.
@export var crouch_collider_height: float = 1.0

@onready var collider: CollisionShape3D = get_node_or_null(collision_shape_path)




# -------------------------------------------------
# Walk
# -------------------------------------------------
@export_group("Walk")
## If true, walking (slow move) is enabled.
@export var enable_walk: bool = true

## Multiplier applied to forward/strafe speed while walking.
@export var walk_speed_mult: float = 0.5

## Multiplier applied to forward/strafe accel while walking.
@export var walk_accel_mult: float = 0.7


# -------------------------------------------------
# Sprint
# -------------------------------------------------
@export_group("Sprint")
## If true, sprinting is enabled.
@export var enable_sprint: bool = true

## Multiplier applied to forward/strafe speed while sprinting.
@export var sprint_speed_mult: float = 1.4

## Multiplier applied to forward/strafe accel while sprinting.
@export var sprint_accel_mult: float = 1.2



# -----------------------------
# Mouse look & Camera
# -----------------------------
@export_category("Camera")

@export_group("Mouse Look")
## How fast the camera rotates when moving the mouse.
@export var mouse_sensitivity: float = 0.003

## If true, vertical mouse movement is inverted.
@export var invert_y: bool = false

## Maximum up/down look angle for the camera (in degrees).
@export_range(0.0, 89.0, 0.1)
var max_pitch_deg: float = 80.0


@export_group("Camera Effects")
## If true, camera bobs when jumping.
@export var enable_bob_on_jump: bool = true

## If true, camera bobs when landing.
@export var enable_bob_on_land: bool = true

## How far the camera moves down when bobbing on jump (in local units).
@export var jump_bob_amount: float = 0.1

## Multiplier for landing bob based on impact speed (downward velocity).
@export var land_bob_multiplier: float = 0.02

## How fast the camera moves downward when bobbing.
@export var bob_down_speed: float = 20.0

## How fast the camera returns upward after the bob.
@export var bob_up_speed: float = 10.0

## If true, tilts the camera when strafing.
@export var enable_strafe_tilt: bool = true

## Maximum tilt angle (in degrees) when fully strafing left/right.
@export var strafe_tilt_angle: float = 5.0

## How fast the camera tilts toward the target angle.
@export var strafe_tilt_speed: float = 8.0



# -----------------------------
# Input action names
# -----------------------------
@export_category("Input")
@export_group("Input Actions")

## Input action for moving left.
@export var move_left_action: StringName = "ui_left"

## Input action for moving right.
@export var move_right_action: StringName = "ui_right"

## Input action for moving forward.
@export var move_forward_action: StringName = "ui_up"

## Input action for moving backward.
@export var move_back_action: StringName = "ui_down"

## Input action used to jump.
@export var jump_action: StringName = "ui_accept"

## Input action that quits the game.
@export var quit_action: StringName = "ui_cancel"

## Input action used to sprint (e.g. Shift).
@export var sprint_action: StringName = "sprint"

## Input action used to walk/slow move (e.g. Alt).
@export var walk_action: StringName = "walk"

## Input action used to crouch (e.g. Ctrl).
@export var crouch_action: StringName = "crouch"

## If true, this script will actually quit the tree when quit_action is pressed.
@export var handle_quit_action: bool = false



# -----------------------------
# Node references
# -----------------------------
@export_category("Nodes")
@export_group("Nodes")

## Optional Camera3D node used for look direction. If empty, tries to find a child Camera3D.
@export var camera_path: NodePath

@onready var cam: Camera3D = get_node_or_null(camera_path)

## If true, capture mouse when this node is ready.
@export var capture_mouse_on_ready: bool = true



# -----------------------------
# Runtime state (not exported)
# -----------------------------
var pitch: float = 0.0
var cam_default_pos: Vector3 = Vector3.ZERO
var cam_bob_offset: float = 0.0
var cam_bob_target: float = 0.0
var cam_tilt: float = 0.0
var cam_tilt_target: float = 0.0
var last_yaw: float = 0.0
var last_vertical_velocity: float = 0.0
var crouch_amount: float = 0.0  # 0 = standing, 1 = fully crouched

# Jump input buffer timer (seconds remaining in buffer).
var jump_buffer_timer: float = 0.0

# Coyote time timer (seconds since leaving the ground where jump is still allowed).
var coyote_timer: float = 0.0

# State for signals / movement state
var is_sprinting_state: bool = false
var is_walking_state: bool = false
var is_crouching_state: bool = false
var prev_is_sprinting: bool = false
var prev_is_crouching: bool = false


func _ready() -> void:
	# Auto camera fallback
	if cam == null and has_node("Camera3D"):
		cam = $Camera3D

	if cam:
		cam_default_pos = cam.position

	if capture_mouse_on_ready:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	last_yaw = rotation.y


func _input(event: InputEvent) -> void:
	# Quit on escape (or whatever quit_action is bound to)
	if event.is_action_pressed(quit_action):
		if handle_quit_action:
			get_tree().quit()
		emit_signal("quit_requested")

	# Mouse look
	if event is InputEventMouseMotion:
		# Horizontal (yaw)
		rotation.y -= event.relative.x * mouse_sensitivity

		# Vertical (pitch)
		var y_mult: float = 1.0 if invert_y else -1.0
		pitch += event.relative.y * mouse_sensitivity * y_mult

		pitch = clamp(
			pitch,
			deg_to_rad(-max_pitch_deg),
			deg_to_rad(max_pitch_deg)
		)

		if cam:
			var cam_rot := cam.rotation
			cam_rot.x = pitch
			# z tilt is handled by strafe tilt logic
			cam.rotation = cam_rot


func _physics_process(delta: float) -> void:
	# Floor state and vertical velocity at the *start* of the frame
	var on_floor_before: bool = is_on_floor()
	last_vertical_velocity = velocity.y

	# Update coyote timer
	if on_floor_before:
		coyote_timer = coyote_time
	else:
		if coyote_timer > 0.0:
			coyote_timer = max(coyote_timer - delta, 0.0)

	# Decrease jump buffer timer
	if jump_buffer_timer > 0.0:
		jump_buffer_timer -= delta
		if jump_buffer_timer < 0.0:
			jump_buffer_timer = 0.0

	# Did the player press jump this frame?
	var jump_pressed: bool = Input.is_action_just_pressed(jump_action)

	# Yaw delta for CS-style air-strafing
	var yaw_delta: float = rotation.y - last_yaw
	last_yaw = rotation.y

	# Gravity
	if not on_floor_before:
		velocity += get_gravity() * delta

	# Get movement input (X = left/right, Y = forward/back)
	var input_dir: Vector2 = Input.get_vector(
		move_left_action,
		move_right_action,
		move_forward_action,
		move_back_action
	)

	# Local basis on XZ plane
	var basis := transform.basis

	var forward: Vector3 = basis.z
	forward.y = 0.0
	forward = forward.normalized()

	var right: Vector3 = basis.x
	right.y = 0.0
	right = right.normalized()

	# -----------------------------
	# State resolution: sprint / walk / crouch
	# -----------------------------
	var is_sprinting: bool = false
	var is_walking: bool = false
	var is_crouching: bool = false

	if enable_walk and Input.is_action_pressed(walk_action):
		is_walking = true

	if enable_crouch and Input.is_action_pressed(crouch_action):
		is_crouching = true

	if enable_sprint and on_floor_before:
		if Input.is_action_pressed(sprint_action) and input_dir.length() > 0.1 and input_dir.y < 0.0:
			is_sprinting = true

	# Do not allow sprint and walk at the same time; walking takes priority if both pressed
	if is_walking:
		is_sprinting = false
	# If crouching, usually you also don't sprint
	if is_crouching:
		is_sprinting = false

	# Store states for signals/move state
	is_sprinting_state = is_sprinting
	is_walking_state = is_walking
	is_crouching_state = is_crouching

	# Signals for crouch/sprint transitions
	if is_crouching_state and not prev_is_crouching:
		emit_signal("started_crouch")
		print("crouching")
	elif not is_crouching_state and prev_is_crouching:
		emit_signal("ended_crouch")

	if is_sprinting_state and not prev_is_sprinting:
		emit_signal("started_sprint")
	elif not is_sprinting_state and prev_is_sprinting:
		emit_signal("ended_sprint")

	prev_is_crouching = is_crouching_state
	prev_is_sprinting = is_sprinting_state

	# Combined state multipliers for speed/accel
	var state_speed_mult: float = 1.0
	var state_accel_mult: float = 1.0

	if is_walking:
		state_speed_mult *= walk_speed_mult
		state_accel_mult *= walk_accel_mult

	if is_crouching:
		state_speed_mult *= crouch_speed_mult
		state_accel_mult *= crouch_accel_mult

	if is_sprinting:
		state_speed_mult *= sprint_speed_mult
		state_accel_mult *= sprint_accel_mult

	# -----------------------------
	# Jump (with optional speed boost + input buffer + coyote time)
	# -----------------------------
	# If jump pressed while in the air, start/refresh the buffer timer
	if jump_pressed and not on_floor_before and jump_buffer_time > 0.0:
		jump_buffer_timer = jump_buffer_time

	var grounded_like: bool = on_floor_before or coyote_timer > 0.0

	# Can we actually perform a jump this frame?
	var should_jump: bool = false
	if enable_jump and grounded_like:
		if jump_pressed:
			should_jump = true
		elif jump_buffer_timer > 0.0:
			should_jump = true

	if should_jump:
		# Consume timers
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

		velocity.y = jump_velocity
		emit_signal("jumped")

		# Horizontal boost in current move direction
		if jump_speed_boost != 0.0:
			var move_dir: Vector3 = (right * input_dir.x + forward * input_dir.y).normalized()
			if move_dir.length() > 0.0:
				velocity.x += move_dir.x * jump_speed_boost
				velocity.z += move_dir.z * jump_speed_boost

		if enable_bob_on_jump and cam:
			cam_bob_target = -jump_bob_amount

	# Current horizontal velocity in world space (before this frame's input changes)
	var horiz_vel_before: Vector3 = Vector3(velocity.x, 0.0, velocity.z)

	# Decompose into local forward/right components
	var v_forward: float = horiz_vel_before.dot(forward)
	var v_right: float = horiz_vel_before.dot(right)

	# Input along each local axis
	var input_forward: float = input_dir.y   # up = -1, down = 1
	var input_right: float = input_dir.x     # left/right

	# Ground vs air control scaling (for standard accel/friction)
	var accel_fwd: float = forward_accel * state_accel_mult
	var accel_right: float = strafe_accel * state_accel_mult
	var friction: float = slide_friction
	var reverse_accel: float = slide_padding

	# State-scaled speed caps
	var max_forward_speed: float = forward_speed * state_speed_mult
	var max_strafe_speed: float = strafe_speed * state_speed_mult

	if not on_floor_before:
		accel_fwd *= air_control_multiplier
		accel_right *= air_control_multiplier
		friction *= air_control_multiplier
		reverse_accel *= air_control_multiplier

	# Are we using "preserve air momentum" behavior this frame?
	var preserving_air: bool = (not on_floor_before and preserve_air_momentum > 0.0)

	# -------------------------
	# Movement resolution
	# -------------------------
	if slide:
		if preserving_air:
			# -------------------------
			# PRESERVE AIR MOMENTUM MODE (SLIDE)
			# -------------------------
			var eff_reverse: float = reverse_accel * preserve_air_momentum

			# ---- Forward axis (in air) ----
			if abs(input_forward) > 0.001:
				var target_fwd_air: float = max_forward_speed * input_forward
				var reversing_fwd_air: bool = (v_forward != 0.0 and sign(v_forward) != sign(target_fwd_air))
				if reversing_fwd_air and eff_reverse > 0.0:
					# Only allow change when input opposes current velocity
					v_forward = move_toward(v_forward, target_fwd_air, eff_reverse * delta)
				elif allow_air_start and abs(v_forward) < 0.01 and accel_fwd > 0.0:
					# From near standstill, allow building speed in air
					v_forward = move_toward(v_forward, target_fwd_air, accel_fwd * delta)
			# No input: keep v_forward

			# ---- Right axis (in air, with CS-style strafe) ----
			if abs(input_right) > 0.001:
				var target_right_air: float = max_strafe_speed * input_right
				var reversing_right_air: bool = (v_right != 0.0 and sign(v_right) != sign(target_right_air))
				if reversing_right_air and eff_reverse > 0.0:
					# Allow fighting momentum with opposite input
					v_right = move_toward(v_right, target_right_air, eff_reverse * delta)
				else:
					var did_boost: bool = false
					# Same-direction air control: CS-style air-strafe boost
					if air_strafe_boost > 0.0 and air_strafe_max_mult > 1.0 and yaw_delta != 0.0:
						if sign(yaw_delta) == sign(input_right):
							var boost_dir: float = sign(input_right)
							var max_air_speed: float = max_strafe_speed * air_strafe_max_mult
							var target_boost: float = max_air_speed * boost_dir
							var eff_boost: float = air_strafe_boost * preserve_air_momentum
							v_right = move_toward(v_right, target_boost, eff_boost * delta)
							did_boost = true
					# If no boost happened and we're near standstill, allow starting movement in air
					if not did_boost and allow_air_start and abs(v_right) < 0.01 and accel_right > 0.0:
						v_right = move_toward(v_right, target_right_air, accel_right * delta)
			# No input: preserve v_right
		else:
			# -------------------------
			# NORMAL SLIDE BEHAVIOR (GROUND / NON-PRESERVING AIR)
			# -------------------------
			# ---- Forward axis ----
			if abs(input_forward) > 0.001:
				var target_fwd: float = max_forward_speed * input_forward
				var reversing_fwd: bool = (v_forward != 0.0 and sign(v_forward) != sign(target_fwd))
				if reversing_fwd and reverse_accel > 0.0:
					# Use slide padding while changing direction
					v_forward = move_toward(v_forward, target_fwd, reverse_accel * delta)
				else:
					if enable_acceleration and accel_fwd > 0.0:
						v_forward = move_toward(v_forward, target_fwd, accel_fwd * delta)
					else:
						v_forward = target_fwd
			else:
				# No forward input: apply slide friction
				v_forward = move_toward(v_forward, 0.0, friction * delta)

			# ---- Right axis ----
			if abs(input_right) > 0.001:
				var target_right: float = max_strafe_speed * input_right
				var reversing_right: bool = (v_right != 0.0 and sign(v_right) != sign(target_right))
				if reversing_right and reverse_accel > 0.0:
					# Use slide padding while changing direction
					v_right = move_toward(v_right, target_right, reverse_accel * delta)
				else:
					if enable_acceleration and accel_right > 0.0:
						v_right = move_toward(v_right, target_right, accel_right * delta)
					else:
						v_right = target_right
			else:
				# No right input: apply slide friction
				v_right = move_toward(v_right, 0.0, friction * delta)
	else:
		# -------------------------
		# NO-SLIDE BRANCH
		# -------------------------
		if preserving_air:
			# PRESERVE AIR MOMENTUM MODE (NO SLIDE)
			var eff_reverse_ns: float = reverse_accel * preserve_air_momentum

			if abs(input_forward) > 0.001:
				var target_fwd_air_ns: float = max_forward_speed * input_forward
				var reversing_fwd_air_ns: bool = (v_forward != 0.0 and sign(v_forward) != sign(target_fwd_air_ns))
				if reversing_fwd_air_ns and eff_reverse_ns > 0.0:
					v_forward = move_toward(v_forward, target_fwd_air_ns, eff_reverse_ns * delta)
				elif allow_air_start and abs(v_forward) < 0.01 and accel_fwd > 0.0:
					# From standstill in air, allow building speed
					v_forward = move_toward(v_forward, target_fwd_air_ns, accel_fwd * delta)

			if abs(input_right) > 0.001:
				var target_right_air_ns: float = max_strafe_speed * input_right
				var reversing_right_air_ns: bool = (v_right != 0.0 and sign(v_right) != sign(target_right_air_ns))
				if reversing_right_air_ns and eff_reverse_ns > 0.0:
					v_right = move_toward(v_right, target_right_air_ns, eff_reverse_ns * delta)
				elif allow_air_start and abs(v_right) < 0.01 and accel_right > 0.0:
					# From standstill in air, allow building speed
					v_right = move_toward(v_right, target_right_air_ns, accel_right * delta)
		else:
			# Normal no-slide accel
			if abs(input_forward) > 0.001:
				var target_fwd_ns: float = max_forward_speed * input_forward
				if enable_acceleration and accel_fwd > 0.0:
					v_forward = move_toward(v_forward, target_fwd_ns, accel_fwd * delta)
				else:
					v_forward = target_fwd_ns
			else:
				v_forward = 0.0

			if abs(input_right) > 0.001:
				var target_right_ns: float = max_strafe_speed * input_right
				if enable_acceleration and accel_right > 0.0:
					v_right = move_toward(v_right, target_right_ns, accel_right * delta)
				else:
					v_right = target_right_ns
			else:
				v_right = 0.0

	# Deadzone tiny values to avoid micro-drift
	if abs(v_forward) < 0.01:
		v_forward = 0.0
	if abs(v_right) < 0.01:
		v_right = 0.0

	# Rebuild target world-space horizontal velocity from local components
	var horiz_vel_target: Vector3 = forward * v_forward + right * v_right

	# Optional direction smoothing: makes changes in movement direction more curved
	if direction_smoothing > 0.0 \
			and horiz_vel_before.length() > 0.01 \
			and horiz_vel_target.length() > 0.01:

		var cur_dir: Vector3 = horiz_vel_before.normalized()
		var target_dir: Vector3 = horiz_vel_target.normalized()

		# If trying to go in the opposite direction (angle > 90°),
		# don't smooth — snap so you can actually reverse.
		if cur_dir.dot(target_dir) < 0.0:
			velocity.x = horiz_vel_target.x
			velocity.z = horiz_vel_target.z
		else:
			var angle: float = cur_dir.angle_to(target_dir)

			# direction_smoothing is in degrees/second; convert to radians/frame
			var max_angle: float = deg_to_rad(direction_smoothing) * delta

			if angle > max_angle and angle > 0.0001:
				var t: float = max_angle / angle
				var new_dir: Vector3 = (cur_dir.lerp(target_dir, t)).normalized()
				var target_speed: float = horiz_vel_target.length()
				var smoothed: Vector3 = new_dir * target_speed
				velocity.x = smoothed.x
				velocity.z = smoothed.z
			else:
				# Target is within our max turn this frame; just go there
				velocity.x = horiz_vel_target.x
				velocity.z = horiz_vel_target.z
	else:
		# No smoothing or no meaningful velocity: just use target
		velocity.x = horiz_vel_target.x
		velocity.z = horiz_vel_target.z


	move_and_slide()

	# New floor state AFTER moving
	var on_floor_after: bool = is_on_floor()

	# Landing detection with velocity-based bob
	if cam and enable_bob_on_land and (not on_floor_before) and on_floor_after:
		var impact_speed: float = max(0.0, -last_vertical_velocity)  # downward speed before impact
		var bob_amount: float = impact_speed * land_bob_multiplier
		if bob_amount > 0.0:
			cam_bob_target = -bob_amount
		emit_signal("landed")

	# Camera jump/land bob smoothing (separate down/up speeds)
	if cam and (enable_bob_on_jump or enable_bob_on_land):
		if cam_bob_target < 0.0:
			cam_bob_offset = move_toward(cam_bob_offset, cam_bob_target, bob_down_speed * delta)
			if abs(cam_bob_offset - cam_bob_target) < 0.01:
				cam_bob_target = 0.0
		else:
			cam_bob_offset = move_toward(cam_bob_offset, 0.0, bob_up_speed * delta)

	# --- CROUCH LOGIC (always runs, independent of camera/bob) ---
	# Crouch smoothing value (0 = stand, 1 = crouch)
	var crouch_target: float = 1.0 if is_crouching_state else 0.0
	crouch_amount = move_toward(crouch_amount, crouch_target, crouch_transition_speed * delta)

	# Adjust collider height so "legs go up" instead of head going down
	if collider and collider.shape is CapsuleShape3D:
		var cap := collider.shape as CapsuleShape3D

		# Lerp between standing and crouched heights
		cap.height = lerp(standing_collider_height, crouch_collider_height, crouch_amount)

		# Optional: keep feet on the ground by adjusting the collider's local Y.
		# This assumes the CharacterBody3D origin is at the feet.
		var total_height := cap.height + cap.radius * 2.0
		collider.position.y = total_height * 0.5

	# --- CAMERA vertical effects (default + bob ONLY) ---
	if cam:
		var cam_pos := cam.position

		# Only apply crouch camera offset when on the ground
		var crouch_view_factor: float = crouch_amount if on_floor_after else 0.0

		cam_pos.y = cam_default_pos.y \
			+ cam_bob_offset \
			+ crouch_view_factor * crouch_camera_offset
		cam.position = cam_pos

		# Camera strafe tilt smoothing
		if enable_strafe_tilt:
			var tilt_deg: float = -input_dir.x * strafe_tilt_angle
			cam_tilt_target = deg_to_rad(tilt_deg)
		else:
			cam_tilt_target = 0.0

		cam_tilt = move_toward(cam_tilt, cam_tilt_target, strafe_tilt_speed * delta)

		var cam_rot := cam.rotation
		cam_rot.z = cam_tilt
		cam.rotation = cam_rot


		# Camera strafe tilt smoothing
		if enable_strafe_tilt:
			var tilt_deg: float = -input_dir.x * strafe_tilt_angle
			cam_tilt_target = deg_to_rad(tilt_deg)
		else:
			cam_tilt_target = 0.0

		cam_tilt = move_toward(cam_tilt, cam_tilt_target, strafe_tilt_speed * delta)

		# Camera strafe tilt smoothing
		if enable_strafe_tilt:
			var tilt_deg: float = -input_dir.x * strafe_tilt_angle
			cam_tilt_target = deg_to_rad(tilt_deg)
		else:
			cam_tilt_target = 0.0

		cam_tilt = move_toward(cam_tilt, cam_tilt_target, strafe_tilt_speed * delta)


# Public helper for animation/state machines
func get_move_state() -> int:
	if not is_on_floor():
		return MoveState.AIR

	if is_crouching_state:
		return MoveState.CROUCH
	if is_sprinting_state:
		return MoveState.SPRINT

	var input_dir: Vector2 = Input.get_vector(
		move_left_action,
		move_right_action,
		move_forward_action,
		move_back_action
	)

	if input_dir.length() < 0.1:
		return MoveState.IDLE

	if is_walking_state:
		return MoveState.WALK

	return MoveState.RUN
