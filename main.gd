extends Node

var lexemes:Lex
var grid:Dictionary
var grid_sprites:Dictionary
var cursor_position:=Vector2i(2, 2)

@onready var background = %Background
@onready var lexeme_list = %LexemeList
@onready var cursor = %Cursor
@onready var grid_node = %Grid
@onready var compicactus = %Compicactus
@onready var logo_screen = %LogoScreen
@onready var eibriel_logo = %EibrielLogo
@onready var intro_screen = %IntroScreen
@onready var pause_screen = %PauseScreen
@onready var inventory_screen = %InventoryScreen
@onready var inventory_pages = [
	%LexemeWall,
	%LexemeInformation,
	%Concepts,
	%ConceptInformation,
	%CompiBrain
]
@onready var pause_menu_label = %PauseMenuLabel
@onready var answers: Array[Node2D]= [
	%Answer1,
	%Answer2,
	%Answer3,
	%Answer4
]
@onready var compi_control = $Control/CompiControl


const languages := [
	["English", "en"],
	["Español Latam", "es"],
	["Español España", "es"]
]
const grid_size:=Vector2i(4, 4)

var inventory_current_page := 0
var menu_current_position := 0
var current_language := 0

func _ready():
	TranslationServer.set_locale(languages[current_language][1])
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
	day_night()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _exit_tree():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func hide_logoscreen():
	var tween := create_tween()
	#tween.tween_interval(2)
	tween.tween_property(eibriel_logo, "scale", Vector2(1.05, 1.05), 2)
	tween.tween_property(logo_screen, "modulate:a", 0, 1)
	tween.tween_callback(func():
			logo_screen.visible = false
			ControlHandler.change_mode(ControlHandler.MODES.START_TITLE)
			)

func day_night():
	var tween := create_tween()
	tween.tween_property(background, "modulate", Color.AQUA, 10)
	tween.tween_property(background, "modulate", Color.ROSY_BROWN, 10)
	tween.tween_property(background, "modulate", Color.WHITE, 10)
	tween.set_loops()

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
	#lexeme_list.position.x = ((grid[cursor_position]+5) * -300) - 150
	var tween_a := create_tween()
	tween_a.tween_property(lexeme_list, "position:x", ((grid[cursor_position]+5) * -300) - 150, 0.2)
	if grid[cursor_position] == 0:
		grid_sprites[cursor_position].texture = null
	else:
		var lid = lexemes.ids[grid[cursor_position]-1]
		var t = load("res://atlas/lexeme_%s.tres" % lid)
		grid_sprites[cursor_position].texture = t
		var tween := create_tween()
		#tween.set_trans(Tween.TRANS_ELASTIC)
		tween.tween_property(grid_sprites[cursor_position], "scale", Vector2(1.3, 1.3), 0.2)
		tween.tween_property(grid_sprites[cursor_position], "scale", Vector2.ONE, 0.1)

func draw_nodes():
	var tween := create_tween()
	#cursor.position = cursor_position * 300
	tween.tween_property(cursor, "position", Vector2(cursor_position * 300), 0.2)

func send_message():
	for _x in 8:
		for _y in 8:
			var k = Vector2i(_x, _y)
			grid[k] = 0
			grid_sprites[k].texture = null
	cursor_position = Vector2i(2, 2)
	var compi_anims := [
		"Disbelief",
		"Wink",
		"No"
	]
	compicactus.play(compi_anims.pick_random(), true)
	for a in answers:
		a.visible = false
	answers.pick_random().visible = true
	var tween := create_tween()
	tween.tween_property(compi_control, "position", compi_control.position+Vector2(13, 15), 0.05)
	tween.tween_property(compi_control, "position", compi_control.position-Vector2(15, 12), 0.02)
	tween.tween_property(compi_control, "position", compi_control.position+Vector2(10, 13), 0.05)
	tween.tween_property(compi_control, "position", compi_control.position-Vector2(6, 8), 0.02)
	tween.tween_property(compi_control, "position", compi_control.position, 0.05)

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
			down_game_menu()
		ControlHandler.EVENTS.MENU_UP:
			up_game_menu()
		ControlHandler.EVENTS.MENU_SELECT:
			action_game_menu()
		ControlHandler.EVENTS.OPEN_INVENTORY_MENU:
			open_inventory_menu()
		ControlHandler.EVENTS.CLOSE_INVENTORY_MENU:
			close_inventory_menu()
		ControlHandler.EVENTS.INVENTORY_NEXT_PAGE:
			inventory_next_page()
		ControlHandler.EVENTS.INVENTORY_PREVIOUS_PAGE:
			inventory_previous_page()
	cursor_position.x = max(cursor_position.x, 0)
	cursor_position.y = max(cursor_position.y, 0)
	cursor_position.x = min(cursor_position.x, grid_size.x)
	cursor_position.y = min(cursor_position.y, grid_size.y)
	grid[cursor_position] = max(grid[cursor_position], 0)
	draw_nodes()
	set_lexemes_position()

func open_game_menu():
	redraw_menu()
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

func action_game_menu():
	match menu_current_position:
		0:
			next_language()
		1:
			get_tree().quit()

func next_language():
	current_language+=1
	if current_language >= languages.size():
		current_language = 0
	TranslationServer.set_locale(languages[current_language][1])
	redraw_menu()

func down_game_menu():
	menu_current_position += 1
	menu_current_position = min(menu_current_position, 1)
	redraw_menu()

func up_game_menu():
	menu_current_position -= 1
	menu_current_position = max(menu_current_position, 0)
	redraw_menu()

func redraw_menu():
	var menu_buttons := [
		languages[current_language][0],
		"_quit"
	]
	var menu_text := ""
	for n in menu_buttons.size():
		if n == menu_current_position:
			menu_text += "[%s]\n" % tr(menu_buttons[n])
		else:
			menu_text += "%s\n" % tr(menu_buttons[n])
	pause_menu_label.text = menu_text

func inventory_next_page():
	inventory_current_page += 1
	inventory_current_page = min(inventory_current_page, inventory_pages.size()-1)
	set_inventory_page(inventory_current_page)

func inventory_previous_page():
	inventory_current_page -= 1
	inventory_current_page = max(inventory_current_page, 0)
	set_inventory_page(inventory_current_page)

func set_inventory_page(page: int):
	for p in inventory_pages:
		p.visible = false
	inventory_pages[page].visible = true

func open_inventory_menu():
	inventory_current_page = 0
	set_inventory_page(inventory_current_page)
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
	.build("question")
	.build("have")
	.build("not_have")
	.build("to_own")
	.build("like")
	.build("not_like")
	.build("to_eat")
	.build("money")
	.build("tree")
	.build("cat")
	.build("dog")
	.build("food")
	.build("event")
	.build("thing")
	.build("all"))
