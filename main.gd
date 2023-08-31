extends Node

var nodes: Array[Area2D]

@onready var center_node = $Control/CenterNode
@onready var game_node := $Control/CenterNode/Game
@onready var lexeme_list = $UI/Control3/LexemeList
#@onready var camera := $Game/Camera3D
#@onready var cursor3D = $Game/CSGSphere3D
@onready var buttons := $UI/MarginContainer/Buttons
#@onready var compicactus_anim = $Game/Compicactus/AnimationPlayer
@onready var cursor := $Cursor
@onready var hint_text_label := $UI/MarginContainer/RichTextLabel

@onready var joypad_up := $UI/Control/JoypadUp
@onready var joypad_down := $UI/Control/JoypadDown
@onready var joypad_left := $UI/Control/JoypadLeft
@onready var joypad_right := $UI/Control/JoypadRight

var TmrNode := preload("res://tmr_node.tscn")
var grabbing := false
var grabbing_tmr
var add_node := false
var node_to_add := {}
var selected_shapes := ""


@onready var joypad_buttons: Array[Label] = [
	joypad_down,
	joypad_right,
	joypad_left,
	joypad_up,
]
	
func _ready():
	#sub_viewport.add_child(game_2)
	#compicactus_anim.play("Action-07-Swinging")
	var hint_text := ""
	var pos_y := 50
	for lexeme in Global.lexemes:
		#hint_text += "%s %s\n" % [lexeme.name, lexeme.code]
		var tmr_node: Area2D = TmrNode.instantiate()
		tmr_node.position = Global.cursor2d_pos
		tmr_node.label = lexeme.label
		tmr_node.code = lexeme.code
		tmr_node.position = Vector2(200, pos_y)
		tmr_node.connections_amount = 0
		lexeme_list.add_child(tmr_node)
		pos_y += 400
	hint_text += "\n\n"
	hint_text += "s: %s\n" % InputMap.action_get_events("SquareShape")[0].as_text()
	hint_text += "c: %s\n" % InputMap.action_get_events("CircleShape")[0].as_text()
	hint_text += "x: %s\n" % InputMap.action_get_events("CrossShape")[0].as_text()
	hint_text += "t: %s\n" % InputMap.action_get_events("TriangleShape")[0].as_text()
	hint_text_label.text = hint_text
	
#	for lexeme in Global.lexemes:
#		var button = Button.new()
#		button.text = lexeme.name
#		button.focus_mode = Control.FOCUS_NONE
#		button.connect("button_up", _on_lexeme_button_up.bind(lexeme))
#		buttons.add_child(button)
	#print(InputMap.action_get_events("Up")[0].as_text())

func getShapeButton(action_name:String):
	var info := InputMap.action_get_events(action_name)[0].as_text()
	if info.begins_with("Joypad Button 0"):
		return 0
	elif info.begins_with("Joypad Button 1"):
		return 1
	elif info.begins_with("Joypad Button 2"):
		return 2
	elif info.begins_with("Joypad Button 3"):
		return 3
	return 3 #TODO should be different from 3

func _input(event):
	if event.is_action_pressed("Place"):
		for node in nodes:
			print(node.child_tmrs)
