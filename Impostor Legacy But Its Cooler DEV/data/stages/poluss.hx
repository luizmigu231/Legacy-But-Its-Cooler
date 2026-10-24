import StringTools;
import funkin.game.shaders.ExtraDropShadowShader;
import funkin.objects.SnowEmitter;

public var speaker:FlxSprite;
public var bfdead:FlxSprite;
var bfRim:ExtraDropShadowShader;
var petRim:ExtraDropShadowShader;
var gfRim:ExtraDropShadowShader;
var dadRim:ExtraDropShadowShader;
var snowAlpha = 1;
var snowEmitter:SnowEmitter;
var crowd:FlxSprite;
var outroVid:PsychVideoSprite;
var ext = 'stages/polus/red/';

function onLoad()
{
	var sky:FlxSprite = new FlxSprite(-400, -400).loadGraphic(Paths.image(ext + 'polus_custom_sky'));
	sky.scrollFactor.set(0.5, 0.5);
	sky.setGraphicSize(Std.int(sky.width * 1.4));
	sky.setColorTransform(0.8, 0.85, 1.15);
	add(sky);
	
	var rocks:FlxSprite = new FlxSprite(-700, -300).loadGraphic(Paths.image(ext + 'polusrocks_night'));
	rocks.scrollFactor.set(0.6, 0.6);
	rocks.setColorTransform(0.8, 0.85, 1.15);
	add(rocks);
	
	var hills:FlxSprite = new FlxSprite(-1050, -180.55).loadGraphic(Paths.image(ext + 'polusHills_night'));
	hills.scrollFactor.set(0.9, 0.9);
	hills.setColorTransform(0.8, 0.85, 1.15);
	add(hills);
	
	var warehouse:FlxSprite = new FlxSprite(50, -400).loadGraphic(Paths.image(ext + 'polus_custom_lab_night'));
	warehouse.setColorTransform(0.8, 0.85, 1.15);
	add(warehouse);
	
	var ground:FlxSprite = new FlxSprite(-1350, 80).loadGraphic(Paths.image(ext + 'polus_custom_floor'));
	ground.setColorTransform(0.8, 0.85, 1.15);
	add(ground);
	
	snowEmitter = new SnowEmitter(-600, -600, 2700);
	snowEmitter.start(false, ClientPrefs.lowQuality ? 0.1 : 0.03);
	snowEmitter.scrollFactor.x.set(1, 1.5);
	snowEmitter.scrollFactor.y.set(1, 1.5);
	add(snowEmitter);
	snowEmitter.alpha.active = false;
	snowEmitter.onEmit.add((particle) ->
{
    particle.alpha = snowAlpha;
    particle.color = 0xFFBFD0FF;
});
	snowEmitter.zIndex = 13;
	snowEmitter.lifespan.set(5);
	
	speaker = new FlxSprite(300, 185);
	speaker.frames = Paths.getSparrowAtlas(ext + 'speakerlonely');
	speaker.animation.addByPrefix('bop', 'speakers lonely', 24, false);
	speaker.animation.play('bop');
	speaker.alpha = 0;
	speaker.color = 0xFF859CCE;
	add(speaker);
	
	// wh.color = FlxColor.RED;
	// wh.alpha = 0.2;
}

function onCreatePost()
{
	camSpecialThing([470, 250], [820, 250]);
	
	boyfriend.color = 0xFF859CCE;
    gf.color = 0xFF859CCE;
    dad.color = 0xFF859CCE;

	applyBFEffect();
	applyGFEffect();
	applyDadEffect();
	
	if (hasPet && pet != null)
    {
    pet.setColorTransform(0.8, 0.85, 1.15);
    }
	
	if (gf.curCharacter == 'gf-ghost' && curSong.toLowerCase() != 'top 10')
	{
		speaker.alpha = 1;
		gf.y -= 240;
	}
	if (boyfriend.curCharacter == 'bf-ghost') bfdead.alpha = 1;
	
	crowd = new FlxSprite(-900, 150);
	crowd.frames = Paths.getSparrowAtlas(ext + 'boppers_meltdown');
	crowd.animation.addByPrefix('bop', 'BoppersMeltdown', 24, false);
	crowd.animation.play('bop');
	crowd.scale.set(0.9,0.9);
	crowd.scrollFactor.set(1.5, 1.5);
	crowd.antialiasing = true;
	crowd.setColorTransform(0.8, 0.85, 1.15);
	// crowd2.scale.set(1, 1); // are we fucking fr
	if (PlayState.SONG.song.toLowerCase() == 'meltdown')
	{
		add(crowd);
	}
}

