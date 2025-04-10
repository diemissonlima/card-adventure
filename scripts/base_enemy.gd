extends CharacterBody2D
class_name BaseEnemy

@export_category("Variaveis")
@export var enemy_name: String
@export var max_health: int
@export var health: int
@export var damage: int

func _ready() -> void:
	get_enemy_name()


func take_damage(value: int) -> void:
	health -= value
	if health <= 0:
		kill()


func kill() -> void:
	pass


func get_enemy_name() -> void:
	var name_list = [
		"enemy 1", "enemy 2", "enemy 3", "enemy 4", "enemy 5", "enemy 6"
	]
	var index: int = randi() % name_list.size()
	enemy_name = name_list[index]
