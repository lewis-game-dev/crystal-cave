extends StaticBody2D


var bye = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if bye == true:
		get_parent().modulate.a8 -= 5
		if get_parent().modulate.a8 <= 0:
			get_parent().queue_free()
		$CollisionShape2D.disabled = true
