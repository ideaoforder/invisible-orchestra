#! /usr/bin/env ruby
require './melody'
require './drums'

folder = "generated_files/#{Time.now.strftime('%-m-%-d-%Y')}"

# melody = Melody::RepeatedNotes.new(:file_name => "#{folder}/melody_repeated_notes.midi")
# melody.write
# melody.save

melody = Melody::Riff.new(:file_name => "#{folder}/melody_riff1.midi")
melody.write
melody.save

melody = Melody::Riff.new(:file_name => "#{folder}/melody_riff2.midi", :step => 1)
melody.write
melody.save

melody = Melody::Riff.new(:file_name => "#{folder}/melody_riff3.midi", :step => 2)
melody.write
melody.save

melody = Melody::Riff.new(:file_name => "#{folder}/melody_riff4.midi", :step => 3)
melody.write
melody.save

melody = Melody::RandomNotes.new(:file_name => "#{folder}/melody_random.midi")
melody.write
melody.save


drums = Drums::Riff.new(:file_name => "#{folder}/drums_riff1.midi")
drums.write
drums.save

drums = Drums::Riff.new(:file_name => "#{folder}/drums_riff2.midi")
drums.write
drums.save

drums = Drums::Random.new(:file_name => "#{folder}/drums_random1.midi")
drums.write
drums.save

drums = Drums::Random.new(:file_name => "#{folder}/drums_random2.midi")
drums.write
drums.save