import funkin.data.ClientPrefs;
import flixel.tweens.FlxEase;
import funkin.game.shaders.ExtraDropShadowShader;

var bfRim:ExtraDropShadowShader;
var dadRim:ExtraDropShadowShader;
var petRim:ExtraDropShadowShader;
var bars:FlxSpriteGroup;

var bg:FlxSprite;
var fans:FlxSprite;
var piss:FlxSprite;
var bg2:FlxSprite;
var fans2:FlxSprite;
var piss2:FlxSprite;
var white:FlxSprite;

var ext:String = 'stages/skeld/jads-dark/';

function onLoad()
{
	bars = new FlxSpriteGroup();
	bars.cameras = [camHUD];
	bars.alpha = 0;
	add(bars);

	for (i in 0...2)
	{
		var bar = new FlxSprite().makeGraphic(FlxG.width + 3, 90, FlxColor.BLACK);
		bar.y = i == 1 ? 630 : 0;
		bars.add(bar);
	}

	bg = new FlxSprite(-595, -195).loadGraphic(Paths.image(ext + 'O2Backgroundnorm'));
	bg.alpha = 1;

	bg2 = new FlxSprite(-595, -195).loadGraphic(Paths.image(ext + 'O2Background'));
	bg2.alpha = 0;

	fans = new FlxSprite(-166.25, 68.45);
	fans.frames = Paths.getSparrowAtlas(ext + 'fansssnorm');
	fans.animation.addByPrefix('bop', 'fansss instance 1', 24, true);
	fans.animation.play('bop');
	fans.alpha = 1;

	fans2 = new FlxSprite(-166.25, 68.45);
	fans2.frames = Paths.getSparrowAtlas(ext + 'fansss');
	fans2.animation.addByPrefix('bop', 'fansss instance 1', 24, true);
	fans2.animation.play('bop');
	fans2.alpha = 0;

	piss = new FlxSprite(-453.9, 310.2).loadGraphic(Paths.image(ext + 'switchnorm'));
	piss.alpha = 1;

	piss2 = new FlxSprite(-453.9, 310.2).loadGraphic(Paths.image(ext + 'switch'));
	piss2.alpha = 0;

	white = new FlxSprite(-595, -195).loadGraphic(Paths.image(ext + 'white'));
	white.alpha = 0;

	add(bg);
	add(fans);
	add(piss);
	add(white);
	add(bg2);
	add(fans2);
	add(piss2);
}

function onCreatePost()
{
	camSpecialThing([600, 440], [1150, 440]);

	applyBFEffect();
	applyDadEffect();

	boyfriendRim = 0;
}

function onSongStart()
{
	onStepHit();

	var rampTime:Float = FlxG.sound.music.length / 70;

	if (bfRim != null)
	{
		FlxTween.tween(bfRim, {strength: 6.5}, rampTime);
		FlxTween.tween(bfRim.layers[0], {strength: 1}, rampTime);
	}

	if (dadRim != null)
	{
		FlxTween.tween(dadRim, {strength: 6.5}, rampTime);
		FlxTween.tween(dadRim.layers[0], {strength: 1}, rampTime);
	}

	if (petRim != null)
	{
		FlxTween.tween(petRim, {strength: 6.5}, rampTime);
		FlxTween.tween(petRim.layers[0], {strength: 1}, rampTime);
	}
}

public var woo_party:Int = 0;

function onEndSong()
{
	woo_party = 0;
}

function onStepHit()
{
	if (curStep == 200)
	{
		FlxTween.tween(bg2, {alpha: 1}, 60);
		FlxTween.tween(bg, {alpha: 0}, 60);
		FlxTween.tween(piss, {alpha: 0}, 60);
		FlxTween.tween(piss2, {alpha: 1}, 60);
		FlxTween.tween(fans, {alpha: 0}, 60);
		FlxTween.tween(fans2, {alpha: 1}, 60);
	}

	modchart(curStep);
}

function bump(game:Float, hud:Float)
{
	if (!ClientPrefs.camZooms)
		return;

	camGame.zoom += game;
	camHUD.zoom += hud;
}

function applyBFEffect()
{
	if (ClientPrefs.shaders)
	{
		var blackRimlightBase:ExtraDropShadowShader = new ExtraDropShadowShader();
		var baseAngle:Float = 10;

		blackRimlightBase.threshold = .05;
		blackRimlightBase.strength = .85;

		blackRimlightBase.setColorMatrix([
			.49, .425, -.17, 0, -42.5,
			-.2125, .745, -.1275, 0, -17,
			.357, -.2975, .8725, 0, -61.2,
			0, 0, 0, 1, 0
		]);

		blackRimlightBase.addLayer([
			-.085, .1275, .255, 0, 51,
			.2125, .4475, -.34, 0, 42.5,
			.4675, .34, .83, 0, 127.5,
			0, 0, 0, 1, 0
		], 9, 12, .01);

		if (boyfriend.getFlag('backlit') != true)
		{
			bfRim = new ExtraDropShadowShader().copyFrom(blackRimlightBase);
			bfRim.attachedSprite = boyfriend;

			boyfriend.useRenderTexture = true;
			boyfriend.shader = bfRim;

			bfRim.layers[0].angle =
				(boyfriend.flipX ? (180 - baseAngle) : baseAngle);

			bfRim.strength = 0;
			bfRim.layers[0].strength = 0;
		}

		if (hasPet)
		{
			petRim = new ExtraDropShadowShader().copyFrom(blackRimlightBase);
			petRim.attachedSprite = pet;

			pet.useRenderTexture = true;
			pet.shader = petRim;

			petRim.layers[0].angle =
				(pet.flipX ? (180 - baseAngle) : baseAngle);

			petRim.strength = 0;
			petRim.layers[0].strength = 0;
		}
	}
}

function applyDadEffect()
{
	if (ClientPrefs.shaders)
	{
		var blackRimlightBase:ExtraDropShadowShader = new ExtraDropShadowShader();
		var baseAngle:Float = 10;

		blackRimlightBase.threshold = .05;
		blackRimlightBase.strength = .85;

		blackRimlightBase.setColorMatrix([
			.49, .425, -.17, 0, -42.5,
			-.2125, .745, -.1275, 0, -17,
			.357, -.2975, .8725, 0, -61.2,
			0, 0, 0, 1, 0
		]);

		blackRimlightBase.addLayer([
			-.085, .1275, .255, 0, 51,
			.2125, .4475, -.34, 0, 42.5,
			.4675, .34, .83, 0, 127.5,
			0, 0, 0, 1, 0
		], 9, 12, .01);

		if (dad.getFlag('backlit') != true)
		{
			dadRim = new ExtraDropShadowShader().copyFrom(blackRimlightBase);
			dadRim.attachedSprite = dad;

			dad.useRenderTexture = true;
			dad.shader = dadRim;

			dadRim.layers[0].angle =
				(dad.flipX ? (180 - baseAngle) : baseAngle);

			dadRim.strength = 0;
			dadRim.layers[0].strength = 0;
		}
	}
}