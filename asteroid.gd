extends Area2D

var speed = 100
var rotation_speed = 1.0
var directionVector = Vector2.ZERO

var HEALTH = 0

var collisionPolygon2DNode: CollisionPolygon2D
var line2DNode: Line2D

func _ready():
	collisionPolygon2DNode = $CollisionPolygon2D
	line2DNode = $Line2D
	line2DNode.closed = true
	
	var size = randf_range(20, 80)

	if size < 45:
		HEALTH = 1
	elif size < 70:
		HEALTH = 2
	else:
		HEALTH = 3

	var points = []
	var segments = ceil(1.3 * sqrt(size))
	for i in range(segments):
		var angle = (TAU / segments) * i
		var distance = randf_range(0.7, 1.5) * size
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

	speed = 126 - 14 * pow(size, 0.3)

func _process(delta):
	position += directionVector * speed * delta
	rotation += rotation_speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		area.queue_free()
		HEALTH -= 1
		if HEALTH <= 0:
			queue_free()
		var points = line2DNode.points
		var new_points = []

		for point in points:
			point *= 0.9
			if randf() <= 0.75 and len(points) > 3:
				new_points.append(point)

		line2DNode.points = new_points
		collisionPolygon2DNode.polygon = new_points
