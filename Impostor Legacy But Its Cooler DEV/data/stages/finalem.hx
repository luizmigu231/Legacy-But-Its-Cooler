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

var dadEyeBlack:FunkinSprite = null;
var dadEyeOverlay:FunkinSprite = null;
var dadEyeAnim:String = '';

var dadEyeBlackP:FunkinSprite = null;
var dadEyeBlackPInitFailed:Bool = false;
var dadEyeBlackPAnim:String = '';
var dadEyeBlackPHiddenOwner:Dynamic = null;
var dadEyeBlackPVisibilityBackup:Array<Dynamic> = [];
var dadEyeBlackPDirtyFrames:Array<Dynamic> = [];

function onLoad()
{
	var bars:FlxSpriteGroup = new FlxSpriteGroup();
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
	
	// Build and mask the BlackP eye before attaching a sprite-wide shader.
	// If it cannot be isolated, the BF must remain unshaded rather than leak rimlight onto the eye.
	var blackPEyeSeparatedAtCreate:Bool = true;
	if (isBlackParasiteTarget(boyfriend))
	{
		ensureBlackParasiteEyeOverlay();
		blackPEyeSeparatedAtCreate = hideOriginalBlackParasiteEye() && dadEyeBlackP != null;
	}

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

		if (
			hasBfSkin &&
			boyfriend.getFlag('backlit') != true &&
			blackPEyeSeparatedAtCreate
		)
		{
			bfRim = blackRimlightBase;
			bfRim.attachedSprite = boyfriend;
			boyfriend.useRenderTexture = true;
			if (isBlackParasiteTarget(boyfriend))
				invalidateAnimateSpriteFrame(boyfriend);
		}
		else if (isBlackParasiteTarget(boyfriend))
		{
			boyfriend.shader = null;
			boyfriend.useRenderTexture = false;
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
		dad.useRenderTexture = true;

		dadRim.layers[0].angle = 170;
		dadRim.layers[1].angle = 88;

	}
	PauseSubState.songName = 'blackPause';
	ensureBlackEyeOverlay();
	ensureBlackParasiteEyeOverlay();
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

	var bfCanUseRimlight:Bool = true;
	if (isBlackParasiteTarget(boyfriend))
	{
		ensureBlackParasiteEyeOverlay();
		bfCanUseRimlight = hideOriginalBlackParasiteEye() && dadEyeBlackP != null;
	}

	if (hasBfSkin && boyfriend.getFlag('backlit') != true && bfCanUseRimlight)
	{
		bfRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(initialRimCopy);
		bfRim.attachedSprite = boyfriend;
		boyfriend.useRenderTexture = true;
		if (isBlackParasiteTarget(boyfriend))
			invalidateAnimateSpriteFrame(boyfriend);
	}
	else if (isBlackParasiteTarget(boyfriend))
	{
		if (bfRim != null && boyfriend.shader == bfRim)
			boyfriend.shader = null;
		boyfriend.useRenderTexture = false;
	}

	if (hasPet)
	{
		petRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(initialRimCopy);
		petRim.attachedSprite = pet;
		pet.useRenderTexture = true;
	}

	dadRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(initialRimCopy);
	dadRim.attachedSprite = dad;
	dad.useRenderTexture = true;
	dadRim.layers[0].angle = 170;
	dadRim.layers[1].angle = 88;
}


function ensureBlackEyeOverlay():Void
{
	// Disabled: do not create or modify a second Animate library for normal Black.
}

