import openfl.filters.ShaderFilter;

var distortionShader:FlxRuntimeShader;
var distortionAmount:Float = 0;
var distortionTween:FlxTween;

var colorShader = newShader('pureColor');
var discText:FlxText;

function onCreatePost()
{
	camHUD.alpha = 0;
	dad.color = FlxColor.BLACK;
	boyfriend.color = FlxColor.BLACK;
	pet.color = FlxColor.BLACK;
	health = 1; // hmm
	playHUD.updateIconsPosition();
	playHUD.updateIconPos = false;
	playHUD.healthBar.alpha = 0;
	if (!hasBfSkin)
	{
        	colorShader.data.colSet.value = [true];
        	colorShader.data.funnyColor.value = [1.0, 1.0, 1.0, 1.0];
        	colorShader.data.strength.value = [0];
		boyfriend.shader = colorShader;
	}
	boyfriend.alpha = 0;
	dad.alpha = 0;
	Paths.sound('join');
	Paths.sound('playerdisconnect');

	discText = new FlxText(30, FlxG.height - 40);
	discText.setFormat(Paths.font('vcr.ttf'), 18, FlxColor.RED, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	discText.scrollFactor.set();
	discText.borderSize = 1.25;
	discText.text = "boyfriend left the game";
	discText.cameras = [camHUD];
	discText.alpha = 0;
	game.add(discText);

	modManager.setValue('alpha', 1, 0);

	if (ClientPrefs.shaders)
	{
		distortionShader = newShader('pix_n_tv');

		distortionShader.setFloat('amount', 0);
		distortionShader.setFloat('pixel', 0);

		camGame.filters = [
			new ShaderFilter(distortionShader)
		];
	}
}

function onUpdate() if (health > 1) health = 1;

function onUpdatePost(elapsed:Float)
{
	if (!ClientPrefs.shaders || distortionShader == null)
		return;

	distortionShader.setFloat('amount', distortionAmount);
	distortionShader.setFloat('pixel', 0);
}

function onSpawnNotePost(note:Note)
{
	if (curBeat >= 16) note.visible = note.mustPress;
}

function onSongStart()
{
	FlxTween.tween(dad, {alpha: 1}, 0.5);
	FlxTween.tween(camHUD, {alpha: 1}, 0.5);
}

function onStepHit()
{
	switch (curStep)
	{
		case 1150:
			if (ClientPrefs.shaders && distortionShader != null)
			{
				if (distortionTween != null)
					distortionTween.cancel();

				distortionAmount = 0;

				distortionTween = FlxTween.num(
					0,
					0.4,
					1.2,
					{
						ease: FlxEase.linear
					},
					function(value:Float)
					{
						distortionAmount = value;
					}
				);
			}

		case 1168:
			if (ClientPrefs.shaders && distortionShader != null)
			{
				if (distortionTween != null)
					distortionTween.cancel();

				distortionAmount = 2;

				distortionTween = FlxTween.num(
					2,
					0,
					0.15,
					{
						ease: FlxEase.quadOut
					},
					function(value:Float)
					{
						distortionAmount = value;
					}
				);
			}
	}
}

function onBeatHit()
{
	switch (curBeat)
	{
		case 14:
  			FlxTween.num(1, 0, 0.7, {ease: FlxEase.quadInOut, onUpdate: function(twn:FlxTween) 								modManager.setValue('alpha', twn.value, 0)
			});
		case 16:
			camSpecialThing([750, 500], [750, 500], 0.6);
			FlxTween.tween(boyfriend, {alpha: 1}, 0.5);
			if (!hasBfSkin)
			FlxTween.num(0, 0.4, 0.5, {onUpdate: function(twn) colorShader.data.strength.value = [twn.value], onComplete: function() {
				FlxTween.num(0.4, 0, 0.5, {onUpdate: function(twn) colorShader.data.strength.value = [twn.value]});
				}
			});
			FlxG.sound.play(Paths.sound('join'));
		case 32:
			comboX = 440;
			if (!ClientPrefs.middleScroll)
			{
  				FlxTween.num(0, 0.5, 0.7, {ease: FlxEase.quadOut, onUpdate: function(twn:FlxTween) 								modManager.setValue('opponentSwap', twn.value, -1)
				});
  				FlxTween.num(0, 1, 0.7, {ease: FlxEase.quadOut, onUpdate: function(twn:FlxTween) 								modManager.setValue('alpha', twn.value, 1)
				});
				comboX = 440;
			}
			FlxTween.color(boyfriend, 1, FlxColor.BLACK, FlxColor.WHITE);
			FlxTween.color(dad, 1, FlxColor.BLACK, FlxColor.WHITE);
			FlxTween.color(pet, 1, FlxColor.BLACK, FlxColor.WHITE);
			defaultCamZoom = 0.7;
		case 48:
			defaultCamZoom = 0.8;
		case 64:
			camZoomingDecay = 0.7;
			camSpecialThing([500, 500], [950, 550], 0.95);
		case 68:
			camZoomingDecay = 1;
			camSpecialThing([750, 500], [750, 500], 0.5);
			changeCharacter("black", 1);
		case 84:
			camSpecialThing([400, 750], [400, 750], -1, 0);
			game.isCameraOnForcedPos = true;
			FlxG.camera.zoom = defaultCamZoom = 0.8;
			FlxTween.tween(game.camFollow, {x: 390}, 1, {ease: FlxEase.quadOut});
		case 88:
			FlxTween.cancelTweensOf(game.camFollow);
			camSpecialThing([900, 750], [900, 750], -1, 0);
			game.isCameraOnForcedPos = true;
			FlxG.camera.zoom = defaultCamZoom = 0.8;
			FlxTween.tween(game.camFollow, {x: 910}, 1, {ease: FlxEase.quadOut});
		case 92:
			FlxTween.cancelTweensOf(game.camFollow);
			camSpecialThing([500, 600], [400, 600], -1, 0);
			game.isCameraOnForcedPos = true;
			FlxG.camera.zoom = defaultCamZoom = 0.8;
			FlxTween.tween(FlxG.camera, {zoom: 0.85}, 1.2, {ease: FlxEase.quadOut, onUpdate: function(twn:FlxTween) defaultCamZoom = FlxG.camera.zoom});
			dad.playAnim("kill");
			dad.canDance = false;
		case 96:
			camSpecialThing([500, 500], [825, 500], -1, 1);
			game.isCameraOnForcedPos = true;
			FlxTween.tween(FlxG.camera, {zoom: 0.5}, 1.2, {ease: FlxEase.quadOut, onUpdate: function(twn:FlxTween) defaultCamZoom = FlxG.camera.zoom});
		case 100:
			dad.canDance = true;
			camSpecialThing([500, 500], [900, 500], 0.6);
			game.isCameraOnForcedPos = false;
		case 164:
			camSpecialThing([750, 500], [750, 500], 0.5);
		case 194:
			defaultCamZoom = 0.6;
		case 212:
			defaultCamZoom = 0.7;
		case 228:
			defaultCamZoom = 0.8;
		case 244:
			defaultCamZoom = 0.85;
		case 260:
			defaultCamZoom = 0.6;
		case 292:
			defaultCamZoom = 0.75;
		case 360:
			camSpecialThing([500, 500], [900, 500], 0.6);
		case 424:
			camSpecialThing([750, 500], [750, 500], 0.7);
		case 456:
			defaultCamZoom = 0.8;
		case 472:
			defaultCamZoom = 0.9;
		case 488:
			defaultCamZoom = 1;
			FlxTween.tween(redscreen, {alpha: 1}, 0.2, {ease: FlxEase.expoOut});
		case 500:
			FlxG.sound.play(Paths.sound("stage/playerdisconnect"));
			discText.alpha = 1;
			
	}
}

function onDestroy()
{
	if (distortionTween != null)
		distortionTween.cancel();

	if (camGame != null)
		camGame.filters = [];
}