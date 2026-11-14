import funkin.game.shaders.ExtraDropShadowShader;
import funkin.states.substates.PauseSubState;
import flixel.tweens.FlxEase;
import animate.FlxAnimateFrames;

var ext = 'stages/void/finale/';
var defeatFinaleStuff:FlxSpriteGroup = new FlxSpriteGroup();
var finaleBGStuff:FlxSpriteGroup = new FlxSpriteGroup();
var finaleFGStuff:FlxSpriteGroup = new FlxSpriteGroup();
var finaleFlashbackStuff:FlxSprite;
var finaleDarkFG:FlxSprite;
var finaleLight:FlxSprite;
var lightoverlay:FlxSprite;
var finaleMode:Bool = false;
var bars:FlxSpriteGroup;
var rimNormalStrength:Float = .85;
var finaleDropRimApplied:Bool = false;
var finalemDestroying:Bool = false;


var dadEyeBlackP:FunkinSprite = null;
var dadEyeBlackPInitFailed:Bool = false;
var dadEyeBlackPAnim:String = '';
var dadEyeBlackPHiddenOwner:Dynamic = null;
var dadEyeBlackPVisibilityBackup:Array<Dynamic> = [];
var finaleEyeDebug:FlxText = null;
var finaleEyeDebugStatus:String = 'waiting for blackparasite';
var finaleEyeDebugMaskCount:Int = 0;
var finaleEyeDebugHiddenCount:Int = 0;
var finaleEyeDebugError:String = '';

function onLoad()
{
	bars = new FlxSpriteGroup();
	bars.cameras = [camHUD];
	add(bars);
	
	for (i in 0...2) // maybe this is doin too much idk
	{
		var bar = new FlxSprite().makeScaledGraphic(FlxG.width + 3, 90, FlxColor.BLACK);
		bar.y = i == 1 ? 630 : 0;
		bars.add(bar);
	}
	
	finaleFlashbackStuff = new FlxSprite(-290, -160);
	finaleFlashbackStuff.frames = Paths.getSparrowAtlas(ext + 'finaleFlashback');
	finaleFlashbackStuff.animation.addByPrefix('moog', 'finaleFlashback moog', 24, false);
	finaleFlashbackStuff.animation.addByPrefix('toog', 'finaleFlashback toog', 24, false);
	finaleFlashbackStuff.animation.addByPrefix('doog', 'finaleFlashback doog', 24, false);
	finaleFlashbackStuff.animation.play('moog');
	finaleFlashbackStuff.setGraphicSize(Std.int(finaleFlashbackStuff.width * 1.6));
	finaleFlashbackStuff.alpha = 0.001;
	finaleFlashbackStuff.scrollFactor.set(); // this matters !??
	
	var defeatthing:FlxSprite = new FlxSprite(-400, 2000, Paths.image('stages/void/finale/defeat'));
	// defeatthing.frames = Paths.getSparrowAtlas('stages/void/defeat');
	// defeatthing.animation.addByPrefix('bop', 'defeat', 24, false);
	// defeatthing.animation.play('bop');
	defeatthing.setGraphicSize(Std.int(defeatthing.width * 1.3));
	defeatthing.scrollFactor.set(0.8, 0.8);
	defeatFinaleStuff.add(defeatthing);
	
	var mainoverlayDK:FlxSprite = new FlxSprite(250, 475).loadGraphic(Paths.image('stages/void/defeatfnf'));
	mainoverlayDK.setGraphicSize(Std.int(mainoverlayDK.width * 4));
	mainoverlayDK.updateHitbox();
	mainoverlayDK.alpha = 0.0001;
	defeatFinaleStuff.add(mainoverlayDK);
	
	var bg0:FlxSprite = new FlxSprite(-600, -400).makeScaledGraphic(3000, 2000, 0xFF120B17);
	
	var bgScale = 1.3;
	
	var bg1:FlxSprite = new FlxSprite(800, -270).loadFromSheet(ext + 'props', 'dead');
	bg1.scrollFactor.set(0.8, 0.8);
	bg1.scale.set(bgScale, bgScale);
	
	var bg2:FlxSprite = new FlxSprite(-790, -530).loadFromSheet(ext + 'props', 'bg');
	bg2.updateHitbox();
	bg2.scrollFactor.set(0.9, 0.9);
	bg2.scale.set(bgScale, bgScale);

	
	var bg3:FlxSprite = new FlxSprite(370, 1200).loadFromSheet(ext + 'props', 'splat');
	bg3.updateHitbox();
	bg3.scale.set(bgScale, bgScale);
	
	var bg4:FlxSprite = new FlxSprite(990, -380).loadFromSheet(ext + 'props', 'lamp');
	bg4.updateHitbox();
	bg4.scale.set(bgScale, bgScale);
	
	var bg5:FlxSprite = new FlxSprite(-750, 160).loadFromSheet(ext + 'props', 'fore');
	bg5.updateHitbox();
	bg5.scale.set(bgScale, bgScale);
	
	var dark:FlxSprite = new FlxSprite(-950, -160).loadFromSheet(ext + 'props', 'dark');
	dark.scale.set(1.3, 1.3);
	
	finaleLight = new FlxSprite(-230, -200);
	finaleLight.frames = Paths.getSparrowAtlas(ext + 'light');
	finaleLight.animation.addByPrefix('bop', 'light', 24, false);
	finaleLight.animation.play('bop');
	finaleLight.setGraphicSize(Std.int(finaleLight.width * 4)); // GRRR
	finaleLight.updateHitbox();
	finaleLight.setGraphicSize(Std.int(finaleLight.width * 1.1));
	finaleLight.scrollFactor.set(0.8, 0.8);
	finaleLight.blend = BlendMode.ADD;
	
	finaleBGStuff.add(bg0);
	finaleBGStuff.add(bg1);
	finaleBGStuff.add(bg2);
	finaleFGStuff.add(bg3);
	finaleFGStuff.add(bg4);
	finaleFGStuff.add(bg5);
	if (!ClientPrefs.lowQuality)finaleFGStuff.add(dark);
	finaleFGStuff.add(finaleLight);
	
	finaleBGStuff.alpha = 0.001;
	finaleFGStuff.alpha = 0.001;
	
	add(defeatFinaleStuff);
	add(finaleBGStuff);
}

