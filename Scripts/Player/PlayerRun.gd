extends State
class_name PlayerRun

@export var player : Player

func Physics_Update(delta: float):
	# Apply gravity
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	
	# Update animation
	player.run_val = lerpf(player.run_val, 1, player.blend_speed * delta)
	player.update_anim_tree()
	
	# Soul Switch State
	if Input.is_action_just_pressed("ui_soul_switch"):
		Transitioned.emit(self, "switch")
		return
	
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Idle State
	if input_dir == Vector2.ZERO:
		Transitioned.emit(self, "idle")
		return
	
	# Apply direction, speed, and model
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	direction = direction.rotated(Vector3.UP, player.camera_rig.rotation.y)
	
	var current_speed = player.soul_data[player.currSoul]["speed"]
	
	player.velocity.x = direction.x * current_speed
	player.velocity.z = direction.z * current_speed
	
	var look_dir = player.global_position + direction
	player.model.look_at(look_dir, Vector3.UP)
	
	player.move_and_slide()
