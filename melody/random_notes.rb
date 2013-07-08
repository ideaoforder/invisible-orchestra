class Melody::RandomNotes < Melody

	def write
		# cycle through each measure
		for i in 1..self.measure_num
			# initialize our available number of notes
			available_notes = self.resolution

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
				if rand(100) <= self.aggression
					self.track.events << NoteOn.new(0, note, self.volume, 0)
				  self.track.events << NoteOff.new(0, note, self.volume, self.sequence.note_to_delta(duration.dup))
				else
					self.track.events << NoteOn.new(0, 0, 0, 0)
				  self.track.events << NoteOff.new(0, 0, 0, self.sequence.note_to_delta(duration.dup))		
				end
			end

		end
	end
	
end