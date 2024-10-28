extends Button

func _ready() -> void:
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		restart_game()

func restart_game():
	var main_scene = load("res://main.tscn")
	get_tree().change_scene_to_packed(main_scene)
