extends Node
class_name Player

@export_category("Variaveis")
@export var max_health: int
@export var health: int
@export var damage: int

@export_category("Variaveis Deck")
@export var deck_list: Array[PackedScene]
@export var hand_limit: int = 7
