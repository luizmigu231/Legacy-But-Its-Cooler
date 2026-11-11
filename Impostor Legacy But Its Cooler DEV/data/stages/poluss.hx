import StringTools;
import funkin.game.shaders.ExtraDropShadowShader;
import funkin.objects.SnowEmitter;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

public var speaker:FlxSprite;
public var bfdead:FlxSprite;
var sky:FlxSprite;
var rocks:FlxSprite;
var hills:FlxSprite;
var warehouse:FlxSprite;
var ground:FlxSprite;
var camOff:FlxSprite;
var snowAlpha:Float = 1;
var snowEmitter:SnowEmitter;
var outroVid:PsychVideoSprite;
var ext = 'stages/polus/red/';
var bfRim:ExtraDropShadowShader;
var petRim:ExtraDropShadowShader;
var gfRim:ExtraDropShadowShader;
var dadRim:ExtraDropShadowShader;

var polusScene:Array<FlxSprite> = [];
var polusVariant:String = "night";
var polusRims:Array<ExtraDropShadowShader> = [];
var polusCharacterChangeHooksBound:Bool = false;
var polusTransitionTween:FlxTween;
var polusTransitionBusy:Bool = false;
var polusTransitionTarget:String = "";
var polusPendingVariant:String = "";
var polusPendingDuration:Float = 12;
var polusTransitionSpeaker:FlxSprite;
var polusTransitionCam:FlxSprite;
var polusNextScene:Array<FlxSprite> = [];
var polusLighting:Array<FlxSprite> = [];
var polusNextLighting:Array<FlxSprite> = [];
var polusVignette:FlxSprite;
var polusAdjustBuilder:ExtraDropShadowShader;
var polusAdjustedMatricesBuilt:Bool = false;
var polusNextVariant:String = "";
var polusNextSpeaker:FlxSprite;
var polusTransitionProgress:Float = 0;
var polusTransitionCameraStartAlpha:Float = 0.001;
var polusCameraVisible:Bool = false;
var polusSnowColor:Int = 0xFFBFD0FF;
var midnightExtrasAdded:Bool = false;
var polusMidnightBlend:Float = 0;
var crowd:FlxSprite;
var crowdfirst:FlxSprite;

var polusNormalMatrix:Array<Float> = [
	1, 0, 0, 0, 0,
	0, 1, 0, 0, 0,
	0, 0, 1, 0, 0,
	0, 0, 0, 1, 0
];
var polusNightMatrix:Array<Float> = [
	0.72, 0, 0, 0, 0,
	0, 0.72, 0, 0, 0,
	0, 0, 0.72, 0, 0,
	0, 0, 0, 1, 0
];
var polusMidnightMatrix:Array<Float> = [
	0.53, 0, 0, 0, 0,
	0, 0.62, 0, 0, 0,
	0, 0, 0.75, 0, 0,
	0, 0, 0, 1, 0
];
var polusNormalLayer:Array<Float> = [
	1, 0, 0, 0, 0,
	0, 1, 0, 0, 0,
	0, 0, 1, 0, 0,
	0, 0, 0, 1, 0
];
var polusNightLayer:Array<Float> = [
	0.94, 0, 0, 0, 3,
	0, 0.94, 0, 0, 3,
	0, 0, 0.94, 0, 5,
	0, 0, 0, 1, 0
];
var polusMidnightLayer:Array<Float> = [
	0.94, 0, 0, 0, 4,
	0, 0.94, 0, 0, 3,
	0, 0, 0.94, 0, 6,
	0, 0, 0, 1, 0
];
function multiplyPolusColorMatrices(a:Array<Float>, b:Array<Float>):Array<Float>
{
	var result:Array<Float> = [];
	for (i in 0...4)
	{
		for (j in 0...5)
		{
			result[i * 5 + j] = a[i * 5] * b[j]
				+ a[i * 5 + 1] * b[j + 5]
				+ a[i * 5 + 2] * b[j + 10]
				+ a[i * 5 + 3] * b[j + 15]
				+ (j == 4 ? a[i * 5 + 4] : 0);
		}
	}
	return result;
}