function copyExactAnimationsToOverlay(source:FunkinSprite, target:FunkinSprite):Bool
{
	if (source == null || target == null || source.library == null || target.library == null)
		return false;

	try
	{
		// Use Legacy's own animation controller copy so prefixes, indices, FPS,
		// looping and special animation definitions match the source character exactly.
		target.copyAnimController(source.animation);

		var sourceAnimations:Dynamic = Reflect.field(source.animation, '_animations');
		var targetAnimations:Dynamic = Reflect.field(target.animation, '_animations');
		if (sourceAnimations == null || targetAnimations == null)
			return false;

		var keysMethod:Dynamic = Reflect.field(sourceAnimations, 'keys');
		var getSourceMethod:Dynamic = Reflect.field(sourceAnimations, 'get');
		var getTargetMethod:Dynamic = Reflect.field(targetAnimations, 'get');
		if (keysMethod == null || getSourceMethod == null || getTargetMethod == null)
			return false;

		var keys:Dynamic = Reflect.callMethod(sourceAnimations, keysMethod, []);
		while (keys.hasNext())
		{
			var animationName:String = Std.string(keys.next());
			var sourceAnim:Dynamic = Reflect.callMethod(sourceAnimations, getSourceMethod, [animationName]);
			var targetAnim:Dynamic = Reflect.callMethod(targetAnimations, getTargetMethod, [animationName]);
			if (sourceAnim == null || targetAnim == null)
				continue;

			var sourceTimeline:Dynamic = Reflect.field(sourceAnim, 'timeline');
			if (sourceTimeline == null)
				continue;

			var mappedTimeline:Dynamic = null;
			if (sourceTimeline == source.library.timeline)
				mappedTimeline = target.library.timeline;
			else
			{
				var timelineName:Dynamic = Reflect.field(sourceTimeline, 'name');
				if (timelineName != null)
				{
					var symbol:Dynamic = target.library.getSymbol(Std.string(timelineName));
					if (symbol != null)
						mappedTimeline = symbol.timeline;
				}
			}

			if (mappedTimeline == null)
				return false;
			Reflect.setField(targetAnim, 'timeline', mappedTimeline);
		}
		return true;
	}
	catch (e:Dynamic)
	{
		return false;
	}
}

function invalidateAnimateSpriteFrame(sprite:FunkinSprite):Void
{
	if (sprite == null || sprite.isAnimNull())
		return;
	try
	{
		var currentFrame:Int = sprite.animation.frameIndex;
		sprite.animation.frameIndex = currentFrame;
	}
	catch (e:Dynamic) {}
}

function isBlackParasiteEyePart(symbolName:String):Bool
{
	if (symbolName == null || symbolName == '')
		return false;

	var lowerName:String = StringTools.trim(symbolName).toLowerCase();
	return lowerName == 'símbolo 25 copia'
		|| lowerName == 'símbolo 25 copia copy'
		|| lowerName == 'simbolo 25 copia'
		|| lowerName == 'simbolo 25 copia copy'
		|| lowerName == '_bta_asi_4'
		|| lowerName == '_bta_asi_5'
		|| lowerName == '_bta_asi_6'
		|| lowerName == '_bta_asi_7'
		|| lowerName == '_bta_asi_18'
		|| lowerName == '_bta_asi_19'
		|| lowerName == '_bta_asi_20'
		|| lowerName == '_bta_asi_21'
		|| lowerName == '_bta_asi_22'
		|| lowerName == '_bta_asi_23'
		|| lowerName == '_bta_asi_24'
		|| lowerName == '_bta_asi_38'
		|| lowerName == '_bta_asi_39'
		|| lowerName == '_bta_asi_40'
		|| lowerName == '_bta_asi_41'
		|| lowerName == '_bta_asi_51'
		|| lowerName == '_bta_asi_52'
		|| lowerName == '_bta_asi_53'
		|| lowerName == '_bta_asi_54';
}

