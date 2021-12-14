extends KinematicBody2D
class_name Character

var velocity: Vector2 = Vector2.ZERO

export(int) var max_hp: int
var hp: int = max_hp

export(int) var strength: int

export(bool) var is_recovering: bool
export(bool) var is_dead: bool

onready var game: Game = get_node("/root/Game")


func _ready():
	hp = max_hp
	is_recovering = false
	is_dead = false

func _process(_delta):
	
	if hp > max_hp:
		hp = max_hp
	if hp <= 0:
		die()

func _physics_process(delta):

	velocity = move_and_slide(velocity)


func heal(val: int):
	hp += val
	
func damage(val: int):

	if not is_recovering:
		hp -= val
		is_recovering = true
		game.sfx_player.stream = load("res://sfx/hit.wav")
		game.sfx_player.play()
	
func die():
	queue_free()
