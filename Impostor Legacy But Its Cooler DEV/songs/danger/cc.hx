import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var colorShaderGame:FlxRuntimeShader;
var colorShaderHUD:FlxRuntimeShader;

var colorFilterGame:ShaderFilter;
var colorFilterHUD:ShaderFilter;

var c_hue:Float = -10;
var c_saturation:Float = 0;
var c_contrast:Float = 0;
var c_brightness:Float = 10;

var hueTween:FlxTween;
var satTween:FlxTween;
var conTween:FlxTween;
var briTween:FlxTween;


function onCreatePost()
{
	if (ClientPrefs.shaders) 
	{
		var shaderCode:String = Paths.getTextFromFile('shaders/adjustColor.frag');
		
		if (shaderCode != null && shaderCode.length > 0) 
		{
			// =========================================================
			// GAME CAMERA
			// =========================================================
			
			colorShaderGame = new FlxRuntimeShader(shaderCode);
			colorFilterGame = new ShaderFilter(colorShaderGame);

			var gameFilters = game.camGame.filters;

			if (gameFilters == null) 
			{
				gameFilters = [colorFilterGame];
			}
			else 
			{
				gameFilters.push(colorFilterGame);
			}

			game.camGame.filters = gameFilters;


			// =========================================================
			// HUD CAMERA
			// =========================================================
			
			colorShaderHUD = new FlxRuntimeShader(shaderCode);
			colorFilterHUD = new ShaderFilter(colorShaderHUD);

			var hudFilters = game.camHUD.filters;

			if (hudFilters == null) 
			{
				hudFilters = [colorFilterHUD];
			}
			else 
			{
				hudFilters.push(colorFilterHUD);
			}

			game.camHUD.filters = hudFilters;


			// =========================================================
			// VALORES INICIAIS
			// =========================================================
			
			updateColorShaders();
		}
	}
}


function updateColorShaders()
{
	if (!ClientPrefs.shaders)
		return;


	// GAME
	if (colorShaderGame != null)
	{
		colorShaderGame.setFloat('hue', c_hue);
		colorShaderGame.setFloat('saturation', c_saturation);
		colorShaderGame.setFloat('contrast', c_contrast);
		colorShaderGame.setFloat('brightness', c_brightness);
	}


	// HUD
	if (colorShaderHUD != null)
	{
		colorShaderHUD.setFloat('hue', c_hue);
		colorShaderHUD.setFloat('saturation', c_saturation);
		colorShaderHUD.setFloat('contrast', c_contrast);
		colorShaderHUD.setFloat('brightness', c_brightness);
	}
}


function onUpdate(elapsed:Float)
{
	if (ClientPrefs.shaders)
	{
		updateColorShaders();
	}
}


function tweenColorParam(param:String, targetValue:Float, duration:Float, easeFunc:Dynamic) 
{
	if (!ClientPrefs.shaders)
		return;


	var p = param.toLowerCase();


	if (p == 'hue') 
	{
		if (hueTween != null)
			hueTween.cancel();

		hueTween = FlxTween.num(
			c_hue,
			targetValue,
			duration,
			{ease: easeFunc},
			function(v)
			{
				c_hue = v;
			}
		);
	} 


	else if (p == 'saturation' || p == 'sat') 
	{
		if (satTween != null)
			satTween.cancel();

		satTween = FlxTween.num(
			c_saturation,
			targetValue,
			duration,
			{ease: easeFunc},
			function(v)
			{
				c_saturation = v;
			}
		);
	} 


	else if (p == 'contrast' || p == 'con') 
	{
		if (conTween != null)
			conTween.cancel();

		conTween = FlxTween.num(
			c_contrast,
			targetValue,
			duration,
			{ease: easeFunc},
			function(v)
			{
				c_contrast = v;
			}
		);
	} 


	else if (p == 'brightness' || p == 'bright' || p == 'bri') 
	{
		if (briTween != null)
			briTween.cancel();

		briTween = FlxTween.num(
			c_brightness,
			targetValue,
			duration,
			{ease: easeFunc},
			function(v)
			{
				c_brightness = v;
			}
		);
	}
}


