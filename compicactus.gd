extends Node3D

@onready var compicactus := $compicactus/AnimationPlayer

func _ready():
	compicactus.get_animation("Idle").loop_mode = Animation.LOOP_LINEAR
	compicactus.get_animation("HumanOrMachine").loop_mode = Animation.LOOP_LINEAR

func play(anim:String, add_iddle:bool=false):
	if anim == "": return
	match anim:
		"Idle":
			compicactus.queue("Idle")
		_:
			compicactus.play(anim)
			if add_iddle:
				compicactus.queue("Idle")

func stop_anim():
	compicactus.stop()

#func set_visible():
#	visible = true
