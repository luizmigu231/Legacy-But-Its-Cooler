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
var lava2:FlxSprite;
var ground:FlxSprite;
var groundBroken1:FlxSprite;
var groundBroken2:FlxSprite;
var bubbles:FlxSprite;
var lavaSplash:FlxSprite;
var playerBaseX:Array<Float> = [];
var oppBaseX:Array<Float> = [];
var startedSong:Bool = false;

var blackRimlightBase:ExtraDropShadowShader;
var bfRim:ExtraDropShadowShader;
var dadRim:ExtraDropShadowShader;
var petRim:ExtraDropShadowShader;
var bfRimTarget:FlxSprite;
var dadRimTarget:FlxSprite;
var petRimTarget:FlxSprite;

// Maroon eye split: keep the eyes out of dad's shader render and draw them separately.
var maroonEyeSprite:FunkinSprite = null;
var maroonEyeFrames:FlxAnimateFrames = null;
var maroonEyeTarget:Dynamic = null;
var maroonEyeAttemptTarget:Dynamic = null;
var maroonEyeGroup:Dynamic = null;
var maroonEyeAddedToState:Bool = false;
var maroonEyeAnim:String = '';
var maroonHiddenObjects:Array<Dynamic> = [];
var maroonHiddenValues:Array<Bool> = [];
var maroonHiddenFrames:Array<Dynamic> = [];
var maroonPoseSymbols:Array<String> = ['idle', 'left', 'up', 'right', 'down'];
var maroonEyeElementNames:Array<String> = ['guh', 'glow shit'];

function maroonNameOf(element:Dynamic):String
{
	try
	{
		if (element != null && element.libraryItem != null && element.libraryItem.name != null)
			return '' + element.libraryItem.name;
	}
	catch (e:Dynamic) {}
	return '';
}

function maroonIsEyeElement(element:Dynamic):Bool
{
	return maroonEyeElementNames.indexOf(maroonNameOf(element)) != -1;
}

function maroonRemember(obj:Dynamic, frame:Dynamic = null):Void
{
	if (obj == null || maroonHiddenObjects.indexOf(obj) != -1) return;
	try
	{
		maroonHiddenObjects.push(obj);
		maroonHiddenValues.push(obj.visible);
		maroonHiddenFrames.push(frame);
	}
	catch (e:Dynamic) {}
}

function maroonDirtyFrame(frame:Dynamic):Void
{
	if (frame == null) return;
	try { frame.setDirty(); } catch (e:Dynamic) {}
}

function maroonInvalidateRender(sprite:Dynamic):Void
{
	if (sprite == null) return;
	try { Reflect.setField(sprite, '_renderTextureDirty', true); } catch (e:Dynamic) {}
}

function maroonFilterTimeline(timeline:Dynamic, eyeOnly:Bool):Bool
{
	if (timeline == null || timeline.layers == null) return false;
	var anyChanged:Bool = false;

	for (layer in timeline.layers)
	{
		if (layer == null || layer.frames == null) continue;

		var hasEyes:Bool = false;
		var hasOther:Bool = false;
		for (frame in layer.frames)
		{
			if (frame == null || frame.elements == null) continue;
			for (element in frame.elements)
			{
				if (maroonIsEyeElement(element)) hasEyes = true;
				else hasOther = true;
			}
		}

		if (eyeOnly)
		{
			var wantedLayerVisible:Bool = hasEyes;
			if (layer.visible != wantedLayerVisible)
			{
				layer.visible = wantedLayerVisible;
				anyChanged = true;
			}

			for (frame in layer.frames)
			{
				if (frame == null || frame.elements == null) continue;
				var frameChanged:Bool = false;
				for (element in frame.elements)
				{
					var wantedVisible:Bool = maroonIsEyeElement(element);
					if (element.visible != wantedVisible)
					{
						element.visible = wantedVisible;
						frameChanged = true;
						anyChanged = true;
					}
				}
				if (frameChanged) maroonDirtyFrame(frame);
			}
			continue;
		}

		if (!hasEyes) continue;
		if (!hasOther)
		{
			if (layer.visible)
			{
				maroonRemember(layer, null);
				layer.visible = false;
				anyChanged = true;
			}
			continue;
		}

		for (frame in layer.frames)
		{
			if (frame == null || frame.elements == null) continue;
			var frameChanged:Bool = false;
			for (element in frame.elements)
			{
				if (!maroonIsEyeElement(element) || !element.visible) continue;
				maroonRemember(element, frame);
				element.visible = false;
				frameChanged = true;
				anyChanged = true;
			}
			if (frameChanged) maroonDirtyFrame(frame);
		}
	}
	return anyChanged;
}

