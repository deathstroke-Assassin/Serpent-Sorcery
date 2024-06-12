extends CharacterBody2D

@export var hitpoint = 10
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@export var isAttacking = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")
#export var bodyz = body.path
func _physics_process(delta):
	# Add the gravity."res://Player/player.tscn"
	mob = get_node("res://Enemies/karasu_e.tscn")
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and  is_on_floor():
		velocity.x = direction * SPEED
		isAttacking = false
		anim.play("run")
	if direction and  is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		anim.play("jump")
	if direction == -1:
		#get_node("AnimatedSprite2D").flip_h = true
		scale.x =  scale.y * -1
	elif  direction == 1:
		#get_node("AnimatedSprite2D").flip_h = false
		scale.x = scale.y * 1
	if direction:
		velocity.x = direction * SPEED
		
	elif not Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if isAttacking: return
		anim.play("idle")
	if velocity.y > 0:
		anim.play("fall")
	move_and_slide()
	death(self)
	
	if Input.is_action_just_pressed("melee") and is_on_floor():
		isAttacking = true
		#attack()
		anim.play("melee1")
		
		await anim.animation_finished
		isAttacking = false
		
		isAttacking = false
		hitcoll = get_node("AnimatedSprite2D/Area2D/CollisionShape2D")
	

	
var hitcoll
var mob

#func attack():
	#var overlapping_obj = $melee.get_overlapping_areas()
	#for area in overlapping_obj:
		#var parent = area.get_parent()
		#parent.queue_free()

# the damage output in animation and numerical data
func _on_melee_body_entered(body):
	if body:
		body.hitpoint -= 3
		body.chase = false
		body.anim.play("hurt")
		await anim.animation_finished
		if body.hitpoint > 0 and body:
			body.chase = true
		print(body.hitpoint)	
		


# if player fall out the world
func _on_area_2d_body_entered(body):
	if body.name == "player":
		body.hitpoint -= 9
		print(body.hitpoint)
		body.global_position = Vector2(400, 320)
		
# death returns to main menu if health is 0 or less
func death(body):
	if body.name == "player" and body.hitpoint <= 0:
		get_tree().change_scene_to_file("res://main.tscn")

