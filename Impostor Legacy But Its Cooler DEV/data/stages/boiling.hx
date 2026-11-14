import animate.FlxAnimateFrames;
import funkin.objects.FunkinSprite;
import flixel.FlxSprite;
import flixel.effects.particles.FlxEmitterMode;
import flixel.math.FlxRect;
import funkin.game.shaders.DropShadowShader;
import funkin.game.shaders.ExtraDropShadowShader;
import funkin.objects.SnowEmitter;

var snowAlpha = 0.3;
var snowEmitter:SnowEmitter;
var emberEmitter:FlxEmitter;
var ext = 'stages/polus/maroon/boiling/';
var lavaOverlay:FlxSprite;
var lava:FlxSprite;
var lavaHot:FlxSprite;
var lava2:FlxSprite;
var lava2Hot:FlxSprite;
var ground:FlxSprite;
var groundHot:FlxSprite;
var groundBroken1:FlxSprite;
var groundBroken1Hot:FlxSprite;
var groundBroken2:FlxSprite;
var groundBroken2Hot:FlxSprite;
var bubbles:FlxSprite;
var bubblesHot:FlxSprite;
var lavaSplash:FlxSprite;
var playerBaseX:Array<Float> = [];
var oppBaseX:Array<Float> = [];
var startedSong:Bool = false;
var boilingLightProgress:Float = 0;
var boilingGroundFade:Float = 1;
var boilingLightTween:Dynamic;
var boilingGroundFadeTween:Dynamic;

var blackRimlightBase:ExtraDropShadowShader;
var bfRim:ExtraDropShadowShader;
var dadRim:ExtraDropShadowShader;
var petRim:ExtraDropShadowShader;
var bfRimTarget:FlxSprite;
var dadRimTarget:FlxSprite;
var petRimTarget:FlxSprite;

var maroonEyeOverlay:FunkinSprite = null;
var maroonEyeOverlaySource:FunkinSprite = null;
var maroonEyeOverlayCharacter:String = '';
var maroonEyeOverlayImage:String = '';
var maroonEyeAttemptSource:FunkinSprite = null;
var maroonEyeAnim:String = '';
var maroonEyeHiddenOwner:FunkinSprite = null;
var maroonEyeVisibilityBackup:Array<Dynamic> = [];
var maroonEyeDirtyFrames:Array<Dynamic> = [];
var maroonPoseSymbols:Array<String> = ['idle', 'left', 'up', 'right', 'down'];
var maroonEyeElementNames:Array<String> = ['guh', 'glow shit'];

function maroonIsEyePart(symbolName:String):Bool
{
	if (symbolName == null || symbolName.length == 0) return false;
	var lowerName:String = StringTools.trim(symbolName).toLowerCase();
	return maroonEyeElementNames.indexOf(lowerName) >= 0;
}

function maroonElementIsEyePart(element:Dynamic):Bool
{
	if (element == null) return false;
	var names:Array<Dynamic> = [];
	try { names.push(element.symbolName); } catch (e:Dynamic) {}
	try
	{
		if (element.libraryItem != null) names.push(element.libraryItem.name);
	}
	catch (e:Dynamic) {}
	try
	{
		if (element.frame != null) names.push(element.frame.name);
	}
	catch (e:Dynamic) {}
	try { names.push(element.bitmap); } catch (e:Dynamic) {}
	for (value in names)
	{
		if (value != null && maroonIsEyePart(Std.string(value))) return true;
	}
	return false;
}

function maroonGetElementSymbolName(element:Dynamic):String
{
	if (element == null) return '';

	var value:Dynamic = null;
	try { value = element.symbolName; } catch (e:Dynamic) {}
	if (value == null) try { value = Reflect.field(element, 'symbolName'); } catch (e:Dynamic) {}
	if (value != null && Std.string(value) != '') return Std.string(value);

	var libraryItem:Dynamic = null;
	try { libraryItem = element.libraryItem; } catch (e:Dynamic) {}
	if (libraryItem == null) try { libraryItem = Reflect.field(element, 'libraryItem'); } catch (e:Dynamic) {}
	if (libraryItem != null)
	{
		var itemName:Dynamic = null;
		try { itemName = libraryItem.name; } catch (e:Dynamic) {}
		if (itemName == null) try { itemName = Reflect.field(libraryItem, 'name'); } catch (e:Dynamic) {}
		if (itemName != null && Std.string(itemName) != '') return Std.string(itemName);
	}

	var atlasFrame:Dynamic = null;
	try { atlasFrame = element.frame; } catch (e:Dynamic) {}
	if (atlasFrame == null) try { atlasFrame = Reflect.field(element, 'frame'); } catch (e:Dynamic) {}
	if (atlasFrame != null)
	{
		var frameName:Dynamic = null;
		try { frameName = atlasFrame.name; } catch (e:Dynamic) {}
		if (frameName == null) try { frameName = Reflect.field(atlasFrame, 'name'); } catch (e:Dynamic) {}
		if (frameName != null && Std.string(frameName) != '') return Std.string(frameName);
	}

	var bitmapName:Dynamic = null;
	try { bitmapName = element.bitmap; } catch (e:Dynamic) {}
	if (bitmapName == null) try { bitmapName = Reflect.field(element, 'bitmap'); } catch (e:Dynamic) {}
	if (bitmapName != null && Std.string(bitmapName) != '') return Std.string(bitmapName);

	return '';
}

function maroonAddEyeRoot(roots:Array<String>, value:Dynamic):Void
{
	if (roots == null || value == null) return;
	var name:String = Std.string(value);
	if (name == '' || name == 'null' || roots.indexOf(name) >= 0) return;
	roots.push(name);
}

