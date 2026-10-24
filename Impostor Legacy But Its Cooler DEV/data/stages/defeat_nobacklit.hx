import funkin.states.substates.GameOverSubstate;
import funkin.states.substates.PauseSubState;
import flixel.text.FlxText;
import funkin.Mods;
import flixel.util.FlxStringUtil;
import openfl.media.Sound;
import funkin.game.huds.PsychHUD;

using StringTools;

var combosPadding:Float = 0;
var defeattext:FlxText;
var oldScoreZoom:Bool;
var lightoverlay:FlxSprite;
var bodies2:FlxSprite;
var bodies:FlxSprite;
var bodiesfront:FlxSprite;
var old_defeat:FlxSprite;
var defeatthing:FlxSprite;
var subtract:FlxSprite;
var edgeglow1:FlxSprite;
var edgeglow2:FlxSprite;
var glowTween1:FlxTween;
var glowTween2:FlxTween;
var defeatBopTween:FlxTween;
var defeatScaleTween:Dynamic = null;
var ext:String = 'stages/void/';
var bf:String;
var defeatRetro:Null<String> = null;
public var redscreen:FlxSprite;
var bfRim:DropShadowShader;
var petRim:DropShadowShader;
var isRetro:Bool = false;
var rimBeatTweenBF:FlxTween;
var rimBeatTweenPet:FlxTween;
var rimBeatTweenDad:FlxTween;
var rimBeatTweenGF:FlxTween;
var rimNormalStrength:Float = 0.85;
var rimBeatStrength:Float = 1.15;

function onLoad()
{
	healthLoss = 0;

	bg = new FlxSprite(-700, -640).loadGraphic(Paths.image(ext + 'TripleKillBG'));
	bg.antialiasing = ClientPrefs.globalAntialiasing;
	bg.scrollFactor.set(0, 0);
	bg.setGraphicSize(Std.int(bg.width * 1.3));
	bg.updateHitbox();
	bg.alpha = 0.001;
	add(bg);

	defeattext = new FlxText(0, 30, -1, '');
	defeattext.setFormat(Paths.font('vcr.ttf'), 195, 0xFFFF0000);
	defeattext.antialiasing = false;
	defeattext.scrollFactor.set(0.9, 0.9);
	defeattext.alpha = 1;
	add(defeattext);

	defeattext.text = Lang.str('stage_defeat');
	defeattext.updateHitbox();
	defeattext.x = 750 - (defeattext.frameWidth / 2);

	defeatthing = new FlxSprite(225, 380);
	defeatthing.loadGraphic(Paths.image(ext + 'defeatpulse'));
	defeatthing.setGraphicSize(Std.int(defeatthing.width * 4));
	defeatthing.antialiasing = ClientPrefs.globalAntialiasing;
	defeatthing.scrollFactor.set(0.8, 0.8);
	defeatthing.alpha = .4;
	add(defeatthing);

	old_defeat = new FlxSprite(250, 125).loadGraphic(Paths.image(ext + 'defeatfnf'));
	old_defeat.antialiasing = ClientPrefs.globalAntialiasing;
	old_defeat.setGraphicSize(Std.int(old_defeat.width * 2));
	old_defeat.alpha = 0.01;
	add(old_defeat);

	bodies2 = new FlxSprite(-500, 50).loadGraphic(Paths.image(ext + 'idontknwo'));
	bodies2.antialiasing = ClientPrefs.globalAntialiasing;
	bodies2.setGraphicSize(Std.int(bodies2.width * 1.3));
	bodies2.scrollFactor.set(0.9, 0.9);
	bodies2.alpha = 0.001;
	add(bodies2);

	bodies = new FlxSprite(-4800, -900).loadFromSheet(ext + 'props', 'deadBG');
	bodies.scale.set(5, 5);
	bodies.updateHitbox();
	bodies.setGraphicSize(Std.int(bodies.width * 0.26));
	bodies.antialiasing = ClientPrefs.globalAntialiasing;
	bodies.scrollFactor.set(0.9, 0.9);
	bodies.alpha = 0.001;
	add(bodies);

	edgeglow1 = new FlxSprite(-1000, -720).loadGraphic(Paths.image(ext + 'edgeglow'));
	edgeglow1.scale.set(1.6, 1.6);
	edgeglow1.updateHitbox();
	edgeglow1.blend = BlendMode.ADD;
	edgeglow1.antialiasing = ClientPrefs.globalAntialiasing;
	edgeglow1.scrollFactor.set(0, 0);
	edgeglow1.alpha = 0.001;
	add(edgeglow1);

	edgeglow2 = new FlxSprite(-1000, 720).loadGraphic(Paths.image(ext + 'edgeglow'));
	edgeglow2.scale.set(1.6, 1.6);
	edgeglow2.updateHitbox();
	edgeglow2.blend = BlendMode.ADD;
	edgeglow2.antialiasing = ClientPrefs.globalAntialiasing;
	edgeglow2.scrollFactor.set(0, 0);
	edgeglow2.alpha = 0.001;
	add(edgeglow2);

	subtract = new FlxSprite(-700, -500).loadGraphic(Paths.image(ext + 'subtract'));
	subtract.scale.set(4, 4);
	subtract.updateHitbox();
	subtract.blend = BlendMode.SUBTRACT;
	subtract.antialiasing = ClientPrefs.globalAntialiasing;
	subtract.scrollFactor.set(0, 0);
	subtract.alpha = 0.001;
	add(subtract);

	redscreen = new FlxSprite().makeScaledGraphic(FlxG.width, FlxG.height, 0xFFA90000);
	redscreen.scrollFactor.set();
	redscreen.alpha = 0.001;
	redscreen.cameras = [camHUD];
	add(redscreen);
}

