extends Character
 
class_name Player

export(float) var walk_speed: float = 100
export(float) var jump_force: float = 500

onready var animated_sprite: AnimatedSprite = get_node("AnimatedSprite")
onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
onready var raycast: RayCast2D = get_node("RayCast2D")
onready var camera: Camera2D = get_node("/root/Game/Camera2D")
onready var active_level: Level = get_node("/root/Game/Level1")
onready var sfx_player: AudioStreamPlayer = get_node("/root/Game/AudioStreamPlayer")

var player_gravity: float

func _ready():
	player_gravity = game.gravity

func _physics_process(delta):
	velocity.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")) * walk_speed

	velocity.y += player_gravity * delta
	
	#  JUMPING
	
	if Input.is_action_just_pressed("jump") and raycast.is_colliding():
		if player_gravity > 0:
			velocity.y -= jump_force
		else:
			velocity.y += jump_force
			
			
	# SHOOTING
			
	if Input.is_action_just_pressed("shoot"):
		var bullet_instance: Bullet = load("res://src/Bullet.tscn").instance()

		if animated_sprite.flip_h:
			bullet_instance.init(Vector2.LEFT, true, 1)
			bullet_instance.position = get_node("GunPoint").global_position - Vector2(14, 0)

		else:
			bullet_instance.init(Vector2.RIGHT, true, 1)
			bullet_instance.position = get_node("GunPoint").global_position
		
		game.add_child(bullet_instance)
		
		sfx_player.stream = load("res://sfx/laser.wav")
		sfx_player.play()
	# GRAVITY SWAP
		
		
	if Input.is_action_just_pressed("gravity_swap"):
		gravity_swap()


func _process(_delta):

	# Flip Sprite to face correct direction

	if velocity.x < 0 && not animated_sprite.flip_h:
		animated_sprite.flip_h = true
	elif velocity.x > 0 && animated_sprite.flip_h:
		animated_sprite.flip_h = false


	# Play correct animations

	if not raycast.is_colliding():
		if velocity.y > 0:
			animation_player.play("fall")
		else:
			animated_sprite.play("jump")
	elif abs(velocity.x) > 0.1:
		animation_player.play("walk")
	else:
		animated_sprite.play("idle")
		
		
	camera_follow()
	
func gravity_swap():
	velocity.y = 0
	player_gravity *= -1
	scale.y *= -1
	

func camera_follow():
	
	camera.position = Vector2(clamp(position.x, active_level.minimum.x, active_level.maximum.x), clamp(position.y, active_level.minimum.y, active_level.maximum.y))
