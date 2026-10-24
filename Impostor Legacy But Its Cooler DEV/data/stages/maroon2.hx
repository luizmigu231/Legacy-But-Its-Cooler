import StringTools;
import funkin.game.shaders.ExtraDropShadowShader;
import funkin.game.shaders.HeatwaveShader;
import funkin.objects.SnowEmitter;

import openfl.filters.ShaderFilter;

var bfRim:ExtraDropShadowShader;
var gfRim:ExtraDropShadowShader;
var dadRim:ExtraDropShadowShader;
var petRim:ExtraDropShadowShader;

var bfRimTarget:FlxSprite;
var gfRimTarget:FlxSprite;
var dadRimTarget:FlxSprite;
var petRimTarget:FlxSprite;

var snowAlpha = 0.4;
var snowEmitter:SnowEmitter;

var ext:String = 'stages/polus/maroon/';

var boilingShader:HeatwaveShader =
	(ClientPrefs.shaders ? new HeatwaveShader() : null);

var boilingFilter:ShaderFilter =
	(boilingShader != null
		? new ShaderFilter(boilingShader.shader)
		: null);

function setBoiling(enabled:Bool)
{
	if (boilingFilter == null)
		return;

	if (enabled)
	{
		if (!camGame.filters.contains(boilingFilter))
			camGame.filters.push(boilingFilter);
	}
	else
	{
		camGame.filters.remove(boilingFilter);
	}
}

function createRim(angleX:Float, angleY:Float):ExtraDropShadowShader
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

	rim.addLayer([
		8, 18,  0, -1,   0,
		0.3, 2.5, -1.5, 0, 85,
		0, -1.5, -5.5, 0, -5,
		0,  9,   0,  9,  0
	], angleX + 86, angleY + 10, 0.08, 0.50);

	return rim;
}

function createRim2(angleX:Float, angleY:Float):ExtraDropShadowShader
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

	rim.addLayer([
		8, 18,  0, -1,   0,
		0.3, 2.5, -1.5, 0, 85,
		0, -1.5, -5.5, 0, -5,
		0,  9,   0,  9,  0
	], angleX + 86, angleY + 10, 0.08, 0.60);

	return rim;
}

function updateRimFrame(sprite:FlxSprite, rim:ExtraDropShadowShader)
{
	if (sprite == null)
		return;

	if (rim == null)
		return;

	if (sprite.frame == null)
		return;

	rim.updateFrameInfo(sprite.frame);
}

function setupBFRim()
{
	if (!ClientPrefs.shaders)
		return;

	if (boyfriend == null)
		return;

	if (bfRim == null)
	{
		if (boyfriend.flipX)
			bfRim = createRim(320, 6);
		else
			bfRim = createRim(380, 6);
	}

	boyfriend.useRenderTexture = true;
	bfRim.attachedSprite = boyfriend;
	bfRimTarget = boyfriend;

	updateRimFrame(boyfriend, bfRim);
}

function setupGFRim()
{
	if (!ClientPrefs.shaders)
		return;

	if (gf == null)
		return;

	if (gfRim == null)
		gfRim = createRim2(180, -28);

	gf.useRenderTexture = true;
	gfRim.attachedSprite = gf;
	gfRimTarget = gf;

	updateRimFrame(gf, gfRim);
}

function setupDadRim()
{
	if (!ClientPrefs.shaders)
		return;

	if (dad == null)
		return;

	if (dadRim == null)
		dadRim = createRim(320, 6);

	dad.useRenderTexture = true;
	dadRim.attachedSprite = dad;
	dadRimTarget = dad;

	updateRimFrame(dad, dadRim);
}

function setupPetRim()
{
	if (!ClientPrefs.shaders)
		return;

	if (!hasPet)
		return;

	if (pet == null)
		return;

	if (petRim == null)
		petRim = createRim(380, 6);

	pet.useRenderTexture = true;
	petRim.attachedSprite = pet;
	petRimTarget = pet;

	updateRimFrame(pet, petRim);
}