function onCreatePost()
{
	addCharacterToList('blackparasite', 1);
	addCharacterToList('black', 1);
	
	camHUD.alpha = 0.001;
	playHUD.iconP1.visible = false;
	playHUD.iconP2.visible = false;
	playHUD.healthBar.visible = false;
	playHUD.timeBar.visible = false;
	playHUD.timeTxt.visible = false;
	canFollow = false;
	camSpecialThing([750, 800], [750, 800], 0.8);
	
	add(finaleFGStuff);
	if (!ClientPrefs.lowQuality) add(finaleFlashbackStuff);
	
	lightoverlay = new FlxSprite(-550, 250).loadGraphic(Paths.image('stages/void/iluminao omaga'));
	lightoverlay.scale.set(4, 4);
	lightoverlay.updateHitbox();
	lightoverlay.blend = BlendMode.ADD;
	lightoverlay.antialiasing = ClientPrefs.globalAntialiasing;
	add(lightoverlay);
	
	finaleDarkFG = new FlxSprite(-1000, -900).makeScaledGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
	finaleDarkFG.scrollFactor.set();
	add(finaleDarkFG);
	
	dadGroup.zIndex = 1;
	finaleFGStuff.zIndex = 2;
	finaleFlashbackStuff.zIndex = 3;
	lightoverlay.zIndex = 4;
	finaleDarkFG.zIndex = 5;
	
	opponentStrums.visible = false;
	modManager.setValue("alpha", 1, 1);
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
			96,24,.01,.4
		);

		if (hasBfSkin && boyfriend.getFlag('backlit') != true)
		{
			bfRim = blackRimlightBase;
			bfRim.attachedSprite = boyfriend;
			boyfriend.useRenderTexture = true;
		}

		if (hasPet)
		{
			petRim =
				new funkin.game.shaders.ExtraDropShadowShader()
				.copyFrom(blackRimlightBase);

			petRim.attachedSprite = pet;
			pet.useRenderTexture = true;
		}

		dadRim =
			new funkin.game.shaders.ExtraDropShadowShader()
			.copyFrom(blackRimlightBase);

		dadRim.attachedSprite = dad;
		dad.shader = dadRim;
		dad.useRenderTexture = true;

		dadRim.layers[0].angle = 170;
		dadRim.layers[1].angle = 88;

	}
	PauseSubState.songName = 'blackPause';
	createFinaleEyeDebug();
}


