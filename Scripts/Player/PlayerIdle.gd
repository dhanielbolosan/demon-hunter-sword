extends State
class_name PlayerIdle

@export var player : Player

func Physics_Update(delta: float):
	# Apply gravity
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	
	# Update animation
	player.run_val = lerpf(player.run_val, 0, player.blend_speed * delta)
	player.update_anim_tree()
	
	# Apply speed
	var current_speed = player.soul_data[player.currSoul]["speed"]
	player.velocity.x = move_toward(player.velocity.x, 0, current_speed)
	player.velocity.z = move_toward(player.velocity.z, 0, current_speed)
	player.move_and_slide()
	
	# Soul Switch State
	if Input.is_action_just_pressed("ui_soul_switch"):
		Transitioned.emit(self, "switch")
		return
	
	# Run State
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_dir != Vector2.ZERO:
		Transitioned.emit(self, "run")
