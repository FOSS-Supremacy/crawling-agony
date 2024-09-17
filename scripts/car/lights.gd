extends Node3D

@onready var external_lights = [ $left_light, $right_light ]
@onready var internal_light = $internal_light

func _ready():
	internal_light.visible = false
	for light in external_lights:
		light.visible = false

func _input(event):
	if Input.is_action_just_pressed("internal_light"):
		internal_light.visible = not internal_light.visible

	if Input.is_action_just_pressed("external_lights"):
		for light in external_lights:
			light.visible = not light.visible
