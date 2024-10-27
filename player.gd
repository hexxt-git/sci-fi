extends Area2D

const SPEED = 300.0
const ROTATION_SPEED = 2.75
const BULLET_SCENE = preload("res://bullet.tscn")
const SHOOT_COOLDOWN = 0.4
var direction = 0
var can_shoot = true
var shoot_timer = Timer.new()

var HEALTH = 3

func _ready() -> void:
	shoot_timer.wait_time = SHOOT_COOLDOWN
	shoot_timer.one_shot = true
	shoot_timer.connect("timeout", Callable(self, "_on_shoot_timer_timeout"))
	add_child(shoot_timer)

func _physics_process(delta: float) -> void:
	var velocity = Vector2(SPEED * delta, 0).rotated(rotation - PI / 2)

	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		rotation += direction * ROTATION_SPEED * delta

	if Input.is_action_pressed("ui_select") and can_shoot:
		shoot()

	position += velocity
	wrap_around_screen()

func shoot() -> void:
	can_shoot = false
	shoot_timer.start()

	var bullet = BULLET_SCENE.instantiate()
	var bullet_offset = 60 * Vector2(cos(rotation - PI / 2), sin(rotation - PI / 2))
	bullet.position = position + bullet_offset
	bullet.rotation = rotation + direction * 0.4
	get_parent().add_child(bullet)

func _on_shoot_timer_timeout() -> void:
	can_shoot = true

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


func _on_area_entered(area: Area2D) -> void:
	var groups = area.get_groups()
	if "asteroid" in groups or "bullet" in groups:
		HEALTH -= 1
		print("player hit")
		print("HEALTH:", HEALTH)
		area.queue_free()
