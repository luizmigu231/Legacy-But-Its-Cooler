import funkin.data.ClientPrefs;
import flixel.tweens.FlxEase;
import flixel.addons.display.FlxRuntimeShader;
import funkin.game.shaders.ExtraDropShadowShader;

var bfRim:ExtraDropShadowShader;
var dadRim:ExtraDropShadowShader;
var petRim:ExtraDropShadowShader;

var bfGhostRims:Array<ExtraDropShadowShader> = [];
var dadGhostRims:Array<ExtraDropShadowShader> = [];

var bars:FlxSpriteGroup;

var bg:FlxSprite;
var fans:FlxSprite;
var piss:FlxSprite;
var bg2:FlxSprite;
var fans2:FlxSprite;
var piss2:FlxSprite;
var white:FlxSprite;

var darkness:FlxSprite;

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

	bg = new FlxSprite(-595, -195).loadGraphic(Paths.image(ext + 'O2Background'));
	bg2 = new FlxSprite(-595, -195).loadGraphic(Paths.image(ext + 'O2Backgroundstar'));
	bg2.alpha = 0;

	fans = new FlxSprite(-166.25, 68.45);
	fans.frames = Paths.getSparrowAtlas(ext + 'fansss');
	fans.animation.addByPrefix('bop', 'fansss instance 1', 24, true);
	fans.animation.play('bop');

	fans2 = new FlxSprite(-166.25, 68.45);
	fans2.frames = Paths.getSparrowAtlas(ext + 'fansssstar');
	fans2.animation.addByPrefix('bop', 'fansss instance 1', 24, true);
	fans2.animation.play('bop');
	fans2.alpha = 0;

	piss = new FlxSprite(-453.9, 310.2).loadGraphic(Paths.image(ext + 'switch'));
	piss2 = new FlxSprite(-453.9, 310.2).loadGraphic(Paths.image(ext + 'switchstar'));
	piss2.alpha = 0;

	white = new FlxSprite(-595, -195).loadGraphic(Paths.image(ext + 'white'));
	white.alpha = 0;

	darkness = new FlxSprite(-FlxG.width, -FlxG.height);
	darkness.makeGraphic(FlxG.width * 6, FlxG.height * 6, 0xFF000000);
	darkness.scrollFactor.set(0, 0);
	darkness.cameras = [camOther];
	darkness.alpha = 1;

	add(bg);
	add(fans);
	add(piss);
	add(bg2);
	add(fans2);
	add(piss2);
	add(white);
	add(darkness);
}

function onCreatePost()
{
	camSpecialThing([600, 440], [1150, 440]);

	applyBFEffect();
	applyDadEffect();

	if (!ClientPrefs.shaders)
	{
		dad.color = 0xFF8038A3;
		boyfriend.color = 0xFF8038A3;
		pet.color = 0xFF8038A3;
	}

	dad.color = 0x00000000;
	boyfriend.color = 0x00000000;
	pet.color = 0x00000000;

	white.alpha = 1;
	bars.alpha = 1;
}

function onSongStart()
{
	onStepHit();
}

public var woo_party:Int = 0;

function onEndSong()
{
	woo_party = 0;
}

function onStepHit()
{
	modchart(curStep);

	// Tenta aplicar aos ghosts caso eles sejam criados
	// depois do onCreatePost.
	applyDoubleGhostEffects();

	if (curStep == 63)
	{
		FlxTween.tween(darkness, {alpha: 0}, 7.5);
	}

	if (curStep == 130)
	{
		triggerEventNote('flash', '3', '');

		dad.color = 0xFFFFFFFF;
		boyfriend.color = 0xFFFFFFFF;
		pet.color = 0xFFFFFFFF;

		white.alpha = 0;
	}

	if (curStep == 192)
	{
		FlxTween.tween(bars, {alpha: 0}, 1);
	}

	if (curStep == 648)
	{
		triggerEventNote('flash', '3', '');

		dad.color = 0x00000000;
		boyfriend.color = 0x00000000;
		pet.color = 0x00000000;

		bars.alpha = 1;

		bg.color = 0x00000000;
		piss.color = 0x00000000;
		fans.color = 0x00000000;
		
		for (obj in [playHUD.healthBar, playHUD.iconP1, playHUD.iconP2, playHUD.scoreTxt, playHUD.timeBar, playHUD.timeTxt]) obj.visible = false;
	}

	if (curStep == 902)
	{
		triggerEventNote('flash', '3', '');

		dad.color = 0xFFFFFFFF;
		boyfriend.color = 0xFFFFFFFF;
		pet.color = 0xFFFFFFFF;

		white.alpha = 0;

		bg.color = 0xFFFFFFFF;
		piss.color = 0xFFFFFFFF;
		fans.color = 0xFFFFFFFF;
		
		for (obj in [playHUD.healthBar, playHUD.iconP1, playHUD.iconP2, playHUD.scoreTxt, playHUD.timeBar, playHUD.timeTxt]) obj.visible = true;
	}

	if (curStep == 960)
	{
		FlxTween.tween(bars, {alpha: 0}, 1);
	}

	if (curStep == 1420)
	{
		FlxTween.tween(bars, {alpha: 1}, 4);

		FlxTween.tween(bg, {alpha: 0.2}, 4);
		FlxTween.tween(fans, {alpha: 0.2}, 4);
		FlxTween.tween(piss, {alpha: 0.2}, 4);
	}
}

