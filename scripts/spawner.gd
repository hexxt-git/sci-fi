extends Node2D

var spawn_timer = Timer.new()
var asteroid = preload("res://asteroid.tscn")

var scoreUI
var wait_time = 3

func _ready() -> void:
	spawn_timer.wait_time = wait_time
	spawn_timer.one_shot = true
	spawn_timer.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	add_child(spawn_timer)
	spawn_timer.start()
	scoreUI = get_tree().root.get_node("Main").get_node("scoreUI")

func _on_spawn_timer_timeout() -> void:
	var instance = asteroid.instantiate()
	add_child(instance)
	
	var level = scoreUI.level
	wait_time = (5 - 0.6 * sqrt(level)) * 0.8

	spawn_timer.wait_time = clamp(wait_time, 1, 5)
	spawn_timer.start()
