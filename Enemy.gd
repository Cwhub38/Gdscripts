extends KinematicBody2D
class_name Enemy

var hud
signal spawn_Bullet(location)
const Bullet = preload("res://Bullet.tscn")
onready var muzzle = $Muzzle
var input_vector = Vector2.ZERO
var velocity = Vector2(0,0)
export (int) var speed = 1000
var color = 0
var ah = 10
var direction = 1

func _physics_process(delta):
	velocity.x = -speed * direction
	$Shoot.play("Shoot")

func Shoot_Bullet():
	var direction = 1 if not $Sprite.flip_h else -1
	var b = Bullet.instance()
	b.direction = direction
	get_parent().add_child(b)
	b.osition.y = position. y
	b.position.x = position. x + 25 * direction * 6

func take_damage(damage):
	$AnimationPlayer.play("death") 
	$AnimationPlayer.play("hit")
	ah -= 1
	$ah.text = str(ah)
	if ah <= 1:
		$AnimationPlayer.play("death")
		get_tree().change_scene("res://YouWin.tscn")

func ouch():
	Global.lose_life()
	Global.lives = -1
	if Global.lives <= 1:
		died()
		$AnimationPlayer.play("death") 
	$AnimationPlayer.play("hit")
	take_damage(1)

func _on_top_checker_body_entered(body):
	if body.is_in_group("Players"):
		body.ouch()

func _on_Timer_timeout():
	ouch()

func _on_AnimationPlayer_animation_finished(anim_name):
	$Timer.start()

func _on_sides_checker_body_entered(body):
	if body.get_collision_layer() == 1:
		body.ouch()
	Shoot_Bullet()
	if body.get_collision_layer == 32:
		$AnimationPlayer.play("hit")
		set_modulate(Color(0.3,0.3,0.3,0.3))
	if Global.lives <= 1:
		$Timer.start()

func died():
	Global.lives == 0
