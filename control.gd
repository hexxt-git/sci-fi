extends Control

export var max_hp: int = 5  # Total hearts
var current_hp: int = max_hp  # Current health

# Call this to add hearts when the scene starts
func _ready():
	update_hearts()

# Updates the hearts display based on `current_hp`
func update_hearts():
	# Clear any existing hearts
	for child in get_children():
		child.queue_free()
	
	# Add a Line2D node for each heart
	for i in range(max_hp):
		var heart = Line2D.new()
		heart.points = get_heart_points()  # Custom function to get heart shape
		heart.width = 3
		heart.default_color = Color(1, 0, 0) if i < current_hp else Color(0.5, 0.5, 0.5, 0.5)  # Grey out if missing
		heart.position = Vector2(i * 20, 0)  # Adjust spacing between hearts
		add_child(heart)

# Set health and update hearts
func set_health(new_hp):
	current_hp = clamp(new_hp, 0, max_hp)
	update_hearts()

# Function to get points for a heart shape
func get_heart_points():
	return [
		Vector2(0, 0), Vector2(5, -5), Vector2(10, 0),
		Vector2(5, 5), Vector2(0, 10),
		Vector2(-5, 5), Vector2(-10, 0), Vector2(-5, -5),
		Vector2(0, 0)
	]