function getBlackParasiteElementSymbolName(element:Dynamic):String
{
	if (element == null)
		return '';

	var value:Dynamic = null;
	try { value = element.symbolName; } catch (e:Dynamic) {}
	if (value != null && Std.string(value) != '')
		return Std.string(value);

	try { value = Reflect.field(element, 'symbolName'); } catch (e:Dynamic) {}
	if (value != null && Std.string(value) != '')
		return Std.string(value);

	var libraryItem:Dynamic = null;
	try { libraryItem = element.libraryItem; } catch (e:Dynamic) {}
	if (libraryItem == null)
		try { libraryItem = Reflect.field(element, 'libraryItem'); } catch (e:Dynamic) {}
	if (libraryItem != null)
	{
		var itemName:Dynamic = null;
		try { itemName = libraryItem.name; } catch (e:Dynamic) {}
		if (itemName == null)
			try { itemName = Reflect.field(libraryItem, 'name'); } catch (e:Dynamic) {}
		if (itemName != null && Std.string(itemName) != '')
			return Std.string(itemName);
	}

	var atlasFrame:Dynamic = null;
	try { atlasFrame = element.frame; } catch (e:Dynamic) {}
	if (atlasFrame == null)
		try { atlasFrame = Reflect.field(element, 'frame'); } catch (e:Dynamic) {}
	if (atlasFrame != null)
	{
		var frameName:Dynamic = null;
		try { frameName = atlasFrame.name; } catch (e:Dynamic) {}
		if (frameName == null)
			try { frameName = Reflect.field(atlasFrame, 'name'); } catch (e:Dynamic) {}
		if (frameName != null && Std.string(frameName) != '')
			return Std.string(frameName);
	}

	var bitmapName:Dynamic = null;
	try { bitmapName = element.bitmap; } catch (e:Dynamic) {}
	if (bitmapName == null)
		try { bitmapName = Reflect.field(element, 'bitmap'); } catch (e:Dynamic) {}
	if (bitmapName != null && Std.string(bitmapName) != '')
		return Std.string(bitmapName);

	return '';
}

function filterBlackParasiteEyeSymbol(overlay:FunkinSprite, symbolName:String, trail:Array<String>):Bool
{
	if (isBlackParasiteEyePart(symbolName))
		return true;
	if (overlay == null || overlay.library == null || symbolName == null || symbolName == '')
		return false;
	if (trail.indexOf(symbolName) >= 0)
		return false;

	var symbol = overlay.library.getSymbol(symbolName);
	if (symbol == null || symbol.timeline == null)
		return false;

	trail.push(symbolName);
	var hasEyePart:Bool = false;
	for (layer in symbol.timeline.layers)
	{
		layer.forEachFrame(function(frame)
		{
			if (frame == null || frame.elements == null)
				return;

			var frameChanged:Bool = false;
			for (element in frame.elements)
			{
				var childName:String = getBlackParasiteElementSymbolName(element);
				var keep:Bool = isBlackParasiteEyePart(childName);
				if (!keep && childName != '')
					keep = filterBlackParasiteEyeSymbol(overlay, childName, trail);

				if (element.visible != keep)
					frameChanged = true;
				element.visible = keep;
				if (keep)
					hasEyePart = true;
			}
			if (frameChanged)
				frame.setDirty();
		});
	}
	trail.pop();
	return hasEyePart;
}

function isBlackParasiteTarget(sprite:FunkinSprite):Bool
{
	if (sprite == null)
		return false;

	var imagePath:String = '';
	var characterName:String = '';
	try { imagePath = Std.string(sprite.imageFile).toLowerCase(); } catch (e:Dynamic) {}
	try { characterName = Std.string(sprite.curCharacter).toLowerCase(); } catch (e:Dynamic) {}

	return imagePath.indexOf('mini_black') >= 0
		|| imagePath.indexOf('blackparasite') >= 0
		|| characterName == 'blackp'
		|| characterName == 'blackparasite';
}

function getBlackParasiteCharacter():FunkinSprite
{
	return isBlackParasiteTarget(boyfriend) ? boyfriend : null;
}

