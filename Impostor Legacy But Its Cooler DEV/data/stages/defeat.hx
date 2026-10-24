import funkin.states.substates.GameOverSubstate;
import funkin.states.substates.PauseSubState;
import flixel.text.FlxText;
import funkin.Mods;
import flixel.util.FlxStringUtil;
import openfl.media.Sound;
import funkin.game.huds.PsychHUD;
import animate.FlxAnimateFrames;

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
var dadRim:DropShadowShader;
var gfRim:DropShadowShader;

var isRetro:Bool = false;

var rimBeatTweenBF:FlxTween;
var rimBeatTweenPet:FlxTween;
var rimBeatTweenDad:FlxTween;
var rimBeatTweenGF:FlxTween;

var rimNormalStrength:Float = 0.85;
var rimBeatStrength:Float = 1.15;

var dadEyeBlack:FunkinSprite;
var dadEyeBlackDk:FunkinSprite;
var dadEyeOverlay:FunkinSprite;
var dadEyeAnim:String = '';
var dadEyeCharacter:String = '';

var dadRenderOwner:Dynamic = null;
var dadEyeHiddenOwner:Dynamic = null;

function onLoad()
{
	healthLoss = 0;

	bg = new FlxSprite(-700,-640).loadGraphic(
		Paths.image(ext + 'TripleKillBG')
	);
	bg.antialiasing = ClientPrefs.globalAntialiasing;
	bg.scrollFactor.set(0,0);
	bg.setGraphicSize(
		Std.int(bg.width * 1.3)
	);
	bg.updateHitbox();
	bg.alpha = 0.001;
	add(bg);

	defeattext = new FlxText(0,30,-1,'');
	defeattext.setFormat(
		Paths.font('vcr.ttf'),
		195,
		0xFFFF0000
	);
	defeattext.antialiasing = false;
	defeattext.scrollFactor.set(0.9,0.9);
	defeattext.alpha = 1;
	add(defeattext);

	defeattext.text = Lang.str('stage_defeat');
	defeattext.updateHitbox();
	defeattext.x =
		750 -
		(defeattext.frameWidth / 2);

	defeatthing = new FlxSprite(225,380);
	defeatthing.loadGraphic(
		Paths.image(ext + 'defeatpulse')
	);
	defeatthing.setGraphicSize(
		Std.int(defeatthing.width * 4)
	);
	defeatthing.antialiasing =
		ClientPrefs.globalAntialiasing;
	defeatthing.scrollFactor.set(0.8,0.8);
	defeatthing.alpha = .4;
	add(defeatthing);

	old_defeat =
		new FlxSprite(250,125).loadGraphic(
			Paths.image(ext + 'defeatfnf')
		);

	old_defeat.antialiasing =
		ClientPrefs.globalAntialiasing;

	old_defeat.setGraphicSize(
		Std.int(old_defeat.width * 2)
	);

	old_defeat.alpha = 0.01;
	add(old_defeat);

	bodies2 =
		new FlxSprite(-500,50).loadGraphic(
			Paths.image(ext + 'idontknwo')
		);

	bodies2.antialiasing =
		ClientPrefs.globalAntialiasing;

	bodies2.setGraphicSize(
		Std.int(bodies2.width * 1.3)
	);

	bodies2.scrollFactor.set(0.9,0.9);
	bodies2.alpha = 0.001;
	add(bodies2);

	bodies =
		new FlxSprite(-4800,-900).loadFromSheet(
			ext + 'props',
			'deadBG'
		);

	bodies.scale.set(5,5);
	bodies.updateHitbox();
	bodies.scrollFactor.set(0.9, 0.9);
	bodies.setGraphicSize(
		Std.int(bodies.width * 0.26)
	);

	bodies.antialiasing =
		ClientPrefs.globalAntialiasing;

	bodies.scrollFactor.set(0.9,0.9);
	bodies.alpha = 0.001;
	add(bodies);

	edgeglow1 =
		new FlxSprite(-1000,-720).loadGraphic(
			Paths.image(ext + 'edgeglow')
		);

	edgeglow1.scale.set(1.6,1.6);
	edgeglow1.updateHitbox();
	edgeglow1.blend = BlendMode.ADD;

	edgeglow1.antialiasing =
		ClientPrefs.globalAntialiasing;

	edgeglow1.scrollFactor.set(0,0);
	edgeglow1.alpha = 0.001;
	add(edgeglow1);

	edgeglow2 =
		new FlxSprite(-1000,720).loadGraphic(
			Paths.image(ext + 'edgeglow')
		);

	edgeglow2.scale.set(1.6,1.6);
	edgeglow2.updateHitbox();
	edgeglow2.blend = BlendMode.ADD;

	edgeglow2.antialiasing =
		ClientPrefs.globalAntialiasing;

	edgeglow2.scrollFactor.set(0,0);
	edgeglow2.alpha = 0.001;
	add(edgeglow2);

	subtract =
		new FlxSprite(-700,-500).loadGraphic(
			Paths.image(ext + 'subtract')
		);

	subtract.scale.set(4,4);
	subtract.updateHitbox();
	subtract.blend = BlendMode.SUBTRACT;

	subtract.antialiasing =
		ClientPrefs.globalAntialiasing;

	subtract.scrollFactor.set(0,0);
	subtract.alpha = 0.001;
	add(subtract);

	redscreen =
		new FlxSprite().makeScaledGraphic(
			FlxG.width,
			FlxG.height,
			0xFFA90000
		);

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

	playHUD.scoreTxt.text =
		songMisses +
		'/' +
		PlayState.totalMisses +
		' ' +
		Lang.str('misses') +
		' | ' +
		Lang.str('rank') +
		': ' +
		Lang.str('AWARDNAME_no_miss_finale') +
		'.';

	playHUD.updateIconPos = false;

	iconP1.x =
		(FlxG.width - iconP1.width) / 2 + 50;

	iconP2.x =
		(FlxG.width - iconP2.width) / 2 - 50;

	iconP1.visible = false;
	iconP2.visible = false;

	defeatRetro = (
		boyfriend.getFlag('variants')?.retro ??
		boyfriend.getFlag('defeatRetro')
	);

	if (defeatRetro != null)
		addCharacterToList(
			defeatRetro,
			0
		);

	addCharacterToList('blackold',1);
	addCharacterToList('black',1);
	addCharacterToList('blackdk',1);

	/*
	 * O estado inicial desta música é BLACKDK.
	 * O BLACK só é colocado pelo evento Defeat Retro 1.
	 */
	changeCharacter('blackdk',1);

	snapCamToPos(750,500);

	dadGroup.zIndex = 1;
	boyfriendGroup.zIndex = 0;

	bodiesfront =
		new FlxSprite(-3770,-250).loadFromSheet(
			ext + 'props',
			'deadFG'
		);

	bodiesfront.scale.set(5,5);
	bodiesfront.updateHitbox();
	bodiesfront.scrollFactor.set(0.5, 1);
	bodiesfront.setGraphicSize(
		Std.int(bodiesfront.width * 0.3)
	);

	bodiesfront.antialiasing =
		ClientPrefs.globalAntialiasing;

	bodiesfront.scrollFactor.set(0.5,1);
	bodiesfront.alpha = 0.001;
	bodiesfront.zIndex = 2;

	if (!ClientPrefs.lowQuality)
		add(bodiesfront);

	lightoverlay =
		new FlxSprite(-500,-200).loadGraphic(
			Paths.image(ext + 'iluminao omaga')
		);

	lightoverlay.scale.set(4,4);
	lightoverlay.updateHitbox();
	lightoverlay.blend = BlendMode.ADD;

	lightoverlay.antialiasing =
		ClientPrefs.globalAntialiasing;

	lightoverlay.zIndex = 3;
	lightoverlay.alpha = 0.6;

	add(lightoverlay);

	redscreen.zIndex = 3;

	refreshZ();

	if (ClientPrefs.shaders)
	{
		var blackRimlightBase:ExtraDropShadowShader =
			new funkin.game.shaders.ExtraDropShadowShader();

		blackRimlightBase.threshold = .05;
		blackRimlightBase.strength =
			rimNormalStrength;

		blackRimlightBase.setColorMatrix([
			.4,.5,-.2,0,-50,
			-.25,.7,-.15,0,-20,
			.42,-.35,.85,0,-72,
			0,0,0,1,0
		]);

		blackRimlightBase.addLayer([
			.7,.5,1,0,192,
			.3,.4,-.5,0,64,
			-.1,.2,.35,0,74,
			0,0,0,1,0
		],10,14,.01);

		blackRimlightBase.addLayer(
			blackRimlightBase.addLayer([
				.9,.6,.4,0,4,
				-.2,.5,.1,0,-18,
				-.2,.2,.4,0,-28,
				0,0,0,1,0
			],12,40,.01,.4)
			.colorMatrix,
			96,
			24,
			.01,
			.4
		);

		if (
			hasBfSkin &&
			boyfriend.getFlag('backlit') != true
		)
		{
			bfRim = blackRimlightBase;
			bfRim.attachedSprite = boyfriend;
			boyfriend.useRenderTexture = true;
		}

		if (hasPet)
		{
			petRim =
				new funkin.game.shaders.ExtraDropShadowShader()
				.copyFrom(
					blackRimlightBase
				);

			petRim.attachedSprite = pet;
			pet.useRenderTexture = true;
		}

		dadRim =
			new funkin.game.shaders.ExtraDropShadowShader()
			.copyFrom(
				blackRimlightBase
			);

		dadRim.attachedSprite = dad;
		dad.useRenderTexture = true;

		dadRim.layers[0].angle = 170;
		dadRim.layers[1].angle = 88;

		gfRim =
			new funkin.game.shaders.ExtraDropShadowShader()
			.copyFrom(
				blackRimlightBase
			);

		gfRim.attachedSprite = gf;
		gf.useRenderTexture = true;

		gfRim.layers[0].angle = 90;
		gfRim.layers[1].angle = 90;

		turnShader(true);
	}

	createDadEyeOverlays();
	refreshDadCharacter();

	camSpecialThing(
		[750,500],
		[750,500],
		defaultCamZoom
	);

	PauseSubState.songName = 'blackPause';
}

