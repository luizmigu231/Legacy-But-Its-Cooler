import StringTools;
import funkin.game.shaders.ExtraDropShadowShader;
import funkin.objects.SnowEmitter;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.states.substates.PauseSubState;

public var speaker:FlxSprite;
public var bfdead:FlxSprite;
var flashSprite:FlxSprite;
var bfRim:ExtraDropShadowShader;
var petRim:ExtraDropShadowShader;
var gfRim:ExtraDropShadowShader;
var dadRim:ExtraDropShadowShader;
var midnightRimsSuspended:Bool = false;
var midnightCharacterChangeHooksBound:Bool = false;
var snowAlpha = 1;
var snowEmitter:SnowEmitter;
var crowd:FlxSprite;
var crowdfirst:FlxSprite;
var outroVid:PsychVideoSprite;
var ext = 'stages/polus/red/';
var colorShader = newShader('pureColor');
var camOff:FlxSprite;
var moonGlow:FlxSprite;
var polusVignette:FlxSprite;
var polusVignetteFitWidth:Int = -1;
var polusVignetteFitHeight:Int = -1;

var whiteBg:FlxSprite;


var darkMatrix:Array<Float> = [
	0.53, 0, 0, 0, 0,
	0, 0.62, 0, 0, 0,
	0, 0, 0.75, 0, 0,
	0, 0, 0, 1, 0
];

var layerColorMatrix:Array<Float> = [
	0.94, 0, 0, 0, 4,
	0, 0.94, 0, 0, 3,
	0, 0, 0.94, 0, 6,
	0, 0, 0, 1, 0
];

function multiplyPolusColorMatrices(a:Array<Float>, b:Array<Float>):Array<Float>
{
	var result:Array<Float> = [];
	for (i in 0...4)
	{
		for (j in 0...5)
		{
			result[i * 5 + j] = a[i * 5] * b[j]
				+ a[i * 5 + 1] * b[j + 5]
				+ a[i * 5 + 2] * b[j + 10]
				+ a[i * 5 + 3] * b[j + 15]
				+ (j == 4 ? a[i * 5 + 4] : 0);
		}
	}
	return result;
}

function createRim(angleX:Float, distance:Float):ExtraDropShadowShader
{
	var rim = new ExtraDropShadowShader();
	rim.threshold = .045;
	rim.strength = 1;
	rim.roughness = .35;
	rim.antialiasStages = 0;
	rim.setAdjustColor(-5, -9, 5, -13);
	var adjustMatrix:Array<Float> = rim.colorMatrix;
	for (i in 0...4) adjustMatrix[i * 5 + 4] *= 255;
	rim.setColorMatrix(multiplyPolusColorMatrices(adjustMatrix, darkMatrix));
	rim.addLayer(layerColorMatrix, angleX + 92, distance, .018, .95, .25);
	return rim;
}


function rebindMidnightCharacterRim(rim:ExtraDropShadowShader, oldChar:FlxSprite, newChar:FlxSprite, angleX:Float):ExtraDropShadowShader
{
	if (!ClientPrefs.shaders || newChar == null || midnightRimsSuspended) return rim;

	if (rim == null)
	{
		newChar.useRenderTexture = true;
		rim = createRim(angleX, -15);
		rim.attachedSprite = newChar;
	}
	else
	{
		var previousSprite = rim.attachedSprite;
		newChar.useRenderTexture = true;
		rim.attachedSprite = newChar;
		if (previousSprite != null && previousSprite != newChar && previousSprite.shader == null)
			previousSprite.useRenderTexture = false;
		if (rim.layers != null && rim.layers.length > 0)
			rim.layers[0].angle = angleX + 92;
	}

	return rim;
}

