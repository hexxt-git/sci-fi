extends Line2D

var basePoints
var variation = 2
var frame = 0

func _ready() -> void:
	basePoints = self.points

func _physics_process(_delta: float) -> void:
	frame += 1
	if frame % 7 != 0: return
	var new_points = []
	for point in basePoints:
		new_points.append(point + Vector2(randf_range(-1, 1), randf_range(-1, 1)) * variation)
	self.points = new_points