function maroonCollectEyeRoots(source:FunkinSprite):Array<String>
{
	var roots:Array<String> = [];
	if (source == null) return roots;

	try
	{
		if (source.library != null && source.library.timeline != null)
			maroonAddEyeRoot(roots, source.library.timeline.name);
	}
	catch (e:Dynamic) {}

	try
	{
		if (source.animations != null)
		{
			for (data in source.animations)
			{
				if (data == null) continue;
				maroonAddEyeRoot(roots, data.name);
				maroonAddEyeRoot(roots, data.anim);
			}
		}
	}
	catch (e:Dynamic) {}

	for (poseName in maroonPoseSymbols)
		maroonAddEyeRoot(roots, poseName);

	return roots;
}

// The eye atlas is a separate Animate copy. Keep only the two eye symbols
// in that copy, recursively following nested symbols just like Defeat's
// Black eye overlay does for its isolated character atlas.
function maroonFilterEyeSymbol(overlay:FunkinSprite, symbolName:String, trail:Array<String>):Bool
{
	if (maroonIsEyePart(symbolName)) return true;
	if (overlay == null || overlay.library == null || symbolName == null || symbolName == '') return false;
	if (trail.indexOf(symbolName) >= 0) return false;

	var symbol:Dynamic = null;
	try { symbol = overlay.library.getSymbol(symbolName); } catch (e:Dynamic) {}
	if (symbol == null || symbol.timeline == null) return false;

	trail.push(symbolName);
	var hasEyePart:Bool = false;
	for (layer in symbol.timeline.layers)
	{
		if (layer == null) continue;
		layer.forEachFrame(function(frame)
		{
			if (frame == null || frame.elements == null) return;

			var frameChanged:Bool = false;
			for (element in frame.elements)
			{
				var childName:String = maroonGetElementSymbolName(element);
				var keep:Bool = maroonElementIsEyePart(element) || maroonIsEyePart(childName);
				var nestedEye:Bool = false;
				if (!keep && childName != '')
				{
					nestedEye = maroonFilterEyeSymbol(overlay, childName, trail);
					keep = nestedEye;
				}

				if (element.visible != keep || nestedEye) frameChanged = true;
				element.visible = keep;
				if (keep) hasEyePart = true;
			}
			if (frameChanged) maroonMarkEyeFrameDirty(frame);
		});
	}
	trail.pop();
	return hasEyePart;
}

function maroonSaveEyeVisibility(element:Dynamic, frame:Dynamic):Void
{
	if (element == null) return;
	for (entry in maroonEyeVisibilityBackup)
	{
		if (entry != null && entry.element == element) return;
	}
	maroonEyeVisibilityBackup.push({element:element, visible:element.visible, frame:frame});
}

function maroonMarkEyeFrameDirty(frame:Dynamic):Void
{
	if (frame == null) return;
	if (maroonEyeDirtyFrames.indexOf(frame) < 0) maroonEyeDirtyFrames.push(frame);
	try { frame.setDirty(); } catch (e:Dynamic) {}
}

function maroonInvalidateRender(sprite:Dynamic):Void
{
	if (sprite == null) return;
	try { Reflect.setField(sprite, '_renderTextureDirty', true); } catch (e:Dynamic) {}
}

// Hide the original eye instances in the live character. Every changed
// parent frame is marked dirty as nested Animate symbols may be baked into it.
function maroonHideEyePartsInSymbol(source:FunkinSprite, symbolName:String, trail:Array<String>):Int
{
	if (source == null || source.library == null || symbolName == null || symbolName == '') return 0;
	if (trail.indexOf(symbolName) >= 0) return 0;

	var symbol:Dynamic = null;
	try { symbol = source.library.getSymbol(symbolName); } catch (e:Dynamic) {}
	if (symbol == null || symbol.timeline == null) return 0;

	trail.push(symbolName);
	var hiddenCount:Int = 0;
	for (layer in symbol.timeline.layers)
	{
		if (layer == null) continue;
		layer.forEachFrame(function(frame)
		{
			if (frame == null || frame.elements == null) return;

			var frameChanged:Bool = false;
			for (element in frame.elements)
			{
				var childName:String = maroonGetElementSymbolName(element);
				if (maroonElementIsEyePart(element) || maroonIsEyePart(childName))
				{
					if (element.visible)
					{
						maroonSaveEyeVisibility(element, frame);
						element.visible = false;
						frameChanged = true;
						hiddenCount++;
					}
				}
				else if (childName != '')
				{
					var nestedHidden:Int = maroonHideEyePartsInSymbol(source, childName, trail);
					if (nestedHidden > 0)
					{
						hiddenCount += nestedHidden;
						frameChanged = true;
					}
				}
			}
			if (frameChanged) maroonMarkEyeFrameDirty(frame);
		});
	}
	trail.pop();
	return hiddenCount;
}

function maroonHideOriginalEyes(source:FunkinSprite):Bool
{
	if (source == null || source.library == null) return false;
	if (maroonEyeHiddenOwner == source) return maroonEyeVisibilityBackup.length > 0;
	if (maroonEyeHiddenOwner != null) maroonRestoreOriginalEyes();

	var hiddenCount:Int = 0;
	for (rootName in maroonCollectEyeRoots(source))
		hiddenCount += maroonHideEyePartsInSymbol(source, rootName, []);

	if (hiddenCount > 0 || maroonEyeVisibilityBackup.length > 0)
	{
		maroonEyeHiddenOwner = source;
		maroonInvalidateRender(source);
		return true;
	}

	maroonEyeHiddenOwner = null;
	return false;
}

