import StringTools;
import animate.FlxAnimateFrames;
import funkin.objects.FunkinSprite;
import funkin.game.shaders.ExtraDropShadowShader;
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
using StringTools;

var legs:Character;
var bfRim:ExtraDropShadowShader;
var gfRim:ExtraDropShadowShader;
var dadRim:ExtraDropShadowShader;
var petRim:ExtraDropShadowShader;
var bfPlatformRim:ExtraDropShadowShader;
var dadLegsRim:ExtraDropShadowShader;
var bfLegsRim:ExtraDropShadowShader;
var petBoardRim:ExtraDropShadowShader;
var gfBoardRim:ExtraDropShadowShader;

var bfLightningLayer;
var gfLightningLayer;
var dadLightningLayer;
var petLightningLayer;
var bfPlatformLightningLayer;
var petBoardLightningLayer;
var gfBoardLightningLayer;

var farCloudBg:FlxSprite;
var farCloudBgUpper:FlxSprite;
var airFarClouds:FlxBackdrop;
var airFarCloudsUpper:FlxBackdrop;
var airMidClouds:FlxBackdrop;
var airMidCloudsUpper:FlxBackdrop;
var airCloseClouds:FlxBackdrop;
var airCloseCloudsUpper:FlxBackdrop;
var airCloseCloudsOverlay:FlxBackdrop;
var airshipPlatform:FlxBackdrop;
var airSpeedlines:FlxBackdrop;
var airBigCloud:FlxSprite;

var edgeglow1:FlxSprite;
var edgeglow2:FlxSprite;

public var bfPlatform:FlxSprite;
public var gfBoard:FlxSprite;
public var petBoard:FlxSprite;

var airshipskyflash:FlxSprite;
var bfAnchorPoint = [0, 0];

var legPosY = [
	7, 7, 4, 4, -5, -5, -7, -7, -3, -3,
	7, 7, 4, 4, -5, -5, -7, -7, -3, -3
];

var airship:FlxSprite;
var airshipDark:FlxSprite;
var airshipDuplicate:FlxSprite;
var airshiplight:FlxSprite;
var cloudlight:FlxSprite;
var createRimLayers:Array<Dynamic> = [];

var dangerDarkGameShader:FlxRuntimeShader;
var dangerDarkHUDShader:FlxRuntimeShader;
var dangerDarkGameFilter:ShaderFilter;
var dangerDarkHUDFilter:ShaderFilter;
var dangerDarkTween:FlxTween;
var dangerUnscreamTween:FlxTween;
var dangerDarkBrightness:Float = 0;
var dangerDarkSaturation:Float = 0;
var dangerDarkContrast:Float = 0;

var thunder:FlxSprite;
var thunderTween:FlxTween;
var thunder1:FlxSprite;
var thunder1Tween:FlxTween;
var thunder2:FlxSprite;
var thunder2Tween:FlxTween;

var thunderHasSound:Bool = false;
var thunderWhiteFlash:Bool = false;

var baseBfX:Float = 0;
var blackScream:Bool = false;
var legs:Character;

var bgspeed:Float = (ClientPrefs.photosensitive ? 7 : 9);
var bigCloudSpeed:Float = 15;

var farCloudsY:Float = 420.2;
var farCloudsUpperY:Float = -340.0;
var midCloudsY:Float = 536.55;
var midCloudsUpperY:Float = -800.0;
var closeCloudsY:Float = 822.15;
var closeCloudsUpperY:Float = -1100.0;
var bigCloudStartY:Float = -1800.0;
var bigCloudMinY:Float = -2400.0;
var bigCloudMaxY:Float = -1500.0;

var airshipDupX:Float = 1114.75;
var airshipDupY:Float = -873.05;
var airshipDupScaleX:Float = 2.0;
var airshipDupScaleY:Float = 2.0;
var airshipDupScrollX:Float = 0.25;
var airshipDupScrollY:Float = 0.25;

var airshiplightX:Float = 414.75;
var airshiplightY:Float = -1173.05;
var airshiplightScaleX:Float = 2.0;
var airshiplightScaleY:Float = 2.0;
var airshiplightScrollX:Float = 0.25;
var airshiplightScrollY:Float = 0.25;

var cloudlightX:Float = -2414.75;
var cloudlightY:Float = -873.05;
var cloudlightScaleX:Float = 2.0;
var cloudlightScaleY:Float = 2.0;
var cloudlightScrollX:Float = 0.25;
var cloudlightScrollY:Float = 0.25;

var thunderX:Float = -1014.75;
var thunderY:Float = -873.05;
var thunderScaleX:Float = 2.0;
var thunderScaleY:Float = 2.0;
var thunderScrollX:Float = 0.25;
var thunderScrollY:Float = 0.25;
var thunderStartAlpha:Float = 0.0;

var thunder1X:Float = 0;
var thunder1Y:Float = -373.05;
var thunder1ScaleX:Float = 2.0;
var thunder1ScaleY:Float = 2.0;
var thunder1ScrollX:Float = 0.25;
var thunder1ScrollY:Float = 0.25;
var thunder1StartAlpha:Float = 0.0;

var thunder2X:Float = -814.75;
var thunder2Y:Float = -673.05;
var thunder2ScaleX:Float = 2.0;
var thunder2ScaleY:Float = 2.0;
var thunder2ScrollX:Float = 0.25;
var thunder2ScrollY:Float = 0.25;
var thunder2StartAlpha:Float = 0.0;

var closeCloudsOverlayX:Float = 6092.2;
var closeCloudsOverlayY:Float = 1250.0;
var closeCloudsOverlayScale:Float = 4.0;
var closeCloudsOverlayScrollX:Float = 0.3;
var closeCloudsOverlayScrollY:Float = 0.3;
var closeCloudsOverlaySpeedMult:Float = 1.25;

var dadEyeOverlay:FunkinSprite;
var dadEyeAnim:String = '';
var dadEyeCharacter:String = '';
var dadEyeSource:Dynamic = null;
var dadEyeHiddenOwner:Dynamic = null;

function createRim(angleX:Float, angleY:Float):ExtraDropShadowShader
{
	var rim = new ExtraDropShadowShader();
	rim.threshold = 0.05;
	rim.strength = 0.85;
	rim.setColorMatrix([
		0.7, 0, 0, 0, 0,
		0, 0.7, 0, 0, 0,
		0, 0, 0.7, 0, 0,
		0, 0, 0, 1, 0
	]);
	var createRimLayer:Dynamic = rim.addLayer([
		1, 0, 0, 0, 90,
		0, 1, 0, 0, 75,
		0, 0, 0.95, 0, 10,
		0, 0, 0, 1, 0
	], angleX + 86, angleY + 10, 0.1, 0.9);
	createRimLayers.push(createRimLayer);
	return rim;
}


function updateDangerDarknessValues():Void
{
	if (dangerDarkGameShader != null)
	{
		dangerDarkGameShader.setFloat('hue', 0);
		dangerDarkGameShader.setFloat('saturation', dangerDarkSaturation);
		dangerDarkGameShader.setFloat('brightness', dangerDarkBrightness);
		dangerDarkGameShader.setFloat('contrast', dangerDarkContrast);
	}

	if (dangerDarkHUDShader != null)
	{
		dangerDarkHUDShader.setFloat('hue', 0);
		dangerDarkHUDShader.setFloat('saturation', dangerDarkSaturation);
		dangerDarkHUDShader.setFloat('brightness', dangerDarkBrightness);
		dangerDarkHUDShader.setFloat('contrast', dangerDarkContrast);
	}
}

