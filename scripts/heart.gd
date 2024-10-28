extends Line2D

var randomRange = 5

func _ready() -> void:
	var new_points = []
	for point in self.points:
		var new_point = point + Vector2(randf_range(-1, 1), randf_range(-1, 1)) * randomRange
		new_points.append(new_point)
	self.points = new_points