function onCreatePost()
{
	oldScoreZoom = ClientPrefs.scoreZoom;
	ClientPrefs.scoreZoom = true;

	if (!hasGfSkin || PlayState.isStoryMode)
		gf.visible = false;

	playHUD.timeBar.visible = false;
	playHUD.timeTxt.visible = false;
	playHUD.scoreTxt.y -= 90;
	playHUD.scoreTxt.text = songMisses + '/' + PlayState.totalMisses + ' ' + Lang.str('misses') + ' | ' + Lang.str('rank') + ': ' + Lang.str('AWARDNAME_no_miss_finale') + '.';
	playHUD.updateIconPos = false;
	iconP1.x = (FlxG.width - iconP1.width) / 2 + 50;
	iconP2.x = (FlxG.width - iconP2.width) / 2 - 50;
	iconP1.visible = false;
	iconP2.visible = false;

	defeatRetro = (boyfriend.getFlag('variants')?.retro ?? boyfriend.getFlag('defeatRetro'));

	if (defeatRetro != null)
		addCharacterToList(defeatRetro, 0);

	addCharacterToList('blackold', 1);

	snapCamToPos(750, 500);

	dadGroup.zIndex = 1;
	boyfriendGroup.zIndex = 0;

	bodiesfront = new FlxSprite(-3770, -250).loadFromSheet(ext + 'props', 'deadFG');
	bodiesfront.scale.set(5, 5);
	bodiesfront.updateHitbox();
	bodiesfront.setGraphicSize(Std.int(bodiesfront.width * 0.3));
	bodiesfront.antialiasing = ClientPrefs.globalAntialiasing;
	bodiesfront.scrollFactor.set(0.5, 1);
	bodiesfront.alpha = 0.001;
	bodiesfront.zIndex = 2;

	if (!ClientPrefs.lowQuality)
		add(bodiesfront);

	lightoverlay = new FlxSprite(-500, -200).loadGraphic(Paths.image(ext + 'iluminao omaga'));
	lightoverlay.scale.set(4, 4);
	lightoverlay.updateHitbox();
	lightoverlay.blend = BlendMode.ADD;
	lightoverlay.antialiasing = ClientPrefs.globalAntialiasing;
	lightoverlay.zIndex = 3;
	lightoverlay.alpha = 0.6;
	add(lightoverlay);

	redscreen.zIndex = 3;
	refreshZ();

	if (ClientPrefs.shaders)
	{
		var blackRimlightBase:ExtraDropShadowShader = new funkin.game.shaders.ExtraDropShadowShader();
		blackRimlightBase.threshold = .05;
		blackRimlightBase.strength = rimNormalStrength;
		blackRimlightBase.setColorMatrix([
			.4, .5, -.2, 0, -50,
			-.25, .7, -.15, 0, -20,
			.42, -.35, .85, 0, -72,
			0, 0, 0, 1, 0
		]);
		blackRimlightBase.addLayer([
			.7, .5, 1, 0, 192,
			.3, .4, -.5, 0, 64,
			-.1, .2, .35, 0, 74,
			0, 0, 0, 1, 0
		], 10, 14, .01);
		blackRimlightBase.addLayer(
			blackRimlightBase.addLayer([
				.9, .6, .4, 0, 4,
				-.2, .5, .1, 0, -18,
				-.2, .2, .4, 0, -28,
				0, 0, 0, 1, 0
			], 12, 40, .01, .4)
		.colorMatrix, 96, 24, .01, .4);

		if (hasBfSkin && boyfriend.getFlag('backlit') != true)
		{
			bfRim = blackRimlightBase;
			bfRim.attachedSprite = boyfriend;
			boyfriend.useRenderTexture = true;
		}

		if (hasPet)
		{
			petRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(blackRimlightBase);
			petRim.attachedSprite = pet;
			pet.useRenderTexture = true;
		}

		gfRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(blackRimlightBase);
		gfRim.attachedSprite = gf;
		gf.useRenderTexture = true;
		gfRim.layers[0].angle = 90;
		gfRim.layers[1].angle = 90;

		turnShader(true);
	}

	camSpecialThing([750, 500], [750, 500], defaultCamZoom);
	PauseSubState.songName = 'blackPause';
}

