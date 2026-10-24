import StringTools;
import funkin.game.shaders.ExtraDropShadowShader;
import funkin.objects.SnowEmitter;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.states.substates.PauseSubState;

public var speaker:FlxSprite;
public var bfdead:FlxSprite;
var flashSprite:FlxSprite;
var speakerRim:ExtraDropShadowShader;
var bfdeadRim:ExtraDropShadowShader;
var crowdRim:ExtraDropShadowShader;
var crowdRim2:ExtraDropShadowShader;
var bfRim:ExtraDropShadowShader;
var petRim:ExtraDropShadowShader;
var gfRim:ExtraDropShadowShader;
var dadRim:ExtraDropShadowShader;
var snowAlpha = 1;
var snowEmitter:SnowEmitter;
var crowd:FlxSprite;
var crowdfirst:FlxSprite;
var outroVid:PsychVideoSprite;
var ext = 'stages/polus/red/';
var colorShader = newShader('pureColor');
var camOff:FlxSprite;

var whiteBg:FlxSprite;

var noteBWActive:Bool = false;

function createRim(angleX:Float, angleY:Float):ExtraDropShadowShader
{
	var rim = new ExtraDropShadowShader();

	rim.threshold = .045;
	rim.strength = .82;
	rim.roughness = .012;

	rim.addLayer([
		1,0,0,0,170,
		0,1,0,0,100,
		0,0,1,0,255,
		0,0,0,1,0
	], angleX + 92, angleY + 0, .018, .70);

	return rim;
}

function applyRim(sprite:FlxSprite)
{
	if (!ClientPrefs.shaders || sprite == null)
		return;

	var rim = createRim(0, 0);
	rim.attachedSprite = sprite;
	sprite.useRenderTexture = true;
	sprite.shader = rim;
}

function updateBWMaskData(shader:FlxRuntimeShader)
{
	if (shader == null)
		return;

	if (boyfriend != null && boyfriend.framePixels != null)
	{
		var bfPos = boyfriend.getScreenPosition(camGame);

		var bfWidth:Float = boyfriend.framePixels.width * boyfriend.scale.x;
		var bfHeight:Float = boyfriend.framePixels.height * boyfriend.scale.y;

		shader.setBitmapData(
			'u_bfMask',
			boyfriend.framePixels
		);

		shader.setFloatArray('u_bfPos', [
			bfPos.x,
			bfPos.y
		]);

		shader.setFloatArray('u_bfSize', [
			bfWidth,
			bfHeight
		]);

		shader.setFloat(
			'u_bfFlip',
			boyfriend.flipX ? 1.0 : 0.0
		);
	}

	if (dad != null && dad.framePixels != null)
	{
		var dadPos = dad.getScreenPosition(camGame);

		var dadWidth:Float = dad.framePixels.width * dad.scale.x;
		var dadHeight:Float = dad.framePixels.height * dad.scale.y;

		shader.setBitmapData(
			'u_dadMask',
			dad.framePixels
		);

		shader.setFloatArray('u_dadPos', [
			dadPos.x,
			dadPos.y
		]);

		shader.setFloatArray('u_dadSize', [
			dadWidth,
			dadHeight
		]);

		shader.setFloat(
			'u_dadFlip',
			dad.flipX ? 1.0 : 0.0
		);
	}
}

function setupBWNote(note)
{
	if (note == null)
		return;

	if (!note.mustPress)
	{
		note.visible = false;
		note.shader = null;
		note.rgbEnabled = false;
		note.rgbShader.enabled = false;
		return;
	}

	if (!note.extraData.exists('noteBWOriginalColor'))
		note.extraData['noteBWOriginalColor'] = note.color;

	if (!note.extraData.exists('noteBWOriginalVisible'))
		note.extraData['noteBWOriginalVisible'] = note.visible;

	if (!note.extraData.exists('noteBWOriginalRGB'))
		note.extraData['noteBWOriginalRGB'] = note.rgbEnabled;

	var shader:FlxRuntimeShader = note.extraData['noteBWShader'];

	if (shader == null)
	{
		shader = newShader('noteBWMask');

		if (shader == null)
		{
			note.color = FlxColor.BLACK;
			note.rgbEnabled = false;
			note.rgbShader.enabled = false;
			return;
		}

		note.extraData['noteBWShader'] = shader;
	}

	note.rgbEnabled = false;
	note.rgbShader.enabled = false;

	note.shader = shader;
	note.visible = true;
}

