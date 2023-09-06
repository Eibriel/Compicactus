class_name CompiLexeme
## A unit of a sentence on Compi constructed visual language.
##
## You can think of it as "words",
## for example "apple" and "eat".

## Name for the Lexeme
var label:String = ""
## Detailed description for the Lexeme
var description:String = ""
## Lexical Category (Noun, Verb, etc.)
var category: String
## A Dictionary representing the possible
## slots to be filled. For example:
## { "SUBJECT": "Noun", "DIRECTOBJECT": "Noun"}
var syntactic_structure: Dictionary = {}
## The sequence of leters t,s,c,x to be used
## to select the Lexeme.
var code:String = ""

## Function to be substituted.[br]
## Should return an Array of possible moves, each move being a change to the provided TMR.
func generate_moves(tmr: CompiTMR) -> Array:
	return []

## Function to be substituted.[br]
## Should return an integer value representing the score
## for that particular instance.
func evaluate_instance(instance: CompiInstance) -> int:
	return 0
