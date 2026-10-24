import funkin.game.shaders.ChromaticAbberation;
import funkin.game.shaders.DropShadowShader;
import funkin.states.substates.PauseSubState;
import openfl.filters.ShaderFilter;

var bg:FlxSprite;
var thebackground:FlxSprite;
var grayfg:FlxSprite;
var lightadd:FlxSprite;
var lightsubtract:FlxSprite;
var hudDarkShader:ExtraDropShadowShader;
var darkShader:ExtraDropShadowShader;
var grayShader:ExtraDropShadowShader;
var isDark:Bool = false;
var noshader:Bool = false;
var ext = 'stages/airship/gray/';
var isChrom:Bool;
var chromAmount:Float = 0;
var chromFreq:Int = 1;
var chromTween:FlxTween;
public var crowd:FlxSprite;
var caShader:ChromaticAbberation;
var bfdead:FlxSprite;

function onBeatHit()
{
	if (curBeat % chromFreq == 0)
	{
		if (chromTween != null) chromTween.cancel();
		caShader.amount = chromAmount;
		chromTween = FlxTween.tween(caShader, {amount: 0}, 0.45, {ease: FlxEase.sineOut});
	}
	if (curBeat % 4 == 0) crowd.animation.play('bop', true);
}

function onLoad()
{
	bg = new FlxSprite(0, 0).loadGraphic(Paths.image(ext + 'graybg'));
	add(bg);
	
	thebackground = new FlxSprite(1930, 400);
	thebackground.frames = Paths.getSparrowAtlas(ext + 'grayglowy');
	thebackground.animation.addByPrefix('bop', 'jar??', 24, true);
	thebackground.animation.play('bop');
	thebackground.antialiasing = true;
	thebackground.scrollFactor.set(1, 1);
	thebackground.setGraphicSize(Std.int(thebackground.width * 1));
	thebackground.active = true;
	add(thebackground);
	
	crowd = new FlxSprite(200, 350);
	crowd.frames = Paths.getSparrowAtlas(ext + 'grayblack');
	crowd.animation.addByPrefix('bop', 'who instance 1', 18, false);
	crowd.animation.play('bop');
	add(crowd);
	
	bfdead = new FlxSprite(600, 525).loadGraphic(Paths.image('stages/polus/red/bfdead'));
	bfdead.setGraphicSize(Std.int(bfdead.width * 0.8));
	bfdead.updateHitbox();
	bfdead.alpha = 0;
}

