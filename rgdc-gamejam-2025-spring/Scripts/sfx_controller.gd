extends AudioStreamPlayer2D


func play_sound():
	if !playing:
		self.play()
		self.playing = true


func stop_sound():
	if playing:
		self.stop()
		self.playing = false
