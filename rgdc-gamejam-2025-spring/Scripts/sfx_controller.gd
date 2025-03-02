extends AudioStreamPlayer


func play_sound():
	if !playing:
		self.play()
		self.playing = true


func stop_sound():
	self.stop()
	self.playing = false