function turnShader(?should = false)
{
	boyfriend.shader = (should && hasBfSkin && boyfriend.getFlag('backlit') != true ? bfRim : null);
	if (hasPet) pet.shader = (should ? petRim : null);
	gf.shader = (should && hasGfSkin ? gfRim : null);
}

function onBeatHit()
{
	if (curBeat % 4 == 0)
	{
		if (defeatBopTween != null)
			defeatBopTween.cancel();

		defeatthing.alpha = (ClientPrefs.flashing ? .5 : .45);
		defeatBopTween = FlxTween.tween(defeatthing, {alpha: .4}, ClientPrefs.flashing ? .8 : .4, {ease: FlxEase.bounceOut});

		if (ClientPrefs.flashing)
		{
			if (defeatScaleTween != null)
				defeatScaleTween.cancel();

			defeatthing.scale.set(5.5, 5);
			defeatScaleTween = FlxTween.tween(defeatthing.scale, {x: 4, y: 4}, .8, {ease: FlxEase.sineOut});
		}

		if (edgeglow1.alpha > 0.01)
		{
			if (glowTween1 != null)
				glowTween1.cancel();

			if (glowTween2 != null)
				glowTween2.cancel();

			edgeglow1.alpha = edgeglow2.alpha = (ClientPrefs.flashing ? 1 : .7);
			glowTween1 = FlxTween.tween(edgeglow1, {alpha: 0.6}, 0.35, {ease: FlxEase.bounceOut});
			glowTween2 = FlxTween.tween(edgeglow2, {alpha: 0.6}, 0.35, {ease: FlxEase.bounceOut});
		}

		if (ClientPrefs.shaders)
		{
			if (bfRim != null)
			{
				if (rimBeatTweenBF != null)
					rimBeatTweenBF.cancel();

				bfRim.strength = rimBeatStrength;
				rimBeatTweenBF = FlxTween.tween(bfRim, {strength: rimNormalStrength}, 0.25, {ease: FlxEase.quadOut});
			}

			if (gfRim != null)
			{
				if (rimBeatTweenGF != null)
					rimBeatTweenGF.cancel();

				gfRim.strength = rimBeatStrength;
				rimBeatTweenGF = FlxTween.tween(gfRim, {strength: rimNormalStrength}, 0.25, {ease: FlxEase.quadOut});
			}

			if (petRim != null)
			{
				if (rimBeatTweenPet != null)
					rimBeatTweenPet.cancel();

				petRim.strength = rimBeatStrength;
				rimBeatTweenPet = FlxTween.tween(petRim, {strength: rimNormalStrength}, 0.25, {ease: FlxEase.quadOut});
			}
		}
	}
}

