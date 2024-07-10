extends CharacterBody2D


@export var Speed :  float = 50.0
@export var jump_force : float = -120.0
@export var jump_time: float = 0.1 #how long spacebar is held
@export var cayote_time : float = 0.05 #how long it waits before you can jump off the edge
@export var gravity_multiplier : float = 3.0
@onready var mainSprite = $AnimatedSprite2D2




# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping : bool = false
var jump_timer : float = 0
var cayote_timer : float = 0

func fighttrigger():
	print("fight is being processed")
	  # Load the new scene
	## Change the current scene
	#get_tree().change_scene_to_file("res://scenes/fightarea.tscn")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		cayote_timer += delta
	else:
		cayote_time = 0

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or cayote_timer < cayote_time):
		velocity.y = jump_force
		is_jumping = true
	elif Input.is_action_pressed("jump") and is_jumping:
		velocity.y = jump_force
	
	if is_jumping and Input.is_action_pressed("jump") and jump_timer < jump_time:
		jump_timer += delta
	else:
		is_jumping=false
		jump_timer = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	
	#HANDLING PLAYER SPRITE FLIP 
	
	if direction>0:
		mainSprite.flip_h = false
	elif direction<0:
		mainSprite.flip_h = true
	
	
	if direction:
		velocity.x = direction * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
	move_and_slide()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	var collision = move_and_collide(velocity * delta)
	if collision:
		print("I collided with ", collision.get_collider().name)
		if collision.get_collider().name == "enemy":
			fighttrigger()


	
