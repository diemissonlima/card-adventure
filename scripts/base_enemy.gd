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
@export var actions: Array[String]


func _ready() -> void:
	get_enemy_name()
	init_bar()
	get_action()


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
func take_damage(value: int, times_used: int, damage_type: String) -> void:
	var new_damage: int = value * times_used
	
	if shield > 0 and damage_type == "physical": # se tiver escudo e o ataque for fisico
		if new_damage <= shield: # dano menor ou igual ao escudo
			shield -= new_damage
			return
			
		else: # dano maior que o escudo
			var leftover = new_damage - shield
			shield = 0
			health -= leftover
			play_animation("hit")
			
			if health <= 0:
				health = 0
				kill()
				
			update_bar()
			return
	
	# dano aplicado normal, sem a influencia do escudo
	health -= new_damage
	play_animation("hit")
	
	if health <= 0:
		health = 0
		kill()
	
	update_bar()


# mostra o status no modifiers_container
func apply_status(type: String) -> void:
	var status_quantity: int = $Modifiers.get_child_count()
	if status_quantity <= 0: # se nao tiver nenhum status adiciona o atual
		var status_instance
		match type:
			"poison":
				status_instance = preload("res://scenes/status/poison.tscn")
			
			"paralyzed":
				status_instance = preload("res://scenes/status/poison.tscn")
		
		var status_scene = status_instance.instantiate()
		$Modifiers.add_child(status_scene)
		return
	
	# caso ja exista algum status, verifica se o status em questao igual ao status aplicado
	for status in $Modifiers.get_children():
		if status.status_name == type:
			status.update_durability("increase")
			break


# aplicado o efeito do status
func apply_status_effect() -> void:
	if modifiers_container.get_child_count() > 0:
		for status in modifiers_container.get_children():
			match status.status_name:
				"poison":
					take_damage(15, 1, "status")
	
	update_status()


# randomiza a ação que será tomada
func get_action() -> String:
	var action = actions[randi() % actions.size()]
	$ActionBallon/Icon.texture = load(CardFactory.icons[action])
	$ActionBallon.show()
	return action


# atualiza o status 
func update_status() -> void:
	if modifiers_container.get_child_count() <= 0:
		return
	
	for status in modifiers_container.get_children():
		status.update_durability("decrease")


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


func show_cursor() -> void:
	$HealthBar/Cursor.visible = true


func hide_cursor() -> void:
	$HealthBar/Cursor.visible = false


func _on_aux_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		queue_free()
