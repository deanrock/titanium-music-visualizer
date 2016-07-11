# music-visualizer Module

## Description

This is a Titanium module for iOS intended to play music and present visual animation.

## Accessing the music-visualizer Module

To access this module from JavaScript, you would do the following:

    var music_visualizer = require("com.deanrock.musicvisualizer");

    var view = music_visualizer.createView({ });
	win.add(view);

The music_visualizer variable is a reference to the Module object, and view variable is a reference to the UIView object.

## Reference

### music_visualizer.load(filepath)

- Loads audio file from specified path `filepath`.
- Returns `true` on success, and `false` on failure.


### music_visualizer.play()

Resumes playback of audio file.


### music_visualizer.pause()

Pauses playback of audio file.

### music_visualizer.seek(position)

Seeks position of playback to `position`. `position` parameter expects position in seconds as float number.

### music_visualizer.getCurrentPosition()

Returns current position of playback as float value.

### music_visualizer.getDuration()

Returns duration of audio file as float value.

### music_visualizer.setVolume(volume)

Sets volume to `volume` with possible range from 0.0 (silent) to 1.0 (max volume).

## Usage

Please check example in examples/music-visualizer-example/ folder.