function ensureBlackParasiteEyeOverlay():Void
{
	if (dadEyeBlackP != null || dadEyeBlackPInitFailed)
		return;

	var blackPCharacter:FunkinSprite = getBlackParasiteCharacter();
	if (blackPCharacter == null || blackPCharacter.library == null)
		return;

	var atlasPath:String = Paths.getPath(
		'images/${ext}blackp_eye_overlay',
		null,
		PathsTestMode.LOOSE
	);
	var eyeFrames:FlxAnimateFrames = FlxAnimateFrames.fromAnimate(
		atlasPath,
		null,
		null,
		'dadEyeUnique_blackp_private_finales',
		true,
		{cacheOnLoad:false}
	);
	if (eyeFrames == null)
	{
		dadEyeBlackPInitFailed = true;
		return;
	}

	var overlay:FunkinSprite = new FunkinSprite(0, 0);
	overlay.frames = eyeFrames;

	if (!copyExactAnimationsToOverlay(blackPCharacter, overlay))
	{
		overlay.destroy();
		dadEyeBlackPInitFailed = true;
		return;
	}

	overlay.scalableOffsets = blackPCharacter.scalableOffsets;
	overlay.rotatableOffsets = blackPCharacter.rotatableOffsets;
	overlay.skewableOffsets = blackPCharacter.skewableOffsets;
	overlay.baseFlipX = blackPCharacter.baseFlipX;
	overlay.baseFlipY = blackPCharacter.baseFlipY;
	overlay.antialiasing = blackPCharacter.antialiasing;
	overlay.shader = null;
	overlay.useRenderTexture = false;
	overlay.cameras = [camGame];
	overlay.scrollFactor.set(blackPCharacter.scrollFactor.x, blackPCharacter.scrollFactor.y);
	overlay.zIndex = finaleDarkFG == null ? 6 : finaleDarkFG.zIndex + 1;
	overlay.active = false;
	overlay.visible = false;

	var roots:Array<String> = [
		'abomination black idle',
		'BLACK UP',
		'black down',
		'right ske',
		'left '
	];
	var matched:Int = 0;
	for (rootName in roots)
	{
		if (filterBlackParasiteEyeSymbol(overlay, rootName, []))
			matched++;
	}
	if (matched == 0)
	{
		overlay.destroy();
		dadEyeBlackPInitFailed = true;
		return;
	}

	add(overlay);
	refreshZ();
	dadEyeBlackP = overlay;
}

function saveBlackParasiteEyeVisibility(element:Dynamic):Void
{
	for (entry in dadEyeBlackPVisibilityBackup)
	{
		if (entry != null && entry.element == element)
			return;
	}
	var parentFrame:Dynamic = null;
	try { parentFrame = element.parentFrame; } catch (e:Dynamic) {}
	dadEyeBlackPVisibilityBackup.push({element:element, visible:element.visible, frame:parentFrame});
}

function markBlackParasiteEyeFrameDirty(frame:Dynamic):Void
{
	if (frame == null)
		return;
	if (dadEyeBlackPDirtyFrames.indexOf(frame) < 0)
		dadEyeBlackPDirtyFrames.push(frame);
	try { frame.setDirty(); } catch (e:Dynamic) {}
}

function hideBlackParasiteEyePartsInSymbol(source:FunkinSprite, symbolName:String, trail:Array<String>):Int
{
	if (source == null || source.library == null || symbolName == null || symbolName == '')
		return 0;
	if (trail.indexOf(symbolName) >= 0)
		return 0;

	var symbol = source.library.getSymbol(symbolName);
	if (symbol == null || symbol.timeline == null)
		return 0;

	var matchedCount:Int = 0;
	trail.push(symbolName);
	for (layer in symbol.timeline.layers)
	{
		layer.forEachFrame(function(frame)
		{
			if (frame == null || frame.elements == null)
				return;

			var frameChanged:Bool = false;
			for (element in frame.elements)
			{
				var childName:String = getBlackParasiteElementSymbolName(element);
				if (isBlackParasiteEyePart(childName))
				{
					saveBlackParasiteEyeVisibility(element);
					matchedCount++;
					frameChanged = true;
					element.visible = false;
				}
				else if (childName != '')
				{
					var nestedMatches:Int = hideBlackParasiteEyePartsInSymbol(source, childName, trail);
					if (nestedMatches > 0)
					{
						matchedCount += nestedMatches;
						frameChanged = true;
					}
				}
			}

			// A parent's baked frame contains its nested child's rendered pixels too.
			// Mark every frame on the path dirty, not only the leaf that owns _bta_asi.
			if (frameChanged)
				markBlackParasiteEyeFrameDirty(frame);
		});
	}
	trail.pop();
	return matchedCount;
}

