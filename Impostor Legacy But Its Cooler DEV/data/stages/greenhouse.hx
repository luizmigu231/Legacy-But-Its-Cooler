import funkin.game.shaders.ColorSwap;
import flixel.effects.particles.FlxEmitterMode;
import flixel.math.FlxRect;
import flixel.addons.effects.FlxSkewedSprite;

public var ext:String = 'stages/mira/greenhouse/';

public var greymira:FlxSprite;
public var longus:FlxSprite;
public var tomato:FlxSprite;
public var ventNotSus:FlxSprite;
public var rhmmira:FlxSprite;

var bluemira:FlxSprite;
var pot:FlxSprite;
var vines:FlxSprite;
var heartEmitter:FlxEmitter;
var heartEmitterHUD:FlxEmitter;
var heartsImage:FlxSprite;
var heartsImageRight:FlxSprite;
var heartsLayoutWidth:Float = -1;
var heartsLayoutHeight:Float = -1;
var pinkVignette:FlxSprite;
var pinkVignette2:FlxSprite;
var pinkHUDVignette:FlxSprite;
var pinkHUDOverlay:FlxSprite;
var vignetteTween:FlxTween;
var whiteTween:FlxTween;
var pinkHUDTween:FlxTween;
var pinkHUDOverlayTween:FlxTween;
var pinkVignette2Tween:FlxTween;
var heartsImageTween:FlxTween;
var sunRiseTween:FlxTween;
var sunRiseStartY:Float = 0;
var sunRiseTargetY:Float = 0;
var sunRiseActive:Bool = false;
var futureTransitionStep:Int = 785;
var stageRimEntries:Array<Dynamic> = [];
var stageColorEntries:Array<Dynamic> = [];
var rimTransitionPhase:Int = 0;
var rimTransitionTime:Float = 0;
var rimTransitionStarted:Bool = false;
var rimMatrixStartStep:Int = -1;
var rimTransitionDuration:Float = 1;
var combosPadding:Float = 0;
var pinkCanPulse:Bool = false;
var heartColorShader:ColorSwap;

var cloud1:FlxSprite;
var cloud2:FlxSprite;
var cloud3:FlxSprite;
var cloud4:FlxSprite;
var cloudbig:FlxSprite;
var greenhouseSky:FlxSprite;
var greenhouseSun:FlxSprite;
var greenhouseCloudfar:FlxSprite;
var greenhouseCloudfront:FlxSprite;
var greenhouseCloudFill:FlxSprite;
var greenhouseGlasses:FlxSprite;
var greenhouseMystery:FlxSprite;
var greenhouseLmao:FlxSprite;
var greenhouseHelp:FlxSprite;

var SHADOW_ENABLED:Bool = true;
var SHADOW_CAST_STAGE_CHARACTERS:Bool = true;
var SHADOW_CAST_PLAY_CHARACTERS:Bool = true;
var SHADOW_CAST_GF:Bool = true;
var SHADOW_DISTANCE:Float = -2;
var SHADOW_ANGLE:Float = 0;
var SHADOW_PROJECTION_ANGLE_BF:Float = 28;
var SHADOW_PROJECTION_SKEW_Y_BF:Float = 0;
var SHADOW_PROJECTION_ANGLE_DAD:Float = -28;
var SHADOW_PROJECTION_SKEW_Y_DAD:Float = 0;
var SHADOW_PROJECTION_ANGLE_GF:Float = 28;
var SHADOW_PROJECTION_SKEW_Y_GF:Float = 0;
var SHADOW_PROJECTION_ANGLE_GREYMIRA:Float = 0;
var SHADOW_PROJECTION_SKEW_Y_GREYMIRA:Float = 0;
var SHADOW_PROJECTION_ANGLE_LONGUS:Float = 28;
var SHADOW_PROJECTION_SKEW_Y_LONGUS:Float = 0;
var SHADOW_PROJECTION_ANGLE_TOMATO:Float = 28;
var SHADOW_PROJECTION_SKEW_Y_TOMATO:Float = 0;
var SHADOW_PROJECTION_ANGLE_POT:Float = 28;
var SHADOW_PROJECTION_SKEW_Y_POT:Float = 0;
var SHADOW_PROJECTION_ANGLE_PRETENDER:Float = 28;
var SHADOW_PROJECTION_SKEW_Y_PRETENDER:Float = 0;
var SHADOW_PROJECTION_ANGLE_BLUEMIRA:Float = 28;
var SHADOW_PROJECTION_SKEW_Y_BLUEMIRA:Float = 0;
var SHADOW_PROJECTION_ANGLE_RHM:Float = 28;
var SHADOW_PROJECTION_SKEW_Y_RHM:Float = 0;
var SHADOW_SCALE_X:Float = 0.96;
var SHADOW_SCALE_Y:Float = 0.45;
var SHADOW_OFFSET_X:Float = 0;
var SHADOW_OFFSET_Y:Float = 0;
var SHADOW_ALPHA:Float = 0.68;
var SHADOW_COLOR_R:Float = 0;
var SHADOW_COLOR_G:Float = 0;
var SHADOW_COLOR_B:Float = 0;
var SHADOW_ANCHOR_ADJUST_BF:Float = -50;
var SHADOW_ANCHOR_ADJUST_DAD:Float = -100;
var SHADOW_ANCHOR_ADJUST_GF:Float = -15;
var SHADOW_ANCHOR_ADJUST_GREYMIRA:Float = -10;
var SHADOW_ANCHOR_ADJUST_LONGUS:Float = 0;
var SHADOW_ANCHOR_ADJUST_TOMATO:Float = 0;
var SHADOW_ANCHOR_ADJUST_PRETENDER:Float = 0;
var SHADOW_ANCHOR_ADJUST_BLUEMIRA:Float = 0;
var SHADOW_ANCHOR_ADJUST_RHM:Float = 0;
var silhouetteShadowShader:Dynamic = null;
var silhouetteShadowEntries:Array<Dynamic> = [];

function interpolateRimMatrix(from:Array<Float>, to:Array<Float>, progress:Float):Array<Float>
{
	var result:Array<Float> = [];
	for (i in 0...20)
		result.push(from[i] + (to[i] - from[i]) * progress);
	return result;
}

function interpolateStageColor(from:Int, to:Int, progress:Float):Int
{
	var r1:Int = (from >> 16) & 0xFF;
	var g1:Int = (from >> 8) & 0xFF;
	var b1:Int = from & 0xFF;
	var r2:Int = (to >> 16) & 0xFF;
	var g2:Int = (to >> 8) & 0xFF;
	var b2:Int = to & 0xFF;
	var r:Int = Std.int(r1 + (r2 - r1) * progress);
	var g:Int = Std.int(g1 + (g2 - g1) * progress);
	var b:Int = Std.int(b1 + (b2 - b1) * progress);
	return 0xFF000000 | (r << 16) | (g << 8) | b;
}

function registerStageColor(sprite:FlxSprite, targetColor:Int)
{
	if (sprite == null)
		return;
	stageColorEntries.push({sprite: sprite, startColor: sprite.color, targetColor: targetColor});
}