function buildPolusAdjustedMatrices():Void
{
	if (polusAdjustedMatricesBuilt || !ClientPrefs.shaders) return;
	polusAdjustBuilder = new ExtraDropShadowShader();
	polusAdjustBuilder.setAdjustColor(-2, -5, 2, -7);
	var nightAdjust:Array<Float> = polusAdjustBuilder.colorMatrix;
	for (i in 0...4) nightAdjust[i * 5 + 4] *= 255;
	polusNightMatrix = multiplyPolusColorMatrices(nightAdjust, polusNightMatrix);
	polusAdjustBuilder.setAdjustColor(-5, -9, 5, -13);
	var midnightAdjust:Array<Float> = polusAdjustBuilder.colorMatrix;
	for (i in 0...4) midnightAdjust[i * 5 + 4] *= 255;
	polusMidnightMatrix = multiplyPolusColorMatrices(midnightAdjust, polusMidnightMatrix);
	polusAdjustBuilder = null;
	polusAdjustedMatricesBuilt = true;
}

function vignetteAlphaForPolusVariant(variant:String):Float
{
	if (variant == "night") return .58;
	if (variant == "midnight") return .72;
	return .42;
}

function lightingAlphasForPolusVariant(variant:String):Array<Float>
{
	if (variant == 'midnight') return [.38];
	if (variant == 'night') return [.34];
	return [.30];
}

function matrixForPolusVariant(variant:String):Array<Float>
{
	if (variant == "night") return polusNightMatrix;
	if (variant == "midnight") return polusMidnightMatrix;
	return polusNormalMatrix;
}

function layerForPolusVariant(variant:String):Array<Float>
{
	if (variant == "night") return polusNightLayer;
	if (variant == "midnight") return polusMidnightLayer;
	return polusNormalLayer;
}

function layerStrengthForPolusVariant(variant:String):Float
{
	return variant == "normal" ? 0 : .95;
}

function interpolatePolusMatrix(a:Array<Float>, b:Array<Float>, t:Float):Array<Float>
{
	var result:Array<Float> = [];
	for (i in 0...20) result.push(a[i] + (b[i] - a[i]) * t);
	return result;
}

function createPolusRim(angleX:Float, distance:Float, variant:String):ExtraDropShadowShader
{
	var rim = new ExtraDropShadowShader();
	rim.threshold = .045;
	rim.strength = 1;
	rim.roughness = .35;
	rim.antialiasStages = 0;
	buildPolusAdjustedMatrices();
	rim.setColorMatrix(matrixForPolusVariant(variant));
	rim.addLayer(layerForPolusVariant(variant), angleX + 92, distance, .018, layerStrengthForPolusVariant(variant), .25);
	return rim;
}

function attachPolusRim(sprite:FlxSprite, angleX:Float):Void
{
	if (!ClientPrefs.shaders || sprite == null) return;
	sprite.useRenderTexture = true;
	var rim = createPolusRim(angleX, -15, polusVariant);
	rim.attachedSprite = sprite;
	polusRims.push(rim);
}

function hasPolusRimFor(sprite:FlxSprite):Bool
{
	if (sprite == null) return false;
	for (rim in polusRims)
		if (rim != null && rim.attachedSprite == sprite) return true;
	return false;
}

function ensurePolusRims():Void
{
	if (!ClientPrefs.shaders) return;
	if (boyfriend != null && !hasPolusRimFor(boyfriend)) attachPolusRim(boyfriend, boyfriend.flipX ? 140 : 220);
	if (gf != null && !hasPolusRimFor(gf)) attachPolusRim(gf, 220);
	if (dad != null && !hasPolusRimFor(dad)) attachPolusRim(dad, 220);
	if (hasPet && pet != null && !hasPolusRimFor(pet)) attachPolusRim(pet, 220);
}

function applyCurrentPolusRimState(rim:ExtraDropShadowShader):Void
{
	if (rim == null || rim.layers == null || rim.layers.length == 0) return;

	var matrix = matrixForPolusVariant(polusVariant);
	var layer = layerForPolusVariant(polusVariant);
	var layerStrength = layerStrengthForPolusVariant(polusVariant);

	if (polusTransitionBusy && polusTransitionTarget != '')
	{
		matrix = interpolatePolusMatrix(matrixForPolusVariant(polusVariant), matrixForPolusVariant(polusTransitionTarget), polusTransitionProgress);
		layer = interpolatePolusMatrix(layerForPolusVariant(polusVariant), layerForPolusVariant(polusTransitionTarget), polusTransitionProgress);
		var fromStrength = layerStrengthForPolusVariant(polusVariant);
		var toStrength = layerStrengthForPolusVariant(polusTransitionTarget);
		layerStrength = fromStrength + (toStrength - fromStrength) * polusTransitionProgress;
	}

	rim.setColorMatrix(matrix);
	rim.layers[0].setColorMatrix(layer);
	rim.layers[0].strength = layerStrength;
}