function createDadEyeOverlays():Void
{
	if (dadEyeBlack == null)
		dadEyeBlack =
			createDadEyeOverlay('black');

	if (dadEyeBlackDk == null)
		dadEyeBlackDk =
			createDadEyeOverlay('blackdk');

	if (dadEyeBlack != null)
	{
		dadEyeBlack.visible = false;
		dadEyeBlack.active = false;
	}

	if (dadEyeBlackDk != null)
	{
		dadEyeBlackDk.visible = false;
		dadEyeBlackDk.active = false;
	}

	dadEyeOverlay = null;
	dadEyeCharacter = '';
	dadEyeAnim = '';
}

function createDadEyeOverlay(
	characterName:String
):FunkinSprite
{
	var char =
		dadGroup.map.get(characterName);

	if (char == null)
		return null;

	var atlasPath:String =
		Paths.getPath(
			'images/${char.imageFile}',
			null,
			PathsTestMode.LOOSE
		);

	/*
	 * Esta é uma instância exclusiva para a
	 * overlay. Nunca é colocada no dad real.
	 */
	var eyeFrames:FlxAnimateFrames =
		FlxAnimateFrames.fromAnimate(
			atlasPath,
			null,
			null,
			'dadEyeUnique_${characterName}',
			true,
			{cacheOnLoad:false}
		);

	if (eyeFrames == null)
		return null;

	var overlay:FunkinSprite =
		new FunkinSprite(0,0);

	overlay.frames = eyeFrames;

	for (anim in char.animations)
	{
		if (anim == null)
			continue;

		if (
			characterName == 'blackdk' &&
			anim.anim == 'fall'
		)
			continue;

		var animName:String =
			'' + anim.anim;

		var sourceName:String =
			'' + anim.name;

		var fps:Int = anim.fps;
		var looping:Bool = !!anim.loop;

		var indices:Array<Int> =
			anim.indices ?? [];

		var flipX:Bool =
			anim.flipX ?? false;

		var flipY:Bool =
			anim.flipY ?? false;

		if (indices.length > 0)
		{
			overlay.addAnimByIndices(
				animName,
				sourceName,
				indices,
				fps,
				looping,
				flipX,
				flipY
			);
		}
		else
		{
			overlay.addAnimByPrefix(
				animName,
				sourceName,
				fps,
				looping,
				flipX,
				flipY
			);
		}
	}

	overlay.scalableOffsets =
		char.scalableOffsets;

	overlay.rotatableOffsets =
		char.rotatableOffsets;

	overlay.skewableOffsets =
		char.skewableOffsets;

	overlay.baseFlipX =
		char.baseFlipX;

	overlay.baseFlipY =
		char.baseFlipY;

	overlay.antialiasing =
		char.antialiasing;

	overlay.shader = null;
	overlay.useRenderTexture = false;

	overlay.cameras = [camGame];

	overlay.scrollFactor.set(
		char.scrollFactor.x,
		char.scrollFactor.y
	);

	overlay.zIndex =
		char.zIndex + 0.01;

	overlay.active = false;
	overlay.visible = false;

	if (characterName == 'black')
	{
		maskDadEyeSymbol(
			overlay,
			'black up',
			['ojo impostor']
		);

		maskDadEyeSymbol(
			overlay,
			'black down',
			['Capa 29']
		);

		maskDadEyeSymbol(
			overlay,
			'black left',
			['ojo impostor']
		);

		maskDadEyeSymbol(
			overlay,
			'black right',
			['ojo impostor']
		);

		maskDadEyeSymbol(
			overlay,
			'black idle remast',
			['ojo impostor']
		);

		maskDadEyeSymbol(
			overlay,
			'black expo',
			['ojo impostor']
		);

		maskDadEyeSymbol(
			overlay,
			'black kill',
			['ojo impostor']
		);

		maskDadEyeSymbol(
			overlay,
			'black expo/black kill',
			['ojo impostor']
		);

		maskDadEyeSymbol(
			overlay,
			'black kill 2',
			['ojo impostor']
		);
	}
	else if (characterName == 'blackdk')
	{
		maskDadEyeSymbol(
			overlay,
			'Símbolo 30',
			['Capa 17','Símbolo 25']
		);

		maskDadEyeSymbol(
			overlay,
			'Símbolo 36',
			['Símbolo 25']
		);

		maskDadEyeSymbol(
			overlay,
			'BLACK RIGHT',
			['Símbolo 25']
		);

		maskDadEyeSymbol(
			overlay,
			'Símbolo 31',
			['Símbolo 25']
		);

		maskDadEyeSymbol(
			overlay,
			'Símbolo 35',
			['Símbolo 25']
		);

		maskDadEyeSymbol(
			overlay,
			'Símbolo 25',
			[
				'Capa 4',
				'Capa 5',
				'Capa 3',
				'Capa 2 copy 3',
				'Capa 2 copy 4',
				'Capa 2 copy 2',
				'Capa 2'
			]
		);
	}

	dadGroup.add(overlay);

	return overlay;
}

