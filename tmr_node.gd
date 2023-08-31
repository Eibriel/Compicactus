extends Area2D

@export var label := "Label"
@export var code := "------"
@export_range(0, 5) var connections_amount := 3

@onready var lasers_node := $LasersNode
@onready var rays_node := $RaysNode
@onready var label2d := %TMRLabel
#@onready var code_label = %ShapesLabel

@onready var shape_sprites: Array[Sprite2D] = [
	$Shapes/Shape01,
	$Shapes/Shape02,
	$Shapes/Shape03,
	$Shapes/Shape04,
	$Shapes/Shape05
]

var mat_laser_idle = preload("res://materials/laser_idle.tres")
var mat_laser_active = preload("res://materials/laser_active.tres")

var circle_texture = preload("res://atlas/circle.tres")
var cross_texture = preload("res://atlas/cross.tres")
var square_texture = preload("res://atlas/square.tres")
var triangle_texture = preload("res://atlas/triangle.tres")

var grabbed := false
var mouse_position := Vector2(0,0)

var lasers: Array[Line2D] = []
#var lasers_geom: Array[CSGPolygon2D] = []
var rays: Array[RayCast2D] = []
var child_tmrs: Array[Area2D] = []

const line_resolution = 16
const line_radius = 0.05

var laser_positions = [
	[Vector2(-0.4, -0.2)*300, Vector2(-1.7, -0.7)*300],
	[Vector2(-0.4, 0.2)*300, Vector2(-1.7, 0.7)*300],
	[Vector2(-0.4, 0)*300, Vector2(-1.7, 0)*300],
]

func _ready():
	for n in connections_amount:
		var laser := Line2D.new()
		laser.width = 24
		laser.add_point(laser_positions[n][0])
		laser.add_point(laser_positions[n][1])
		lasers.append(laser)
		lasers_node.add_child(laser)
		
		var ray := RayCast2D.new()
		ray.collide_with_areas = true
		ray.collide_with_bodies = false
		ray.position = laser_positions[n][0]
		ray.target_position = laser_positions[n][1]
		rays.append(ray)
		rays_node.add_child(ray)
		child_tmrs.append(null)

func _physics_process(_delta):
	if grabbed:
		global_position = Global.cursor2d_pos

func _process(_delta):
	label2d.text = label
	#code_label.text = code
	for s in shape_sprites:
		s.texture = null
	for n in code.length():
		match code[n]:
			"s":
				shape_sprites[n].texture = square_texture
			"c":
				shape_sprites[n].texture = circle_texture
			"t":
				shape_sprites[n].texture = triangle_texture
			"x":
				shape_sprites[n].texture = cross_texture
	for ray in connections_amount:
		var start_point = rays[ray].position
		if rays[ray].is_colliding():
			var global_collision_point = rays[ray].get_collision_point()
			var collision_tmr := rays[ray].get_collider()
			child_tmrs[ray] = collision_tmr
			lasers[ray].set_point_position(1, lasers[ray].to_local(global_collision_point))
			lasers[ray].default_color = Color(0.961, 0.247, 0.588)
			lasers[ray].self_modulate.a = 0.8
		else:
			var global_target_pos = rays[ray].to_global(rays[ray].target_position)
			lasers[ray].set_point_position(1, lasers[ray].to_local(global_target_pos))
			lasers[ray].default_color = Color(0.725, 0.537, 0.925)
			lasers[ray].self_modulate.a = 0.2

#func _on_input_event(_viewport, _event, _shape_idx):
#	pass
#	if event is InputEventMouseButton:
#		event = event as InputEventMouseButton
#		if event.pressed:
#			if event.button_index == 1:
#				print("Grabbing")
#				grab_event = true
#

func _unhandled_input(event):
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if !event.pressed:
			grabbed = false
	if event is InputEventMouseMotion:
		event = event as InputEventMouseMotion
		mouse_position = event.position
