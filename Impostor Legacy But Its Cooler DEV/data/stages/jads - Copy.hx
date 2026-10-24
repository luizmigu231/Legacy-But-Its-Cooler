import funkin.data.ClientPrefs;
import flixel.tweens.FlxEase;
import flixel.addons.display.FlxRuntimeShader;
import funkin.game.shaders.ExtraDropShadowShader;

var bfRim:ExtraDropShadowShader;
var dadRim:ExtraDropShadowShader;
var petRim:ExtraDropShadowShader;

var bfGhostRims:Array<ExtraDropShadowShader> = [];
var dadGhostRims:Array<ExtraDropShadowShader> = [];

var currentGhostColor:FlxColor = 0xFFFFFFFF;
var ghostColorTween:FlxTween;

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

	add(bg);
	add(fans);
	add(piss);
	add(bg2);
	add(fans2);
	add(piss2);
	add(white);

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

		if (pet != null)
			pet.color = 0xFF8038A3;

		setGhostsColor(0xFF8038A3);
	}
	else
	{
		currentGhostColor = 0xFFFFFFFF;
	}
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

	applyDoubleGhostEffects();

	if (curStep == 510)
	{
		applyMiddleRim();
	}

	if (curStep == 1025)
	{
		applyOriginalRim();
	}

	if (curStep == 250)
	{
		FlxTween.tween(bars, {alpha: 1}, 0.75);
	}

	if (curStep == 256)
	{
		FlxTween.tween(white, {alpha: 1}, 0.75);
	}

	if (curStep == 260)
	{
		tweenCharactersColor(0xFF000000, 0.5);
	}

	if (curStep == 510)
	{
		FlxTween.tween(bars, {alpha: 0}, 0.5);

		if (ClientPrefs.shaders)
			tweenCharactersColor(0xFFFFFFFF, 0.5);
		else
			tweenCharactersColor(0xFF8038A3, 0.5);

		FlxTween.tween(white, {alpha: 0}, 0.5);
		FlxTween.tween(bg, {alpha: 0.5}, 0.5);
		FlxTween.tween(piss, {alpha: 0.5}, 0.5);
		FlxTween.tween(fans, {alpha: 0.5}, 0.5);
	}

	if (curStep == 772)
	{
		FlxTween.tween(bars, {alpha: 1}, 1);

		tweenCharactersColor(0xFF000000, 0.5);

		FlxTween.tween(white, {alpha: 1}, 0.5);
	}

	if (curStep == 1024)
	{
		bg.alpha = 0;
		fans.alpha = 0;
		piss.alpha = 0;

		bg2.alpha = 1;
		fans2.alpha = 1;
		piss2.alpha = 1;
	}

	if (curStep == 1025)
	{
		FlxTween.tween(bars, {alpha: 0}, 0.5);

		if (ClientPrefs.shaders)
			tweenCharactersColor(0xFFFFFFFF, 0.5);
		else
			tweenCharactersColor(0xFF8038A3, 0.5);

		FlxTween.tween(white, {alpha: 0}, 0.5);
	}

	if (curStep % 4 > 0)
		return;

	switch (woo_party)
	{
		case 1:
			bump(0.008, 0.008);

		case 2:
			bump(0.016, 0.016);

		case 3:
			bump(0.008, 0.016);

		case 4:
			bump(0.02, 0.02);

			if (ClientPrefs.flashing)
			{
				camGame.stopFade();
				camGame.flash(FlxColor.WHITE, 5);
				camGame._fxFlashAlpha = .1;
			}
	}
}

function bump(game:Float, hud:Float)
{
	if (!ClientPrefs.camZooms)
		return;

	camGame.zoom += game;
	camHUD.zoom += hud;
}

function setGhostsColor(color:FlxColor)
{
	currentGhostColor = color;

	if (boyfriend != null && boyfriend.doubleGhosts != null)
	{
		for (ghost in boyfriend.doubleGhosts)
		{
			if (ghost != null)
				ghost.color = color;
		}
	}

	if (dad != null && dad.doubleGhosts != null)
	{
		for (ghost in dad.doubleGhosts)
		{
			if (ghost != null)
				ghost.color = color;
		}
	}
}

