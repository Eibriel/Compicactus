extends Node

signal ui_event(event_code: int, event_strength: float)
signal ui_mode_change(new_mode: int)

const MODES = {
	"SELECT_LEXEME": 0,
	"MOVE_CURSOR": 1,
	"EIBRIEL_TITLE": 2,
	"START_TITLE": 3,
	"GAME_MENU": 4,
	"INVENTORY_MENU":5
}

const EVENTS = {
	"LEXEME_RIGHT": 0,
	"LEXEME_LEFT": 1,
	"CURSOR_UP": 2,
	"CURSOR_DOWN": 3,
	"CURSOR_LEFT": 4,
	"CURSOR_RIGHT": 5,
	"SEND_MESSAGE": 6,
	"LEAVING_TITLE": 7,
	"OPEN_GAME_MENU": 8,
	"CLOSE_GAME_MENU": 9,
	
	"MENU_UP": 10,
	"MENU_DOWN": 11,
	"MENU_LEFT": 12,
	"MENU_RIGHT": 13,
	"MENU_SELECT": 14,
	"MENU_BACK": 15,
	
	"OPEN_INVENTORY_MENU": 16,
	"CLOSE_INVENTORY_MENU": 17,
	"INVENTORY_NEXT_PAGE": 18,
	"INVENTORY_PREVIOUS_PAGE": 19,
}

const INPUT_MODE = {
	"GAMEPAD": 0,
	"KEYBOARD": 1
}

var ui_mode := MODES.EIBRIEL_TITLE

#func _process(_delta):
#	var joyvector := Vector2.ZERO
#	joyvector.x = Input.get_action_strength("CursorRight") - Input.get_action_strength("CursorLeft")
#	joyvector.y = Input.get_action_strength("CursorDown") - Input.get_action_strength("CursorUp")

func _input(event) -> void:
	match ui_mode:
		MODES.SELECT_LEXEME:
			select_lexeme_input(event)
		MODES.START_TITLE:
			start_title_input(event)
		MODES.GAME_MENU:
			game_menu_input(event)
		MODES.INVENTORY_MENU:
			inventory_menu_input(event)

func change_mode(new_mode: int) -> void:
	ui_mode = new_mode
	emit_signal("ui_mode_change", ui_mode)


func select_lexeme_input(event: InputEvent) -> void:
	if event.is_action_pressed("lexeme_right"):
		emit_signal("ui_event", EVENTS.LEXEME_RIGHT, 1.0)
	if event.is_action_pressed("lexeme_left"):
		emit_signal("ui_event", EVENTS.LEXEME_LEFT, 1.0)
		
	if event.is_action_pressed("cursor_right"):
		emit_signal("ui_event", EVENTS.CURSOR_RIGHT, 1.0)
	if event.is_action_pressed("cursor_left"):
		emit_signal("ui_event", EVENTS.CURSOR_LEFT, 1.0)
	if event.is_action_pressed("cursor_up"):
		emit_signal("ui_event", EVENTS.CURSOR_UP, 1.0)
	if event.is_action_pressed("cursor_down"):
		emit_signal("ui_event", EVENTS.CURSOR_DOWN, 1.0)
	
	if event.is_action_pressed("send_message"):
		emit_signal("ui_event", EVENTS.SEND_MESSAGE, 1.0)
	
	if event.is_action_pressed("open_game_menu"):
		emit_signal("ui_event", EVENTS.OPEN_GAME_MENU, 1.0)
	
	if event.is_action_pressed("open_inventory_menu"):
		emit_signal("ui_event", EVENTS.OPEN_INVENTORY_MENU, 1.0)


func start_title_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu_select"):
		emit_signal("ui_event", EVENTS.LEAVING_TITLE, 1.0)

func game_menu_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_game_menu"):
		emit_signal("ui_event", EVENTS.CLOSE_GAME_MENU, 1.0)
	if event.is_action_pressed("menu_back"):
		emit_signal("ui_event", EVENTS.CLOSE_GAME_MENU, 1.0)
	if event.is_action_pressed("menu_up"):
		emit_signal("ui_event", EVENTS.MENU_UP, 1.0)
	if event.is_action_pressed("menu_down"):
		emit_signal("ui_event", EVENTS.MENU_DOWN, 1.0)
	if event.is_action_pressed("menu_left"):
		emit_signal("ui_event", EVENTS.MENU_LEFT, 1.0)
	if event.is_action_pressed("menu_right"):
		emit_signal("ui_event", EVENTS.MENU_RIGHT, 1.0)
	if event.is_action_pressed("menu_select"):
		emit_signal("ui_event", EVENTS.MENU_SELECT, 1.0)

func inventory_menu_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_inventory_menu"):
		emit_signal("ui_event", EVENTS.CLOSE_INVENTORY_MENU, 1.0)
	if event.is_action_pressed("menu_back"):
		emit_signal("ui_event", EVENTS.CLOSE_INVENTORY_MENU, 1.0)
	
	if event.is_action_pressed("lexeme_right"):
		emit_signal("ui_event", EVENTS.INVENTORY_NEXT_PAGE, 1.0)
	if event.is_action_pressed("lexeme_left"):
		emit_signal("ui_event", EVENTS.INVENTORY_PREVIOUS_PAGE, 1.0)
