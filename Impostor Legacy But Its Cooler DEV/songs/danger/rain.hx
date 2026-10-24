import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;

var rainShader;
var rainFilter;

var rainIntensity = 0.097;
var rainTime = 0;
var rainTween;

var rainSpeedMultiplier = 1.5;
var rainSpeedTween;

var rainScaleMultiplier = 4.4;

var stormStarted:Bool = false;

function onCreatePost()
{
if (ClientPrefs.shaders)
{
var shaderCode = Paths.getTextFromFile('shaders/rain.frag');

	if (shaderCode != null && shaderCode.length > 0)
	{
		rainShader = new FlxRuntimeShader(shaderCode);
		rainFilter = new ShaderFilter(rainShader);

		if (game.camGame.filters == null)
		{
			game.camGame.filters = [rainFilter];
		}
		else
		{
			game.camGame.filters.push(rainFilter);
		}

		rainShader.setFloat('uTime', 0);
		rainShader.setFloat('uIntensity', rainIntensity);

		rainShader.setFloat(
			'uScale',
			game.camGame.zoom * rainScaleMultiplier
		);

		rainShader.setFloatArray(
			'uScreenResolution',
			[
				FlxG.width,
				FlxG.height
			]
		);
	}
}

}

function onUpdate(elapsed)
{
if (rainShader != null && ClientPrefs.shaders)
{
rainTime += elapsed * rainSpeedMultiplier;

	rainShader.setFloat(
		'uTime',
		rainTime
	);

	rainShader.setFloat(
		'uIntensity',
		rainIntensity
	);

	rainShader.setFloat(
		'uScale',
		game.camGame.zoom * rainScaleMultiplier
	);

	if (game.camGame != null)
	{
		rainShader.setFloatArray(
			'uCameraBounds',
			[
				game.camGame.scroll.x,
				game.camGame.scroll.y,
				game.camGame.scroll.x + game.camGame.width,
				game.camGame.scroll.y + game.camGame.height
			]
		);
	}

	rainShader.setFloatArray(
		'uScreenResolution',
		[
			FlxG.width,
			FlxG.height
		]
	);
}

}

function startStorm()
{
if (stormStarted)
return;

stormStarted = true;

if (rainTween != null)
	rainTween.cancel();

if (rainSpeedTween != null)
	rainSpeedTween.cancel();

rainTween = FlxTween.num(
	rainIntensity,
	0.30,
	10,
	{
		ease: FlxEase.quadInOut
	},
	function(v:Float)
	{
		rainIntensity = v;
	}
);

rainSpeedTween = FlxTween.num(
	rainSpeedMultiplier,
	3.0,
	10,
	{
		ease: FlxEase.quadInOut
	},
	function(v:Float)
	{
		rainSpeedMultiplier = v;
	}
);

}

function onBeatHit()
{
if (curBeat == 160)
{
startStorm();
}
}

function tweenRain(targetValue, duration, easeFunc)
{
if (rainTween != null)
{
rainTween.cancel();
}

rainTween = FlxTween.num(
	rainIntensity,
	targetValue,
	duration,
	{
		ease: easeFunc
	},
	function(v:Float)
	{
		rainIntensity = v;
	}
);

}

function opponentNoteHit(note)
{
if (rainShader == null || !ClientPrefs.shaders)
return;

if (curStep > 7991 && curStep < 8000)
{
	tweenRain(
		0.098,
		1,
		FlxEase.cubeOut
	);
}

}