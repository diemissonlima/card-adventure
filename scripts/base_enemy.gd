extends CharacterBody2D
class_name BaseEnemy

@export_category("Objetos")
@export var health_bar: TextureProgressBar
@export var health_bar_label: Label
@export var animation: AnimationPlayer
@export var modifiers_container: HBoxContainer

@export_category("Variaveis")
@export var enemy_name: String
@export var max_health: int
@export var health: int
@export var damage: int
@export var shield: int


func _ready() -> void:
	get_enemy_name()
	init_bar()


# inicializa a barra de vida
func init_bar() -> void:
	health_bar.max_value = max_health
	health_bar.value = health
	health_bar_label.text = str(health) + " / " + str(max_health)


# atualiza a barra de vida
func update_bar() -> void:
	health_bar.value = health
	health_bar_label.text = str(health) + " / " + str(max_health)


# recebe o dano do player
func take_damage(damage: int, times_used: int) -> void:
	var new_damage: int = damage * times_used
	health -= new_damage
	animation.play("hit")
	
	if health <= 0:
		health = 0
		kill()
	
	update_bar()


func apply_status(type: String) -> void:
	var target = null
	
	for status in modifiers_container.get_children():
		if status.texture == null:
			target = status
			break
	
	match type:
		"poison":
			target.texture = load("res://assets/Environment/status_icon/poison.png")
			target.show()
		
		"paralyzed":
			target.texture = load("res://assets/Environment/status_icon/paralysis.png")
			target.show()


# método de morte
func kill() -> void:
	animation.play("death")


func get_enemy_name() -> void:
	var name_list = [
		"enemy 1", "enemy 2", "enemy 3", "enemy 4", "enemy 5", "enemy 6"
	]
	var index: int = randi() % name_list.size()
	enemy_name = name_list[index]


func _on_aux_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		queue_free()
