playerlaser script for godpt 3.6 

extends KinematicBody2D
class_name PlayerLaser

var SPEED = 1000
var velocity = Vector2()
var direction = 1

func _ready():
	velocity.x = SPEED * direction

func _physics_process(delta):
	
	if is_on_wall():
		queue_free()
	
	velocity = move_and_slide(velocity)


func _on_PlayerLaser_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(1)
