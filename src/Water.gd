extends Area2D

func _on_Water_body_entered(body):
	if body is Player:
		(body as Player).die()
