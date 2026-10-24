import funkin.backend.FunkinShader.FunkinRuntimeShader;
import funkin.game.shaders.ExtraDropShadowShader;

var ext = 'stages/mira/reactor/';

var bg0:FlxSprite;
var bg:FlxSprite;
var bg2:FlxSprite;
var bg3:FlxSprite;

var lightoverlay:FlxSprite;
var mainoverlay:FlxSprite;

var toogusorange:FlxSprite;
var toogusblue:FlxSprite;

var coreClaw:FunkinSprite;
var coreGlow:FunkinSprite;
var coreRing:FunkinSprite;

var coreGlowRim:ExtraDropShadowShader;
var coreRingRim:ExtraDropShadowShader;
var coreClawRim:ExtraDropShadowShader;

function makeAdjustColor():FunkinRuntimeShader
{
	var shader:FunkinRuntimeShader = newShader('adjustColor');

	shader.setFloat('hue', 0);
	shader.setFloat('saturation', 0);
	shader.setFloat('brightness', 0);
	shader.setFloat('contrast', 0);

	return shader;
}

function colorize(sprite:FlxSprite, hue:Float, saturation:Float, brightness:Float, contrast:Float)
{
	if (sprite == null) return;

	var shader:FunkinRuntimeShader = makeAdjustColor();

	shader.setFloat('hue', hue);
	shader.setFloat('saturation', saturation);
	shader.setFloat('brightness', brightness);
	shader.setFloat('contrast', contrast);

	sprite.shader = shader;
}

function makeCoreGlowRim():ExtraDropShadowShader
{
	var shader:ExtraDropShadowShader = new ExtraDropShadowShader();

	shader.threshold = .018;

	shader.setColorMatrix([
		1.00, .18, .38, 0, 18,
		.02, .30, .10, 0, -10,
		.24, .00, 1.02, 0, 28,
		0, 0, 0, 1, 0
	]);

	shader.addLayer([
		1.00, .12, .30, 0, 42,
		.02, .22, .08, 0, -2,
		.18, .01, .98, 0, 22,
		0, 0, 0, 1, 0
	], 90, 22, .055);

	shader.addLayer([
		1.00, .03, .18, 0, 58,
		0, .11, .06, 0, 2,
		.22, 0, .90, 0, 38,
		0, 0, 0, 1, 0
	], 270, 42, .035);

	return shader;
}

function makeCoreRingRim():ExtraDropShadowShader
{
	var shader:ExtraDropShadowShader = new ExtraDropShadowShader();

	shader.threshold = .018;

	shader.setColorMatrix([
		1.00, .20, .42, 0, 22,
		.02, .36, .12, 0, -8,
		.26, .00, 1.05, 0, 34,
		0, 0, 0, 1, 0
	]);

	shader.addLayer([
		1.00, .12, .32, 0, 36,
		.01, .27, .09, 0, 0,
		.20, .01, 1.00, 0, 24,
		0, 0, 0, 1, 0
	], 90, 20, .06);

	shader.addLayer([
		1.00, .03, .20, 0, 56,
		0, .13, .06, 0, 2,
		.23, 0, .92, 0, 36,
		0, 0, 0, 1, 0
	], 270, 38, .035);

	return shader;
}

function makeCoreClawRim():ExtraDropShadowShader
{
	var shader:ExtraDropShadowShader = new ExtraDropShadowShader();

	shader.threshold = .04;

	shader.setColorMatrix([
		.78, .08, .20, 0, -4,
		.03, .62, .13, 0, 8,
		.15, .04, .86, 0, 8,
		0, 0, 0, 1, 0
	]);

	shader.addLayer([
		.92, .12, .24, 0, 28,
		.02, .66, .10, 0, 8,
		.10, .03, .80, 0, 4,
		0, 0, 0, 1, 0
	], 120, 20, .05);

	shader.addLayer([
		.72, .05, .30, 0, 20,
		.01, .44, .08, 0, 2,
		.16, .01, .76, 0, 14,
		0, 0, 0, 1, 0
	], 300, 28, .035);

	return shader;
}

function onLoad()
{
	bg0 = new FlxSprite(290, 0).loadGraphic(Paths.image(ext + 'wallbgthing'));
	bg0.scale.set(2, 2);
	bg0.updateHitbox();
	add(bg0);

	bg = new FlxSprite(0, 762).loadGraphic(Paths.image(ext + 'floornew'));
	add(bg);

	toogusorange = new FlxSprite(875, 890);
	toogusorange.frames = Paths.getSparrowAtlas(ext + 'yellowglita');
	toogusorange.animation.addByPrefix('bop', 'Pillars with crewmates instance 1', 24, false);
	toogusorange.animation.play('bop');
	toogusorange.setGraphicSize(Std.int(toogusorange.width * 1));
	add(toogusorange);

	bg2 = new FlxSprite(408, 579).loadGraphic(Paths.image(ext + 'backbars'));
	add(bg2);

	toogusblue = new FlxSprite(450, 995);
	toogusblue.frames = Paths.getSparrowAtlas(ext + 'browngeoff');
	toogusblue.animation.addByPrefix('bop', 'Pillars with crewmates instance 1', 24, false);
	toogusblue.animation.play('bop');
	toogusblue.setGraphicSize(Std.int(toogusblue.width * 1));
	add(toogusblue);

	bg3 = new FlxSprite(58, 546).loadGraphic(Paths.image(ext + 'frontpillars'));
	add(bg3);

	coreGlow = new FunkinSprite(1150, 60).loadAtlas('${ext}coreGlow');
	coreGlow.scale.set(2.7, 2.7);
	coreGlow.updateHitbox();
	add(coreGlow);

	if (ClientPrefs.flashing)
	{
		coreGlow.addAnimByPrefix('bop', 'reactor core', 24, false);
	}
	else
	{
		coreGlow.addAnimByIndices('bop', 'reactor core', [for (i in 25 ... 30) i], 24, false);
	}

	coreGlow.animation.play('bop');

	coreRing = new FunkinSprite(1295, 212).loadAtlas('${ext}coreRing');
	coreRing.addAnimByPrefix('ring', 'reactor core ring', 24, true);
	coreRing.animation.play('ring');
	coreRing.scale.set(1.35, 1.35);
	coreRing.blend = BlendMode.ADD;
	coreRing.updateHitbox();
	add(coreRing);

	coreClaw = new FunkinSprite(1222, 395).loadGraphic(Paths.image('${ext}coreClaw'));
	add(coreClaw);

	coreGlow.scrollFactor.set(.95, .95);
	coreRing.scrollFactor.set(.95, .95);
	coreClaw.scrollFactor.set(.98, 1.3);
}

