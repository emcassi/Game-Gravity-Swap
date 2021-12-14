extends Enemy

var change_state_timer = rand_range(0, 4)

onready var player: Player = get_node("/root/Game/Player")

func _process(delta):


	# check if in recover or dead state
	if is_recovering:
		state = STATES.RECOVER
	elif is_dead:
		state = STATES.DEAD

	else:
		
		# Set default state in case
		state = STATES.IDLE

		if change_state_timer <= 0:
			print("CHANGE STATE")
			var i = randi() % 2
			if i == 0:
				state = STATES.IDLE
			else: 
				state = STATES.WANDER
				
			change_state_timer = rand_range(0, 4)
		

			state = STATES.CHASE

	change_state_timer -= delta

	if state == STATES.IDLE:
		animation_player.play("idle")
		
	elif state == STATES.WANDER:
		animation_player.play("move")

		var dir = randi() % 2

		if dir == 0:
			velocity = Vector2.LEFT * walk_speed
		else: 
			velocity = Vector2.RIGHT * walk_speed
	
	elif state == STATES.CHASE:
		animation_player.play("move")

		if player.position.x < position.x:
			velocity = Vector2.LEFT * walk_speed
		else: 
			velocity = Vector2.RIGHT * walk_speed
		
	elif state == STATES.RECOVER:
		animation_player.play("hit")

	elif state == STATES.DEAD:
		animation_player.play("hit")
