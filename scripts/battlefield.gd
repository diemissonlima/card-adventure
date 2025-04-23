extends Control
class_name Battlefield

var can_click: bool = false
var target_enemy = null

@export var player: Node2D
@export var deck_size: Label
@export var discard_pile_size: Label


func _ready() -> void:
	connect_enemy_signal()


func _process(_delta: float) -> void:
	deck_size.text = str($Background/Player/PlayerHand.player_deck.size())
	discard_pile_size.text = str($Background/Player/PlayerHand.discard_pile.size())


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
		
		"technique":
			if target_enemy != null:
				perform_action_card(card, target_enemy)
			else:
				return


func perform_action_card(card, target) -> void:
	if target is BaseEnemy:
		if card.card_type == "attack":
			var damage: int = player.damage + card.card_value
			target.take_damage(damage, card.times_used)
			
		elif card.card_type == "technique":
			target.apply_status(card.status_type)
			
	elif target is Player:
		if card.card_type == "defense":
			player.apply_status(card.status_type, card.card_value)
	
	player.spend_energy() # card.card_cost
	$Background/Player/PlayerHand.discard_pile.append(card)
	card.queue_free()


func on_mouse_area_entered(enemy) -> void:
	can_click = true
	target_enemy = enemy
	enemy.show_cursor()


func on_mouse_exited() -> void:
	can_click = false
	target_enemy.hide_cursor()


func _on_end_turn_pressed() -> void:
	for card in $Background/Player/PlayerHand.get_children():
		$Background/Player/PlayerHand.discard_pile.append(card.scene_path)
		card.queue_free()
		await get_tree().create_timer(0.5).timeout
		
	for enemy in get_tree().get_nodes_in_group("enemy"):
		apply_status_effect(enemy)
		player.take_damage(enemy.damage)
		await get_tree().create_timer(0.5).timeout
	
	
	$Background/Player/PlayerHand.draw_card(4)
	player.actions = 4
	player.update_bar()
	player.update_status()


func apply_status_effect(enemy) -> void:
	var enemy_modifier = enemy.get_node("Modifiers")
	
	if enemy_modifier.get_child_count() > 0:
		for status in enemy_modifier.get_children():
			match status.status_name:
				"poison":
					enemy.take_damage(15, 1)
	
	enemy.update_status()
