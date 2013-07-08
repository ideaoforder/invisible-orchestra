invisible-orchestra
===================


Project Description
-------------------

The Invisible Orchestra Project is an electronic music experiment. Using a collection of computer algorithms that rely--to an extent--on randomness, each week (or month?) we generate a collection of "riffs"--6 melodies and 4 drum tracks--for you to create original compositions with. Some riffs are more random than others. Some weeks' riffs will be more conventional and listenable. Some will be more...well...difficult.

You--the "composers"--will build compositions out of computer-generated "riffs". Riffs are simply midi-files, which include no information but which notes to play or drums to hit, how loud to play them, and for how long. Composers choose the voice and arrangement for these riffs. Sections might be looped, silenced, effect-laden, cut into pieces, etc.

The songs might be barebones, or they may include original (human-generated) riffs.


What's Under the Hood, or The Code
----------------------------------

The Invisible Orchestra code is written in Ruby and outputs MIDI.

The MIDI file generation can be broken down into "drum" and "melody" tracks. Both drums and melodies rely on a default parent class 'Drums' and 'Melody'. There are lots of ways of creating drum and melody tracks (relying on different types of randomness, varying aggression, forcing riff-like structures, etc), and these methods can be found in the 'drums' and 'melody' folders. 

If you're interested in contributing, it's likely that you'll want to create new generators in the 'drums' or 'melody' folders.


### Drums ###

Drum tracks are generated using the [rhythmruby](https://github.com/Lvelden/rhythmruby) library, which uses a syntax like `#---#---` to represent drum hits (the '#' is a hit and the '-' is a rest).

To create a drum file, you might execute something like:

```
drums = Drums::Riff.new(:file_name => "generated_files/drums_riff.midi")
drums.write
drums.save
``` 

Drum generators should typically accept these arguments: 

* bpm - Beats Per Minute (default = 64)
* resolution - How many notes there are in a measure (default = 16)
* measure_num - How many measures to generate (default = 32)
* file_name - File name of output file
* aggression - How aggressive the drum beat is; lots of drum hits or more sparse
* vary_aggression - Whether aggression should be varied from measure to measure


### Melody ###

Melody tracks are created using the Ruby [midilib](https://github.com/jimm/midilib) library. This is slightly more complex than rhythmruby, but also more flexible.

To create a melody file, you might execute something like:

```
melody = Melody::RandomNotes.new(:file_name => "generated_files/melody_random.midi")
melody.write
melody.save
``` 

Melody generators should typically accept these arguments: 

* midi_notes - Which MIDI notes are usable (default will choose all of the notes in C Major)
* bpm - Beats Per Minute (default = 64)
* resolution - How many notes there are in a measure (default = 16)
* measure_num - How many measures to generate (default = 32)
* file_name - File name of output file
* aggression - How aggressive the drum beat is; lots of drum hits or more sparse
* riff_notes_num - How complicated a riff should be
* volume - Track volume (default = 127)
* midi_step - What octave the notes should be (this depends on the notes--step moves the midi_notes up or down the specified number of octaves)
