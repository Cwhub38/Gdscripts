extends CanvasLayer

var coins = 0
var hud

func ready():
	$Coin.text = String(coins)
	load_hearts()
	Global.hud = self

func _on_coin_collected():
	coins = coins + 1
	_ready()
	if coins == 3:
		get_tree().change_scene("res://YouWin.tscn")

func load_hearts():
	$HeartsFull.rect_size.x = Global.lives * 53
	$HeartsEmpty.rect_size.x = (Global.max_lives - Global.lives) * 53
	

