import StringTools;
import funkin.game.shaders.ExtraDropShadowShader;
import funkin.objects.SnowEmitter;

var bfRim:ExtraDropShadowShader;
var gfRim:ExtraDropShadowShader;
var dadRim:ExtraDropShadowShader;
var petRim:ExtraDropShadowShader;
var snowAlpha = 0.3;
var snowEmitter:SnowEmitter;
var ext:String = 'stages/polus/maroon/';
var darkStageVariant:Bool = false;

function maroonStageImage(name:String):String
{
	if (darkStageVariant && (name == 'newsky' || name == 'newcloud' || name == 'backwall' || name == 'newstage'))
		return ext + name + '_lightsdown';

	return ext + name;
}

function createRim(angle:Float):ExtraDropShadowShader
{
	var rim = new ExtraDropShadowShader();
	rim.threshold = 0.05;
	rim.strength = 0.85;
	rim.setColorMatrix([
		0.70, 0.10,  0.00, 0, -5,
		0.00, 0.70, -0.25, 0,  0,
		0.00,-0.15, 0.75, 0, -1,
		0.00, 0.80, 0.00, 1,  0
	]);
	var layerMatrix = [
		8, 18,  0, -1,   0,
		0.3, 2.5, -1.5, 0, 85,
		0, -1.5, -5.5, 0, -5,
		0,  9,   0,  9,  0
	];
	rim.addLayer(layerMatrix, angle, 16, 0.08, 0.30, 1.00);
	return rim;
}


function createRim2(angle:Float):ExtraDropShadowShader
{
	var rim = new ExtraDropShadowShader();
	rim.threshold = 0.05;
	rim.strength = 0.85;
	rim.setColorMatrix([
		0.70, 0.10,  0.00, 0, -5,
		0.00, 0.70, -0.25, 0,  0,
		0.00,-0.15, 0.75, 0, -1,
		0.00, 0.80, 0.00, 1,  0
	]);
	var layerMatrix = [
		8, 18,  0, -1,   0,
		0.3, 2.5, -1.5, 0, 85,
		0, -1.5, -5.5, 0, -5,
		0,  9,   0,  9,  0
	];
	rim.addLayer(layerMatrix, angle, 16, 0.08, 0.40, 1.00);
	return rim;
}


function createDarkRim(angle:Float):ExtraDropShadowShader
{
	var rim = new ExtraDropShadowShader();
	rim.threshold = 0.045;
	rim.strength = 0.80;
	rim.operation = 'replace';
	rim.setColorMatrix([
		0.045, 0.010, 0.000, 0, 0,
		0.005, 0.025, 0.000, 0, 0,
		0.000, 0.002, 0.015, 0, 0,
		0.000, 0.000, 0.000, 1, 0
	]);
	var layerMatrix = [
		8, 18,  0, -1,   0,
		0.3, 2.5, -1.5, 0, 85,
		0, -1.5, -5.5, 0, -5,
		0,  9,   0,  9,  0
	];
	rim.addLayer(layerMatrix, angle, 18, 0.045, 0.58, 0.95);
	return rim;
}



function createDarkRim2(angle:Float):ExtraDropShadowShader
{
	var rim = new ExtraDropShadowShader();
	rim.threshold = 0.045;
	rim.strength = 0.80;
	rim.operation = 'replace';
	rim.setColorMatrix([
		0.045, 0.010, 0.000, 0, 0,
		0.005, 0.025, 0.000, 0, 0,
		0.000, 0.002, 0.015, 0, 0,
		0.000, 0.000, 0.000, 1, 0
	]);
	var layerMatrix = [
		8, 18,  0, -1,   0,
		0.3, 2.5, -1.5, 0, 85,
		0, -1.5, -5.5, 0, -5,
		0,  9,   0,  9,  0
	];
	rim.addLayer(layerMatrix, angle, 18, 0.045, 0.64, 0.95);
	return rim;
}