function onStepHit()
{
	switch(curStep)
	{
		case 5:
			tweenColorParam('contrast', 50, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 40, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 7:
			tweenColorParam('contrast', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 1.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('hue', 0, 1.5, FlxEase.cubeOut);

		case 8:
			tweenColorParam('contrast', 60, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 50, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 9:
			tweenColorParam('contrast', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 1.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 1.5, FlxEase.cubeOut);


		case 149:
			tweenColorParam('contrast', 50, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 40, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 150:
			tweenColorParam('contrast', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 1.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 1.5, FlxEase.cubeOut);


		case 256:
			tweenColorParam('contrast', 50, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 40, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 257:
			tweenColorParam('contrast', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 0.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 0.5, FlxEase.cubeOut);

		case 258:
			tweenColorParam('contrast', 70, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 60, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 259:
			tweenColorParam('contrast', 0, 1, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 1, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 1, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 1, FlxEase.cubeOut);


		case 334:
			tweenColorParam('contrast', 50, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 40, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 335:
			tweenColorParam('contrast', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 0.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 0.5, FlxEase.cubeOut);

		case 336:
			tweenColorParam('contrast', 70, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 60, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 337:
			tweenColorParam('contrast', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 1.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 1.5, FlxEase.cubeOut);


		case 378:
			tweenColorParam('contrast', -10, 1, FlxEase.cubeInOut);
			tweenColorParam('brightness', -17, 1, FlxEase.cubeInOut);
			tweenColorParam('saturation', -75, 1, FlxEase.cubeInOut);
			tweenColorParam('hue', -10, 1, FlxEase.cubeInOut);


		case 509:
			tweenColorParam('contrast', 50, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 40, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 510:
			tweenColorParam('contrast', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 0.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 0.5, FlxEase.cubeOut);

		case 511:
			tweenColorParam('contrast', 70, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 60, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 512:
			tweenColorParam('contrast', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 1.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 1.5, FlxEase.cubeOut);


		case 608:
			tweenColorParam('contrast', -5, 1.5, FlxEase.cubeIn);
			tweenColorParam('brightness', -10, 1.5, FlxEase.cubeIn);
			tweenColorParam('saturation', -100, 1.5, FlxEase.cubeIn);
			tweenColorParam('hue', -10, 1.5, FlxEase.cubeIn);

		case 632:
			tweenColorParam('contrast', 0, 0.01, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 0.01, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 0.01, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 0.01, FlxEase.cubeOut);


		case 641:
			tweenColorParam('contrast', 50, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 40, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 642:
			tweenColorParam('contrast', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 0.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 0.5, FlxEase.cubeOut);

		case 643:
			tweenColorParam('contrast', 70, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 60, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 644:
			tweenColorParam('contrast', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 1.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 1.5, FlxEase.cubeOut);


		case 761:
			tweenColorParam('contrast', 50, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 40, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 762:
			tweenColorParam('contrast', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 0.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 0.5, FlxEase.cubeOut);

		case 763:
			tweenColorParam('contrast', 70, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 60, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 764:
			tweenColorParam('contrast', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 1.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 1.5, FlxEase.cubeOut);


		case 977:
			tweenColorParam('contrast', 50, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 40, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 978:
			tweenColorParam('contrast', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 0.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 0.5, FlxEase.cubeOut);

		case 979:
			tweenColorParam('contrast', 70, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 60, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 980:
			tweenColorParam('contrast', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 1.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 1.5, FlxEase.cubeOut);


		case 1004:
			tweenColorParam('contrast', -15, 6, FlxEase.cubeInOut);
			tweenColorParam('brightness', -16, 6, FlxEase.cubeInOut);
			tweenColorParam('saturation', -85, 6, FlxEase.cubeInOut);
			tweenColorParam('hue', -10, 6, FlxEase.cubeInOut);

		case 1152:
			tweenColorParam('contrast', 0, 9, FlxEase.cubeOut);
			tweenColorParam('brightness', -10, 9, FlxEase.cubeOut);
			tweenColorParam('saturation', -15, 9, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 9, FlxEase.cubeOut);

		case 1274:
			tweenColorParam('contrast', -30, 0.5, FlxEase.cubeIn);
			tweenColorParam('brightness', -100, 0.5, FlxEase.cubeIn);
			tweenColorParam('saturation', -100, 0.5, FlxEase.cubeIn);
			tweenColorParam('hue', -10, 0.5, FlxEase.cubeIn);


		case 1280:
			tweenColorParam('contrast', 50, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 40, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 1281:
			tweenColorParam('contrast', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 0.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 0.5, FlxEase.cubeOut);

		case 1282:
			tweenColorParam('contrast', 70, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 60, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 1283:
			tweenColorParam('contrast', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 1.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 1.5, FlxEase.cubeOut);


		case 1294:
			tweenColorParam('contrast', 50, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 40, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 1295:
			tweenColorParam('contrast', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 0.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 0.5, FlxEase.cubeOut);

		case 1296:
			tweenColorParam('contrast', 70, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 60, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 1297:
			tweenColorParam('contrast', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 1.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 1.5, FlxEase.cubeOut);


		case 1312:
			tweenColorParam('contrast', 50, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 40, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 1313:
			tweenColorParam('contrast', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 0.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 0.5, FlxEase.cubeOut);

		case 1314:
			tweenColorParam('contrast', 70, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 60, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 1315:
			tweenColorParam('contrast', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 1.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 1.5, FlxEase.cubeOut);


		case 1412:
			tweenColorParam('contrast', 50, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 40, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 1413:
			tweenColorParam('contrast', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 0.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 0.5, FlxEase.cubeOut);

		case 1414:
			tweenColorParam('contrast', 70, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 60, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 1415:
			tweenColorParam('contrast', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 1.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 1.5, FlxEase.cubeOut);


		case 1441:
			tweenColorParam('contrast', 50, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 40, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 1442:
			tweenColorParam('contrast', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 0.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 0.5, FlxEase.cubeOut);

		case 1443:
			tweenColorParam('contrast', 70, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 60, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 1444:
			tweenColorParam('contrast', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 1.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 1.5, FlxEase.cubeOut);


		case 1480:
			tweenColorParam('contrast', 50, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 40, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 1481:
			tweenColorParam('contrast', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 0.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 0.5, FlxEase.cubeOut);

		case 1482:
			tweenColorParam('contrast', 70, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 60, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 1483:
			tweenColorParam('contrast', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 1.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 1.5, FlxEase.cubeOut);


		case 1542:
			tweenColorParam('contrast', 50, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 40, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 1543:
			tweenColorParam('contrast', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 0.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 0.5, FlxEase.cubeOut);

		case 1544:
			tweenColorParam('contrast', 70, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 60, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 1545:
			tweenColorParam('contrast', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 1.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 1.5, FlxEase.cubeOut);


		case 1549:
			tweenColorParam('contrast', 50, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 40, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 1550:
			tweenColorParam('contrast', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 0.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 0.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 0.5, FlxEase.cubeOut);

		case 1551:
			tweenColorParam('contrast', 70, 0.01, FlxEase.cubeIn);
			tweenColorParam('brightness', 60, 0.01, FlxEase.cubeIn);
			tweenColorParam('saturation', -17, 0.01, FlxEase.cubeIn);
			tweenColorParam('hue', 0, 0.01, FlxEase.cubeIn);

		case 1552:
			tweenColorParam('contrast', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('brightness', 17, 1.5, FlxEase.cubeOut);
			tweenColorParam('saturation', 0, 1.5, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 1.5, FlxEase.cubeOut);


		case 1600:
			tweenColorParam('contrast', -10, 6, FlxEase.cubeOut);
			tweenColorParam('brightness', -150, 6, FlxEase.cubeOut);
			tweenColorParam('saturation', -100, 6, FlxEase.cubeOut);
			tweenColorParam('hue', -10, 6, FlxEase.cubeOut);
	}
}