function setupDangerDarkness():Void
{
	if (!ClientPrefs.shaders)
		return;

	var shaderCode:String = Paths.getTextFromFile('shaders/adjustColor.frag');
	if (shaderCode == null || shaderCode.length == 0)
		return;

	if (game.camGame != null)
	{
		dangerDarkGameShader = new FlxRuntimeShader(shaderCode);
		if (dangerDarkGameShader != null)
		{
			dangerDarkGameFilter = new ShaderFilter(dangerDarkGameShader);
			if (game.camGame.filters == null)
				game.camGame.filters = [];
			game.camGame.filters.push(dangerDarkGameFilter);
		}
	}

	if (game.camHUD != null)
	{
		dangerDarkHUDShader = new FlxRuntimeShader(shaderCode);
		if (dangerDarkHUDShader != null)
		{
			dangerDarkHUDFilter = new ShaderFilter(dangerDarkHUDShader);
			if (game.camHUD.filters == null)
				game.camHUD.filters = [];
			game.camHUD.filters.push(dangerDarkHUDFilter);
		}
	}

	updateDangerDarknessValues();
}

function activateDangerDarkness():Void
{
	if (dangerDarkGameShader == null && dangerDarkHUDShader == null)
		setupDangerDarkness();

	if (dangerDarkGameShader == null && dangerDarkHUDShader == null)
		return;

	if (dangerDarkTween != null)
		dangerDarkTween.cancel();

	var startBrightness:Float = dangerDarkBrightness;
	var startSaturation:Float = dangerDarkSaturation;
	var startContrast:Float = dangerDarkContrast;

	dangerDarkTween = FlxTween.num(
		0,
		1,
		0.65,
		{ease: FlxEase.quadOut},
		function(amount:Float)
		{
			dangerDarkBrightness = FlxMath.lerp(startBrightness, -55, amount);
			dangerDarkSaturation = FlxMath.lerp(startSaturation, -12, amount);
			dangerDarkContrast = FlxMath.lerp(startContrast, 8, amount);
			updateDangerDarknessValues();
		}
	);
}

function beginDangerUnscreamTransition():Void
{
	if (dangerUnscreamTween != null)
		dangerUnscreamTween.cancel();

	var shipStartAlpha:Float = airship != null ? airship.alpha : 1;
	var lightStartAlpha:Float = airshiplight != null ? airshiplight.alpha : 1;
	var cloudLightStartAlpha:Float = cloudlight != null ? cloudlight.alpha : 1;
	var rimLayerStates:Array<Dynamic> = [];

	for (layer in createRimLayers)
	{
		if (layer != null)
			rimLayerStates.push({layer: layer, strength: layer.strength});
	}

	if (airshipDuplicate != null)
		airshipDuplicate.visible = false;

	if (airshipDark != null)
	{
		if (airship != null)
			airshipDark.setPosition(airship.x, airship.y);
		airshipDark.alpha = 0;
		airshipDark.visible = false;
	}

	if (airship != null)
	{
		airship.alpha = shipStartAlpha;
		airship.visible = true;
	}

	if (airshiplight != null)
	{
		airshiplight.alpha = lightStartAlpha;
		airshiplight.visible = true;
	}

	if (cloudlight != null)
	{
		cloudlight.alpha = cloudLightStartAlpha;
		cloudlight.visible = true;
	}

	// Five quick on/off cycles. The character rim base layers blink with the ship,
	// while the separate thunder/lightning layers are left untouched.
	dangerUnscreamTween = FlxTween.num(
		0,
		10,
		0.7,
		{
			ease: FlxEase.linear,
			onComplete: function(tween:FlxTween)
			{
				if (airshipDark != null)
				{
					if (airship != null)
						airshipDark.setPosition(airship.x, airship.y);
					airshipDark.alpha = 0;
					airshipDark.visible = true;
				}

				// Cross-fade to the dark replacement while the original ship, lights,
				// and createRim layers fade out together.
				dangerUnscreamTween = FlxTween.num(
					0,
					1,
					0.4,
					{
						ease: FlxEase.quadInOut,
						onComplete: function(fadeTween:FlxTween)
						{
							if (airship != null)
							{
								airship.alpha = shipStartAlpha;
								airship.visible = false;
							}
							if (airshiplight != null)
							{
								airshiplight.alpha = lightStartAlpha;
								airshiplight.visible = false;
							}
							if (cloudlight != null)
							{
								cloudlight.alpha = cloudLightStartAlpha;
								cloudlight.visible = false;
							}
							if (airshipDark != null)
							{
								airshipDark.alpha = 1;
								airshipDark.visible = true;
							}
							for (state in rimLayerStates)
								if (state.layer != null) state.layer.strength = 0;
							dangerUnscreamTween = null;
						}
					},
					function(amount:Float)
					{
						if (airship != null)
							airship.alpha = shipStartAlpha * (1 - amount);
						if (airshiplight != null)
							airshiplight.alpha = lightStartAlpha * (1 - amount);
						if (cloudlight != null)
							cloudlight.alpha = cloudLightStartAlpha * (1 - amount);
						if (airshipDark != null)
						{
							if (airship != null)
								airshipDark.setPosition(airship.x, airship.y);
							airshipDark.alpha = amount;
						}
						for (state in rimLayerStates)
							if (state.layer != null)
								state.layer.strength = state.strength * (1 - amount);
					}
				);
			}
		},
		function(value:Float)
		{
			var isOn:Bool = Std.int(Math.floor(value)) % 2 == 0;
			if (airship != null)
				airship.alpha = isOn ? shipStartAlpha : 0;
			if (airshiplight != null)
				airshiplight.alpha = isOn ? lightStartAlpha : 0;
			if (cloudlight != null)
				cloudlight.alpha = isOn ? cloudLightStartAlpha : 0;
			for (state in rimLayerStates)
				if (state.layer != null)
					state.layer.strength = isOn ? state.strength : 0;
		}
	);
}

