import StringTools;
import funkin.backend.FunkinShader.FunkinRuntimeShader;
import funkin.objects.Bopper;

var ext = 'stages/mira/cafeteria/';

var stageShaders:Array<Dynamic> = [];
var nightAmount:Float = 0;

public var loBlack:FlxSprite;
public var bfvent:FlxSprite;
public var ldSpeaker:FlxSprite;

public var bg:FlxSprite;
public var fg:FlxSprite;
public var tn:FlxSprite;

function makeAdjustColor():FunkinRuntimeShader
{
	var shader:FunkinRuntimeShader = newShader('adjustColor');

	shader.setFloat('hue', 0);
	shader.setFloat('saturation', 0);
	shader.setFloat('brightness', 0);
	shader.setFloat('contrast', 0);

	return shader;
}

function addStageShader(sprite:FlxSprite, darkHue:Float, darkSaturation:Float, darkBrightness:Float, darkContrast:Float):Void
{
	if (!ClientPrefs.shaders || sprite == null)
		return;

	var shader:FunkinRuntimeShader = makeAdjustColor();

	shader.setFloat('hue', darkHue);
	shader.setFloat('saturation', darkSaturation);
	shader.setFloat('brightness', darkBrightness);
	shader.setFloat('contrast', darkContrast);

	sprite.shader = shader;

	stageShaders.push({
		sprite: sprite,
		shader: shader,
		hue: darkHue,
		saturation: darkSaturation,
		brightness: darkBrightness,
		contrast: darkContrast
	});
}

function applyNight(amount:Float):Void
{
	nightAmount = amount;

	for (layer in stageShaders)
	{
		if (layer.sprite == null)
			continue;

		layer.shader.setFloat('hue', layer.hue * amount);
		layer.shader.setFloat('saturation', layer.saturation * amount);
		layer.shader.setFloat('brightness', layer.brightness * amount);
		layer.shader.setFloat('contrast', layer.contrast * amount);
	}
}

function tweenNight(target:Float):Void
{
	FlxTween.num(
		nightAmount,
		target,
		ClientPrefs.flashing ? 0.45 : 0.8,
		{ease: FlxEase.sineInOut},
		function(value:Float)
		{
			applyNight(value);
		}
	);
}

function onLoad()
{
	bg = new FlxSprite(-207, 37).loadGraphic(Paths.image(ext + 'mirabg'));
	bg.setGraphicSize(Std.int(bg.width * 1.06));

	fg = new FlxSprite(-1649, 49).loadGraphic(Paths.image(ext + 'mirafg'));
	fg.setGraphicSize(Std.int(fg.width * 1.06));

	fg.zIndex = 2;

	tn = new FlxSprite(-1659, 42).loadGraphic(Paths.image(ext + 'table_bg'));
	tn.setGraphicSize(Std.int(tn.width * 1.06));
	tn.zIndex = 10;

	loBlack = new flixel.system.FlxBGSprite();
	loBlack.color = FlxColor.BLACK;
	loBlack.alpha = 0.001;
	loBlack.screenCenter();
	loBlack.zIndex = 12;

	bfvent = new FlxSprite(70, 200);
	bfvent.frames = Paths.getSparrowAtlas(ext + 'bf_mira_vent');
	bfvent.animation.addByPrefix('vent', 'bf vent', 24, false);
	bfvent.animation.play('vent');
	bfvent.alpha = 0;

	ldSpeaker = new FlxSprite(400, 385);
	ldSpeaker.frames = Paths.getSparrowAtlas(ext + 'stereo_taken');
	ldSpeaker.animation.addByPrefix('boom', 'stereo boom', 24, false);
	ldSpeaker.zIndex = 11;
	ldSpeaker.alpha = 0;

	for (i in [bg, fg, bfvent, tn, ldSpeaker, loBlack])
	{
		add(i);
	}
}

function onSongStart()
{
	FlxTween.num(0, 1, songLength / 1000, {onUpdate: function(twn:FlxTween) applyNight(twn.value)});
	FlxTween.color(boyfriend, songLength / 1000, FlxColor.WHITE, 0xFFFFF2EA);
	FlxTween.color(gf, songLength / 1000, FlxColor.WHITE, 0xFFFFF2EA);
	FlxTween.color(dad, songLength / 1000, FlxColor.WHITE, 0xFFFFF2EA);
	FlxTween.color(pet, songLength / 1000, FlxColor.WHITE, 0xFFFFF2EA);
	FlxTween.tween(bg.colorTransform, {redMultiplier: 0.68, greenMultiplier: 0.74, blueMultiplier: 1.10}, songLength / 1000);
	FlxTween.tween(fg.colorTransform, {redMultiplier: 0.80, greenMultiplier: 0.83, blueMultiplier: 1.05}, songLength / 1000);
	FlxTween.tween(tn.colorTransform, {redMultiplier: 0.82, greenMultiplier: 0.85, blueMultiplier: 1.04}, songLength / 1000);
}

function onCreatePost()
{
	camSpecialThing([500, 475], [900, 475]);


	if (ClientPrefs.shaders)
	{
		addStageShader(bg, -20, -20, -96, 20);
		addStageShader(fg, -14, -14, -50, 10);
		addStageShader(tn, -12, -12, -44, 9);

		addStageShader(bfvent, -8, -8, -24, 6);
		addStageShader(ldSpeaker, -8, -8, -24, 6);

		addStageShader(boyfriend, -16, -16, -56, 9);
		addStageShader(gf, -16, -16, -56, 9);
		addStageShader(dad, -16, -16, -56, 9);

		if (hasPet)
			addStageShader(pet, -16, -16, -56, 9);
	}

	applyNight(0);
}

function onEvent(eventName, value1, value2)
{
	if (eventName == 'Restore Rim')
	{
		if (ClientPrefs.shaders)
			applyNight(nightAmount);

		return;
	}

	if (eventName == 'Toogus Sax')
	{
		canFollow = false;
		camFollow.x = 400;
		isCameraOnForcedPos = true;

		FlxTween.tween(
			camFollow,
			{x: 600, y: camFollow.y - 5},
			11
		);

		FlxTween.tween(
			game,
			{defaultCamZoom: .82},
			11,
			{ease: FlxEase.sineInOut}
		);
	}
	else if (eventName == 'Legacy')
	{
		if (value1 == 'Toogus Sax Out')
		{
			FlxTween.cancelTweensOf(camFollow);
			FlxTween.cancelTweensOf(game);

			canFollow = true;
			isCameraOnForcedPos = false;

			defaultCamZoom = .9;
		}
	}
	else if (eventName == 'Lights out')
	{
		if (value1 == '2' || (value1 == '1' && !ClientPrefs.flashing))
			return;

		tweenNight(2.4);
	}
	else if (eventName == 'Lights on')
	{
		if (value1 == '1' && !ClientPrefs.flashing)
			return;

		tweenNight(1);
	}
}