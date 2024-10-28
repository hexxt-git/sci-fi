extends Area2D

const SPEED = 7.0
const ROTATION_SPEED = 3
const BULLET_SCENE = preload("res://bullet.tscn")
const SHOOT_COOLDOWN = 0.3

var direction = 0
var velocity = Vector2(0, -2)
var can_shoot = true
var shoot_timer = Timer.new()

var heartsUI
var _health: int = 5
var health: int:
	set(value):
		_health = value
		heartsUI.set_health(_health)
	get:
		return _health

@onready var fire = $Fire

func _ready() -> void:
	var main_scene = get_tree().root.get_node("Main") 
	heartsUI = main_scene.get_node("heartsUI")
	
	shoot_timer.wait_time = SHOOT_COOLDOWN
	shoot_timer.one_shot = true
	shoot_timer.connect("timeout", Callable(self, "_on_shoot_timer_timeout"))
	add_child(shoot_timer)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("forward"):
		velocity += Vector2(SPEED * delta, 0).rotated(rotation - PI / 2)
		fire.visible = true
	else: fire.visible = false

	direction = Input.get_axis("left", "right")
	if direction:
		rotation += direction * ROTATION_SPEED * delta

	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

	if velocity.length() > 2.5:
		velocity *= 0.99
	position += velocity
	wrap_around_screen()

func shoot() -> void:
	play_sfx("res://sfx/shoot.wav")
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
		play_sfx("res://sfx/player_hit.wav")
		area.queue_free()
		health -= 1
	if health <= 0:
		var scoreUI = get_tree().root.get_node("Main").get_node("scoreUI")
		var score = scoreUI.score
		get_tree().get_root().set_meta("score", score)
		get_tree().change_scene_to_file("res://game_over.tscn")

func play_sfx(sound_path: String):
	var audio_player = AudioStreamPlayer.new()
	audio_player.name = "audio_player_" + str(randi())
	audio_player.stream = load(sound_path) as AudioStream
	get_parent().add_child(audio_player)
	audio_player.connect("finished", audio_player.queue_free)
	audio_player.play()