function onLoad()
{
	game.camGame.height = FlxG.height + 200;
	game.camGame.y -= 100;

	var sky:FlxSprite = new FlxSprite(-1500, -897.55).loadGraphic(Paths.image('stages/airship/danger/sky'));
	sky.setGraphicSize(5000, sky.height * 1.5 * 4);
	sky.updateHitbox();
	sky.scrollFactor.set(0, 0);
	add(sky);

	thunder1 = new FlxSprite(thunder1X, thunder1Y).loadGraphic(Paths.image('stages/airship/danger/thunder1'));
	thunder1.scrollFactor.set(thunder1ScrollX, thunder1ScrollY);
	thunder1.scale.set(thunder1ScaleX, thunder1ScaleY);
	thunder1.alpha = thunder1StartAlpha;
	thunder1.updateHitbox();
	add(thunder1);

	thunder2 = new FlxSprite(thunder2X, thunder2Y).loadGraphic(Paths.image('stages/airship/danger/thunder2'));
	thunder2.scrollFactor.set(thunder2ScrollX, thunder2ScrollY);
	thunder2.scale.set(thunder2ScaleX, thunder2ScaleY);
	thunder2.alpha = thunder2StartAlpha;
	thunder2.updateHitbox();
	add(thunder2);

	farCloudBg = new FlxSprite(-1500).makeGraphic(50, 50, 0xff222537);
	farCloudBg.setGraphicSize(3000, 3000);
	farCloudBg.scrollFactor.set(0.1, 0.1);
	farCloudBg.antialiasing = false;
	farCloudBg.updateHitbox();
	add(farCloudBg);

	farCloudBgUpper = new FlxSprite(-1500).makeGraphic(50, 50, 0xff222537);
	farCloudBgUpper.scrollFactor.set(0.1, 0.1);
	farCloudBgUpper.antialiasing = false;
	farCloudBgUpper.updateHitbox();
	add(farCloudBgUpper);

	airFarClouds = new FlxBackdrop(Paths.image('stages/airship/danger/farthestClouds'), FlxAxes.X, -2);
	airFarClouds.setPosition(3385.95, farCloudsY);
	airFarClouds.scrollFactor.set(0.1, 0.1);
	airFarClouds.scale.set(2, 2);
	airFarClouds.updateHitbox();
	add(airFarClouds);

	airFarCloudsUpper = new FlxBackdrop(Paths.image('stages/airship/danger/farthestCloudsl'), FlxAxes.X, -2);
	airFarCloudsUpper.setPosition(3385.95, farCloudsUpperY);
	airFarCloudsUpper.scrollFactor.set(0.1, 0.1);
	airFarCloudsUpper.scale.set(2, 2);
	airFarCloudsUpper.flipY = true;
	airFarCloudsUpper.updateHitbox();
	add(airFarCloudsUpper);

	farCloudBg.y = airFarClouds.y + airFarClouds.height - 1;
	farCloudBgUpper.y = airFarCloudsUpper.y - farCloudBgUpper.height + 1;

	airMidClouds = new FlxBackdrop(Paths.image('stages/airship/danger/backClouds'), FlxAxes.X, -2, 299, 0);
	airMidClouds.setPosition(3352.4, midCloudsY);
	airMidClouds.scrollFactor.set(0.2, 0.2);
	airMidClouds.scale.set(2, 2);
	airMidClouds.updateHitbox();
	add(airMidClouds);

	airMidCloudsUpper = new FlxBackdrop(Paths.image('stages/airship/danger/backCloudsl'), FlxAxes.X, -2, 299, 0);
	airMidCloudsUpper.setPosition(3352.4, midCloudsUpperY);
	airMidCloudsUpper.scrollFactor.set(0.2, 0.2);
	airMidCloudsUpper.scale.set(2, 2);
	airMidCloudsUpper.flipY = true;
	airMidCloudsUpper.updateHitbox();
	add(airMidCloudsUpper);

	airship = new FlxSprite(1114.75, -873.05).loadGraphic(Paths.image('stages/airship/danger/airship'));
	airship.scrollFactor.set(0.25, 0.25);
	airship.scale.set(2, 2);
	airship.updateHitbox();
	add(airship);

	airshipDark = new FlxSprite(airship.x, airship.y).loadGraphic(Paths.image('stages/airship/danger/airship-dark'));
	airshipDark.scrollFactor.set(airship.scrollFactor.x, airship.scrollFactor.y);
	airshipDark.scale.set(airship.scale.x, airship.scale.y);
	airshipDark.updateHitbox();
	airshipDark.visible = false;
	add(airshipDark);

	airshipDuplicate = new FlxSprite(airshipDupX, airshipDupY).loadGraphic(Paths.image('stages/airship/danger/airship'));
	airshipDuplicate.scrollFactor.set(airshipDupScrollX, airshipDupScrollY);
	airshipDuplicate.scale.set(airshipDupScaleX, airshipDupScaleY);
	airshipDuplicate.updateHitbox();
	add(airshipDuplicate);

	var fan:FlxSprite = new FlxSprite(2285.4, 102);
	fan.frames = Paths.getSparrowAtlas('stages/airship/danger/airshipFan');
	fan.animation.addByPrefix('idle', 'ala avion instance 1', 24, true);
	fan.animation.play('idle');
	fan.scrollFactor.set(0.27, 0.27);
	add(fan);

	airshiplight = new FlxSprite(airshiplightX, airshiplightY).loadGraphic(Paths.image('stages/airship/danger/airshiplight'));
	airshiplight.scrollFactor.set(airshiplightScrollX, airshiplightScrollY);
	airshiplight.scale.set(airshiplightScaleX, airshiplightScaleY);
	airshiplight.updateHitbox();
	add(airshiplight);

	airBigCloud = new FlxSprite(3507.15, bigCloudStartY).loadGraphic(Paths.image('stages/airship/danger/bigCloud'));
	airBigCloud.scrollFactor.set(0.4, 0.4);
	airBigCloud.scale.set(4, 4);
	airBigCloud.flipY = true;
	airBigCloud.updateHitbox();
	add(airBigCloud);

	airCloseClouds = new FlxBackdrop(Paths.image('stages/airship/danger/frontClouds'), FlxAxes.X, -3, 808, 0);
	airCloseClouds.setPosition(6092.2, closeCloudsY);
	airCloseClouds.scrollFactor.set(0.3, 0.3);
	airCloseClouds.scale.set(2, 2);
	airCloseClouds.updateHitbox();
	add(airCloseClouds);

	cloudlight = new FlxSprite(cloudlightX, cloudlightY).loadGraphic(Paths.image('stages/airship/danger/cloudlight'));
	cloudlight.scrollFactor.set(cloudlightScrollX, cloudlightScrollY);
	cloudlight.scale.set(cloudlightScaleX, cloudlightScaleY);
	cloudlight.updateHitbox();
	add(cloudlight);

	thunder = new FlxSprite(thunderX, thunderY).loadGraphic(Paths.image('stages/airship/danger/thunder'));
	thunder.scrollFactor.set(thunderScrollX, thunderScrollY);
	thunder.scale.set(thunderScaleX, thunderScaleY);
	thunder.alpha = thunderStartAlpha;
	thunder.updateHitbox();
	add(thunder);

	airCloseCloudsUpper = new FlxBackdrop(Paths.image('stages/airship/danger/frontCloudsl'), FlxAxes.X, -3, 808, 0);
	airCloseCloudsUpper.setPosition(6092.2, closeCloudsUpperY);
	airCloseCloudsUpper.scrollFactor.set(0.3, 0.3);
	airCloseCloudsUpper.scale.set(2, 2);
	airCloseCloudsUpper.flipY = true;
	airCloseCloudsUpper.updateHitbox();
	add(airCloseCloudsUpper);

	airshipskyflash = new FlxSprite(0, -200);
	airshipskyflash.frames = Paths.getSparrowAtlas('stages/airship/danger/screamsky');
	airshipskyflash.animation.addByPrefix('bop', 'scream sky', 24, false);
	airshipskyflash.setGraphicSize(Std.int(airshipskyflash.width * 4));
	airshipskyflash.updateHitbox();
	airshipskyflash.setGraphicSize(Std.int(airshipskyflash.width * 3));
	airshipskyflash.antialiasing = true;
	add(airshipskyflash);
	airshipskyflash.alpha = 0.0001;

	airshipPlatform = new FlxBackdrop(Paths.image('stages/airship/danger/fgPlatform'), FlxAxes.X);
	airshipPlatform.setPosition(-7184.8, 282.25);
	airshipPlatform.scale.set(2, 2);
	airshipPlatform.updateHitbox();
	add(airshipPlatform);

	bfPlatform = new FlxSprite(1542 -1645, 350 - -120);
	bfPlatform.zIndex = boyfriendGroup.zIndex - 1;
	bfPlatform.frames = Paths.getSparrowAtlas('stages/common/platform-dark');
	bfPlatform.animation.addByPrefix('bop', 'danger', 24, true);
	bfPlatform.animation.play('bop');
	bfPlatform.visible = false;

	gfBoard = new FlxSprite(850, 550);
	gfBoard.zIndex = gfGroup.zIndex - 1;
	gfBoard.frames = Paths.getSparrowAtlas('stages/airship/danger/dangerboards');
	gfBoard.animation.addByPrefix('bop', 'speakerwheel', 24, true);
	gfBoard.animation.play('bop');
	gfBoard.visible = false;

	petBoard = new FlxSprite(1900, 500);
	petBoard.zIndex = pet.zIndex + 1;
	petBoard.frames = Paths.getSparrowAtlas('stages/airship/danger/dangerboards');
	petBoard.animation.addByPrefix('bop', 'cart', 24, true);
	petBoard.animation.play('bop');
	petBoard.visible = false;

	boyfriendGroup.add(bfPlatform);
	add(gfBoard);
	add(petBoard);

	airCloseCloudsOverlay = new FlxBackdrop(Paths.image('stages/airship/danger/frontClouds'), FlxAxes.X, -3, 808, 0);
	airCloseCloudsOverlay.setPosition(closeCloudsOverlayX, closeCloudsOverlayY);
	airCloseCloudsOverlay.scrollFactor.set(closeCloudsOverlayScrollX, closeCloudsOverlayScrollY);
	airCloseCloudsOverlay.scale.set(closeCloudsOverlayScale, closeCloudsOverlayScale);
	airCloseCloudsOverlay.updateHitbox();
	airCloseCloudsOverlay.zIndex = boyfriendGroup.zIndex + 100;
	add(airCloseCloudsOverlay);
}