function maroonRestoreOriginalEyes():Void
{
	var previousOwner:FunkinSprite = maroonEyeHiddenOwner;
	for (entry in maroonEyeVisibilityBackup)
	{
		if (entry == null || entry.element == null) continue;
		try { entry.element.visible = entry.visible; } catch (e:Dynamic) {}
		if (entry.frame != null) maroonMarkEyeFrameDirty(entry.frame);
	}
	for (frame in maroonEyeDirtyFrames)
		try { frame.setDirty(); } catch (e:Dynamic) {}

	maroonEyeVisibilityBackup = [];
	maroonEyeDirtyFrames = [];
	maroonEyeHiddenOwner = null;
	if (previousOwner != null) maroonInvalidateRender(previousOwner);
}

function maroonCopyEyeAnimations(source:FunkinSprite, overlay:FunkinSprite):Bool
{
	if (source == null || overlay == null || source.animations == null) return false;
	var copied:Int = 0;

	for (data in source.animations)
	{
		if (data == null) continue;
		var animName:String = data.anim == null ? '' : '' + data.anim;
		var symbolName:String = data.name == null ? '' : '' + data.name;
		if (animName.length == 0 || symbolName.length == 0 || overlay.hasAnim(animName)) continue;

		var fps:Int = data.fps == null ? 24 : data.fps;
		var looped:Bool = data.loop == true;
		var flipX:Bool = data.flipX == true;
		var flipY:Bool = data.flipY == true;
		var indices:Array<Int> = data.indices == null ? [] : data.indices;
		try
		{
			if (indices.length > 0)
				overlay.addAnimByIndices(animName, symbolName, indices, fps, looped, flipX, flipY);
			else
				overlay.addAnimByPrefix(animName, symbolName, fps, looped, flipX, flipY);
			if (data.offsets != null && data.offsets.length > 1)
				overlay.addOffset(animName, data.offsets[0], data.offsets[1]);
			else
				overlay.addOffset(animName, 0, 0);
			copied++;
		}
		catch (e:Dynamic) {}
	}
	return copied > 0 && overlay.hasAnim('idle');
}

function maroonIsEyeTarget(source:FunkinSprite):Bool
{
	if (source == null) return false;
	var characterName:String = '';
	var imagePath:String = '';
	try { characterName = Std.string(source.curCharacter).toLowerCase(); } catch (e:Dynamic) {}
	try { imagePath = Std.string(source.imageFile).toLowerCase(); } catch (e:Dynamic) {}
	return characterName.indexOf('maroon') >= 0
		|| imagePath.indexOf('/maroon/') >= 0
		|| imagePath.indexOf('maroonparasite') >= 0;
}

function maroonCreateEyeOverlay(source:FunkinSprite):Bool
{
	if (source == null || source.library == null) return false;

	var atlasPath:String = '';
	try { atlasPath = Paths.getPath('images/' + source.imageFile, null, PathsTestMode.LOOSE); } catch (e:Dynamic) {}
	if (atlasPath == null || atlasPath.length == 0) return false;

	var eyeFrames:FlxAnimateFrames = null;
	try
	{
		var uniqueImage:String = StringTools.replace(Std.string(source.imageFile), '/', '_');
		var uniqueName:String = 'maroon_eye_unique_' + source.curCharacter + '_' + uniqueImage;
		eyeFrames = FlxAnimateFrames.fromAnimate(atlasPath, null, null, uniqueName, true, {cacheOnLoad:false});
	}
	catch (e:Dynamic) { eyeFrames = null; }
	if (eyeFrames == null) return false;

	var overlay:FunkinSprite = new FunkinSprite(0, 0);
	overlay.frames = eyeFrames;
	if (!maroonCopyEyeAnimations(source, overlay))
	{
		overlay.destroy();
		return false;
	}

	overlay.scalableOffsets = source.scalableOffsets;
	overlay.rotatableOffsets = source.rotatableOffsets;
	overlay.skewableOffsets = source.skewableOffsets;
	overlay.baseFlipX = source.baseFlipX;
	overlay.baseFlipY = source.baseFlipY;
	overlay.antialiasing = source.antialiasing;
	overlay.shader = null;
	overlay.useRenderTexture = false;
	overlay.cameras = [camGame];
	overlay.scrollFactor.set(source.scrollFactor.x, source.scrollFactor.y);
	overlay.zIndex = source.zIndex + 0.01;
	overlay.active = false;
	overlay.visible = false;
	try { overlay.applyStageMatrix = source.applyStageMatrix; } catch (e:Dynamic) {}
	try { overlay.postStageMatrixApply = source.postStageMatrixApply; } catch (e:Dynamic) {}

	var matched:Int = 0;
	for (rootName in maroonCollectEyeRoots(source))
	{
		if (maroonFilterEyeSymbol(overlay, rootName, [])) matched++;
	}
	if (matched == 0)
	{
		overlay.destroy();
		return false;
	}

	if (!maroonHideOriginalEyes(source))
	{
		overlay.destroy();
		return false;
	}

	try { dadGroup.add(overlay); }
	catch (e:Dynamic)
	{
		maroonRestoreOriginalEyes();
		overlay.destroy();
		return false;
	}

	maroonEyeOverlay = overlay;
	maroonEyeOverlaySource = source;
	maroonEyeOverlayCharacter = Std.string(source.curCharacter);
	maroonEyeOverlayImage = Std.string(source.imageFile);
	maroonEyeAnim = '';
	return true;
}

function maroonDestroyEyeSplit(restore:Bool = true):Void
{
	if (restore) maroonRestoreOriginalEyes();
	if (maroonEyeOverlay != null)
	{
		var overlay:FunkinSprite = maroonEyeOverlay;
		maroonEyeOverlay = null;
		try { dadGroup.remove(overlay, true); }
		catch (e:Dynamic) { try { overlay.destroy(); } catch (e2:Dynamic) {} }
	}
	maroonEyeOverlaySource = null;
	maroonEyeOverlayCharacter = '';
	maroonEyeOverlayImage = '';
	maroonEyeAttemptSource = null;
	maroonEyeAnim = '';
}

