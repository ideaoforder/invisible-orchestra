class Drums::Riff < Drums

	def write
		kick_string = ''
		snare_string = ''
		hihat_string = ''

		for i in 1..self.measure_num

			if i % self.measure_switch == 1
				# these rhythms should be as long as the resolution
				kick_rhythms 	= ['#-#---#-#-----#-', '#---#---#---#---', '#-#-----#-#---#-', '#-------#-#-----']
				snare_rhythms 	= ['--#---#----#-#--', '--#---#---#---#-', '-#-#---#-#-#---#', '----#-------#---', '----------------']
				hihat_rhythms 	= ['#-#-#-#-#-#-#-#-', '#---#---#---#---', '#-------#-------', '#-###---#-##--#-', '----------------']

				this_kick 	= kick_rhythms.sample
				this_snare = snare_rhythms.sample
				this_hihat = hihat_rhythms.sample
			end

			kick_string 	+= this_kick
			snare_string += this_snare
			hihat_string += this_hihat
		end

		# parse the rhythm string to MIDI ready information (array of [midiNote, noteLength] sub-arrays)
		kick_info = RhythmParser.parseRhythm(kick_string, self.count_base, self.midi_notes[:kick])
		kickTrack = self.midi_writer.createTrack() # create track in the MIDI song
		self.midi_writer.writeSeqToTrack(kick_info, kickTrack) # write the parsed rhythm to a MIDI track

		snare_info = RhythmParser.parseRhythm(snare_string, self.count_base, self.midi_notes[:snare])
		snareTrack = self.midi_writer.createTrack() # create track in the MIDI song
		self.midi_writer.writeSeqToTrack(snare_info, snareTrack) # write the parsed rhythm to a MIDI track

		hihat_info = RhythmParser.parseRhythm(hihat_string, self.count_base, self.midi_notes[:hihat_closed])
		hihatTrack = self.midi_writer.createTrack() # create track in the MIDI song
		self.midi_writer.writeSeqToTrack(hihat_info, hihatTrack) # write the parsed rhythm to a MIDI track
	end

end