function rebindPolusCharacterRim(oldChar:FlxSprite, newChar:FlxSprite, angleX:Float):Void
{
	if (!ClientPrefs.shaders || newChar == null) return;

	var rim:ExtraDropShadowShader = null;
	for (candidate in polusRims)
	{
		if (candidate != null && (candidate.attachedSprite == oldChar || candidate.attachedSprite == newChar))
		{
			rim = candidate;
			break;
		}
	}

	if (rim == null)
	{
		attachPolusRim(newChar, angleX);
		rim = polusRims[polusRims.length - 1];
	}
	else
	{
		var previousSprite = rim.attachedSprite;
		newChar.useRenderTexture = true;
		rim.attachedSprite = newChar;
		if (previousSprite != null && previousSprite != newChar && previousSprite.shader == null)
			previousSprite.useRenderTexture = false;
		if (rim.layers != null && rim.layers.length > 0)
			rim.layers[0].angle = angleX + 92;
	}

	applyCurrentPolusRimState(rim);
}

function bindPolusCharacterChangeHooks():Void
{
	if (polusCharacterChangeHooksBound) return;
	polusCharacterChangeHooksBound = true;

	if (boyfriendGroup != null)
		boyfriendGroup.onChange.add(function(newChar, oldChar) {
			if (newChar != null) rebindPolusCharacterRim(oldChar, newChar, newChar.flipX ? 140 : 220);
		});
	if (gfGroup != null)
		gfGroup.onChange.add(function(newChar, oldChar) {
			if (newChar != null) rebindPolusCharacterRim(oldChar, newChar, 220);
		});
	if (dadGroup != null)
		dadGroup.onChange.add(function(newChar, oldChar) {
			if (newChar != null) rebindPolusCharacterRim(oldChar, newChar, 220);
		});
	if (pet != null)
		pet.onChange.add(function(changedPet) {
			if (changedPet != null) rebindPolusCharacterRim(changedPet, changedPet, 220);
		});
}

function makePolusSceneSprite(variant:String, asset:String, x:Float, y:Float, sx:Float, sy:Float, graphicScale:Float = 1):FlxSprite
{
	var suffix = variant == "normal" ? "" : "_" + variant;
	var spr = new FlxSprite(x, y).loadGraphic(Paths.image(ext + asset + suffix));
	spr.scrollFactor.set(sx, sy);
	if (graphicScale != 1) spr.setGraphicSize(Std.int(spr.width * graphicScale));
	return spr;
}

function makePolusSpeaker(variant:String):FlxSprite
{
	var suffix = variant == "normal" ? "" : "_" + variant;
	var spr = new FlxSprite(300, 185);
	spr.frames = Paths.getSparrowAtlas(ext + 'speakerlonely' + suffix);
	spr.animation.addByPrefix('bop', 'speakers lonely', 24, false);
	spr.animation.play('bop');
	return spr;
}

function makePolusLightingSet(variant:String):Array<FlxSprite>
{
	var moon = new FlxSprite(-130, -430).loadGraphic(Paths.image(ext + 'polus_moon_glow'));
	moon.setGraphicSize(960, 960);
	moon.updateHitbox();
	moon.scrollFactor.set(.5, .5);
	moon.blend = BlendMode.ADD;
	moon.antialiasing = true;
	moon.active = false;
	moon.color = variant == 'midnight' ? 0xFF647BCB : (variant == 'night' ? 0xFF8FA8FF : 0xFFB69DFF);
	moon.alpha = variant == 'midnight' ? .38 : (variant == 'night' ? .34 : .30);
	moon.zIndex = -548;

	return [moon];
}

function addPolusLightingSet(lights:Array<FlxSprite>):Void
{
	if (lights == null) return;
	for (light in lights) add(light);
}

function removePolusLightingSet(lights:Array<FlxSprite>):Void
{
	if (lights == null) return;
	for (light in lights)
	{
		if (light == null) continue;
		stage.remove(light, true);
		light.destroy();
	}
}

var polusVignetteFitWidth:Int = -1;
var polusVignetteFitHeight:Int = -1;