function maroonSyncEyeAnimationClock(source:FunkinSprite, target:FunkinSprite):Void
{
	if (source == null || target == null || source.isAnimNull() || target.isAnimNull()) return;
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
				if (value != null) Reflect.setField(targetAnim, field, value);
			}
			catch (e:Dynamic) {}
		}
		try
		{
			var displayedFrame:Int = source.animation.frameIndex;
			if (target.animation.frameIndex != displayedFrame)
				target.animation.frameIndex = displayedFrame;
		}
		catch (e:Dynamic) {}
	}
}

function maroonSyncEyeSprite():Void
{
	var source:FunkinSprite = dad;
	if (!maroonIsEyeTarget(source))
	{
		if (maroonEyeOverlay != null || maroonEyeHiddenOwner != null) maroonDestroyEyeSplit(true);
		maroonEyeAttemptSource = null;
		return;
	}

	var currentCharacter:String = Std.string(source.curCharacter);
	var currentImage:String = Std.string(source.imageFile);
	if (maroonEyeOverlaySource != null && (maroonEyeOverlaySource != source || maroonEyeOverlayCharacter != currentCharacter || maroonEyeOverlayImage != currentImage))
		maroonDestroyEyeSplit(true);

	if (maroonEyeOverlay == null)
	{
		if (source.library == null) return;
		if (maroonEyeAttemptSource == source) return;
		maroonEyeAttemptSource = source;
		if (!maroonCreateEyeOverlay(source)) return;
	}

	if (maroonEyeHiddenOwner != source && !maroonHideOriginalEyes(source))
	{
		maroonEyeOverlay.visible = false;
		maroonEyeOverlay.active = false;
		return;
	}

	if (!source.exists || !source.visible || source.alpha <= 0 || source.isAnimNull())
	{
		maroonEyeOverlay.visible = false;
		maroonEyeOverlay.active = false;
		return;
	}

	var wanted:String = source.getAnimName();
	if (wanted == null || wanted.length == 0) wanted = 'idle';
	if (!maroonEyeOverlay.hasAnim(wanted))
	{
		if (wanted.indexOf('LEFT') != -1 && maroonEyeOverlay.hasAnim('singLEFT')) wanted = 'singLEFT';
		else if (wanted.indexOf('DOWN') != -1 && maroonEyeOverlay.hasAnim('singDOWN')) wanted = 'singDOWN';
		else if (wanted.indexOf('UP') != -1 && maroonEyeOverlay.hasAnim('singUP')) wanted = 'singUP';
		else if (wanted.indexOf('RIGHT') != -1 && maroonEyeOverlay.hasAnim('singRIGHT')) wanted = 'singRIGHT';
		else if (maroonEyeOverlay.hasAnim('idle')) wanted = 'idle';
		else
		{
			maroonEyeOverlay.visible = false;
			maroonEyeOverlay.active = false;
			return;
		}
	}

	if (maroonEyeAnim != wanted || maroonEyeOverlay.isAnimNull())
	{
		var sourceReversed:Bool = false;
		try { sourceReversed = source.animation.curAnim.reversed; } catch (e:Dynamic) {}
		maroonEyeOverlay.playAnim(wanted, true, sourceReversed, source.animCurFrame);
		maroonEyeAnim = wanted;
	}
	maroonSyncEyeAnimationClock(source, maroonEyeOverlay);

	maroonEyeOverlay.x = source.x;
	maroonEyeOverlay.y = source.y;
	maroonEyeOverlay.scale.set(source.scale.x, source.scale.y);
	maroonEyeOverlay.baseScale.set(source.baseScale.x, source.baseScale.y);
	maroonEyeOverlay.origin.set(source.origin.x, source.origin.y);
	maroonEyeOverlay.offset.set(source.offset.x, source.offset.y);
	maroonEyeOverlay.spriteOffset.set(source.spriteOffset.x, source.spriteOffset.y);
	maroonEyeOverlay.animOffset.set(source.animOffset.x, source.animOffset.y);
	maroonEyeOverlay.angle = source.angle;
	maroonEyeOverlay.skew.set(source.skew.x, source.skew.y);
	maroonEyeOverlay.flipX = source.flipX;
	maroonEyeOverlay.flipY = source.flipY;
	maroonEyeOverlay.alpha = source.alpha;
	// Keep the separated eye at its original atlas colors. The character's
	// FlxTween.color / sprite tint must never be inherited by this overlay.
	maroonEyeOverlay.color = 0xFFFFFFFF;
	maroonEyeOverlay.blend = source.blend;
	maroonEyeOverlay.scrollFactor.set(source.scrollFactor.x, source.scrollFactor.y);
	maroonEyeOverlay.antialiasing = source.antialiasing;
	var eyeZ:Float = source.zIndex + 0.01;
	if (maroonEyeOverlay.zIndex != eyeZ)
	{
		maroonEyeOverlay.zIndex = eyeZ;
		refreshZ();
	}
	maroonEyeOverlay.shader = null;
	maroonEyeOverlay.useRenderTexture = false;
	maroonEyeOverlay.cameras = [camGame];
	// Neutral color transform: do not copy the parent's tint or color offsets.
	maroonEyeOverlay.colorTransform.redMultiplier = 1;
	maroonEyeOverlay.colorTransform.greenMultiplier = 1;
	maroonEyeOverlay.colorTransform.blueMultiplier = 1;
	maroonEyeOverlay.colorTransform.alphaMultiplier = 1;
	maroonEyeOverlay.colorTransform.redOffset = 0;
	maroonEyeOverlay.colorTransform.greenOffset = 0;
	maroonEyeOverlay.colorTransform.blueOffset = 0;
	maroonEyeOverlay.colorTransform.alphaOffset = 0;
	try { maroonEyeOverlay.applyStageMatrix = source.applyStageMatrix; } catch (e:Dynamic) {}
	try { maroonEyeOverlay.postStageMatrixApply = source.postStageMatrixApply; } catch (e:Dynamic) {}
	maroonEyeOverlay.active = false;
	maroonEyeOverlay.visible = true;
}

