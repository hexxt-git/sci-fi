extends Node2D


var spawn_timer = Timer.new()
var asteroid = preload("res://asteroid.tscn")

func _ready() -> void:
	spawn_timer.wait_time = 3.0
	spawn_timer.one_shot = false
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	add_child(spawn_timer)
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	var instance = asteroid.instantiate()
	add_child(instance)
