extends CharacterBody3D

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.8
const SENSITIVITY = 0.004

#bob variables
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

@onready var camera = $Head/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
		# Handle Sprint.
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
		
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("ui_left", "ui_rght", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
		
		# Head bob
		t_bob += delta * velocity.length() * float(is_on_floor())
		camera.transform.origin = _headbob(t_bob)
		
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		$AnimationPlayer.play("shoot")
	if Input.is_action_just_pressed("drawsniper"):
		$AnimationPlayer.play("drawsniper")
	if Input.is_action_just_pressed("knifedraw"):
		$AnimationPlayer.play("knifedraw")
	if Input.is_action_just_pressed("knifestab"):
		$AnimationPlayer.play("knifestab")
	if Input.is_action_just_pressed("putawaysniper"):
		$AnimationPlayer.play("putawaysniper")
	if Input.is_action_just_pressed("zoom"):
		$AnimationPlayer.play("zoom")
	if Input.is_action_just_pressed("zoomout"):
		$AnimationPlayer.play("zoomout")
	if Input.is_action_just_pressed("drawpistol"):
		$AnimationPlayer.play("drawpistol")
	if Input.is_action_just_pressed("putawaypistol"):
		$AnimationPlayer.play("putawaypistol")

func shoot():
	$AnimationPlayer.play("shoot")

func drawsniper():
	$AnimationPlayer.play("drawsniper")

func knifedraw():
	$AnimationPlayer.play("knifedraw")

func knifestab():
	$AnimationPlayer.play("knifestab")

func putawaysniper():
	$AnimationPlayer.play("putawaysniper")

func zoom():
	$AnimationPlayer.play("zoomout")

func zoomout():
	$AnimationPlayer.play("zoomout")

func drawpistol():
	$AnimationPlayer.play("drawpistol")

func putawaypistol():
	$AnimationPlayer.play("putawaypistol")
