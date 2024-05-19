extends KinematicBody2D
class_name Enemy1

var hud
var coins = 0
export (int) var speed = 22
var ah = 22

func ouch():
	$AnimationPlayer.play("death")
	take_damage(1)

func _physics_process(delta):
	global_position.x -= speed * delta
 
func take_damage(damage):
	$AnimationPlayer.play("death")
	ah -= 1
	$ah.text = str(ah)
	if ah <= 1:
		$AnimationPlayer.play("death")
		queue_free()

func add_coin():
	coins = coins + 1

func _on_Timer_timeout():
	take_damage(1)

func _on_top_checker_body_entered(body):
	if body.is_in_group("Players"):
		body.ouch()

func _on_sides_checker_body_entered(body):
	if body.is_in_group("Players"):
		body.ouch()
		body.take_damage(1)
		$AnimationPlayer.play("death")


func _on_AnimationPlayer_animation_finished(anim_name):
	$Timer.start()
