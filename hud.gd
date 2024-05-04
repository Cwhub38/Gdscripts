extends CanvasLayer

var coins = 0
var hud

func ouch():
draw_hearts(lives)

func ready():
ouch()
$Coin.text = String(coins)
load_hearts()
Global.hud = self

func _on_coin_collected():
coins = coins + 1
_ready()
if coins == 3:
get_tree().change_scene("res://YouWin.tscn")

func load_hearts(num_hearts):
print("i got called")
for i in range(1, max_lives+1):
print(' i is', i)
var heart_node = get_node("Heart"+str(i))
if i <= num_hearts:
heart_node.visible = true
else:
heart_node.visible = false