function maskDadEyeSymbol(
	overlay:FunkinSprite,
	symbolName:String,
	eyeLayers:Array<String>
):Void
{
	if (
		overlay == null ||
		overlay.library == null
	)
		return;

	var symbol =
		overlay.library.getSymbol(symbolName);

	if (
		symbol == null ||
		symbol.timeline == null
	)
		return;

	for (layer in symbol.timeline.layers)
	{
		var showLayer:Bool =
			eyeLayers.indexOf(layer.name) >= 0;

		layer.forEachFrame(function(frame)
		{
			if (
				frame == null ||
				frame.elements == null
			)
				return;

			for (element in frame.elements)
				element.visible = showLayer;
		});
	}
}

function hideOriginalDadEye():Void
{
	if (
		dad == null ||
		dad.library == null
	)
		return;

	if (dadEyeHiddenOwner == dad)
		return;

	switch (dad.curCharacter)
	{
		case 'black':
			hideDadEyeLayers(
				dad,
				'black up',
				['ojo impostor']
			);

			hideDadEyeLayers(
				dad,
				'black down',
				['Capa 29']
			);

			hideDadEyeLayers(
				dad,
				'black left',
				['ojo impostor']
			);

			hideDadEyeLayers(
				dad,
				'black right',
				['ojo impostor']
			);

			hideDadEyeLayers(
				dad,
				'black idle remast',
				['ojo impostor']
			);

			hideDadEyeLayers(
				dad,
				'black expo',
				['ojo impostor']
			);

			hideDadEyeLayers(
				dad,
				'black kill',
				['ojo impostor']
			);

			hideDadEyeLayers(
				dad,
				'black expo/black kill',
				['ojo impostor']
			);

			hideDadEyeLayers(
				dad,
				'black kill 2',
				['ojo impostor']
			);

		case 'blackdk':
			hideDadEyeLayers(
				dad,
				'Símbolo 30',
				['Capa 17','Símbolo 25']
			);

			hideDadEyeLayers(
				dad,
				'Símbolo 36',
				['Símbolo 25']
			);

			hideDadEyeLayers(
				dad,
				'BLACK RIGHT',
				['Símbolo 25']
			);

			hideDadEyeLayers(
				dad,
				'Símbolo 31',
				['Símbolo 25']
			);

			hideDadEyeLayers(
				dad,
				'Símbolo 35',
				['Símbolo 25']
			);
	}

	dadEyeHiddenOwner = dad;
}

