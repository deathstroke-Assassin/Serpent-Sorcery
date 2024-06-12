extends CharacterBody2D

@onready var anim = get_node("AnimatedSprite2D")
@export var hitpoint = 10
const SPEED = 200.0
var player
var chase = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#func _ready():
#	anim.play("idle")
	
func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta
	player = get_node("../../Player/player")
	var direction = (player.position - self.position).normalized()
	# play the idle animation if not moving
	if is_on_floor() and not chase:
		#if hitpoint <= 0:
			#death()
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if hitpoint > 0:
			await anim.animation_finished
			anim.play("idle")
	# player chased by mobs and moving in a direction
	if chase:
		if direction.x > 0:
			anim.play("run")
			get_node("AnimatedSprite2D").flip_h = false
			
		elif direction.x < 0:
			anim.play("run")
			get_node("AnimatedSprite2D").flip_h = true
		velocity.x = direction.x * SPEED
		#if hitpoint <= 0:
		#	death()
		
		#if hitpoint ==  hitpoint - 1:
		#	velocity.x = 0
			#chase = false
		#	anim.play("hurt")
		#await anim.animation_finished
	else:
		velocity.x = 0
		
	move_and_slide()
	if hitpoint <= 0:
			death()


#to tell the enemy to chase the player
func _on_player_detection_body_entered(body):
	if body.name == "player" and hitpoint > 0:
		chase = true
	

func _on_player_detection_body_exited(body):
	if body.name == "player":
		chase = false
		
# play the death anim and free memmory
func death():
	velocity.x = 0
	chase = false
	anim.play("death")
	await anim.animation_finished
	queue_free()