var playingCutscene:Bool = false;

function onGameOver()
{
	if (playingCutscene)
		return Function_Continue;

	health = 1;
	playingCutscene = true;
	game.startedCountdown = false;

	if (boyfriend.gameoverCharacter == 'bf-dead' || boyfriend.gameoverCharacter == 'bf-defeat-dead')
	{
		var suffix:String = (isRetro ? '-retro' : '');

		if (FlxG.random.bool(10))
		{
			boyfriend.gameoverCharacter = 'bf-defeat-dead-balls$suffix';
			boyfriend.gameoverInitialDeathSound = 'stage/defeat_kill_ballz_sfx$suffix';
		}
		else if (boyfriend.gameoverCharacter != 'bf-defeat-dead')
		{
			boyfriend.gameoverCharacter = 'bf-defeat-dead$suffix';
			boyfriend.gameoverInitialDeathSound = 'stage/defeat_kill_sfx$suffix';
		}

		if (!isRetro)
			blackGameOver();
		else
			blackGameOverV3();

		return Function_Stop;
	}
}

function onGameOverPost()
{
	if (boyfriend.gameoverCharacter?.endsWith('-retro'))
	{
		FlxG.camera.bgColor = 0xFF1A182E;
		FlxG.camera.snapToTarget();
	}
}

function blackGameOver()
{
	for (note in notes)
	{
		note.ignoreNote = true;
		note.visible = false;
	}

	startingSong = true;
	startedCountdown = false;
	boyfriend.stunned = boyfriend.skipDance = true;
	isCameraOnForcedPos = true;
	inCutscene = true;
	canPause = false;
	camZooming = false;
	audio.playerVolume = 0;
	audio.opponentVolume = 0;

	FlxTween.tween(audio.inst, {volume: 0}, 1.5, {ease: FlxEase.expoOut});
	camFollow.setPosition(550, 500);
	FlxTween.tween(camHUD, {alpha: 0}, .7, {ease: FlxEase.quadInOut});
	FlxTween.tween(FlxG.camera, {zoom: 0.65}, 1, {ease: FlxEase.quadInOut});

	dad.playAnim('kill', true);
	dad.specialAnim = true;

	dad.animation.onFinish.add((animName) -> {
		if (animName == 'kill')
		{
			dad.animation.play('kill2', true);
			dad.specialAnim = true;
		}
		else if (animName == 'kill2')
		{
			playingCutscene = true;
			doDeathCheck(true);
		}
	});

	dad.animation.onFrameChange.add((animName, frameNumber, frameIndex) -> {
		if (animName == 'kill' && frameNumber == 6)
			FlxG.sound.play(Paths.sound('stage/defeat_prekill_sfx'));
	});
}

