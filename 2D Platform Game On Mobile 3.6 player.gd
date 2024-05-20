extends KinematicBody2D
class_name Player

var hp = 10
signal spawn_laser(location)
const Player_Laser = preload("res://projectiles/PlayerLaser.tscn")
onready var muzzle = $Muzzle
onready var bullet = $Bullet
enum States {AIR = 1, FlOOR = 2}
var state = States.AIR
var velocity = Vector2(0,0)
var coins = 0
const SPEED = 210
const GRAVITY = 35
const JUMPFORCE = -900
var input_vector = Vector2.ZERO
const RUNSPEED = 2000

func _physics_process(_delta):
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
					velocity.x = -RUNSPEED
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
			elif Input.is_action_pressed("move_up"):
				if Input.is_action_pressed("run"):
					velocity.x = -RUNSPEED
				$Sprite.play("walk")
				$Sprite.flip_h = true
			else:
				$Sprite.play("idle")
				velocity.x = lerp(velocity.x,0,0.2)

			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMPFORCE
				state = States.AIR
			move_and_fall()
				
			if Input.is_action_just_pressed("shoot"):
				shoot_Laser()

func shoot_Laser():
	if Input.is_action_just_pressed("shoot"):
		var direction = 1 if not $Sprite.flip_h else -1
		var f = Player_Laser.instance()
		f.direction = direction
		get_parent().add_child(f)
		f.position.y = position. y + 10 * direction
		f.position.x = position. x + 5


func ouch():
	set_modulate(Color(0.3,0.3,0.3,0.3))
	take_damage(1)
	$Timer.start()

func take_damage(damage):
	hp -= damage
	hp -= 1
	$hp.text = str(hp)
	if hp <= 0:
		queue_free()

func is_on_floor():
	velocity = move_and_slide(velocity,Vector2.UP)

func move_and_fall():
	velocity = move_and_slide(velocity,Vector2.UP)
	velocity.y = velocity.y + GRAVITY

func _on_FallZone_body_entered():
	get_tree().change_scene("res://GameOver.tscn")

func add_coin():
	coins = coins + 1



func _on_player_body_entered(body):
	if body.is_in_group("enemies"):
		ouch()
		set_modulate(Color(0.3,0.3,0.3,0.3))

func _on_Timer_timeout():
	set_modulate(Color(1,1,1,1))


func _on_player_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(1)
