class_name Turret
extends Node3D

const TURRET_PROJECTILE = preload("uid://563ue053bg5k")

## Controla si las armas de la torreta deben mirar hacia el [member targeted_node] o no.
@export var weapons_track_target: bool = false
## Nodo al que apunta la torreta.
@export var targeted_node: Node3D
## Velocidad de los proyectiles que dispara la torreta.
@export var shoot_speed: float = 5.0
## Tiempo que tarda entre que empieza la animación de disparo y que el proyectil es disparado.
@export var attack_telegraph_time: float = 2.0
## Tiempo entre que un proyectil fue disparado y que comienza la animación de disparo de nuevo.
@export var time_between_shoots: float = 3.0

@onready var face: Node3D = %Face
@onready var shoot_spawn_position: Marker3D = %ShootSpawnPosition
@onready var animation_player: AnimationPlayer = $AnimationPlayer

## Método auxiliar que rota un nodo para que mire a cierto punto.
func _smoothed_look_at(node_to_rotate: Node3D, point_to_look_at: Vector3, weight: float) -> void:
	var node_transform = node_to_rotate.global_transform
	var target_transform := node_transform.looking_at(point_to_look_at)
	var new_quaternion: Quaternion = node_transform.basis.get_rotation_quaternion().slerp(target_transform.basis.get_rotation_quaternion(), weight)
	var new_transform := Transform3D(Basis(new_quaternion), node_transform.origin)
	node_to_rotate.global_transform = new_transform

func _physics_process(delta: float) -> void:
	look_at_target(delta)

func switch_to_aggresive_mode_animation():
	animation_player.play("switch_to_aggresive")

func switch_to_idle_mode_animation():
	animation_player.play_backwards("switch_to_aggresive")

## Método que mueve la "cara" y las armas de la torreta hacia el [member targeted_node] (si hay uno).
func look_at_target(delta: float):
	if targeted_node:
		var point_to_look_at := targeted_node.global_position
		_smoothed_look_at(face, point_to_look_at, 1 - pow(0.01, delta))
		if weapons_track_target:
			for weapon in face.weapons:
				_smoothed_look_at(weapon, point_to_look_at, 1 - pow(0.01, delta))

## Comienza la animación de disparo y luego de un tiempo (configurado en [member attack_telegraph_time])
## crea un proyectil que es lanzado en dirección a [member targeted_node]
func shoot():
	for weapon in face.weapons:
		weapon.play_shoot_animation()
	await get_tree().create_timer(attack_telegraph_time).timeout
	var turret_projectile = TURRET_PROJECTILE.instantiate()
	get_parent().add_child(turret_projectile)
	turret_projectile.global_position = shoot_spawn_position.global_position
	turret_projectile.direction = -face.global_basis.z
	turret_projectile.speed = shoot_speed
