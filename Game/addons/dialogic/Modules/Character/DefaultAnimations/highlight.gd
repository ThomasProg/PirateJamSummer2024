extends DialogicAnimation

func animate():
	var tween := (node.create_tween() as Tween)
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(node, 'modulate', Color(1.0, 1.0, 1.0, 1.0), time)
	tween.finished.connect(emit_signal.bind('finished_once'))
