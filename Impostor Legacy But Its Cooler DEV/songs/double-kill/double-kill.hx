var cargoDarkFG:FlxSprite;
var cargoDarken:Bool = false;
var cargoAirship:FlxSprite;
var showDlowDK:Bool = false;
var defeatDKoverlay:FlxSprite;
var testMode:Bool = false;
public var vignette:Bool = false;
var dadRim:DropShadowShader;
var gfRim:ExtraDropShadowShader;

function onCreatePost()
{
	if (!hasBfSkin) addCharacterToList('bf-defeat-normal', 0);
	reactorFade = 1;
	cargoAirsip = new FlxSprite(2200, 800).loadGraphic(Paths.image('stages/airship/double-kill/airshipFlashback'));
	cargoAirsip.antialiasing = true;
	cargoAirsip.updateHitbox();
	cargoAirsip.scrollFactor.set(1, 1);
	cargoAirsip.setGraphicSize(Std.int(cargoAirsip.width * 1.3));
	cargoAirsip.alpha = 0.001;
	add(cargoAirsip);
	
	camHUD.visible = false;
	cargoDarkFG = new FlxSprite(-640, -360).makeScaledGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
	cargoDarkFG.scrollFactor.set(0, 0);
	
	defeatDKoverlay = new FlxSprite(900, 350).loadGraphic(Paths.image('stages/void/iluminao omaga'));
	defeatDKoverlay.blend = BlendMode.ADD;
	defeatDKoverlay.alpha = 0.001;
	defeatDKoverlay.scale.set(4, 4);
	defeatDKoverlay.updateHitbox();
	add(defeatDKoverlay);
	add(cargoDarkFG);
	if (true) cargoDarkFG.alpha = 0;
	
	camSpecialThing([2000, 1050], [2300, 1050], -1);
}

function onUpdate(elapsed)
{
	// i want to know who did this bullshit in source.
	if (Conductor.songPosition >= 0 && Conductor.songPosition < 1200)
	{
		cargoDarkFG.alpha -= elapsed / 5;
		FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, 1, FlxMath.bound(elapsed * 3, 0, 1));
	}
	if (cargoDarken)
	{
		cargoDark.alpha = FlxMath.lerp(cargoDark.alpha, 1, FlxMath.bound(elapsed * 1.4, 0, 1));
		dad.alpha = FlxMath.lerp(dad.alpha, 0.001, FlxMath.bound(elapsed * 1.4, 0, 1));
		black.alpha = FlxMath.lerp(black.alpha, 0.001, FlxMath.bound(elapsed * 1.4, 0, 1));
		// pet.alpha = FlxMath.lerp(pet.alpha, 0.001, FlxMath.bound(elapsed * 1.4, 0, 1));
		mainoverlayDK.alpha = FlxMath.lerp(mainoverlayDK.alpha, 0.001, FlxMath.bound(elapsed * 1.4, 0, 1));
		lightoverlayDK.alpha = FlxMath.lerp(lightoverlayDK.alpha, 0.001, FlxMath.bound(elapsed * 1.4, 0, 1));
	}
	if (showDlowDK)
	{
		cargoAirsip.alpha = FlxMath.lerp(cargoAirsip.alpha, 0.45, FlxMath.bound(elapsed * 0.1, 0, 1));
	}
	/*if (FlxG.keys.justPressed.Q)
		{
			setSongTime(183 * 1000);
			clearNotesBefore(Conductor.songPosition);
	}*/
}

