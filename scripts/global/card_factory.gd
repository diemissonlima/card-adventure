extends Node
class_name CardList

var card_list: Dictionary = {
	"corte": "res://scenes/cards/corte.tscn",
	"corte_diagonal": "res://scenes/cards/corte_diagonal.tscn",
	"corte_tornado": "res://scenes/cards/corte_tornado.tscn",
	"bloquear": "res://scenes/cards/bloquear.tscn",
	"envenenar": "res://scenes/cards/envenenar.tscn"
}


# intenções do inimigo aparecendo
# caixa com informação da intencao do inimigo
# valor de escudo do inimigo aparecendo para o jogador
# bug de quando o inimigo morre ainda causa dano corrigido
# intenção do inimigo de causar veneno adicionado
# dano de veneno sendo causado ao player
