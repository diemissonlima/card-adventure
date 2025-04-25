extends Control
class_name Battlefield

var can_click: bool = false
var target_enemy = null
var previous_enemy = null

@export var player: Node2D
@export var deck_size: Label
@export var discard_pile_size: Label


func _ready() -> void:
	connect_enemy_signal()


func _process(_delta: float) -> void:
	deck_size.text = str($Background/Player/PlayerHand.player_deck.size())
	discard_pile_size.text = str($Background/Player/PlayerHand.discard_pile.size())

# conecta o sinal de mouse entered e mouse exited ao inimigo
func connect_enemy_signal() -> void:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		var area: Area2D = enemy.get_node("Area")
		area.mouse_entered.connect(on_mouse_area_entered.bind(enemy))
		area.mouse_exited.connect(on_mouse_exited)


# pega a carta utilizada pelo player
func get_card_in_use(card: Control) -> void:
	if card.card_cost > player.actions or player.actions <= 0:
		return
	
	var card_used = card
	match card_used.card_type: # verifica o tipo da carta
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


# executa a ação da carta
func perform_action_card(card, target) -> void:
	if target is BaseEnemy:
		var damage: int = player.damage + card.card_value
		
		if card.card_type == "attack" and card.attack_type == "single": # ataque ao unico alvo
			target.take_damage(damage, card.times_used, "physical")
			
		elif card.card_type == "attack" and card.attack_type == "multiple": # ataque a multiplos alvos
			for enemy in get_tree().get_nodes_in_group("enemy"):
				enemy.take_damage(damage, card.times_used, "physical")
			
		elif card.card_type == "technique": # carta de tecnica
			target.apply_status(card.status_type)
			
	elif target is Player:
		if card.card_type == "defense":
			player.apply_status(card.status_type, card.card_value)
	
	player.spend_energy() # gasta uma energia 
	$Background/Player/PlayerHand.discard_pile.append(card.card_id) # descarta a carta
	card.queue_free() # deleta a carta da cena


# executa a ação do inimigo
func perform_enemy_action(enemy: BaseEnemy, action: String) -> void:
	match action:
		"defense": # se for defesa ele ganha escudo
			enemy.shield += 5
			
		"attack": # se for ataque, causa dano ao player
			player.take_damage(enemy.damage)


# função executada quando o mouse entrar na area do inimigo
func on_mouse_area_entered(enemy) -> void:
	can_click = true
	target_enemy = enemy
	enemy.show_cursor()
	
	if previous_enemy != null:
		previous_enemy.hide_cursor()


# função executada quando o mouse sair da area do inimigo
func on_mouse_exited() -> void:
	can_click = false
	previous_enemy = target_enemy


# função executada quando o player clicar no botao de finalizar turno
func _on_end_turn_pressed() -> void:
	for card in $Background/Player/PlayerHand.get_children(): # descarta as cartas restantes da mao do player
		$Background/Player/PlayerHand.discard_pile.append(card.card_id)
		card.queue_free()
		await get_tree().create_timer(0.5).timeout
		
	for enemy in get_tree().get_nodes_in_group("enemy"): # verifica cada inimigo
		enemy.apply_status_effect() # aplica status, caso tenha algum
		perform_enemy_action(enemy, enemy.get_action()) # recebe a ação e passa pra funcao de executar a ação
		await get_tree().create_timer(0.5).timeout
	
	$Background/Player/PlayerHand.draw_card(4) # compra novas cartas
	player.actions = 4 # restaura as ações do player
	player.update_bar() # atualizar a barra de status (vida/ações)
	player.update_status() # atualiza o status
