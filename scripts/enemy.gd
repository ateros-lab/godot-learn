extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var player: CharacterBody3D = $"../Player"

const SPEED: int = 2.0

var is_moving: bool = false
var is_player_here: bool = false

enum AnimationState {IDLE, WALK}
var animation_state: AnimationState = AnimationState.IDLE
@onready var animation_player: AnimationPlayer = $PlayerMesh/AnimationPlayer
@onready var progress_bar: ProgressBar = $SubViewport/ProgressBar

var is_enemy_dead: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if is_player_here and Input.is_action_just_pressed('mouse_click'):
		if progress_bar.value == 20:
			animation_player.play('die')
			is_enemy_dead = true
		progress_bar.value -= 20
	
	if !is_enemy_dead:
		match(animation_state):
			AnimationState.IDLE:
				animation_player.play('idle')
			AnimationState.WALK:
				animation_player.play('walk')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !is_enemy_dead:
		if is_moving:
			look_at(Vector3(player.position.x, position.y, player.position.z))
			nav.target_position = player.position
			var direction := (nav.get_next_path_position() - position).normalized()
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			animation_state = AnimationState.WALK
		else:
			velocity.x = move_toward(velocity.x, 0.0, SPEED)
			velocity.z = move_toward(velocity.z, 0.0, SPEED)
			animation_state = AnimationState.IDLE
		move_and_slide()

func _on_enemy_area_area_entered(area: Area3D) -> void:
	if area.is_in_group('player'):
		is_moving = false
		is_player_here = true


func _on_enemy_area_area_exited(area: Area3D) -> void:
	if area.is_in_group('player'):
		is_moving = true
		is_player_here = false


func _on_enemy_territory_area_entered(area: Area3D) -> void:
	if area.is_in_group('player'):
		is_moving = true


func _on_enemy_territory_area_exited(area: Area3D) -> void:
	if area.is_in_group('player'):
		is_moving = false