function onCreatePost()
{
	for (member in boyfriendGroup.members)
		if (member != boyfriend && Std.isOfType(member, Character))
			legs = member;

	edgeglow1 =
		new FlxSprite(0, -60).loadGraphic(
			Paths.image('stages/airship/danger/edgeglow')
		);

	edgeglow1.blend = BlendMode.ADD;

	edgeglow1.setGraphicSize(FlxG.width * 1.1);
	edgeglow1.screenCenter(FlxAxes.X);

	edgeglow1.antialiasing =
		ClientPrefs.globalAntialiasing;

	edgeglow1.scrollFactor.set(0,0);
	edgeglow1.alpha = 1;
	game.add(edgeglow1);
	edgeglow1.camera = camHUD;

	edgeglow2 =
		new FlxSprite(0, FlxG.height - 290).loadGraphic(
			Paths.image('stages/airship/danger/edgeglow')
		);

	edgeglow2.blend = BlendMode.ADD;

	edgeglow2.setGraphicSize(FlxG.width * 1.1);
	edgeglow2.screenCenter(FlxAxes.X);
	edgeglow2.flipY = true;

	edgeglow2.antialiasing =
		ClientPrefs.globalAntialiasing;

	edgeglow2.scrollFactor.set(0,0);
	edgeglow2.alpha = 1;
	game.add(edgeglow2);
	edgeglow2.camera = camHUD;

	var hud = game.playHUD;

	hud.updateIconPos = false;

	hud.iconP1.x =
		hud.healthBar.x +
		hud.healthBar.width -
		(hud.iconP1.width / 2);

	if (boyfriend.getFlag("runner") == true)
		iconP1.flipX = true;

	baseBfX =
		game.boyfriend.x;

	camSpecialThing(
		[300, 500],
		[700, 500],
		0.6
	);

	if (hasBfSkin)
	{
		boyfriend.color =
			0xFF909090;

		if (legs != null)
			legs.color =
				0xFF909090;
	}
	else
	{
		boyfriend.color =
			0xFFF1F1F1;

		if (legs != null)
			legs.color =
				0xFFF1F1F1;
	}

	gf.color =
		0xFF909090;

	pet.color =
		0xFF909090;

	dad.color =
		0xFFF1F1F1;

	if (ClientPrefs.shaders)
	{
		boyfriend.useRenderTexture =
			true;

		var bfRimAngle:Float =
			boyfriend.flipX
			? -130
			: -210;

		bfRim =
			createRim(
				bfRimAngle,
				-28
			);

		bfLightningLayer =
			bfRim.addLayer([
				1, 1, 1, 0, 255,
				1, 1, 1, 0, 255,
				1, 1, 1, 0, 255,
				0, 0, 0, 1, 0
			], -60, -28, 0.05, 0);

		bfLightningLayer.strength =
			0;

		bfRim.attachedSprite =
			boyfriend;

		boyfriend.shader =
			bfRim;

		if (legs != null)
		{
			bfLegsRim =
				createRim(
					boyfriend.flipX
					? -130
					: -210,
					-28
				);

			bfLegsRim.attachedSprite =
				legs;

			legs.shader =
				bfLegsRim;
		}

		if (hasPet)
		{
			pet.useRenderTexture =
				true;

			petRim =
				createRim(
					-210,
					-28
				);

			petLightningLayer =
				petRim.addLayer([
					1, 1, 1, 0, 255,
					1, 1, 1, 0, 255,
					1, 1, 1, 0, 255,
					0, 0, 0, 1, 0
				], -60, -28, 0.05, 0);

			petLightningLayer.strength =
				0;

			petRim.attachedSprite =
				pet;

			pet.shader =
				petRim;
		}

		gf.useRenderTexture =
			true;

		gfRim =
			createRim(
				-210,
				-28
			);

		gfLightningLayer =
			gfRim.addLayer([
				1, 1, 1, 0, 255,
				1, 1, 1, 0, 255,
				1, 1, 1, 0, 255,
				0, 0, 0, 1, 0
			], -60, -28, 0.05, 0);

		gfLightningLayer.strength =
			0;

		gfRim.attachedSprite =
			gf;

		gf.shader =
			gfRim;

		dad.useRenderTexture =
			true;

		dadRim =
			createRim(
				355,
				6
			);

		dadLightningLayer =
			dadRim.addLayer([
				1, 1, 1, 0, 255,
				1, 1, 1, 0, 255,
				1, 1, 1, 0, 255,
				0, 0, 0, 1, 0
			], 355, 6, 0.05, 0);

		dadLightningLayer.strength =
			0;

		dadRim.attachedSprite =
			dad;

		dad.shader =
			dadRim;

		if (dadLegs != null)
		{
			dadLegs.useRenderTexture =
				true;

			dadLegsRim =
				createRim(
					355,
					6
				);

			dadLegsRim.attachedSprite =
				dadLegs;

			dadLegs.shader =
				dadLegsRim;
		}

		if (
			hasBfSkin &&
			boyfriend.getFlag('floating') != true &&
			boyfriend.getFlag('runner') != true
		)
		{
			bfPlatformRim =
				createRim(
					-210,
					-28
				);

			bfPlatformLightningLayer =
				bfPlatformRim.addLayer([
					1, 1, 1, 0, 255,
					1, 1, 1, 0, 255,
					1, 1, 1, 0, 255,
					0, 0, 0, 1, 0
				], -60, -28, 0.05, 0);

			bfPlatformLightningLayer.strength =
				0;

			bfPlatformRim.attachedSprite =
				bfPlatform;

			bfPlatform.shader =
				bfPlatformRim;
		}

		if (
			hasPet &&
			pet.getFlag('floating') != true &&
			pet.getFlag('runner') != true
		)
		{
			petBoardRim =
				createRim(
					-210,
					-28
				);

			petBoardLightningLayer =
				petBoardRim.addLayer([
					1, 1, 1, 0, 255,
					1, 1, 1, 0, 255,
					1, 1, 1, 0, 255,
					0, 0, 0, 1, 0
				], -60, -28, 0.05, 0);

			petBoardLightningLayer.strength =
				0;

			petBoardRim.attachedSprite =
				petBoard;

			petBoard.shader =
				petBoardRim;
		}

		if (hasGfSkin)
		{
			gfBoardRim =
				createRim(
					-210,
					-28
				);

			gfBoardLightningLayer =
				gfBoardRim.addLayer([
					1, 1, 1, 0, 255,
					1, 1, 1, 0, 255,
					1, 1, 1, 0, 255,
					0, 0, 0, 1, 0
				], -60, -28, 0.05, 0);

			gfBoardLightningLayer.strength =
				0;

			gfBoardRim.attachedSprite =
				gfBoard;

			gfBoard.shader =
				gfBoardRim;
		}
	}

	if (
		gf.getFlag('floating') != true &&
		gf.getFlag('runner') != true
	)
		gfBoard.visible = true;

	if (gf.getFlag('dangerSkateboard'))
	{
		gfBoard.animation.addByPrefix(
			'bop',
			'skateboard',
			24,
			true
		);

		gfBoard.x += 110;
		gfBoard.y -= 50;
	}
	else
	{
		gfBoard.animation.addByPrefix(
			'bop',
			'speakerwheel',
			24,
			true
		);
	}

	gfBoard.animation.play(
		'bop'
	);

	if (
		hasBfSkin &&
		boyfriend.getFlag('floating') != true &&
		boyfriend.getFlag('runner') != true
	)
	{
		bfPlatform.visible =
			true;

		boyfriend.x += 50;
		boyfriend.y -= 235;
	}

	if (
		hasPet &&
		pet.getFlag('floating') != true &&
		pet.getFlag('runner') != true
	)
	{
		petBoard.visible =
			true;

		pet.y -= 20;
	}

	airSpeedlines =
		new FlxBackdrop(
			Paths.image(
				'stages/airship/danger/speedlines'
			),
			FlxAxes.X,
			1,
			787.95,
			0
		);

	airSpeedlines.setPosition(
		-3352.1,
		-1035.95
	);

	airSpeedlines.alpha =
		0.2;

	airSpeedlines.scrollFactor.set(
		1.3,
		1.3
	);

	add(airSpeedlines);

	refreshDangerDadEye();
}