function hideDadEyeLayers(
	sprite:FunkinSprite,
	symbolName:String,
	hiddenLayers:Array<String>
):Void
{
	if (
		sprite == null ||
		sprite.library == null
	)
		return;

	var symbol =
		sprite.library.getSymbol(symbolName);

	if (
		symbol == null ||
		symbol.timeline == null
	)
		return;

	for (layer in symbol.timeline.layers)
	{
		if (
			hiddenLayers.indexOf(layer.name) < 0
		)
			continue;

		layer.forEachFrame(function(frame)
		{
			if (
				frame == null ||
				frame.elements == null
			)
				return;

			for (element in frame.elements)
				element.visible = false;
		});
	}
}

function restoreOriginalDadEye():Void
{
	var blackChar:FunkinSprite =
		dadGroup.map.get('black');

	var blackDkChar:FunkinSprite =
		dadGroup.map.get('blackdk');

	if (
		blackChar != null &&
		blackChar.library != null
	)
	{
		restoreDadEyeLayers(
			blackChar,
			'black up',
			['ojo impostor']
		);

		restoreDadEyeLayers(
			blackChar,
			'black down',
			['Capa 29']
		);

		restoreDadEyeLayers(
			blackChar,
			'black left',
			['ojo impostor']
		);

		restoreDadEyeLayers(
			blackChar,
			'black right',
			['ojo impostor']
		);

		restoreDadEyeLayers(
			blackChar,
			'black idle remast',
			['ojo impostor']
		);

		restoreDadEyeLayers(
			blackChar,
			'black expo',
			['ojo impostor']
		);

		restoreDadEyeLayers(
			blackChar,
			'black kill',
			['ojo impostor']
		);

		restoreDadEyeLayers(
			blackChar,
			'black expo/black kill',
			['ojo impostor']
		);

		restoreDadEyeLayers(
			blackChar,
			'black kill 2',
			['ojo impostor']
		);
	}

	if (
		blackDkChar != null &&
		blackDkChar.library != null
	)
	{
		restoreDadEyeLayers(
			blackDkChar,
			'Símbolo 30',
			['Capa 17','Símbolo 25']
		);

		restoreDadEyeLayers(
			blackDkChar,
			'Símbolo 36',
			['Símbolo 25']
		);

		restoreDadEyeLayers(
			blackDkChar,
			'BLACK RIGHT',
			['Símbolo 25']
		);

		restoreDadEyeLayers(
			blackDkChar,
			'Símbolo 31',
			['Símbolo 25']
		);

		restoreDadEyeLayers(
			blackDkChar,
			'Símbolo 35',
			['Símbolo 25']
		);
	}
}

function restoreDadEyeLayers(
	sprite:FunkinSprite,
	symbolName:String,
	hiddenLayers:Array<String>
):Void
{
	if (
		sprite == null ||
		sprite.library == null
	)
		return;

	var symbol =
		sprite.library.getSymbol(symbolName);

	if (
		symbol == null ||
		symbol.timeline == null
	)
		return;

	for (layer in symbol.timeline.layers)
	{
		if (
			hiddenLayers.indexOf(layer.name) < 0
		)
			continue;

		layer.forEachFrame(function(frame)
		{
			if (
				frame == null ||
				frame.elements == null
			)
				return;

			for (element in frame.elements)
				element.visible = true;
		});
	}
}

