extends Control
class_name Battlefield

var can_click: bool = false
var target_enemy = null

@export var player: Node2D


func _ready() -> void:
	connect_enemy_signal()


func connect_enemy_signal() -> void:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		var area: Area2D = enemy.get_node("Area")
		area.mouse_entered.connect(on_mouse_area_entered.bind(enemy))
		area.mouse_exited.connect(on_mouse_exited)


func get_card_in_use(card: Control) -> void:
	if card.card_cost > player.actions or player.actions <= 0:
		return
	
	var card_used = card
	match card_used.card_type:
		"attack":
			if target_enemy != null:
				perform_action_card(card, target_enemy)
			else:
				return
		
		"defense":
			perform_action_card(card, player)
		
		"buff":
			perform_action_card(card, player)
			
		"debuff":
			if target_enemy != null:
				perform_action_card(card, target_enemy)
			else:
				return


func perform_action_card(card, target) -> void:
	if target is BaseEnemy:
		if card.card_type == "attack":
			target.take_damage(card.card_value, card.times_used)
			
		elif card.card_type == "debuff":
			target.apply_status(card.status_type)
			
	elif target is Player:
		if card.card_type == "defense":
			player.apply_status(card.status_type)
	
	player.spend_energy(card.card_cost)
	card.queue_free()


func on_mouse_area_entered(enemy) -> void:
	can_click = true
	target_enemy = enemy


func on_mouse_exited() -> void:
	can_click = false
