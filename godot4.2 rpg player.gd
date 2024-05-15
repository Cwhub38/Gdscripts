extends CharacterBody2D
signal spawn_laser(location)
@onready var muzzle = $Muzzle 
var speed = 300
var input_vector = Vector2.ZERO
var hp = 3

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	global_position += input_vector * speed * delta

func ouch():
	set_modulate(Color(1,0.3,0.3,0.3))
	take_damage(1)

func take_damage(damage):
	hp -= damage
	hp -= 1
	$hp.text = str(hp)
	if hp <= 0:
		queue_free()

func _on_player_body_entered(body):
	if body.is_in_group("enemies"):
		set_modulate(Color(0.3,0.3,0.3,0.3))
		ouch()
		take_damage(1)

func _on_player_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(1)
