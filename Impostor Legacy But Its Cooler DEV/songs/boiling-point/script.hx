import openfl.filters.ShaderFilter;
import flixel.addons.display.FlxRuntimeShader;
import funkin.game.shaders.HeatwaveShader;

var heatwaveHUD:HeatwaveShader;
var chromHUD:FlxRuntimeShader;
var chromTween:FlxTween;

function onLoad()
{
	videoCutscene('boiling', false);
}

function onCreatePost()
{
	if (ClientPrefs.shaders)
	{
		heatwaveHUD = new HeatwaveShader();

		chromHUD = new FlxRuntimeShader(
			Paths.getTextFromFile('shaders/chromaticHUD.frag')
		);

		chromHUD.setFloat('amount', -0.2);

		camHUD.filters = [
			new ShaderFilter(heatwaveHUD.shader),
			new ShaderFilter(chromHUD)
		];
	}

	snapCamToPos(1760, 340);
	defaultCamZoom = 0.7;
}

function onUpdate(elapsed:Float)
{
	if (!ClientPrefs.shaders)
		return;

	if (heatwaveHUD != null)
		heatwaveHUD.update(elapsed);
}

function onEvent(eventName, value1, value2)
{
	switch (eventName)
	{
		case 'setChrom':
			if (chromHUD == null)
				return;

			var amount:Float = Std.parseFloat(value1);
			if (Math.isNaN(amount))
				amount = 0;

			var speed:Float = Std.parseFloat(value2);
			if (Math.isNaN(speed))
				speed = 0;

			if (chromTween != null)
				chromTween.cancel();

			chromTween = FlxTween.num(
				-0.2,
				amount,
				speed,
				{
					ease: FlxEase.sineOut,
					onUpdate: function(tween:FlxTween)
					{
						chromHUD.setFloat('amount', tween.value);
					}
				}
			);
	}
}