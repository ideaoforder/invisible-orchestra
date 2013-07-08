class Drums
	require 'fileutils'
	require 'rhythmruby'

	# require child classes
	Dir[File.dirname(__FILE__) + '/drums/*.rb'].each {|file| require file }

	# these are passed in or have defaults
	attr_accessor :bpm, :resolution, :measure_num, :file_name, :aggression, :vary_aggression

	# these are set based on those values, or aren't shouldn't be set
	attr_accessor  :measure_switch, :midi_writer, :count_base, :midi_notes

	def initialize(args={})   
		# these are fixed values
		self.count_base = 1.0/4.0 # one symbol represents a sixteenth note (one fourth of a quarter note)
		self.midi_notes = {:kick => 36, :snare => 40, :hihat_closed => 42}

		# these can be passed in
		self.file_name = args[:file_name] || 'drums'
		self.aggression = args[:aggression] || 40..70 # how aggressive is our accompaniment? How often is there a note played, basically.
		self.vary_aggression = args[:vary_aggression] || true
		self.bpm = args[:bpm] || 64
		self.resolution = args[:resolution] || 16 # default length of each note; so an 1/8 note would take up 2, and a quarter note would take up 4, etc
		self.measure_num = args[:measure_num] || 32 # number of measures in the song

		# now setup a few calculated/default values
		self.midi_writer = MidiWriter.new(self.bpm) # self.midi_writer instance administrating one MIDI song

		### Now let's set a few things based on those vars ###
		# self.measure_switch tells us how often to change rules or do something different
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

	end

	def save
  	dir = File.dirname(self.file_name)

	  unless File.directory?(dir)
	    FileUtils.mkdir_p(dir)
	  end

		### Now merge the whole thing and write it to a file ###
		self.midi_writer.mergeTracks # merge all tracks to one track (one midi file import in DAW)
		self.midi_writer.writeToFile(self.file_name) # write MIDI song to file
	end

	def write
		puts "The Drums class can't write on its own. Please call this method on a subclass, like Riff"
	end

end