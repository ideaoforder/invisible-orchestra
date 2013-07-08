class Melody::RepeatedNotes < Melody
	def write
		for i in 1..self.num_riffs
			self.riffs[i] = Array.new

			# for the moment, let's just use 8th notes
			# and then repeat those notes an arbitrary number of times
			# repeats = resolution / @@noteLengths.values.sample
			note_length = "8th"
			repeats = 8

			# initialize our available number of notes
			available_notes = self.resolution

			for k in 1..self.riff_notes_num
				note = self.midi_notes.values.sample
				for j in 1..repeats
					# 2) Finally write the damn note to the track
					riffs[i] << {:note => note, :duration => self.sequence.note_to_delta(note_length), :volume => self.volume}
				  available_notes -= self.note_lengths[note_length]
				end
			end

		end

		# cycle through each measure
		j = 0
		for i in 1..self.measure_num
			j += 1 if (i % self.measure_switch == 0)
			n = (j % self.num_riffs) + 1
			riff = self.riffs[n]
			riff.each do |note|
				self.track.events << NoteOn.new(0, note[:note], note[:volume], 0)
				self.track.events << NoteOff.new(0, note[:note], note[:volume], note[:duration])
			end
		end
	end
end