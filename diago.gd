extends KinematicBody2D

onready var anim = $AnimationPlayer
onready var body = $CollisionShape2D

var is_shooting = false
var grav = 0
var jump_height = 400
var lock_jump = false
var health = 100#
var dead = false
var on = false
var player_active = true

export (NodePath) var molly
export (NodePath) var gordan

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	
	if health <= 2:
		dead = true
		
	if dead == true:
		if on == false:
			if get_node_or_null(molly):
				get_parent().get_node("molly").player_active = true
				player_active = false
				
		else:
			if get_node_or_null(gordan):
				get_parent().get_node("gordan").player_active = true
				player_active = false
				
		queue_free()
		on = true
	
	$icon/Node2D/ProgressBar.value = health
	
	if player_active == false:
		$icon/Node2D.hide()
	
	if dead == false and player_active == true:
		$Camera2D.current = true
		$icon/Node2D.show()
				
		if get_node_or_null(molly):
			if Input.is_action_just_pressed("2") and get_parent().get_node("molly").unlocked == true:
				get_parent().get_node("molly").player_active = true
				player_active = false
				
		if get_node_or_null(gordan):
			if Input.is_action_just_pressed("3") and get_parent().get_node("gordan").unlocked == true:
				get_parent().get_node("gordan").player_active = true
				player_active = false
	
		if Input.is_action_pressed("left"):
			velocity.x -= 150
			
			body.scale.x = -1
			
			if is_on_floor() and is_shooting == false:
				anim.play("run")
				
			elif is_on_floor() and is_shooting == true:
				anim.play("shoot_run")
				
			elif not is_on_floor() and is_shooting == false:
				anim.play("jump")
				
			else:
				anim.play("shoot_jump")
			
			
			
		elif Input.is_action_pressed("right"):
			velocity.x += 150
			
			body.scale.x = 1
			
			if is_on_floor() and is_shooting == false:
				anim.play("run")
				
			elif is_on_floor() and is_shooting == true:
				anim.play("shoot_run")
				
			elif not is_on_floor() and is_shooting == false:
				anim.play("jump")
				
			else:
				anim.play("shoot_jump")
				
		else:
			if is_shooting == false:
				if is_on_floor():
					anim.play("idle")
				else:
					anim.play("jump")
			else:
				if is_on_floor():
					anim.play("shooting_stand")
				else:
					anim.play("shoot_jump")
				
		if is_on_floor():
			grav = 0
			velocity.y = 50
			lock_jump = false
			
		if Input.is_action_pressed("jump") and lock_jump == false:
			grav = jump_height
		if Input.is_action_just_pressed("jump") and lock_jump == false:
			$CollisionShape2D/jump.play()
			
		if Input.is_action_just_released("jump") and grav > 0:
			velocity.y = 40
			grav = -30
			
		if Input.is_action_pressed("shoot"):
			is_shooting = true
			shoot()
		else:
			is_shooting = false
			
	else:
		anim.play("idle")
			
	velocity.y -= grav 
				
	if not is_on_floor():
			
			lock_jump = true
			grav -= 20
				
	move_and_slide(velocity, Vector2.UP)
	
	
func shoot():
	if $CollisionShape2D/muzle.is_colliding():
		$CollisionShape2D/muzle.get_collider().health -= 2
	if $CollisionShape2D/muzle2.is_colliding():
		$CollisionShape2D/muzle2.get_collider().bye = true