function createInitialRimlightCopy()
{
	var rimCopy:ExtraDropShadowShader = new funkin.game.shaders.ExtraDropShadowShader();
	rimCopy.threshold = .05;
	rimCopy.strength = rimNormalStrength;
	rimCopy.setColorMatrix([
		.42,.5,-.18,0,-46,
		-.27,.69,-.16,0,-22,
		.44,-.33,.88,0,-68,
		0,0,0,1,0
	]);
	rimCopy.addLayer([
		.73,.5,.96,0,195,
		.29,.39,-.48,0,62,
		-.08,.18,.39,0,77,
		0,0,0,1,0
	],10,14,.01);
	rimCopy.addLayer(
		rimCopy.addLayer([
			.92,.59,.39,0,6,
			-.21,.49,.1,0,-19,
			-.18,.19,.42,0,-25,
			0,0,0,1,0
		],12,40,.01,.4).colorMatrix,
		96,24,.01,.4
	);
	return rimCopy;
}

function applyInitialRimlightCopies()
{
	if (!ClientPrefs.shaders || finaleDropRimApplied) return;
	finaleDropRimApplied = true;

	var initialRimCopy:ExtraDropShadowShader = createInitialRimlightCopy();

	if (hasBfSkin && boyfriend.getFlag('backlit') != true)
	{
		bfRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(initialRimCopy);
		bfRim.attachedSprite = boyfriend;
		boyfriend.useRenderTexture = true;
	}

	if (hasPet)
	{
		petRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(initialRimCopy);
		petRim.attachedSprite = pet;
		pet.useRenderTexture = true;
	}

	dadRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(initialRimCopy);
	dadRim.attachedSprite = dad;
	dad.shader = dadRim;
	dad.useRenderTexture = true;
	dadRim.layers[0].angle = 170;
	dadRim.layers[1].angle = 88;
}


function isBlackParasiteTarget(sprite:FunkinSprite):Bool
{
	if (sprite == null)
		return false;
	try
	{
		if (!sprite.exists || !sprite.alive)
			return false;
		return Std.string(sprite.curCharacter).toLowerCase() == 'blackparasite';
	}
	catch (e:Dynamic)
	{
		return false;
	}
}

function getBlackParasiteCharacter():FunkinSprite
{
	return isBlackParasiteTarget(dad) ? dad : null;
}

function maskBlackParasiteEyeRoot(overlay:FunkinSprite, symbolName:String, eyeLayerIndices:Array<Int>):Int
{
	if (overlay == null || overlay.library == null)
		return 0;
	var symbol = overlay.library.getSymbol(symbolName);
	if (symbol == null || symbol.timeline == null)
		return 0;
	var matched:Int = 0;
	for (layerIndex in 0...symbol.timeline.layers.length)
	{
		var layer = symbol.timeline.layers[layerIndex];
		var keepLayer:Bool = eyeLayerIndices.indexOf(layerIndex) >= 0;
		if (keepLayer)
			matched++;
		layer.forEachFrame(function(frame)
		{
			if (frame == null || frame.elements == null)
				return;
			var changed:Bool = false;
			for (element in frame.elements)
			{
				if (element.visible != keepLayer)
					changed = true;
				element.visible = keepLayer;
			}
			if (changed)
				try { frame.setDirty(); } catch (e:Dynamic) {}
		});
	}
	return matched;
}