function fitPolusVignette():Void
{
	if (polusVignette == null || camGame == null) return;

	var fitZoom:Float = camGame.zoom > 0 ? camGame.zoom : 1;
	var targetWidth:Int = Std.int(Math.ceil(FlxG.width / fitZoom));
	var targetHeight:Int = Std.int(Math.ceil(FlxG.height / fitZoom));
	if (targetWidth < 1 || targetHeight < 1) return;

	if (targetWidth != polusVignetteFitWidth || targetHeight != polusVignetteFitHeight)
	{
		polusVignette.setGraphicSize(targetWidth, targetHeight);
		polusVignette.updateHitbox();
		polusVignetteFitWidth = targetWidth;
		polusVignetteFitHeight = targetHeight;
	}

	polusVignette.setPosition(camGame.viewMarginX, camGame.viewMarginY);
}

function makePolusVignette():FlxSprite
{
	var vignette = new FlxSprite(0, 0).loadGraphic(Paths.image(ext + 'polus_vignette'));
	vignette.scrollFactor.set(0, 0);
	vignette.blend = BlendMode.NORMAL;
	vignette.alpha = vignetteAlphaForPolusVariant(polusVariant);
	vignette.camera = camGame;
	vignette.zIndex = 999999;
	vignette.active = false;
	vignette.antialiasing = true;
	polusVignetteFitWidth = -1;
	polusVignetteFitHeight = -1;
	polusVignette = vignette;
	fitPolusVignette();
	return vignette;
}

function setPolusSceneDepth(scene:Array<FlxSprite>, base:Int, isCurrent:Bool):Void
{
	for (i in 0...scene.length)
		if (scene[i] != null) scene[i].zIndex = base + (i * 10) + (isCurrent ? 1 : 0);
}

function makePolusSceneSet(variant:String):Array<FlxSprite>
{
	return [
		makePolusSceneSprite(variant, 'polus_custom_sky', -400, -400, .5, .5, 1.4),
		makePolusSceneSprite(variant, 'polusrocks', -700, -300, .6, .6, 1),
		makePolusSceneSprite(variant, 'polusHills', -1050, -180.55, .9, .9, 1),
		makePolusSceneSprite(variant, 'polus_custom_lab', 50, -400, 1, 1, 1),
		makePolusSceneSprite(variant, 'cam_off_lab', 50 + 1123, -400 + 452, 1, 1, 1),
		makePolusSceneSprite(variant, 'polus_custom_floor', -1350, 80, 1, 1, 1)
	];
}

function clearPolusNextPair():Void
{
	removePolusLightingSet(polusNextLighting);
	polusNextLighting = [];
	if (polusNextScene != null)
	{
		for (spr in polusNextScene)
		{
			stage.remove(spr, true);
			spr.destroy();
		}
	}
	polusNextScene = [];
	polusNextVariant = '';
	if (polusNextSpeaker != null)
	{
		stage.remove(polusNextSpeaker, true);
		polusNextSpeaker.destroy();
		polusNextSpeaker = null;
	}
	polusTransitionCam = null;
}

function preloadPolusStagePair(target:String):Void
{
	if (target == '' || target == polusVariant) return;
	if (polusNextVariant == target && polusNextScene.length == 6 && polusNextSpeaker != null) return;
	if (polusNextScene.length > 0 || polusNextSpeaker != null) clearPolusNextPair();

	polusNextScene = makePolusSceneSet(target);
	setPolusSceneDepth(polusNextScene, -600, false);
	for (i in 0...polusNextScene.length)
	{
		polusNextScene[i].alpha = i == 4 ? (polusCameraVisible ? 1 : 0.001) : 1;
		stage.add(polusNextScene[i]);
	}

	polusNextSpeaker = makePolusSpeaker(target);
	polusNextSpeaker.alpha = speaker != null ? speaker.alpha : 0;
	polusNextSpeaker.zIndex = -90;
	if (speaker != null) speaker.zIndex = -89;
	stage.add(polusNextSpeaker);

	polusNextLighting = makePolusLightingSet(target);
	for (light in polusNextLighting) light.alpha = 0;
	addPolusLightingSet(polusNextLighting);
	polusNextVariant = target;
	polusTransitionCam = polusNextScene[4];
	refreshZ(stage);
}

function preloadNextPolusStage():Void
{
	if (polusVariant == 'normal') preloadPolusStagePair('night');
	else if (polusVariant == 'night') preloadPolusStagePair('midnight');
}