function updateStageColors(progress:Float)
{
	for (entry in stageColorEntries)
	{
		if (entry.sprite != null)
			entry.sprite.color = interpolateStageColor(entry.startColor, entry.targetColor, progress);
	}
}

function createStageRims(sprite:FlxSprite, ?rimType:String = 'object')
{
	if (sprite == null || !ClientPrefs.shaders)
		return;

	var targetLayer1Angle:Float = 20;
	var targetLayer1Distance:Float = 18;
	var targetLayer2Angle:Float = 120;
	var targetLayer2Distance:Float = 25;
	if (rimType == 'gf')
	{
		targetLayer1Angle = 60;
		targetLayer1Distance = 25;
		targetLayer2Angle = 120;
		targetLayer2Distance = 25;
	}
	else if (rimType == 'character')
	{
		targetLayer1Angle = 120;
		targetLayer1Distance = 25;
		targetLayer2Angle = 120;
		targetLayer2Distance = 25;
	}

	var rim = new funkin.game.shaders.ExtraDropShadowShader();
	var baseMatrix:Array<Float> = [
		0.3, 0.2, 0, 0, 9,
		-0.5, 0.77, 0.2, 0, 13,
		0, -0.1, 0.69, 0, 20,
		0, 0, 0, 1, 0
	];
	var rimLayerMatrix:Array<Float> = [
		1.10, 0.02, 0.00, 0, 15,
		0.04, 0.72, 0.00, 0, 7,
		0.00, 0.02, 0.32, 0, 0,
		0.00, 0.00, 0.00, 1, 0
	];
	rim.setColorMatrix(baseMatrix.copy());
	rim.threshold = 0.02;
	rim.strength = 0.7;
	var layer1 = rim.addLayer(rimLayerMatrix.copy(), 90, 15, 0.01, 0.38);
	var layer2 = rim.addLayer(rimLayerMatrix.copy(), 90, 25, 0.01, 0.18);
	rim.attachedSprite = sprite;
	stageRimEntries.push({
		shader: rim,
		baseMatrix: baseMatrix.copy(),
		layerMatrix1: rimLayerMatrix.copy(),
		layerMatrix2: rimLayerMatrix.copy(),
		layer1: layer1,
		layer2: layer2,
		baseThreshold: 0.02,
		baseStrength: 0.7,
		layer1Angle: 90.0,
		layer1Distance: 15.0,
		layer1Threshold: 0.01,
		layer1Strength: 0.38,
		layer2Angle: 90.0,
		layer2Distance: 25.0,
		layer2Threshold: 0.01,
		layer2Strength: 0.18,
		targetLayer1Angle: targetLayer1Angle,
		targetLayer1Distance: targetLayer1Distance,
		targetLayer2Angle: targetLayer2Angle,
		targetLayer2Distance: targetLayer2Distance
	});
}

function startRimTransition()
{
	if (rimTransitionStarted || (stageRimEntries.length <= 0 && stageColorEntries.length <= 0))
		return;

	rimTransitionStarted = true;
	rimTransitionPhase = 1;
	rimTransitionTime = 0;
}

function updateRimTransition(elapsed:Float)
{
	if (rimTransitionPhase <= 0 || (stageRimEntries.length <= 0 && stageColorEntries.length <= 0))
		return;

	rimTransitionTime += elapsed;
	var p:Float = Math.max(0, Math.min(1, rimTransitionTime / rimTransitionDuration));
	if (rimTransitionPhase == 2)
	{
		if (rimMatrixStartStep < 0)
			rimMatrixStartStep = curStep;
		var matrixSteps:Int = 900 - rimMatrixStartStep;
		p = (matrixSteps <= 0) ? 1 : Math.max(0, Math.min(1, (curStep - rimMatrixStartStep) / matrixSteps));
	}
	var targetBaseMatrix:Array<Float> = [
		1, 0, 0, 0, 0,
		0, 1, 0, 0, 0,
		0, 0, 1, 0, 0,
		0, 0, 0, 1, 0
	];
	var targetLayerMatrix:Array<Float> = [
		1.35, 0, 0, 0, 0,
		0, 0.92, 0, 0, 0,
		0, 0, 0.98, 0, 0,
		0, 0, 0, 1, 0
	];

	if (rimTransitionPhase == 2)
		updateStageColors(p);

	for (entry in stageRimEntries)
	{
		var rim = entry.shader;
		var layer1 = entry.layer1;
		var layer2 = entry.layer2;

		if (rim == null || layer1 == null || layer2 == null)
			continue;

		if (rimTransitionPhase == 1)
		{
			layer1.strength = entry.layer1Strength * (1 - p);
			layer2.strength = entry.layer2Strength * (1 - p);
		}
		else if (rimTransitionPhase == 2)
		{
			rim.setColorMatrix(interpolateRimMatrix(entry.baseMatrix, targetBaseMatrix, p));
			layer1.colorMatrix = interpolateRimMatrix(entry.layerMatrix1, targetLayerMatrix, p);
			layer2.colorMatrix = interpolateRimMatrix(entry.layerMatrix2, targetLayerMatrix, p);
			rim.threshold = entry.baseThreshold + (0.035 - entry.baseThreshold) * p;
			rim.strength = entry.baseStrength + (0.55 - entry.baseStrength) * p;
			layer1.angle = entry.layer1Angle + (entry.targetLayer1Angle - entry.layer1Angle) * p;
			layer1.distance = entry.layer1Distance + (entry.targetLayer1Distance - entry.layer1Distance) * p;
			layer1.threshold = entry.layer1Threshold + (0.025 - entry.layer1Threshold) * p;
			layer2.angle = entry.layer2Angle + (entry.targetLayer2Angle - entry.layer2Angle) * p;
			layer2.distance = entry.layer2Distance + (entry.targetLayer2Distance - entry.layer2Distance) * p;
			layer2.threshold = entry.layer2Threshold + (0.025 - entry.layer2Threshold) * p;
			layer1.strength = 0;
			layer2.strength = 0;
		}
		else if (rimTransitionPhase == 3)
		{
			layer1.strength = p;
			layer2.strength = p;
		}
	}

	if (p >= 1)
	{
		rimTransitionTime = 0;
		if (rimTransitionPhase == 1)
		{
			for (entry in stageRimEntries)
			{
				if (entry.layer1 != null) entry.layer1.strength = 0;
				if (entry.layer2 != null) entry.layer2.strength = 0;
			}
			rimTransitionPhase = 2;
			rimMatrixStartStep = curStep;
			rimTransitionTime = 0;
		}
		else if (rimTransitionPhase == 2)
		{
			for (entry in stageRimEntries)
			{
				if (entry.shader != null)
				{
					entry.shader.setColorMatrix(targetBaseMatrix.copy());
					entry.shader.threshold = 0.035;
					entry.shader.strength = 0.55;
				}
				if (entry.layer1 != null)
				{
					entry.layer1.colorMatrix = targetLayerMatrix.copy();
					entry.layer1.angle = entry.targetLayer1Angle;
					entry.layer1.distance = entry.targetLayer1Distance;
					entry.layer1.threshold = 0.025;
					entry.layer1.strength = 0;
				}
				if (entry.layer2 != null)
				{
					entry.layer2.colorMatrix = targetLayerMatrix.copy();
					entry.layer2.angle = entry.targetLayer2Angle;
					entry.layer2.distance = entry.targetLayer2Distance;
					entry.layer2.threshold = 0.025;
					entry.layer2.strength = 0;
				}
			}
			rimTransitionPhase = 3;
		}
		else
			rimTransitionPhase = 0;
	}
}

