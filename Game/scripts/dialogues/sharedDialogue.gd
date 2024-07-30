extends Node
class_name SharedDialogue

@export var timeline:DialogicTimeline
var hasDialogueAlreadyPlayed:bool = false

signal onStarted(characterTalkedTo:Character, player:Player)
signal onCancelled(characterTalkedTo:Character, player:Player)
signal onFinished(characterTalkedTo:Character, player:Player)

func play(characterTalkedTo:Character, player:Player):
	if (timeline == null):
		push_error("\"timeline\" not set in ", name)
		return
		
	if (hasDialogueAlreadyPlayed):
		print("Dialogue already played")
		return
		
	GameManager.isConsumingDialogue = true
	onStarted.emit(characterTalkedTo, player)
	hasDialogueAlreadyPlayed = true
	
	Dialogic.start(timeline)
	get_viewport().set_input_as_handled()
	player.blockMouseCapture = true
	player.captureMouse = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	var interactComp = Utilities.findComponentByType(player, InteractionComponent) as InteractionComponent
	if (interactComp != null):
		interactComp.enabled = false
		
	Dialogic.timeline_ended.connect(func():
		player.blockMouseCapture = false
		player.captureMouse = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		if not(GameManager.isConsumingDialogue):
			hasDialogueAlreadyPlayed = false
			onCancelled.emit(characterTalkedTo, player)
		
		await get_tree().process_frame
		interactComp.enabled = true
			
		onFinished.emit(characterTalkedTo, player)
		, CONNECT_ONE_SHOT)
