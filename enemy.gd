extends KinematicBody2D


var health = 100
var dead = false
var dead_o = false
var dir = 1
var velocity = Vector2()
var attach = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ProgressBar.value = health
	if health <= 0:
		dead = true
		
	if dead == true:
		if dead_o == false:
			$AnimationPlayer.play("dead")
			dead_o = true
			
	if dir == 2:
		dir = -1
		position.x -= 25
		
	if dir == 0:
		dir = 1
		position.x += 25
		
	velocity = Vector2()
		
	if dead == false and attach == false:
		
		if dir == 1:
			velocity.x += 150
			$CollisionShape2D.scale.x = 1
			$AnimationPlayer.play("walk")
			
		elif dir == -1:
			velocity.x -= 150
			$CollisionShape2D.scale.x = -1
			$AnimationPlayer.play("walk")
			
	move_and_slide(velocity, Vector2.UP)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "dead":
		queue_free()


func _on_Area2D_body_exited(body):
	dir += 1


func _on_attach_body_entered(body):
	if dead == false:
		$AnimationPlayer.play("attach")
		attach = true


func _on_attach_body_exited(body):
	attach = false


func _on_Area2D2_body_entered__(body):
	body.health -= 10


func _on_Area2D_body_entered(body):
	dir += 1