function addMidnightPolusExtras():Void
{
	if (midnightExtrasAdded) return;
	midnightExtrasAdded = true;
	if (PlayState.SONG.song.toLowerCase() == 'meltdown')
	{
		crowdfirst = new FlxSprite(-900, curBeat >= 64 ? 150 : 300);
		crowdfirst.frames = Paths.getSparrowAtlas(ext + 'boppers_meltdown_first_midnight');
		crowdfirst.animation.addByPrefix('bop', 'BoppersMeltdown', 24, false);
		crowdfirst.animation.play('bop');
		crowdfirst.scale.set(0.9, 0.9);
		crowdfirst.scrollFactor.set(1.5, 1.5);
		crowdfirst.antialiasing = true;
		crowdfirst.alpha = 0;
		crowdfirst.zIndex = -150;
		stage.add(crowdfirst);

		crowd = new FlxSprite(-900, 150);
		crowd.frames = Paths.getSparrowAtlas(ext + 'boppers_meltdown_midnight');
		crowd.animation.addByPrefix('bop', 'BoppersMeltdown', 24, false);
		crowd.animation.play('bop');
		crowd.scale.set(0.9, 0.9);
		crowd.scrollFactor.set(1.5, 1.5);
		crowd.antialiasing = true;
		crowd.alpha = 0;
		crowd.zIndex = -150;
		stage.add(crowd);
	}

	if (boyfriend != null && boyfriend.curCharacter == 'bf-ghost')
	{
		bfdead = new FlxSprite(600, 525).loadGraphic(Paths.image(ext + 'bfdead_midnight'));
		bfdead.setGraphicSize(Std.int(bfdead.width * 0.8));
		bfdead.updateHitbox();
		bfdead.alpha = 0;
		bfdead.zIndex = -150;
		var gfIndex = stage.members.indexOf(game.gfGroup);
		if (gfIndex < 0) stage.add(bfdead);
		else stage.insert(gfIndex, bfdead);
	}
}

