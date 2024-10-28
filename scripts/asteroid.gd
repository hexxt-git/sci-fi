extends Area2D

var speed = 100
var rotation_speed = 1.0
var directionVector = Vector2.ZERO

var MAX_HEALTH = 3
var HEALTH = 0

var collisionPolygon2DNode: CollisionPolygon2D
var line2DNode: Line2D

var scoreUI
var life_timer = Timer.new()

func _ready():
	life_timer.wait_time = 60.0
	life_timer.one_shot = true
	life_timer.connect("timeout", Callable(self, "_on_life_timer_timeout"))
	add_child(life_timer)
	life_timer.start()

	var main_scene = get_tree().root.get_node("Main") 
	scoreUI = main_scene.get_node("scoreUI")

	collisionPolygon2DNode = $CollisionPolygon2D
	line2DNode = $Line2D
	line2DNode.closed = true
	
	var size = randf_range(20, 80)

	if size < 45:
		MAX_HEALTH = 1
	elif size < 70:
		MAX_HEALTH = 2
	elif size < 76:
		MAX_HEALTH = 3
	else:
		MAX_HEALTH = 5
		size *= 1.5
	
	HEALTH = MAX_HEALTH

	var points = []
	var segments = ceil(1.4 * sqrt(size))
	for i in range(segments):
		var angle = (TAU / segments) * i
		var distance = randf_range(0.6, 1.5) * size
		points.append(Vector2(cos(angle), sin(angle)) * distance)

	collisionPolygon2DNode.polygon = points
	line2DNode.points = points
	
	var screen_size = get_viewport_rect().size
	var starting = randf_range(0, 1)
	if starting < 0.25:
		position = Vector2(randf_range(0, screen_size.x), 0)
	elif starting < 0.5:
		position = Vector2(screen_size.x, randf_range(0, screen_size.y))
	elif starting < 0.75:
		position = Vector2(randf_range(0, screen_size.x), screen_size.y)
	else:
		position = Vector2(0, randf_range(0, screen_size.y))
	directionVector = (Vector2(screen_size.x / 2, screen_size.y / 2) - position).normalized()
	position -= directionVector * 100 # outside screen

	speed = 160 - 16 * pow(size, 0.3)
	rotation_speed = speed / 120 * (randf_range(-0.1, 0.1) + 1)
	rotation_speed = rotation_speed if randf() >= 0.5 else -rotation_speed

func _process(delta):
	position += directionVector * speed * delta
	rotation += rotation_speed * delta

func _on_life_timer_timeout():
	self.queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		play_sfx("res://sfx/asteroid_hit.wav")
		area.queue_free()
		HEALTH -= 1
		if HEALTH <= 0:
			scoreUI.increase_score(pow(MAX_HEALTH, 2) * 9923)
			queue_free()
		var points = line2DNode.points
		var new_points = []

		for point in points:
			# point *= 0.9
			if randf() <= 0.65 or len(new_points) < 3:
				new_points.append(point)

		line2DNode.points = new_points
		collisionPolygon2DNode.polygon = new_points

func play_sfx(sound_path: String):
	var audio_player = AudioStreamPlayer.new()
	audio_player.name = "audio_player_" + str(randi())
	audio_player.stream = load(sound_path) as AudioStream
	get_parent().add_child(audio_player)
	audio_player.connect("finished", audio_player.queue_free)
	audio_player.play()
