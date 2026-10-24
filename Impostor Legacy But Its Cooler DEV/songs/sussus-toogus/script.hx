import funkin.backend.FunkinShader.FunkinRuntimeShader;

var walkerShaders:Array<Dynamic> = [];
var nightAmount:Float = 0;

var shaderReady:Bool = false;

function makeAdjustColor():FunkinRuntimeShader
{
	var shader:FunkinRuntimeShader = newShader('adjustColor');

	shader.setFloat('hue', 0);
	shader.setFloat('saturation', 0);
	shader.setFloat('brightness', 0);
	shader.setFloat('contrast', 0);

	return shader;
}

function addShader(sprite:FlxSprite, hue:Float, saturation:Float, brightness:Float, contrast:Float):Void
{
	if (!ClientPrefs.shaders || sprite == null)
		return;

	var shader:FunkinRuntimeShader = makeAdjustColor();

	shader.setFloat('hue', hue);
	shader.setFloat('saturation', saturation);
	shader.setFloat('brightness', brightness);
	shader.setFloat('contrast', contrast);

	sprite.shader = shader;

	walkerShaders.push({
		sprite: sprite,
		shader: shader,
		hue: hue,
		saturation: saturation,
		brightness: brightness,
		contrast: contrast
	});
}

function applyNight(amount:Float):Void
{
	nightAmount = amount;

	for (entry in walkerShaders)
	{
		if (entry.sprite == null)
			continue;

		entry.shader.setFloat('hue', entry.hue * amount);
		entry.shader.setFloat('saturation', entry.saturation * amount);
		entry.shader.setFloat('brightness', entry.brightness * amount);
		entry.shader.setFloat('contrast', entry.contrast * amount);
	}
}

function setupWalkerShaders():Void
{
	if (!ClientPrefs.shaders || shaderReady)
		return;

	if (walkers == null || walkers.length == 0)
		return;

	for (walker in walkers)
	{
		if (walker == null)
			continue;

		addShader(walker, -16, -16, -56, 9);
	}

	shaderReady = true;
	applyNight(nightAmount);
}

function onCreatePost()
{
	setupWalkerShaders();
}

function onSongStart()
{
	FlxTween.num(0, 1, songLength / 1000, {onUpdate: function(twn:FlxTween) nightAmount = twn.value});
}

function onUpdate(elapsed:Float)
{
	if (!shaderReady)
		setupWalkerShaders();
	applyNight(nightAmount);
}

function onEvent(eventName, value1, value2)
{
	return;
	if (eventName == 'Lights out')
	{
		if (value1 == '2' || (value1 == '1' && !ClientPrefs.flashing))
			return;

		FlxTween.num(
			nightAmount,
			2.4,
			ClientPrefs.flashing ? 0.45 : 0.8,
			{ease: FlxEase.sineInOut},
			function(value:Float)
			{
				applyNight(value);
			}
		);
	}
	else if (eventName == 'Lights on')
	{
		if (value1 == '1' && !ClientPrefs.flashing)
			return;

		FlxTween.num(
			nightAmount,
			1,
			ClientPrefs.flashing ? 0.45 : 0.8,
			{ease: FlxEase.sineInOut},
			function(value:Float)
			{
				applyNight(value);
			}
		);
	}
	else if (eventName == 'Restore Rim')
	{
		if (ClientPrefs.shaders)
			applyNight(nightAmount);
	}
}