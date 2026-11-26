import StringTools;
import funkin.game.shaders.HeatwaveShader;
import funkin.objects.SnowEmitter;
import funkin.game.shaders.ExtraDropShadowShader;

import openfl.filters.ShaderFilter;

var bfDirectionalLook:Dynamic;
var dadDirectionalLook:Dynamic;
var petDirectionalLook:Dynamic;

var bfDirectionalTarget:FlxSprite;
var dadDirectionalTarget:FlxSprite;
var petDirectionalTarget:FlxSprite;
var directionalLUTBitmap:Dynamic;

var gfLook:Dynamic;
var gfLookTarget:FlxSprite;

var snowAlpha = 0.4;
var snowEmitter:SnowEmitter;

var ext:String = 'stages/polus/maroon/';
var darkStageVariant:Bool = false;
var stageLightsOutActive:Bool = false;

var boilingShader:HeatwaveShader =
    (ClientPrefs.shaders ? new HeatwaveShader() : null);

var boilingFilter:ShaderFilter =
    (boilingShader != null
        ? new ShaderFilter(boilingShader.shader)
        : null);

function maroonStageImage(name:String):String
{
    if (darkStageVariant && PlayState.SONG.stage == 'maroon2'
        && (name == 'newcloud' || name == 'backwall' || name == 'newstage'))
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

function setupBFRim()
{
	if (!ClientPrefs.shaders)
		return;

	if (boyfriend == null)
		return;

	var bfRim = boyfriend.shader;

	if (bfRim == null)
	{
		if (boyfriend.flipX)
			bfRim = darkStageVariant ? createDarkRim(46) : createRim(46);
		else
			bfRim = darkStageVariant ? createDarkRim(106) : createRim(106);
	}

	boyfriend.useRenderTexture = true;
	bfRim.attachedSprite = boyfriend;
	boyfriend.shader = bfRim;
	bfRimTarget = boyfriend;
}

function setupGFRim()
{
	if (!ClientPrefs.shaders)
		return;

	if (gf == null)
		return;

	var gfRim = gf.shader;

	if (gfRim == null)
		gfRim = darkStageVariant ? createDarkRim2(266) : createRim2(266);

	gf.useRenderTexture = true;
	gfRim.attachedSprite = gf;
	gf.shader = gfRim;
	gfRimTarget = gf;
}

function setupDadRim()
{
	if (!ClientPrefs.shaders)
		return;

	if (dad == null)
		return;

	var dadRim = dad.shader;

	if (dadRim == null)
		dadRim = createRim(46);

	dad.useRenderTexture = true;
	dadRim.attachedSprite = dad;
	dad.shader = dadRim;
	dadRimTarget = dad;
}

function setupPetRim()
{
	if (!ClientPrefs.shaders)
		return;

	if (!hasPet)
		return;

	if (pet == null)
		return;

	var petRim = pet.shader;

	if (petRim == null)
		petRim = darkStageVariant ? createDarkRim(106) : createRim(106);

	pet.useRenderTexture = true;
	petRim.attachedSprite = pet;
	pet.shader = petRim;
	petRimTarget = pet;
}

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

function getDirectionalLUTBitmap():Dynamic
{
    if (directionalLUTBitmap == null)
    {
        var lutGraphic = Paths.image('looks/polus-directional-layer', null, false);
        if (lutGraphic != null)
            directionalLUTBitmap = lutGraphic.bitmap;
    }

    return directionalLUTBitmap;
}

function createDirectionalLook():Dynamic
{
    var lutBitmap = getDirectionalLUTBitmap();
    if (lutBitmap == null)
        return null;

    var shader = newShader('directionalLayerLUT');
    if (shader == null)
        return null;

    shader.setBitmapData('uDirectionalLUT', lutBitmap);

    if (darkStageVariant)
    {
        shader.setFloatArray('uBaseRow0', [0.045, 0.010, 0.000, 0.000]);
        shader.setFloatArray('uBaseRow1', [0.005, 0.025, 0.000, 0.000]);
        shader.setFloatArray('uBaseRow2', [0.000, 0.002, 0.015, 0.000]);
        shader.setFloatArray('uBaseRow3', [0.000, 0.000, 0.000, 1.000]);
        shader.setFloatArray('uBaseOffset', [0.0, 0.0, 0.0, 0.0]);
        shader.setFloatArray('uBaseStrength', [0.80]);
        shader.setFloatArray('uBaseThreshold', [0.045]);
        shader.setFloatArray('uBaseRoughness', [1.0]);

        shader.setFloatArray('uLayerDistance', [16.0]);
        shader.setFloatArray('uLayerThreshold', [0.045]);
        shader.setFloatArray('uLayerStrength', [0.36]);
        shader.setFloatArray('uLayerRoughness', [0.95]);
    }
    else
    {
        shader.setFloatArray('uBaseRow0', [0.78, 0.08, 0.00, 0.00]);
        shader.setFloatArray('uBaseRow1', [0.00, 0.78, -0.16, 0.00]);
        shader.setFloatArray('uBaseRow2', [0.00, -0.10, 0.82, 0.00]);
        shader.setFloatArray('uBaseRow3', [0.00, 0.80, 0.00, 1.00]);
        shader.setFloatArray('uBaseOffset', [-3.0 / 255.0, 0.0, -0.5 / 255.0, 0.0]);
        shader.setFloatArray('uBaseStrength', [0.80]);
        shader.setFloatArray('uBaseThreshold', [0.05]);
        shader.setFloatArray('uBaseRoughness', [1.0]);

        shader.setFloatArray('uLayerDistance', [16.0]);
        shader.setFloatArray('uLayerThreshold', [0.08]);
        shader.setFloatArray('uLayerStrength', [0.30]);
        shader.setFloatArray('uLayerRoughness', [1.00]);
    }
    var directionalWidth:Float;
    if (PlayState.SONG.stage == 'maroon2')
        directionalWidth = darkStageVariant ? 41.0 : 60.0;
    else
        directionalWidth = darkStageVariant ? 48.0 : 62.4;

    shader.setFloatArray('uLayerWidth', [directionalWidth]);

    return shader;
}

function updateDirectionalLook(sprite:FlxSprite, shader:Dynamic, angle:Float)
{
    if (sprite == null || shader == null || sprite.frame == null || sprite.frame.uv == null)
        return;

    var uv = sprite.frame.uv;
    var frameAngle:Float = 0.0;
    if (sprite.frame.angle != null)
        frameAngle = sprite.frame.angle * 0.017453292519943295;

    shader.setFloatArray('uAngle', [angle]);
    shader.setFloatArray('uFrameAngle', [frameAngle]);
    shader.setFloatArray('uScale', [sprite.scale.x, sprite.scale.y]);
    shader.setFloatArray('uFrameBounds', [uv.left, uv.top, uv.right, uv.bottom]);
}

function setupBFDirectionalLUT()
{
    if (!ClientPrefs.shaders || boyfriend == null)
        return;

    if (bfDirectionalLook == null)
        bfDirectionalLook = createDirectionalLook();

    if (bfDirectionalLook == null)
        return;

    if (bfDirectionalTarget != boyfriend || boyfriend.shader != bfDirectionalLook)
    {
        boyfriend.useRenderTexture = true;
        boyfriend.shader = bfDirectionalLook;
        bfDirectionalTarget = boyfriend;
    }

    updateDirectionalLook(boyfriend, bfDirectionalLook, boyfriend.flipX ? 46 : 106);
}

function setupDadDirectionalLUT()
{
    if (!ClientPrefs.shaders || dad == null)
        return;

    if (dadDirectionalLook == null)
        dadDirectionalLook = createDirectionalLook();

    if (dadDirectionalLook == null)
        return;

    if (dadDirectionalTarget != dad || dad.shader != dadDirectionalLook)
    {
        dad.useRenderTexture = true;
        dad.shader = dadDirectionalLook;
        dadDirectionalTarget = dad;
    }

    updateDirectionalLook(dad, dadDirectionalLook, 46);
}

function setupPetDirectionalLUT()
{
    if (!ClientPrefs.shaders || !hasPet || pet == null)
        return;

    if (petDirectionalLook == null)
        petDirectionalLook = createDirectionalLook();

    if (petDirectionalLook == null)
        return;

    if (petDirectionalTarget != pet || pet.shader != petDirectionalLook)
    {
        pet.useRenderTexture = true;
        pet.shader = petDirectionalLook;
        petDirectionalTarget = pet;
    }

    updateDirectionalLook(pet, petDirectionalLook, 106);
}

function setupGFLook()
{
    if (!ClientPrefs.shaders || stageLightsOutActive || gf == null)
        return;

    if (gfLook == null)
    {
        var rimLut = Paths.image('looks/gfpolus-lava-rim', null, false);

        if (rimLut == null || rimLut.bitmap == null)
            return;

        gfLook = newShader('characterLookRim');
        if (gfLook == null)
            return;

        gfLook.setBitmapData('lutRim', rimLut.bitmap);

        if (darkStageVariant)
        {
            gfLook.setFloatArray('uMatrixRow0', [0.045, 0.010, 0.000, 0.000]);
            gfLook.setFloatArray('uMatrixRow1', [0.005, 0.025, 0.000, 0.000]);
            gfLook.setFloatArray('uMatrixRow2', [0.000, 0.002, 0.015, 0.000]);
            gfLook.setFloatArray('uMatrixOffset', [0.0, 0.0, 0.0, 0.0]);
            gfLook.setFloatArray('uMatrixStrength', [0.80]);
            gfLook.setFloatArray('uMatrixThreshold', [0.045]);
            gfLook.setFloatArray('uMatrixRoughness', [4.0]);
        }
        else
        {
            gfLook.setFloatArray('uMatrixRow0', [0.70, 0.10, 0.00, 0.00]);
            gfLook.setFloatArray('uMatrixRow1', [0.00, 0.70, -0.25, 0.00]);
            gfLook.setFloatArray('uMatrixRow2', [0.00, -0.15, 0.75, 0.00]);
            gfLook.setFloatArray('uMatrixOffset', [-5.0 / 255.0, 0.0, -1.0 / 255.0, 0.0]);
            gfLook.setFloatArray('uMatrixStrength', [0.85]);
            gfLook.setFloatArray('uMatrixThreshold', [0.05]);
            gfLook.setFloatArray('uMatrixRoughness', [4.0]);
        }
        gfLook.setFloatArray('uStrength', [darkStageVariant ? 0.70 : 0.72]);
        gfLook.setFloatArray('uRimGain', [darkStageVariant ? 0.98 : 1.22]);
        gfLook.setFloatArray('uRimAmount', [darkStageVariant ? 0.88 : 1.0]);
        gfLook.setFloatArray('uRimSpread', [darkStageVariant ? 3.8 : 5.0]);
        gfLook.setFloatArray('uRimCurve', [1.05]);
        gfLook.setFloatArray('uGlowCurve', [0.55]);
        gfLook.setFloatArray('uGlowAmount', [darkStageVariant ? 0.55 : 0.60]);
    }

    if (gfLookTarget != gf || gf.shader != gfLook)
    {
        gf.useRenderTexture = true;
        gf.shader = gfLook;
        gfLookTarget = gf;
    }

    updateGFLookFrame();
}

function updateGFLookFrame()
{
    if (gf == null || gfLook == null || gf.frame == null || gf.frame.uv == null)
        return;

    var uv = gf.frame.uv;
    gfLook.setFloatArray('uFrameLeft', [uv.left]);
    gfLook.setFloatArray('uFrameTop', [uv.top]);
    gfLook.setFloatArray('uFrameRight', [uv.right]);
    gfLook.setFloatArray('uFrameBottom', [uv.bottom]);
}

function checkRimAttachments()
{
    if (!ClientPrefs.shaders || stageLightsOutActive)
        return;

    setupBFDirectionalLUT();
    setupGFLook();
    setupDadDirectionalLUT();
    setupPetDirectionalLUT();
}

function onLoad()
{
    darkStageVariant = !PlayState.isStoryMode && PlayState.SONG.stage == 'maroon2' && FlxG.random.int(1, 4) == 1;

    var bg:FlxSprite = new FlxSprite(-200)
        .loadGraphic(Paths.image(maroonStageImage("newsky")));
    bg.scrollFactor.x = 0.7;
    bg.scale.set(0.75, 0.75);
    bg.color = 0xFFFFFFFF;
    add(bg);

    var cloud:FlxSprite = new FlxSprite(-100)
        .loadGraphic(Paths.image(maroonStageImage("newcloud")));
    cloud.scrollFactor.x = 0.9;
    cloud.alpha = 0.9;
    cloud.color = 0xFFFFFFFF;
    add(cloud);

    var rocks:FlxSprite = new FlxSprite()
        .loadGraphic(Paths.image(ext + "newrocks"));
    rocks.alpha = 0.49;
    rocks.color = 0xFF4F5E7C;
    add(rocks);

    var backwall:FlxSprite = new FlxSprite()
        .loadGraphic(Paths.image(maroonStageImage("backwall")));
    backwall.scrollFactor.x = 0.9;
    backwall.color = 0xFFFFFFFF;
    add(backwall);

    var ground:FlxSprite = new FlxSprite()
        .loadGraphic(Paths.image(maroonStageImage("newstage")));
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

    var lava:FlxSprite = new FlxSprite()
        .loadGraphic(Paths.image(ext + "newlava"));
    lava.blend = BlendMode.ADD;
    lava.color = 0xFFFF4500;
    add(lava);

    for (i in [bg, cloud, rocks, backwall, ground, lava])
        i.scale.set(0.75, 0.75);
}

function onUpdatePost(elapsed:Float)
{
    if (boilingShader != null)
        boilingShader.update(elapsed);

    if (darkStageVariant) checkRimAttachments();
}

function onEvent(eventName, value1, value2)
{
    if (eventName == 'Lights out')
        stageLightsOutActive = true;
    else if (eventName == 'Lights on')
        stageLightsOutActive = false;
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
                changeCharacter(coldVarP, 0);

            if (coldVarG != null)
                changeCharacter(coldVarG, 2);

        case "maroon2":
            coldVarP = (boyfriend.getFlag('variants')?.cold ?? null);
            coldVarG = (gf.getFlag('variants')?.cold ?? null);

            if (coldVarP != null)
                changeCharacter(coldVarP, 0);

            if (coldVarG != null)
                changeCharacter(coldVarG, 2);

        case "boiling":
            coldVarP = (boyfriend.getFlag('variants')?.cold ?? null);

            if (coldVarP != null)
                changeCharacter(coldVarP, 0);
    }

    camSpecialThing([1600, 1300], [1800, 1300]);

    var player:FlxSprite = new FlxSprite(dadGroup.x - 280, dadGroup.y + 440).loadGraphic(Paths.image(ext + 'player'));
    player.color = darkStageVariant ? 0xff060a1a : 0xFF8A9BC0;
    stage.insert(stage.members.indexOf(dadGroup), player);

    boyfriend.color = 0xFF8A9BC0;
    gf.color = 0xFF8A9BC0;
    dad.color = 0xFF8A9BC0;

    if (pet != null)
        pet.color = 0xFF8A9BC0;

    if (ClientPrefs.shaders)
    {
	if (darkStageVariant)
	{
        	setupBFDirectionalLUT();
        	setupGFLook();
        	setupDadDirectionalLUT();

        	if (hasPet)
        	    setupPetDirectionalLUT();
	}
	else
	{
		setupBFRim();
		setupGFRim();
		setupDadRim();

		if (hasPet)
			setupPetRim();
	}
    }

    var mainoverlay:FlxSprite = new FlxSprite(0, 0);
    mainoverlay.loadGraphic(Paths.image(ext + "newoverlay"));
    mainoverlay.scrollFactor.set(1, 1);
    mainoverlay.scale.set(0.75, 0.75);
    mainoverlay.alpha = darkStageVariant ? 0.12 : 0.80;
    mainoverlay.blend = 0;

    if (!ClientPrefs.lowQuality)
        add(mainoverlay);
}

function onSongRetry()
{
    stageLightsOutActive = false;
    bfDirectionalTarget = null;
    gfLookTarget = null;
    dadDirectionalTarget = null;
    petDirectionalTarget = null;
}

function onResume()
{
    if (stageLightsOutActive || !ClientPrefs.shaders || !darkStageVariant)
        return;

    setupBFDirectionalLUT();
    setupGFLook();
    setupDadDirectionalLUT();

    if (hasPet)
        setupPetDirectionalLUT();
}

function onGameOver()
{
    stageLightsOutActive = false;

    bfDirectionalTarget = null;
    gfLookTarget = null;
    dadDirectionalTarget = null;
    petDirectionalTarget = null;

    bfDirectionalLook = null;
    gfLook = null;
    dadDirectionalLook = null;
    petDirectionalLook = null;
}
