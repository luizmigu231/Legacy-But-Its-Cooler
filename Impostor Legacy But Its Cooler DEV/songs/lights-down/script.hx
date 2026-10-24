import funkin.backend.FunkinShader.FunkinRuntimeShader;
import funkin.states.substates.PauseSubState;

var lightsShader:FunkinRuntimeShader;
public var dimShader = (ClientPrefs.shaders ? new funkin.game.shaders.ColorMatrixShader() : null);
public var hudDarkShader:ExtraDropShadowShader;
public var darkShader:ExtraDropShadowShader;
public var vignette:Bool = false;

var isDark:Bool = false;
var noshader:Bool = false;
var noteShader = newShader('blacknotes');
var miraGradient:FlxSprite;

function onLoad()
{
	readDialogue();
	
	var dark:Null<String> = boyfriend.getFlag('variants')?.dark;
	if (dark != null)
		addCharacterToList(dark, 0);
	
	addCharacterToList('green-dark', 1);
	
	darkShader = new funkin.game.shaders.ExtraDropShadowShader();
	
	darkShader.threshold = .03;
	
	darkShader.setHollowColorMatrix([
		0, 0, 0, 0, 255,
		0, 0, 0, 0, 255,
		0, 0, 0, 0, 255,
		0, 0, 0, 1, 0
	]);
	
	darkShader.setColorMatrix([
		0, 0, 0, 0, 0,
		0, 0, 0, 0, 0,
		0, 0, 0, 0, 0,
		0, 0, 0, 1, 0
	]);
	
	darkShader.antialiasStages = 4;
	
	hudDarkShader = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(darkShader);
	hudDarkShader.threshold = .12;
	
	hudDarkShader.setHollowColorMatrix([
		0, 0, 0, 0, 224,
		0, 0, 0, 0, 224,
		0, 0, 0, 0, 224,
		0, 0, 0, 1, 0
	]);
	
	darkShader.addLayer([
		0, 0, 0, 0, 0,
		0, 0, 0, 0, 0,
		0, 0, 0, 0, 0,
		0, 0, 0, 1, 0
	], -70, 22, 0);
	
	darkShader.addLayer([
		0, 0, 0, 0, 255,
		0, 0, 0, 0, 255,
		0, 0, 0, 0, 255,
		0, 0, 0, 1, 0
	], 140, 10, 0);
	
	darkShader.addLayer([
		0, 0, 0, 0, 0,
		0, 0, 0, 0, 0,
		0, 0, 0, 0, 0,
		0, 0, 0, 1, 0
	], -32, 12, 0);
	
	darkShader.attachedSprite = boyfriend;
	boyfriend.useRenderTexture = true;
	boyfriend.shader = null;
}

function onCreatePost()
{
	if (!hasBfSkin)
		bfvent.alpha = 0.001;
	
	if (gf.getFlag('lightsDownSpeaker'))
		ldSpeaker.alpha = 0.001;

	miraGradient = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/mira/cafeteria/MiraGradient'));
	miraGradient.scrollFactor.set(0, 0);
	miraGradient.setGraphicSize(FlxG.width, FlxG.height);
	miraGradient.screenCenter();
	miraGradient.alpha = 0;
	miraGradient.cameras = [camHUD];
	add(miraGradient);
}

function applyDarkShader(sprite:FlxSprite)
{
	if (!ClientPrefs.shaders || !isDark || sprite == null)
		return;
	
	if (sprite.shader != null)
		return;
	
	var shader = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(darkShader);
	shader.attachedSprite = sprite;
	
	sprite.useRenderTexture = true;
	sprite.shader = shader;
}

function onPopUpScorePost(note, rating)
{
	if (isDark)
	{
		playHUD.ratingGraphic.color = FlxColor.WHITE;
		for (num in playHUD.ratingNumGroup.members)
			num.color = FlxColor.WHITE;
	}
}