function updateRimFrame(sprite:FlxSprite, shader:ExtraDropShadowShader)
{
	if (sprite == null) return;
	if (shader == null) return;
	if (sprite.frame == null) return;
	shader.updateFrameInfo(sprite.frame);
}

function setupBFRim()
{
	if (!ClientPrefs.shaders) return;
	if (boyfriend == null) return;
	if (blackRimlightBase == null) return;

	bfRim = new ExtraDropShadowShader().copyFrom(blackRimlightBase);
	bfRim.attachedSprite = boyfriend;
	boyfriend.useRenderTexture = true;
	boyfriend.shader = bfRim;
	bfRimTarget = boyfriend;
	updateRimFrame(boyfriend, bfRim);
}

function setupDadRim()
{
	if (!ClientPrefs.shaders) return;
	if (dad == null) return;
	if (blackRimlightBase == null) return;

	dadRim = new ExtraDropShadowShader().copyFrom(blackRimlightBase);
	dadRim.attachedSprite = dad;
	dad.useRenderTexture = true;
	dad.shader = dadRim;
	dadRimTarget = dad;
	updateRimFrame(dad, dadRim);
}

function setupPetRim()
{
	if (!ClientPrefs.shaders) return;
	if (pet == null) return;
	if (blackRimlightBase == null) return;

	petRim = new ExtraDropShadowShader().copyFrom(blackRimlightBase);
	petRim.attachedSprite = pet;
	pet.useRenderTexture = true;
	pet.shader = petRim;
	petRimTarget = pet;
	updateRimFrame(pet, petRim);
}

function checkRimAttachments()
{
	if (!ClientPrefs.shaders) return;
	if (blackRimlightBase == null) return;

	if (boyfriend != null && (bfRimTarget != boyfriend || boyfriend.shader != bfRim)) setupBFRim();
	if (dad != null && (dadRimTarget != dad || dad.shader != dadRim)) setupDadRim();
	if (pet != null && (petRimTarget != pet || pet.shader != petRim)) setupPetRim();
}

function makeWallBPSprite(asset:String, x:Float, y:Float, layer:Int, alphaValue:Float):FlxSprite
{
	var spr = new FlxSprite(x, y);
	spr.frames = Paths.getSparrowAtlas(ext + asset);
	spr.animation.addByPrefix('bop', 'Back wall and lava', 24, true);
	if (!ClientPrefs.lowQuality) spr.animation.play('bop');
	spr.scrollFactor.set(0.8, 0.8);
	spr.zIndex = layer;
	spr.alpha = alphaValue;
	add(spr);
	return spr;
}

function applyBoilingLightBlend(value:Float):Void
{
	boilingLightProgress = Math.max(0, Math.min(1, value));
	var hotAlpha:Float = boilingLightProgress;

	// Keep the original sprite as the opaque base. Only fade the baked-light
	// copy over it; fading both sprites caused the stage to lose opacity.
	if (lava != null) lava.alpha = 1;
	if (lavaHot != null) lavaHot.alpha = hotAlpha;
	if (lava2 != null) lava2.alpha = 1;
	if (lava2Hot != null) lava2Hot.alpha = hotAlpha;

	if (ground != null) ground.alpha = boilingGroundFade;
	if (groundHot != null) groundHot.alpha = hotAlpha * boilingGroundFade;
	if (groundBroken1 != null) groundBroken1.alpha = 1;
	if (groundBroken1Hot != null) groundBroken1Hot.alpha = hotAlpha;
	if (groundBroken2 != null) groundBroken2.alpha = 1;
	if (groundBroken2Hot != null) groundBroken2Hot.alpha = hotAlpha;
	if (bubbles != null) bubbles.alpha = 1;
	if (bubblesHot != null) bubblesHot.alpha = hotAlpha;
}

function syncWallAnimation(source:FlxSprite, target:FlxSprite):Void
{
	if (source == null || target == null) return;
	if (source.animation == null || target.animation == null) return;
	if (source.animation.curAnim == null || target.animation.curAnim == null) return;
	try
	{
		if (target.animation.frameIndex != source.animation.frameIndex)
			target.animation.frameIndex = source.animation.frameIndex;
	}
	catch (e:Dynamic) {}
}

function syncBoilingWallAnimations():Void
{
	syncWallAnimation(lava, lavaHot);
	syncWallAnimation(lava, lava2);
	syncWallAnimation(lava, lava2Hot);
	syncWallAnimation(bubbles, bubblesHot);
}

