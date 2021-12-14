extends Character
class_name Enemy

enum STATES {
	IDLE,
	WANDER,
	PREPARE,
	ATTACK,
	CHASE,
	RECOVER, 
	DEAD
}

var state = STATES.IDLE
export(float) var walk_speed: float

onready var animation_player = get_node("AnimationPlayer")

func _physics_process(delta):
	velocity.y += game.gravity * delta
	