function bindMidnightCharacterChangeHooks():Void
{
	if (midnightCharacterChangeHooksBound) return;
	midnightCharacterChangeHooksBound = true;

	if (boyfriendGroup != null)
		boyfriendGroup.onChange.add(function(newChar, oldChar) {
			if (newChar != null) bfRim = rebindMidnightCharacterRim(bfRim, oldChar, newChar, newChar.flipX ? 140 : 220);
		});
	if (gfGroup != null)
		gfGroup.onChange.add(function(newChar, oldChar) {
			if (newChar != null) gfRim = rebindMidnightCharacterRim(gfRim, oldChar, newChar, 220);
		});
	if (dadGroup != null)
		dadGroup.onChange.add(function(newChar, oldChar) {
			if (newChar != null) dadRim = rebindMidnightCharacterRim(dadRim, oldChar, newChar, 220);
		});
	if (pet != null)
		pet.onChange.add(function(changedPet) {
			if (changedPet != null) petRim = rebindMidnightCharacterRim(petRim, changedPet, changedPet, 220);
		});
}

function onLoad()
{
	var sky:FlxSprite = new FlxSprite(-400, -400).loadGraphic(Paths.image(ext + 'polus_custom_sky_midnight'));
	sky.scrollFactor.set(0.5, 0.5);
	sky.setGraphicSize(Std.int(sky.width * 1.4));
	add(sky);

	var rocks:FlxSprite = new FlxSprite(-700, -300).loadGraphic(Paths.image(ext + 'polusrocks_midnight'));
	rocks.scrollFactor.set(0.6, 0.6);
	add(rocks);

	var hills:FlxSprite = new FlxSprite(-1050, -180.55).loadGraphic(Paths.image(ext + 'polusHills_midnight'));
	hills.scrollFactor.set(0.9, 0.9);
	add(hills);

	var warehouse:FlxSprite = new FlxSprite(50, -400).loadGraphic(Paths.image(ext + 'polus_custom_lab_midnight'));
	add(warehouse);
	
	camOff = new FlxSprite(50 + 1123, -400 + 452).loadGraphic(Paths.image(ext + 'cam_off_lab_midnight'));
	camOff.alpha = 0.001;
	add(camOff);

	var ground:FlxSprite = new FlxSprite(-1350, 80).loadGraphic(Paths.image(ext + 'polus_custom_floor_midnight'));
	add(ground);

	moonGlow = new FlxSprite(-130, -430).loadGraphic(Paths.image(ext + 'polus_moon_glow'));
	moonGlow.setGraphicSize(960, 960);
	moonGlow.updateHitbox();
	moonGlow.scrollFactor.set(.5, .5);
	moonGlow.blend = BlendMode.ADD;
	moonGlow.color = 0xFF647BCB;
	moonGlow.alpha = .38;
	moonGlow.antialiasing = true;
	moonGlow.active = false;
	add(moonGlow);



	whiteBg = new FlxSprite(0, 0).makeGraphic(100, 100, 0xFFFFFFFF);
	whiteBg.scale.set(10000, 10000);
	whiteBg.alpha = 0;
	add(whiteBg);

	snowEmitter = new SnowEmitter(-600, -600, 200);
	snowEmitter.start(false, ClientPrefs.lowQuality ? 0.16 : 0.08);
	snowEmitter.scrollFactor.x.set(1, 1.5);
	snowEmitter.scrollFactor.y.set(1, 1.5);
	add(snowEmitter);

	snowEmitter.alpha.active = false;

	snowEmitter.onEmit.add((particle) ->
	{
		if (whiteBg.alpha == 1)
			particle.alpha = 0;
		else
			particle.alpha = snowAlpha;

	});

	snowEmitter.zIndex = 13;
	snowEmitter.lifespan.set(5);

	speaker = new FlxSprite(300, 185);
	speaker.frames = Paths.getSparrowAtlas(ext + 'speakerlonely_midnight');
	speaker.animation.addByPrefix('bop', 'speakers lonely', 24, false);
	speaker.animation.play('bop');
	speaker.alpha = 0;
	add(speaker);

	bfdead = new FlxSprite(600, 525).loadGraphic(Paths.image(ext + 'bfdead_midnight'));
	bfdead.setGraphicSize(Std.int(bfdead.width * 0.8));
	bfdead.updateHitbox();
	bfdead.alpha = 0;
	add(bfdead);
}

