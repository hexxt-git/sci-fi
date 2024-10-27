extends Area2D

var speed = 450

var life_timer = Timer.new()

func _ready() -> void:
	life_timer.wait_time = 6.0
	life_timer.one_shot = true
	life_timer.connect("timeout", Callable(self, "_on_life_timer_timeout"))
	add_child(life_timer)
	life_timer.start()

func _physics_process(delta: float) -> void:
	position += Vector2(0, - speed * delta).rotated(rotation)
	wrap_around_screen()

func _on_life_timer_timeout() -> void:
	queue_free()

func wrap_around_screen() -> void:
	var screen_size = get_viewport_rect().size

	if position.x < 0:
		position.x = screen_size.x
	elif position.x > screen_size.x:
		position.x = 0

	if position.y < 0:
		position.y = screen_size.y
	elif position.y > screen_size.y:
		position.y = 0
