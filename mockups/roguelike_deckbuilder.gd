extends Control

@onready var output := %Output
@onready var input := %Input

var cards := []
const deck = {
	"hello":{},
	"how_are":{}
}
const answers := {
	"hello": "how_are you",
	"no":"yes"
}
var first_turn := true

func _ready():
	next_turn()

func next_turn():
	output.add_text("\n")
	var input_text: String = input.text.to_lower()
	if first_turn:
		input_text = "FIRST"
		first_turn = false
	say(input_text)
	if cards.size() == 0:
		output.add_text("\n\n** You loose **")

func say(text: String):
	var _cards := get_cards(text)
	_cards = only_on_cards(_cards)
	if _cards.size() == 0:
		output.add_text("Compi says: ?")
		return
	remove_cards(_cards)
	var answer: String
	var card: String = _cards[0]
	if answers.has(card):
		answer = answers[card]
		var a_cards := get_cards(answer)
		cards.append_array(a_cards)
		output.add_text("Compi says: %s" % answer)
	else:
		output.add_text("Error, can't get answer for %s" % card)
	output.add_text("\n Your cards: ")
	for c in cards:
		output.add_text("%s, " % c)

func remove_cards(_cards:Array[String]):
	for c in _cards:
		var i = cards.find(c)
		if i >= 0:
			cards.remove_at(i)

func only_on_cards(_cards:Array[String])->Array[String]:
	var filtered:Array[String] = []
	for c in _cards:
		if cards.has(c):
			filtered.append(c)
	return filtered

func get_cards(text: String) -> Array[String]:
	var words := text.split(" ")
	var _cards:Array[String] = []
	for w in words:
		if deck.has(w) or w == "FIRST":
			_cards.append(w)
	return _cards


func _on_input_text_submitted(new_text):
	next_turn()
	input.text = ""