function onLoad()
{
	lava = makeWallBPSprite('wallBP', 270, -330, 0, 1);
	lavaHot = makeWallBPSprite('wallBP_hot', 270, -330, 0, 0);

	lava2 = makeWallBPSprite('wallBP', 270, -330, 2, 1);
	lava2Hot = makeWallBPSprite('wallBP_hot', 270, -330, 2, 0);

	FlxTween.tween(lava, {y: -500}, 200);
	FlxTween.tween(lavaHot, {y: -500}, 200);
	FlxTween.tween(lava2, {y: -500}, 200);
	FlxTween.tween(lava2Hot, {y: -500}, 200);

	ground = new FlxSprite(1050, 650).loadGraphic(Paths.image(ext + 'platform'));
	ground.alpha = 1;
	add(ground);

	groundHot = new FlxSprite(1050, 650).loadGraphic(Paths.image(ext + 'platform_hot'));
	groundHot.alpha = 0;
	add(groundHot);

	var clip:Float = (ground.y - lava.y) + ground.height;
	lava2.clipRect = new FlxRect(0, clip, lava.width, lava.height);
	lava2Hot.clipRect = new FlxRect(0, clip, lavaHot.width, lavaHot.height);

	groundBroken1 = new FlxSprite(1050, 640).loadGraphic(Paths.image(ext + 'platform-broken-left'));
	add(groundBroken1);
	groundBroken1.visible = false;

	groundBroken1Hot = new FlxSprite(1050, 640).loadGraphic(Paths.image(ext + 'platform-broken-left_hot'));
	add(groundBroken1Hot);
	groundBroken1Hot.visible = false;

	groundBroken2 = new FlxSprite(1050, 650).loadGraphic(Paths.image(ext + 'platform-broken-right'));
	add(groundBroken2);
	groundBroken2.visible = false;

	groundBroken2Hot = new FlxSprite(1050, 650).loadGraphic(Paths.image(ext + 'platform-broken-right_hot'));
	add(groundBroken2Hot);
	groundBroken2Hot.visible = false;

	bubbles = new FlxSprite(800, 850);
	bubbles.frames = Paths.getSparrowAtlas(ext + 'bubbles');
	bubbles.animation.addByPrefix('bop', 'Lava Bubbles', 24, true);
	bubbles.animation.play('bop');
	add(bubbles);

	bubblesHot = new FlxSprite(800, 850);
	bubblesHot.frames = Paths.getSparrowAtlas(ext + 'bubbles_hot');
	bubblesHot.animation.addByPrefix('bop', 'Lava Bubbles', 24, true);
	bubblesHot.animation.play('bop');
	bubblesHot.alpha = 0;
	add(bubblesHot);

	emberEmitter = new FlxEmitter(-1200, 1000);
	for (i in 0...150)
	{
		var p = new FlxParticle();
		p.frames = Paths.getSparrowAtlas(ext + 'ember');
		p.animation.addByPrefix('ember', 'ember', 24, true);
		p.animation.play('ember');
		p.exists = false;
		p.animation.curAnim.curFrame = FlxG.random.int(0, 9);
		p.blend = BlendMode.ADD;
		p.color = 0xFFFF8A5A;
		emberEmitter.add(p);
	}

	emberEmitter.launchMode = FlxEmitterMode.SQUARE;
	emberEmitter.velocity.set(-50, -400, 50, -800, -100, 0, 100, -800);
	emberEmitter.scale.set(1, 1, 0.8, 0.8, 0, 0, 0, 0);
	emberEmitter.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
	emberEmitter.width = 4200.45;
	emberEmitter.alpha.set(1, 1);
	emberEmitter.lifespan.set(4, 4.5);

	snowEmitter = new SnowEmitter(900, -800, 2700);
	snowEmitter.start(false, ClientPrefs.lowQuality ? 0.5 : 0.5);
	snowEmitter.scrollFactor.x.set(1, 1.5);
	snowEmitter.scrollFactor.y.set(1, 1.5);
	add(snowEmitter);
	snowEmitter.alpha.active = false;
	snowEmitter.onEmit.add((particle) -> particle.alpha = snowAlpha);
	snowEmitter.zIndex = 13;

	redscreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFFF24400);
	redscreen.scrollFactor.set();
	redscreen.alpha = 0.001;
	redscreen.cameras = [camHUD];
	add(redscreen);

	emberEmitter.start(false, FlxG.random.float(0.3, 0.4), 100000);
	applyBoilingLightBlend(0);
	syncBoilingWallAnimations();
}

function onCreatePost()
{
	camSpecialThing([1760, 300], [1900, 400]);

	lavaSplash = new FlxSprite(1400, 530);
	lavaSplash.frames = Paths.getSparrowAtlas(ext + 'lava_splash');
	lavaSplash.scale.set(0.6,0.6);
	add(lavaSplash);
	lavaSplash.animation.addByPrefix('splash', 'lava splash', 24, false);
	lavaSplash.alpha = 0;

	lavaOverlay = new FlxSprite(1000, -100).loadGraphic(Paths.image(ext + 'overlaythjing'));
	lavaOverlay.scale.set(1.5, 1.5);
	lavaOverlay.blend = BlendMode.ADD;
	lavaOverlay.alpha = 0.7;
	add(lavaOverlay);

	if (!ClientPrefs.lowQuality) add(emberEmitter);

	if (ClientPrefs.bfSkin == 'bfpolus')
	{
		triggerEventNote('Change Character', 'dad', 'maroonplayableoplava');
		game.dad.x = 1050;
		game.dad.y = 330;
		triggerEventNote('Change Character', 'boyfriend', 'bf-lava');
		camSpecialThing([1760, 400], [1900, 400]);
	}

	pet.zIndex = 0;
	lavaOverlay.zIndex = 2;
	emberEmitter.zIndex = 2;
	snowEmitter.zIndex = 2;
	redscreen.zIndex = 3;

	maroonSyncEyeSprite();

	if (ClientPrefs.shaders)
	{
		blackRimlightBase = new ExtraDropShadowShader();
		blackRimlightBase.addLayer(getBaseMatrix(), 330, 25, .01, 0);

		updateRimFrame(boyfriend, bfRim);
		updateRimFrame(dad, dadRim);
		updateRimFrame(pet, petRim);
	}
}

