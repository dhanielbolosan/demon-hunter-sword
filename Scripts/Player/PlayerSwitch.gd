extends State
class_name PlayerSwitch

@export var player : Player

func Enter():
	# Slow time, update animation, revert time, and go back to idle
	Engine.time_scale = 0.2
	
	player.currSoul = (int(player.currSoul) + 1) % 3
	
	var transition_name = player.soul_data[player.currSoul]["anim"]
	player.anim_tree["parameters/Soul_Switch_Trans/transition_request"] = transition_name
	player.anim_tree["parameters/Soul_Switch/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	
	await get_tree().create_timer(1.0, true, false, true).timeout
	
	Engine.time_scale = 1.0
	Transitioned.emit(self, "idle")

func Physics_Update(delta: float):
	player.update_anim_tree()
	
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
		
	player.move_and_slide()
