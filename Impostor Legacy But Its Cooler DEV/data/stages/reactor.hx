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

var reactorBfRim:ExtraDropShadowShader;
var reactorGfRim:ExtraDropShadowShader;
var reactorDadRim:ExtraDropShadowShader;
var reactorPetRim:ExtraDropShadowShader;

function makeAdjustColor():FunkinRuntimeShader
{
	var shader:FunkinRuntimeShader = newShader('adjustColor');

	shader.setFloat('hue', 0);
	shader.setFloat('saturation', 0);
	shader.setFloat('brightness', 0);
	shader.setFloat('contrast', 0);

	return shader;
}

function colorize(sprite:FlxSprite, hue:Float, saturation:Float, brightness:Float, contrast:Float):Void
{
	if (sprite == null) return;

	var shader:FunkinRuntimeShader = makeAdjustColor();

	shader.setFloat('hue', hue);
	shader.setFloat('saturation', saturation);
	shader.setFloat('brightness', brightness);
	shader.setFloat('contrast', contrast);

	sprite.shader = shader;
}

function makeCharacterRim():ExtraDropShadowShader
{
	var shader:ExtraDropShadowShader = new ExtraDropShadowShader();

	shader.threshold = .02;
	shader.strength = 1;
	shader.roughness = .9;
	shader.operation = 'stack';

	shader.setAdjustColor(-24, -9, 34, -42);

	shader.addLayer([
		1.00, .025, .10, 0, 88,
		.01, .90, .025, 0, 2,
		.10, .02, 1.02, 0, 58,
		0, 0, 0, 1, 0
	], 90, 20, .018, .82, .82);

	shader.addLayer([
		.96, .015, .13, 0, 38,
		.012, .87, .035, 0, 1,
		.13, .025, 1.06, 0, 92,
		0, 0, 0, 1, 0
	], 90, 32, .035, .50, .85);

	shader.addLayer([
		1.02, .02, .075, 0, 52,
		.012, .94, .02, 0, 1,
		.075, .015, 1.0, 0, 36,
		0, 0, 0, 1, 0
	], 90, 11, .05, .30, .8);

	return shader;
}

function updateCharacterRimDirection(shader:ExtraDropShadowShader, character:FlxSprite):Void
{
	if (shader == null || character == null || coreGlow == null)
		return;

	var cameraX:Float = FlxG.camera.scroll.x;
	var cameraY:Float = FlxG.camera.scroll.y;

	var sourceX:Float = coreGlow.x + coreGlow.width * .5
		- cameraX * coreGlow.scrollFactor.x;

	var sourceY:Float = coreGlow.y + coreGlow.height * .5
		- cameraY * coreGlow.scrollFactor.y;

	var characterX:Float = character.x + character.width * .5
		- cameraX * character.scrollFactor.x;

	var characterY:Float = character.y + character.height * .5
		- cameraY * character.scrollFactor.y;

	var dx:Float = sourceX - characterX;
	var dy:Float = sourceY - characterY;

	var angle:Float = Math.atan2(-dy, dx) * 180 / Math.PI;

	if (angle < 0)
		angle += 360;

	shader.layers[0].angle = angle;
	shader.layers[1].angle = angle - 13;
	shader.layers[2].angle = angle + 13;
}

function keepCharacterRim(shader:ExtraDropShadowShader, character:FlxSprite):Void
{
	if (shader == null || character == null) return;

	updateCharacterRimDirection(shader, character);

	if (shader.attachedSprite != character)
		shader.attachedSprite = character;

	character.useRenderTexture = true;

	if (character.shader != shader)
		character.shader = shader;
}

function applyCharacterRims():Void
{
	if (!ClientPrefs.shaders) return;

	keepCharacterRim(reactorBfRim, boyfriend);
	keepCharacterRim(reactorGfRim, gf);
	keepCharacterRim(reactorDadRim, dad);

	if (hasPet)
		keepCharacterRim(reactorPetRim, pet);
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

	colorize(toogusorange, 6, -12, -12, 26);
	colorize(toogusblue, -16, -34, -20, 31);

	if (ClientPrefs.shaders)
	{
		var rimlightBase:ExtraDropShadowShader = makeCharacterRim();

		reactorBfRim = new ExtraDropShadowShader().copyFrom(rimlightBase);
		bfRim = reactorBfRim;

		reactorGfRim = new ExtraDropShadowShader().copyFrom(rimlightBase);
		gfRim = reactorGfRim;

		reactorDadRim = new ExtraDropShadowShader().copyFrom(rimlightBase);

		reactorDadRim.setAdjustColor(-20, -8, 30, -28);

		reactorDadRim.layers[0].distance = 24;
		reactorDadRim.layers[0].threshold = .02;
		reactorDadRim.layers[0].strength = .72;
		reactorDadRim.layers[0].roughness = .85;

		reactorDadRim.layers[1].distance = 34;
		reactorDadRim.layers[1].threshold = .035;
		reactorDadRim.layers[1].strength = .46;
		reactorDadRim.layers[1].roughness = .85;

		reactorDadRim.layers[2].distance = 12;
		reactorDadRim.layers[2].threshold = .05;
		reactorDadRim.layers[2].strength = .28;
		reactorDadRim.layers[2].roughness = .8;

		dadRim = reactorDadRim;

		if (hasPet)
		{
			reactorPetRim = new ExtraDropShadowShader().copyFrom(rimlightBase);
			petRim = reactorPetRim;
		}

		applyCharacterRims();
	}
	else
	{
		boyfriend.color = 0xffe080a6;

		if (gf != null)
			gf.color = 0xffe080a6;

		if (hasPet)
			pet.color = 0xffe080a6;

		dad.color = 0xffd48aa8;
	}
}

function onUpdatePost(elapsed:Float):Void
{
	applyCharacterRims();
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