function maroonFilterPose(library:Dynamic, symbolName:String, eyeOnly:Bool):Void
{
	if (library == null) return;
	var item:Dynamic = null;
	try { item = library.getSymbol(symbolName); } catch (e:Dynamic) {}
	if (item == null || item.timeline == null) return;
	maroonFilterTimeline(item.timeline, eyeOnly);
}

function maroonRestoreOriginalEyes():Void
{
	for (i in 0...maroonHiddenObjects.length)
	{
		try { maroonHiddenObjects[i].visible = maroonHiddenValues[i]; } catch (e:Dynamic) {}
		if (i < maroonHiddenFrames.length && maroonHiddenFrames[i] != null)
			maroonDirtyFrame(maroonHiddenFrames[i]);
	}
	maroonHiddenObjects = [];
	maroonHiddenValues = [];
	maroonHiddenFrames = [];
	if (maroonEyeTarget != null) maroonInvalidateRender(maroonEyeTarget);
}

function maroonAddEyeAnim(animName:String, symbolName:String, fps:Int, looped:Bool):Void
{
	if (maroonEyeSprite == null) return;
	try { maroonEyeSprite.addAnimByPrefix(animName, symbolName, fps, looped); } catch (e:Dynamic) {}
}

function maroonCopyAnimDefinitions():Void
{
	if (dad == null || maroonEyeSprite == null || dad.animations == null) return;

	for (data in dad.animations)
	{
		if (data == null) continue;
		var animName:String = data.anim == null ? '' : '' + data.anim;
		var symbolName:String = data.name == null ? '' : '' + data.name;
		if (animName.length == 0 || symbolName.length == 0) continue;
		var fps:Int = data.fps == null ? 24 : data.fps;
		var looped:Bool = data.loop == true;
		var flipX:Bool = data.flipX == true;
		var flipY:Bool = data.flipY == true;
		try
		{
			if (!maroonEyeSprite.hasAnim(animName))
			{
				maroonEyeSprite.addAnimByPrefix(animName, symbolName, fps, looped, flipX, flipY);
				if (data.offsets != null && data.offsets.length > 1)
					maroonEyeSprite.addOffset(animName, data.offsets[0], data.offsets[1]);
				else maroonEyeSprite.addOffset(animName, 0, 0);
			}
		}
		catch (e:Dynamic) {}
	}

	// Known exported symbols in the Maroon atlas. These fallbacks ensure that
	// the overlay can follow Legacy's standard sing animation names.
	maroonAddEyeAnim('idle', 'idle', 24, true);
	maroonAddEyeAnim('singLEFT', 'left', 24, false);
	maroonAddEyeAnim('singDOWN', 'down', 24, false);
	maroonAddEyeAnim('singUP', 'up', 24, false);
	maroonAddEyeAnim('singRIGHT', 'right', 24, false);
	maroonAddEyeAnim('singLEFT-loop', 'left', 24, true);
	maroonAddEyeAnim('singDOWN-loop', 'down', 24, true);
	maroonAddEyeAnim('singUP-loop', 'up', 24, true);
	maroonAddEyeAnim('singRIGHT-loop', 'right', 24, true);
}

