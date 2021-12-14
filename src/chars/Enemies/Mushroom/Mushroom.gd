extends Enemy

var change_state_timer = rand_range(0, 4)
var prepare_timer_max = 0.5
var prepare_timer = prepare_timer_max

export(float) var fire_rate = 1
var attack_timer = fire_rate

var facing_left = true

onready var player: Player = get_node("/root/Game/Player")
onready var sprite: AnimatedSprite = get_node("AnimatedSprite")

func _process(delta):
	
	if player.position.x > position.x and not sprite.flip_h:
		sprite.flip_h = true
	elif player.position.x < position.x and sprite.flip_h:
		sprite.flip_h = false

	if state == STATES.ATTACK:
		pass
	# check if in recover or dead state
	elif is_recovering:
		state = STATES.RECOVER
	elif is_dead:
		state = STATES.DEAD

	else:
		
		# Set default state in case
		state = STATES.IDLE

		if change_state_timer <= 0:
			var i = randi() % 2
			if i == 0:
				state = STATES.IDLE
			else: 
				state = STATES.PREPARE

			change_state_timer = rand_range(0, 4)
		
		if abs(position.x - player.position.x) < 150 and abs(position.y - player.position.y) < 10 :

			state = STATES.PREPARE
			

	change_state_timer -= delta
	
	if state == STATES.IDLE:
		animation_player.play("idle")

	if state == STATES.PREPARE:
		animation_player.play("attack")

		
		if(prepare_timer <= 0):
			prepare_timer = prepare_timer_max
			state = STATES.ATTACK

		prepare_timer -= delta
	
	if state == STATES.ATTACK:
		if attack_timer <= 0:
			
			animation_player.play("attack")
			
			var bullet_instance = load("res://src/Bullet.tscn").instance()
			
			if sprite.flip_h:
				bullet_instance.init(Vector2.RIGHT, false, 2)
				bullet_instance.position = get_node("SpawnPoint").global_position + Vector2(14, 0)
			else:
				bullet_instance.init(Vector2.LEFT, false, 2)
				bullet_instance.position = get_node("SpawnPoint").global_position
				
			game.add_child(bullet_instance)
			attack_timer = fire_rate
			state = STATES.IDLE
		
		attack_timer -= delta
		
	elif state == STATES.RECOVER:
		animation_player.play("hit")

	elif state == STATES.DEAD:
		animation_player.play("hit")






