#		if grabbing:
#			grabbing = false
#			grabbing_tmr.grabbed = false
#		else:
#			add_node = true
#			node_to_add = Global.lexemes.pick_random()
	
	joypad_buttons[getShapeButton("SquareShape")].text = "S"
	joypad_buttons[getShapeButton("CircleShape")].text = "C"
	joypad_buttons[getShapeButton("CrossShape")].text = "X"
	joypad_buttons[getShapeButton("TriangleShape")].text = "T"
	if event.is_action_pressed("CircleShape"):
		selected_shapes += "c"
		joypad_buttons[getShapeButton("CircleShape")].text = "(C)"
	elif event.is_action_pressed("SquareShape"):
		selected_shapes += "s"
		joypad_buttons[getShapeButton("SquareShape")].text = "(S)"
	elif event.is_action_pressed("CrossShape"):
		selected_shapes += "x"
		joypad_buttons[getShapeButton("CrossShape")].text = "(X)"
	elif event.is_action_pressed("TriangleShape"):
		selected_shapes += "t"
		joypad_buttons[getShapeButton("TriangleShape")].text = "(T)"
	elif event.is_action_pressed("LexemeDown"):
		var tween = create_tween()
		tween.tween_property(lexeme_list, "position:y", lexeme_list.position.y + 200, 0.2)
		#lexeme_list.position.y += 200
	elif event.is_action_pressed("LexemeUp"):
		var tween = create_tween()
		tween.tween_property(lexeme_list, "position:y", lexeme_list.position.y - 200, 0.2)
		#lexeme_list.position.y -= 200

func _process(_delta):
	var panvector := Vector2.ZERO
	panvector.x = Input.get_action_strength("PanRight") - Input.get_action_strength("PanLeft")
	panvector.y = Input.get_action_strength("PanDown") - Input.get_action_strength("PanUp")
	center_node.position += panvector * _delta * 800
	
	var joyvector := Vector2.ZERO
	joyvector.x = Input.get_action_strength("CursorRight") - Input.get_action_strength("CursorLeft")
	joyvector.y = Input.get_action_strength("CursorDown") - Input.get_action_strength("CursorUp")
	#label_score.text = "%f" % Input.get_action_strength("MoveCursorRight")
	#joyvector = joyvector.normalized()
	cursor.position += joyvector * _delta * 600
	if joyvector.length() > 0:
		if selected_shapes.length() > 0:
			print(selected_shapes)
			if codeExists(selected_shapes):
				add_node = true
				node_to_add = codeToLexeme(selected_shapes)
		selected_shapes = ""
	#cursor3D.position = Global.cursor3d_pos
	if add_node:
		add_node = false
		var tmr_node: Area2D = TmrNode.instantiate()
		tmr_node.position = game_node.to_local(Global.cursor2d_pos)
		tmr_node.connect("input_event", _on_input_event.bind(tmr_node))
		var lexeme = node_to_add
		tmr_node.label = lexeme.label
		tmr_node.code = lexeme.code
		tmr_node.connections_amount = lexeme.connections_amount
		game_node.add_child(tmr_node)
		#tmr_node.grabbed = true
		#grabbing_tmr = tmr_node
		#grabbing = true
		nodes.append(tmr_node)
		print("Add child")
	Global.cursor2d_pos = cursor.position
	
#	var xs: float = float(get_viewport().size.x) / 960
#	var ys: float = float(get_viewport().size.y) / 540
#	if xs > ys:
#		print("x")
#		center_node.position.x = get_viewport().size.x
#	else:
#		print("y")
#		center_node.position.y = get_viewport().size.y
#	#print(center_node.position, DisplayServer.window_get_size(0))
#	#print(get_viewport().size)
#	#center_node.position = get_viewport().size / 2

func codeExists(code:String):
	for lexeme in Global.lexemes:
		if lexeme.code == code:
			return true
	return false

func codeToLexeme(code:String) -> Dictionary:
	for lexeme in Global.lexemes:
		if lexeme.code == code:
			return lexeme
	return {}

func _unhandled_input(event):
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.pressed:
			print("Press")
			#if event.button_index == 2:
			#	add_node = true
		if !event.pressed:
			grabbing = false
	
	if event is InputEventMouseMotion:
		event = event as InputEventMouseMotion
		getCursorPosition(event)

func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int, tmr_node:Area2D):
	if grabbing: return
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.pressed:
			if event.button_index == 1:
				tmr_node.grabbed = true
				grabbing = true

func _on_lexeme_button_up(lexeme):
	add_node = true
	node_to_add = lexeme

func getCursorPosition(event):
	cursor.position = event.position

