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
@export var deck_list: Array[PackedScene]
@export var hand_limit: int = 4

@export_category("Objetos")
@export var hud: CanvasLayer

var health_bar: TextureProgressBar = null
var action_bar: TextureProgressBar = null
var info_container: HBoxContainer = null
var attack_label = null
var defense_label = null


func _ready() -> void:
	init_bar()
	init_label()


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
	attack_label = info_container.get_node("Attack")
	defense_label = info_container.get_node("Defense")
	
	attack_label.text = "Atk " + str(damage)
	defense_label.text = "Def " + str(defense)


func update_bar() -> void:
	health_bar.value = health
	health_bar.get_node("Label").text = str(health) + " / " + str(max_health)
	
	action_bar.value = actions
	action_bar.get_node("Label").text = str(actions)


func update_label() -> void:
	attack_label.text = "Atk " + str(damage)
	defense_label.text = "Def " + str(defense)


func take_damage(damage: int) -> void:
	health -= damage
	update_bar()


func apply_status(type: String) -> void:
	var modifiers_container = hud.get_node("Modifiers")
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
		
		"block":
			target.texture = load("res://assets/Environment/status_icon/block.png")
			target.show()


func spend_energy(card_cost: int) -> void:
	actions -= card_cost
	update_bar()
