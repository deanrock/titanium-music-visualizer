$.index.open();

var file = Ti.Filesystem.getFile(Ti.Filesystem.resourcesDirectory,'example.mp3');

if ($.visualizer.load(file.nativePath)) {
	$.play.addEventListener('click', function(e)
	{
		$.visualizer.play();
	});

	$.pause.addEventListener('click', function(e)
	{
		$.visualizer.pause();
	});

	$.seek.addEventListener('click', function(e)
	{
		$.visualizer.seek(120.0);
	});

	$.mute.addEventListener('click', function(e)
	{
		$.visualizer.setVolume(0.0);
	});

	$.unmute.addEventListener('click', function(e)
	{
		$.visualizer.setVolume(1.0);
	});

	setInterval(function(){
	   // check position
	   $.label.text = $.visualizer.getCurrentPosition().toFixed(2) + ' / ' + $.visualizer.getDuration().toFixed(2);
	}, 100);
}else{
	$.label.text = 'cannot load specified file';
}