function ensureBlackParasiteEyeOverlay():Void
{
	if (finalemDestroying || (dadEyeBlackP != null && dadEyeBlackP.exists))
		return;
	if (dadEyeBlackP != null && !dadEyeBlackP.exists)
		dadEyeBlackP = null;
	if (dadEyeBlackPInitFailed || !isBlackParasiteTarget(dad))
		return;
	if (dadGroup == null || dadGroup.map == null)
	{
		finaleEyeDebugStatus = 'dadGroup/map unavailable';
		return;
	}

	var blackPTemplate:FunkinSprite = null;
	try { blackPTemplate = dadGroup.map.get('blackparasite'); } catch (e:Dynamic) {}
	if (blackPTemplate == null || blackPTemplate.library == null || blackPTemplate.animations == null)
	{
		finaleEyeDebugStatus = 'blackparasite template missing';
		return;
	}

	var overlay:FunkinSprite = null;
	try
	{
		var atlasPath:String = Paths.getPath(
			'images/${ext}blackp_eye_overlay',
			null,
			PathsTestMode.LOOSE
		);
		if (atlasPath == null || atlasPath == '')
			throw 'overlay atlas path is empty';

		var eyeFrames:FlxAnimateFrames = FlxAnimateFrames.fromAnimate(
			atlasPath,
			null,
			null,
			'dadEyeUnique_blackparasite_finalem_debug',
			true,
			{cacheOnLoad:false}
		);
		if (eyeFrames == null)
			throw 'FlxAnimateFrames.fromAnimate returned null';

		overlay = new FunkinSprite(0, 0);
		overlay.frames = eyeFrames;
		var animationCount:Int = 0;
		for (anim in blackPTemplate.animations)
		{
			if (anim == null)
				continue;
			var animName:String = '' + anim.anim;
			var sourceName:String = '' + anim.name;
			var fps:Int = anim.fps;
			var looping:Bool = !!anim.loop;
			var indices:Array<Int> = anim.indices ?? [];
			var flipX:Bool = anim.flipX ?? false;
			var flipY:Bool = anim.flipY ?? false;
			if (indices.length > 0)
				overlay.addAnimByIndices(animName, sourceName, indices, fps, looping, flipX, flipY);
			else
				overlay.addAnimByPrefix(animName, sourceName, fps, looping, flipX, flipY);
			animationCount++;
		}
		if (animationCount == 0)
			throw 'blackparasite template has no animations';

		var matched:Int = 0;
		matched += maskBlackParasiteEyeRoot(overlay, 'abomination black idle', [4]);
		matched += maskBlackParasiteEyeRoot(overlay, 'BLACK UP', [2, 3]);
		matched += maskBlackParasiteEyeRoot(overlay, 'black down', [0]);
		matched += maskBlackParasiteEyeRoot(overlay, 'right ske', [3, 4]);
		matched += maskBlackParasiteEyeRoot(overlay, 'left ', [2, 12]);
		finaleEyeDebugMaskCount = matched;
		if (matched != 8)
			throw 'unexpected eye layer count: ' + matched + ' (expected 8)';

		overlay.scalableOffsets = blackPTemplate.scalableOffsets;
		overlay.rotatableOffsets = blackPTemplate.rotatableOffsets;
		overlay.skewableOffsets = blackPTemplate.skewableOffsets;
		overlay.baseFlipX = blackPTemplate.baseFlipX;
		overlay.baseFlipY = blackPTemplate.baseFlipY;
		overlay.antialiasing = blackPTemplate.antialiasing;
		overlay.shader = null;
		overlay.useRenderTexture = false;
		overlay.cameras = [camGame];
		overlay.scrollFactor.set(blackPTemplate.scrollFactor.x, blackPTemplate.scrollFactor.y);
		overlay.zIndex = dad.zIndex + 0.01;
		overlay.active = false;
		overlay.visible = false;

		dadGroup.add(overlay);
		refreshZ();
		dadEyeBlackP = overlay;
		dadEyeBlackPInitFailed = false;
		finaleEyeDebugStatus = 'overlay created';
		finaleEyeDebugError = '';
	}
	catch (e:Dynamic)
	{
		dadEyeBlackPInitFailed = true;
		finaleEyeDebugStatus = 'overlay creation failed';
		finaleEyeDebugError = Std.string(e);
		if (overlay != null)
		{
			try { overlay.visible = false; overlay.active = false; } catch (ignored:Dynamic) {}
			try { overlay.destroy(); } catch (ignored:Dynamic) {}
		}
	}
}