function opponentNoteHit(note)
{
	if (game.health > 0.3)
	{
		game.dad.animSuffix == "mad"
			? game.health -= 0.03
			: game.health -= 0.015;
	}
}

function onUpdate(elapsed)
{
	updateIconsPosition();

	var bfTargetX:Float =
		FlxMath.remapToRange(
			game.health,
			0,
			2,
			game.BF_X - 202,
			game.BF_X + 202
		);

	boyfriendGroup.x =
		FlxMath.lerp(
			boyfriendGroup.x,
			bfTargetX + 30,
			FlxMath.bound(
				4.5 * elapsed,
				0,
				1
			)
		);

	edgeglow1.alpha = edgeglow2.alpha = FlxMath.remapToRange(health + 1.1, 2, 1, 0, 1);

	if (ClientPrefs.inDevMode)
	{
		if (FlxG.keys.pressed.Q)
			bgspeed -=
				elapsed * 30;

		if (FlxG.keys.pressed.E)
			bgspeed +=
				elapsed * 30;
	}

	final delta:Float =
		elapsed *
		bgspeed *
		playbackRate;

	if (!isDead)
	{
		if (!blackScream)
		{
			game.camGame.shake(
				0.0008,
				0.01
			);
		}

		game.camGame.y =
			Math.sin(
				(Conductor.songPosition / 280) *
				(Conductor.bpm / 60)
			) *
			2 -
			100;

		game.camHUD.scroll.y =
			Math.sin(
				(Conductor.songPosition / 300) *
				(Conductor.bpm / 60)
			) *
			0.6;

		game.camHUD.scrollAngle =
			Math.sin(
				(Conductor.songPosition / 350) *
				(Conductor.bpm / 60) *
				-1.0
			) *
			0.6;
	}

	airFarClouds.x -=
		delta * 10.5;

	airFarCloudsUpper.x -=
		delta * 15.75;

	airMidClouds.x -=
		delta * 19.5;

	airMidCloudsUpper.x -=
		delta * 29.25;

	airCloseClouds.x -=
		delta * 75;

	airCloseCloudsUpper.x -=
		delta * 112.5;

	airCloseCloudsOverlay.x -=
		delta *
		75 *
		closeCloudsOverlaySpeedMult;

	airshipPlatform.x -=
		delta * 300;

	airSpeedlines.x -=
		delta * 875;

	if (airBigCloud != null)
	{
		airBigCloud.x -=
			delta *
			bigCloudSpeed;

		if (airBigCloud.x < -6000.0)
		{
			airBigCloud.x =
				FlxG.random.float(
					3931.5,
					4824.05
				);

			airBigCloud.y =
				FlxG.random.float(
					bigCloudMinY,
					bigCloudMaxY
				);

			bigCloudSpeed =
				FlxG.random.float(
					10.5,
					22.5
				);
		}
	}

	refreshDangerDadEye();
}

function getDisplacement(
	left_x:Float = -4000,
	get_x:Float = 0,
	returnX:Float = 4000
)
{
	var dp:Float =
		left_x - get_x;

	return returnX - dp;
}

function onGameOverStart()
{
	FlxTween.tween(
		FlxG.camera,
		{zoom: .65},
		8,
		{
			ease: FlxEase.expoOut,
			startDelay: .5
		}
	);
}

function onEvent(ev, v1, v2)
{
	if (ev == 'Legacy')
	{
		switch (v1)
		{
			case 'scream danger':
				blackScream =
					true;

				airshipskyflash.alpha =
					1;

				airshipskyflash.animation.play(
					'bop',
					false
				);

				dad.playAnim(
					'scream2',
					true
				);

				dad.specialAnim =
					true;

				dad.animSuffix =
					'-mad';

			case 'unscream danger':
				dadLegs.playAnim(
					'legs-mad',
					true
				);

				blackScream =
					false;

				activateDangerDarkness();
				beginDangerUnscreamTransition();

				FlxTween.tween(
					airshipskyflash,
					{alpha: 0},
					0.6,
					{
						ease: FlxEase.quartOut
					}
				);

			case 'bye gf':
				FlxTween.tween(
					gf,
					{x: gf.x - 3500},
					4,
					{
						ease: FlxEase.quartIn,
						onComplete: function()
						{
							gf.kill();
						}
					}
				);

				FlxTween.tween(
					pet,
					{x: pet.x - 3500},
					8,
					{
						ease: FlxEase.quartIn,
						onComplete: function()
						{
							pet.kill();
						}
					}
				);

				FlxTween.tween(
					gfBoard,
					{x: gfBoard.x - 3500},
					4,
					{
						ease: FlxEase.quartIn,
						onComplete: function()
						{
							gfBoard.kill();
						}
					}
				);

				FlxTween.tween(
					petBoard,
					{x: petBoard.x - 3500},
					8,
					{
						ease: FlxEase.quartIn,
						onComplete: function()
						{
							petBoard.kill();
						}
					}
				);

				FlxTween.num(
					bgspeed,
					ClientPrefs.photosensitive
						? 9
						: 14,
					5,
					{
						ease: FlxEase.quadIn
					},
					function(v:Float)
					{
						bgspeed =
							v;
					}
				);
		}
	}
}

function updateThunderRim()
{
	if (
		thunderHasSound ||
		thunderWhiteFlash
	)
	{
		setLightningRim(
			true,
			thunder.alpha * 0.9
		);
	}
	else
	{
		setLightningRim(
			false,
			0
		);
	}
}

function tweenThunderAlpha(
	targetAlpha:Float,
	duration:Float,
	hasSound:Bool
)
{
	if (thunder == null)
		return;

	if (thunderTween != null)
		thunderTween.cancel();

	thunderHasSound =
		hasSound;

	thunderWhiteFlash =
		targetAlpha >= 1.0;

	updateThunderRim();

	thunderTween =
		FlxTween.tween(
			thunder,
			{alpha: targetAlpha},
			duration,
			{
				ease: FlxEase.cubeOut,

				onUpdate: function(tween:FlxTween)
				{
					updateThunderRim();
				},

				onComplete: function(tween:FlxTween)
				{
					if (targetAlpha <= 0)
					{
						thunderHasSound =
							false;

						thunderWhiteFlash =
							false;

						updateThunderRim();
					}
				}
			}
		);
}

function tweenThunder1Alpha(
	targetAlpha:Float,
	duration:Float
)
{
	if (thunder1 == null)
		return;

	if (thunder1Tween != null)
		thunder1Tween.cancel();

	thunder1Tween =
		FlxTween.tween(
			thunder1,
			{alpha: targetAlpha},
			duration,
			{
				ease: FlxEase.cubeOut
			}
		);
}