function hideOriginalBlackParasiteEye():Bool
{
	var source:FunkinSprite = getBlackParasiteCharacter();
	if (source == null || source.library == null)
	{
		if (dadEyeBlackPHiddenOwner != null)
			restoreOriginalBlackParasiteEye();
		return false;
	}
	if (dadEyeBlackPHiddenOwner == source)
		return dadEyeBlackPVisibilityBackup.length > 0;

	if (dadEyeBlackPHiddenOwner != null)
		restoreOriginalBlackParasiteEye();

	var roots:Array<String> = [];
	function addEyeRoot(value:Dynamic):Void
	{
		if (value == null) return;
		var name:String = Std.string(value);
		if (name == '' || name == 'null' || roots.indexOf(name) >= 0) return;
		roots.push(name);
	}

	// Walk the complete Animate document root first. Some eye instances live
	// in symbols outside the five common pose symbols below.
	try { addEyeRoot(source.library.timeline.name); } catch (e:Dynamic) {}
	try
	{
		for (anim in source.animations)
		{
			if (anim == null) continue;
			addEyeRoot(anim.name);
			addEyeRoot(anim.anim);
		}
	}
	catch (e:Dynamic) {}

	for (rootName in [
		'abomination black idle',
		'BLACK UP',
		'black down',
		'right ske',
		'left '
	])
		addEyeRoot(rootName);

	var hiddenCount:Int = 0;
	for (rootName in roots)
		hiddenCount += hideBlackParasiteEyePartsInSymbol(source, rootName, []);

	if (hiddenCount > 0 || dadEyeBlackPVisibilityBackup.length > 0)
	{
		dadEyeBlackPHiddenOwner = source;
		invalidateAnimateSpriteFrame(source);
		return true;
	}

	// Never mark the source as masked when no eye elements were actually found.
	// Keep trying on the next update instead of silently leaving the shaded eye visible.
	dadEyeBlackPHiddenOwner = null;
	return false;
}

function restoreOriginalBlackParasiteEye():Void
{
	for (entry in dadEyeBlackPVisibilityBackup)
	{
		if (entry != null && entry.element != null)
			entry.element.visible = entry.visible;
	}

	// Restore the baked parent frames as well as leaf frames; otherwise stale
	// cached pixels can survive after the source visibility has been restored.
	for (frame in dadEyeBlackPDirtyFrames)
		try { frame.setDirty(); } catch (e:Dynamic) {}

	dadEyeBlackPDirtyFrames = [];
	dadEyeBlackPVisibilityBackup = [];
	dadEyeBlackPHiddenOwner = null;
	invalidateAnimateSpriteFrame(getBlackParasiteCharacter());
}