function layoutHeartsHUD()
{
	if (heartsImage == null || heartsImageRight == null)
		return;

	heartsImage.x = -25;
	heartsImageRight.x = FlxG.width - heartsImageRight.frameWidth;
	heartsImage.scrollFactor.set(0, 0);
	heartsImageRight.scrollFactor.set(0, 0);
	heartsLayoutWidth = FlxG.width;
	heartsLayoutHeight = FlxG.height;
}

function getSilhouetteShadowColor():Int
{
	var r:Int = Std.int(Math.max(0, Math.min(1, SHADOW_COLOR_R)) * 255);
	var g:Int = Std.int(Math.max(0, Math.min(1, SHADOW_COLOR_G)) * 255);
	var b:Int = Std.int(Math.max(0, Math.min(1, SHADOW_COLOR_B)) * 255);
	return 0xFF000000 | (r << 16) | (g << 8) | b;
}

function initializeSilhouetteShadowShader()
{
	silhouetteShadowShader = null;
	if (!ClientPrefs.shaders)
		return;

	var shaderCode:String = Paths.getTextFromFile('shaders/Shadow.frag');
	if (shaderCode == null || shaderCode.length == 0)
		return;

	silhouetteShadowShader = new FlxRuntimeShader(shaderCode);
	silhouetteShadowShader.setFloatArray('col', [SHADOW_COLOR_R, SHADOW_COLOR_G, SHADOW_COLOR_B]);
	silhouetteShadowShader.setFloat('amount', 1);
}

function getShadowTransformedOffset(sprite:Dynamic, animateAtlas:Bool):Array<Float>
{
	var ox:Float = 0;
	var oy:Float = 0;
	if (!animateAtlas)
		return [0, 0];

	if (sprite.spriteOffset != null)
	{
		ox += sprite.spriteOffset.x;
		oy += sprite.spriteOffset.y;
	}
	if (sprite.animOffset != null)
	{
		ox += sprite.animOffset.x;
		oy += sprite.animOffset.y;
	}

	if (sprite.scalableOffsets)
	{
		var baseX:Float = (sprite.baseScale != null && sprite.baseScale.x != 0) ? sprite.baseScale.x : 1;
		var baseY:Float = (sprite.baseScale != null && sprite.baseScale.y != 0) ? sprite.baseScale.y : 1;
		ox *= sprite.scale.x / baseX;
		oy *= sprite.scale.y / baseY;
	}

	if (sprite.rotatableOffsets && Math.abs(sprite.angle % 360) > 0.0001)
	{
		var radians:Float = sprite.angle * Math.PI / 180;
		var oldX:Float = ox;
		var oldY:Float = oy;
		ox = oldX * Math.cos(radians) - oldY * Math.sin(radians);
		oy = oldX * Math.sin(radians) + oldY * Math.cos(radians);
	}

	if (sprite.skewableOffsets && sprite.skew != null && (sprite.skew.x != 0 || sprite.skew.y != 0))
	{
		var oldX:Float = ox;
		var oldY:Float = oy;
		ox += oldY * Math.tan(sprite.skew.x * Math.PI / 180);
		 oy += oldX * Math.tan(sprite.skew.y * Math.PI / 180);
	}
	return [ox, oy];
}

function getShadowProjectionAngle(slot:String):Float
{
	return switch (slot)
	{
		case 'boyfriend': SHADOW_PROJECTION_ANGLE_BF;
		case 'dad': SHADOW_PROJECTION_ANGLE_DAD;
		case 'gf': SHADOW_PROJECTION_ANGLE_GF;
		case 'greymira': SHADOW_PROJECTION_ANGLE_GREYMIRA;
		case 'longus': SHADOW_PROJECTION_ANGLE_LONGUS;
		case 'tomato': SHADOW_PROJECTION_ANGLE_TOMATO;
		case 'pot': SHADOW_PROJECTION_ANGLE_POT;
		case 'pretender': SHADOW_PROJECTION_ANGLE_PRETENDER;
		case 'bluemira': SHADOW_PROJECTION_ANGLE_BLUEMIRA;
		case 'rhm': SHADOW_PROJECTION_ANGLE_RHM;
		default: 28;
	};
}

function getShadowProjectionSkewY(slot:String):Float
{
	return switch (slot)
	{
		case 'boyfriend': SHADOW_PROJECTION_SKEW_Y_BF;
		case 'dad': SHADOW_PROJECTION_SKEW_Y_DAD;
		case 'gf': SHADOW_PROJECTION_SKEW_Y_GF;
		case 'greymira': SHADOW_PROJECTION_SKEW_Y_GREYMIRA;
		case 'longus': SHADOW_PROJECTION_SKEW_Y_LONGUS;
		case 'tomato': SHADOW_PROJECTION_SKEW_Y_TOMATO;
		case 'pot': SHADOW_PROJECTION_SKEW_Y_POT;
		case 'pretender': SHADOW_PROJECTION_SKEW_Y_PRETENDER;
		case 'bluemira': SHADOW_PROJECTION_SKEW_Y_BLUEMIRA;
		case 'rhm': SHADOW_PROJECTION_SKEW_Y_RHM;
		default: 0;
	};
}

function getShadowAnchorAdjust(slot:String):Float
{
	return switch (slot)
	{
		case 'boyfriend': SHADOW_ANCHOR_ADJUST_BF;
		case 'dad': SHADOW_ANCHOR_ADJUST_DAD;
		case 'gf': SHADOW_ANCHOR_ADJUST_GF;
		case 'greymira': SHADOW_ANCHOR_ADJUST_GREYMIRA;
		case 'longus': SHADOW_ANCHOR_ADJUST_LONGUS;
		case 'tomato': SHADOW_ANCHOR_ADJUST_TOMATO;
		case 'pretender': SHADOW_ANCHOR_ADJUST_PRETENDER;
		case 'bluemira': SHADOW_ANCHOR_ADJUST_BLUEMIRA;
		case 'rhm': SHADOW_ANCHOR_ADJUST_RHM;
		default: 0;
	};
}

