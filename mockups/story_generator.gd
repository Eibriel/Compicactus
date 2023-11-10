extends Control

@onready var output := $Output

const names = [
	"John"
]

const problems = [
	"its loosing its memories",
	"forgot about a meeting"
]

const howto_face = [
	"being violent with others (who?)",
	"being violent with itself",
	"being frozen in fear",
	"by hidding the simptoms"
]

const howto_deny = [
	"by projecting the issue on others (who?)",
	"by saying that there is no problem",
	"by saying that will be fixed soon",
	"by changing subject"
]

func _input(event):
	if event.is_action_pressed("ui_accept"):
		var town = generate_town()
		output.add_text("\n%s" % town)

func generate_town() -> String:
	const HOUSES := 5
	var town : String = ""
	for h in HOUSES:
		town += "\nHouse %d\n" % h
		town += "Owner: %s\n" % generate_house_owner()
		town += "Compicactus: %s\n" % generate_compicactus()
	return town

func generate_compicactus() -> String:
	var compicactus: String = names.pick_random()
	compicactus += "\nProblem: %s" % generate_problem()
	return compicactus

func generate_house_owner() -> String:
	return ""

func generate_personality() -> String:
	return ""

func generate_problem() -> String:
	var problem: String = problems.pick_random()
	var atitude: int = [0, 1, 2].pick_random()
	match atitude:
		0:
			problem += " - faces it %s" % howto_face.pick_random()
		1:
			problem += " - denies it %s" % howto_deny.pick_random()
		2:
			problem += " - don't know it"
	return problem