function syncDadEyeOverlay():Void
{
	if (dad == null)
		return;

	var wanted:FunkinSprite = null;
	var wantedCharacter:String = '';

	switch (dad.curCharacter)
	{
		case 'black':
			wanted = dadEyeBlack;
			wantedCharacter = 'black';

		case 'blackdk':
			wanted = dadEyeBlackDk;
			wantedCharacter = 'blackdk';

		default:
			if (dadEyeBlack != null)
			{
				dadEyeBlack.visible = false;
				dadEyeBlack.active = false;
			}

			if (dadEyeBlackDk != null)
			{
				dadEyeBlackDk.visible = false;
				dadEyeBlackDk.active = false;
			}

			dadEyeOverlay = null;
			dadEyeCharacter = '';
			dadEyeAnim = '';

			return;
	}

	if (wanted == null)
		return;

	if (dadEyeOverlay != wanted)
	{
		if (dadEyeOverlay != null)
		{
			dadEyeOverlay.visible = false;
			dadEyeOverlay.active = false;
		}

		dadEyeOverlay = wanted;
		dadEyeCharacter = wantedCharacter;
		dadEyeAnim = '';
	}

	if (
		!dad.exists ||
		!dad.visible ||
		dad.alpha <= 0 ||
		dad.isAnimNull()
	)
	{
		dadEyeOverlay.visible = false;
		dadEyeOverlay.active = false;
		return;
	}

	var currentAnim:String =
		dad.getAnimName();

	if (
		currentAnim == '' ||
		!dadEyeOverlay.hasAnim(currentAnim)
	)
	{
		dadEyeOverlay.visible = false;
		dadEyeOverlay.active = false;
		return;
	}

	if (dadEyeAnim != currentAnim)
	{
		dadEyeOverlay.playAnim(
			currentAnim,
			true,
			false
		);

		dadEyeAnim = currentAnim;
	}

	var frameCount:Int =
		dadEyeOverlay.getAnimNumFrames();

	if (frameCount > 0)
	{
		var frame:Int =
			dad.animCurFrame;

		if (frame < 0)
			frame = 0;

		if (frame >= frameCount)
			frame =
				frameCount - 1;

		dadEyeOverlay.animCurFrame =
			frame;
	}

	dadEyeOverlay.x = dad.x;
	dadEyeOverlay.y = dad.y;

	dadEyeOverlay.scale.set(
		dad.scale.x,
		dad.scale.y
	);

	dadEyeOverlay.baseScale.set(
		dad.baseScale.x,
		dad.baseScale.y
	);

	dadEyeOverlay.origin.set(
		dad.origin.x,
		dad.origin.y
	);

	dadEyeOverlay.offset.set(
		dad.offset.x,
		dad.offset.y
	);

	dadEyeOverlay.spriteOffset.set(
		dad.spriteOffset.x,
		dad.spriteOffset.y
	);

	dadEyeOverlay.animOffset.set(
		dad.animOffset.x,
		dad.animOffset.y
	);

	dadEyeOverlay.angle =
		dad.angle;

	dadEyeOverlay.skew.set(
		dad.skew.x,
		dad.skew.y
	);

	dadEyeOverlay.flipX =
		dad.flipX;

	dadEyeOverlay.flipY =
		dad.flipY;

	dadEyeOverlay.alpha =
		dad.alpha;

	dadEyeOverlay.color =
		dad.color;

	dadEyeOverlay.blend =
		dad.blend;

	dadEyeOverlay.scrollFactor.set(
		dad.scrollFactor.x,
		dad.scrollFactor.y
	);

	dadEyeOverlay.antialiasing =
		dad.antialiasing;

	dadEyeOverlay.zIndex =
		dad.zIndex + 0.01;

	dadEyeOverlay.shader = null;
	dadEyeOverlay.useRenderTexture = false;
	dadEyeOverlay.cameras = [camGame];

	dadEyeOverlay.colorTransform.redMultiplier =
		dad.colorTransform.redMultiplier;

	dadEyeOverlay.colorTransform.greenMultiplier =
		dad.colorTransform.greenMultiplier;

	dadEyeOverlay.colorTransform.blueMultiplier =
		dad.colorTransform.blueMultiplier;

	dadEyeOverlay.colorTransform.alphaMultiplier =
		dad.colorTransform.alphaMultiplier;

	dadEyeOverlay.colorTransform.redOffset =
		dad.colorTransform.redOffset;

	dadEyeOverlay.colorTransform.greenOffset =
		dad.colorTransform.greenOffset;

	dadEyeOverlay.colorTransform.blueOffset =
		dad.colorTransform.blueOffset;

	dadEyeOverlay.colorTransform.alphaOffset =
		dad.colorTransform.alphaOffset;

	dadEyeOverlay.active = true;
	dadEyeOverlay.visible = true;
}

