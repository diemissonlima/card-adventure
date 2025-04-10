extends Control
class_name Battlefield

var can_click: bool = false
var target_enemy = null


func _ready() -> void:
	connect_enemy_signal()


func connect_enemy_signal() -> void:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		var area: Area2D = enemy.get_node("Area")
		area.mouse_entered.connect(on_mouse_area_entered.bind(enemy))
		area.mouse_exited.connect(on_mouse_exited)


func on_mouse_area_entered(enemy) -> void:
	can_click = true
	target_enemy = enemy


func on_mouse_exited() -> void:
	can_click = false
	target_enemy = null