function onSongStart()
{
	var dur = songLength / 1000;

	// Preserve the original sinking motion: characters and platforms move down
	// together over the song. The wall/lava layers stay at their original height.
	FlxTween.tween(boyfriend, {y: boyfriend.y + 133 / 2}, dur);
	FlxTween.tween(dad, {y: dad.y + 133 / 2}, dur);
	FlxTween.tween(pet, {y: pet.y + 133 / 2}, dur);
	FlxTween.tween(ground, {y: ground.y + 133 / 2}, dur);
	FlxTween.tween(groundHot, {y: groundHot.y + 133 / 2}, dur);
	FlxTween.tween(groundBroken1, {y: groundBroken1.y + 133 / 2}, dur);
	FlxTween.tween(groundBroken1Hot, {y: groundBroken1Hot.y + 133 / 2}, dur);
	FlxTween.tween(groundBroken2, {y: groundBroken2.y + 133 / 2}, dur);
	FlxTween.tween(groundBroken2Hot, {y: groundBroken2Hot.y + 133 / 2}, dur);

	if (boilingLightTween != null)
	{
		try { boilingLightTween.cancel(); } catch (e:Dynamic) {}
	}
	if (boilingGroundFadeTween != null)
	{
		try { boilingGroundFadeTween.cancel(); } catch (e:Dynamic) {}
	}
	boilingGroundFade = 1;
	applyBoilingLightBlend(0);

	boilingLightTween = FlxTween.num(0, 1, dur, {ease: FlxEase.linear}, function(progress:Float)
	{
		applyBoilingLightBlend(progress);
	});

	for (char in [boyfriend, dad, pet])
	{
		FlxTween.color(char, 2.54 * 60, FlxColor.WHITE, 0xFFFF8A98);
		tweenShadowLayer(char.shader.layers[0], [[
			8, 18, 0, -1, 0,
			0.3, 2.5, -1.5, 0, 85,
			0, -1.5, -5.5, 0, -5,
			0, 9, 0, 9, 0
		], 330, 25, .01, 0.80], songLength / 1000, FlxEase.linear);
	}
}

function onCountdownTick(tick:Int)
{
	if (tick != 0) return;
	for (i in 0...game.playerStrums.members.length) playerBaseX[i] = game.playerStrums.members[i].x;
	for (i in 0...game.opponentStrums.members.length) oppBaseX[i] = game.opponentStrums.members[i].x;
	startedSong = true;
}

function onBeatHit()
{
	if (curBeat == 220)
	{
		groundBroken1.visible = true;
		groundBroken1Hot.visible = true;
		applyBoilingLightBlend(boilingLightProgress);
	}
	if (curBeat == 256)
	{
		groundBroken2.visible = true;
		groundBroken2Hot.visible = true;
		applyBoilingLightBlend(boilingLightProgress);
	}
	if (curBeat == 288)
	{
		for (sprite in [ground, groundHot, groundBroken1, groundBroken1Hot, groundBroken2, groundBroken2Hot, dad, boyfriend, pet])
			FlxTween.cancelTweensOf(sprite);

		if (boilingGroundFadeTween != null)
		{
			try { boilingGroundFadeTween.cancel(); } catch (e:Dynamic) {}
		}
		boilingGroundFadeTween = FlxTween.num(boilingGroundFade, 0, 0.1, {ease: FlxEase.expoOut}, function(value:Float)
		{
			boilingGroundFade = value;
			applyBoilingLightBlend(boilingLightProgress);
		});

		FlxTween.tween(groundBroken1, {x: groundBroken1.x - 60}, 1, {ease: FlxEase.expoOut});
		FlxTween.tween(groundBroken1Hot, {x: groundBroken1Hot.x - 60}, 1, {ease: FlxEase.expoOut});
		FlxTween.tween(groundBroken2, {x: groundBroken2.x + 70}, 1, {ease: FlxEase.expoOut});
		FlxTween.tween(groundBroken2Hot, {x: groundBroken2Hot.x + 70}, 1, {ease: FlxEase.expoOut});
		FlxTween.tween(groundBroken1, {y: groundBroken1.y - 100}, 2, {ease: FlxEase.quadOut});
		FlxTween.tween(groundBroken1Hot, {y: groundBroken1Hot.y - 100}, 2, {ease: FlxEase.quadOut});
		FlxTween.tween(groundBroken2, {y: groundBroken2.y - 100}, 2, {ease: FlxEase.quadOut});
		FlxTween.tween(groundBroken2Hot, {y: groundBroken2Hot.y - 100}, 2, {ease: FlxEase.quadOut});
		FlxTween.tween(boyfriend, {x: boyfriend.x + 70}, 2, {ease: FlxEase.quadOut});
		FlxTween.tween(dad, {x: dad.x - 60}, 2, {ease: FlxEase.quadOut});
		FlxTween.tween(boyfriend, {y: boyfriend.y - 100}, 2, {ease: FlxEase.quadOut});
		FlxTween.tween(dad, {y: dad.y - 100}, 2, {ease: FlxEase.quadOut});
		FlxTween.tween(pet, {y: pet.y + 900}, 1, {ease: FlxEase.quadOut, startDelay: 0.3});
		new FlxTimer().start(0.3, () -> { lavaSplash.alpha = 1; lavaSplash.animation.play('splash'); });
		new FlxTimer().start(2, () ->
		{
			var curTime:Float = Math.max(0, Conductor.songPosition - ClientPrefs.noteOffset);

			FlxTween.tween(groundBroken1, {y: groundBroken1.y + 90}, 80);
			FlxTween.tween(groundBroken1Hot, {y: groundBroken1Hot.y + 90}, 80);
			FlxTween.tween(dad, {y: dad.y + 90}, 80);
			FlxTween.tween(groundBroken2, {y: groundBroken2.y + 90}, 80);
			FlxTween.tween(groundBroken2Hot, {y: groundBroken2Hot.y + 90}, 80);
			FlxTween.tween(boyfriend, {y: boyfriend.y + 90}, 80);

			FlxTween.tween(dadGroup, {angle: -10}, (songLength - curTime) / 1000);
			FlxTween.tween(groundBroken1, {angle: -10}, (songLength - curTime) / 1000);
			FlxTween.tween(groundBroken1Hot, {angle: -10}, (songLength - curTime) / 1000);

			boyfriendGroup.origin.set(0,0);
			FlxTween.tween(boyfriendGroup, {angle: 10}, (songLength - curTime) / 1000);
			FlxTween.tween(groundBroken2, {angle: 10}, (songLength - curTime) / 1000);
			FlxTween.tween(groundBroken2Hot, {angle: 10}, (songLength - curTime) / 1000);
		});
	}
}