function onSongStart()
{
	if (hasBfSkin && game.boyfriend.curCharacter == 'redp' && pet.curPet == 'minicrewmate') game.unlockAchievementPopup('red_handed');
}

function onBeatHit()
{
	if (curBeat % 1 == 0) speaker.animation.play('bop');
	if (curBeat % 2 == 0) crowd.animation.play('bop');
        if (curBeat == 208) dad.color = 0xFF859CCE;
}

function onStartCountdown()
{
	var fakeStartTimer = new FlxTimer().start((Conductor.crotchet / 1000) / playbackRate, function(tmr:FlxTimer) {
		if (tmr.loopsLeft % 2 == 0) crowd.animation.play('bop');
		if (tmr.loopsLeft % 1 == 0) speaker.animation.play('bop');
	}, 5);
}

function applyBFEffect()
{
	if (!ClientPrefs.shaders || boyfriend == null) return;

	var rim = new ExtraDropShadowShader();

	rim.setColorMatrix([
		1, 0, 0, 0, 0,
		0, 1, 0, 0, 0,
		0, 0, 1, 0, 0,
		0, 0, 0, 1, 0
	]);

	rim.addLayer([
        1, 0, 0, 0, 255,
        0, 1, 0, 0, 255,
        0, 0, 1, 0, 255,
        0, 0, 0, 1, 0
    ], 220, -0, 4, 0.25);

	bfRim = rim;
	bfRim.attachedSprite = boyfriend;
	boyfriend.useRenderTexture = true;
	boyfriend.shader = bfRim;

	if (hasPet && pet != null)
	{
		petRim = new ExtraDropShadowShader().copyFrom(rim);
		petRim.attachedSprite = pet;
		pet.useRenderTexture = true;
		pet.shader = petRim;
		pet.color = 0xFF859CCE;
	}
}

function applyGFEffect()
{
	if (!ClientPrefs.shaders) return;

	var rim = new ExtraDropShadowShader();

	rim.setColorMatrix([
		1, 0, 0, 0, 0,
		0, 1, 0, 0, 0,
		0, 0, 1, 0, 0,
		0, 0, 0, 1, 0
	]);

	rim.addLayer([
        1, 0, 0, 0, 255,
        0, 1, 0, 0, 255,
        0, 0, 1, 0, 255,
        0, 0, 0, 1, 0
    ], -65, -0, 4, 0.25);

	gfRim = rim;
	gfRim.attachedSprite = gf;
	gf.useRenderTexture = true;
	gf.shader = gfRim;
}
function applyDadEffect()
{
	if (!ClientPrefs.shaders) return;

	var rim = new ExtraDropShadowShader();
	rim.setColorMatrix([
		1, 0, 0, 0, 0,
	0, 1, 0, 0, 0,
	0, 0, 0.95, 0, 0,
	0, 0, 0, 1, 0
	]);

	rim.addLayer([
        1, 0, 0, 0, 255,
        0, 1, 0, 0, 255,
        0, 0, 1, 0, 255,
        0, 0, 0, 1, 0
    ], 220, -0, 4, 0.25);

	dadRim = rim;
	dadRim.attachedSprite = dad;
	dad.useRenderTexture = true;

	{
		petRim = new ExtraDropShadowShader().copyFrom(rim);
		petRim.attachedSprite = pet;
		pet.useRenderTexture = true;
	}

	boyfriend.shader = bfRim;
}