function onMoveCamera(whosTurn:String)
{
	if (miraGradient != null)
	{
		if (whosTurn == 'boyfriend') miraGradient.flipX = true;
		else miraGradient.flipX = false;
	}
}

function clearDarkShader(sprite:FlxSprite)
{
	if (sprite == null)
		return;
	
	sprite.shader = null;
	sprite.useRenderTexture = false;
}

function applyDarkShaderToStrums()
{
	for (strum in playerStrums)
		applyDarkShader(strum);
	
	for (strum in opponentStrums)
		applyDarkShader(strum);
}

function clearDarkShaderFromStrums()
{
	for (strum in playerStrums)
		clearDarkShader(strum);
	
	for (strum in opponentStrums)
		clearDarkShader(strum);
}

function setVignette(yea:Bool):Void
{
	vignette = yea;
	
	boyfriend.shader = dad.shader = gf.shader = pet.shader = bg.shader = fg.shader = tn.shader = blue.shader = orange.shader = white.shader = dimShader;
	
	if (dimShader == null)
		return;
	
	FlxTween.num(
		ClientPrefs.flashing ? .5 : 0,
		1,
		.5,
		{
			ease: ClientPrefs.flashing ? FlxEase.elasticOut : FlxEase.sineOut
		},
		function(n)
		{
			if (!yea)
				n = (1 - n);
			
			dimShader.setAdjustColor(
				n * -80,
				n * -20,
				n * -50,
				n * 20
			);
		}
	);
	FlxTween.tween(miraGradient, {alpha: (yea) ? 0.6 : 0}, .5, {ease: ClientPrefs.flashing ? FlxEase.elasticOut : FlxEase.sineOut});
}

