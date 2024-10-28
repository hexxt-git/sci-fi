extends Label

var score = 0
var level = 0

func _ready() -> void:
	update_score()

func increase_score(increase: int):
	score += increase
	update_score()

func update_score():
	var cur_level = ceil(pow(score / 9923.0, 0.9) / 20 + 0.3) 
	if level != cur_level:
		play_sfx("res://sfx/level_up.wav")
	level = cur_level
	self.text = "score: %d\nlevel: %d" % [score, level]
	
func play_sfx(sound_path: String):
	var audio_player = AudioStreamPlayer.new()
	audio_player.name = "audio_player_" + str(randi())
	audio_player.stream = load(sound_path) as AudioStream
	get_parent().add_child(audio_player)
	audio_player.connect("finished", audio_player.queue_free)
	audio_player.play()
