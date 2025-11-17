extends Control

@onready var shoot_button: Button = %ShootButton
@onready var toggle_aggresive_mode: CheckButton = %ToggleAggresiveMode
@onready var toggle_player_targeted: CheckButton = %TogglePlayerTargeted
@export var turret: Turret
@export var player: Player
@onready var go_to_tracking_state_button: Button = %GoToTrackingStateButton

func _ready() -> void:
	toggle_player_targeted.toggled.connect(self.on_player_targeted_toggled)
	toggle_aggresive_mode.toggled.connect(self.on_aggresive_mode_toggled)
	shoot_button.pressed.connect(self.on_shoot_button_pressed)
	go_to_tracking_state_button.pressed.connect(self.on_tracking_state_button_pressed)

func on_aggresive_mode_toggled(is_checked):
	if is_checked:
		turret.switch_to_aggresive_mode_animation()
	else:
		turret.switch_to_idle_mode_animation()

func on_player_targeted_toggled(is_checked):
	if is_checked:
		turret.targeted_node = player
	else:
		turret.targeted_node = null

func on_shoot_button_pressed():
	turret.shoot()

func on_tracking_state_button_pressed():
	turret.get_node("StateMachine").current_state = turret.get_node("StateMachine/Tracking")