function syncOverlayAnimationClock(source:FunkinSprite, target:FunkinSprite):Void
{
	if (source == null || target == null || source.isAnimNull() || target.isAnimNull())
		return;

	target.animCurFrame = source.animCurFrame;

	var sourceAnim:Dynamic = source.animation.curAnim;
	var targetAnim:Dynamic = target.animation.curAnim;
	if (sourceAnim != null && targetAnim != null)
	{
		for (field in ['frameTimer', 'finished', 'reversed'])
		{
			try
			{
				var value:Dynamic = Reflect.field(sourceAnim, field);
				if (value != null)
					Reflect.setField(targetAnim, field, value);
			}
			catch (e:Dynamic) {}
		}
		// Setting curFrame alone only changes the controller's counter; FlxAnimate
		// draws from its timeline frameIndex. Copy the displayed frame as well.
		try
		{
			var displayedFrame:Int = source.animation.frameIndex;
			if (target.animation.frameIndex != displayedFrame)
				target.animation.frameIndex = displayedFrame;
		}
		catch (e:Dynamic) {}
	}
}

function syncBlackParasiteEyeOverlay():Void
{
	var source:FunkinSprite = getBlackParasiteCharacter();
	if (source == null)
	{
		if (dadEyeBlackP != null) { dadEyeBlackP.visible = false; dadEyeBlackP.active = false; }
		if (dadEyeBlackPHiddenOwner != null) restoreOriginalBlackParasiteEye();
		dadEyeBlackPAnim = '';
		return;
	}

	ensureBlackParasiteEyeOverlay();
	if (dadEyeBlackP == null)
	{
		if (dadEyeBlackPHiddenOwner != null) restoreOriginalBlackParasiteEye();
		if (bfRim != null && source.shader == bfRim) source.shader = null;
		source.useRenderTexture = false;
		return;
	}

	if (!hideOriginalBlackParasiteEye())
	{
		dadEyeBlackP.visible = false;
		dadEyeBlackP.active = false;
		if (bfRim != null && source.shader == bfRim) source.shader = null;
		source.useRenderTexture = false;
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
		dadEyeBlackP.visible = false;
		dadEyeBlackP.active = false;
		restoreOriginalBlackParasiteEye();
		if (bfRim != null && source.shader == bfRim) source.shader = null;
		source.useRenderTexture = false;
		return;
	}

	if (dadEyeBlackPAnim != currentAnim || dadEyeBlackP.isAnimNull())
	{
		var sourceReversed:Bool = false;
		try { sourceReversed = source.animation.curAnim.reversed; } catch (e:Dynamic) {}
		dadEyeBlackP.playAnim(currentAnim, true, sourceReversed, source.animCurFrame);
		dadEyeBlackPAnim = currentAnim;
	}

	syncOverlayAnimationClock(source, dadEyeBlackP);
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
	var eyeZ:Float = finaleDarkFG == null ? 6 : finaleDarkFG.zIndex + 1;
	if (dadEyeBlackP.zIndex != eyeZ) { dadEyeBlackP.zIndex = eyeZ; refreshZ(); }
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
}

function syncBlackEyeOverlay():Void
{
	// Disabled: leave normal Black and its Animate spritemap untouched.
}

function restoreOriginalBlackEye():Void
{
	// Disabled: this script no longer changes normal Black timeline elements.
}

function onUpdatePost(elapsed:Float)
{
	syncBlackEyeOverlay();
	syncBlackParasiteEyeOverlay();
}

function onDestroy()
{
	restoreOriginalBlackEye();
	restoreOriginalBlackParasiteEye();
	if (dadEyeBlack != null)
	{
		dadEyeBlack.visible = false;
		dadEyeBlack.active = false;
		dadEyeBlack.destroy();
		dadEyeBlack = null;
	}
	if (dadEyeBlackP != null)
	{
		dadEyeBlackP.visible = false;
		dadEyeBlackP.active = false;
		dadEyeBlackP.destroy();
		dadEyeBlackP = null;
	}
	dadEyeOverlay = null;
	dadEyeAnim = '';
	dadEyeBlackPAnim = '';
	dadEyeBlackPInitFailed = false;
	dadEyeHiddenOwner = null;
	dadEyeBlackPHiddenOwner = null;
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
			// Mask the BlackP eye before applying the copied rimlight shader to BF.
			hideOriginalBlackParasiteEye();
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