function updateSilhouetteShadowAnchor(target:Dynamic, shadow:Dynamic, slot:String, animateAtlas:Bool)
{
	var frameW:Float = target.frameWidth;
	var frameH:Float = target.frameHeight;
	if (frameW <= 0)
		frameW = (target.scale.x != 0) ? target.width / target.scale.x : target.width;
	if (frameH <= 0)
		frameH = (target.scale.y != 0) ? target.height / target.scale.y : target.height;

	var sourceOriginX:Float = target.origin.x;
	var sourceOriginY:Float = target.origin.y;
	var localX:Float = frameW * 0.5;
	var localY:Float = target.flipY ? 0 : frameH;
	var dx:Float = (localX - sourceOriginX) * target.scale.x;
	var dy:Float = (localY - sourceOriginY) * target.scale.y;

	if (Math.abs(target.angle % 360) > 0.0001)
	{
		var radians:Float = target.angle * Math.PI / 180;
		var oldX:Float = dx;
		var oldY:Float = dy;
		dx = oldX * Math.cos(radians) - oldY * Math.sin(radians);
		dy = oldX * Math.sin(radians) + oldY * Math.cos(radians);
	}

	if (animateAtlas && target.skew != null && (target.skew.x != 0 || target.skew.y != 0))
	{
		var oldX:Float = dx;
		var oldY:Float = dy;
		dx += oldY * Math.tan(target.skew.x * Math.PI / 180);
		dy += oldX * Math.tan(target.skew.y * Math.PI / 180);
	}

	var sourceOffset:Array<Float> = getShadowTransformedOffset(target, animateAtlas);
	var shadowOffset:Array<Float> = getShadowTransformedOffset(shadow, animateAtlas);
	var sourceAnchorX:Float = target.x - target.offset.x + sourceOriginX + dx - sourceOffset[0];
	var sourceAnchorY:Float = target.y - target.offset.y + sourceOriginY + dy - sourceOffset[1];

	shadow.origin.set(shadow.frameWidth * 0.5, 0);
	shadow.x = sourceAnchorX + shadow.offset.x - shadow.origin.x + shadowOffset[0] + SHADOW_OFFSET_X;
	shadow.y = sourceAnchorY + shadow.offset.y - shadow.origin.y + shadowOffset[1] + SHADOW_DISTANCE + SHADOW_OFFSET_Y + getShadowAnchorAdjust(slot);
}

function createSilhouetteShadow(target:Dynamic, container:Dynamic, slot:String, animateAtlas:Bool)
{
	if (target == null || target.frames == null || container == null || container.members == null)
		return;

	var shadow:Dynamic = null;
	if (animateAtlas)
	{
		shadow = new funkin.objects.FunkinSprite(target.x, target.y);
		if (target.imageFile != null && target.imageFile.length > 0)
			shadow.loadAtlas(target.imageFile, null, PathsTestMode.LOOSE);
		else
			shadow.frames = target.frames;
		shadow.copyAnimController(target.animation);
		if (target.animation != null && target.animation.curAnim != null)
		{
			var sourceAnim = target.animation.curAnim;
			shadow.animation.play(sourceAnim.name, true, sourceAnim.reversed, sourceAnim.curFrame);
		}
	}
	else
	{
		shadow = new FlxSkewedSprite(target.x, target.y);
		shadow.frames = target.frames;
		shadow.frame = target.frame;
	}

	shadow.active = false;
	shadow.antialiasing = target.antialiasing;
	shadow.cameras = target.cameras;
	shadow.scrollFactor.set(target.scrollFactor.x, target.scrollFactor.y);
	shadow.flipX = target.flipX;
	shadow.flipY = !target.flipY;
	shadow.origin.set(shadow.frameWidth * 0.5, 0);
	shadow.offset.set(target.offset.x, target.offset.y);
	shadow.angle = target.angle + SHADOW_ANGLE;
	shadow.alpha = SHADOW_ALPHA;

	if (animateAtlas)
	{
		shadow.spriteOffset.set(target.spriteOffset.x, target.spriteOffset.y);
		shadow.animOffset.set(target.animOffset.x, target.animOffset.y);
		shadow.baseScale.set(target.baseScale.x, target.baseScale.y);
		shadow.scalableOffsets = target.scalableOffsets;
		shadow.rotatableOffsets = target.rotatableOffsets;
		shadow.skewableOffsets = target.skewableOffsets;
		shadow.baseFlipX = target.baseFlipX;
		shadow.baseFlipY = target.baseFlipY;
		shadow.skew.set(target.skew.x + getShadowProjectionAngle(slot), target.skew.y + getShadowProjectionSkewY(slot));
		shadow.color = 0xFFFFFFFF;
	}
	else
		shadow.skew.set(getShadowProjectionAngle(slot), getShadowProjectionSkewY(slot));

	if (silhouetteShadowShader != null)
	{
		shadow.shader = silhouetteShadowShader;
		shadow.color = 0xFFFFFFFF;
	}
	else
		shadow.color = getSilhouetteShadowColor();

	shadow.scale.set(target.scale.x * SHADOW_SCALE_X, target.scale.y * SHADOW_SCALE_Y);
	shadow.updateHitbox();
	shadow.origin.set(shadow.frameWidth * 0.5, 0);

	var parent:Dynamic = container;
	var index:Int = parent.members.indexOf(target);
	if (index >= 0)
		parent.insert(index, shadow);
	else
		parent.add(shadow);

	var sourceAnimName:String = '';
	if (animateAtlas && target.animation != null && target.animation.curAnim != null)
		sourceAnimName = target.animation.curAnim.name;

	silhouetteShadowEntries.push({
		source: target,
		sprite: shadow,
		container: parent,
		slot: slot,
		animateAtlas: animateAtlas,
		lastFrame: target.frame,
		lastFrames: target.frames,
		lastImageFile: (animateAtlas ? target.imageFile : ''),
		lastAnimName: sourceAnimName,
		lastScaleX: target.scale.x * SHADOW_SCALE_X,
		lastScaleY: target.scale.y * SHADOW_SCALE_Y
	});
}

function createStageSilhouetteShadows()
{
	initializeSilhouetteShadowShader();
	if (!SHADOW_ENABLED)
		return;

	if (SHADOW_CAST_STAGE_CHARACTERS)
	{
		createSilhouetteShadow(greymira, stage, 'greymira', false);
		createSilhouetteShadow(longus, stage, 'longus', false);
		createSilhouetteShadow(tomato, stage, 'tomato', false);
		createSilhouetteShadow(pot, stage, 'pot', false);
		createSilhouetteShadow(ventNotSus, stage, 'pretender', false);
		createSilhouetteShadow(bluemira, stage, 'bluemira', false);
		createSilhouetteShadow(rhmmira, stage, 'rhm', false);
	}

	if (SHADOW_CAST_PLAY_CHARACTERS)
	{
		if (boyfriend != null && boyfriendGroup != null)
			createSilhouetteShadow(boyfriend, boyfriendGroup, 'boyfriend', true);
		if (dad != null && dadGroup != null)
			createSilhouetteShadow(dad, dadGroup, 'dad', true);
		if (SHADOW_CAST_GF && gf != null && gfGroup != null)
			createSilhouetteShadow(gf, gfGroup, 'gf', true);
	}
}