function blackGameOverV3()
{
	for (note in notes)
	{
		note.ignoreNote = true;
		note.visible = false;
	}

	startingSong = true;
	startedCountdown = false;
	isCameraOnForcedPos = true;
	inCutscene = true;
	boyfriend.stunned = boyfriend.skipDance = true;
	canPause = false;
	camZooming = false;
	audio.playerVolume = 0;
	audio.opponentVolume = 0;
	audio.inst.volume = 0;
	camFollow.setPosition(550, 500);

	FlxTween.tween(camHUD, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
	FlxTween.tween(FlxG.camera, {zoom: 1.2}, 1.5, {ease: FlxEase.circOut});
	FlxG.sound.play(Paths.sound('stage/defeat_prekill_sfx_v3'));

	dad.playAnim('death', true);
	dad.specialAnim = true;

	dad.animation.onFinish.add((animName) -> {
		if (animName == 'death')
		{
			snapCamToPos(boyfriend.getGraphicMidpoint().x - 23, boyfriend.getGraphicMidpoint().y - 20, false);
			playingCutscene = true;
			doDeathCheck(true);
		}
	});
}

var prevAfterimages:Bool;
var prevScoreColor:FlxColor;

function onEvent(eventName, value1, value2)
{
	switch (eventName)
	{
		case 'Defeat Retro':
			var charType:Int = Std.parseInt(value1);
			if (Math.isNaN(charType))
				charType = 0;

			switch (charType)
			{
				case 0:
					prevAfterimages = boyfriend.ghostsEnabled;
					prevScoreColor = scoreTxt.color;
					bf = boyfriend.curCharacter;

					if (defeatRetro != null)
						changeCharacter(defeatRetro, 0);

					boyfriend.ghostsEnabled = false;

					for (i in [bg, defeattext, bodies, bodies2, bodiesfront, lightoverlay, subtract, edgeglow2, edgeglow1, iconP1, iconP2])
						i.alpha = 0.001;

					old_defeat.alpha = 1;
					defeatthing.alpha = 0.001;
					turnShader(false);
					scoreTxt.size = 16;
					scoreTxt.color = FlxColor.WHITE;

					if (hasPet)
						pet.visible = false;

					isRetro = true;

				case 1:
					changeCharacter(bf, 0);
					changeCharacter('black', 1);
					checkStageFlag(boyfriend);
					boyfriend.ghostsEnabled = prevAfterimages;

					for (i in [bg, defeattext, bodies, bodies2, bodiesfront, lightoverlay, subtract, edgeglow2, edgeglow1])
						i.alpha = 1;

					old_defeat.alpha = 0.001;
					defeatthing.alpha = 1;
					scoreTxt.color = prevScoreColor;
					scoreTxt.size = 20;
					turnShader(true);

					if (hasPet)
						pet.visible = true;

					isRetro = false;
			}

		case 'Defeat Fade':
			var charType:Int = Std.parseInt(value1);
			if (Math.isNaN(charType))
				charType = 0;

			switch (charType)
			{
				case 0:
					if (boyfriend.curCharacter == 'bf-defeat-normal')
						changeCharacter('bf-defeat-scared', 0);

					FlxTween.tween(bg, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
					FlxTween.tween(bodies, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
					FlxTween.tween(bodies2, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
					FlxTween.tween(bodiesfront, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
					FlxTween.tween(edgeglow1, {alpha: 0.5}, 0.7, {ease: FlxEase.quadInOut});
					FlxTween.tween(edgeglow2, {alpha: 0.5}, 0.7, {ease: FlxEase.quadInOut});
					FlxTween.tween(subtract, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
					FlxTween.tween(lightoverlay, {alpha: 0.7}, 0.7, {ease: FlxEase.quadInOut});

				case 1:
					FlxTween.tween(bg, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
					FlxTween.tween(bodies, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
					FlxTween.tween(bodies2, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
					FlxTween.tween(bodiesfront, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
					FlxTween.tween(edgeglow1, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
					FlxTween.tween(edgeglow2, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
					FlxTween.tween(subtract, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
					FlxTween.tween(lightoverlay, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
			}
	}
}

function onUpdatePost(elapsed:Float)
{
	if (!isRetro)
	{
		playHUD.scoreTxt.text = songMisses + '/' + PlayState.totalMisses + ' ' + Lang.str('misses') + ' | ' + Lang.str('rank') + ': ' + Lang.str('AWARDNAME_no_miss_finale') + '.';
		playHUD.scoreTxt.color = FlxColor.RED;
	}
}

function onPopUpScorePost(note, rating)
{
	if (ratingGraphic != null)
	{
		ratingGraphic.color = scoreTxt.color;
		ratingGraphic.x = (FlxG.width / 2) - (ratingGraphic.width / 2) + comboX;
		ratingGraphic.y = ClientPrefs.downScroll ? (FlxG.height - ratingGraphic.height - 50) : 55;
	}

	if (playHUD.ratingNumGroup != null && playHUD.ratingNumGroup.members != null)
	{
		var activeMembers = [
			for (member in playHUD.ratingNumGroup.members)
				if (member != null && member.exists && member.alive)
					member
		];

		var totalWidth = 0;

		for (m in activeMembers)
			totalWidth += ((m.frameWidth + combosPadding) * playHUD.combosScale);

		var xOffset = ((FlxG.width - totalWidth) / 2);

		for (numScore in activeMembers)
			numScore.color = scoreTxt.color;
	}

	return Function_Continue;
}