function fitPolusVignette():Void
{
	if (polusVignette == null || camGame == null) return;

	var fitZoom:Float = camGame.zoom > 0 ? camGame.zoom : 1;
	var targetWidth:Int = Std.int(Math.ceil(FlxG.width / fitZoom));
	var targetHeight:Int = Std.int(Math.ceil(FlxG.height / fitZoom));
	if (targetWidth < 1 || targetHeight < 1) return;

	if (targetWidth != polusVignetteFitWidth || targetHeight != polusVignetteFitHeight)
	{
		polusVignette.setGraphicSize(targetWidth, targetHeight);
		polusVignette.updateHitbox();
		polusVignetteFitWidth = targetWidth;
		polusVignetteFitHeight = targetHeight;
	}

	polusVignette.setPosition(camGame.viewMarginX, camGame.viewMarginY);
}

function onUpdatePost(elapsed:Float):Void
{
	fitPolusVignette();
}

function onCreatePost()
{
	flashSprite = new FlxSprite(0, 0).makeScaledGraphic(
		FlxG.width,
		FlxG.height,
		0xFFB30000
	);

	flashSprite.alpha = 0.001;

	if (ClientPrefs.photosensitive)
	{
		flashSprite.camera = camHUD;
		insert(0, flashSprite);
	}
	else
	{
		flashSprite.camera = camOther;
		add(flashSprite);
	}

	colorShader.data.colSet.value = [true];
	colorShader.data.funnyColor.value = [0.0, 0.0, 0.0, 1.0];
	colorShader.data.strength.value = [1.0];

	camSpecialThing([470, 250], [820, 250]);

	polusVignette = new FlxSprite(0, 0).loadGraphic(Paths.image(ext + 'polus_vignette'));
	polusVignette.scrollFactor.set(0, 0);
	polusVignette.blend = BlendMode.NORMAL;
	polusVignette.alpha = .72;
	polusVignette.camera = camGame;
	polusVignette.zIndex = 999999;
	polusVignette.active = false;
	polusVignette.antialiasing = true;
	polusVignetteFitWidth = -1;
	polusVignetteFitHeight = -1;
	fitPolusVignette();
	add(polusVignette);
	refreshZ(stage);

	if (gf.curCharacter == 'gf-ghost' && curSong.toLowerCase() != 'top 10')
	{
		speaker.alpha = 1;
		gf.y -= 240;
		}

	if (boyfriend.curCharacter == 'bf-ghost')
	{
		bfdead.alpha = 1;
		}

	crowdfirst = new FlxSprite(-900, 300);
	crowdfirst.frames = Paths.getSparrowAtlas(ext + 'boppers_meltdown_first_midnight');
	crowdfirst.animation.addByPrefix('bop', 'BoppersMeltdown', 24, false);
	crowdfirst.animation.play('bop');
	crowdfirst.scale.set(0.9, 0.9);
	crowdfirst.scrollFactor.set(1.5, 1.5);
	crowdfirst.antialiasing = true;
	crowdfirst.alpha = 0;

	crowd = new FlxSprite(-900, 150);
	crowd.frames = Paths.getSparrowAtlas(ext + 'boppers_meltdown_midnight');
	crowd.animation.addByPrefix('bop', 'BoppersMeltdown', 24, false);
	crowd.animation.play('bop');
	crowd.scale.set(0.9, 0.9);
	crowd.scrollFactor.set(1.5, 1.5);
	crowd.antialiasing = true;
	crowd.alpha = 0;

	if (PlayState.SONG.song.toLowerCase() == 'meltdown')
	{
		add(crowd);
		add(crowdfirst);
	}

	if (ClientPrefs.shaders)
	{
		boyfriend.useRenderTexture = true;

		if (boyfriend.flipX)
			bfRim = createRim(140, -15);
		else
			bfRim = createRim(220, -15);

		bfRim.attachedSprite = boyfriend;
		boyfriend.shader = bfRim;

		if (hasPet && pet != null)
		{
			pet.useRenderTexture = true;
			petRim = createRim(220, -15);
			petRim.attachedSprite = pet;
			pet.shader = petRim;
		}

		if (gf != null)
		{
			gf.useRenderTexture = true;
			gfRim = createRim(220, -15);
			gfRim.attachedSprite = gf;
			gf.shader = gfRim;
		}

		dad.useRenderTexture = true;
		dadRim = createRim(220, -15);
		dadRim.attachedSprite = dad;
		dad.shader = dadRim;
	}

	bindMidnightCharacterChangeHooks();
	refreshZ(stage);
}