function onLoad()
{
	heartColorShader = new ColorSwap();

	greenhouseSky = new FlxSprite(-1500, -800).loadGraphic(Paths.image(ext + 'bg sky'));
	greenhouseSky.antialiasing = ClientPrefs.globalAntialiasing;
	greenhouseSky.cameras = [camGame];
	greenhouseSky.scrollFactor.set(0.8, 0.8);
	add(greenhouseSky);

	greenhouseSun = new FlxSprite(-400, -1100).loadGraphic(Paths.image(ext + 'the sun'));
	greenhouseSun.cameras = [camGame];
	greenhouseSun.scrollFactor.set(0.8, 0.8);
	greenhouseSun.blend = BlendMode.ADD;
	add(greenhouseSun);

	pinkVignette = new FlxSprite(0, 0).loadGraphic(Paths.image(ext + 'vignette'));
	pinkVignette.camera = camHUD;
	pinkVignette.alpha = 0.0001;
	pinkVignette.setGraphicSize(Std.int(FlxG.width * 1.05), Std.int(FlxG.height * 1.05));
	pinkVignette.updateHitbox();
	pinkVignette.antialiasing = true;
	pinkVignette.blend = BlendMode.ADD;

	pinkVignette2 = new FlxSprite(0, 0).loadGraphic(Paths.image(ext + 'vignette2'));
	pinkVignette2.cameras = [camHUD];
	pinkVignette2.alpha = 0.0001;
	pinkVignette2.setGraphicSize(Std.int(FlxG.width * 1.05), Std.int(FlxG.height * 1.05));
	pinkVignette2.updateHitbox();
	pinkVignette2.antialiasing = true;
	add(pinkVignette2);
	add(pinkVignette);

	pinkHUDVignette = new FlxSprite(0, 0).loadGraphic(Paths.image(ext + 'vignette'));
	pinkHUDVignette.cameras = [camOther];
	pinkHUDVignette.setGraphicSize(Std.int(FlxG.width * 1.05), Std.int(FlxG.height * 1.05));
	pinkHUDVignette.updateHitbox();
	pinkHUDVignette.setPosition((FlxG.width - pinkHUDVignette.width) / 2, (FlxG.height - pinkHUDVignette.height) / 2);
	pinkHUDVignette.scrollFactor.set(0, 0);
	pinkHUDVignette.alpha = 0;
	pinkHUDVignette.antialiasing = ClientPrefs.globalAntialiasing;
	pinkHUDVignette.blend = BlendMode.ADD;
	add(pinkHUDVignette);

	pinkHUDOverlay = new FlxSprite(0, 0);
	pinkHUDOverlay.cameras = [camOther];
	pinkHUDOverlay.makeGraphic(FlxG.width, FlxG.height, 0x00FF69B4);
	pinkHUDOverlay.scrollFactor.set(0, 0);
	pinkHUDOverlay.alpha = 0;
	pinkHUDOverlay.blend = BlendMode.ADD;
	add(pinkHUDOverlay);

	heartsImage = new FlxSprite(0, 0);
	heartsImage.cameras = [camOther];
	heartsImage.frames = Paths.getSparrowAtlas(ext + 'hearts');
	heartsImage.animation.addByPrefix('boil', 'Symbol 2', 24, true);
	heartsImage.animation.play('boil');
	heartsImage.clipRect = new FlxRect(0, 0, heartsImage.frameWidth / 2, heartsImage.frameHeight);
	heartsImage.antialiasing = ClientPrefs.globalAntialiasing;
	heartsImage.alpha = 0.0001;
	heartsImage.shader = heartColorShader.shader;
	add(heartsImage);

	heartsImageRight = new FlxSprite(0, 0);
	heartsImageRight.cameras = [camOther];
	heartsImageRight.frames = Paths.getSparrowAtlas(ext + 'hearts');
	heartsImageRight.animation.addByPrefix('boil', 'Symbol 2', 24, true);
	heartsImageRight.animation.play('boil');
	heartsImageRight.clipRect = new FlxRect(heartsImageRight.frameWidth / 2, 0, heartsImageRight.frameWidth / 2, heartsImageRight.frameHeight);
	heartsImageRight.antialiasing = ClientPrefs.globalAntialiasing;
	heartsImageRight.alpha = 0.0001;
	heartsImageRight.shader = heartColorShader.shader;
	add(heartsImageRight);
	layoutHeartsHUD();

	var cloudBack:FlxSprite = new FlxSprite(-1300, -100).loadGraphic(Paths.image(ext + 'cloud fathest'));
	cloudBack.antialiasing = ClientPrefs.globalAntialiasing;
	greenhouseCloudfar = cloudBack;
	add(cloudBack);

	greenhouseCloudFill = new FlxSprite(-1300, cloudBack.y + cloudBack.height).makeGraphic(1, 1, 0xffc0dbff);
	greenhouseCloudFill.setGraphicSize(Std.int(cloudBack.width), 200);
	greenhouseCloudFill.updateHitbox();
	add(greenhouseCloudFill);

	greenhouseCloudfront = new FlxSprite(-1300, 0).loadGraphic(Paths.image(ext + 'cloud front'));
	greenhouseCloudfront.antialiasing = ClientPrefs.globalAntialiasing;
	add(greenhouseCloudfront);

	cloud1 = new FlxBackdrop(Paths.image(ext + 'cloud 1'), FlxAxes.X, 2209);
	cloud1.setPosition(1196, -1000 + 904);
	cloud1.antialiasing = ClientPrefs.globalAntialiasing;
	cloud1.velocity.x = -9;
	add(cloud1);

	cloud2 = new FlxBackdrop(Paths.image(ext + 'cloud 2'), FlxAxes.X, 2209);
	cloud2.setPosition(100, -1200 + 1052);
	cloud2.antialiasing = ClientPrefs.globalAntialiasing;
	cloud2.velocity.x = -27;
	add(cloud2);

	cloud3 = new FlxBackdrop(Paths.image(ext + 'cloud 3'), FlxAxes.X, 2209);
	cloud3.setPosition(792, -1400 + 1364);
	cloud3.antialiasing = ClientPrefs.globalAntialiasing;
	cloud3.velocity.x = -18;
	add(cloud3);

	cloud4 = new FlxBackdrop(Paths.image(ext + 'cloud 4'), FlxAxes.X, 2209);
	cloud4.setPosition(1750, -1600 + 1167);
	cloud4.antialiasing = ClientPrefs.globalAntialiasing;
	cloud4.velocity.x = -0.9;
	add(cloud4);

	cloudbig = new FlxBackdrop(Paths.image(ext + 'bigcloud'), FlxAxes.X, 2209);
	cloudbig.setPosition(1356, -1200 + 1192);
	cloudbig.antialiasing = ClientPrefs.globalAntialiasing;
	cloudbig.velocity.x = -4.5;
	add(cloudbig);

	greenhouseGlasses = new FlxSprite(-1200, -750).loadGraphic(Paths.image(ext + 'glasses'));
	greenhouseGlasses.antialiasing = ClientPrefs.globalAntialiasing;
	add(greenhouseGlasses);

	greymira = new FlxSprite(-550, -40);
	greymira.frames = Paths.getMultiAtlas([ext + 'gray_squidboy84_eggus_ghostus', ext + 'gray_squidboy84_eggus_ghostus_animation']);
	greymira.animation.addByPrefix('bop', 'gray, squidboy84 & eggus ghosus0', 18, false);
	greymira.animation.addByPrefix('anim', 'gray, squidboy84 & eggus ghosus animation', 12, false);
	greymira.animation.play('bop');
	greymira.scale.set(0.78, 0.8);
	greymira.antialiasing = ClientPrefs.globalAntialiasing;
	add(greymira);

	longus = new FlxSprite(745, -45);
	longus.frames = Paths.getSparrowAtlas(ext + 'longus');
	longus.animation.addByPrefix('bop', 'longus0', 24, false);
	longus.animation.addByPrefix('anim', 'longus anim0', 24, false);
	longus.animation.play('bop');
	longus.animation.onFrameChange.add((animName, frameNumber, frameIndex) -> {
		if (animName == 'anim')
			longus.offset.set(475, -4);
	});
	longus.antialiasing = ClientPrefs.globalAntialiasing;
	add(longus);

	tomato = new FlxSprite(936, 195);
	tomato.frames = Paths.getSparrowAtlas(ext + 'tomato');
	tomato.animation.addByPrefix('bop', 'tomato0', 24, false);
	tomato.animation.addByPrefix('anim', 'tomatongus anim0', 24, false);
	tomato.animation.play('bop');
	tomato.animation.onFrameChange.add((animName, frameNumber, frameIndex) -> {
		if (animName == 'anim')
			tomato.offset.set(153, 43);
	});
	tomato.antialiasing = ClientPrefs.globalAntialiasing;
	add(tomato);

	ventNotSus = new FlxSprite(-100, -200);
	ventNotSus.frames = Paths.getSparrowAtlas(ext + 'black_pretender');
	ventNotSus.animation.addByPrefix('anim', 'black', 24, false);
	ventNotSus.antialiasing = ClientPrefs.globalAntialiasing;
	add(ventNotSus);

	greenhouseMystery = new FlxSprite(0, -650).loadGraphic(Paths.image(ext + 'what is this'));
	add(greenhouseMystery);
	greenhouseLmao = new FlxSprite(-900, -10).loadGraphic(Paths.image(ext + 'lmao'));
	add(greenhouseLmao);
	greenhouseHelp = new FlxSprite(1200, 140).loadGraphic(Paths.image(ext + 'help'));
	add(greenhouseHelp);

	rhmmira = new FlxSprite(1050, 125);
	rhmmira.frames = Paths.getSparrowAtlas(ext + 'crew');
	rhmmira.animation.addByPrefix('bop', 'RHM', 24, false);
	rhmmira.animation.play('bop');
	rhmmira.antialiasing = true;
	rhmmira.scrollFactor.set(1.2, 1);

	bluemira = new FlxSprite(-1350, 0);
	bluemira.frames = Paths.getSparrowAtlas(ext + 'crew');
	bluemira.animation.addByPrefix('bop', 'blue', 24, false);
	bluemira.animation.play('bop');
	bluemira.antialiasing = true;
	bluemira.scrollFactor.set(1.2, 1);

	pot = new FlxSprite(-1550, 650).loadGraphic(Paths.image(ext + 'front pot'));
	pot.antialiasing = true;
	pot.setGraphicSize(Std.int(pot.width * 1));
	pot.updateHitbox();
	pot.scrollFactor.set(1.2, 1);

	vines = new FlxSprite(-1200, -1200);
	vines.frames = Paths.getSparrowAtlas(ext + 'vines');
	vines.animation.addByPrefix('bop', 'green', 24, true);
	vines.animation.play('bop');
	vines.antialiasing = ClientPrefs.globalAntialiasing;
	vines.scrollFactor.set(1.4, 1);

	heartEmitter = new FlxEmitter(-1200, 1000);
	for (i in 0...50)
	{
		var particle = new FlxParticle();
		particle.frames = Paths.getSparrowAtlas(ext + 'littleheart');
		particle.animation.addByPrefix('littleheart', 'littleheart', 24, true);
		particle.animation.play('littleheart');
		particle.exists = false;
		particle.animation.curAnim.curFrame = FlxG.random.int(0, 2);
		particle.shader = heartColorShader.shader;
		heartEmitter.add(particle);
	}
	heartEmitter.launchMode = FlxEmitterMode.SQUARE;
	heartEmitter.velocity.set(-50, -400, 50, -800, -100, 0, 100, -800);
	heartEmitter.scale.set(3.4, 3.4, 3.4, 3.4, 0, 0, 0, 0);
	heartEmitter.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
	heartEmitter.width = 4200.45;
	heartEmitter.alpha.set(1, 1);
	heartEmitter.lifespan.set(4, 4.5);
	heartEmitter.start(false, FlxG.random.float(0.6, 0.8), 50000);
	heartEmitter.emitting = false;

	heartEmitterHUD = new FlxEmitter(0, FlxG.height);
	heartEmitterHUD.cameras = [camOther];
	for (i in 0...25)
	{
		var particle = new FlxParticle();
		particle.frames = Paths.getSparrowAtlas(ext + 'littleheart');
		particle.animation.addByPrefix('littleheart', 'littleheart', 24, true);
		particle.animation.play('littleheart');
		particle.exists = false;
		particle.animation.curAnim.curFrame = FlxG.random.int(0, 2);
		particle.shader = heartColorShader.shader;
		particle.cameras = [camOther];
		particle.scrollFactor.set(0, 0);
		heartEmitterHUD.add(particle);
	}
	heartEmitterHUD.launchMode = FlxEmitterMode.SQUARE;
	heartEmitterHUD.velocity.set(-35, -180, 35, -320, -25, 0, 25, -320);
	heartEmitterHUD.scale.set(1.2, 1.2, 1.2, 1.2, 0, 0, 0, 0);
	heartEmitterHUD.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
	heartEmitterHUD.width = FlxG.width;
	heartEmitterHUD.alpha.set(0.65, 0.9);
	heartEmitterHUD.lifespan.set(2.5, 3.5);
	heartEmitterHUD.start(false, 0.24, 50000);
	heartEmitterHUD.emitting = false;

	greenhouseSky.color = 0xFFFF7777;
	greenhouseSun.color = 0xFFFFA06A;
	greenhouseCloudfar.color = 0xFF963F47;
	greenhouseCloudfront.color = 0xFFA4464E;
	greenhouseCloudFill.color = 0xFFFF7777;
	cloud1.color = 0xFF9B424A;
	cloud2.color = 0xFF914049;
	cloud3.color = 0xFF9F4149;
	cloud4.color = 0xFF89363F;
	cloudbig.color = 0xFF924049;
	greenhouseGlasses.color = 0xFFE95761;
	greenhouseMystery.color = 0xFFFF8580;
	greenhouseLmao.color = 0xFFE84A55;
	greenhouseHelp.color = 0xFFE84A55;
	greymira.color = 0xFFFF6262;
	longus.color = 0xFFFF6262;
	tomato.color = 0xFFFF6262;
	ventNotSus.color = 0xFFFF6262;
	bluemira.color = 0xFF8A3943;
	rhmmira.color = 0xFFFF6262;
	pot.color = 0xFFE54852;
	vines.color = 0xFFE54852;
}