function onCreatePost()
{
	lightoverlay = new FlxSprite(0, 0).loadGraphic(Paths.image(ext + 'frontblack'));
	lightoverlay.scale.set(4, 4);
	lightoverlay.updateHitbox();
	add(lightoverlay);

	mainoverlay = new FlxSprite(750, 100);
	mainoverlay.frames = Paths.getSparrowAtlas(ext + 'yeahman');
	mainoverlay.animation.addByPrefix('bop', 'Reactor Overlay Top instance 1', 24, true);
	mainoverlay.animation.play('bop');
	mainoverlay.blend = BlendMode.ADD;
	add(mainoverlay);

	colorize(bg0, -8, -42, -24, 34);
	colorize(bg, -11, -50, -28, 38);
	colorize(toogusorange, 6, -12, -12, 26);
	colorize(bg2, -5, -40, -22, 36);
	colorize(toogusblue, -16, -34, -20, 31);
	colorize(bg3, -9, -52, -31, 40);

	colorize(lightoverlay, -4, -62, -34, 28);
	colorize(mainoverlay, 8, 26, 6, 15);

	if (ClientPrefs.shaders)
	{
		coreGlowRim = makeCoreGlowRim();
		coreGlow.shader = coreGlowRim;
		coreGlow.useRenderTexture = true;

		coreRingRim = makeCoreRingRim();
		coreRing.shader = coreRingRim;
		coreRing.useRenderTexture = true;

		coreClawRim = makeCoreClawRim();
		coreClaw.shader = coreClawRim;
		coreClaw.useRenderTexture = true;

		var rimlightBase:ExtraDropShadowShader = new ExtraDropShadowShader();

		rimlightBase.threshold = .03;

		rimlightBase.setColorMatrix([
			.88, .10, .25, 0, -16,
			.02, .58, .11, 0, 4,
			.11, .04, .84, 0, -2,
			0, 0, 0, 1, 0
		]);

		rimlightBase.addLayer([
			1.00, .17, .36, 0, 102,
			.04, .72, .13, 0, 18,
			.22, .04, 1.00, 0, 42,
			0, 0, 0, 1, 0
		], 120, 22, .03);

		rimlightBase.addLayer(
			rimlightBase.addLayer([
				.96, .13, .30, 0, 32,
				-.02, .63, .14, 0, 8,
				-.02, .20, .94, 0, -8,
				0, 0, 0, 1, 0
			], 95, 38, .035)
		.colorMatrix, 140, 32, .03);

		if (hasBfSkin)
		{
			bfRim = rimlightBase;
			bfRim.attachedSprite = boyfriend;
			boyfriend.useRenderTexture = true;
		}

		if (hasGfSkin)
		{
			gfRim = new ExtraDropShadowShader().copyFrom(rimlightBase);

			gfRim.layers[0].angle = 90;
			gfRim.layers[1].angle = 90;
			gfRim.layers[2].angle = 90;

			gfRim.attachedSprite = gf;
			gf.useRenderTexture = true;
		}

		if (hasPet)
		{
			petRim = new ExtraDropShadowShader().copyFrom(rimlightBase);

			petRim.layers[0].angle = 105;
			petRim.layers[1].angle = 100;
			petRim.layers[2].angle = 115;

			petRim.attachedSprite = pet;
			pet.useRenderTexture = true;
		}

		var dadRim:ExtraDropShadowShader = new ExtraDropShadowShader().copyFrom(rimlightBase);

		dadRim.layers[0].angle = 60;
		dadRim.layers[1].angle = 85;
		dadRim.layers[2].angle = 40;

		dadRim.attachedSprite = dad;
		dad.useRenderTexture = true;
	}
	else
	{
		if (hasBfSkin)
			boyfriend.color = 0xffe080a6;

		if (hasGfSkin)
			gf.color = 0xffe080a6;

		if (hasPet)
			pet.color = 0xffe080a6;

		dad.color = 0xffd48aa8;
	}
}

function onBeatHit():Void
{
	if (curBeat % 2 == 0)
	{
		toogusorange.animation.play('bop', true);
		toogusblue.animation.play('bop', true);

		if (ClientPrefs.photosensitive || curBeat % 4 == 0)
			coreGlow.animation.play('bop', true);
	}
}

function onCountdownTick(tick:Int):Void
{
	if (tick % 2 == 0)
	{
		toogusorange.animation.play('bop', true);
		toogusblue.animation.play('bop', true);
	}
}