function onLoad()
{
	darkStageVariant = PlayState.SONG.stage == 'maroon' && FlxG.random.int(1, 4) == 1;

	var bg:FlxSprite = new FlxSprite(-200).loadGraphic(Paths.image(maroonStageImage("newsky")));
	bg.scrollFactor.x = 0.7;
	bg.scale.set(0.75, 0.75);
	bg.color = 0xFFFFFFFF;
	add(bg);

	var cloud:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image(maroonStageImage("newcloud")));
	cloud.scrollFactor.x = 0.9;
	cloud.alpha = 0.9;
	cloud.color = 0xFFFFFFFF;
	add(cloud);

	var rocks:FlxSprite = new FlxSprite().loadGraphic(Paths.image(ext + "newrocks"));
	rocks.alpha = 0.49;
	rocks.color = 0xFF4F5E7C;
	add(rocks);

	var backwall:FlxSprite = new FlxSprite().loadGraphic(Paths.image(maroonStageImage("backwall")));
	backwall.scrollFactor.x = 0.9;
	backwall.color = 0xFFFFFFFF;
	add(backwall);

	var ground:FlxSprite = new FlxSprite().loadGraphic(Paths.image(maroonStageImage("newstage")));
	ground.color = 0xFFFFFFFF;
	add(ground);

	snowEmitter = new SnowEmitter(1000, 800, 2700);
	snowEmitter.start(false, ClientPrefs.lowQuality ? 0.1 : 0.04);
	snowEmitter.scrollFactor.x.set(1, 1.5);
	snowEmitter.scrollFactor.y.set(1, 1.5);
	add(snowEmitter);
	snowEmitter.alpha.active = false;
	snowEmitter.onEmit.add((particle) ->
	{
		particle.alpha = snowAlpha;
		particle.color = 0xFFFFF2EA;
	});
	snowEmitter.zIndex = 13;
	snowEmitter.speed.set(1000, 1500);

	var lava:FlxSprite = new FlxSprite().loadGraphic(Paths.image(ext + "newlava"));
	lava.blend = BlendMode.ADD;
	lava.color = 0xFFFFF2EA;
	add(lava);

	for (i in [bg, cloud, rocks, backwall, ground, lava])
	{
		i.scale.set(0.75, 0.75);
	}
}

function goodNoteHit(note)
{
	if (note.noteType == 'Hey!')
	{
		game.boyfriend.playAnim('hey', true);
		game.boyfriend.specialAnim = true;
	}
}

function opponentNoteHit(note)
{
	game.defaultCamZoom = 0.7;
}

function onCreatePost()
{
	if (hasBfSkin && game.boyfriend.curCharacter == 'bfpolus')
	{
		triggerEventNote('Change Character', 'boyfriend', 'bfpolusblow');
	}

	camSpecialThing([1600, 1300], [1800, 1300]);

	boyfriend.color = 0xFF8A9BC0;
	gf.color = 0xFF8A9BC0;
	dad.color = 0xFF8A9BC0;
	pet.color = 0xFF8A9BC0;

	if (ClientPrefs.shaders)
	{
		boyfriend.useRenderTexture = true;

		if (boyfriend.flipX)
			bfRim = darkStageVariant ? createDarkRim(46) : createRim(46);
		else
			bfRim = darkStageVariant ? createDarkRim(106) : createRim(106);

		bfRim.attachedSprite = boyfriend;
		boyfriend.shader = bfRim;

		if (hasPet)
		{
			pet.useRenderTexture = true;
			petRim = darkStageVariant ? createDarkRim(106) : createRim(106);
			petRim.attachedSprite = pet;
			pet.shader = petRim;
		}

		gf.useRenderTexture = true;
		gfRim = darkStageVariant ? createDarkRim2(266) : createRim2(266);
		gfRim.attachedSprite = gf;
		gf.shader = gfRim;

		dad.useRenderTexture = true;
		dadRim = darkStageVariant ? createDarkRim(46) : createRim(46);
		dadRim.attachedSprite = dad;
		dad.shader = dadRim;
	}

	var mainoverlay:FlxSprite = new FlxSprite(0, 0);
	mainoverlay.loadGraphic(Paths.image(ext + "newoverlay"));
	mainoverlay.scrollFactor.set(1, 1);
	mainoverlay.scale.set(0.75, 0.75);
	mainoverlay.alpha = darkStageVariant ? 0.12 : 0.60;
	mainoverlay.blend = 0;

	if (!ClientPrefs.lowQuality)
		add(mainoverlay);
}