function onUpdatePost(elapsed:Float)
{
	maroonSyncEyeSprite();
	syncBoilingWallAnimations();

	if (ClientPrefs.shaders)
	{
		checkRimAttachments();
		updateRimFrame(boyfriend, bfRim);
		updateRimFrame(dad, dadRim);
		updateRimFrame(pet, petRim);
	}

	if (!startedSong) return;
	var beat = (Conductor.songPosition / 1000) * (Conductor.bpm / 60);

	for (i in 0...game.playerStrums.members.length)
	{
		var strum = game.playerStrums.members[i];
		strum.x = playerBaseX[i] + Math.sin(beat + i * 0.5) * 15;
	}
	for (i in 0...game.opponentStrums.members.length)
	{
		var strum = game.opponentStrums.members[i];
		strum.x = oppBaseX[i] + Math.sin(beat + i * 0.5) * 15;
	}

	game.playerStrums.forEachAliveNote(function(note)
	{
		if (note.strum != null)
		{
			note.x = note.strum.x + 28;
			for (tail in note.tail)
				if (tail.strum != null) tail.x = tail.strum.x + (tail.strum.width - tail.width) / 2;
		}
	});
	game.opponentStrums.forEachAliveNote(function(note)
	{
		if (note.strum != null)
		{
			note.x = note.strum.x + 28;
			for (tail in note.tail)
				if (tail.strum != null) tail.x = tail.strum.x + (tail.strum.width - tail.width) / 2;
		}
	});
	game.playerStrums.grpNoteSplashes.forEach(function(splash)
	{
		if (splash != null && splash.exists)
		{
			var theStrum = game.playerStrums.members[splash.data];
			splash.x = theStrum.x + (theStrum.width - splash.width) * .5;
		}
	});
	game.opponentStrums.grpNoteSplashes.forEach(function(splash)
	{
		if (splash != null && splash.exists)
		{
			var theStrum = game.opponentStrums.members[splash.data];
			splash.x = theStrum.x + (theStrum.width - splash.width) * .5;
		}
	});
}

function onEvent(n, v1, v2)
{
	switch (n)
	{
		case 'Legacy':
			switch (v1)
			{
				case 'byebye':
					camSpecialThing(null, [1900, 300], 0.8);
					triggerEventNote('setChrom', '-5', '2');
					FlxTween.tween(redscreen, {alpha: 1}, 2, {ease: FlxEase.expoInOut});
			}
	}
}

function onPause()
{
	if (!ClientPrefs.shaders) return;
	checkRimAttachments();
	if (boyfriend != null && bfRim != null)
	{
		boyfriend.useRenderTexture = true;
		boyfriend.shader = bfRim;
		updateRimFrame(boyfriend, bfRim);
	}
	if (dad != null && dadRim != null)
	{
		dad.useRenderTexture = true;
		dad.shader = dadRim;
		updateRimFrame(dad, dadRim);
	}
	if (pet != null && petRim != null)
	{
		pet.useRenderTexture = true;
		pet.shader = petRim;
		updateRimFrame(pet, petRim);
	}
}

function onResume()
{
	if (!ClientPrefs.shaders) return;
	checkRimAttachments();
	if (boyfriend != null && bfRim != null)
	{
		boyfriend.useRenderTexture = true;
		boyfriend.shader = bfRim;
		updateRimFrame(boyfriend, bfRim);
	}
	if (dad != null && dadRim != null)
	{
		dad.useRenderTexture = true;
		dad.shader = dadRim;
		updateRimFrame(dad, dadRim);
	}
	if (pet != null && petRim != null)
	{
		pet.useRenderTexture = true;
		pet.shader = petRim;
		updateRimFrame(pet, petRim);
	}
}

function onSongRetry()
{
	if (boilingLightTween != null)
	{
		try { boilingLightTween.cancel(); } catch (e:Dynamic) {}
	}
	if (boilingGroundFadeTween != null)
	{
		try { boilingGroundFadeTween.cancel(); } catch (e:Dynamic) {}
	}
	boilingGroundFade = 1;
	applyBoilingLightBlend(0);

	bfRimTarget = null;
	dadRimTarget = null;
	petRimTarget = null;
	maroonDestroyEyeSplit(true);
	maroonSyncEyeSprite();
	if (!ClientPrefs.shaders) return;
	if (blackRimlightBase == null) return;
	setupBFRim();
	setupDadRim();
	setupPetRim();
}

function onGameOver()
{
	maroonDestroyEyeSplit(true);
	if (boilingLightTween != null)
	{
		try { boilingLightTween.cancel(); } catch (e:Dynamic) {}
	}
	if (boilingGroundFadeTween != null)
	{
		try { boilingGroundFadeTween.cancel(); } catch (e:Dynamic) {}
	}
	if (boyfriend != null) boyfriend.shader = null;
	if (dad != null) dad.shader = null;
	if (pet != null) pet.shader = null;
	bfRimTarget = null;
	dadRimTarget = null;
	petRimTarget = null;
}

function onDestroy()
{
	if (boilingLightTween != null)
	{
		try { boilingLightTween.cancel(); } catch (e:Dynamic) {}
	}
	if (boilingGroundFadeTween != null)
	{
		try { boilingGroundFadeTween.cancel(); } catch (e:Dynamic) {}
	}
	maroonDestroyEyeSplit(true);
}