function onEvent(eventName, value1, value2)
{
	switch (eventName)
	{
		case 'flash':
			cargoDarkFG.alpha = 0;
			camHUD.visible = true;
		case 'Legacy':
			switch (value1)
			{
				case 'wmc': // weird mid cam
					camSpecialThing([2150, 1050], [2150, 1050]);
				case 'nc': // normal cam
					camSpecialThing([2000, 1050], [2300, 1050]);
				case 'ncy': // normal cam
					camSpecialThing([2000, 1050], [isBfGhost ? 2600 : 2300, 1050]);
				case '356':
					camSpecialThing(-1, [2750, 1150], 1.1);
				case '420':
					camSpecialThing(-1, [2300, 1050], 0.8);
				case '552':
					camSpecialThing([1650, 1180], -1, 1.2);
					if (isBfGhost) FlxTween.tween(yellow, {alpha: 1}, Conductor.stepCrotchet / 1000);
				case '556':
					camSpecialThing([2000, 1050], isBfGhost ? [2600, 1050] : -1, 0.8);
				case 'darken':
        	                        FlxTween.tween(playHUD.iconP2, { alpha: 0 }, 0.5, { ease: FlxEase.quadOut });
        	                        FlxTween.tween(playHUD.iconP2, { alpha: 0 }, 0.5, { ease: FlxEase.quadOut });
        	                        FlxTween.tween(playHUD.healthBar.leftBar, { alpha: 0 }, 0.5, { ease: FlxEase.quadOut });
        	                        FlxTween.tween(playHUD.scoreTxt, { alpha: 0 }, 0.5, { ease: FlxEase.quadOut });
					cargoDarken = true;
					camGame.flash(FlxColor.BLACK, 0.55);
					if (!ClientPrefs.middleScroll)
					{
  						FlxTween.num(0, 0.5, 0.7, {ease: FlxEase.quadInOut, onUpdate: function(twn:FlxTween) modManager.setValue('opponentSwap', twn.value, -1)});
  						FlxTween.num(0, 1, 0.7, {ease: FlxEase.quadInOut, onUpdate: function(twn:FlxTween) modManager.setValue('alpha', twn.value, 1)});
						comboX = 440;
					}
				case 'airship':
        	                        playHUD.scoreTxt.color = -1001146;
                                        playHUD.healthBar.leftBar.color = -1001146;
                                        playHUD.iconP2.changeIcon("yellow");
        	                        FlxTween.tween(playHUD.scoreTxt, { alpha: 0.45 }, 9, { ease: FlxEase.quadOut });
        	                        FlxTween.tween(playHUD.healthBar.leftBar, { alpha: 0.45 }, 9, { ease: FlxEase.quadOut });
        	                        FlxTween.tween(playHUD.iconP2, { alpha: 0.45 }, 9, { ease: FlxEase.quadOut });
					showDlowDK = true;
				case 'brighten':
                                        playHUD.scoreTxt.color = -12969137;
                                        playHUD.scoreTxt.alpha = 1;
                                        playHUD.healthBar.leftBar.color = -12969137;
                                        playHUD.healthBar.leftBar.alpha = 1;
                                        playHUD.iconP2.changeIcon("black");
                                        playHUD.iconP2.alpha = 1;
					showDlowDK = false;
					cargoDarken = false;
					cargoAirsip.alpha = 0.001;
					cargoDark.alpha = 0.001;
					dad.alpha = 1;
					black.alpha = 1;
					// pet.alpha = 1;
					FlxG.signals.postUpdate.addOnce(()->
					{
						lightoverlayDK.alpha = 0.4;
						mainoverlayDK.alpha = 0.51;
					});
					if (!ClientPrefs.middleScroll)
					{
  						modManager.setValue('opponentSwap', 0, -1);
  						modManager.setValue('alpha', 0, 1);
						comboX = 0;
					}
				case 'gonnakill':
					FlxTween.tween(game, {defaultCamZoom: 1}, Conductor.crotchet * .004, {ease: FlxEase.sineInOut});
					FlxTween.tween(cargoDarkFG, {alpha: 1}, Conductor.crotchet * .004);
					
					for (obj in [playHUD.timeBar, playHUD.timeTxt, playHUD.healthBar, playHUD.iconP1, playHUD.iconP2])
						FlxTween.tween(obj, {alpha: 0}, Conductor.crotchet * .004, {ease: FlxEase.circInOut});
					
				case 'readykill':
					if (!hasBfSkin) triggerEventNote('Change Character', '0', 'bf-defeat-normal');
					
					FlxTween.tween(game, {defaultCamZoom: .8}, Conductor.crotchet * .004 * 4, {ease: FlxEase.expoOut});
					
					if (yellow != null) yellow.kill();
					if (ClientPrefs.downScroll) playHUD.scoreTxt.y = FlxG.height * 0.06;
					if (hasColor) FlxG.signals.postUpdate.addOnce(()->{
						playHUD.scoreTxt.color = black.healthColour;
					});
					defeatDKoverlay.alpha = .1;
					lightoverlayDK.alpha = 0;
					cargoDark.alpha = 1;
					dad.alpha = 0;
					cargoDarkFG.alpha = 1;
					FlxTween.tween(cargoDarkFG, {alpha: 0}, 2.75);
					
					mainoverlayDK.flipY = true;
					mainoverlayDK.scale.y *= 3;
					mainoverlayDK.y += 1200;
					
					defeatness();
					
				case 'ending':
					FlxTween.tween(game, {defaultCamZoom: .6}, Conductor.crotchet * .004 * 16);
					FlxTween.tween(defeatDKoverlay, {alpha: 1}, Conductor.crotchet * .004 * 20, {ease: FlxEase.sineInOut});
					FlxTween.color(playHUD.scoreTxt, Conductor.crotchet * .004 * 20, black.healthColour, FlxColor.RED, {ease: FlxEase.sineInOut});
					FlxTween.tween(mainoverlayDK.scale, {y: mainoverlayDK.scale.y * 2}, Conductor.crotchet * .004 * 24, {ease: FlxEase.sineInOut});
				
				case 'endingcam':
					camSpecialThing([2220, 1050], [2220, 1050]);
					
				case 'kill':
					camGame.flash(FlxColor.RED, 2.75);
					black.kill();
					pet.kill();
					boyfriend.kill();
					defeatDKoverlay.kill();
					camHUD.visible = false;
									case 'Vignette On':
					setVignette(true);
				case 'Vignette Off':
					setVignette(false);
				case 'ending':
					setVignette(false);
					triggerEventNote('Lights on', '', '');
					boyfriend.visible = false;
					black.visible = false;
					triggerEventNote('HUD Fade', '0', '');
					triggerEventNote('Play Animation', 'liveReaction', 'dad');
					if (!hasBfSkin)
					{
						bfvent.alpha = 1;
						bfvent.animation.play('vent', true);
					}
					if (gf.getFlag('lightsDownSpeaker'))
					{
						ldSpeaker.animation.play('boom', true);
						ldSpeaker.alpha = 1;
					}
				case 'bye':
					camGame.alpha = 0;
			}
		case 'Lights out':
			if (value1 == '2' /* ????? */ || (value1 == '1' && !ClientPrefs.flashing)) return;
			
			isDark = true;
			
			// My favorite VS IMPOSTOR moment is when we loaded the dad shader despite this never being used outside of this song/character.
			camGame.flash(ClientPrefs.flashing ? FlxColor.WHITE : FlxColor.BLACK, 0.35);
			gf.alpha = 0;
			pet.alpha = 0;
			loBlack.alpha = 1;
			playHUD.iconP1.shader = hudDarkShader;
			playHUD.iconP2.shader = hudDarkShader;
			
			triggerEventNote('Change Character', '1', 'green-dark');
			dad.shader = null;
			
			playHUD.healthBar.bg.setColorTransform(0, 0, 0, 1, 224, 224, 224);
			
			var dark:Null<String> = boyfriend.getFlag('variants')?.dark;
			if (dark != null)
			{
				changeCharacter(dark, 0);
				boyfriend.shader = null;
				noshader = true;
			}
			else if (boyfriend.getFlag('dark') != true)
			{
				boyfriend.shader = darkShader;
			}
			
			playHUD.healthBar.setColors(FlxColor.BLACK, 0xffe0e0e0);
		case 'Lights on':
			if (value1 == '1' && !ClientPrefs.flashing) return;
			
			isDark = false;
			
			gf.alpha = 1;
			pet.alpha = 1;
			playHUD.iconP1.shader = null;
			playHUD.iconP2.shader = null;
			camGame.flash(FlxColor.BLACK, 0.35);
			loBlack.alpha = 0;
			
			playHUD.healthBar.bg.setColorTransform();
			
			if (noshader) changeCharacter(hasBfSkin ? ClientPrefs.bfSkin : PlayState.SONG.player1, 0);
			
			setVignette(vignette);
			triggerEventNote('Change Character', '1', PlayState.SONG.player2);
	}
			}