function saveBlackParasiteEyeVisibility(element:Dynamic, frame:Dynamic):Void
{
	for (entry in dadEyeBlackPVisibilityBackup)
	{
		if (entry != null && entry.element == element)
			return;
	}
	dadEyeBlackPVisibilityBackup.push({element:element, visible:element.visible, frame:frame});
}

function hideBlackParasiteEyeRoot(source:FunkinSprite, symbolName:String, eyeLayerIndices:Array<Int>):Int
{
	if (source == null || source.library == null)
		return 0;
	var symbol = source.library.getSymbol(symbolName);
	if (symbol == null || symbol.timeline == null)
		return 0;
	var matched:Int = 0;
	for (layerIndex in 0...symbol.timeline.layers.length)
	{
		if (eyeLayerIndices.indexOf(layerIndex) < 0)
			continue;
		var layer = symbol.timeline.layers[layerIndex];
		layer.forEachFrame(function(frame)
		{
			if (frame == null || frame.elements == null)
				return;
			var changed:Bool = false;
			for (element in frame.elements)
			{
				saveBlackParasiteEyeVisibility(element, frame);
				matched++;
				if (element.visible)
				{
					element.visible = false;
					changed = true;
				}
			}
			if (changed)
				try { frame.setDirty(); } catch (e:Dynamic) {}
		});
	}
	return matched;
}

function disableBlackParasiteRimlight(source:FunkinSprite):Void
{
	if (source == null)
		return;
	try
	{
		if (dadRim != null && dadRim.attachedSprite == source)
			dadRim.attachedSprite = null;
	}
	catch (e:Dynamic) {}
	try
	{
		if (dadRim != null && source.shader == dadRim)
			source.shader = null;
	}
	catch (e:Dynamic) {}
	try { source.useRenderTexture = false; } catch (e:Dynamic) {}
}

function syncBlackParasiteRimlight(source:FunkinSprite):Void
{
	if (source == null || dadRim == null)
		return;
	var previous:FunkinSprite = null;
	try { previous = dadRim.attachedSprite; } catch (e:Dynamic) {}
	if (previous != null && previous != source)
	{
		try { if (previous.shader == dadRim) previous.shader = null; } catch (e:Dynamic) {}
		try { previous.useRenderTexture = false; } catch (e:Dynamic) {}
	}
	if (finaleMode && ClientPrefs.shaders)
	{
		try
		{
			dadRim.attachedSprite = source;
			source.shader = dadRim;
			source.useRenderTexture = true;
		}
		catch (e:Dynamic) {}
	}
	else if (dadRim.attachedSprite == source)
	{
		disableBlackParasiteRimlight(source);
	}
}

function hideOriginalBlackParasiteEye():Bool
{
	var source:FunkinSprite = getBlackParasiteCharacter();
	if (source == null)
	{
		finaleEyeDebugStatus = 'Black Parasite source unavailable';
		if (dadEyeBlackPHiddenOwner != null)
			restoreOriginalBlackParasiteEye();
		return false;
	}
	if (source.library == null)
	{
		finaleEyeDebugStatus = 'Black Parasite Animate library unavailable';
		return false;
	}
	if (dadEyeBlackPHiddenOwner == source)
		return dadEyeBlackPVisibilityBackup.length > 0;
	if (dadEyeBlackPHiddenOwner != null)
		restoreOriginalBlackParasiteEye();

	var hiddenCount:Int = 0;
	hiddenCount += hideBlackParasiteEyeRoot(source, 'abomination black idle', [4]);
	hiddenCount += hideBlackParasiteEyeRoot(source, 'BLACK UP', [2, 3]);
	hiddenCount += hideBlackParasiteEyeRoot(source, 'black down', [0]);
	hiddenCount += hideBlackParasiteEyeRoot(source, 'right ske', [3, 4]);
	hiddenCount += hideBlackParasiteEyeRoot(source, 'left ', [2, 12]);
	finaleEyeDebugHiddenCount = hiddenCount;
	if (hiddenCount > 0 || dadEyeBlackPVisibilityBackup.length > 0)
	{
		dadEyeBlackPHiddenOwner = source;
		invalidateAnimateSpriteFrame(source);
		return true;
	}
	dadEyeBlackPHiddenOwner = null;
	return false;
}

