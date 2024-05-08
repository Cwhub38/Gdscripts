extends KinematicBody2D
class_name Enemy

var hud
signal spawn_Bullet(location)
const Bullet = preload("res://Bullet.tscn")
onready var muzzle = $Muzzle
var input_vector = Vector2.ZERO
var velocity = Vector2(0,0)
export (int) var speed = 66
var color = 0
var ah = 22
var Healthh = 22

func _physics_process(delta):
	global_position.x -= speed * delta
	$Shoot.play("Shoot")

func Shoot_Bullet():
	var direction = 1 if not $Sprite.flip_h else -1
	var b = Bullet.instance()
	b.direction = direction
	get_parent().add_child(b)
	b.osition.y = position. y
	b.position.x = position. x + 25 * direction * 6

func take_damage(damage):
	ah -= 1
	$ah.text = str(ah)
	if ah <= 0:
		$AnimationPlayer.play("death")
		get_tree().change_scene("res://YouWin.tscn")

func ouch():
	take_damage(1)
	$AnimationPlayer.play("death") 
	$AnimationPlayer.play("hit")

func _on_top_checker_body_entered(body):
	if body.is_in_group("Players"):
		body.ouch()

func _on_Timer_timeout():
	queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	$Timer.start()

func _on_sides_checker_body_entered(body):
	if body.is_in_group("Players"):
		body.ouch()

