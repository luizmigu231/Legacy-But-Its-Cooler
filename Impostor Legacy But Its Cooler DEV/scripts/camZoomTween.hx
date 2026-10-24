import funkin.utils.CoolUtil;

using StringTools;

function onEvent(eventName, value1, value2)
{
	switch (eventName)
	{
		case 'camZoomTween':
			var zoom = Std.parseFloat(value1);
                        var timing = value2.split(",");
                        var duration = Std.parseFloat(timing[0]);
			var easingMethod = CoolUtil.getEaseFromString(timing[1]);
					
			function bindZoom() game.defaultCamZoom = FlxG.camera.zoom;
					
			FlxTween.tween(FlxG.camera, {zoom: zoom}, duration,
			{
				ease: easingMethod,
				onUpdate: bindZoom,
				onComplete: function(tween:FlxTween) {
					FlxTimer.wait(0, bindZoom);
				}
			});
	}
}
