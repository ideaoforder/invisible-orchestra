class Melody
	require 'fileutils'
	require 'midilib/sequence'
	require 'midilib/consts'
	include MIDI

	# require child classes
	Dir[File.dirname(__FILE__) + '/melody/*.rb'].each {|file| require file }

	# these are passed in or have defaults
	attr_accessor :midi_notes, :bpm, :resolution, :measure_num, :riff_notes_num, :file_name, :volume, :midi_step, :aggression

	# these are set based on those values
	attr_accessor :total_notes, :measure_switch, :num_riffs, :riffs, :track_name, :track, :sequence, :note_lengths

	def initialize(args={})   
		# init with possible args  
		self.midi_notes = args[:midi_notes] || {:d => 30, :e => 32, :fs => 34, :g => 35, :a => 37, :b => 39, :c => 41}
		self.bpm = args[:bpm] || 64
		self.resolution = args[:resolution] || 16 # default length of each note; so an 1/8 note would take up 2, and a quarter note would take up 4, etc
		self.measure_num = args[:measure_num] || 32 # number of measures in the song
		self.riff_notes_num = args[:riff_notes_num] || 4 # how complicated is this riff?
		self.file_name = args[:file_name] || 'melody'
		self.volume = args[:volume] || 127 # Volume - This could actually also be randomized within a range; For now, though, fucking blast it
		self.midi_step = args[:midi_step] || 0
		self.aggression = args[:aggression] || 50

		### Now let's set a few things based on those vars ###

		# total number of notes in a "song"
		self.total_notes = self.resolution * self.measure_num

		# if we need to shift the notes up or down any number of steps
		key_notes = Hash.new
		self.midi_notes.each do |note, num|
			key_notes[note] = num + (self.midi_step * 8)
		end
		self.midi_notes = key_notes

		# set the note lengths
		self.note_lengths = {"whole" => resolution, "half" => (resolution / 2), "quarter" => (resolution / 4), "8th" => (resolution / 8), "sixteenth" => (resolution / 16)}

		# measureSwitch tells us how often to change rules or do something different
		case i = self.measure_num
			when i <= 8
				# It's too short, don't switch anything up
				self.measure_switch = nil
			when (i > 8 and i <= 32)
				self.measure_switch = 8
			when (i > 32 and i <= 64)
				self.measure_switch = 8
			else
				self.measure_switch = 8
		end

		self.num_riffs = self.measure_num / self.measure_switch

		self.riffs = Hash.new
		self.track_name = self.file_name.split('/').last.gsub('_', '').capitalize

		self.sequence = Sequence.new()

		# Create a first track for the sequence. This holds tempo events and stuff like that.
		track = Track.new(self.sequence)
		self.sequence.tracks << track
		track.events << Tempo.new(Tempo.bpm_to_mpq(self.bpm))
		track.events << MetaEvent.new(META_SEQ_NAME, "#{track_name} Sequence")

		# Create a track to hold the notes. Add it to the sequence.
		track = Track.new(self.sequence)
		self.sequence.tracks << track

		# Give the track a name and an instrument name (optional).
		track.name = track_name
		track.instrument = GM_PATCH_NAMES[0]

		self.track = track
  end

  def save
  	dir = File.dirname(self.file_name)

	  unless File.directory?(dir)
	    FileUtils.mkdir_p(dir)
	  end

  	File.open(self.file_name, 'wb') { |file| self.sequence.write(file) }
  end

  # Is there enough time left in the measure to play a not of this length?
  # If not, truncate it something reasonable
  def valid_duration(available, given)
		length = self.note_lengths[given]
		if length > available
			given = self.note_lengths.keys[self.note_lengths.keys.index(given) + 1]
			return valid_duration(available, given)
		else
			return given
		end
	end

	def write
		puts "The Melody class can't write on its own. Please call this method on a subclass, like Riff"
	end

end