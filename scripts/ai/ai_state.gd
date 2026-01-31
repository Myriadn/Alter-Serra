extends Node
class_name AIState

# Base class untuk semua AI states
enum State {
	IDLE,
	PATROL,
	CHASE,  # Untuk nanti kalo mau expand
	ATTACK  # Untuk nanti kalo mau expand
}

var current_state: State = State.IDLE
var ai_controller: Node  # Reference ke AI controller