function onEvent(eventName, value1, value2)
{
	switch (eventName)
	{
		case 'Legacy':
			switch (value1)
			{
				case 'Vignette On':
					setVignette(true);
				
				case 'Vignette Off':
					setVignette(false);
				
				case 'ending':
					setVignette(false);
					triggerEventNote('Lights on', '', '');
					triggerEventNote('Restore Rim', '', '');
					boyfriend.visible = false;
					gf.visible = false;
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
			if (value1 == '2' || (value1 == '1' && !ClientPrefs.flashing))
				return;
			
			isDark = true;
			
			camGame.flash(
				ClientPrefs.flashing ? FlxColor.WHITE : FlxColor.BLACK,
				0.35
			);
			
			gf.alpha = 0;
			pet.alpha = 0;
			loBlack.alpha = 1;
			
			playHUD.iconP1.shader = hudDarkShader;
			playHUD.iconP2.shader = hudDarkShader;
			
			triggerEventNote('Change Character', '1', 'green-dark');
			dad.shader = null;
			
			playHUD.healthBar.bg.setColorTransform(
				0, 0, 0, 1,
				224, 224, 224
			);
			
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
			
			FlxG.signals.postUpdate.addOnce(() -> {
				playHUD.healthBar.setColors(
					FlxColor.BLACK,
					FlxColor.BLACK
				);
			});
			
			playHUD.timeBar.setColors(
				FlxColor.BLACK,
				FlxColor.BLACK
			);
			
			playHUD.timeTxt.color = FlxColor.BLACK;
			playHUD.timeTxt.borderColor = FlxColor.WHITE;
			
			playHUD.scoreTxt.borderColor = FlxColor.WHITE;
			playHUD.scoreTxt.color = FlxColor.BLACK;
			
			game.botplayTxt.borderColor = FlxColor.WHITE;
			game.botplayTxt.color = FlxColor.BLACK;
			
			for (i in opponentStrums)
				i.visible = false;
			
			for (note in game.notes)
			{
				note.visible = note.mustPress;
				
				if (note.mustPress)
					applyDarkShader(note);
			}
			
			applyDarkShaderToStrums();
			
			playHUD.ratingPrefix = '/ui/lights-down/';
			playHUD.ratingSuffix = '-ld';
			
			for (member in members)
				if (ClientPrefs.inDevMode && Std.isOfType(member, FlxSprite) && member.camera == camOther && member.alpha == 0.3)
					member.loadGraphic(Paths.image('menu/pause/looksie_extreme_demon-dark'));

		case 'Lights on':
			if (value1 == '1' && !ClientPrefs.flashing)
				return;
			
			isDark = false;
			
			gf.alpha = 1;
			pet.alpha = 1;
			
			playHUD.iconP1.shader = null;
			playHUD.iconP2.shader = null;
			
			camGame.flash(
				FlxColor.BLACK,
				0.35
			);
			
			loBlack.alpha = 0;
			
			playHUD.healthBar.bg.setColorTransform();
			
			if (noshader)
			{
				changeCharacter(
					hasBfSkin ? ClientPrefs.bfSkin : PlayState.SONG.player1,
					0
				);
				
				noshader = false;
			}
			
			setVignette(vignette);
			
			triggerEventNote(
				'Change Character',
				'1',
				PlayState.SONG.player2
			);
			
			playHUD.timeBar.setColors(
				0xFF44d844,
				0xFF2e412e
			);
			
			playHUD.timeTxt.color = FlxColor.WHITE;
			playHUD.timeTxt.borderColor = FlxColor.BLACK;
			
			playHUD.scoreTxt.borderColor = FlxColor.BLACK;
			
			game.botplayTxt.borderColor = FlxColor.BLACK;
			game.botplayTxt.color = FlxColor.WHITE;
			
			for (i in opponentStrums)
				i.visible = true;
			
			for (note in game.notes)
			{
				note.visible = true;
				clearDarkShader(note);
				
				if (note.noteSplash != null)
					clearDarkShader(note.noteSplash);
				
				if (note.sustainSplash != null)
					clearDarkShader(note.sustainSplash);
			}
			
			clearDarkShaderFromStrums();
			
			playHUD.ratingPrefix = '';
			playHUD.ratingSuffix = '';
			
			for (member in members)
				if (ClientPrefs.inDevMode && Std.isOfType(member, FlxSprite) && member.camera == camOther && member.alpha == 0.3)
					member.loadGraphic(Paths.image('menu/pause/looksie_extreme_demon'));
	}
}

function onSubstateOpen()
{
	if (!isDark)
		return;
	
	FlxG.signals.postUpdate.addOnce(() -> {
		
		if (PauseSubState.instance != null)
		{
			var pause = PauseSubState.instance;
			
			for (option in pause.optionText)
			{
				option.color = FlxColor.BLACK;
				option.borderColor = FlxColor.WHITE;
			}
			
			pause.infoTitle.color = FlxColor.BLACK;
			pause.infoTitle.borderColor = FlxColor.WHITE;
			pause.infoSubtext.color = FlxColor.BLACK;
			pause.infoSubtext.borderColor = FlxColor.WHITE;
			pause.looksie.loadGraphic(Paths.image('menu/pause/looksie-dark'));
		}
	});
}

function onSpawnNotePost(note:Note)
{
	if (note == null)
		return;
	
	if (isDark)
	{
		note.visible = note.mustPress;
		
		if (note.mustPress)
			applyDarkShader(note);
	}
	else
	{
		clearDarkShader(note);
		note.visible = true;
	}
}

function onSpawnNoteSplash(splash:NoteSplash, note:Note)
{
	if (splash == null)
		return;
	
	if (isDark)
	{
		applyDarkShader(splash);
	}
	else
	{
		clearDarkShader(splash);
	}
}

function onSpawnSustainSplash(splash:SustainSplash, note:Note)
{
	if (splash == null)
		return;
	
	if (isDark)
	{
		applyDarkShader(splash);
	}
	else
	{
		clearDarkShader(splash);
	}
}

function onGhostAnim(anim, note)
{
	if (isDark)
		return Function_Stop;
}