function updateBWNote(note)
{
	if (note == null || !note.mustPress)
		return;

	var shader:FlxRuntimeShader = note.extraData['noteBWShader'];

	if (shader == null)
	{
		setupBWNote(note);
		shader = note.extraData['noteBWShader'];
	}

	if (shader == null)
	{
		note.rgbEnabled = false;
		note.rgbShader.enabled = false;
		note.color = FlxColor.BLACK;
		return;
	}

	var notePos = note.getScreenPosition(camHUD);

	var noteWidth:Float = note.width * note.scale.x;
	var noteHeight:Float = note.height * note.scale.y;

	if (noteWidth <= 0 || noteHeight <= 0)
		return;

	shader.setFloatArray('u_targetPos', [
		notePos.x,
		notePos.y
	]);

	shader.setFloatArray('u_targetSize', [
		noteWidth,
		noteHeight
	]);

	updateBWMaskData(shader);

	note.rgbEnabled = false;
	note.rgbShader.enabled = false;
	note.shader = shader;
	note.visible = true;
}

function enableNoteBW()
{
	noteBWActive = true;

	if (game.notes == null)
		return;

	game.notes.forEachAlive(function(note)
	{
		if (note == null)
			return;

		if (!note.extraData.exists('noteBWOriginalColor'))
			note.extraData['noteBWOriginalColor'] = note.color;

		if (!note.extraData.exists('noteBWOriginalVisible'))
			note.extraData['noteBWOriginalVisible'] = note.visible;

		if (!note.extraData.exists('noteBWOriginalRGB'))
			note.extraData['noteBWOriginalRGB'] = note.rgbEnabled;

		if (!note.mustPress)
		{
			note.visible = false;
			note.shader = null;
			note.rgbEnabled = false;
			note.rgbShader.enabled = false;
			return;
		}

		setupBWNote(note);
	});
}

function disableNoteBW()
{
	noteBWActive = false;

	if (game.notes == null)
		return;

	game.notes.forEachAlive(function(note)
	{
		if (note == null)
			return;

		note.shader = null;

		if (note.extraData.exists('noteBWOriginalColor'))
		{
			note.color = note.extraData['noteBWOriginalColor'];
			note.extraData.remove('noteBWOriginalColor');
		}

		if (note.extraData.exists('noteBWOriginalVisible'))
		{
			note.visible = note.extraData['noteBWOriginalVisible'];
			note.extraData.remove('noteBWOriginalVisible');
		}

		if (note.extraData.exists('noteBWOriginalRGB'))
		{
			note.rgbEnabled = note.extraData['noteBWOriginalRGB'];
			note.extraData.remove('noteBWOriginalRGB');
		}
		else
		{
			note.rgbEnabled = true;
		}

		note.rgbShader.enabled = note.rgbEnabled;

		if (note.extraData.exists('noteBWShader'))
			note.extraData.remove('noteBWShader');
	});
}