function tweenGhostsColor(color:FlxColor, duration:Float)
{
	if (ghostColorTween != null)
		ghostColorTween.cancel();

	var startColor:FlxColor = currentGhostColor;

	if (boyfriend == null)
	{
		currentGhostColor = color;
		setGhostsColor(color);
		return;
	}

	ghostColorTween = FlxTween.color(
		boyfriend,
		duration,
		startColor,
		color,
		{
			onUpdate: function(twn:FlxTween)
			{
				currentGhostColor = boyfriend.color;

				if (boyfriend != null && boyfriend.doubleGhosts != null)
				{
					for (ghost in boyfriend.doubleGhosts)
					{
						if (ghost != null)
							ghost.color = currentGhostColor;
					}
				}

				if (dad != null && dad.doubleGhosts != null)
				{
					for (ghost in dad.doubleGhosts)
					{
						if (ghost != null)
							ghost.color = currentGhostColor;
					}
				}
			},

			onComplete: function(twn:FlxTween)
			{
				currentGhostColor = color;
				setGhostsColor(color);
			}
		}
	);
}

function tweenCharactersColor(color:FlxColor, duration:Float)
{
	if (dad != null)
		FlxTween.color(dad, duration, dad.color, color);

	if (boyfriend != null)
		FlxTween.color(boyfriend, duration, boyfriend.color, color);

	if (pet != null)
		FlxTween.color(pet, duration, pet.color, color);

	tweenGhostsColor(color, duration);
}

function createRim(
	sprite:FlxSprite,
	angle:Float,
	colorMatrix:Array<Float>,
	layerMatrix:Array<Float>,
	layerDistance:Float,
	layerStrength:Float
):ExtraDropShadowShader
{
	var rim:ExtraDropShadowShader = new ExtraDropShadowShader();

	rim.threshold = .05;
	rim.strength = .85;

	rim.setColorMatrix(colorMatrix);

	rim.addLayer(
		layerMatrix,
		layerDistance,
		layerStrength,
		.01
	);

	sprite.useRenderTexture = true;

	rim.attachedSprite = sprite;

	rim.layers[0].angle =
		(sprite.flipX ? (180 - angle) : angle);

	sprite.shader = rim;

	return rim;
}

function createGhostRim(
	sprite:FlxSprite,
	angle:Float,
	colorMatrix:Array<Float>,
	layerMatrix:Array<Float>,
	layerDistance:Float,
	layerStrength:Float
):ExtraDropShadowShader
{
	return createRim(
		sprite,
		angle,
		colorMatrix,
		layerMatrix,
		layerDistance,
		layerStrength
	);
}

function applyDoubleGhostEffects()
{
	if (!ClientPrefs.shaders)
		return;

	if (boyfriend != null && boyfriend.doubleGhosts != null)
	{
		for (ghost in boyfriend.doubleGhosts)
		{
			if (ghost == null)
				continue;

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
			{
				ghost.color = currentGhostColor;
				continue;
			}

			var ghostRim = createGhostRim(
				ghost,
				boyfriend.flipX ? 140 : 220,
				[
					.49, .425, -.17, 0, -42.5,
					-.2125, .745, -.1275, 0, -17,
					.357, -.2975, .8725, 0, -61.2,
					0, 0, 0, 1, 0
				],
				[
					-.085, .1275, .255, 0, 51,
					.2125, .4475, -.34, 0, 42.5,
					.4675, .34, .83, 0, 127.5,
					0, 0, 0, 1, 0
				],
				9,
				12
			);

			ghost.color = currentGhostColor;
			bfGhostRims.push(ghostRim);
		}
	}

	if (dad != null && dad.doubleGhosts != null)
	{
		for (ghost in dad.doubleGhosts)
		{
			if (ghost == null)
				continue;

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
			{
				ghost.color = currentGhostColor;
				continue;
			}

			var ghostRim = createGhostRim(
				ghost,
				dad.flipX ? 140 : 520,
				[
					.49, .425, -.17, 0, -42.5,
					-.2125, .745, -.1275, 0, -17,
					.357, -.2975, .8725, 0, -61.2,
					0, 0, 0, 1, 0
				],
				[
					-.085, .1275, .255, 0, 51,
					.2125, .4475, -.34, 0, 42.5,
					.4675, .34, .83, 0, 127.5,
					0, 0, 0, 1, 0
				],
				9,
				12
			);

			ghost.color = currentGhostColor;
			dadGhostRims.push(ghostRim);
		}
	}
}

function applyBFEffect()
{
	if (!ClientPrefs.shaders)
		return;

	bfRim = createRim(
		boyfriend,
		10,
		[
			.49, .425, -.17, 0, -42.5,
			-.2125, .745, -.1275, 0, -17,
			.357, -.2975, .8725, 0, -61.2,
			0, 0, 0, 1, 0
		],
		[
			-.085, .1275, .255, 0, 51,
			.2125, .4475, -.34, 0, 42.5,
			.4675, .34, .83, 0, 127.5,
			0, 0, 0, 1, 0
		],
		9,
		12
	);

	if (hasPet && pet != null)
	{
		petRim = createRim(
			pet,
			10,
			[
				.49, .425, -.17, 0, -42.5,
				-.2125, .745, -.1275, 0, -17,
				.357, -.2975, .8725, 0, -61.2,
				0, 0, 0, 1, 0
			],
			[
				-.085, .1275, .255, 0, 51,
				.2125, .4475, -.34, 0, 42.5,
				.4675, .34, .83, 0, 127.5,
				0, 0, 0, 1, 0
			],
			9,
			12
		);
	}
}

