$.index.open();

var file = Ti.Filesystem.getFile(Ti.Filesystem.resourcesDirectory,'example.mp3');
var path = file.nativePath;

if (OS_ANDROID) {
	path = "/sdcard/example.mp3";

	var audioPermission = "android.permission.RECORD_AUDIO";
	var hasAudioPerm = Ti.Android.hasPermission(audioPermission);
	 
	var storagePermission = "android.permission.READ_EXTERNAL_STORAGE";
	var hasStoragePerm = Ti.Android.hasPermission(storagePermission);
	 
	var permissionsToRequest = [];
	if (!hasAudioPerm) {
	    permissionsToRequest.push(audioPermission);
	} 
	if (!hasStoragePerm) {
	    permissionsToRequest.push(storagePermission);
	} 
	if (permissionsToRequest.length > 0) {
	    Ti.Android.requestPermissions(permissionsToRequest, function(e) {
	        if (e.success) {
	            Ti.API.info("SUCCESS");
	        } else {
	            Ti.API.info("ERROR: " + e.error);
	        }
	    });
	}
}

if ($.visualizer.load(path)) {
	$.visualizer.lineColor = "blue";
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
