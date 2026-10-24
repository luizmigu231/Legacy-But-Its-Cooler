import StringTools;
import funkin.backend.FunkinShader.FunkinRuntimeShader;
import funkin.objects.Bopper;

var ext = 'stages/mira/cafeteria/';

var stageShaders:Array<Dynamic> = [];
var nightAmount:Float = 1;

public var loBlack:FlxSprite;
public var bfvent:FlxSprite;
public var ldSpeaker:FlxSprite;

var walkers:Array<AmongWalker> = [];
var lightsCount:Int = 0;

public var bg:FlxSprite;
public var fg:FlxSprite;
public var tn:FlxSprite;
public var blue:FlxSprite;
public var orange:FlxSprite;
public var white:FlxSprite;

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
	// none of the first 3 objects line up 1:1 bc they were cropped and they don't round up/down the same yay!!!

	bg = new FlxSprite(-207, 37).loadGraphic(Paths.image(ext + 'mirabg'));
	bg.setGraphicSize(Std.int(bg.width * 1.06));
	bg.setColorTransform(0.80, 0.84, 1.08);

	fg = new FlxSprite(-1649, 49).loadGraphic(Paths.image(ext + 'mirafg'));
	fg.setGraphicSize(Std.int(fg.width * 1.06));
	fg.setColorTransform(0.86, 0.88, 1.05);

	blue = new Bopper(1040, 190, 2);
	blue.frames = Paths.getSparrowAtlas(ext + 'mirascaredmates');
	blue.flipX = true;
	blue.scale.set(0.8, 0.8);
	blue.animation.addByPrefix('idle', 'blue', 24, false);
	blue.animation.addByPrefix('idle-dead', '1body', 24, false);
	blue.addOffset('idle-dead', 0, -230);
	blue.zIndex = 3;
	stage.add(blue);

	orange = new Bopper(-350, 200, 2);
	orange.frames = Paths.getSparrowAtlas(ext + 'mirascaredmates');
	orange.scale.set(0.8, 0.8);
	orange.animation.addByPrefix('idle', 'orange', 24, false);
	orange.animation.addByPrefix('idle-dead', '2body', 24, false);
	orange.addOffset('idle-dead', 0, -300);
	orange.zIndex = 3;
	stage.add(orange);

	fg.zIndex = 2;

	white = new Bopper(1200, 150, 2);
	white.frames = Paths.getSparrowAtlas(ext + 'mirascaredmates');
	white.scale.set(0.8, 0.8);
	white.animation.addByPrefix('idle', 'white', 24, false);
	white.animation.addByPrefix('idle-dead', '3body', 24, false);
	white.addOffset('idle-dead', 0, -300);
	white.flipX = true;
	white.zIndex = 4;
	stage.add(white);

	blue.playAnim('idle');
	blue.animation.curAnim.curFrame = 0;

	orange.playAnim('idle');
	orange.animation.curAnim.curFrame = 0;

	white.playAnim('idle');
	white.animation.curAnim.curFrame = 0;

	tn = new FlxSprite(-1659, 42).loadGraphic(Paths.image(ext + 'table_bg'));
	tn.setGraphicSize(Std.int(tn.width * 1.06));
	tn.setColorTransform(0.88, 0.90, 1.04);
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

function onCreatePost()
{
	camSpecialThing([500, 475], [900, 475]);

	boyfriend.color = 0xFFFFF2EA;
	gf.color = 0xFFFFF2EA;
	dad.color = 0xFFFFF2EA;

	if (hasPet)
		pet.color = 0xFFFFF2EA;

	if (ClientPrefs.shaders)
	{
		addStageShader(bg, -16, -16, -78, 16);
		addStageShader(fg, -10, -10, -38, 8);
		addStageShader(tn, -8, -8, -32, 7);

		addStageShader(bfvent, -6, -6, -20, 5);
		addStageShader(ldSpeaker, -6, -6, -20, 5);

		// Personagens - somente eles foram ajustados.
		addStageShader(boyfriend, -12, -12, -42, 7);
		addStageShader(gf, -12, -12, -42, 7);
		addStageShader(dad, -12, -12, -42, 7);

		if (hasPet)
			addStageShader(pet, -12, -12, -42, 7);

		addStageShader(blue, -12, -12, -42, 7);
		addStageShader(orange, -12, -12, -42, 7);
		addStageShader(white, -12, -12, -42, 7);
	}

	applyNight(1);
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

		tweenNight(2);
	}
	else if (eventName == 'Lights on')
	{
		if (value1 == '1' && !ClientPrefs.flashing)
			return;

		tweenNight(1);
	}
}

function onCountdownTick(tick:Int)
{
	if (tick == 0 || tick == 2)
	{
		blue.onBeatHit();
		orange.onBeatHit();
		white.onBeatHit();
	}
}

function onBeatHit()
{
	if (curBeat % 2 == 0)
	{
		blue.onBeatHit();
		orange.onBeatHit();
		white.onBeatHit();
	}

	if (curBeat == 92)
		blue.idleSuffix = "-dead";

	if (curBeat == 172)
		orange.idleSuffix = "-dead";

	if (curBeat == 312)
		white.idleSuffix = "-dead";
}