function onCreatePost()
{
	forcedBotColor = true;

        if (ClientPrefs.shaders) {
		var dark:Null<String> = boyfriend.getFlag('variants')?.dark;
		if (dark != null) addCharacterToList(dark, 0);
	
	
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

		grayShader = new funkin.game.shaders.ExtraDropShadowShader();

		grayShader.threshold = .03;
		grayShader.setHollowColorMatrix([
			0, 0, 0, 0, 255,
			0, 0, 0, 0, 255,
			0, 0, 0, 0, 255,
			0, 0, 0, 1, 0
		]);
		grayShader.setColorMatrix([
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 1, 0
		]);
		grayShader.antialiasStages = 4;

		grayShader.addLayer([
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 1, 0
		], 200, 22, 0);
		grayShader.addLayer([
			0, 0, 0, 0, 255,
			0, 0, 0, 0, 255,
			0, 0, 0, 0, 255,
			0, 0, 0, 1, 0
		], 410, 10, 0);
		grayShader.addLayer([
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 1, 0
		], 238, 12, 0);

		darkShader.attachedSprite = boyfriend;
                grayShader.attachedSprite = dad;

		boyfriend.useRenderTexture = true;
                dad.useRenderTexture = true;

		boyfriend.shader = null;
                dad.shader = null;
        }

	snapCamToPos(1300, 700);
	camSpecialThing([1300, 700], [1800, 700]);
	// Lol
	if (boyfriend.curCharacter == 'bf-ghost')
	{
		bfdead.alpha = 1;
		bfdead.setPosition(boyfriend.x - 150, boyfriend.y + 350);
		stage.insert(stage.members.indexOf(boyfriendGroup) - 1, bfdead);
		
		if (ClientPrefs.shaders)
		{
			var rim:DropShadowShader;
			rim = new DropShadowShader();
			rim.setAdjustColor(-40, -25, -25, -25);
			rim.color = 0xFF447F80;
			rim.angle = 45;
			rim.threshold = 0.5;
			rim.distance = 25;
			bfdead.shader = rim;
			rim.attachedSprite = boyfriend;
			rim.updateFrameInfo(boyfriend.frame);
		}
		else
		{
			bfdead.color = 0xffa0c0d6;
		}
	}
	caShader = new ChromaticAbberation(0);
	caShader.amount = -0.5;
	if (ClientPrefs.shaders) FlxG.camera.filters = [new ShaderFilter(caShader.shader)];
	
	grayfg = new FlxSprite(1200, 1030).loadGraphic(Paths.image(ext
		+ 'grayfg'
		+ (boyfriend.curCharacter == 'yellowplayable' ? '_noyellow' : '')));
	grayfg.scrollFactor.set(1.1, 1.1);
	add(grayfg);
	
	lightadd = new FlxSprite(-150, -200).loadGraphic(Paths.image(ext + 'grayadd'));
	lightadd.scale.set(2, 2);
	lightadd.updateHitbox();
	lightadd.blend = BlendMode.ADD;
	lightadd.alpha = 1;
	add(lightadd);
	
	lightsubtract = new FlxSprite(-900, -200).loadGraphic(Paths.image(ext + 'graysubtract'));
	lightsubtract.scale.set(2, 2);
	lightsubtract.updateHitbox();
	lightsubtract.blend = BlendMode.SUBTRACT;
	lightsubtract.alpha = 1;
	add(lightsubtract);
	
	if (hasGfSkin && gf.curCharacter == 'gfmira') changeCharacter('gf-pretender', 2);
	if (ClientPrefs.shaders)
	{
		var rimlightBase:ExtraDropShadowShader = new funkin.game.shaders.ExtraDropShadowShader();
		
		rimlightBase.setColorMatrix([
			0.3, 0.2, 0, 0, 9,
		    -0.5, 0.77, 0.2, 0, 13,
			   0, -0.1, 0.69, 0, 20,
			   0, 0, 0, 1, 0
		]);
		rimlightBase.threshold = .02;
		rimlightBase.strength = .7;
		rimlightBase.addLayer(
			rimlightBase.addLayer([
				1.5, 0, 0, 0, -8,
				0, .8, .1, 0, 59,
				.1, 0, .8, 0, 57,
				0, 0, 0, 1, 0
			], 20, 25, .01)
		.colorMatrix, 90, 15, .01);
		
		if (hasBfSkin && boyfriend.curCharacter != 'bfairship' && boyfriend.getFlag('backlit') != true)
		{
			bfRim = rimlightBase;
			bfRim.attachedSprite = boyfriend;
			boyfriend.useRenderTexture = true;
		}
		
		if (hasGfSkin && gf.getFlag('backlit') != true)
		{
			gfRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(rimlightBase);
			gfRim.layers[0].distance = gfRim.layers[1].distance = 20;
			gfRim.layers[0].angle = 60;
			gfRim.layers[1].angle = 120;
			gfRim.attachedSprite = gf;
			gf.useRenderTexture = true;
		}
		if (hasPet)
		{
			petRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(rimlightBase);
			petRim.attachedSprite = pet;
		}
		if (hasBfSkin && boyfriend.curCharacter != 'bfairship' && boyfriend.getFlag('backlit') != true)
		{
		dadRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(rimlightBase);
dadRim.attachedSprite = dad;
dad.useRenderTexture = true;
}
if (hasBfSkin && boyfriend.curCharacter != 'bfairship' && boyfriend.getFlag('backlit') != true)
{
gfRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(rimlightBase);
			gfRim.layers[0].distance = gfRim.layers[1].distance = 20;
			gfRim.layers[0].angle = 60;
			gfRim.layers[1].angle = 120;
			gfRim.attachedSprite = gf;
			gf.useRenderTexture = true;
			}
	}
	else
	{
		if (hasBfSkin && boyfriend.curCharacter != 'bfairship') boyfriend.color = 0xffa0c0d6;
		
		if (hasGfSkin) gf.color = 0xffa0c0d6;
		
		if (hasPet) pet.color = 0xffa0c0d6;
	}
}

