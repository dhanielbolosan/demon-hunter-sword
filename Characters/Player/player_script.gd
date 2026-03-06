extends CharacterBody3D

@onready var camera_rig = $CameraRig
@onready var anim_tree = $Model/AnimationTree
@onready var model = $Model

@export var blend_speed = 30

enum {IDLE, RUN}
enum {DEMON, HUNTER, SWORD}
var soul_blend_paths = {
	DEMON: ["Demon", "parameters/Demon_Blend/blend_amount"],
	HUNTER: ["Hunter", "parameters/Hunter_Blend/blend_amount"],
	SWORD: ["Sword", "parameters/Sword_Blend/blend_amount"]
}

var currAnim = IDLE
var currSoul = HUNTER
var is_switching = false

const SPEED = 10.0
var run_val = 0.0

func check_soul_switch():
	if Input.is_action_just_pressed("ui_soul_switch") and !is_switching:
		is_switching = true
		Engine.time_scale = 0.2		
		
		currSoul = (int(currSoul) + 1) % 3
		var soul_anim = soul_blend_paths[currSoul]
		
		anim_tree["parameters/Soul_Switch_Trans/transition_request"] = soul_anim[0]
		anim_tree["parameters/Soul_Switch/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		
		await get_tree().create_timer(1.0, true, false, true).timeout
		
		Engine.time_scale = 1
		is_switching = false
		
func update_anim_tree():
	var current_blend_path = soul_blend_paths[currSoul][1]
	anim_tree[current_blend_path] = run_val
	
func handle_animations(delta):
	match currAnim:
		IDLE:
			run_val = lerpf(run_val, 0, blend_speed * delta)
		RUN:
			run_val = lerpf(run_val, 1, blend_speed * delta)

func _physics_process(delta):
	update_anim_tree()
	handle_animations(delta)
	
	if is_switching:
		move_and_slide()
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()

	if direction: 
		direction = direction.rotated(Vector3.UP, camera_rig.rotation.y)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		var look_dir = global_position + direction
		model.look_at(look_dir, Vector3.UP)
		currAnim = RUN
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		currAnim = IDLE
		
	check_soul_switch()
	move_and_slide()
