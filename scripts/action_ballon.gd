extends TextureRect
class_name ActionBallon

@export var action_info: TextureRect


func _on_mouse_entered() -> void:
	action_info.visible = true


func _on_mouse_exited() -> void:
	action_info.visible = false
