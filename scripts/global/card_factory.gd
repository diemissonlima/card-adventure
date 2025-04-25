extends Node
class_name CardList

var card_list: Dictionary = {
	"corte": "res://scenes/cards/corte.tscn",
	"corte_diagonal": "res://scenes/cards/corte_diagonal.tscn",
	"corte_tornado": "res://scenes/cards/corte_tornado.tscn",
	"bloquear": "res://scenes/cards/bloquear.tscn",
	"envenenar": "res://scenes/cards/envenenar.tscn"
}

var icons: Dictionary = {
	"attack": "res://assets/Environment/status_icon/ataque.png",
	"defense": "res://assets/Environment/status_icon/block.png"
}
