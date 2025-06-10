extends CharacterBody3D

#@export var speed : float = 5.0
const SPEED : float = 3.0
const JUMP_HEIGHT : float = 5.0

#@onready var ground : Node3D = $'../Environment/Ground'
#@onready var ground : CSGBox3D = $"../Environmet/Ground"
@onready var camera_pivot: Node3D = $CameraPivot
@onready var player_mesh: MeshInstance3D = $PlayerMesh

func _process(delta : float) -> void:
	#position.x -= 0.1 * delta
	#rotation.y -= 0.1
	#scale.x += 0.1
	#transform.origin == position
	#transform.basis == basis
	pass
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed('jump') and is_on_floor():
		velocity.y = JUMP_HEIGHT
	
	#if Input.is_action_pressed('left'):
		#velocity.x = -SPEED
	#elif Input.is_action_pressed('right'):
		#velocity.x = SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0.0, SPEED)
		
	var input_dir := Input.get_vector('left', 'right', 'up', 'down')
	var direction := (camera_pivot.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()
	if direction:
		player_mesh.basis = camera_pivot.basis
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
		velocity.z = move_toward(velocity.z, 0.0, SPEED)
	
	#velocity.x -= 0.1
	move_and_slide()
	
	
	
	
	
	
	
