extends Node
class_name Player

@export_category("Variaveis")
@export var max_health: int
@export var health: int
@export var damage: int
@export var defense: int
@export var shield: int
@export var max_actions: int
@export var actions: int

@export_category("Variaveis Deck")
@export var deck_list: Array[String]

@export_category("Objetos")
@export var hud: CanvasLayer

var health_bar: TextureProgressBar = null
var action_bar: TextureProgressBar = null
var info_container: HBoxContainer = null
var attack_label = null
var defense_label = null
var modifiers_container = null


func _ready() -> void:
	init_bar()
	init_label()
	send_deck_to_battlefield()
	
	modifiers_container = hud.get_node("Modifiers")


func init_bar() -> void:
	health_bar = hud.get_node("HealthBar")
	action_bar = hud.get_node("ActionsBar")
	
	health_bar.max_value = max_health
	health_bar.value = health
	health_bar.get_node("Label").text = str(health) + " / " + str(max_health)
	
	action_bar.max_value = max_actions
	action_bar.value = actions
	action_bar.get_node("Label").text = str(actions)


func init_label() -> void:
	info_container = hud.get_node("Attack-Defense")
	attack_label = info_container.get_node("AttackIcon/Attack")
	defense_label = info_container.get_node("DefenseIcon/Defense")
	
	attack_label.text = str(damage)
	defense_label.text = str(defense)


func update_bar() -> void:
	health_bar.value = health
	health_bar.get_node("Label").text = str(health) + " / " + str(max_health)
	
	action_bar.value = actions
	action_bar.get_node("Label").text = str(actions)


func update_label() -> void:
	attack_label.text = "Atk " + str(damage)
	defense_label.text = "Def " + str(defense)


func send_deck_to_battlefield() -> void:
	var deck: Array = deck_list.duplicate()
	get_tree().call_group("player_hand", "get_player_deck", deck)


func take_damage(value: int) -> void:
	if shield > 0:
		if value <= shield:
			shield -= value
			return
			
		else:
			var leftover = value - shield
			shield = 0
			health -= leftover
			update_bar()
			return
	
	health -= value
	update_bar()


func apply_status(type: String, value: int) -> void:
	var status_instance
	
	if modifiers_container.get_child_count() <= 0:
		match type:
			"poison":
				pass
			
			"paralyzed":
				pass
			
			"block":
				status_instance = preload("res://scenes/status/block.tscn")
				shield += (value + defense)
		
		var status_scene = status_instance.instantiate()
		status_scene.status_modifier = value
		modifiers_container.add_child(status_scene)
		return
	
	# verificar se status aplicado ja existe no player
	for status in modifiers_container.get_children():
		if status.status_name == type:
			if status.status_name == "block":
				shield += (value + defense)
			else:
				status.update_durability("increase")
				
			break


func update_status() -> void:
	if modifiers_container.get_child_count() <= 0:
		return
	
	for status in modifiers_container.get_children():
		status.update_durability("decrease")


func spend_energy() -> void:
	actions -= 1
	update_bar()
