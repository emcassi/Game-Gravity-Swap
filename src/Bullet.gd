extends KinematicBody2D
class_name Bullet

var dir: Vector2 = Vector2.ZERO
var friendly: bool
var strength: int

export(float) var speed: float

func init(dir, friendly, strength):
	self.dir = dir
	self.friendly = friendly
	self.strength = strength
	
	
func _physics_process(_delta):
	
	var collision: KinematicCollision2D = move_and_collide(dir * speed)
	
	if collision:
		if friendly:
			if collision.collider is Enemy:
				(collision.collider as Enemy).damage(strength)
#		else:
#			if collision.collider is Player:
#				pass
#				(collision.collider).damage(strength)
		queue_free()
