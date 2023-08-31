extends Node

var cursor2d_pos := Vector2()

const lexemes = [
	{
		"name": "1st person",
		"label": "I/Me",
		"connections_amount": 0,
		"category": "Noun",
		"syntactic-structure": {},
		"semantic-structure": "human:user",
		"code":"t"
	},
	{
		"name": "Apple fruit",
		"label": "apple",
		"connections_amount": 0,
		"category": "Noun",
		"syntactic-structure": {},
		"semantic-structure": "apple",
		"code":"ct"
	},
	{
		"name": "Pizza food",
		"label": "pizza",
		"connections_amount": 0,
		"category": "Noun",
		"syntactic-structure": {},
		"semantic-structure": "pizza",
		"code": "cx"
	},
	{
		"name": "To eat",
		"label": "eats",
		"category": "Verb",
		"connections_amount": 2,
		"syntactic-structure": {
			"SUBJECT": "Noun",
			"DIRECTOBJECT": "Noun" #optional
		},
		"semantic-structure": {},
		"code": "cs"
	},
	{
		"name": "Posession",
		"label": "owned by",
		"category": "Verb",
		"connections_amount": 2,
		"syntactic-structure": {
			"SUBJECT": "Noun",
			"DIRECTOBJECT": "Noun" #optional
		},
		"semantic-structure": {},
		"code": "ss"
	},
	{
		"name": "To like",
		"label": "like",
		"category": "Verb",
		"connections_amount": 2,
		"syntactic-structure": {
			"SUBJECT": "Noun",
			"DIRECTOBJECT": "Noun" #optional
		},
		"semantic-structure": {},
		"code": "ctc"
	},
	{
		"name": "To sleep",
		"label": "sleep",
		"category": "Verb",
		"connections_amount": 1,
		"syntactic-structure": {
			"SUBJECT": "Noun",
			"DIRECTOBJECT": "Noun" #optional
		},
		"semantic-structure": {},
		"code": "xx"
	},
	{
		"name": "To live",
		"label": "live",
		"category": "Verb",
		"connections_amount": 2,
		"syntactic-structure": {
			"SUBJECT": "Noun",
			"DIRECTOBJECT": "Noun" #optional
		},
		"semantic-structure": {},
		"code": "sx"
	},
	{
		"name": "House",
		"label": "house",
		"category": "Noun",
		"connections_amount": 0,
		"syntactic-structure": {},
		"semantic-structure": {},
		"code": "st"
	},
	{
		"name": "Sibling",
		"label": "brother/sister",
		"category": "Noun",
		"connections_amount": 0,
		"syntactic-structure": {},
		"semantic-structure": {},
		"code": "ssss"
	},
	{
		"name": "Too",
		"label": "too",
		"category": "Adverb",
		"connections_amount": 1,
		"syntactic-structure": {},
		"semantic-structure": {},
		"code": "cscs"
	},
	{
		"name": "More than",
		"label": "more than",
		"category": "Adverb",
		"connections_amount": 2,
		"syntactic-structure": {},
		"semantic-structure": {},
		"code": "ts"
	},
	{
		"name": "Less than",
		"label": "less than",
		"category": "Adverb",
		"connections_amount": 2,
		"syntactic-structure": {},
		"semantic-structure": {},
		"code": "st"
	}
]
