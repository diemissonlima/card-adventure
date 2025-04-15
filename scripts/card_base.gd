extends Control
class_name CardBase

@export_category("Variaveis")
@export var card_name: String
@export var card_value: int
@export var times_used: int
@export_enum("attack", "defense", "technique") var card_type: String
@export_enum("null", "block", "poison", "paralyzed", "bleed") var status_type: String

var can_click: bool = false

func _ready() -> void:
	$Background/BoxName/Name.text = card_name


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action") and can_click:
		get_tree().call_group("battlefield", "get_card_in_use", self)


func _on_area_mouse_entered() -> void:
	can_click = true
	self.position.y = - 50.0


func _on_area_mouse_exited() -> void:
	can_click = false
	self.position.y = 0