function refreshDadCharacter():Void
{
	if (dad == null)
		return;

	var shaderEnabled:Bool =
		ClientPrefs.shaders &&
		!isRetro;

	if (dadRenderOwner != dad)
	{
		if (dadRenderOwner != null)
		{
			dadRenderOwner.shader = null;
			dadRenderOwner.useRenderTexture =
				false;
		}

		dadRenderOwner = dad;
		dadEyeHiddenOwner = null;
	}

	if (dadRim != null)
	{
		dadRim.attachedSprite = dad;

		dadRim.layers[0].angle = 170;
		dadRim.layers[1].angle = 88;
	}

	dad.useRenderTexture =
		shaderEnabled &&
		hasBfSkin;

	dad.shader = (
		shaderEnabled &&
		hasBfSkin &&
		dadRim != null
		? dadRim
		: null
	);

	hideOriginalDadEye();
	syncDadEyeOverlay();
}

function turnShader(?should = false)
{
	boyfriend.shader = (
		should &&
		hasBfSkin &&
		boyfriend.getFlag('backlit') != true
		? bfRim
		: null
	);

	if (boyfriend != null)
	{
		boyfriend.useRenderTexture = (
			should &&
			hasBfSkin &&
			bfRim != null
		);
	}

	if (hasPet)
	{
		pet.shader = (
			should &&
			petRim != null
			? petRim
			: null
		);

		pet.useRenderTexture = (
			should &&
			petRim != null
		);
	}

	if (dad != null)
	{
		if (dadRim != null)
			dadRim.attachedSprite = dad;

		dad.shader = (
			should &&
			hasBfSkin &&
			dadRim != null
			? dadRim
			: null
		);

		dad.useRenderTexture = (
			should &&
			hasBfSkin &&
			dadRim != null
		);

		dadRenderOwner = dad;
	}

	if (gf != null)
	{
		gf.shader = (
			should &&
			hasGfSkin &&
			gfRim != null
			? gfRim
			: null
		);

		gf.useRenderTexture = (
			should &&
			hasGfSkin &&
			gfRim != null
		);
	}

	syncDadEyeOverlay();
}