function beginPolusStageTransition(target:String, duration:Float):Void
{
	buildPolusAdjustedMatrices();
	if (target != 'normal' && target != 'night' && target != 'midnight') return;
	if (target == polusVariant) return;
	if (duration <= 0 || Math.isNaN(duration)) duration = 12;
	if (polusTransitionBusy)
	{
		polusPendingVariant = target;
		polusPendingDuration = duration;
		return;
	}

	if (polusNextVariant != target || polusNextScene.length != 6 || polusNextSpeaker == null || polusNextLighting.length != 1)
	{
		clearPolusNextPair();
		preloadPolusStagePair(target);
	}
	if (polusNextScene.length != 6 || polusNextSpeaker == null || polusNextLighting.length != 1) return;

	polusTransitionBusy = true;
	polusTransitionTarget = target;
	var fromVariant = polusVariant;
	var fromMatrix = matrixForPolusVariant(fromVariant);
	var toMatrix = matrixForPolusVariant(target);
	var fromLayer = layerForPolusVariant(fromVariant);
	var toLayer = layerForPolusVariant(target);
	var fromLayerStrength = layerStrengthForPolusVariant(fromVariant);
	var toLayerStrength = layerStrengthForPolusVariant(target);
	ensurePolusRims();

	var fromSceneAlphas:Array<Float> = [for (spr in polusScene) spr.alpha];
	var nextScene:Array<FlxSprite> = polusNextScene;
	var oldSpeaker = speaker;
	var nextSpeaker = polusNextSpeaker;
	var oldLighting = polusLighting;
	var nextLighting = polusNextLighting;
	var fromLightingAlphas:Array<Float> = [for (light in oldLighting) light.alpha];
	var toLightingAlphas:Array<Float> = lightingAlphasForPolusVariant(target);
	var fromVignetteAlpha = polusVignette != null ? polusVignette.alpha : vignetteAlphaForPolusVariant(fromVariant);
	var toVignetteAlpha = vignetteAlphaForPolusVariant(target);
	var speakerTargetAlpha = oldSpeaker.alpha;
	nextSpeaker.alpha = speakerTargetAlpha;
	nextSpeaker.zIndex = -90;
	oldSpeaker.zIndex = -89;
	polusTransitionSpeaker = nextSpeaker;
	polusTransitionCam = nextScene[4];
	polusTransitionProgress = 0;
	polusTransitionCameraStartAlpha = polusCameraVisible ? 1 : 0.001;

	var isMeltdown = PlayState.SONG.song.toLowerCase() == 'meltdown';
	if (target == 'midnight') addMidnightPolusExtras();
	if (target == 'midnight')
	{
		if (crowd != null) crowd.zIndex = -150;
		if (crowdfirst != null) crowdfirst.zIndex = -150;
		if (bfdead != null) bfdead.zIndex = -150;
	}
	refreshZ(stage);

	var crowdFromAlpha = crowd != null ? crowd.alpha : 0.0;
	var firstCrowdFromAlpha = crowdfirst != null ? crowdfirst.alpha : 0.0;
	var bfdeadFromAlpha = bfdead != null ? bfdead.alpha : 0.0;
	var bfdeadTargetAlpha = (target == 'midnight' && boyfriend != null && boyfriend.curCharacter == 'bf-ghost') ? 1.0 : 0.0;

	polusTransitionTween = FlxTween.num(0, 1, duration, {ease: FlxEase.sineInOut, onComplete: function(_) {
		removePolusLightingSet(oldLighting);
		polusLighting = nextLighting;
		polusNextLighting = [];
		for (old in polusScene)
		{
			stage.remove(old, true);
			old.destroy();
		}
		stage.remove(oldSpeaker, true);
		oldSpeaker.destroy();

		polusScene = nextScene;
		setPolusSceneDepth(polusScene, -600, true);
		sky = nextScene[0];
		rocks = nextScene[1];
		hills = nextScene[2];
		warehouse = nextScene[3];
		camOff = nextScene[4];
		ground = nextScene[5];
		speaker = nextSpeaker;
		speaker.zIndex = -89;
		speaker.alpha = speakerTargetAlpha;
		camOff.alpha = polusCameraVisible ? 1 : 0.001;
		polusVariant = target;
		if (polusVignette != null) polusVignette.alpha = toVignetteAlpha;
		polusNextScene = [];
		polusNextVariant = '';
		polusNextSpeaker = null;
		polusTransitionSpeaker = null;
		polusTransitionCam = null;
		polusTransitionTween = null;
		polusTransitionBusy = false;
		polusTransitionTarget = '';
		polusTransitionProgress = 0;
		polusMidnightBlend = target == 'midnight' ? 1 : 0;

		if (target == 'midnight')
		{
			if (crowd != null) crowd.zIndex = -88;
			if (crowdfirst != null) crowdfirst.zIndex = -88;
			if (bfdead != null) bfdead.zIndex = -87;
		}
		refreshZ(stage);

		preloadNextPolusStage();

		if (polusPendingVariant != '')
		{
			var queuedTarget = polusPendingVariant;
			var queuedDuration = polusPendingDuration;
			polusPendingVariant = '';
			beginPolusStageTransition(queuedTarget, queuedDuration);
		}
	}}, function(t:Float) {
		polusTransitionProgress = t;
		for (i in 0...polusScene.length)
		{
			var oldAlpha = i == 4 ? polusTransitionCameraStartAlpha : fromSceneAlphas[i];
			polusScene[i].alpha = oldAlpha * (1 - t);
			// Each objective sprite sits directly below its matching current sprite and stays at alpha 1.
		}
		for (i in 0...oldLighting.length)
		{
			oldLighting[i].alpha = fromLightingAlphas[i] * (1 - t);
			nextLighting[i].alpha = toLightingAlphas[i] * t;
		}
		if (polusVignette != null) polusVignette.alpha = fromVignetteAlpha + (toVignetteAlpha - fromVignetteAlpha) * t;
		oldSpeaker.alpha = speakerTargetAlpha * (1 - t);
		nextSpeaker.alpha = speakerTargetAlpha;

		if (target == 'midnight') polusMidnightBlend = t;
		else if (fromVariant == 'midnight') polusMidnightBlend = 1 - t;
		else polusMidnightBlend = 0;

		if (ClientPrefs.shaders && polusRims.length > 0)
		{
			var matrix = interpolatePolusMatrix(fromMatrix, toMatrix, t);
			var layer = interpolatePolusMatrix(fromLayer, toLayer, t);
			var layerStrength = fromLayerStrength + (toLayerStrength - fromLayerStrength) * t;
			for (rim in polusRims)
			{
				rim.setColorMatrix(matrix);
				rim.layers[0].setColorMatrix(layer);
				rim.layers[0].strength = layerStrength;
			}
		}

		if (crowd != null)
		{
			var currentCrowdTarget = (target == 'midnight' && curBeat >= 160 && isMeltdown) ? 1.0 : 0.0;
			crowd.alpha = crowdFromAlpha + (currentCrowdTarget - crowdFromAlpha) * t;
		}
		if (crowdfirst != null)
		{
			var currentFirstTarget = (target == 'midnight' && curBeat >= 64 && curBeat < 128 && isMeltdown) ? 1.0 : 0.0;
			crowdfirst.alpha = firstCrowdFromAlpha + (currentFirstTarget - firstCrowdFromAlpha) * t;
		}
		if (bfdead != null) bfdead.alpha = bfdeadFromAlpha + (bfdeadTargetAlpha - bfdeadFromAlpha) * t;
	});
}

