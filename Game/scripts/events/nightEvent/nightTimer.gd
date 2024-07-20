extends Node
class_name NightTimer

@export var nightDuration:float = 20.0
@export var peekTimes:Array[float] = []

# useful for testing debug, to skip part of the night
# of course it's not optimized, but it's alright
@export var currentTime:float = 0

signal onPeek()
signal onNightEnd()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var nextTime = currentTime + delta 
	for peekTime in peekTimes:
		if (currentTime < peekTime and nextTime >= peekTime):
			onPeek.emit()

	if (currentTime < nightDuration and nextTime >= nightDuration):
		onNightEnd.emit()

	currentTime = nextTime
	