function maroonSyncEyeSprite():Void
{
	if (maroonEyeSprite == null || maroonEyeTarget == null || dad == null || dad != maroonEyeTarget) return;

	var wanted:String = '';
	try { wanted = dad.getAnimName(); } catch (e:Dynamic) {}
	if (wanted == null || wanted.length == 0) wanted = 'idle';

	var currentName:String = '';
	try
	{
		if (maroonEyeSprite.animation != null && maroonEyeSprite.animation.curAnim != null)
			currentName = maroonEyeSprite.animation.curAnim.name;
	}
	catch (e:Dynamic) {}

	if (maroonEyeSprite.hasAnim(wanted) == false)
	{
		if (wanted.indexOf('LEFT') != -1) wanted = 'singLEFT';
		else if (wanted.indexOf('DOWN') != -1) wanted = 'singDOWN';
		else if (wanted.indexOf('UP') != -1) wanted = 'singUP';
		else if (wanted.indexOf('RIGHT') != -1) wanted = 'singRIGHT';
		else wanted = 'idle';
	}

	if (currentName != wanted)
	{
		try { maroonEyeSprite.playAnim(wanted, true); } catch (e:Dynamic) {}
		maroonEyeAnim = wanted;
	}

	try
	{
		if (dad.animation != null && dad.animation.curAnim != null && maroonEyeSprite.animation != null && maroonEyeSprite.animation.curAnim != null && maroonEyeSprite.animation.frameIndex != dad.animation.frameIndex)
			maroonEyeSprite.animation.frameIndex = dad.animation.frameIndex;
	}
	catch (e:Dynamic) {}

	maroonEyeSprite.x = dad.x;
	maroonEyeSprite.y = dad.y;
	maroonEyeSprite.scale.set(dad.scale.x, dad.scale.y);
	maroonEyeSprite.angle = dad.angle;
	maroonEyeSprite.flipX = dad.flipX;
	maroonEyeSprite.flipY = dad.flipY;
	maroonEyeSprite.origin.copyFrom(dad.origin);
	maroonEyeSprite.offset.copyFrom(dad.offset);
	maroonEyeSprite.scrollFactor.set(dad.scrollFactor.x, dad.scrollFactor.y);
	maroonEyeSprite.alpha = dad.alpha;
	maroonEyeSprite.color = dad.color;
	maroonEyeSprite.antialiasing = dad.antialiasing;
	maroonEyeSprite.cameras = dad.cameras;
	maroonEyeSprite.visible = dad.visible && dad.exists && dad.active;
	maroonEyeSprite.shader = null;
	maroonEyeSprite.useRenderTexture = false;
	try { maroonEyeSprite.skew.copyFrom(dad.skew); } catch (e:Dynamic) {}
	try { maroonEyeSprite.spriteOffset.copyFrom(dad.spriteOffset); } catch (e:Dynamic) {}
	try { maroonEyeSprite.animOffset.copyFrom(dad.animOffset); } catch (e:Dynamic) {}
	try { maroonEyeSprite.baseScale.copyFrom(dad.baseScale); } catch (e:Dynamic) {}
	try { maroonEyeSprite.baseFlipX = dad.baseFlipX; } catch (e:Dynamic) {}
	try { maroonEyeSprite.baseFlipY = dad.baseFlipY; } catch (e:Dynamic) {}
	try { maroonEyeSprite.scalableOffsets = dad.scalableOffsets; } catch (e:Dynamic) {}
	try { maroonEyeSprite.rotatableOffsets = dad.rotatableOffsets; } catch (e:Dynamic) {}
	try { maroonEyeSprite.skewableOffsets = dad.skewableOffsets; } catch (e:Dynamic) {}
	try { maroonEyeSprite.applyStageMatrix = dad.applyStageMatrix; } catch (e:Dynamic) {}
	try { maroonEyeSprite.postStageMatrixApply = dad.postStageMatrixApply; } catch (e:Dynamic) {}
}

function maroonDestroyEyeSplit(restore:Bool = true):Void
{
	if (restore) maroonRestoreOriginalEyes();

	if (maroonEyeSprite != null)
	{
		try
		{
			if (maroonEyeGroup != null) maroonEyeGroup.remove(maroonEyeSprite, true);
			else if (maroonEyeAddedToState && FlxG.state != null) FlxG.state.remove(maroonEyeSprite, true);
		}
		catch (e:Dynamic) {}
		try { maroonEyeSprite.destroy(); } catch (e:Dynamic) {}
	}
	maroonEyeSprite = null;
	maroonEyeFrames = null;
	maroonEyeTarget = null;
	maroonEyeGroup = null;
	maroonEyeAddedToState = false;
	maroonEyeAnim = '';
}

