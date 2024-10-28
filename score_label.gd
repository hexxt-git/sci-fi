extends Label

func _ready() -> void:
	var score = get_tree().get_root().get_meta("score")
	if !score: score = 0
	self.text = "score: %d" % [score]
