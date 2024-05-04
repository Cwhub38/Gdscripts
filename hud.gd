extends CanvasLayer


#Called when the node enters the scene tree for the first time

func _ready():
	ouch()

func ouch():
	draw_hearts(Global.lives)

func draw_hearts (num_hearts):
	print("i got called")
	for i in range(1, Global.max_lives+1):
		print(' i is', i)
		var heart_node = get_node("Heart"+str(i))
		if i <= num_hearts:
			heart_node.visible = true
		else:
			heart_node.visible = false
