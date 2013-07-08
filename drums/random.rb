class Drums::Random < Drums
	def write
		kick_string = ''
		snare_string = ''
		hihat_string = ''

		for i in 1..self.measure_num

			if i % self.measure_switch == 1
				if vary_aggression
					if aggression.is_a? Range
						this_aggression = [*aggression].sample
					else
						this_aggression = rand(100)
					end
				else
					this aggression = aggression
				end
				kick_rhythm = ''
				snare_rhythm = ''
				hihat_rhythm = ''

				# these rhythms should be as long as the resolution
				for j in 1..resolution
					kick_rhythm 		+= (rand(100) <= this_aggression ? '#' : '-')
					snare_rhythm 	+= (rand(100) <= this_aggression ? '#' : '-')
					hihat_rhythm 	+= (rand(100) <= this_aggression ? '#' : '-')
				end

				this_kick 	= kick_rhythm
				this_snare = snare_rhythm
				this_hihat = hihat_rhythm
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