extends CharacterBody3D

const SPEED : float = 3.0
const JUMP_HEIGHT : float = 5.0

@onready var camera_pivot: Node3D = $CameraPivot
@onready var player_mesh: Node3D = $PlayerMesh
@onready var animation_player: AnimationPlayer = $PlayerMesh/AnimationPlayer

enum AnimationState {IDLE, WALK}
var animation_state : AnimationState = AnimationState.IDLE

func _process(delta : float) -> void:
	if Input.is_action_just_pressed('mouse_click'):
		animation_player.play('attack-melee-right')
	
	if not is_on_floor():
		animation_player.play('jump') #.pause('jump') .stop()
	elif animation_player.current_animation != 'attack-melee-right':
		match(animation_state):
			AnimationState.IDLE:
				animation_player.play('idle')
			AnimationState.WALK:
				animation_player.play('walk')
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed('jump') and is_on_floor():
		velocity.y = JUMP_HEIGHT
		
	var input_dir := Input.get_vector('left', 'right', 'up', 'down')
	var direction := (camera_pivot.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	if direction:
		player_mesh.basis = camera_pivot.basis
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		animation_state = AnimationState.WALK
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
		velocity.z = move_toward(velocity.z, 0.0, SPEED)
		animation_state = AnimationState.IDLE
	
	move_and_slide()
