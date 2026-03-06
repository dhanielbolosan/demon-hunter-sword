extends CharacterBody3D

@onready var camera_rig = $CameraRig
@onready var anim_tree = $Model/AnimationTree
@onready var model = $Model

@export var blend_speed = 15

enum {IDLE, RUN}
var run_val = 0.0
var currAnim = IDLE

const SPEED = 5.0

func update_anim_tree():
	anim_tree["parameters/Run/blend_amount"] = run_val;
	
func handle_animations(delta):
	match currAnim:
		IDLE:
			run_val = lerpf(run_val, 0, blend_speed * delta)
		RUN:
			run_val = lerpf(run_val, 1, blend_speed * delta)

func _physics_process(delta):
	handle_animations(delta)
	update_anim_tree()
	
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

	move_and_slide()
