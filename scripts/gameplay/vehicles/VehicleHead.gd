
#<---> 
#	Still under development. It is not practical to use this script in other vehicles.
#	If you add this script to other vehicles, you will need a series of corrections
#	in the script due to lack of resources in the scene. Such as "$ExitMarked", "$VehicleCameraController",
#	"$InteractArea", etc...
#<--->

extends VehicleBody3D
class_name VehicleHead

@export var state:VehicleState = VehicleState.STOPPED
enum VehicleState {
	PLAYER_DRIVING,
	NPC_DRIVING,
	STOPPED
}

var speed = 0

@export_group("Vehicle Nodes")
@export var VehicleEnginePath:VehicleEngine
@export var VehicleSteeringPath:VehicleSteering

@onready var driver: Node3D = $CarView/Driver

# Getting in and out of the car
var player # player ref
var player_can_interact = false
var player_in_area = false

# camera rotation based on direction
var camera_rotation = 0.0

func _physics_process(delta):
	StateController() # Car state controller
	EnterAndExit() # Mechanic to join and leave the car
	
	if VehicleEnginePath != null and VehicleSteeringPath != null:
		match state:
			VehicleState.PLAYER_DRIVING: # If the player is driving:
				VehicleEnginePath.EngineController()
				VehicleSteeringPath.SteerVehicle(delta)
			VehicleState.STOPPED: # If the player is not driving:
				VehicleEnginePath.EngineBrake()
	else:
		print("Vehicle nodes not found.")

func StateController(): # Car state controller
	# <--->
	if state == VehicleState.PLAYER_DRIVING: # For now only controls the camera
		$VehicleCameraController.ControllerState = $VehicleCameraController.CameraState.ACTIVE
	elif state == VehicleState.NPC_DRIVING:
		$VehicleCameraController.ControllerState = $VehicleCameraController.CameraState.DISABLE
	else:
		$VehicleCameraController.ControllerState = $VehicleCameraController.CameraState.DISABLE
	# <--->
	if state == VehicleState.PLAYER_DRIVING: # Set some parameters when the player is inside or outside of the car
		driver.show()
		$CarInterface/VBoxContainer.show()
	else:
		driver.hide()
		$CarInterface/VBoxContainer.hide()
		
		
	# <--->	
	if player_in_area: # Used to set if the player can or can't interact with the car
		if state == VehicleState.STOPPED:
			player_can_interact = true
		elif state == VehicleState.PLAYER_DRIVING:
			player_can_interact = false
	else:
		player_can_interact = false
	# <--->
	
func EnterAndExit(): # Mechanic to join and leave the car
	if Input.is_action_just_pressed("enter_car") and player != null:
		if state == VehicleState.STOPPED:
			if player_can_interact:
				state = VehicleState.PLAYER_DRIVING
				player.global_transform.origin = Vector3(0,-200,0)
		elif state == VehicleState.PLAYER_DRIVING:
			state = VehicleState.STOPPED
			state = VehicleState.STOPPED
			player.global_transform.origin = $ExitMarked.global_transform.origin
			
func PlayerEnteredInteractArea(body: Node3D) -> void:
	if body is Player:
		player = body
		player_can_interact = true
		player_in_area = true
func PlayerExitedInteractArea(body: Node3D) -> void:
	if body is Player:
		pass
		#player = null
		player_can_interact = false
		player_in_area = false
