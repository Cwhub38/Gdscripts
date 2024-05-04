extends KinematicBody2D
class_name Enemy

var hud
signal spawn_Bullet(location)
const Bullet = preload("res://Bullet.tscn")
onready var muzzle = $Muzzle
var input_vector = Vector2.ZERO
var velocity = Vector2(0,0)
export (int) var speed = 100
var color = 0
var hp = 13

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
	hp -= damage
	if hp <= 0:
		$AnimationPlayer.play("death") 
		$Explode.play()



func _on_top_checker_body_entered(body):
	$Sprite.play("squashed")
	speed = 0
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(4, false)
	$top_checker.set_collision_layer_bit(4, false)
	$top_checker.set_collision_mask_bit(0, false)
	$sides_checker.set_collision_layer_bit(4, false)
	$sides_checker.set_collision_mask_bit(0, false)

func _on_Timer_timeout():
	queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	$Timer.start()

func _on_sides_checker_body_entered(body):
	if body.get_collision_layer() == 1:
		body.take_damage(1)
	elif body.get_collision_layer() == 32:
		$AnimationPlayer.play("death")
