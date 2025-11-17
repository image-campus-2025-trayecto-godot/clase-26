class_name Idle
extends TurretState

func enter() -> void:
	agent.switch_to_idle_mode_animation()

func on_tick(delta: float) -> void:
	pass

func on_physics_tick(delta: float) -> void:
	if agent.targeted_node:
		change_state("Tracking")

func exit() -> void:
	pass
