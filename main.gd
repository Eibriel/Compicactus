extends Node

var nodes: Array[Area2D]

@onready var center_node = $Control/CenterNode
@onready var game_node := $Control/CenterNode/Game
@onready var lexeme_list = $UI/Control3/LexemeList
#@onready var camera := $Game/Camera3D
#@onready var cursor3D = $Game/CSGSphere3D
@onready var buttons := $UI/MarginContainer/Buttons
#@onready var compicactus_anim = $Game/Compicactus/AnimationPlayer
@onready var pointer := $Pointer
@onready var cursor = $Control/CenterNode/Cursor
@onready var hint_text_label := $UI/MarginContainer/RichTextLabel

@onready var joypad_up := $UI/Control/JoypadUp
@onready var joypad_down := $UI/Control/JoypadDown
@onready var joypad_left := $UI/Control/JoypadLeft
@onready var joypad_right := $UI/Control/JoypadRight

var TmrNode := preload("res://tmr_node.tscn")
var grabbing := false
var grabbing_tmr
var adding_node: Area2D
var selected_shapes := ""


@onready var joypad_buttons: Array[Label] = [
	joypad_down,
	joypad_right,
	joypad_left,
	joypad_up,
]
	
func _ready():
	var hint_text := ""
	var pos_y := 50
	for lexeme in Global.lexemes:
		var tmr_node: Area2D = TmrNode.instantiate()
		tmr_node.code = lexeme.code
		tmr_node.connected = false
		tmr_node.position = Vector2(200, pos_y)
		lexeme_list.add_child(tmr_node)
		pos_y += 400
	hint_text += "\n\n"
	hint_text += "s: %s\n" % InputMap.action_get_events("SquareShape")[0].as_text()
	hint_text += "c: %s\n" % InputMap.action_get_events("CircleShape")[0].as_text()
	hint_text += "x: %s\n" % InputMap.action_get_events("CrossShape")[0].as_text()
	hint_text += "t: %s\n" % InputMap.action_get_events("TriangleShape")[0].as_text()
	hint_text_label.text = hint_text
	

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
	
	elif event.is_action_pressed("CursorDown"):
		doneBuildingNode()
		var tween = create_tween()
		tween.tween_property(cursor, "position:y", cursor.position.y + 300, 0.1)
	elif event.is_action_pressed("CursorUp"):
		#cursor.position.y -= 100
		doneBuildingNode()
		var tween = create_tween()
		tween.tween_property(cursor, "position:y", cursor.position.y - 300, 0.1)
	elif event.is_action_pressed("CursorLeft"):
		#cursor.position.x -= 100
		doneBuildingNode()
		var tween = create_tween()
		tween.tween_property(cursor, "position:x", cursor.position.x - 300, 0.1)
	elif event.is_action_pressed("CursorRight"):
		#cursor.position.x += 100
		doneBuildingNode()
		var tween = create_tween()
		tween.tween_property(cursor, "position:x", cursor.position.x + 300, 0.1)
	elif event.is_action_pressed("Grab"):
		if grabbing:
			grabbing = false
			grabbing_tmr.grabbed = false
		else:
			var min_distance = null
			var closest_instance = null
			for instance in Global.instances:
				var dist = instance.position.distance_to(Global.cursor2d_pos)
				if min_distance == null or dist < min_distance:
					min_distance = dist
					closest_instance = instance
			if closest_instance != null:
				grabbing = true
				grabbing_tmr = closest_instance
				grabbing_tmr.grabbed = true

func doneBuildingNode():
	selected_shapes = ""
	adding_node = null

func _process(_delta):
	var panvector := Vector2.ZERO
	panvector.x = Input.get_action_strength("PanRight") - Input.get_action_strength("PanLeft")
	panvector.y = Input.get_action_strength("PanDown") - Input.get_action_strength("PanUp")
	center_node.position -= panvector * _delta * 1000
	
	var joyvector := Vector2.ZERO
	joyvector.x = Input.get_action_strength("PointerRight") - Input.get_action_strength("PointerLeft")
	joyvector.y = Input.get_action_strength("PointerDown") - Input.get_action_strength("PointerUp")
	#label_score.text = "%f" % Input.get_action_strength("MoveCursorRight")
	#joyvector = joyvector.normalized()
	#pointer.position += joyvector * _delta * 600
	lexeme_list.position += joyvector * _delta * 1500
	if joyvector.length() > 0:
		selected_shapes = ""
		adding_node = null
	if selected_shapes.length() == 1:
		if adding_node == null:
			print(selected_shapes)
			var tmr_node: Area2D = TmrNode.instantiate()
			tmr_node.position = Global.cursor2d_pos
			tmr_node.connect("input_event", _on_input_event.bind(tmr_node))
			tmr_node.code = selected_shapes
			game_node.add_child(tmr_node)
			nodes.append(tmr_node)
			Global.instances.append(tmr_node)
			adding_node = tmr_node
			print("Add child")
	elif selected_shapes.length() > 1:
		adding_node.code = selected_shapes
	#Global.cursor2d_pos = cursor.position
	Global.cursor2d_pos = game_node.to_local(center_node.to_global(cursor.position))

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
	pass
#	add_node = true
#	node_to_add = lexeme

func getCursorPosition(event):
	pointer.position = event.position

