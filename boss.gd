extends KinematicBody2D

var attach = false
var speed = 50
var move = false
var health = 750
var dead = false
var dead_on = false

onready var anim = $CollisionShape2D/AnimationPlayer

export (NodePath) var diago
export (NodePath) var molly
export (NodePath) var gordan
export (NodePath) var pos_en 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target
	var velocity = Vector2()
	get_parent().get_node("ProgressBar").value = health
	
	if get_parent().get_node("ProgressBar").value <= 0:
		dead = true
		attach = false
		move = false
	
	if dead == false:
		
		if get_node_or_null(diago):
			if get_parent().get_node("diago").player_active == true:
				target = get_parent().get_node("diago").position
			
		if get_node_or_null(gordan):
			if get_parent().get_node("gordan").player_active == true:
				target = get_parent().get_node("gordan").position
			
		if get_node_or_null(molly):
			if get_parent().get_node("molly").player_active == true:
				target = get_parent().get_node("molly").position
		
		if move == true:
			look_at(target)
				
			velocity += transform.x.normalized() * 100
				
		if move == false and attach == true:
			anim.play("attach")
				
		move_and_slide(velocity, Vector2.UP)
		
	if dead == true:
		if dead_on == false:
			anim.play("dead")


func _on_Area2D_body_entered(body):
	move = false
	attach = true


func _on_Area2D_body_exited(body):
	move = true
	attach = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attach" and attach == false:
		anim.play("idle")
		
	if anim_name == "dead":
		queue_free()


func _on_attach_body_entered(body):
	body.health -= 5


func _on_Area2D_body_entered_start(body):
	$enter.queue_free()
	move = true


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "dead":
		dead_on = true