function bump(game:Float, hud:Float)
{
	if (!ClientPrefs.camZooms)
		return;

	camGame.zoom += game;
	camHUD.zoom += hud;
}

function createGhostRim(sprite:FlxSprite, angle:Float):ExtraDropShadowShader
{
	var rim:ExtraDropShadowShader = new ExtraDropShadowShader();
	var baseAngle:Float = 10;

	rim.threshold = .05;
	rim.strength = .85;

	rim.setColorMatrix([
	.49, .425, -.17, 0, -42.5,
	-.2125, .745, -.1275, 0, -17,
	.357, -.2975, .8725, 0, -61.2,
	0, 0, 0, 1, 0
]);

	rim.addLayer([
	-.085, .1275, .255, 0, 51,
	.2125, .4475, -.34, 0, 42.5,
	.4675, .34, .83, 0, 127.5,
	0, 0, 0, 1, 0
], 9, 12, .01);

	sprite.useRenderTexture = true;

	rim.attachedSprite = sprite;

	rim.layers[0].angle =
		(sprite.flipX ? (180 - angle) : angle);

	sprite.shader = rim;

	return rim;
}

function applyDoubleGhostEffects()
{
	if (!ClientPrefs.shaders)
		return;

	// =========================================
	// BOYFRIEND DOUBLE GHOSTS
	// =========================================

	if (boyfriend != null && boyfriend.doubleGhosts != null)
	{
		for (ghost in boyfriend.doubleGhosts)
		{
			if (ghost == null)
				continue;

			// Evita aplicar outro shader no mesmo ghost.
			var alreadyExists:Bool = false;

			for (rim in bfGhostRims)
			{
				if (rim != null && rim.attachedSprite == ghost)
				{
					alreadyExists = true;
					break;
				}
			}

			if (alreadyExists)
				continue;

			var ghostRim = createGhostRim(
				ghost,
				boyfriend.flipX ? 140 : 220
			);

			bfGhostRims.push(ghostRim);
		}
	}

	// =========================================
	// DAD DOUBLE GHOSTS
	// =========================================

	if (dad != null && dad.doubleGhosts != null)
	{
		for (ghost in dad.doubleGhosts)
		{
			if (ghost == null)
				continue;

			// Evita aplicar outro shader no mesmo ghost.
			var alreadyExists:Bool = false;

			for (rim in dadGhostRims)
			{
				if (rim != null && rim.attachedSprite == ghost)
				{
					alreadyExists = true;
					break;
				}
			}

			if (alreadyExists)
				continue;

			var ghostRim = createGhostRim(
				ghost,
				dad.flipX ? 140 : 520
			);

			dadGhostRims.push(ghostRim);
		}
	}
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
			bfRim =
				new ExtraDropShadowShader()
				.copyFrom(blackRimlightBase);

			bfRim.attachedSprite = boyfriend;

			boyfriend.useRenderTexture = true;

			bfRim.layers[0].angle = (dad.flipX ? (180 - baseAngle) : baseAngle);
		}

		if (hasPet)
		{
			petRim =
				new ExtraDropShadowShader()
				.copyFrom(blackRimlightBase);

			petRim.attachedSprite = pet;

			pet.useRenderTexture = true;

			petRim.layers[0].angle = (dad.flipX ? (180 - baseAngle) : baseAngle);
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
			dadRim =
				new ExtraDropShadowShader()
				.copyFrom(blackRimlightBase);

			dadRim.attachedSprite = dad;

			dad.useRenderTexture = true;

			dadRim.layers[0].angle = (dad.flipX ? (180 - baseAngle) : baseAngle);
		}
	}
}