function restoreOriginalBlackParasiteEye():Void
{
	var source:FunkinSprite = dadEyeBlackPHiddenOwner;
	for (entry in dadEyeBlackPVisibilityBackup)
	{
		if (entry == null || entry.element == null)
			continue;
		try { entry.element.visible = entry.visible; } catch (e:Dynamic) {}
		if (entry.frame != null)
			try { entry.frame.setDirty(); } catch (e:Dynamic) {}
	}
	dadEyeBlackPVisibilityBackup = [];
	dadEyeBlackPHiddenOwner = null;
	invalidateAnimateSpriteFrame(source);
}

function syncOverlayAnimationClock(source:FunkinSprite, overlay:FunkinSprite):Void
{
	if (source == null || overlay == null)
		return;
	try
	{
		if (source.isAnimNull() || overlay.isAnimNull())
			return;
		var frameCount:Int = overlay.getAnimNumFrames();
		if (frameCount <= 0)
			return;
		var frame:Int = source.animCurFrame;
		if (frame < 0) frame = 0;
		if (frame >= frameCount) frame = frameCount - 1;
		overlay.animCurFrame = frame;
		try { overlay.animation.frameIndex = source.animation.frameIndex; } catch (e:Dynamic) {}
	}
	catch (e:Dynamic) {}
}

function syncBlackParasiteEyeOverlay():Void
{
	if (finalemDestroying)
		return;
	if (dadEyeBlackP != null && !dadEyeBlackP.exists)
	{
		dadEyeBlackP = null;
		dadEyeBlackPAnim = '';
		dadEyeBlackPInitFailed = false;
	}
	var source:FunkinSprite = getBlackParasiteCharacter();
	if (source == null)
	{
		finaleEyeDebugStatus = 'waiting for dad.curCharacter == blackparasite';
		if (dadEyeBlackP != null && dadEyeBlackP.exists)
		{
			dadEyeBlackP.visible = false;
			dadEyeBlackP.active = false;
		}
		var oldOwner:FunkinSprite = dadEyeBlackPHiddenOwner;
		if (oldOwner != null)
			restoreOriginalBlackParasiteEye();
		if (oldOwner != null && oldOwner != dad)
			disableBlackParasiteRimlight(oldOwner);
		if (dad != null && finaleMode)
			syncBlackParasiteRimlight(dad);
		else if (oldOwner != null)
			disableBlackParasiteRimlight(oldOwner);
		dadEyeBlackPAnim = '';
		return;
	}

	syncBlackParasiteRimlight(source);
	ensureBlackParasiteEyeOverlay();
	if (dadEyeBlackP == null || !dadEyeBlackP.exists)
	{
		if (dadEyeBlackPHiddenOwner != null)
			restoreOriginalBlackParasiteEye();
		return;
	}
	if (!hideOriginalBlackParasiteEye())
	{
		finaleEyeDebugStatus = 'could not hide source eye layers';
		dadEyeBlackP.visible = false;
		dadEyeBlackP.active = false;
		return;
	}
	if (!source.exists || !source.visible || source.alpha <= 0 || source.isAnimNull())
	{
		dadEyeBlackP.visible = false;
		dadEyeBlackP.active = false;
		return;
	}
	var currentAnim:String = source.getAnimName();
	if (currentAnim == '' || !dadEyeBlackP.hasAnim(currentAnim))
	{
		finaleEyeDebugStatus = 'overlay animation not found: ' + currentAnim;
		dadEyeBlackP.visible = false;
		dadEyeBlackP.active = false;
		restoreOriginalBlackParasiteEye();
		return;
	}
	if (dadEyeBlackPAnim != currentAnim || dadEyeBlackP.isAnimNull())
	{
		var sourceReversed:Bool = false;
		try { sourceReversed = source.animation.curAnim.reversed; } catch (e:Dynamic) {}
		dadEyeBlackP.playAnim(currentAnim, true, sourceReversed, source.animCurFrame);
		dadEyeBlackPAnim = currentAnim;
	}
	var frameCount:Int = dadEyeBlackP.getAnimNumFrames();
	if (frameCount > 0)
	{
		var frame:Int = source.animCurFrame;
		if (frame < 0) frame = 0;
		if (frame >= frameCount) frame = frameCount - 1;
		dadEyeBlackP.animCurFrame = frame;
		try { dadEyeBlackP.animation.frameIndex = source.animation.frameIndex; } catch (e:Dynamic) {}
	}
	dadEyeBlackP.x = source.x;
	dadEyeBlackP.y = source.y;
	dadEyeBlackP.scale.set(source.scale.x, source.scale.y);
	dadEyeBlackP.baseScale.set(source.baseScale.x, source.baseScale.y);
	dadEyeBlackP.origin.set(source.origin.x, source.origin.y);
	dadEyeBlackP.offset.set(source.offset.x, source.offset.y);
	dadEyeBlackP.spriteOffset.set(source.spriteOffset.x, source.spriteOffset.y);
	dadEyeBlackP.animOffset.set(source.animOffset.x, source.animOffset.y);
	dadEyeBlackP.angle = source.angle;
	dadEyeBlackP.skew.set(source.skew.x, source.skew.y);
	dadEyeBlackP.flipX = source.flipX;
	dadEyeBlackP.flipY = source.flipY;
	dadEyeBlackP.alpha = source.alpha;
	dadEyeBlackP.color = source.color;
	dadEyeBlackP.blend = source.blend;
	dadEyeBlackP.scrollFactor.set(source.scrollFactor.x, source.scrollFactor.y);
	dadEyeBlackP.antialiasing = source.antialiasing;
	var eyeZ:Float = source.zIndex + 0.01;
	if (dadEyeBlackP.zIndex != eyeZ)
	{
		dadEyeBlackP.zIndex = eyeZ;
		refreshZ();
	}
	dadEyeBlackP.shader = null;
	dadEyeBlackP.useRenderTexture = false;
	dadEyeBlackP.cameras = [camGame];
	dadEyeBlackP.colorTransform.redMultiplier = source.colorTransform.redMultiplier;
	dadEyeBlackP.colorTransform.greenMultiplier = source.colorTransform.greenMultiplier;
	dadEyeBlackP.colorTransform.blueMultiplier = source.colorTransform.blueMultiplier;
	dadEyeBlackP.colorTransform.alphaMultiplier = source.colorTransform.alphaMultiplier;
	dadEyeBlackP.colorTransform.redOffset = source.colorTransform.redOffset;
	dadEyeBlackP.colorTransform.greenOffset = source.colorTransform.greenOffset;
	dadEyeBlackP.colorTransform.blueOffset = source.colorTransform.blueOffset;
	dadEyeBlackP.colorTransform.alphaOffset = source.colorTransform.alphaOffset;
	dadEyeBlackP.active = false;
	dadEyeBlackP.visible = true;
	finaleEyeDebugStatus = 'separation active';
}

