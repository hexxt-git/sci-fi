extends Control

var current_hp: int = 5
var HeartScene = preload("res://heart.tscn")

func _ready():
	update_hearts()

func update_hearts():
	for child in get_children():
		child.queue_free()
	
	for i in range(current_hp):
		var heart = HeartScene.instantiate()
		heart.position = Vector2(i * 55 + 40, 30)
		add_child(heart)

func set_health(new_hp):
	current_hp = clamp(new_hp, 0, current_hp)
	update_hearts()
