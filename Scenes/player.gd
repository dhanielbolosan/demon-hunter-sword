extends CharacterBody3D

const SPEED = 5.0

@onready var camera_rig = $CameraRig
@onready var model = $Model 

func _physics_process(delta):
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
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