function createFinaleEyeDebug():Void
{
	if (finaleEyeDebug != null)
		return;
	finaleEyeDebug = new FlxText(8, 8, 780, 'Finale eye: waiting for blackparasite', 14);
	finaleEyeDebug.setFormat(null, 14, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	finaleEyeDebug.scrollFactor.set();
	finaleEyeDebug.cameras = [camGame];
	finaleEyeDebug.zIndex = 10000;
	add(finaleEyeDebug);
	refreshZ();
}

function updateFinaleEyeDebug():Void
{
	if (finaleEyeDebug == null || finalemDestroying)
		return;
	var characterName:String = 'null';
	var animationName:String = '';
	var sourceHasLibrary:Bool = false;
	var templateExists:Bool = false;
	var overlayExists:Bool = dadEyeBlackP != null && dadEyeBlackP.exists;
	try { if (dad != null) characterName = Std.string(dad.curCharacter); } catch (e:Dynamic) {}
	var source:FunkinSprite = getBlackParasiteCharacter();
	if (source != null)
	{
		try { animationName = source.getAnimName(); } catch (e:Dynamic) {}
		try { sourceHasLibrary = source.library != null; } catch (e:Dynamic) {}
	}
	try { templateExists = dadGroup != null && dadGroup.map != null && dadGroup.map.get('blackparasite') != null; } catch (e:Dynamic) {}
	finaleEyeDebug.text = 'Finale eye DEBUG\n'
		+ 'dad: ' + characterName + ' | animation: ' + animationName + '\n'
		+ 'source library: ' + sourceHasLibrary + ' | template: ' + templateExists + '\n'
		+ 'overlay: ' + overlayExists + ' | mask layers: ' + finaleEyeDebugMaskCount + '\n'
		+ 'hidden source elements: ' + dadEyeBlackPVisibilityBackup.length + ' | status: ' + finaleEyeDebugStatus
		+ (finaleEyeDebugError != '' ? '\nerror: ' + finaleEyeDebugError : '');
}

function onUpdatePost(elapsed:Float)
{
	if (finalemDestroying)
		return;
	try
	{
		syncBlackParasiteEyeOverlay();
	}
	catch (e:Dynamic)
	{
		finaleEyeDebugStatus = 'sync exception';
		finaleEyeDebugError = Std.string(e);
	}
	updateFinaleEyeDebug();
}

function onDestroy()
{
	if (finalemDestroying)
		return;
	finalemDestroying = true;
	try { if (finaleDarkFG != null) FlxTween.cancelTweensOf(finaleDarkFG); } catch (e:Dynamic) {}

	var blackParasiteOwner:FunkinSprite = dadEyeBlackPHiddenOwner;
	try { restoreOriginalBlackParasiteEye(); } catch (e:Dynamic) {}
	if (blackParasiteOwner != null)
	{
		try { disableBlackParasiteRimlight(blackParasiteOwner); } catch (e:Dynamic) {}
	}

	if (dadEyeBlackP != null)
	{
		try { dadEyeBlackP.visible = false; dadEyeBlackP.active = false; } catch (e:Dynamic) {}
	}
	dadEyeBlackP = null;
	dadEyeBlackPAnim = '';
	dadEyeBlackPInitFailed = false;
	dadEyeBlackPHiddenOwner = null;
	dadEyeBlackPVisibilityBackup = [];
	finaleEyeDebug = null;
}

function onBeatHit()
{
	if (!ClientPrefs.lowQuality && curBeat % 4 == 0) finaleLight.animation.play('bop');
}

function onUpdate(elapsed)
{
	if (Conductor.songPosition >= 0 && Conductor.songPosition < 9600)
	{
		FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, 1, FlxMath.bound(elapsed * 0.01, 0, 1));
	}
}