function onLoad()
{
	var sky:FlxSprite = new FlxSprite(-400, -400).loadGraphic(Paths.image(ext + 'polus_custom_sky'));
	sky.scrollFactor.set(0.5, 0.5);
	sky.setGraphicSize(Std.int(sky.width * 1.4));
	sky.setColorTransform(0.88, 0.92, 1.12);
	add(sky);

	var rocks:FlxSprite = new FlxSprite(-700, -300).loadGraphic(Paths.image(ext + 'polusrocks_midnight'));
	rocks.scrollFactor.set(0.6, 0.6);
	rocks.setColorTransform(0.88, 0.92, 1.12);
	add(rocks);

	var hills:FlxSprite = new FlxSprite(-1050, -180.55).loadGraphic(Paths.image(ext + 'polusHills_midnight'));
	hills.scrollFactor.set(0.9, 0.9);
	hills.setColorTransform(0.88, 0.92, 1.12);
	add(hills);

	var warehouse:FlxSprite = new FlxSprite(50, -400).loadGraphic(Paths.image(ext + 'polus_custom_lab_midnight'));
	warehouse.setColorTransform(0.88, 0.92, 1.12);
	add(warehouse);
	
	camOff = new FlxSprite(50 + 1123, -400 + 452).loadGraphic(Paths.image(ext + 'cam_off_lab'));
	camOff.setColorTransform(0.88, 0.92, 1.12);
	camOff.alpha = 0.001;
	add(camOff);

	var ground:FlxSprite = new FlxSprite(-1350, 80).loadGraphic(Paths.image(ext + 'polus_custom_floor'));
	ground.setColorTransform(0.88, 0.92, 1.12);
	add(ground);

	whiteBg = new FlxSprite(0, 0).makeGraphic(100, 100, 0xFFFFFFFF);
	whiteBg.scale.set(10000, 10000);
	whiteBg.alpha = 0;
	add(whiteBg);

	snowEmitter = new SnowEmitter(-600, -600, 2700);
	snowEmitter.start(false, ClientPrefs.lowQuality ? 0.1 : 0.04);
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

		particle.color = 0xFFDCE6FF;
	});

	snowEmitter.zIndex = 13;
	snowEmitter.lifespan.set(5);

	speaker = new FlxSprite(300, 185);
	speaker.frames = Paths.getSparrowAtlas(ext + 'speakerlonely');
	speaker.animation.addByPrefix('bop', 'speakers lonely', 24, false);
	speaker.animation.play('bop');
	speaker.alpha = 0;
	speaker.color = 0xFF89A0D0;
	add(speaker);

	bfdead = new FlxSprite(600, 525).loadGraphic(Paths.image(ext + 'bfdead_midnight'));
	bfdead.setGraphicSize(Std.int(bfdead.width * 0.8));
	bfdead.updateHitbox();
	bfdead.alpha = 0;
	bfdead.color = 0xFF89A0D0;
	add(bfdead);
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

	boyfriend.color = 0xFF89A0D0;
	gf.color = 0xFF89A0D0;
	dad.color = 0xFF89A0D0;
	pet.color = 0xFF89A0D0;

	if (gf.curCharacter == 'gf-ghost' && curSong.toLowerCase() != 'top 10')
	{
		speaker.alpha = 1;
		gf.y -= 240;
		speaker.color = 0xFF89A0D0;
	}

	if (boyfriend.curCharacter == 'bf-ghost')
	{
		bfdead.alpha = 1;
		bfdead.color = 0xFF89A0D0;
	}

	crowdfirst = new FlxSprite(-900, 300);
	crowdfirst.frames = Paths.getSparrowAtlas(ext + 'boppers_meltdown_first');
	crowdfirst.animation.addByPrefix('bop', 'BoppersMeltdown', 24, false);
	crowdfirst.animation.play('bop');
	crowdfirst.scale.set(0.9, 0.9);
	crowdfirst.scrollFactor.set(1.5, 1.5);
	crowdfirst.antialiasing = true;
	crowdfirst.setColorTransform(0.88, 0.92, 1.12);
	crowdfirst.alpha = 0;

	crowd = new FlxSprite(-900, 150);
	crowd.frames = Paths.getSparrowAtlas(ext + 'boppers_meltdown');
	crowd.animation.addByPrefix('bop', 'BoppersMeltdown', 24, false);
	crowd.animation.play('bop');
	crowd.scale.set(0.9, 0.9);
	crowd.scrollFactor.set(1.5, 1.5);
	crowd.antialiasing = true;
	crowd.setColorTransform(0.88, 0.92, 1.12);
	crowd.alpha = 0;

	if (PlayState.SONG.song.toLowerCase() == 'meltdown')
	{
		add(crowd);
		add(crowdfirst);

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

			gf.useRenderTexture = true;
			gfRim = createRim(220, -15);
			gfRim.attachedSprite = gf;
			gf.shader = gfRim;

			dad.useRenderTexture = true;
			dadRim = createRim(220, -15);
			dadRim.attachedSprite = dad;
			dad.shader = dadRim;

			crowdRim = createRim(220, -15);
			crowdRim.attachedSprite = crowd;
			crowd.shader = crowdRim;

			crowdRim2 = createRim(220, -15);
			crowdRim2.attachedSprite = crowdfirst;
			crowdfirst.shader = crowdRim2;

			speakerRim = createRim(220, -15);
			speakerRim.attachedSprite = speaker;
			speaker.shader = speakerRim;
		}
	}
}

function onUpdatePost(elapsed:Float)
{
	if (!noteBWActive)
		return;

	if (game.notes == null)
		return;

	game.notes.forEachAlive(function(note)
	{
		if (note == null)
			return;

		if (!note.mustPress)
		{
			note.visible = false;
			note.shader = null;
			note.rgbEnabled = false;
			note.rgbShader.enabled = false;
			return;
		}

		updateBWNote(note);
	});
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

		dad.color = 0xFF89A0D0;
	}

	if (curBeat == 128)
	{
		dad.shader = null;
		boyfriend.shader = null;

		dad.useRenderTexture = false;
		boyfriend.useRenderTexture = false;

		dad.color = FlxColor.BLACK;
		boyfriend.color = FlxColor.BLACK;

		crowdfirst.alpha = 0;
		speaker.alpha = 0;
		gf.alpha = 0;
		whiteBg.alpha = 1;

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

		enableNoteBW();
	}

	if (curBeat == 160)
	{
		disableNoteBW();

		if (ClientPrefs.shaders)
		{
			if (bfRim != null)
			{
				boyfriend.useRenderTexture = true;
				boyfriend.shader = bfRim;
			}

			if (dadRim != null)
			{
				dad.useRenderTexture = true;
				dad.shader = dadRim;
			}
		}

		boyfriend.color = 0xFF89A0D0;

		for (obj in [playHUD.healthBar, playHUD.iconP1, playHUD.iconP2, playHUD.scoreTxt, playHUD.timeBar, playHUD.timeTxt])
			obj.visible = true;

		crowd.alpha = 1;

		if (gf.curCharacter == "gf-ghost")
			speaker.alpha = 1;

		gf.alpha = 1;
		whiteBg.alpha = 0;

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