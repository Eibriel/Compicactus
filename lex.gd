class_name Lex

var ids:=[]
var lexemes:={}

func build(id:String):
	ids.append(id)
	lexemes[id] = {
		"id": id
	}
	return self
