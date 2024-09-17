extends Node3D

@onready var sun = $sun
@onready var moon = $moon

func _ready():
	moon.visible = false

func _input(event):
	if Input.is_action_just_pressed("night_toggle"):
		sun.visible = false
		moon.visible = true
