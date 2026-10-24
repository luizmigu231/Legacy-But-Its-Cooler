import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var colorShaderGame:FlxRuntimeShader;
var colorShaderHUD:FlxRuntimeShader;

var colorFilterGame:ShaderFilter;
var colorFilterHUD:ShaderFilter;

var c_hue:Float = 0;
var c_saturation:Float = 0;
var c_contrast:Float = 0;
var c_brightness:Float = 0;

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
			// GAME
			colorShaderGame = new FlxRuntimeShader(shaderCode);
			colorFilterGame = new ShaderFilter(colorShaderGame);

			var gameFilters = game.camGame.filters;

			if (gameFilters == null)
				gameFilters = [colorFilterGame];
			else
				gameFilters.push(colorFilterGame);

			game.camGame.filters = gameFilters;


			// HUD
			colorShaderHUD = new FlxRuntimeShader(shaderCode);
			colorFilterHUD = new ShaderFilter(colorShaderHUD);

			var hudFilters = game.camHUD.filters;

			if (hudFilters == null)
				hudFilters = [colorFilterHUD];
			else
				hudFilters.push(colorFilterHUD);

			game.camHUD.filters = hudFilters;


			updateColorShaders();
		}
	}
}


function updateColorShaders()
{
	if (!ClientPrefs.shaders)
		return;

	if (colorShaderGame != null)
	{
		colorShaderGame.setFloat('hue', c_hue);
		colorShaderGame.setFloat('saturation', c_saturation);
		colorShaderGame.setFloat('contrast', c_contrast);
		colorShaderGame.setFloat('brightness', c_brightness);
	}

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
		updateColorShaders();
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
		// =========================================================
		// STEP 768 — PERDE A COR DURANTE 16 STEPS
		// 180 BPM = 1.3333 segundos
		// =========================================================

		case 760:
			tweenColorParam('contrast', -5, 1.3333, FlxEase.cubeIn);
			tweenColorParam('brightness', -10, 1.3333, FlxEase.cubeIn);
			tweenColorParam('saturation', -100, 1.3333, FlxEase.cubeIn);
			tweenColorParam('hue', -10, 1.3333, FlxEase.cubeIn);


		// =========================================================
		// STEP 1024 — VOLTA À COR EM 1 SEGUNDO
		// =========================================================

		case 1024:
			tweenColorParam('contrast', 0, 1, FlxEase.cubeOut);
			tweenColorParam('brightness', 0, 1, FlxEase.cubeOut);
			tweenColorParam('saturation', 20, 1, FlxEase.cubeOut);
			tweenColorParam('hue', 0, 1, FlxEase.cubeOut);
			
		case 1280:
			tweenColorParam('contrast', 0, 1, FlxEase.cubeOut);
			tweenColorParam('brightness', 0, 1, FlxEase.cubeOut);
			tweenColorParam('saturation', 8, 1, FlxEase.cubeOut);
			tweenColorParam('hue', 0, 1, FlxEase.cubeOut);
	}
}