function applyDadEffect()
{
	if (!ClientPrefs.shaders)
		return;

	dadRim = createRim(
		dad,
		10,
		[
			.49, .425, -.17, 0, -42.5,
			-.2125, .745, -.1275, 0, -17,
			.357, -.2975, .8725, 0, -61.2,
			0, 0, 0, 1, 0
		],
		[
			-.085, .1275, .255, 0, 51,
			.2125, .4475, -.34, 0, 42.5,
			.4675, .34, .83, 0, 127.5,
			0, 0, 0, 1, 0
		],
		9,
		12
	);
}

function applyMiddleRim()
{
	if (!ClientPrefs.shaders)
		return;

	var matrix:Array<Float> = [
		.445, .4625, -.185, 0, -46.25,
		-.23125, .7225, -.13875, 0, -18.5,
		.3885, -.32375, .86125, 0, -66.6,
		0, 0, 0, 1, 0
	];

	var layer:Array<Float> = [
		-.0925, .13875, .2775, 0, 55.5,
		.23125, .39875, -.37, 0, 46.25,
		.50875, .37, .815, 0, 138.75,
		0, 0, 0, 1, 0
	];

	bfRim = createRim(
		boyfriend,
		10,
		matrix,
		layer,
		9.5,
		13
	);

	dadRim = createRim(
		dad,
		10,
		matrix,
		layer,
		9.5,
		13
	);

	if (hasPet && pet != null)
	{
		petRim = createRim(
			pet,
			10,
			matrix,
			layer,
			9.5,
			13
		);
	}

	bfGhostRims = [];
	dadGhostRims = [];

	if (boyfriend.doubleGhosts != null)
	{
		for (ghost in boyfriend.doubleGhosts)
		{
			if (ghost == null)
				continue;

			var rim = createGhostRim(
				ghost,
				boyfriend.flipX ? 140 : 220,
				matrix,
				layer,
				9.5,
				13
			);

			ghost.color = currentGhostColor;
			bfGhostRims.push(rim);
		}
	}

	if (dad.doubleGhosts != null)
	{
		for (ghost in dad.doubleGhosts)
		{
			if (ghost == null)
				continue;

			var rim = createGhostRim(
				ghost,
				dad.flipX ? 140 : 520,
				matrix,
				layer,
				9.5,
				13
			);

			ghost.color = currentGhostColor;
			dadGhostRims.push(rim);
		}
	}
}

function applyOriginalRim()
{
	if (!ClientPrefs.shaders)
		return;

	var matrix:Array<Float> = [
		.4, .5, -.2, 0, -50,
		-.25, .7, -.15, 0, -20,
		.42, -.35, .85, 0, -72,
		0, 0, 0, 1, 0
	];

	var layer:Array<Float> = [
		-.1, .15, .3, 0, 60,
		.25, .35, -.4, 0, 50,
		.55, .4, .8, 0, 150,
		0, 0, 0, 1, 0
	];

	bfRim = createRim(
		boyfriend,
		10,
		matrix,
		layer,
		10,
		14
	);

	dadRim = createRim(
		dad,
		10,
		matrix,
		layer,
		10,
		14
	);

	if (hasPet && pet != null)
	{
		petRim = createRim(
			pet,
			10,
			matrix,
			layer,
			10,
			14
		);
	}

	bfGhostRims = [];
	dadGhostRims = [];

	if (boyfriend.doubleGhosts != null)
	{
		for (ghost in boyfriend.doubleGhosts)
		{
			if (ghost == null)
				continue;

			var rim = createGhostRim(
				ghost,
				boyfriend.flipX ? 140 : 220,
				matrix,
				layer,
				10,
				14
			);

			ghost.color = currentGhostColor;
			bfGhostRims.push(rim);
		}
	}

	if (dad.doubleGhosts != null)
	{
		for (ghost in dad.doubleGhosts)
		{
			if (ghost == null)
				continue;

			var rim = createGhostRim(
				ghost,
				dad.flipX ? 140 : 520,
				matrix,
				layer,
				10,
				14
			);

			ghost.color = currentGhostColor;
			dadGhostRims.push(rim);
		}
	}
}