function onSongStart()
{
	// finaleDarkFG.alpha = FlxMath.lerp(finaleDarkFG.alpha, 0, FlxMath.bound(elapsed * 0.5, 0, 1));
	FlxTween.tween(finaleDarkFG, {alpha: .14}, 1.4, {ease: FlxEase.quadOut});
}

function onMoveCamera(isDad)
{
	if (finaleMode) if (isDad == 'boyfriend')
	{
		game.defaultCamZoom = 0.5;
	}
	else
	{
		game.defaultCamZoom = 0.4;
	}
}

function onEvent(name, v1, v2)
{
	switch (name)
	{
		case 'Finale Flashback Change':
			finaleFlashbackStuff.alpha = 0.5;
			switch (v1)
			{
				case 'moog':
					finaleFlashbackStuff.animation.play('moog');
				case 'toog':
					finaleFlashbackStuff.animation.play('toog');
				case 'doog':
					finaleFlashbackStuff.animation.play('doog');
				case 'flash':
					FlxG.camera.fade(FlxColor.WHITE, 1.2, false, function() {
						FlxG.camera.fade(FlxColor.RED, 0.6, true);
						finaleFlashbackStuff.alpha = 0;
					});
			}
			
		case 'Finale Drop':
			finaleMode = true;
			applyInitialRimlightCopies();
			camSpecialThing([500, 600], [700, 700]);
			health = 0.2; // used to be 0.1 but im nicer
			finaleBGStuff.alpha = 1;
			finaleFGStuff.alpha = 1;
			defeatFinaleStuff.visible = false;
			lightoverlay.visible = false;
			healthBar.visible = true;
			canFollow = true;
			finaleUIOn();
			scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, 0xFFff1266, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			playHUD.updateIconPos = false;
			camGame.flash(0xFFff1266, 0.75);
		case 'Finale End':
			camOther.flash(0xFFff1266, 5);
			camHUD.visible = false;
			camGame.visible = false;
	}
}