function onUpdatePost()
{
	if (ClientPrefs.inDevMode && showDevInfo) dbText = dbText + ('\nchrom (am, freq): ' + [chromAmount, chromFreq]);
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
		FlxG.signals.postUpdate.addOnce(()->{
			playHUD.ratingGraphic.color = FlxColor.WHITE;
			for (num in playHUD.ratingNumGroup.members)
				num.color = FlxColor.WHITE;
		});
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

function onEvent(eventName, value1, value2)
{
	switch (eventName)
	{
		case 'chromToggle':
			var theAmount:Float = Std.parseFloat(value1 ?? 0);
			var theAmount2:Int = Std.int(value2 ?? (theAmount > 0 ? 1 : 0));
			if (showDevInfo) trace([theAmount, theAmount2]);
			
			if (theAmount > 0)
			{
				isChrom = true;
				chromAmount = theAmount;
				chromFreq = theAmount2;
				return;
			}
			else
			{
				isChrom = false;
				chromAmount = 0;
				return;
			}
		case 'Lights out':
			if (value1 == '2' /* ????? */ || (value1 == '1' && !ClientPrefs.flashing)) return;

			isDark = true;
                        isChrom = false;
			
			// My favorite VS IMPOSTOR moment is when we loaded the dad shader despite this never being used outside of this song/character.
			camGame.flash(ClientPrefs.flashing ? FlxColor.WHITE : FlxColor.BLACK, 0.35);
			gf.alpha = 0.001;
			pet.alpha = 0.001;
			bg.alpha = 0.001;
			thebackground.alpha = 0.001;
			crowd.alpha = 0.001;
			bfdead.alpha = 0.001;
                        grayfg.alpha = 0.001;
                        lightadd.alpha = 0.001;
                        lightsubtract.alpha = 0.001;
			playHUD.iconP1.shader = hudDarkShader;
			playHUD.iconP2.shader = hudDarkShader;
			
			dad.shader = grayShader;
			
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
			if (value1 == '1' && !ClientPrefs.flashing) return;

			isDark = false;
			
			gf.alpha = 1;
			pet.alpha = 1;
			bg.alpha = 1;
			thebackground.alpha = 1;
			crowd.alpha = 1;
			if (boyfriend.curCharacter == "bfghost") bfdead.alpha = 1;
                        grayfg.alpha = 1;
                        lightadd.alpha = 1;
                        lightsubtract.alpha = 1;
			playHUD.iconP1.shader = null;
			playHUD.iconP2.shader = null;
			camGame.flash(FlxColor.BLACK, 0.35);
			
			playHUD.healthBar.bg.setColorTransform();
                        playHUD.healthBar.setColors(dad.healthColour, boyfriend.healthColour);
			
			if (noshader) changeCharacter(hasBfSkin ? ClientPrefs.bfSkin : PlayState.SONG.player1, 0);
                        boyfriend.shader = null;
dad.shader = null;

if (hasBfSkin && boyfriend.curCharacter != 'bfairship' && boyfriend.getFlag('backlit') != true)
{
    if (bfRim != null)
    {
        boyfriend.shader = bfRim;
        bfRim.attachedSprite = boyfriend;
        bfRim.updateFrameInfo(boyfriend.frame);
    }

    if (dadRim != null)
    {
        dad.shader = dadRim;
        dadRim.attachedSprite = dad;
        dadRim.updateFrameInfo(dad.frame);
    }
}
			playHUD.timeBar.setColors(
				0xFF44d844,
				0xFF2e412e
			);
			
			playHUD.timeTxt.color = FlxColor.WHITE;
			playHUD.timeTxt.borderColor = FlxColor.BLACK;
			
			playHUD.scoreTxt.borderColor = FlxColor.BLACK;
			playHUD.scoreTxt.color = dad.healthColour;
			
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
	if (isDark) return Function_Stop;
}
