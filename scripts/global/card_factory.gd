extends Node
class_name CardList

var card_list: Dictionary = {
	"corte": "res://scenes/cards/corte.tscn",
	"corte_duplo": "res://scenes/cards/corte_duplo.tscn",
	"corte_tornado": "res://scenes/cards/corte_tornado.tscn",
	"corte_rapido": "res://scenes/cards/corte_rapido.tscn",
	"bloquear": "res://scenes/cards/bloquear.tscn",
	"envenenar": "res://scenes/cards/envenenar.tscn",
	"pocao_vida": "res://scenes/cards/pocao_vida.tscn"
}

# adicionado +2 card (corte rapido, pocao de vida)
# dano de veneno sendo calculado com base na vida maxima
# criado 3 novos inimigos
