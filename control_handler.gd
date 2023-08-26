extends Node



func _process(_delta):
	var joyvector := Vector2.ZERO
	joyvector.x = Input.get_action_strength("CursorRight") - Input.get_action_strength("CursorLeft")
	joyvector.y = Input.get_action_strength("CursorDown") - Input.get_action_strength("CursorUp")

func _input(event):
	if event.is_action_pressed("Place"):
		print("Place")
	
	if event.is_action_pressed("CircleShape"):
		print("Circle")
	elif event.is_action_pressed("SquareShape"):
		print("Square")
	elif event.is_action_pressed("CrossShape"):
		print("Cross")
	elif event.is_action_pressed("TriangleShape"):
		print("Triangle")
