extends CharacterBody2D


@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var SPEED = 50.0


func _physics_process(delta: float) -> void:
	set_nav_agent()
	move_and_slide()

var dir = Vector2.ZERO
func set_nav_agent():
	nav_agent.target_position = get_tree().get_first_node_in_group("Player").global_position
	var next_point = nav_agent.get_next_path_position()
	dir = (next_point - global_position).normalized()
	velocity = dir * SPEED