function handlePolusTransitionEvent(value1:String, value2:String):Void
{
	var target = StringTools.trim((value1 ?? 'next').toLowerCase());
	if (target == 'next')
	{
		var current = polusTransitionBusy ? polusTransitionTarget : polusVariant;
		target = current == 'normal' ? 'night' : 'midnight';
	}
	var duration = Std.parseFloat(value2 ?? '12');
	if (Math.isNaN(duration) || duration <= 0) duration = 12;
	if (!polusTransitionBusy && polusVariant == 'normal' && target == 'midnight')
	{
		polusPendingVariant = 'midnight';
		polusPendingDuration = duration;
		target = 'night';
	}
	beginPolusStageTransition(target, duration);
}

function onLoad()
{
	polusScene = [];
	polusNextScene = [];

	// SKY: variante atual por cima, objetivo logo abaixo.
	sky = makePolusSceneSprite('night', 'polus_custom_sky', -400, -400, 0.5, 0.5, 1.4);
	sky.zIndex = -599;
	add(sky);
	var skyN = makePolusSceneSprite('midnight', 'polus_custom_sky', -400, -400, 0.5, 0.5, 1.4);
	skyN.zIndex = -600;
	add(skyN);
	polusScene.push(sky);
	polusNextScene.push(skyN);

	// ROCKS: variante atual por cima, objetivo logo abaixo.
	rocks = makePolusSceneSprite('night', 'polusrocks', -700, -300, 0.6, 0.6, 1);
	rocks.zIndex = -589;
	add(rocks);
	var rocksN = makePolusSceneSprite('midnight', 'polusrocks', -700, -300, 0.6, 0.6, 1);
	rocksN.zIndex = -590;
	add(rocksN);
	polusScene.push(rocks);
	polusNextScene.push(rocksN);

	// HILLS: variante atual por cima, objetivo logo abaixo.
	hills = makePolusSceneSprite('night', 'polusHills', -1050, -180.55, 0.9, 0.9, 1);
	hills.zIndex = -579;
	add(hills);
	var hillsN = makePolusSceneSprite('midnight', 'polusHills', -1050, -180.55, 0.9, 0.9, 1);
	hillsN.zIndex = -580;
	add(hillsN);
	polusScene.push(hills);
	polusNextScene.push(hillsN);

	// LAB: variante atual por cima, objetivo logo abaixo.
	warehouse = makePolusSceneSprite('night', 'polus_custom_lab', 50, -400, 1, 1, 1);
	warehouse.zIndex = -569;
	add(warehouse);
	var warehouseN = makePolusSceneSprite('midnight', 'polus_custom_lab', 50, -400, 1, 1, 1);
	warehouseN.zIndex = -570;
	add(warehouseN);
	polusScene.push(warehouse);
	polusNextScene.push(warehouseN);

	// CAMERA: variante atual por cima, objetivo logo abaixo.
	camOff = makePolusSceneSprite('night', 'cam_off_lab', 50 + 1123, -400 + 452, 1, 1, 1);
	camOff.alpha = polusCameraVisible ? 1 : 0.001;
	camOff.zIndex = -559;
	add(camOff);
	var camOffN = makePolusSceneSprite('midnight', 'cam_off_lab', 50 + 1123, -400 + 452, 1, 1, 1);
	camOffN.alpha = polusCameraVisible ? 1 : 0.001;
	camOffN.zIndex = -560;
	add(camOffN);
	polusScene.push(camOff);
	polusNextScene.push(camOffN);

	// FLOOR: variante atual por cima, objetivo logo abaixo.
	ground = makePolusSceneSprite('night', 'polus_custom_floor', -1350, 80, 1, 1, 1);
	ground.zIndex = -549;
	add(ground);
	var groundN = makePolusSceneSprite('midnight', 'polus_custom_floor', -1350, 80, 1, 1, 1);
	groundN.zIndex = -550;
	add(groundN);
	polusScene.push(ground);
	polusNextScene.push(groundN);

	polusNextVariant = 'midnight';
	polusTransitionCam = camOffN;

	snowEmitter = new SnowEmitter(-600, -600, 200);
	snowEmitter.start(false, ClientPrefs.lowQuality ? 0.14 : 0.07);
	snowEmitter.scrollFactor.x.set(1, 1.5);
	snowEmitter.scrollFactor.y.set(1, 1.5);
	add(snowEmitter);
	snowEmitter.alpha.active = false;
	snowEmitter.onEmit.add((particle) -> {
		particle.alpha = snowAlpha;
	});
	snowEmitter.zIndex = 13;
	snowEmitter.lifespan.set(5);

	// Speaker: atual por cima, próximo atlas logo abaixo.
	speaker = makePolusSpeaker('night');
	speaker.alpha = 0;
	speaker.zIndex = -89;
	add(speaker);
	polusNextSpeaker = makePolusSpeaker('midnight');
	polusNextSpeaker.alpha = speaker.alpha;
	polusNextSpeaker.zIndex = -90;
	add(polusNextSpeaker);

	polusLighting = makePolusLightingSet(polusVariant);
	addPolusLightingSet(polusLighting);
	polusNextLighting = makePolusLightingSet(polusNextVariant);
	for (light in polusNextLighting) light.alpha = 0;
	addPolusLightingSet(polusNextLighting);

	refreshZ(stage);
}