function onCreatePost()
{
	if (ClientPrefs.bfSkin == 'pinkplayable')
	{
		triggerEventNote('Change Character', 'dad', 'minigreyopscary');
		triggerEventNote('Change Character', 'boyfriend', 'pinkplayable');
		game.dad.x = -300;
		game.dad.y = 350;
	}

	if (ClientPrefs.gfSkin == 'blackspeaker')
	{
		triggerEventNote('Change Character', 'gf', 'blackspeaker');
		gf.flipX = true;
	}

	if (dad != null) dad.useRenderTexture = true;
	if (boyfriend != null) boyfriend.useRenderTexture = true;
	if (gf != null) gf.useRenderTexture = true;
	if (hasPet && pet != null) pet.useRenderTexture = true;

	add(bluemira);
	add(rhmmira);
	add(pot);
	add(vines);
	add(heartEmitter);
	add(heartEmitterHUD);

	if (dad != null) dad.color = 0xFFFF6B70;
	if (gf != null) gf.color = 0xFFFF6B70;
	if (boyfriend != null) boyfriend.color = 0xFFFF6B70;
	if (hasPet && pet != null) pet.color = 0xFFFF6B70;

	createStageSilhouetteShadows();

	if (ClientPrefs.shaders)
	{
		createStageRims(greenhouseMystery, 'object');
		createStageRims(greenhouseLmao, 'object');
		createStageRims(greenhouseHelp, 'object');
		createStageRims(greymira, 'object');
		createStageRims(longus, 'object');
		createStageRims(tomato, 'object');
		createStageRims(ventNotSus, 'object');
		createStageRims(bluemira, 'object');
		createStageRims(rhmmira, 'object');
		createStageRims(pot, 'object');
		createStageRims(vines, 'object');
		createStageRims(dad, 'character');
		createStageRims(gf, 'gf');
		createStageRims(boyfriend, 'character');
		if (hasPet && pet != null)
			createStageRims(pet, 'character');
	}

	stageColorEntries = [];
	registerStageColor(greenhouseSky, 0xFFFFFFFF);
	registerStageColor(greenhouseSun, 0xFFFFFFFF);
	registerStageColor(greenhouseCloudfar, 0xFF963F47);
	registerStageColor(greenhouseCloudfront, 0xFFA4464E);
	registerStageColor(greenhouseCloudFill, 0xFF963F47);
	registerStageColor(cloud1, 0xFF9B424A);
	registerStageColor(cloud2, 0xFF914049);
	registerStageColor(cloud3, 0xFF9F4149);
	registerStageColor(cloud4, 0xFF89363F);
	registerStageColor(cloudbig, 0xFF924049);
	registerStageColor(greenhouseGlasses, 0xFF713039);
	registerStageColor(greymira, 0xFF8A3943);
	registerStageColor(longus, 0xFF8A3943);
	registerStageColor(tomato, 0xFF8A3943);
	registerStageColor(ventNotSus, 0xFF8A3943);
	registerStageColor(bluemira, 0xFF8A3943);
	registerStageColor(rhmmira, 0xFF8A3943);
	registerStageColor(pot, 0xFF6D282F);
	registerStageColor(vines, 0xFF512128);
	registerStageColor(dad, 0xFF8A3943);
	registerStageColor(gf, 0xFF8A3943);
	registerStageColor(boyfriend, 0xFF8A3943);
	if (hasPet && pet != null)
		registerStageColor(pet, 0xFF8A3943);

	snapCamToPos(450, 300);
	camSpecialThing([160, 200], [380, 200], 0.5);
}