function onSongStart()
{
	if (hasBfSkin && game.boyfriend.curCharacter == 'redp' && pet.curPet == 'minicrewmate')
		game.unlockAchievementPopup('red_handed');
}

function onEvent(ev, v1, v2)
{
	if (ev == "Reactor Beep")
	{
		flashSprite.alpha = 0.5;
		FlxTween.tween(flashSprite, {alpha: 0}, .3);
	}
	if (ev == 'toggle cams')
		FlxTween.tween(camOff, {alpha: (camOff.alpha == 1) ? 0.001 : 1}, 0.3, {ease: FlxEase.quadOut});
}

function onBeatHit()
{
	if (curBeat % 1 == 0)
		speaker.animation.play('bop');

	if (curBeat % 2 == 0)
	{
		crowdfirst.animation.play('bop');
		crowd.animation.play('bop');
	}

	if (curBeat == 64)
	{
		crowdfirst.alpha = 1;

		FlxTween.tween(crowdfirst, {y: 150}, 0.5, {
			ease: FlxEase.quadOut
		});

		if (ClientPrefs.shaders && dadRim != null)
		{
			dad.useRenderTexture = true;
			dad.shader = dadRim;
		}
	}

	if (curBeat == 128)
	{
		midnightRimsSuspended = true;
		dad.shader = null;
		boyfriend.shader = null;

		dad.useRenderTexture = false;
		boyfriend.useRenderTexture = false;

		if (gfRim != null)
		{
			gf.shader = null;
			gf.useRenderTexture = false;
		}

		if (petRim != null && pet != null)
		{
			pet.shader = null;
			pet.useRenderTexture = false;
		}

		dad.color = FlxColor.BLACK;
		boyfriend.color = FlxColor.BLACK;

		crowdfirst.alpha = 0;
		speaker.alpha = 0;
		gf.alpha = 0;
		whiteBg.alpha = 1;
		if (moonGlow != null) moonGlow.visible = false;
		if (polusVignette != null) polusVignette.visible = false;

		healthBar.rightBar.color = healthBar.leftBar.color = FlxColor.BLACK;
		iconP1.color = FlxColor.BLACK;
		iconP2.color = FlxColor.BLACK;
		scoreTxt.color = FlxColor.WHITE;
		timeBar.leftBar.color = FlxColor.BLACK;
		timeBar.rightBar.color = FlxColor.WHITE;

		forcedBotColor = true;
		botplayTxt.color = FlxColor.WHITE;

		for (strum in playerStrums)
			strum.color = FlxColor.BLACK;
		for (strum in opponentStrums)
			strum.color = FlxColor.BLACK;

		ratingGraphic.color = FlxColor.WHITE;
		for (num in ratingNumGroup.members)
			num.color = FlxColor.WHITE;

		if (snowEmitter != null)
		{
			for (particle in snowEmitter.members)
			{
				if (particle != null)
					particle.alpha = 0;
			}
		}

		if (pet != null)
			pet.alpha = 0;

		bfdead.alpha = 0;
	}

	if (curBeat == 160)
	{

		midnightRimsSuspended = false;
		if (ClientPrefs.shaders)
		{
			bfRim = rebindMidnightCharacterRim(bfRim, bfRim != null ? bfRim.attachedSprite : null, boyfriend, boyfriend.flipX ? 140 : 220);
			dadRim = rebindMidnightCharacterRim(dadRim, dadRim != null ? dadRim.attachedSprite : null, dad, 220);
			if (gf != null)
				gfRim = rebindMidnightCharacterRim(gfRim, gfRim != null ? gfRim.attachedSprite : null, gf, 220);
			if (hasPet && pet != null)
				petRim = rebindMidnightCharacterRim(petRim, petRim != null ? petRim.attachedSprite : null, pet, 220);
		}

	
		boyfriend.color = FlxColor.WHITE;
		dad.color = FlxColor.WHITE;

		for (obj in [playHUD.healthBar, playHUD.iconP1, playHUD.iconP2, playHUD.scoreTxt, playHUD.timeBar, playHUD.timeTxt])
			obj.visible = true;

		crowd.alpha = 1;

		if (gf.curCharacter == "gf-ghost")
			speaker.alpha = 1;

		gf.alpha = 1;
		whiteBg.alpha = 0;
		if (moonGlow != null) moonGlow.visible = true;
		if (polusVignette != null) polusVignette.visible = true;

		iconP1.color = FlxColor.WHITE;
		iconP2.color = FlxColor.WHITE;
		playHUD.scoreTxt.color = playHUD.healthBar.leftBar.color;

		forcedBotColor = false;

		timeBar.setColors(0xFF44d844, 0xFF2e412e);

		for (strum in playerStrums)
			strum.color = FlxColor.WHITE;
		for (strum in opponentStrums)
			strum.color = FlxColor.WHITE;

		if (ClientPrefs.colorText == 'Enabled DX')
		{
			ratingGraphic.color = FlxColor.WHITE;
			for (num in ratingNumGroup.members)
				num.color = FlxColor.WHITE;
		}

		if (snowEmitter != null)
		{
			for (particle in snowEmitter.members)
			{
				if (particle != null)
					particle.alpha = 1;
			}
		}

		if (pet != null)
			pet.alpha = 1;

		if (boyfriend.curCharacter == 'bf-ghost')
			bfdead.alpha = 1;
		else
			bfdead.alpha = 0;
	}

	if (curBeat == 288)
	{
		colorShader.data.funnyColor.value = [1.0, 1.0, 1.0, 1.0];

		if (boyfriend.getFlag("ghost") == true)
		{
			boyfriend.shader = colorShader;

			FlxTween.tween(boyfriend, {alpha: 0}, 1, {
				ease: FlxEase.expoOut
			});
		}

		if (gf.getFlag("ghost") == true)
		{
			gf.shader = colorShader;

			FlxTween.tween(gf, {alpha: 0}, 1, {
				ease: FlxEase.expoOut
			});
		}
	}
}

function onStartCountdown()
{
	var fakeStartTimer = new FlxTimer().start(
		(Conductor.crotchet / 1000) / playbackRate,
		function(tmr:FlxTimer)
		{
			if (tmr.loopsLeft % 2 == 0)
				crowd.animation.play('bop');

			if (tmr.loopsLeft % 1 == 0)
				speaker.animation.play('bop');
		},
		5
	);
}

function onSubstateOpen()
{
	if (boyfriend.color != FlxColor.BLACK)
		return;
	
	FlxG.signals.postUpdate.addOnce(() -> {
		
		if (PauseSubState.instance != null)
		{
			var pause = PauseSubState.instance;
			
			pause.pauseGroup.members[1].color = pause.pauseGroup.members[2].color = FlxColor.BLACK;
			pause.looksie.loadGraphic(Paths.image('menu/pause/looksie-dark'));
		}
	});
}