function tweenThunder2Alpha(
	targetAlpha:Float,
	duration:Float
)
{
	if (thunder2 == null)
		return;

	if (thunder2Tween != null)
		thunder2Tween.cancel();

	thunder2Tween =
		FlxTween.tween(
			thunder2,
			{alpha: targetAlpha},
			duration,
			{
				ease: FlxEase.cubeOut
			}
		);
}

function onStepHit()
{
	switch (curStep)
	{
		case 5:
			tweenThunderAlpha(
				0.8,
				0.01,
				false
			);

		case 7:
			tweenThunderAlpha(
				0.0,
				1,
				false
			);

		case 8:
			tweenThunderAlpha(
				1.0,
				0.01,
				false
			);

		case 9:
			tweenThunderAlpha(
				0.0,
				1.1,
				false
			);

		case 149:
			tweenThunderAlpha(
				0.8,
				0.01,
				true
			);

			FlxG.sound.play(
				Paths.sound('thunder22'),
				0.12
			);

		case 150:
			tweenThunderAlpha(
				0.0,
				1,
				true
			);

		case 256:
			tweenThunderAlpha(
				0.8,
				0.01,
				true
			);

			FlxG.sound.play(
				Paths.sound('thunder11'),
				0.013
			);

		case 257:
			tweenThunderAlpha(
				0.0,
				0.5,
				true
			);

		case 258:
			tweenThunderAlpha(
				1.0,
				0.01,
				true
			);

		case 259:
			tweenThunderAlpha(
				0.0,
				0.9,
				true
			);

		case 334:
			tweenThunderAlpha(
				0.8,
				0.01,
				true
			);

			FlxG.sound.play(
				Paths.sound('thunder33'),
				0.013
			);

		case 335:
			tweenThunderAlpha(
				0.0,
				0.5,
				true
			);

		case 336:
			tweenThunderAlpha(
				1.0,
				0.01,
				true
			);

		case 337:
			tweenThunderAlpha(
				0.0,
				0.9,
				true
			);

		case 509:
			tweenThunderAlpha(
				0.8,
				0.01,
				true
			);

			FlxG.sound.play(
				Paths.sound('thunder11 '),
				0.013
			);

		case 510:
			tweenThunderAlpha(
				0.0,
				0.5,
				true
			);

		case 511:
			tweenThunderAlpha(
				1.0,
				0.01,
				true
			);

		case 512:
			tweenThunderAlpha(
				0.0,
				0.9,
				true
			);

		case 641:
			tweenThunderAlpha(
				0.8,
				0.01,
				true
			);

			FlxG.sound.play(
				Paths.sound('thunder22'),
				0.013
			);

		case 642:
			tweenThunderAlpha(
				0.0,
				0.5,
				true
			);

		case 643:
			tweenThunderAlpha(
				1.0,
				0.01,
				true
			);

		case 644:
			tweenThunderAlpha(
				0.0,
				0.9,
				true
			);

		case 761:
			tweenThunderAlpha(
				0.8,
				0.01,
				true
			);

			FlxG.sound.play(
				Paths.sound('thunder11'),
				0.013
			);

		case 762:
			tweenThunderAlpha(
				0.0,
				0.5,
				true
			);

		case 763:
			tweenThunderAlpha(
				1.0,
				0.01,
				true
			);

		case 764:
			tweenThunderAlpha(
				0.0,
				0.9,
				true
			);

		case 977:
			tweenThunderAlpha(
				0.8,
				0.01,
				true
			);

		case 978:
			tweenThunderAlpha(
				0.0,
				0.5,
				true
			);

			FlxG.sound.play(
				Paths.sound('thunder33'),
				0.013
			);

		case 979:
			tweenThunderAlpha(
				1.0,
				0.01,
				true
			);

		case 980:
			tweenThunderAlpha(
				0.0,
				0.9,
				true
			);

		case 1280:
			tweenThunderAlpha(
				0.8,
				0.01,
				true
			);

			FlxG.sound.play(
				Paths.sound('thunder11 '),
				0.013
			);

		case 1281:
			tweenThunderAlpha(
				0.0,
				0.5,
				true
			);

		case 1282:
			tweenThunderAlpha(
				1.0,
				0.01,
				true
			);

		case 1283:
			tweenThunderAlpha(
				0.0,
				0.9,
				true
			);

		case 1294:
			tweenThunderAlpha(
				0.8,
				0.01,
				true
			);

			FlxG.sound.play(
				Paths.sound('thunder22'),
				0.013
			);

		case 1295:
			tweenThunderAlpha(
				0.0,
				0.5,
				true
			);

		case 1296:
			tweenThunderAlpha(
				1.0,
				0.01,
				true
			);

		case 1297:
			tweenThunderAlpha(
				0.0,
				0.9,
				true
			);

		case 1312:
			tweenThunderAlpha(
				0.8,
				0.01,
				true
			);

			FlxG.sound.play(
				Paths.sound('thunder33'),
				0.013
			);

		case 1313:
			tweenThunderAlpha(
				0.0,
				0.5,
				true
			);

		case 1314:
			tweenThunderAlpha(
				1.0,
				0.01,
				true
			);

		case 1315:
			tweenThunderAlpha(
				0.0,
				0.9,
				true
			);

		case 1412:
			tweenThunderAlpha(
				0.8,
				0.01,
				true
			);

			FlxG.sound.play(
				Paths.sound('thunder11'),
				0.013
			);

		case 1413:
			tweenThunderAlpha(
				0.0,
				0.5,
				true
			);

		case 1414:
			tweenThunderAlpha(
				1.0,
				0.01,
				true
			);

		case 1415:
			tweenThunderAlpha(
				0.0,
				0.9,
				true
			);

		case 1441:
			tweenThunderAlpha(
				0.8,
				0.01,
				true
			);

			FlxG.sound.play(
				Paths.sound('thunder33'),
				0.013
			);

		case 1442:
			tweenThunderAlpha(
				0.0,
				0.5,
				true
			);

		case 1443:
			tweenThunderAlpha(
				1.0,
				0.01,
				true
			);

		case 1444:
			tweenThunderAlpha(
				0.0,
				0.9,
				true
			);

		case 1480:
			tweenThunderAlpha(
				0.8,
				0.01,
				true
			);

			FlxG.sound.play(
				Paths.sound('thunder11'),
				0.013
			);

		case 1481:
			tweenThunderAlpha(
				0.0,
				0.5,
				true
			);

		case 1482:
			tweenThunderAlpha(
				1.0,
				0.01,
				true
			);

		case 1483:
			tweenThunderAlpha(
				0.0,
				0.9,
				true
			);

		case 1542:
			tweenThunderAlpha(
				0.8,
				0.01,
				true
			);

			FlxG.sound.play(
				Paths.sound('thunder22'),
				0.013
			);

		case 1543:
			tweenThunderAlpha(
				0.0,
				0.5,
				true
			);

		case 1544:
			tweenThunderAlpha(
				1.0,
				0.01,
				true
			);

		case 1545:
			tweenThunderAlpha(
				0.0,
				0.9,
				true
			);

		case 1549:
			tweenThunderAlpha(
				0.8,
				0.01,
				true
			);

			FlxG.sound.play(
				Paths.sound('thunder33'),
				0.013
			);

		case 1550:
			tweenThunderAlpha(
				0.0,
				0.5,
				true
			);

		case 1551:
			tweenThunderAlpha(
				1.0,
				0.01,
				true
			);

		case 1552:
			tweenThunderAlpha(
				0.0,
				0.9,
				true
			);
	}

	switch (curStep)
	{
		case 35:
			tweenThunder2Alpha(1, 0.01);

		case 36:
			tweenThunder2Alpha(0, 0.5);

		case 75:
			tweenThunder1Alpha(1, 0.01);

		case 76:
			tweenThunder1Alpha(0, 0.5);

		case 80:
			tweenThunder2Alpha(1, 0.01);

		case 81:
			tweenThunder2Alpha(0, 0.5);

		case 220:
			tweenThunder2Alpha(1, 0.01);

		case 221:
			tweenThunder2Alpha(0, 0.5);

		case 262:
			tweenThunder2Alpha(1, 0.01);

		case 263:
			tweenThunder2Alpha(0, 0.5);

		case 266:
			tweenThunder1Alpha(1, 0.01);

		case 267:
			tweenThunder1Alpha(0, 0.5);

		case 404:
			tweenThunder1Alpha(1, 0.01);

		case 405:
			tweenThunder1Alpha(0, 0.5);

		case 519:
			tweenThunder2Alpha(1, 0.01);

		case 520:
			tweenThunder2Alpha(0, 0.5);

		case 523:
			tweenThunder1Alpha(1, 0.01);

		case 524:
			tweenThunder1Alpha(0, 0.5);

		case 536:
			tweenThunder1Alpha(1, 0.01);

		case 537:
			tweenThunder1Alpha(0, 0.5);

		case 573:
			tweenThunder2Alpha(1, 0.01);

		case 574:
			tweenThunder2Alpha(0, 0.5);

		case 728:
			tweenThunder2Alpha(1, 0.01);

		case 729:
			tweenThunder2Alpha(0, 0.5);

		case 908:
			tweenThunder1Alpha(1, 0.01);

		case 909:
			tweenThunder1Alpha(0, 0.5);

		case 915:
			tweenThunder2Alpha(1, 0.01);

		case 916:
			tweenThunder2Alpha(0, 0.5);

		case 1283:
			tweenThunder2Alpha(1, 0.01);

		case 1284:
			tweenThunder2Alpha(0, 0.5);

		case 1287:
			tweenThunder1Alpha(1, 0.01);

		case 1288:
			tweenThunder1Alpha(0, 0.5);

		case 1300:
			tweenThunder1Alpha(1, 0.01);

		case 1301:
			tweenThunder1Alpha(0, 0.5);

		case 1322:
			tweenThunder2Alpha(1, 0.01);

		case 1323:
			tweenThunder2Alpha(0, 0.5);

		case 1356:
			tweenThunder1Alpha(1, 0.01);

		case 1357:
			tweenThunder1Alpha(0, 0.5);

		case 1361:
			tweenThunder2Alpha(1, 0.01);

		case 1362:
			tweenThunder2Alpha(0, 0.5);

		case 1452:
			tweenThunder1Alpha(1, 0.01);

		case 1453:
			tweenThunder1Alpha(0, 0.5);

		case 1484:
			tweenThunder2Alpha(1, 0.01);

		case 1485:
			tweenThunder2Alpha(0, 0.5);
	}
}