function onUpdate(elapsed:Float)
{
	updateRimTransition(elapsed);

	if (sunRiseActive && greenhouseSun != null)
	{
		var progress:Float = Math.max(0, Math.min(1, curStep / 900));
		greenhouseSun.y = sunRiseStartY + (sunRiseTargetY - sunRiseStartY) * progress;
		if (curStep >= 900)
			sunRiseActive = false;
	}

	if (FlxG.width != heartsLayoutWidth || FlxG.height != heartsLayoutHeight)
	{
		layoutHeartsHUD();
		if (heartEmitterHUD != null)
		{
			heartEmitterHUD.setPosition(0, FlxG.height);
			heartEmitterHUD.width = FlxG.width;
		}
	}
}

function onUpdatePost(elapsed:Float)
{
	updateSilhouetteShadows();
}

function updateSilhouetteShadows()
{
	for (entry in silhouetteShadowEntries)
	{
		var target:Dynamic = entry.source;
		var shadow:Dynamic = entry.sprite;
		if (entry.slot == 'boyfriend')
			target = boyfriend;
		else if (entry.slot == 'dad')
			target = dad;
		else if (entry.slot == 'gf')
			target = gf;

		if (target == null || !target.exists || target.frames == null)
		{
			shadow.visible = false;
			continue;
		}

		if (entry.animateAtlas && (entry.lastImageFile != target.imageFile || entry.lastFrames != target.frames))
		{
			if (target.imageFile != null && target.imageFile.length > 0)
				shadow.loadAtlas(target.imageFile, null, PathsTestMode.LOOSE);
			else
				shadow.frames = target.frames;
			shadow.copyAnimController(target.animation);
			entry.lastImageFile = target.imageFile;
			entry.lastFrames = target.frames;
			entry.lastAnimName = '';
		}
		else if (!entry.animateAtlas && entry.lastFrames != target.frames)
		{
			shadow.frames = target.frames;
			entry.lastFrames = target.frames;
			entry.lastFrame = null;
		}

		if (entry.source != target)
		{
			entry.source = target;
			var parent:Dynamic = entry.container;
			var targetIndex:Int = parent.members.indexOf(target);
			var shadowIndex:Int = parent.members.indexOf(shadow);
			if (targetIndex >= 0 && shadowIndex >= 0 && shadowIndex > targetIndex)
			{
				parent.remove(shadow, false);
				parent.insert(parent.members.indexOf(target), shadow);
			}
			entry.lastFrame = null;
		}

		shadow.visible = SHADOW_ENABLED && target.visible;
		shadow.alpha = SHADOW_ALPHA * target.alpha;
		if (!shadow.visible)
			continue;

		if (entry.animateAtlas)
		{
			if (target.animation != null && target.animation.curAnim != null)
			{
				var sourceAnim = target.animation.curAnim;
				if (entry.lastAnimName != sourceAnim.name || shadow.animation == null || shadow.animation.curAnim == null)
				{
					shadow.animation.play(sourceAnim.name, true, sourceAnim.reversed, sourceAnim.curFrame);
					entry.lastAnimName = sourceAnim.name;
				}
				if (shadow.animation.curAnim != null)
				{
					shadow.animation.curAnim.curFrame = sourceAnim.curFrame;
					shadow.animation.frameIndex = target.animation.frameIndex;
				}
			}

			shadow.spriteOffset.set(target.spriteOffset.x, target.spriteOffset.y);
			shadow.animOffset.set(target.animOffset.x, target.animOffset.y);
			shadow.baseScale.set(target.baseScale.x, target.baseScale.y);
			shadow.scalableOffsets = target.scalableOffsets;
			shadow.rotatableOffsets = target.rotatableOffsets;
			shadow.skewableOffsets = target.skewableOffsets;
			shadow.baseFlipX = target.baseFlipX;
			shadow.baseFlipY = target.baseFlipY;
			shadow.skew.set(target.skew.x + getShadowProjectionAngle(entry.slot), target.skew.y + getShadowProjectionSkewY(entry.slot));
		}
		else if (entry.lastFrame != target.frame)
		{
			shadow.frame = target.frame;
			entry.lastFrame = target.frame;
		}

		if (!entry.animateAtlas)
			shadow.skew.set(getShadowProjectionAngle(entry.slot), getShadowProjectionSkewY(entry.slot));

		shadow.flipX = target.flipX;
		shadow.flipY = !target.flipY;
		shadow.offset.set(target.offset.x, target.offset.y);
		shadow.scrollFactor.set(target.scrollFactor.x, target.scrollFactor.y);
		shadow.cameras = target.cameras;
		shadow.angle = target.angle + SHADOW_ANGLE;

		var wantedScaleX:Float = target.scale.x * SHADOW_SCALE_X;
		var wantedScaleY:Float = target.scale.y * SHADOW_SCALE_Y;
		if (entry.lastScaleX != wantedScaleX || entry.lastScaleY != wantedScaleY)
		{
			shadow.scale.set(wantedScaleX, wantedScaleY);
			shadow.updateHitbox();
			entry.lastScaleX = wantedScaleX;
			entry.lastScaleY = wantedScaleY;
		}
		shadow.origin.set(shadow.frameWidth * 0.5, 0);
		updateSilhouetteShadowAnchor(target, shadow, entry.slot, entry.animateAtlas);
	}
}