function reapplyBFRim()
{
	if (!ClientPrefs.shaders)
		return;

	if (boyfriend == null)
		return;

	if (bfRim == null)
		return;

	if (bfRimTarget != boyfriend)
	{
		boyfriend.useRenderTexture = true;
		bfRim.attachedSprite = boyfriend;
		bfRimTarget = boyfriend;

		updateRimFrame(boyfriend, bfRim);

		return;
	}

	if (boyfriend.shader != bfRim)
	{
		boyfriend.useRenderTexture = true;
		bfRim.attachedSprite = boyfriend;
		bfRimTarget = boyfriend;

		updateRimFrame(boyfriend, bfRim);
	}
}

function reapplyGFRim()
{
	if (!ClientPrefs.shaders)
		return;

	if (gf == null)
		return;

	if (gfRim == null)
		return;

	if (gfRimTarget != gf)
	{
		gf.useRenderTexture = true;
		gfRim.attachedSprite = gf;
		gfRimTarget = gf;

		updateRimFrame(gf, gfRim);

		return;
	}

	if (gf.shader != gfRim)
	{
		gf.useRenderTexture = true;
		gfRim.attachedSprite = gf;
		gfRimTarget = gf;

		updateRimFrame(gf, gfRim);
	}
}

function reapplyDadRim()
{
	if (!ClientPrefs.shaders)
		return;

	if (dad == null)
		return;

	if (dadRim == null)
		return;

	if (dadRimTarget != dad)
	{
		dad.useRenderTexture = true;
		dadRim.attachedSprite = dad;
		dadRimTarget = dad;

		updateRimFrame(dad, dadRim);

		return;
	}

	if (dad.shader != dadRim)
	{
		dad.useRenderTexture = true;
		dadRim.attachedSprite = dad;
		dadRimTarget = dad;

		updateRimFrame(dad, dadRim);
	}
}

function reapplyPetRim()
{
	if (!ClientPrefs.shaders)
		return;

	if (!hasPet)
		return;

	if (pet == null)
		return;

	if (petRim == null)
		return;

	if (petRimTarget != pet)
	{
		pet.useRenderTexture = true;
		petRim.attachedSprite = pet;
		petRimTarget = pet;

		updateRimFrame(pet, petRim);

		return;
	}

	if (pet.shader != petRim)
	{
		pet.useRenderTexture = true;
		petRim.attachedSprite = pet;
		petRimTarget = pet;

		updateRimFrame(pet, petRim);
	}
}

function checkRimAttachments()
{
	if (!ClientPrefs.shaders)
		return;

	reapplyBFRim();
	reapplyGFRim();
	reapplyDadRim();
	reapplyPetRim();
}

function onLoad()
{
	var bg:FlxSprite = new FlxSprite(-200)
		.loadGraphic(Paths.image(ext + "newsky"));

	bg.scrollFactor.x = 0.7;
	bg.scale.set(0.75, 0.75);
	bg.color = 0xFF5C6E91;
	add(bg);

	var cloud:FlxSprite = new FlxSprite(-100)
		.loadGraphic(Paths.image(ext + "newcloud"));

	cloud.scrollFactor.x = 0.9;
	cloud.alpha = 0.9;
	cloud.color = 0xFF7488A8;
	add(cloud);

	var rocks:FlxSprite = new FlxSprite()
		.loadGraphic(Paths.image(ext + "newrocks"));

	rocks.alpha = 0.49;
	rocks.color = 0xFF4F5E7C;
	add(rocks);

	var backwall:FlxSprite = new FlxSprite()
		.loadGraphic(Paths.image(ext + "backwall"));

	backwall.scrollFactor.x = 0.9;
	backwall.color = 0xFF566885;
	add(backwall);

	var ground:FlxSprite = new FlxSprite()
		.loadGraphic(Paths.image(ext + "newstage"));

	ground.color = 0xFF5A6C8A;
	add(ground);

	snowEmitter = new SnowEmitter(
		1000,
		800,
		2700
	);

	snowEmitter.start(
		false,
		ClientPrefs.lowQuality ? 0.1 : 0.04
	);

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

	var lava:FlxSprite = new FlxSprite()
		.loadGraphic(Paths.image(ext + "newlava"));

	lava.blend = BlendMode.ADD;
	lava.color = 0xFFFF4500;

	add(lava);

	for (i in [bg, cloud, rocks, backwall, ground, lava])
	{
		i.scale.set(0.75, 0.75);
	}
}

