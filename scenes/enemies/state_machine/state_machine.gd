class_name StateMachine
extends Node

@onready var states = get_children()
@onready var current_state = states.front() : set = change_state

@export var agent: Node3D
@export var initial_state_name: String = ""

func _ready() -> void:
	for state in states:
		state.agent = agent
		state.change_state_requested.connect(func(new_state_name: String):
			if state == current_state:
				var new_state = get_node(new_state_name)
				change_state(new_state)
		)
	if initial_state_name:
		change_state(get_node(initial_state_name))


func _process(delta: float) -> void:
	current_state.on_tick(delta)

func _physics_process(delta: float) -> void:
	current_state.on_physics_tick(delta)

func change_state(new_state):
	if current_state == new_state:
		return
	if not agent.is_node_ready():
		await agent.ready
	current_state.exit()
	current_state = new_state
	current_state.enter()