function onBeatHit()
{
	if (curBeat % 4 == 0)
	{
		if (defeatBopTween != null)
			defeatBopTween.cancel();

		defeatthing.alpha = (
			ClientPrefs.flashing
			? .5
			: .45
		);

		defeatBopTween =
			FlxTween.tween(
				defeatthing,
				{alpha:.4},
				ClientPrefs.flashing
					? .8
					: .4,
				{
					ease:FlxEase.bounceOut
				}
			);

		if (ClientPrefs.flashing)
		{
			if (defeatScaleTween != null)
				defeatScaleTween.cancel();

			defeatthing.scale.set(5.5,5);

			defeatScaleTween =
				FlxTween.tween(
					defeatthing.scale,
					{x:4,y:4},
					.8,
					{
						ease:FlxEase.sineOut
					}
				);
		}

		if (edgeglow1.alpha > .01)
		{
			if (glowTween1 != null)
				glowTween1.cancel();

			if (glowTween2 != null)
				glowTween2.cancel();

			edgeglow1.alpha =
				edgeglow2.alpha =
					ClientPrefs.flashing
					? 1
					: .7;

			glowTween1 =
				FlxTween.tween(
					edgeglow1,
					{alpha:.6},
					.35,
					{
						ease:FlxEase.bounceOut
					}
				);

			glowTween2 =
				FlxTween.tween(
					edgeglow2,
					{alpha:.6},
					.35,
					{
						ease:FlxEase.bounceOut
					}
				);
		}

		if (ClientPrefs.shaders)
		{
			if (bfRim != null)
			{
				if (rimBeatTweenBF != null)
					rimBeatTweenBF.cancel();

				bfRim.strength =
					rimBeatStrength;

				rimBeatTweenBF =
					FlxTween.tween(
						bfRim,
						{
							strength:
								rimNormalStrength
						},
						.25,
						{
							ease:
								FlxEase.quadOut
						}
					);
			}

			if (gfRim != null)
			{
				if (rimBeatTweenGF != null)
					rimBeatTweenGF.cancel();

				gfRim.strength =
					rimBeatStrength;

				rimBeatTweenGF =
					FlxTween.tween(
						gfRim,
						{
							strength:
								rimNormalStrength
						},
						.25,
						{
							ease:
								FlxEase.quadOut
						}
					);
			}

			if (petRim != null)
			{
				if (rimBeatTweenPet != null)
					rimBeatTweenPet.cancel();

				petRim.strength =
					rimBeatStrength;

				rimBeatTweenPet =
					FlxTween.tween(
						petRim,
						{
							strength:
								rimNormalStrength
						},
						.25,
						{
							ease:
								FlxEase.quadOut
						}
					);
			}

			if (dadRim != null)
			{
				if (rimBeatTweenDad != null)
					rimBeatTweenDad.cancel();

				dadRim.strength =
					rimBeatStrength;

				rimBeatTweenDad =
					FlxTween.tween(
						dadRim,
						{
							strength:
								rimNormalStrength
						},
						.25,
						{
							ease:
								FlxEase.quadOut
						}
					);
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

	if (
		boyfriend.gameoverCharacter ==
			'bf-dead' ||
		boyfriend.gameoverCharacter ==
			'bf-defeat-dead'
	)
	{
		var suffix:String =
			isRetro
			? '-retro'
			: '';

		if (FlxG.random.bool(10))
		{
			boyfriend.gameoverCharacter =
				'bf-defeat-dead-balls$suffix';

			boyfriend.gameoverInitialDeathSound =
				'stage/defeat_kill_ballz_sfx$suffix';
		}
		else if (
			boyfriend.gameoverCharacter !=
				'bf-defeat-dead'
		)
		{
			boyfriend.gameoverCharacter =
				'bf-defeat-dead$suffix';

			boyfriend.gameoverInitialDeathSound =
				'stage/defeat_kill_sfx$suffix';
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
	if (
		boyfriend.gameoverCharacter?.
			endsWith('-retro')
	)
	{
		FlxG.camera.bgColor =
			0xFF1A182E;

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

	boyfriend.stunned =
		boyfriend.skipDance = true;

	isCameraOnForcedPos = true;
	inCutscene = true;
	canPause = false;
	camZooming = false;

	audio.playerVolume = 0;
	audio.opponentVolume = 0;

	FlxTween.tween(
		audio.inst,
		{volume:0},
		1.5,
		{
			ease:FlxEase.expoOut
		}
	);

	camFollow.setPosition(550,500);

	FlxTween.tween(
		camHUD,
		{alpha:0},
		.7,
		{
			ease:FlxEase.quadInOut
		}
	);

	FlxTween.tween(
		FlxG.camera,
		{zoom:.65},
		1,
		{
			ease:FlxEase.quadInOut
		}
	);

	changeCharacter("black", 1);
	dad.playAnim(
		'kill',
		true
	);

	dad.specialAnim = true;

	dad.animation.onFinish.add(
		(animName) ->
		{
			if (animName == 'kill')
			{
				dad.animation.play(
					'kill2',
					true
				);

				dad.specialAnim = true;
			}
			else if (animName == 'kill2')
			{
				playingCutscene = true;
				doDeathCheck(true);
			}
		}
	);

	dad.animation.onFrameChange.add(
		(animName,frameNumber,frameIndex) ->
		{
			if (
				animName == 'kill' &&
				frameNumber == 6
			)
			{
				FlxG.sound.play(
					Paths.sound(
						'stage/defeat_prekill_sfx'
					)
				);
			}
		}
	);
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

	boyfriend.stunned =
		boyfriend.skipDance = true;

	canPause = false;
	camZooming = false;

	audio.playerVolume = 0;
	audio.opponentVolume = 0;
	audio.inst.volume = 0;

	camFollow.setPosition(550,500);

	FlxTween.tween(
		camHUD,
		{alpha:0},
		.7,
		{
			ease:FlxEase.quadInOut
		}
	);

	FlxTween.tween(
		FlxG.camera,
		{zoom:1.2},
		1.5,
		{
			ease:FlxEase.circOut
		}
	);

	FlxG.sound.play(
		Paths.sound(
			'stage/defeat_prekill_sfx_v3'
		)
	);

	dad.playAnim(
		'death',
		true
	);

	dad.specialAnim = true;

	dad.animation.onFinish.add(
		(animName) ->
		{
			if (animName == 'death')
			{
				snapCamToPos(
					boyfriend.getGraphicMidpoint().x - 23,
					boyfriend.getGraphicMidpoint().y - 20,
					false
				);

				playingCutscene = true;
				doDeathCheck(true);
			}
		}
	);
}

var prevAfterimages:Bool;
var prevScoreColor:FlxColor;

function onEvent(
	eventName,
	value1,
	value2
)
{
	switch (eventName)
	{
		case 'Defeat Retro':
			var charType:Int =
				Std.parseInt(value1);

			if (Math.isNaN(charType))
				charType = 0;

			switch (charType)
			{
				case 0:
					prevAfterimages =
						boyfriend.ghostsEnabled;

					prevScoreColor =
						scoreTxt.color;

					bf =
						boyfriend.curCharacter;

					if (defeatRetro != null)
						changeCharacter(
							defeatRetro,
							0
						);

					boyfriend.ghostsEnabled =
						false;

					for (i in [
						bg,
						defeattext,
						bodies,
						bodies2,
						bodiesfront,
						lightoverlay,
						subtract,
						edgeglow2,
						edgeglow1,
						iconP1,
						iconP2
					])
						i.alpha = 0.001;

					old_defeat.alpha = 1;
					defeatthing.alpha = 0.001;

					turnShader(false);

					scoreTxt.size = 16;
					scoreTxt.color =
						FlxColor.WHITE;

					if (hasPet)
						pet.visible = false;

					isRetro = true;
					refreshDadCharacter();

				case 1:
					changeCharacter(
						bf,
						0
					);

					changeCharacter(
						'black',
						1
					);

					checkStageFlag(
						boyfriend
					);

					boyfriend.ghostsEnabled =
						prevAfterimages;

					for (i in [
						bg,
						defeattext,
						bodies,
						bodies2,
						bodiesfront,
						lightoverlay,
						subtract,
						edgeglow2,
						edgeglow1
					])
						i.alpha = 1;

					old_defeat.alpha = 0.001;
					defeatthing.alpha = 1;

					scoreTxt.color =
						prevScoreColor;

					scoreTxt.size = 20;

					turnShader(true);

					if (hasPet)
						pet.visible = true;

					isRetro = false;
					refreshDadCharacter();
			}

		case 'Defeat Fade':
			var charType:Int =
				Std.parseInt(value1);

			if (Math.isNaN(charType))
				charType = 0;

			switch (charType)
			{
				case 0:
					if (
						boyfriend.curCharacter ==
							'bf-defeat-normal'
					)
					{
						changeCharacter(
							'bf-defeat-scared',
							0
						);
					}

					FlxTween.tween(
						bg,
						{alpha:1},
						.7,
						{
							ease:
								FlxEase.quadInOut
						}
					);

					FlxTween.tween(
						bodies,
						{alpha:1},
						.7,
						{
							ease:
								FlxEase.quadInOut
						}
					);

					FlxTween.tween(
						bodies2,
						{alpha:1},
						.7,
						{
							ease:
								FlxEase.quadInOut
						}
					);

					FlxTween.tween(
						bodiesfront,
						{alpha:1},
						.7,
						{
							ease:
								FlxEase.quadInOut
						}
					);

					FlxTween.tween(
						edgeglow1,
						{alpha:.5},
						.7,
						{
							ease:
								FlxEase.quadInOut
						}
					);

					FlxTween.tween(
						edgeglow2,
						{alpha:.5},
						.7,
						{
							ease:
								FlxEase.quadInOut
						}
					);

					FlxTween.tween(
						subtract,
						{alpha:1},
						.7,
						{
							ease:
								FlxEase.quadInOut
						}
					);

					FlxTween.tween(
						lightoverlay,
						{alpha:.7},
						.7,
						{
							ease:
								FlxEase.quadInOut
						}
					);

				case 1:
					FlxTween.tween(
						bg,
						{alpha:0},
						.7,
						{
							ease:
								FlxEase.quadInOut
						}
					);

					FlxTween.tween(
						bodies,
						{alpha:0},
						.7,
						{
							ease:
								FlxEase.quadInOut
						}
					);

					FlxTween.tween(
						bodies2,
						{alpha:0},
						.7,
						{
							ease:
								FlxEase.quadInOut
						}
					);

					FlxTween.tween(
						bodiesfront,
						{alpha:0},
						.7,
						{
							ease:
								FlxEase.quadInOut
						}
					);

					FlxTween.tween(
						edgeglow1,
						{alpha:0},
						.7,
						{
							ease:
								FlxEase.quadInOut
						}
					);

					FlxTween.tween(
						edgeglow2,
						{alpha:0},
						.7,
						{
							ease:
								FlxEase.quadInOut
						}
					);

					FlxTween.tween(
						subtract,
						{alpha:0},
						.7,
						{
							ease:
								FlxEase.quadInOut
						}
					);

					FlxTween.tween(
						lightoverlay,
						{alpha:0},
						.7,
						{
							ease:
								FlxEase.quadInOut
						}
					);
			}
	}
}

function onUpdatePost(elapsed:Float)
{
	refreshDadCharacter();

	if (!isRetro)
	{
		playHUD.scoreTxt.text =
			songMisses +
			'/' +
			PlayState.totalMisses +
			' ' +
			Lang.str('misses') +
			' | ' +
			Lang.str('rank') +
			': ' +
			Lang.str(
				'AWARDNAME_no_miss_finale'
			) +
			'.';

		playHUD.scoreTxt.color =
			FlxColor.RED;
	}
}

function onPopUpScorePost(note,rating)
{
	if (ratingGraphic != null)
	{
		ratingGraphic.color =
			scoreTxt.color;

		ratingGraphic.x =
			(FlxG.width / 2) -
			(ratingGraphic.width / 2) +
			comboX;

		ratingGraphic.y =
			ClientPrefs.downScroll
			? (
				FlxG.height -
				ratingGraphic.height -
				50
			)
			: 55;
	}

	if (
		playHUD.ratingNumGroup != null &&
		playHUD.ratingNumGroup.members != null
	)
	{
		var activeMembers = [
			for (member in
				playHUD.ratingNumGroup.members)
				if (
					member != null &&
					member.exists &&
					member.alive
				)
					member
		];

		var totalWidth = 0;

		for (m in activeMembers)
		{
			totalWidth += (
				(m.frameWidth +
				combosPadding) *
				playHUD.combosScale
			);
		}

		var xOffset =
			(FlxG.width - totalWidth) / 2;

		for (numScore in activeMembers)
			numScore.color =
				scoreTxt.color;
	}

	return Function_Continue;
}

function onDestroy()
{
	restoreOriginalDadEye();

	if (dadEyeBlack != null)
	{
		dadEyeBlack.destroy();
		dadEyeBlack = null;
	}

	if (dadEyeBlackDk != null)
	{
		dadEyeBlackDk.destroy();
		dadEyeBlackDk = null;
	}

	dadEyeOverlay = null;
	dadRenderOwner = null;
	dadEyeHiddenOwner = null;
	dadEyeCharacter = '';
	dadEyeAnim = '';
}