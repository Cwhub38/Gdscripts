extends KinematicBody2D
class_name Player

signal spawn_laser(location)
onready var muzzle = $Muzzle 
const Player_Laser = preload("res://PlayerLaser.tscn")
var SPEED = 210
var velocity = Vector2(0,0)
var input_vector = Vector2.ZERO
var coins = 0
enum States {AIR = 1, FLOOR}
var state = States.AIR
const RUNSPEED = 7000
const JUMPFORCE = -1100
const GRAVITY = 75
var hp = 30

func _physics_process(delta):
	match state:
		States.AIR:
			if is_on_floor():
				state = States.FLOOR
				continue
			$Sprite.play("air")
			if Input.is_action_pressed("move_right"):
				if Input.is_action_pressed("run"):
					velocity.x = RUNSPEED
				else:
					velocity.x = SPEED
				$Sprite.flip_h = false
			elif Input.is_action_pressed("move_left"):
				if Input.is_action_pressed("run"):
					velocity. x = -RUNSPEED
				else:
					velocity.x = -SPEED
				$Sprite.flip_h = true
			else:
				velocity.x = lerp(velocity.x,0,0.2)
			move_and_fall()
			if Input.is_action_just_pressed("jump"):
						velocity.y = JUMPFORCE
			
		States.FLOOR:
			if not is_on_floor():
				state = States.AIR
			if Input.is_action_pressed("move_right"):
				if Input.is_action_pressed("run"):
					velocity.x = RUNSPEED
				else:
					velocity.x -= SPEED
					$Sprite.play("walk")
					$Sprite.flip_h = false
			elif Input.is_action_pressed("move_left"):
				if Input.is_action_pressed("run"):
					velocity.x = -RUNSPEED
				else:
					velocity.x -= SPEED
				$Sprite.play("walk")
				$Sprite.flip_h = true
			else:
				$Sprite.play("idle")
				velocity.x = lerp(velocity.x,0,0.2)

	if Input.is_action_just_pressed("jump"):
		velocity. y = JUMPFORCE
		state = States.AIR
		move_and_fall()
	
		global_position += input_vector * SPEED
		
		move_and_slide(velocity, Vector2.UP)
		
	if Input.is_action_just_pressed("shoot"):
		$AnimationPlayer.play("S")
		shoot_laser()
	if Input.is_action_just_released("move_right"):
		set_modulate(Color(1,1,1,1))

func ouch():
	take_damage(1)
	$AnimationPlayer.play("death") 
	$AnimationPlayer.play("hit")

func take_damage(damage):
	hp -= damage
	hp -= 1
	$hp.text = str(hp)
	if hp <= 0:
		$gameover.play()

func shoot_laser():
	if Input.is_action_just_pressed("shoot"):
		var direction = 1 if not $Sprite.flip_h else -1
		var f = Player_Laser.instance()
		f.direction = direction
		get_parent().add_child(f)
		f.position.y = position. y + -10
		f.position.x = position. x + 25 * direction 

func is_on_floor():
	velocity = move_and_slide(velocity,Vector2.UP)

func move_and_fall():
	velocity = move_and_slide(velocity,Vector2.UP)
	velocity.y = velocity.y + GRAVITY

func add_coin():
	coins = coins + 1

func _on_Timer_timeout():
	take_damage(1)

func _on_player_body_entered(body):
	if body.is_in_group("enemies"):
		ouch()
		set_modulate(Color(0.3,0.3,0.3,0.3))

func _on_player_area_entered(area):
	if area.is_in_group("enemies"):
		print("hi")

func _on_gameover_finished():
	get_tree().change_scene("res://GameOver.tscn")