function onStepHit()
{
	if (curStep == futureTransitionStep)
		startRimTransition();
}

function onBeatHit()
{
	if (curBeat % 2 == (curSong == 'Pinkwave' ? 0 : 1) && pinkCanPulse)
	{
		if (pinkVignette != null)
		{
			if (vignetteTween != null)
				vignetteTween.cancel();
			pinkVignette.alpha = 1;
			vignetteTween = FlxTween.tween(pinkVignette, {alpha: 0.2}, 1.2, {ease: FlxEase.sineOut});
		}
		if (pinkHUDVignette != null)
		{
			if (pinkHUDTween != null)
				pinkHUDTween.cancel();
			pinkHUDVignette.alpha = 0.65;
			pinkHUDTween = FlxTween.tween(pinkHUDVignette, {alpha: 0.12}, 1.2, {ease: FlxEase.sineOut});
		}
		if (pinkHUDOverlay != null)
		{
			if (pinkHUDOverlayTween != null)
				pinkHUDOverlayTween.cancel();
			pinkHUDOverlay.alpha = 0.12;
			pinkHUDOverlayTween = FlxTween.tween(pinkHUDOverlay, {alpha: 0.025}, 1.2, {ease: FlxEase.sineOut});
		}
		if (whiteTween != null)
			whiteTween.cancel();
		heartColorShader.flash = 0.5;
		whiteTween = FlxTween.tween(heartColorShader, {flash: 0}, 0.75, {ease: FlxEase.sineOut});
	}

	if (!inCutscene)
	{
		if (curBeat % 2 == 0)
		{
			longus.animation.play('bop', true);
			tomato.animation.play('bop', true);
			greymira.animation.play('bop', true);
			rhmmira.animation.play('bop', true);
		}
		bluemira.animation.play('bop', true);
	}
}

function onEvent(eventName, value1, value2)
{
	switch (eventName)
	{
		case 'pink toggle':
			if (!pinkCanPulse)
			{
				pinkCanPulse = true;
				if (vignetteTween != null) vignetteTween.cancel();
				if (pinkVignette2Tween != null) pinkVignette2Tween.cancel();
				if (whiteTween != null) whiteTween.cancel();
				if (pinkHUDTween != null) pinkHUDTween.cancel();
				if (pinkHUDOverlayTween != null) pinkHUDOverlayTween.cancel();
				if (heartsImageTween != null) heartsImageTween.cancel();

				heartsImage.alpha = 1;
				heartsImageRight.alpha = 1;
				pinkVignette.alpha = 1;
				pinkVignette2.alpha = 0.3;
				pinkHUDVignette.alpha = 0.65;
				pinkHUDOverlay.alpha = 0.12;

				var fadeTime:Float = Std.parseFloat(value1) * 1.2;
				if (Math.isNaN(fadeTime) || fadeTime < 0) fadeTime = 0;
				heartColorShader.flash = 1;
				whiteTween = FlxTween.tween(heartColorShader, {flash: 0}, fadeTime, {ease: FlxEase.cubeInOut});
				heartEmitter.emitting = true;
				heartEmitterHUD.emitting = true;
				return;
			}
			else
			{
				pinkCanPulse = false;
				heartEmitter.emitting = false;
				heartEmitterHUD.emitting = false;
				var fadeTime:Float = Std.parseFloat(value1) * 2;
				if (Math.isNaN(fadeTime) || fadeTime < 0) fadeTime = 0;

				if (vignetteTween != null) vignetteTween.cancel();
				if (pinkVignette2Tween != null) pinkVignette2Tween.cancel();
				if (whiteTween != null) whiteTween.cancel();
				if (pinkHUDTween != null) pinkHUDTween.cancel();
				if (pinkHUDOverlayTween != null) pinkHUDOverlayTween.cancel();
				if (heartsImageTween != null) heartsImageTween.cancel();

				heartsImage.alpha = 1;
				heartsImageRight.alpha = 1;
				pinkVignette.alpha = 1;
				pinkVignette2.alpha = 0.4;
				pinkHUDVignette.alpha = 0.65;
				pinkHUDOverlay.alpha = 0.12;
				heartColorShader.flash = 1;

				heartsImageTween = FlxTween.tween(heartsImage, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
				FlxTween.tween(heartsImageRight, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
				whiteTween = FlxTween.tween(heartColorShader, {flash: 0}, fadeTime, {ease: FlxEase.cubeInOut});
				vignetteTween = FlxTween.tween(pinkVignette, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
				pinkVignette2Tween = FlxTween.tween(pinkVignette2, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
				pinkHUDTween = FlxTween.tween(pinkHUDVignette, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
				pinkHUDOverlayTween = FlxTween.tween(pinkHUDOverlay, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
				return;
			}
	}
}

function onPopUpScorePost(note, rating)
{
	if (ratingGraphic != null && scoreTxt != null)
	{
		ratingGraphic.color = scoreTxt.color;
		ratingGraphic.x = ((FlxG.width / 2) - (ratingGraphic.width / 2) + comboX);
		ratingGraphic.y = (ClientPrefs.downScroll ? (FlxG.height - ratingGraphic.height - 50) : 55);
	}

	if (playHUD != null && playHUD.ratingNumGroup != null && playHUD.ratingNumGroup.members != null && scoreTxt != null)
	{
		var activeMembers = [for (member in playHUD.ratingNumGroup.members) if (member != null && member.exists && member.alive) member];
		var totalWidth:Float = 0;
		for (member in activeMembers)
			totalWidth += ((member.frameWidth + combosPadding) * playHUD.combosScale);
		for (numScore in activeMembers)
			numScore.color = scoreTxt.color;
	}
	return Function_Continue;
}

function onSongStart()
{
	if (greenhouseSun != null)
	{
		if (sunRiseTween != null)
			sunRiseTween.cancel();
		sunRiseStartY = greenhouseSun.y;
		sunRiseTargetY = greenhouseSun.y - FlxG.height - greenhouseSun.height - 200;
		sunRiseActive = true;
	}
}
