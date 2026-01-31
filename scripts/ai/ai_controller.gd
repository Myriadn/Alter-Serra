extends Area2D
class_name AIController

@export var speed: float = 50.0
@export var patrol_distance: float = 100.0
@export var wait_time: float = 1.0  # Waktu tunggu di ujung patrol

var current_state: AIState.State = AIState.State.PATROL
var start_position: Vector2
var target_position: Vector2
var wait_timer: float = 0.0
var is_waiting: bool = false
var velocity: Vector2 = Vector2.ZERO

func _ready():
	start_position = global_position
	setup_patrol()
	# print("AI spawned at: ", global_position)

func _on_body_entered(body: Node2D):
	if body is Player:  # Cek apakah yang nabrak player
		print("touched")
		# Nanti bisa trigger game over / retry di sini
		trigger_game_over(body)

func trigger_game_over(player: Player):
	# Placeholder - nanti bisa panggil game manager
	print("Game over will implemented")
	# get_tree().reload_current_scene()

# Override ini di child class
func setup_patrol():
	pass

# Override ini di child class untuk movement logic
func patrol_movement(delta: float):
	pass

func _physics_process(delta: float):
	match current_state:
		AIState.State.IDLE:
			handle_idle(delta)
		AIState.State.PATROL:
			handle_patrol(delta)
		AIState.State.CHASE:
			handle_chase(delta)
		AIState.State.ATTACK:
			handle_attack(delta)

func handle_idle(delta: float):
	# Tunggu sebentar
	if is_waiting:
		wait_timer += delta
		if wait_timer >= wait_time:
			wait_timer = 0.0
			is_waiting = false
			change_state(AIState.State.PATROL)

func handle_patrol(delta: float):
	patrol_movement(delta)
	global_position += velocity * delta

func handle_chase(delta: float):
	# Untuk nanti kalo mau chase player
	pass

func handle_attack(delta: float):
	# Untuk nanti kalo mau attack
	pass

func change_state(new_state: AIState.State):
	# print("AI state changed: ", AIState.State.keys()[current_state], " -> ", AIState.State.keys()[new_state])
	current_state = new_state

func reached_target() -> bool:
	return global_position.distance_to(target_position) < 5.0

func start_waiting():
	is_waiting = true
	wait_timer = 0.0
	change_state(AIState.State.IDLE)

# Visual debug
func _draw():
	if Engine.is_editor_hint():
		return

	# Draw patrol path
	draw_line(Vector2.ZERO, to_local(target_position), Color.RED, 2.0)
	draw_circle(to_local(start_position), 5, Color.GREEN)
	draw_circle(to_local(target_position), 5, Color.RED)

func _process(_delta):
	queue_redraw()  # Update debug visualization