public function updateIconsPosition()
{
	var hud = game.playHUD;
	var healthBar = hud.healthBar;
	var iconP2 = hud.iconP2;
	final iconOffset:Int = 26;

	iconP2.x =
		healthBar.barCenter -
		(150 * iconP2.scale.x) / 2 -
		iconOffset * 2;
}

function setLightningRim(
	active:Bool,
	strength:Float
)
{
	var value:Float =
		active
		? strength
		: 0;

	if (bfLightningLayer != null)
		bfLightningLayer.strength =
			value;

	if (gfLightningLayer != null)
		gfLightningLayer.strength =
			value;

	if (dadLightningLayer != null)
		dadLightningLayer.strength =
			value;

	if (petLightningLayer != null)
		petLightningLayer.strength =
			value;

	if (bfPlatformLightningLayer != null)
		bfPlatformLightningLayer.strength =
			value;

	if (petBoardLightningLayer != null)
		petBoardLightningLayer.strength =
			value;

	if (gfBoardLightningLayer != null)
		gfBoardLightningLayer.strength =
			value;
}

function getDangerEyeLayers(
	symbolName:String
):Array<String>
{
	switch (symbolName)
	{
		case '!EXPORT/black idle':
			return ['Layer 7'];

		case '!EXPORT/black left':
			return ['Layer 4'];

		case '!EXPORT/black down':
			return ['Layer 2'];

		case '!EXPORT/black up':
			return ['Layer 8'];

		case '!EXPORT/black right':
			return ['Layer 2'];

		case '!EXPORT/black prepare':
			return [
				'Layer 2',
				'Layer 2 copy'
			];

		case '!EXPORT/black SCREAM':
			return ['Layer 16'];

		case '!EXPORT/black idle angry':
			return ['Layer 7'];

		case '!EXPORT/anger down':
			return ['Layer 11'];

		case '!EXPORT/anger right':
			return ['Layer 6'];

		case '!EXPORT/anger up':
			return ['Layer 7'];

		case '!EXPORT/anger left':
			return ['Layer 7'];
	}

	return [];
}

function isDangerEyeLayer(
	symbolName:String,
	layerName:String
):Bool
{
	var layers:Array<String> =
		getDangerEyeLayers(
			symbolName
		);

	if (
		layers == null ||
		layers.length == 0
	)
		return false;

	var normalized:String =
		StringTools.trim(
			'' + layerName
		).toLowerCase();

	for (eyeLayer in layers)
	{
		var eyeName:String =
			StringTools.trim(
				'' + eyeLayer
			).toLowerCase();

		if (
			normalized ==
			eyeName
		)
			return true;
	}

	return false;
}

function prepareDangerEyeSymbol(
	sprite:FunkinSprite,
	symbolName:String
):Void
{
	if (
		sprite == null ||
		sprite.library == null ||
		symbolName == null ||
		symbolName == ''
	)
		return;

	var symbol =
		sprite.library.getSymbol(
			symbolName
		);

	if (
		symbol == null ||
		symbol.timeline == null
	)
		return;

	for (layer in symbol.timeline.layers)
	{
		if (layer == null)
			continue;

		var showLayer:Bool =
			isDangerEyeLayer(
				symbolName,
				layer.name
			);

		layer.forEachFrame(
			function(frame)
			{
				if (
					frame == null ||
					frame.elements == null
				)
					return;

				for (element in frame.elements)
					element.visible =
						showLayer;
			}
		);
	}
}

function hideOriginalDangerEye(
	sprite:FunkinSprite,
	symbolName:String
):Void
{
	if (
		sprite == null ||
		sprite.library == null
	)
		return;

	var symbol =
		sprite.library.getSymbol(
			symbolName
		);

	if (
		symbol == null ||
		symbol.timeline == null
	)
		return;

	for (layer in symbol.timeline.layers)
	{
		if (
			!isDangerEyeLayer(
				symbolName,
				layer.name
			)
		)
			continue;

		layer.forEachFrame(
			function(frame)
			{
				if (
					frame == null ||
					frame.elements == null
				)
					return;

				for (element in frame.elements)
					element.visible =
						false;
			}
		);
	}
}

function restoreOriginalDangerEye(
	sprite:FunkinSprite,
	symbolName:String
):Void
{
	if (
		sprite == null ||
		sprite.library == null
	)
		return;

	var symbol =
		sprite.library.getSymbol(
			symbolName
		);

	if (
		symbol == null ||
		symbol.timeline == null
	)
		return;

	for (layer in symbol.timeline.layers)
	{
		if (
			!isDangerEyeLayer(
				symbolName,
				layer.name
			)
		)
			continue;

		layer.forEachFrame(
			function(frame)
			{
				if (
					frame == null ||
					frame.elements == null
				)
					return;

				for (element in frame.elements)
					element.visible =
						true;
			}
		);
	}
}

function isDangerEyeCharacter(
	char:FunkinSprite
):Bool
{
	if (
		char == null ||
		char.library == null
	)
		return false;

	return char.library.getSymbol(
		'!EXPORT/black idle'
	) != null;
}

