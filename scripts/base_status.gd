extends TextureRect
class_name BaseStatus

@export_category("Variaveis")
@export var status_name: String
@export var status_modifier: int
@export var status_durability: int
@export var status_description: String

@export_category("Objetos")
@export var durability_label: Label


func _ready() -> void:
	durability_label.text = str(status_durability)


func update_durability(type: String) -> void:
	match type:
		"increase":
			status_durability += 1
			
		"decrease":
			status_durability -= 1
	
	if status_durability <= 0:
		queue_free()
		return
	
	durability_label.text = str(status_durability)
