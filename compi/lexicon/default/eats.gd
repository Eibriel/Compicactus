extends CompiLexeme

func _init():
	label = "Eats"
	description = "To eat"
	category = "Verb"
	syntactic_structure = {
		"SUBJECT": "Noun",
		"DIRECTOBJECT": "Noun" #optional
	}
	code = "cs"

# Adding instances  (move this to compi?)
# Connect instances (move this to compi?)

func generate_moves(tmr: CompiTMR):
	var token_id = 0
	var moves = []
	if !tmr.is_token_instanced(token_id):
		moves.append(tmr.add_instance(token_id, "ingest"))
	else:
		moves.append_array(tmr.add_property(token_id))
	return moves

func evaluate_instance(instance: CompiInstance) -> int:
	var score:int = 0
	if instance.sem_struc["SUBJECT"].category != "Noun":
		score -= 10
	if instance.sem_struc.has("DIRECTOBJECT") and instance.sem_struc["DIRECTOBJECT"].category != "Noun":
		score -= 10
		if instance.sem_struc["SUBJECT"] == instance.sem_struc["DIRECTOBJECT"]:
			score -= 100
	if not instance.sem_struc["SUBJECT"].is_a("animal"):
		score -= 50
	if not instance.sem_struc["DIRECTOBJECT"].is_a("food"):
		score -= 50
	return score
