extends AudioStreamPlayer
class_name NightBGM

var targetVolumes:Array[float] = [0, -60, -60, -60]
var transitionSpeed:float = 20.0

func _ready() -> void:
	assert(stream is AudioStreamSynchronized)
	setIntensity0()
	
	#await get_tree().create_timer(15).timeout
	#
	#setIntensity1()
	#
	#await get_tree().create_timer(7).timeout
	#
	#setIntensity2()
	
func updateStreamVolume(index:int,delta):
	# TODO : convert to linear? (not db?)
	var newVolume:float = move_toward(stream.get_sync_stream_volume(index), targetVolumes[index], transitionSpeed * delta)
	stream.set_sync_stream_volume(index, newVolume)
	print(index, " : ", newVolume)
	
func _process(delta: float) -> void:
	updateStreamVolume(0, delta)
	updateStreamVolume(1, delta)
	updateStreamVolume(2, delta)
	
func setIntensity0():
	if (stream is AudioStreamSynchronized):
		targetVolumes[0] = 0.0
		targetVolumes[1] = -60.0
		targetVolumes[2] = -60.0
		

func setIntensity1():
	if (stream is AudioStreamSynchronized):
		targetVolumes[0] = 0.0
		targetVolumes[1] = 0.0
		targetVolumes[2] = -60.0
		
func setIntensity2():
	if (stream is AudioStreamSynchronized):
		targetVolumes[0] = 0.0
		targetVolumes[1] = 0.0
		targetVolumes[2] = 0.0
