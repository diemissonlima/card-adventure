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
	play_animation("hit")
	
	if health <= 0:
		health = 0
		kill()
	
	update_bar()


func apply_status(type: String) -> void:
	var status_quantity: int = $Modifiers.get_child_count()
	if status_quantity <= 0:
		var status_instance
		match type:
			"poison":
				status_instance = preload("res://scenes/status/poison.tscn")
			
			"paralyzed":
				status_instance = preload("res://scenes/status/poison.tscn")
		
		var status_scene = status_instance.instantiate()
		$Modifiers.add_child(status_scene)
		return
	
	for status in $Modifiers.get_children():
		if status.status_name == type:
			status.update_durability("increase")
			break


# método de morte
func kill() -> void:
	play_animation("death")


func get_enemy_name() -> void:
	var name_list = [
		"enemy 1", "enemy 2", "enemy 3", "enemy 4", "enemy 5", "enemy 6"
	]
	var index: int = randi() % name_list.size()
	enemy_name = name_list[index]


func play_animation(anim_name: String) -> void:
	animation.play(anim_name)


func _on_aux_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		queue_free()