function onUpdatePost(elapsed:Float)
{
	if (boilingShader != null)
		boilingShader.update(elapsed);

	checkRimAttachments();
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
	switch (PlayState.SONG.stage)
	{
		case "maroon":
			coldVarP = (boyfriend.getFlag('variants')?.cold ?? null);
			coldVarG = (gf.getFlag('variants')?.cold ?? null);

			if (coldVarP != null)
			{
				changeCharacter(coldVarP, 0);
			}

			if (coldVarG != null)
			{
				changeCharacter(coldVarG, 2);
			}

		case "maroon2":
			coldVarP = (boyfriend.getFlag('variants')?.cold ?? null);
			coldVarG = (gf.getFlag('variants')?.cold ?? null);

			if (coldVarP != null)
			{
				changeCharacter(coldVarP, 0);
			}

			if (coldVarG != null)
			{
				changeCharacter(coldVarG, 2);
			}

		case "boiling":
			coldVarP = (boyfriend.getFlag('variants')?.cold ?? null);

			if (coldVarP != null)
			{
				changeCharacter(coldVarP, 0);
			}
	}

	camSpecialThing(
		[1600, 1300],
		[1800, 1300]
	);

	boyfriend.color = 0xFF8A9BC0;
	gf.color = 0xFF8A9BC0;
	dad.color = 0xFF8A9BC0;

	if (pet != null)
		pet.color = 0xFF8A9BC0;

	if (ClientPrefs.shaders)
	{
		setupBFRim();
		setupGFRim();
		setupDadRim();

		if (hasPet)
			setupPetRim();
	}

	var mainoverlay:FlxSprite = new FlxSprite(0, 0);

	mainoverlay.loadGraphic(
		Paths.image(ext + "newoverlay")
	);

	mainoverlay.scrollFactor.set(1, 1);
	mainoverlay.scale.set(0.75, 0.75);
	mainoverlay.alpha = 0.80;
	mainoverlay.blend = 0;

	if (!ClientPrefs.lowQuality)
		add(mainoverlay);
}

function onSongRetry()
{
	bfRimTarget = null;
	gfRimTarget = null;
	dadRimTarget = null;
	petRimTarget = null;
}

function onResume()
{
	if (!ClientPrefs.shaders)
		return;

	if (boyfriend != null && bfRim != null)
	{
		boyfriend.useRenderTexture = true;
		bfRim.attachedSprite = boyfriend;
		bfRimTarget = boyfriend;
		updateRimFrame(boyfriend, bfRim);
	}

	if (gf != null && gfRim != null)
	{
		gf.useRenderTexture = true;
		gfRim.attachedSprite = gf;
		gfRimTarget = gf;
		updateRimFrame(gf, gfRim);
	}

	if (dad != null && dadRim != null)
	{
		dad.useRenderTexture = true;
		dadRim.attachedSprite = dad;
		dadRimTarget = dad;
		updateRimFrame(dad, dadRim);
	}

	if (hasPet && pet != null && petRim != null)
	{
		pet.useRenderTexture = true;
		petRim.attachedSprite = pet;
		petRimTarget = pet;
		updateRimFrame(pet, petRim);
	}
}

function onGameOver()
{
	bfRimTarget = null;
	gfRimTarget = null;
	dadRimTarget = null;
	petRimTarget = null;

	bfRim = null;
	gfRim = null;
	dadRim = null;
	petRim = null;
}