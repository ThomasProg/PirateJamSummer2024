extends Node
class_name NightEvent

@export var peekAnchorGroup:Node3D
@export var nightTimer: NightTimer
@export var wolf: Wolf
@export_file("*.tscn") var nextDayPath: String
@export var brickBreakSFX:AudioStream

@export var nightBGM:NightBGM
@export var wolfStab:AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.is_debug_build():
		var children = peekAnchorGroup.get_children()
		for peekAnchor in children:
			assert(peekAnchor is Node3D)

	nightTimer.onPeek.connect(onPeek)
	
	wolf.onWolfDisappears.connect(func():
		nightBGM.targetVolumes[3] = -60
		)
	
	nightTimer.onNightEnd.connect(func():
		print("End of the night: you survive")
		if not(nextDayPath.is_empty()):
			GameManager.loadNextDay(nextDayPath)
		)
		
	wolf.onWolfLeave.connect(func():
		print("End of the night: the wolf went away")
		if not(nextDayPath.is_empty()):
			GameManager.loadNextDay(nextDayPath)
		)
	
	wolf.onWolfWin.connect(func(): 
		print("Game Over")
		nightTimer.queue_free()	
		wolf.queue_free()
		wolf = null
		
		nightBGM.queue_free()
		#for i in range(4):
			#nightBGM.targetVolumes[i] = 0
		
		GameManager.loadGameOver()
		)

func onPeek():
	nightBGM.targetVolumes[3] = 0
	
	# TODO : opti and precompute
	var stones = get_parent().find_children("*", "RemovableStone", true, false)

	#var peekAnchor = peekAnchorGroup.get_children().pick_random() as Node3D
	var stone = stones.pick_random() as RemovableStone
	var peekAnchor = stone.peekingSpot

	if (stone.peekingSpot != null):
		var audioPlayer = AudioStreamPlayer3D.new()
		audioPlayer.stream = brickBreakSFX
		stone.add_child(audioPlayer)
		audioPlayer.play()
		audioPlayer.finished.connect(func():
			audioPlayer.queue_free())
		
		stone.disappear()
		wolf.global_position = stone.peekingSpot.global_position
		wolf.lookAt = stone
		wolf.appear()
		wolfStab.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (wolf != null):
		var ratio = wolf.aggro / wolf.maxAggro
		if (ratio < 0.3):
			nightBGM.setIntensity0()
		elif (ratio < 0.6):
			nightBGM.setIntensity1()
		else:
			nightBGM.setIntensity2()