function defeatness():Void
{
	playHUD.scoreTxt.y -= 90;

	if (!ClientPrefs.shaders) return;
	
	var defeat:Null<String> = boyfriend.getFlag('variants')?.defeat;
	if (defeat != null) changeCharacter(defeat, 0);
	
	var blackRimlightBase:ExtraDropShadowShader = new funkin.game.shaders.ExtraDropShadowShader();
	
	blackRimlightBase.threshold = .05;
	blackRimlightBase.strength = .85;
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
		bfRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(blackRimlightBase);
		bfRim.attachedSprite = boyfriend;
		boyfriend.useRenderTexture = true;

		dadRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(blackRimlightBase);
		dadRim.attachedSprite = black;
        	black.shader = dadRim;
		black.useRenderTexture = true;
		dadRim.layers[0].angle = 170;
		dadRim.layers[1].angle = 88;
	} else dad.shader = null;
	
	if (hasPet)
	{
		petRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(blackRimlightBase);
		petRim.attachedSprite = pet;
		pet.useRenderTexture = true;
	}
	
	gfRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(blackRimlightBase);
	gfRim.attachedSprite = gf;
	gf.useRenderTexture = true;
	gf.shader = gfRim;
	gfRim.layers[0].angle = 90;
	gfRim.layers[1].angle = 90;
}

function setVignette(yea:Bool):Void
{
	vignette = yea;
	
	boyfriend.shader = dad.shader = black.shader = pet.shader = bg.shader = fg.shader = tn.shader = dimShader;
	
	if (dimShader == null) return;
	
	FlxTween.num(ClientPrefs.flashing ? .5 : 0, 1, .5, {ease: ClientPrefs.flashing ? FlxEase.elasticOut : FlxEase.sineOut}, function(n) {
		if (!yea) n = (1 - n);
		dimShader.setAdjustColor(n * -80, n * -20, n * -50, n * 20);
	});
}