function setupMaroonEyeSplit():Void
{
	if (dad == null || dad.library == null) return;
	if (maroonEyeTarget == dad && maroonEyeSprite != null) return;
	if (maroonEyeAttemptTarget == dad) return;

	maroonDestroyEyeSplit(true);
	maroonEyeAttemptTarget = dad;

	var testGuh:Dynamic = null;
	var testGlow:Dynamic = null;
	try { testGuh = dad.library.getSymbol('guh'); } catch (e:Dynamic) {}
	try { testGlow = dad.library.getSymbol('glow shit'); } catch (e:Dynamic) {}
	if (testGuh == null || testGlow == null) return;

	var atlasPath:String = '';
	try { atlasPath = Paths.getPath('images/' + dad.imageFile, PathsTestMode.LOOSE); } catch (e:Dynamic) {}
	if (atlasPath == null || atlasPath.length == 0) return;

	try
	{
		// unique=true is important: filtering this copy must not change dad's source library.
		maroonEyeFrames = FlxAnimateFrames.fromAnimate(atlasPath, null, null, 'maroon_stage_eye_overlay', true, {cacheOnLoad: false});
	}
	catch (e:Dynamic)
	{
		maroonEyeFrames = null;
	}
	if (maroonEyeFrames == null) return;

	maroonEyeTarget = dad;
	for (symbolName in maroonPoseSymbols)
	{
		maroonFilterPose(dad.library, symbolName, false);
		maroonFilterPose(maroonEyeFrames, symbolName, true);
	}
	maroonInvalidateRender(dad);

	maroonEyeSprite = new FunkinSprite(dad.x, dad.y);
	maroonEyeSprite.frames = maroonEyeFrames;
	maroonEyeSprite.shader = null;
	maroonEyeSprite.useRenderTexture = false;
	maroonEyeSprite.antialiasing = dad.antialiasing;
	maroonEyeSprite.applyStageMatrix = dad.applyStageMatrix;
	maroonEyeSprite.postStageMatrixApply = dad.postStageMatrixApply;
	maroonCopyAnimDefinitions();

	var hasIdle:Bool = false;
	try { hasIdle = maroonEyeSprite.hasAnim('idle'); } catch (e:Dynamic) {}
	if (!hasIdle)
	{
		try { maroonEyeSprite.addAnimByPrefix('idle', 'idle', 24, true); } catch (e:Dynamic) {}
		try { hasIdle = maroonEyeSprite.hasAnim('idle'); } catch (e:Dynamic) {}
	}
	if (!hasIdle)
	{
		maroonDestroyEyeSplit(true);
		return;
	}

	maroonEyeTarget = dad;
	maroonEyeGroup = null;
	maroonEyeAddedToState = false;
	try
	{
		if (game != null && game.dadGroup != null)
		{
			maroonEyeGroup = game.dadGroup;
			maroonEyeGroup.add(maroonEyeSprite);
		}
	}
	catch (e:Dynamic) { maroonEyeGroup = null; }

	if (maroonEyeGroup == null && FlxG.state != null)
	{
		try
		{
			FlxG.state.add(maroonEyeSprite);
			maroonEyeAddedToState = true;
		}
		catch (e:Dynamic) {}
	}

	// Keep the unshaded eye overlay above the character in Legacy's z sorting.
	try { maroonEyeSprite.zIndex = dad.zIndex + 100; } catch (e:Dynamic) {}
	try { maroonEyeSprite.shader = null; } catch (e:Dynamic) {}
	try { maroonEyeSprite.useRenderTexture = false; } catch (e:Dynamic) {}
	maroonSyncEyeSprite();
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

function onLoad()
{
	lava = new FlxSprite(270, -330);
	lava.frames = Paths.getSparrowAtlas(ext + 'wallBP');
	lava.animation.addByPrefix('bop', 'Back wall and lava', 24, true);
	if (!ClientPrefs.lowQuality) lava.animation.play('bop');
	lava.scrollFactor.set(0.8, 0.8);
	add(lava);

	lava2 = new FlxSprite(270, -330);
	lava2.frames = Paths.getSparrowAtlas(ext + 'wallBP');
	lava2.animation.addByPrefix('bop', 'Back wall and lava', 24, true);
	if (!ClientPrefs.lowQuality) lava2.animation.play('bop');
	lava2.scrollFactor.set(0.8, 0.8);
	lava2.zIndex = 2;
	add(lava2);

	FlxTween.tween(lava, {y: -500}, 200);
	FlxTween.tween(lava2, {y: -500}, 200);

	ground = new FlxSprite(1050, 650).loadGraphic(Paths.image(ext + 'platform'));
	ground.alpha = 1;
	add(ground);

	var clip:Float = (ground.y - lava.y) + ground.height;
	lava2.clipRect = new FlxRect(0, clip, lava.width, lava.height);

	groundBroken1 = new FlxSprite(1050, 640).loadGraphic(Paths.image(ext + 'platform-broken-left'));
	add(groundBroken1);

	groundBroken2 = new FlxSprite(1050, 650).loadGraphic(Paths.image(ext + 'platform-broken-right'));
	add(groundBroken2);
	groundBroken1.visible = groundBroken2.visible = false;

	bubbles = new FlxSprite(800, 850);
	bubbles.frames = Paths.getSparrowAtlas(ext + 'bubbles');
	bubbles.animation.addByPrefix('bop', 'Lava Bubbles', 24, true);
	bubbles.animation.play('bop');
	add(bubbles);

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

	// Split eyes after any stage-specific Change Character event has run.
	setupMaroonEyeSplit();

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

	FlxTween.tween(boyfriend, {y: boyfriend.y + 133 / 2}, dur);
	FlxTween.tween(dad, {y: dad.y + 133 / 2}, dur);
	FlxTween.tween(pet, {y: pet.y + 133 / 2}, dur);
	FlxTween.tween(ground, {y: ground.y + 133 / 2}, dur);
	FlxTween.tween(groundBroken1, {y: groundBroken1.y + 133 / 2}, dur);
	FlxTween.tween(groundBroken2, {y: groundBroken2.y + 133 / 2}, dur);

	for (sprite in [lava, lava2, ground, groundBroken1, groundBroken2, bubbles])
		FlxTween.color(sprite, dur, FlxColor.WHITE, 0xFFFF8A5A);
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
		FlxTween.tween(groundBroken1, {"alpha": 1}, 0.1, {ease: FlxEase.expoOut});
	}
	if (curBeat == 256)
	{
		groundBroken2.visible = true;
		FlxTween.tween(groundBroken2, {"alpha": 1}, 0.1, {ease: FlxEase.expoOut});
	}
	if (curBeat == 288)
	{
		FlxTween.cancelTweensOf(ground);
		FlxTween.cancelTweensOf(groundBroken1);
		FlxTween.cancelTweensOf(groundBroken2);
		FlxTween.cancelTweensOf(dad);
		FlxTween.cancelTweensOf(boyfriend);
		FlxTween.cancelTweensOf(pet);
		FlxTween.tween(ground, {"alpha": 0}, 0.1, {ease: FlxEase.expoOut});
		FlxTween.tween(groundBroken1, {"x": groundBroken1.x - 60}, 1, {ease: FlxEase.expoOut});
		FlxTween.tween(groundBroken2, {"x": groundBroken2.x + 70}, 1, {ease: FlxEase.expoOut});
		FlxTween.tween(groundBroken1, {"y": groundBroken1.y - 100}, 2, {ease: FlxEase.quadOut});
		FlxTween.tween(groundBroken2, {"y": groundBroken2.y - 100}, 2, {ease: FlxEase.quadOut});
		FlxTween.tween(boyfriend, {"x": boyfriend.x + 70}, 2, {ease: FlxEase.quadOut});
		FlxTween.tween(dad, {"x": dad.x - 60}, 2, {ease: FlxEase.quadOut});
		FlxTween.tween(boyfriend, {"y": boyfriend.y - 100}, 2, {ease: FlxEase.quadOut});
		FlxTween.tween(dad, {"y": dad.y - 100}, 2, {ease: FlxEase.quadOut});
		FlxTween.tween(pet, {"y": pet.y + 900}, 1, {ease: FlxEase.quadOut, startDelay: 0.3});
		new FlxTimer().start(0.3, ()-> { lavaSplash.alpha = 1; lavaSplash.animation.play('splash'); });
		new FlxTimer().start(2, () ->
		{
			var curTime:Float = Math.max(0, Conductor.songPosition - ClientPrefs.noteOffset);

			FlxTween.tween(groundBroken1, {"y": groundBroken1.y + 90}, 80);
			FlxTween.tween(dad, {"y": dad.y + 90}, 80);
			FlxTween.tween(groundBroken2, {"y": groundBroken2.y + 90}, 80);
			FlxTween.tween(boyfriend, {"y": boyfriend.y + 90}, 80);
	
			FlxTween.tween(dadGroup, {"angle": -10}, (songLength - curTime) / 1000);
			FlxTween.tween(groundBroken1, {"angle": -10}, (songLength - curTime) / 1000);
	
			boyfriendGroup.origin.set(0,0);
			FlxTween.tween(boyfriendGroup, {"angle": 10}, (songLength - curTime) / 1000);
			FlxTween.tween(groundBroken2, {"angle": 10}, (songLength - curTime) / 1000);
		});
	}
}

function onUpdatePost(elapsed:Float)
{
	if (maroonEyeTarget != dad && maroonEyeAttemptTarget != dad) setupMaroonEyeSplit();
	maroonSyncEyeSprite();

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
	bfRimTarget = null;
	dadRimTarget = null;
	petRimTarget = null;
	if (maroonEyeTarget != dad)
	{
		maroonEyeAttemptTarget = null;
		setupMaroonEyeSplit();
	}
	else maroonSyncEyeSprite();
	if (!ClientPrefs.shaders) return;
	if (blackRimlightBase == null) return;
	setupBFRim();
	setupDadRim();
	setupPetRim();
}

function onGameOver()
{
	if (boyfriend != null) boyfriend.shader = null;
	if (dad != null) dad.shader = null;
	if (pet != null) pet.shader = null;
	bfRimTarget = null;
	dadRimTarget = null;
	petRimTarget = null;
}

function onDestroy()
{
	maroonDestroyEyeSplit(true);
}