function onUpdatePost(elapsed:Float):Void
{
	fitPolusVignette();
}

function onCreatePost()
{
	camSpecialThing([470, 250], [820, 250]);
	polusVignette = makePolusVignette();
	add(polusVignette);
	refreshZ(stage);
	buildPolusAdjustedMatrices();
	ensurePolusRims();
	bindPolusCharacterChangeHooks();
	if (gf != null && gf.curCharacter == 'gf-ghost' && curSong.toLowerCase() != 'top 10')
	{
		speaker.alpha = 1;
		if (polusNextSpeaker != null) polusNextSpeaker.alpha = 1;
		gf.y -= 240;
	}
	refreshZ(stage);
}

function onSongStart()
{
	if (hasBfSkin && game.boyfriend.curCharacter == 'redp' && hasPet && pet.curPet == 'minicrewmate')
		game.unlockAchievementPopup('red_handed');

	// Night -> Midnight: same 3:05 transition window used by Normal -> Night.
	beginPolusStageTransition('midnight', 3.05 * 60);
}

function onBeatHit()
{
	if (speaker != null) speaker.animation.play('bop');
	if (polusNextSpeaker != null) polusNextSpeaker.animation.play('bop');
	if (crowdfirst != null && curBeat % 2 == 0) crowdfirst.animation.play('bop');
	if (crowd != null && curBeat % 2 == 0) crowd.animation.play('bop');
	if (!polusTransitionBusy && crowdfirst != null && curBeat == 64)
	{
		crowdfirst.alpha = polusMidnightBlend;
		FlxTween.tween(crowdfirst, {y: 150}, 0.5, {ease: FlxEase.quadOut});
	}
	if (!polusTransitionBusy && crowdfirst != null && curBeat == 128) crowdfirst.alpha = 0;
	if (!polusTransitionBusy && crowd != null && curBeat == 160) crowd.alpha = polusMidnightBlend;
}

function onEvent(name, v1, v2)
{
	if (name == 'toggle cams')
	{
		polusCameraVisible = !polusCameraVisible;
		var cameraAlpha = polusCameraVisible ? 1.0 : 0.001;
		if (polusNextScene != null && polusNextScene.length > 4) polusNextScene[4].alpha = cameraAlpha;
		if (polusTransitionBusy)
		{
			polusTransitionCameraStartAlpha = cameraAlpha;
			if (camOff != null) camOff.alpha = cameraAlpha * (1 - polusTransitionProgress);
		}
		else if (camOff != null)
			FlxTween.tween(camOff, {alpha: cameraAlpha}, 0.3, {ease: FlxEase.quadOut});
	}
	if (name == 'Polus Stage Transition') handlePolusTransitionEvent(v1, v2);
}

function onStartCountdown()
{
	new FlxTimer().start((Conductor.crotchet / 1000) / playbackRate, function(tmr:FlxTimer) {
		if (tmr.loopsLeft % 1 == 0)
		{
			if (speaker != null) speaker.animation.play('bop');
			if (polusNextSpeaker != null) polusNextSpeaker.animation.play('bop');
		}
	}, 5);
}