function hideOriginalDadEye():Void
{
	if (
		dad == null ||
		!isDangerEyeCharacter(dad)
	)
		return;

	if (
		dadEyeHiddenOwner == dad
	)
		return;

	for (anim in dad.animations)
	{
		if (anim == null)
			continue;

		var symbolName:String =
			'' + anim.anim;

		if (
			getDangerEyeLayers(
				symbolName
			).length == 0
		)
			continue;

		hideOriginalDangerEye(
			dad,
			symbolName
		);
	}

	dadEyeHiddenOwner =
		dad;
}

function restoreOriginalDadEye():Void
{
	var owner:FunkinSprite =
		dadEyeHiddenOwner;

	if (owner == null)
	{
		dadEyeHiddenOwner =
			null;

		return;
	}

	for (anim in owner.animations)
	{
		if (anim == null)
			continue;

		var symbolName:String =
			'' + anim.anim;

		if (
			getDangerEyeLayers(
				symbolName
			).length == 0
		)
			continue;

		restoreOriginalDangerEye(
			owner,
			symbolName
		);
	}

	dadEyeHiddenOwner =
		null;
}

function createDadEyeOverlay(
	char:FunkinSprite
):FunkinSprite
{
	if (
		char == null ||
		!isDangerEyeCharacter(char)
	)
		return null;

	var atlasPath:String =
		Paths.getPath(
			'images/${char.imageFile}',
			null,
			PathsTestMode.LOOSE
		);

	var eyeFrames:FlxAnimateFrames =
		FlxAnimateFrames.fromAnimate(
			atlasPath,
			null,
			null,
			'dangerDadEye_${char.curCharacter}',
			true,
			{
				cacheOnLoad:false
			}
		);

	if (eyeFrames == null)
		return null;

	var overlay:FunkinSprite =
		new FunkinSprite(0, 0);

	overlay.frames =
		eyeFrames;

	for (anim in char.animations)
	{
		if (anim == null)
			continue;

		var animName:String =
			'' + anim.name;

		var symbolName:String =
			'' + anim.anim;

		var eyeLayers:Array<String> =
			getDangerEyeLayers(
				symbolName
			);

		if (
			animName == '' ||
			symbolName == '' ||
			eyeLayers.length == 0
		)
			continue;

		if (
			anim.indices != null &&
			anim.indices.length > 0
		)
		{
			overlay.addAnimByIndices(
				animName,
				symbolName,
				anim.indices,
				anim.fps,
				anim.loop,
				anim.flipX,
				anim.flipY
			);
		}
		else
		{
			overlay.addAnimByPrefix(
				animName,
				symbolName,
				anim.fps,
				anim.loop,
				anim.flipX,
				anim.flipY
			);
		}

		prepareDangerEyeSymbol(
			overlay,
			symbolName
		);
	}

	overlay.shader = null;
	overlay.useRenderTexture =
		false;

	overlay.cameras =
		[camGame];

	overlay.scrollFactor.set(
		char.scrollFactor.x,
		char.scrollFactor.y
	);

	overlay.zIndex =
		char.zIndex + 0.01;

	overlay.active =
		false;

	overlay.visible =
		false;

	dadGroup.add(
		overlay
	);

	return overlay;
}

function syncDadEyeOverlay():Void
{
	if (
		dad == null ||
		dadEyeOverlay == null
	)
		return;

	if (
		!dad.exists ||
		!dad.visible ||
		dad.alpha <= 0
	)
	{
		dadEyeOverlay.visible =
			false;

		return;
	}

	var currentAnim:String =
		dad.getAnimName();

	if (
		currentAnim == '' ||
		!dadEyeOverlay.hasAnim(
			currentAnim
		)
	)
	{
		dadEyeOverlay.visible =
			false;

		return;
	}

	if (
		dadEyeAnim != currentAnim
	)
	{
		dadEyeOverlay.playAnim(
			currentAnim,
			true,
			false
		);

		if (
			dadEyeOverlay.animation.curAnim != null
		)
		{
			dadEyeOverlay
				.animation
				.curAnim
				.pause();
		}

		dadEyeAnim =
			currentAnim;
	}

	if (
		dad.animation.curAnim != null &&
		dadEyeOverlay.animation.curAnim != null
	)
	{
		var sourceFrames:Int =
			dad.animation.curAnim.numFrames;

		var eyeFrames:Int =
			dadEyeOverlay
				.animation
				.curAnim
				.numFrames;

		if (
			sourceFrames > 0 &&
			eyeFrames > 0
		)
		{
			var sourceFrame:Int =
				dad.animation.curAnim.curFrame;

			sourceFrame =
				Std.int(
					FlxMath.bound(
						sourceFrame,
						0,
						sourceFrames - 1
					)
				);

			var eyeFrame:Int;

			if (
				sourceFrames ==
				eyeFrames
			)
			{
				eyeFrame =
					sourceFrame;
			}
			else
			{
				var progress:Float =
					sourceFrames <= 1
					? 0
					: sourceFrame /
						(sourceFrames - 1);

				eyeFrame =
					Math.round(
						progress *
						(eyeFrames - 1)
					);
			}

			eyeFrame =
				Std.int(
					FlxMath.bound(
						eyeFrame,
						0,
						eyeFrames - 1
					)
				);

			dadEyeOverlay
				.animation
				.curAnim
				.curFrame =
					eyeFrame;

			dadEyeOverlay.animCurFrame =
				eyeFrame;
		}
	}

	dadEyeOverlay.x =
		dad.x;

	dadEyeOverlay.y =
		dad.y;

	dadEyeOverlay.scale.set(
		dad.scale.x,
		dad.scale.y
	);

	dadEyeOverlay.baseScale.set(
		dad.baseScale.x,
		dad.baseScale.y
	);

	dadEyeOverlay.offset.set(
		dad.offset.x,
		dad.offset.y
	);

	dadEyeOverlay.origin.set(
		dad.origin.x,
		dad.origin.y
	);

	dadEyeOverlay.angle =
		dad.angle;

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

	dadEyeOverlay.antialiasing =
		dad.antialiasing;

	dadEyeOverlay.zIndex =
		dad.zIndex + 0.01;

	dadEyeOverlay.active =
		false;

	dadEyeOverlay.visible =
		true;
}

function refreshDangerDadEye():Void
{
	if (dad == null)
		return;

	if (!isDangerEyeCharacter(dad))
	{
		restoreOriginalDadEye();

		if (dadEyeOverlay != null)
		{
			dadEyeOverlay.visible =
				false;

			dadEyeOverlay.active =
				false;
		}

		return;
	}

	hideOriginalDadEye();

	if (
		dadEyeSource != dad ||
		dadEyeOverlay == null
	)
	{
		if (dadEyeOverlay != null)
		{
			dadEyeOverlay.destroy();
			dadEyeOverlay = null;
		}

		dadEyeSource =
			dad;

		dadEyeOverlay =
			createDadEyeOverlay(
				dad
			);

		dadEyeCharacter =
			dad.curCharacter;

		dadEyeAnim =
			'';
	}

	syncDadEyeOverlay();
}

function onDestroy()
{
	if (dangerDarkTween != null)
	{
		dangerDarkTween.cancel();
		dangerDarkTween = null;
	}

	if (dangerUnscreamTween != null)
	{
		dangerUnscreamTween.cancel();
		dangerUnscreamTween = null;
	}

	if (game != null && game.camGame != null && game.camGame.filters != null && dangerDarkGameFilter != null)
		game.camGame.filters.remove(dangerDarkGameFilter);

	if (game != null && game.camHUD != null && game.camHUD.filters != null && dangerDarkHUDFilter != null)
		game.camHUD.filters.remove(dangerDarkHUDFilter);

	restoreOriginalDadEye();

	if (dadEyeOverlay != null)
	{
		dadEyeOverlay.destroy();
		dadEyeOverlay = null;
	}

	dadEyeSource = null;
	dadEyeHiddenOwner = null;
	dadEyeCharacter = '';
	dadEyeAnim = '';
}
