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

var previous_damage: int = 0
var bonus_damage: float = 0.0
var is_strengthened: bool = false


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
	
	attack_label.text = str(damage)
	defense_label.text = str(defense)
	
	hud.get_node("ShieldContainer/Label").text = str(shield)
	if shield <= 0:
		hud.get_node("ShieldContainer").visible = false


func update_label() -> void:
	attack_label.text = "Atk " + str(damage)
	defense_label.text = "Def " + str(defense)


# envia o deck para o battlefield
func send_deck_to_battlefield() -> void:
	var deck: Array = deck_list.duplicate()
	get_tree().call_group("player_hand", "get_player_deck", deck)


# função que recebe o dano
func take_damage(value: int, type: String) -> void:
	if shield > 0 and type == "physical":
		if value <= shield:
			shield -= value
			update_bar()
			return
		else:
			var leftover = value - shield
			shield = 0
			health -= leftover
			update_bar()
			return
	
	health -= value
	update_bar()


# aplica o efeito da carta
func apply_card_effect(card: Control) -> void:
	if card.card_type == "defense":
		shield += (card.card_value + defense)
		hud.get_node("ShieldContainer").show()
		hud.get_node("ShieldContainer/Label").text = str(shield)
	
	if card.card_type == "effect":
		if card.card_id == "pocao_vida":
			health += 20 # na verdade é pra calcular com base na vida maxima, corrigir depois
			if health > max_health:
				health = max_health
		
		if card.card_id == "fortalecer":
			calculate_bonus_damage(card.card_value)
			apply_status(card.status_type)
			is_strengthened = true
			gain_energy(1)


# aplica o status
func apply_status(type: String) -> void:
	var status_instance
	if modifiers_container.get_child_count() <= 5:
		match type:
			"poison":
				status_instance = preload("res://scenes/status/poison.tscn")
			
			"paralyzed":
				pass
			
			"strength":
				status_instance = preload("res://scenes/status/strength.tscn")
		
		# verificar se status aplicado ja existe no player
		for status in modifiers_container.get_children():
			if status.status_name == type:
				status.update_durability("increase")
				return
		
		var status_scene = status_instance.instantiate()
		modifiers_container.add_child(status_scene)


# aplica o efeito do status
func apply_status_effect() -> void:
	if modifiers_container.get_child_count() <= 0:
		return
		
	for status in modifiers_container.get_children():
		if status.status_name == "poison":
			take_damage(calculate_status_damage("poison", status.status_modifier), "status")


# calcula o dano conforme o tipo de status
func calculate_status_damage(status: String, modifier: int) -> int:
	var status_damage
	
	if status == "poison":
		status_damage = round(max_health * modifier / 100)
	
	return status_damage


# atualiza a durabilidade do status
func update_status() -> void:
	if modifiers_container.get_child_count() <= 0:
		return
	
	for status in modifiers_container.get_children():
		status.update_durability("decrease")


func calculate_bonus_damage(damage_modifier: float) -> void:
	if not is_strengthened:
		previous_damage = damage
		bonus_damage = damage * damage_modifier / 100
		damage += round(bonus_damage)
		update_bar()


func clear_bonus_damage() -> void: # funcao chamada pelo base_status
	is_strengthened = false
	bonus_damage = 0.0
	damage = previous_damage
	update_bar()


# gasta energia
func spend_energy() -> void:
	actions -= 1
	update_bar()


# ganha energia
func gain_energy(quantity: int) -> void:
	await get_tree().create_timer(0.5).timeout
	actions += quantity
	update_bar()
