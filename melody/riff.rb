class Melody::Riff < Melody
	def write
		for i in 1..self.num_riffs
			self.riffs[i] = Array.new

			# initialize our available number of notes
			available_notes = self.resolution
			available_riff_notes = riff_notes_num

			while available_notes > 0
				# 1) Now choose a note
				note = self.midi_notes.values.sample

				# 2) Set a duration
				duration = self.note_lengths.keys.sample

				# 3) Check that we've got enough space in this measure
				duration = valid_duration(available_notes, duration)

				# 4) Subtract duration from the available time we've got
				available_notes -= self.note_lengths[duration]

				# 5) Finally write the damn note to the track
				if available_riff_notes > 0 and rand(100) <= self.aggression
					self.riffs[i] << {:note => note, :duration => self.sequence.note_to_delta(duration.dup), :volume =>self.volume}
				  available_riff_notes -= 1
				else
					self.riffs[i] << {:note => 0, :duration => self.sequence.note_to_delta(duration.dup), :volume => 0}	
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