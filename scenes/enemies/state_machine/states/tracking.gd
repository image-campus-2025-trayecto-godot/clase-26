class_name Tracking
extends TurretState

func enter() -> void:
	agent.switch_to_aggresive_mode_animation()

func on_tick(delta: float) -> void:
	agent.look_at_target(delta)

func on_physics_tick(delta: float) -> void:
	if not agent.targeted_node:
		change_state("Idle")
	elif agent.is_target_locked_on():
		change_state("ChargingAttack")

func exit() -> void:
	pass
