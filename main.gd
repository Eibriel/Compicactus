extends Node

var lexemes:Lex
var grid:Dictionary
var grid_sprites:Dictionary
var cursor_position:=Vector2i(2, 2)

@onready var lexeme_list = %LexemeList
@onready var cursor = %Cursor
@onready var grid_node = %Grid
@onready var compicactus = %Compicactus
@onready var logo_screen = %LogoScreen
@onready var intro_screen = %IntroScreen
@onready var pause_screen = %PauseScreen
@onready var inventory_screen = %InventoryScreen

const grid_size:=Vector2i(4, 4)


func _ready():
	$Screens.visible = true
	logo_screen.visible = true
	intro_screen.visible = true
	pause_screen.visible = false
	inventory_screen.visible = false
	compicactus.play("Idle")
	populate_lexemes()
	draw_lexemes()
	draw_nodes()
	for _x in 8:
		for _y in 8:
			var k = Vector2i(_x, _y)
			grid[k] = 0
			var s = Sprite2D.new()
			s.position = k * 300
			grid_sprites[k] = s
			grid_node.add_child(s)
	set_lexemes_position()
	hide_logoscreen()

func hide_logoscreen():
	var tween := create_tween()
	tween.tween_interval(2)
	tween.tween_property(logo_screen, "modulate:a", 0, 1)
	tween.tween_callback(func():
			logo_screen.visible = false
			ControlHandler.change_mode(ControlHandler.MODES.START_TITLE)
			)

func draw_lexemes():
	var pos_y = 300
	for lid in lexemes.ids:
		print(lid)
		var t = load("res://atlas/lexeme_%s.tres" % lid)
		var s = Sprite2D.new()
		s.texture = t
		s.scale = Vector2(0.7, 0.7)
		s.position.x = pos_y
		lexeme_list.add_child(s)
		pos_y += 300
	ControlHandler.connect("ui_event", _ui_event)

func set_lexemes_position():
	lexeme_list.position.x = ((grid[cursor_position]+5) * -300) - 150
	if grid[cursor_position] == 0:
		grid_sprites[cursor_position].texture = null
	else:
		var lid = lexemes.ids[grid[cursor_position]-1]
		var t = load("res://atlas/lexeme_%s.tres" % lid)
		grid_sprites[cursor_position].texture = t

func draw_nodes():
	cursor.position = cursor_position * 300

func send_message():
	for _x in 8:
		for _y in 8:
			var k = Vector2i(_x, _y)
			grid[k] = 0
			grid_sprites[k].texture = null
	cursor_position = Vector2i(2, 2)

func _ui_event(event_code: int, event_strength: float):
	print(event_code)
	match event_code:
		ControlHandler.EVENTS.LEXEME_RIGHT:
			grid[cursor_position] += 1
		ControlHandler.EVENTS.LEXEME_LEFT:
			grid[cursor_position] -= 1
		ControlHandler.EVENTS.CURSOR_LEFT:
			cursor_position.x -= 1
		ControlHandler.EVENTS.CURSOR_RIGHT:
			cursor_position.x += 1
		ControlHandler.EVENTS.CURSOR_UP:
			cursor_position.y -= 1
		ControlHandler.EVENTS.CURSOR_DOWN:
			cursor_position.y += 1
		ControlHandler.EVENTS.SEND_MESSAGE:
			send_message()
		ControlHandler.EVENTS.LEAVING_TITLE:
			leave_title()
		ControlHandler.EVENTS.OPEN_GAME_MENU:
			open_game_menu()
		ControlHandler.EVENTS.CLOSE_GAME_MENU:
			close_game_menu()
		ControlHandler.EVENTS.MENU_DOWN:
			get_tree().quit()
		ControlHandler.EVENTS.OPEN_INVENTORY_MENU:
			open_inventory_menu()
		ControlHandler.EVENTS.CLOSE_INVENTORY_MENU:
			close_inventory_menu()
	cursor_position.x = max(cursor_position.x, 0)
	cursor_position.y = max(cursor_position.y, 0)
	cursor_position.x = min(cursor_position.x, grid_size.x)
	cursor_position.y = min(cursor_position.y, grid_size.y)
	grid[cursor_position] = max(grid[cursor_position], 0)
	draw_nodes()
	set_lexemes_position()

func open_game_menu():
	var tween := create_tween()
	pause_screen.modulate.a = 0.0
	pause_screen.visible = true
	tween.tween_property(pause_screen, "modulate:a", 1, 0.2)
	tween.tween_callback(func():
		ControlHandler.change_mode(ControlHandler.MODES.GAME_MENU)
		)

func close_game_menu():
	var tween := create_tween()
	pause_screen.modulate.a = 1.0
	pause_screen.visible = true
	tween.tween_property(pause_screen, "modulate:a", 0, 0.2)
	tween.tween_callback(func():
		pause_screen.visible = false
		ControlHandler.change_mode(ControlHandler.MODES.SELECT_LEXEME)
		)

func open_inventory_menu():
	var tween := create_tween()
	inventory_screen.modulate.a = 0.0
	inventory_screen.visible = true
	tween.tween_property(inventory_screen, "modulate:a", 1, 0.2)
	tween.tween_callback(func():
		ControlHandler.change_mode(ControlHandler.MODES.INVENTORY_MENU)
		)

func close_inventory_menu():
	var tween := create_tween()
	inventory_screen.modulate.a = 1.0
	inventory_screen.visible = true
	tween.tween_property(inventory_screen, "modulate:a", 0, 0.2)
	tween.tween_callback(func():
		inventory_screen.visible = false
		ControlHandler.change_mode(ControlHandler.MODES.SELECT_LEXEME)
		)

func leave_title():
	var tween := create_tween()
	tween.tween_property(intro_screen, "modulate:a", 0, 1)
	tween.tween_callback(func():
		intro_screen.visible = false
		ControlHandler.change_mode(ControlHandler.MODES.SELECT_LEXEME)
		)

func populate_lexemes():
	lexemes = Lex.new()
	(lexemes.build("apple")
	.build("i")
	.build("you")
	.build("have")
	.build("not_have")
	.build("to_own")
	.build("like")
	.build("not_like")
	.build("money")
	.build("tree"))
