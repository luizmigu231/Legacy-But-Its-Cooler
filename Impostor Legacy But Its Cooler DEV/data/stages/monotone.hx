import funkin.data.ClientPrefs;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import Reflect;

var ext = 'stages/skeld/monotone/';
var Rext = 'stages/polus/red/';
var Vext = 'stages/mira/ejected/';
var bbg:FlxSprite;
var introTween:FlxTween;
var black:FlxSprite;
var yapsesh:FlxSprite;
var bgblue:FlxSprite;
var bgblue2:FlxSprite;
var bgblue3:FlxSprite;
var floor:FlxSprite;
var wires:FlxSprite;
var blueRoom:FlxSpriteGroup;
var redRoom:FlxSpriteGroup;
var greenRoom:FlxSpriteGroup;
var bggreen:FlxSprite;
var sungreen:FlxSprite;
var greentower:FlxSprite;
var defeatthing:FlxSprite;
var platform:FlxSprite;
var speedlines:FlxBackdrop;
var blackImage:FlxSprite;
var lightoverlay:FlxSprite;
var lightoverlay2:FlxSprite;
var hsv1:HSLColorSwap = (ClientPrefs.shaders ? new funkin.game.shaders.HSLColorSwap() : null);
var spinPet = false;
public var copyPet:FunkinSprite;

var redSky:FlxSprite;
var redRocks:FlxSprite;
var redHills:FlxSprite;
var redWarehouse:FlxSprite;
var redGround:FlxSprite;
var redDreamTime:Float = 0;

var mistBack:FlxBackdrop;
var mistMid:FlxBackdrop;
var mistFront:FlxBackdrop;
var mistDreamTime:Float = 0;

var monoDreamTime:Float = 0;

var redBFRimlight:ExtraDropShadowShader;
var redDadRimlight:ExtraDropShadowShader;
var redPetRimlight:ExtraDropShadowShader;

var monoBFRimlight:ExtraDropShadowShader;
var monoDadRimlight:ExtraDropShadowShader;
var monoPetRimlight:ExtraDropShadowShader;

var greenBFRimlight:ExtraDropShadowShader;
var greenDadRimlight:ExtraDropShadowShader;
var greenPetRimlight:ExtraDropShadowShader;
var greenPlatformRimlight:ExtraDropShadowShader;

var blackDadRimlight:ExtraDropShadowShader;

function onDestroy()
{
	FlxG.camera.bgColor = 0xFF000000;
}

function onLoad()
{
	FlxG.camera.bgColor = 0xFF201F34;

	blueRoom = new FlxSpriteGroup();
	redRoom = new FlxSpriteGroup();
	greenRoom = new FlxSpriteGroup();

	redRoom.alpha = 0;
	greenRoom.alpha = 0;

	pet.origin.set(pet.width / 2, pet.height - 50);

	var bars:FlxSpriteGroup = new FlxSpriteGroup();
	bars.cameras = [camHUD];
	add(bars);

	for (i in 0...2)
	{
		var bar = new FlxSprite().makeGraphic(FlxG.width + 3, 90, FlxColor.BLACK);
		bar.y = i == 1 ? 630 : 0;
		bars.add(bar);
	}

	bbg = new FlxSprite(50, 531).loadGraphic(Paths.image(ext + 'back'));
	bbg.setGraphicSize(Std.int(bbg.width * 2));
	bbg.updateHitbox();
	blueRoom.add(bbg);

	bgblue = new FlxSprite(0, 25).loadGraphic(Paths.image(ext + 'backthings'));
	bgblue.setGraphicSize(Std.int(bgblue.width * 2));
	bgblue.setColorTransform(0.86, 0.94, 1.00, 1, 0, 8, 18, 0);
	blueRoom.add(bgblue);

	floor = new FlxSprite(0, 1150).loadGraphic(Paths.image(ext + 'Floor'));
	floor.setGraphicSize(Std.int(floor.width * 2));
	floor.setColorTransform(0.84, 0.92, 1.00, 1, 0, 8, 18, 0);
	blueRoom.add(floor);

	defeatthing = new FlxSprite(330, 500);
	defeatthing.loadGraphic(Paths.image('stages/void/defeatpulse'));
	defeatthing.setGraphicSize(Std.int(defeatthing.width * 4));
	defeatthing.antialiasing = ClientPrefs.globalAntialiasing;
	defeatthing.scrollFactor.set(0.8, 0.8);
	defeatthing.alpha = 0;
	add(defeatthing);

	bgblue2 = new FlxSprite(570, -150).loadGraphic(Paths.image(ext + 'Reactor'));
	bgblue2.setGraphicSize(Std.int(bgblue2.width * 2));
	bgblue2.setColorTransform(0.84, 0.94, 1.00, 1, 0, 10, 24, 0);
	blueRoom.add(bgblue2);

	redSky = new FlxSprite(100, -200).loadGraphic(Paths.image(Rext + 'polus_custom_sky'));
	redSky.scrollFactor.set(0.5, 0.5);
	redSky.setGraphicSize(Std.int(redSky.width * 1.8));
	redSky.alpha = 0.82;
	redSky.setColorTransform(1.00, 0.82, 0.98, 1, 12, 0, 28, 0);
	redRoom.add(redSky);

	redRocks = new FlxSprite(125, 0).loadGraphic(Paths.image(Rext + 'polusrocks'));
	redRocks.setGraphicSize(Std.int(redRocks.width * 1.2));
	redRocks.scrollFactor.set(0.6, 0.6);
	redRocks.alpha = 0.68;
	redRocks.setColorTransform(0.96, 0.78, 0.98, 1, 8, 0, 22, 0);
	redRoom.add(redRocks);

	redHills = new FlxSprite(-705, 200.55).loadGraphic(Paths.image(Rext + 'polusHills'));
	redHills.setGraphicSize(Std.int(redHills.width * 1.2));
	redHills.scrollFactor.set(0.9, 0.9);
	redHills.alpha = 0.76;
	redHills.setColorTransform(0.92, 0.72, 0.98, 1, 6, 0, 24, 0);
	redRoom.add(redHills);

	redWarehouse = new FlxSprite(1000, 30).loadGraphic(Paths.image(Rext + 'polus_custom_lab'));
	redWarehouse.setGraphicSize(Std.int(redWarehouse.width * 1.4));
	redWarehouse.alpha = 0.88;
	redWarehouse.setColorTransform(0.96, 0.80, 1.00, 1, 10, 0, 24, 0);
	redRoom.add(redWarehouse);

	redGround = new FlxSprite(-800, 650).loadGraphic(Paths.image(Rext + 'polus_custom_floor'));
	redGround.setGraphicSize(Std.int(redGround.width * 1.4));
	redGround.alpha = 0.86;
	redGround.setColorTransform(0.94, 0.76, 0.98, 1, 8, 0, 24, 0);
	redRoom.add(redGround);

	if (!ClientPrefs.lowQuality)
	{
		mistBack = new FlxBackdrop().loadGraphic(Paths.image(ext + 'mistBack'));
		mistBack.setPosition(-650, 1550);
		mistBack.scrollFactor.set(0.35, 0.35);
		mistBack.scale.set(1.1, 1.1);
		mistBack.updateHitbox();
		mistBack.velocity.x = -18;
		mistBack.alpha = 0.24;
		mistBack.color = 0xFFE2D5DB;
		mistBack.zIndex = 25;
		redRoom.add(mistBack);

		mistMid = new FlxBackdrop().loadGraphic(Paths.image(ext + 'mistMid'));
		mistMid.setPosition(-650, 1450);
		mistMid.scrollFactor.set(0.65, 0.65);
		mistMid.scale.set(1.0, 1.0);
		mistMid.updateHitbox();
		mistMid.velocity.x = 32;
		mistMid.alpha = 0.19;
		mistMid.color = 0xFFE9DEE3;
		mistMid.zIndex = 45;
		redRoom.add(mistMid);

		mistFront = new FlxBackdrop().loadGraphic(Paths.image(ext + 'mistFront'));
		mistFront.setPosition(-650, 1370);
		mistFront.scrollFactor.set(1.0, 1.0);
		mistFront.scale.set(1.0, 1.0);
		mistFront.updateHitbox();
		mistFront.velocity.x = -45;
		mistFront.alpha = 0;
		mistFront.color = 0xFFF1E8EB;
		mistFront.zIndex = 465;
		add(mistFront);
	}

	bgblue3 = new FlxSprite(350, 460).loadGraphic(Paths.image(ext + 'Reactorlight'));
	bgblue3.setGraphicSize(Std.int(bgblue3.width * 2));
	bgblue3.blend = BlendMode.ADD;
	bgblue3.color = 0xFF8DEBFF;
	blueRoom.add(bgblue3);

	add(blueRoom);
	add(redRoom);

	wires = new FlxSprite(0, -100).loadGraphic(Paths.image(ext + 'wires1'));
	wires.updateHitbox();
	wires.alpha = 0;
	add(wires);

	bggreen = new FlxSprite(-200, -1600).loadGraphic(Paths.image(ext + 'evilejected'));
	bggreen.scrollFactor.set(0, 0);
	bggreen.setGraphicSize(Std.int(bggreen.width * 2));
	add(bggreen);

	sungreen = new FlxSprite(1000, -80).loadGraphic(Paths.image(Vext + 'sun'));
	sungreen.scrollFactor.set(0, 0);
	sungreen.color = 0xFF72FF3B;
	sungreen.alpha = 0.72;
	sungreen.blend = BlendMode.ADD;
	add(sungreen);

	greentower = new FlxSprite(550, 0).loadGraphic(Paths.image(ext + 'brombom'));
	greentower.setGraphicSize(Std.int(greentower.width * 1.5));
	greentower.scrollFactor.set(0.1, 0.1);
	greentower.updateHitbox();
	add(greentower);

	bggreen.alpha = 0;
	sungreen.alpha = 0;
	greentower.alpha = 0;

	platform = new FlxSprite(1340, 1110);
	platform.frames = Paths.getSparrowAtlas('stages/common/platform');
	platform.animation.addByPrefix('bop', 'floating', 24, true);
	platform.animation.play('bop');
	platform.alpha = 0.00001;
	add(platform);

	copyPet = new funkin.objects.Pet(142, PET_Y);
}

function onGameOverStart()
{
	FlxG.camera.bgColor = FlxColor.BLACK;
}

function onCreatePost()
{
	blackImage = new flixel.system.FlxBGSprite();
	blackImage.color = FlxColor.BLACK;
	blackImage.alpha = 0;
	stage.insert(stage.members.indexOf(dadGroup) + 1, blackImage);

	copyPet.loadPet(pet.curPet);
	copyPet.flipX = !copyPet.flipX;
	copyPet.x -= (copyPet._petOffset.x * 2);
	add(copyPet);

	var grayscale:ExtraDropShadowShader = new funkin.game.shaders.ExtraDropShadowShader();
	grayscale.threshold = .05;
	grayscale.strength = .85;
	grayscale.setColorMatrix([
		0.31, 0.52, 0.17, 0, 0,
		0.31, 0.52, 0.17, 0, 0,
		0.31, 0.52, 0.17, 0, 0,
		0,    0,    0,    1, 0
	]);
	grayscale.attachedSprite = copyPet;
	copyPet.useRenderTexture = true;

	if (Paths.fileExists('scripts/vent.hx'))
		initScript('scripts/vent');

	preloadVariant('falling');
	preloadVariant('defeat');
	preloadVariant('windy');

	addCharacterToList('greenEjected', 1);
	addCharacterToList('monotone', 1);
	addCharacterToList('red', 1);
	addCharacterToList('black', 1);

	if (hasBfSkin)
	{
		final shift:Null<String> = (boyfriend.getFlag('variants')?.monotone ?? boyfriend.getFlag('customMonotone'));

		changeCharacter(shift ?? boyfriend.curCharacter, 1);

		if (dad.isPlayerInEditor)
		{
			dad.baseFlipX = !dad.baseFlipX;

			var swapAnims:Map<String, String> = [
				'singLEFT' => 'singRIGHT',
				'danceLeft' => 'danceRight'
			];

			var ogAnims = dad.animation.getNameList().copy();

			for (animName in ogAnims)
			{
				for (name => newName in swapAnims)
				{
					if (StringTools.startsWith(animName, name))
					{
						dad.swapAnims(animName, newName + animName.substr(name.length));
					}
				}
			}
		}

		if (shift == null)
			dad.x = (-boyfriend.x - dad.baseFrameWidth + (dad.getFlag('monotoneXOffset') ?? 0) + 1920);
	}

	camHUD.alpha = .0001;

	snapCamToPos(960, 700);
	camSpecialThing([960, 700], [960, 700]);

	lightoverlay = new FlxSprite(500, 275).loadGraphic(Paths.image(ext + 'overlay'));
	lightoverlay.setGraphicSize(Std.int(lightoverlay.width * 4));
	lightoverlay.blend = BlendMode.SUBTRACT;
	if (ClientPrefs.shaders)
		lightoverlay.shader = hsv1.shader;
	add(lightoverlay);

	lightoverlay2 = new FlxSprite(500, 275).loadGraphic(Paths.image(ext + 'overlay2'));
	lightoverlay2.blend = BlendMode.ADD;
	lightoverlay2.setGraphicSize(Std.int(lightoverlay2.width * 4));
	if (ClientPrefs.shaders)
		lightoverlay2.shader = hsv1.shader;
	add(lightoverlay2);

	black = new FlxSprite().makeGraphic(
		Std.int(camOther.width + 10),
		Std.int(camOther.height + 10),
		FlxColor.BLACK
	);
	black.camera = camOther;
	black.scrollFactor.set(0, 0);
	black.setPosition(-5, -5);
	add(black);
	black.visible = true;

	yapsesh = new FlxSprite(0, 0);
	yapsesh.frames = Paths.getSparrowAtlas(ext + 'dialogue');
	yapsesh.animation.addByPrefix('bop', 'dialogue', 22, false);
	yapsesh.camera = camOther;
	yapsesh.zIndex = 12;
	yapsesh.screenCenter();
	yapsesh.setGraphicSize(Std.int(yapsesh.width * 0.6));
	yapsesh.alpha = 0;
	add(yapsesh);

	speedlines = new FlxBackdrop().loadGraphic(Paths.image(ext + 'speedlines'));
	speedlines.scale.set(3, 3);
	speedlines.updateHitbox();
	speedlines.scrollFactor.set(.3, .3);
	speedlines.alpha = 0.00001;
	add(speedlines);

	pauseOverwrite = 'monotone';

	createRedShaders();
	createGreenShaders();
	createMonotoneShaders();
}

function createRedShaders()
{
	if (!ClientPrefs.shaders)
		return;

	redBFRimlight = new funkin.game.shaders.ExtraDropShadowShader();
	redBFRimlight.threshold = .045;
	redBFRimlight.strength = .82;
	redBFRimlight.roughness = .012;

	redBFRimlight.setColorMatrix([
		.72, .06, .00, 0, -8,
		.045, .66, .035, 0, -8,
		.008, .035, .60, 0, -8,
		0,   0,   0,    1, 0
	]);

	redBFRimlight.addLayer([
		1,0,0,0,170,
		0,1,0,0,100,
		0,0,1,0,255,
		0,0,0,1,0
	], 140, 15, .018, .72);

	redDadRimlight = new funkin.game.shaders.ExtraDropShadowShader();
	redDadRimlight.threshold = .045;
	redDadRimlight.strength = .80;
	redDadRimlight.roughness = .012;

	redDadRimlight.setColorMatrix([
		.72, .06, .00, 0, -8,
		.045, .66, .035, 0, -8,
		.008, .035, .60, 0, -8,
		0,   0,   0,    1, 0
	]);

	redDadRimlight.addLayer([
		1,0,0,0,170,
		0,1,0,0,100,
		0,0,1,0,255,
		0,0,0,1,0
	], 90, 15, .018, .70);

	redPetRimlight = new funkin.game.shaders.ExtraDropShadowShader();
	redPetRimlight.threshold = .055;
	redPetRimlight.strength = .68;
	redPetRimlight.roughness = .018;

	redPetRimlight.setColorMatrix([
		.74, .05, .00, 0, -7,
		.04, .68, .03, 0, -7,
		.008, .03, .62, 0, -7,
		0,   0,   0,    1, 0
	]);

	redPetRimlight.addLayer([
		1,0,0,0,170,
		0,1,0,0,100,
		0,0,1,0,255,
		0,0,0,1,0
	], 140, 12, .022, .56);
}

function createMonotoneShaders()
{
	if (!ClientPrefs.shaders)
		return;

	monoBFRimlight = new funkin.game.shaders.ExtraDropShadowShader();
	monoBFRimlight.threshold = .045;
	monoBFRimlight.strength = .68;
	monoBFRimlight.roughness = .012;

	monoBFRimlight.setColorMatrix([
		.62, .22, .12, 0, -10,
		.18, .58, .24, 0, -8,
		.12, .28, .58, 0, 4,
		0,   0,   0,   1, 0
	]);

	monoBFRimlight.addLayer([
		1,0,0,0,35,
		0,1,0,0,215,
		0,0,1,0,255,
		0,0,0,1,0
	], 180, 13, .018, .62);

	monoDadRimlight = new funkin.game.shaders.ExtraDropShadowShader();
	monoDadRimlight.threshold = .045;
	monoDadRimlight.strength = .72;
	monoDadRimlight.roughness = .012;

	monoDadRimlight.setColorMatrix([
		.58, .24, .14, 0, -14,
		.16, .54, .26, 0, -10,
		.10, .26, .54, 0, 2,
		0,   0,   0,   1, 0
	]);

	monoDadRimlight.addLayer([
		1,0,0,0,35,
		0,1,0,0,215,
		0,0,1,0,255,
		0,0,0,1,0
	], 0, 15, .018, .68);

	monoPetRimlight = new funkin.game.shaders.ExtraDropShadowShader();
	monoPetRimlight.threshold = .055;
	monoPetRimlight.strength = .58;
	monoPetRimlight.roughness = .018;

	monoPetRimlight.setColorMatrix([
		.66, .20, .12, 0, -8,
		.18, .60, .22, 0, -6,
		.10, .28, .58, 0, 4,
		0,   0,   0,   1, 0
	]);

	monoPetRimlight.addLayer([
		1,0,0,0,35,
		0,1,0,0,215,
		0,0,1,0,255,
		0,0,0,1,0
	], 180, 10, .022, .50);
}

function createGreenShaders()
{
	if (!ClientPrefs.shaders)
		return;

	greenBFRimlight = new funkin.game.shaders.ExtraDropShadowShader();
	greenBFRimlight.threshold = .045;
	greenBFRimlight.strength = .72;
	greenBFRimlight.roughness = .010;

	greenBFRimlight.setColorMatrix([
		.20, .35, .08, 0, -25,
		.05, .55, .08, 0, -18,
		.05, .30, .18, 0, -35,
		0, 0, 0, 1, 0
	]);

	greenBFRimlight.addLayer([
		.02, .72, .01, 0, 35,
		.01, .95, .02, 0, 75,
		.00, .45, .01, 0, 25,
		0,   0,   0,   1, 0
	], 135, 14, .014, .72);

	greenDadRimlight = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(greenBFRimlight);
	greenDadRimlight.layers[0].angle = 45;

	greenPetRimlight = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(greenBFRimlight);

	greenPlatformRimlight = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(greenBFRimlight);
}

function createBlackShader()
{
	if (!ClientPrefs.shaders)
		return;

	blackDadRimlight = new funkin.game.shaders.ExtraDropShadowShader();
	blackDadRimlight.threshold = .05;
	blackDadRimlight.strength = .85;

	blackDadRimlight.addLayer([
		.7, .5, 1, 0, 192,
		.3, .4, -.5, 0, 64,
		-.1, .2, .35, 0, 74,
		0, 0, 0, 1, 0
	], 10, 14, .01);

	blackDadRimlight.addLayer([
		.9, .6, .4, 0, 4,
		-.2, .5, .1, 0, -18,
		-.2, .2, .4, 0, -28,
		0, 0, 0, 1, 0
	], 12, 40, .01, .4);

	blackDadRimlight.layers[0].angle = 170;
	blackDadRimlight.layers[1].angle = 88;
}

function applyRedShaders()
{
	if (!ClientPrefs.shaders)
		return;

	if (redBFRimlight != null && boyfriend != null && hasBfSkin && boyfriend.getFlag('backlit') != true)
	{
		redBFRimlight.attachedSprite = boyfriend;
		boyfriend.useRenderTexture = true;
		boyfriend.shader = redBFRimlight;
	}

	if (redDadRimlight != null && dad != null && dad.curCharacter == 'red')
	{
		redDadRimlight.attachedSprite = dad;
		dad.useRenderTexture = true;
		dad.shader = redDadRimlight;
	}

	if (redPetRimlight != null && pet != null && hasPet)
	{
		redPetRimlight.attachedSprite = pet;
		pet.useRenderTexture = true;
		pet.shader = redPetRimlight;
	}
}

function applyMonotoneShaders()
{
	if (!ClientPrefs.shaders)
		return;

	if (monoBFRimlight != null && boyfriend != null)
	{
		monoBFRimlight.attachedSprite = boyfriend;
		boyfriend.useRenderTexture = true;
		boyfriend.shader = monoBFRimlight;
	}

	if (monoDadRimlight != null && dad != null && dad.curCharacter == 'monotone')
	{
		monoDadRimlight.attachedSprite = dad;
		dad.useRenderTexture = true;
		dad.shader = monoDadRimlight;
	}

	if (monoPetRimlight != null && pet != null && hasPet)
	{
		monoPetRimlight.attachedSprite = pet;
		pet.useRenderTexture = true;
		pet.shader = monoPetRimlight;
	}
}

function applyGreenShaders()
{
	if (!ClientPrefs.shaders)
		return;

	if (greenBFRimlight != null && boyfriend != null)
	{
		greenBFRimlight.attachedSprite = boyfriend;
		boyfriend.useRenderTexture = true;
		boyfriend.shader = greenBFRimlight;
	}

	if (greenDadRimlight != null && dad != null)
	{
		greenDadRimlight.attachedSprite = dad;
		dad.useRenderTexture = true;
		dad.shader = greenDadRimlight;
	}

	if (greenPetRimlight != null && pet != null)
	{
		greenPetRimlight.attachedSprite = pet;
		pet.useRenderTexture = true;
		pet.shader = greenPetRimlight;
	}

	if (greenPlatformRimlight != null && platform != null)
	{
		greenPlatformRimlight.attachedSprite = platform;
		platform.shader = greenPlatformRimlight;
	}
}

function applyBlackShader()
{
	if (!ClientPrefs.shaders)
		return;

	if (blackDadRimlight != null && dad != null && dad.curCharacter == 'black')
	{
		blackDadRimlight.attachedSprite = dad;
		dad.useRenderTexture = true;
		dad.shader = blackDadRimlight;
	}
}

function clearRedShaders()
{
	if (boyfriend != null && boyfriend.shader == redBFRimlight)
		boyfriend.shader = null;

	if (dad != null && dad.shader == redDadRimlight)
		dad.shader = null;

	if (pet != null && pet.shader == redPetRimlight)
		pet.shader = null;
}

function clearMonotoneShaders()
{
	if (boyfriend != null && boyfriend.shader == monoBFRimlight)
		boyfriend.shader = null;

	if (dad != null && dad.shader == monoDadRimlight)
		dad.shader = null;

	if (pet != null && pet.shader == monoPetRimlight)
		pet.shader = null;
}

function clearGreenShaders()
{
	if (boyfriend != null && boyfriend.shader == greenBFRimlight)
		boyfriend.shader = null;

	if (dad != null && dad.shader == greenDadRimlight)
		dad.shader = null;

	if (pet != null && pet.shader == greenPetRimlight)
		pet.shader = null;

	if (platform != null && platform.shader == greenPlatformRimlight)
		platform.shader = null;
}

function clearBlackShader()
{
	if (dad != null && dad.shader == blackDadRimlight)
		dad.shader = null;
}

function onSongStart()
{
	if (hasBfSkin)
		game.unlockAchievementPopup('double_trouble');
}

function onEvent(n, v1, v2)
{
	switch (n)
	{
		case 'Legacy':
			if (v1 == 'red' || v1 == 'green' || v1 == 'monotone' || v1 == 'black')
			{
				if (ClientPrefs.shaders)
				{
					hsv1.hue = 0;
				}
				else
				{
					lightoverlay.setColorTransform();
					lightoverlay2.setColorTransform();
				}

				clearRedShaders();
				clearMonotoneShaders();
				clearGreenShaders();
				clearBlackShader();

				pauseOverwrite = '';

				if (v1 != 'green' && v1 != 'black')
					setVariant();

				platform.alpha = 0;
				defeatthing.alpha = 0;
				bggreen.alpha = 0;
				sungreen.alpha = 0;
				lightoverlay.alpha = 1;
				lightoverlay2.alpha = 1;
				speedlines.alpha = 0;
				greentower.alpha = 0;
				redRoom.alpha = 0;
				blueRoom.alpha = 0;
				greenRoom.alpha = 0;
				wires.alpha = 0;

				if (mistFront != null)
					mistFront.alpha = 0;

				defeatness(v1 == 'black');
			}

			switch (v1)
			{
				case 'crisis_line':
					yapsesh.alpha = 1;
					yapsesh.animation.play('bop');

				case 'red':
					defeatthing.alpha = 0;
					redRoom.alpha = 1;
					wires.alpha = 0;

					redDreamTime = 0;
					mistDreamTime = 0;

					if (ClientPrefs.shaders)
					{
						hsv1.hue = -118 / 255;
					}
					else
					{
						lightoverlay.setColorTransform(.2, .2, .2, 1, 0, 128, 20);
						lightoverlay2.setColorTransform(0, 0, 0, 1, 255, 0, 20);
					}

					lightoverlay.alpha = 0.62;
					lightoverlay2.alpha = 0.78;

					if (mistFront != null)
						mistFront.alpha = 0.13;

					triggerEventNote('Change Character', 'dad', 'red');
					spinPet = false;
					bbg.alpha = 0;
					applyRedShaders();

				case 'monotone':
					triggerEventNote('Change Character', 'dad', 'monotone');
					defeatthing.alpha = 0;
					blueRoom.alpha = 1;
					redRoom.alpha = 0;
					greenRoom.alpha = 0;
					wires.alpha = 1;
					sungreen.alpha = 0;
					dad.originalFlipX = dad.originalFlipX;
					spinPet = false;
					bbg.alpha = 1;
					monoDreamTime = 0;

					if (mistFront != null)
						mistFront.alpha = 0;

					if (ClientPrefs.shaders)
						applyMonotoneShaders();

				case 'green':
					setVariant('falling');
					spinPet = true;
					triggerEventNote('Change Character', 'dad', 'greenEjected');
					bggreen.alpha = 1;
					sungreen.alpha = 0.72;
					lightoverlay2.alpha = 0;
					greentower.alpha = 1;
					speedlines.alpha = 0.5;
					wires.alpha = 0;

					if (mistFront != null)
						mistFront.alpha = 0;

					if (hasBfSkin && boyfriend.getFlag('floating') != true)
						platform.alpha = 1;

					greentower.y = 0;
					FlxTween.tween(greentower, {y: -300}, 20);
					bbg.alpha = 0;
					defeatthing.alpha = 0;

					applyGreenShaders();

				case 'black':
					setVariant('defeat');
					triggerEventNote('Change Character', 'dad', 'black');
					defeatthing.alpha = 0.5;
					lightoverlay2.alpha = 0;
					spinPet = false;
					wires.alpha = 0;
					sungreen.alpha = 0;
					bbg.alpha = 0;

					if (mistFront != null)
						mistFront.alpha = 0;

					applyBlackShader();

				case 'ending':
					FlxTween.tween(lightoverlay2, {alpha: 0}, 10);
					FlxTween.tween(blackImage, {alpha: 1}, 12);

				case 'off':
					triggerEventNote('flash', '2', '');

				case 'on':
					triggerEventNote('flash', '3', '');
			}

		case 'flash':
			if (v1 == '2')
			{
				black.visible = true;
				black.alpha = 1;
			}

			if (v1 == '3')
			{
				black.visible = false;
				yapsesh.visible = false;
			}
	}

	if (dad.curCharacter == 'monotone')
		copyPet.kill();
}

var oldPet:Null<String> = null;
var oldBf:Null<String> = null;

function setVariant(?variant:String):Void
{
	var custom:Null<String> = (variant == null || boyfriend.getFlag('variants') == null ? null : Reflect.field(boyfriend.getFlag('variants'), variant));

	if (custom != null)
	{
		oldBf ??= boyfriend.curCharacter;
		changeCharacter(custom, 0);
	}
	else if (oldBf != null)
	{
		changeCharacter(oldBf, 0);
		oldBf = null;
	}

	custom = (variant == null || pet.getFlag('variants') == null ? null : Reflect.field(pet.getFlag('variants'), variant));

	if (custom != null)
	{
		oldPet ??= pet.curPet;
		pet.loadPet(custom);
	}
	else if (oldPet != null)
	{
		pet.loadPet(oldPet);
		oldPet = null;
	}
}

function preloadVariant(variant:String):Void
{
	var custom:Null<String> = (boyfriend.getFlag('variants') == null ? null : Reflect.field(boyfriend.getFlag('variants'), variant));

	if (custom != null)
		addCharacterToList(custom, 0);

	custom = (pet.getFlag('variants') == null ? null : Reflect.field(pet.getFlag('variants'), variant));

	if (custom != null)
		new funkin.objects.Pet().loadPet(custom).destroy();
}

function onUpdate(elapsed:Float):Void
{
	if (ClientPrefs.inDevMode)
	{
		if (FlxG.keys.justPressed.Z)
			triggerEventNote('Legacy', 'red');

		if (FlxG.keys.justPressed.X)
			triggerEventNote('Legacy', 'black');

		if (FlxG.keys.justPressed.C)
			triggerEventNote('Legacy', 'green');

		if (FlxG.keys.justPressed.V)
			triggerEventNote('Legacy', 'monotone');
	}
}

function onUpdatePost(elapsed:Float):Void
{
	if (speedlines != null)
		speedlines.y = (Conductor.songPosition * -2 * (ClientPrefs.flashing ? 1.75 : .75));

	if (dad != null)
	{
		if (dad.curCharacter == 'red')
		{
			redDreamTime += elapsed;
			mistDreamTime += elapsed;

			redSky.x = 100 + Math.sin(redDreamTime * 0.11) * 18;
			redSky.y = -200 + Math.cos(redDreamTime * 0.07) * 9;

			redRocks.x = 125 + Math.sin(redDreamTime * 0.15) * 12;
			redRocks.y = Math.cos(redDreamTime * 0.09) * 5;

			redHills.x = -705 + Math.sin(redDreamTime * 0.06) * 10;
			redHills.y = 200.55 + Math.cos(redDreamTime * 0.055) * 4;

			redWarehouse.x = 1000 + Math.sin(redDreamTime * 0.08) * 7;
			redWarehouse.y = 30 + Math.cos(redDreamTime * 0.06) * 3;

			redGround.x = -800 + Math.sin(redDreamTime * 0.045) * 14;
			redGround.y = 650 + Math.cos(redDreamTime * 0.05) * 5;

			if (!ClientPrefs.lowQuality)
			{
				if (mistBack != null)
				{
					mistBack.y = 1550 + Math.sin(mistDreamTime * 0.08) * 8;
					mistBack.alpha = 0.22 + Math.sin(mistDreamTime * 0.18) * 0.025;
				}

				if (mistMid != null)
				{
					mistMid.y = 1450 + Math.sin(mistDreamTime * 0.11 + 1.2) * 10;
					mistMid.alpha = 0.17 + Math.sin(mistDreamTime * 0.15 + 2) * 0.022;
				}

				if (mistFront != null)
				{
					mistFront.y = 1370 + Math.sin(mistDreamTime * 0.14 + 0.7) * 7;
					mistFront.alpha = 0.13 + Math.sin(mistDreamTime * 0.13) * 0.018;
				}
			}

			lightoverlay.alpha = 0.58 + Math.sin(redDreamTime * 0.32) * 0.035;
			lightoverlay2.alpha = 0.76 + Math.sin(redDreamTime * 0.24 + 1.4) * 0.055;

			if (ClientPrefs.shaders && redDadRimlight != null && dad.shader != redDadRimlight)
				applyRedShaders();

			redRoom.alpha = 1;
			blueRoom.alpha = 0;
			greenRoom.alpha = 0;
			wires.alpha = 0;
			sungreen.alpha = 0;

			if (hasBfSkin && ClientPrefs.shaders && redBFRimlight != null && boyfriend != null && boyfriend.getFlag('backlit') != true && boyfriend.shader != redBFRimlight)
				applyRedShaders();

			if (hasPet && ClientPrefs.shaders && redPetRimlight != null && pet != null && pet.shader != redPetRimlight)
				applyRedShaders();
		}
		else if (dad.curCharacter == 'monotone')
		{
			monoDreamTime += elapsed;

			bgblue.x = Math.sin(monoDreamTime * 0.06) * 4;
			bgblue.y = 25 + Math.cos(monoDreamTime * 0.08) * 3;

			bgblue2.x = 570 + Math.sin(monoDreamTime * 0.045) * 3;
			bgblue2.y = -150 + Math.cos(monoDreamTime * 0.055) * 2;

			floor.x = Math.sin(monoDreamTime * 0.035) * 5;
			floor.y = 1150 + Math.cos(monoDreamTime * 0.04) * 3;

			bgblue3.alpha = 0.72 + Math.sin(monoDreamTime * 0.18) * 0.035;

			blueRoom.alpha = 1;
			redRoom.alpha = 0;
			greenRoom.alpha = 0;
			wires.alpha = 1;
			sungreen.alpha = 0;

			if (mistFront != null)
				mistFront.alpha = 0;

			lightoverlay.alpha = 0.96 + Math.sin(monoDreamTime * 0.14) * 0.025;
			lightoverlay2.alpha = 0.92 + Math.sin(monoDreamTime * 0.11 + 1.2) * 0.025;

			if (ClientPrefs.shaders)
			{
				if (monoDadRimlight != null && dad.shader != monoDadRimlight)
					applyMonotoneShaders();

				if (monoBFRimlight != null && boyfriend != null && boyfriend.shader != monoBFRimlight)
					applyMonotoneShaders();

				if (monoPetRimlight != null && pet != null && pet.shader != monoPetRimlight)
					applyMonotoneShaders();
			}

			if (dad.shader == redDadRimlight)
				dad.shader = null;

			if (dad.shader == greenDadRimlight)
				dad.shader = null;

			if (dad.shader == blackDadRimlight)
				dad.shader = null;
		}
		else if (dad.curCharacter == 'greenEjected')
		{
			blueRoom.alpha = 0;
			redRoom.alpha = 0;
			greenRoom.alpha = 1;
			wires.alpha = 0;
			sungreen.alpha = 0.72;

			if (mistFront != null)
				mistFront.alpha = 0;

			lightoverlay.alpha = 1;

			if (ClientPrefs.shaders && greenDadRimlight != null && dad.shader != greenDadRimlight)
				applyGreenShaders();

			if (hasBfSkin && ClientPrefs.shaders && greenBFRimlight != null && boyfriend != null && boyfriend.getFlag('backlit') != true && boyfriend.shader != greenBFRimlight)
				applyGreenShaders();

			if (hasPet && ClientPrefs.shaders && greenPetRimlight != null && pet != null && pet.shader != greenPetRimlight)
				applyGreenShaders();

			if (dad.shader == redDadRimlight)
				dad.shader = null;

			if (dad.shader == blackDadRimlight)
				dad.shader = null;
		}
		else if (dad.curCharacter == 'black')
		{
			blueRoom.alpha = 0;
			redRoom.alpha = 0;
			greenRoom.alpha = 0;
			wires.alpha = 0;
			sungreen.alpha = 0;

			if (mistFront != null)
				mistFront.alpha = 0;

			lightoverlay.alpha = 1;

			if (ClientPrefs.shaders && blackDadRimlight != null && dad.shader != blackDadRimlight)
				applyBlackShader();

			if (dad.shader == redDadRimlight)
				dad.shader = null;

			if (dad.shader == greenDadRimlight)
				dad.shader = null;
		}
	}
	else
	{
		wires.alpha = 0;
		sungreen.alpha = 0;

		if (mistFront != null)
			mistFront.alpha = 0;
	}

	if (spinPet)
	{
		pet.x = (1850 + copyPet._petOffset.x);
		pet.y = (800 + copyPet._petOffset.y);
		pet.scrollFactor.set(1.2, 1.2);

		if (pet.getFlag('spin') != false)
			pet.angularVelocity = 450;

		pet.setColorTransform(1, 1, 1, 1, 0, 20, 40, -127);
		pet.colorTransform.alphaMultiplier = 2;
		pet.x += Math.sin(Conductor.songPosition / 150) * 400 * FlxG.elapsed;
		pet.y = 800 + Math.sin(Conductor.songPosition / 150) * 50;
	}
	else
	{
		pet.angle = pet.angularVelocity = 0;
		pet.x = (PET_X - pet.width * .5 + copyPet._petOffset.x);
		pet.y = (PET_Y - pet.height + copyPet._petOffset.y);
		pet.setColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
		pet.scrollFactor.set(1, 1);
		pet.setColorTransform();
	}
}

function onBeatHit()
{
	if (curBeat % 4 == 0)
	{
		defeatthing.scale.set(5.5, 5);
		defeatScaleTween = FlxTween.tween(defeatthing.scale, {x: 4, y: 4}, .8, {ease: FlxEase.sineOut});
	}

	copyPet.dance();

	switch (curBeat)
	{
		case 6:
			FlxTween.tween(black, {alpha: 0}, 15);
			introTween = FlxTween.tween(camGame, {zoom: 0.4}, 20);

		case 64:
			if (introTween != null)
				introTween.cancel();

			camSpecialThing([960, 750], [960, 750], 0.4);

		case 81:
			camSpecialThing([850, 750], [1050, 750], 0.45);

		case 88:
			camSpecialThing([700, 800], [700, 800], 0.8);

		case 95:
			camSpecialThing([850, 750], [1050, 750], 0.5);

		case 112:
			camSpecialThing([960, 750], [960, 750], 0.5);

		case 128:
			camSpecialThing([850, 750], [1050, 750], 0.6);

		case 192:
			camSpecialThing([960, 750], [960, 750], 0.5);

		case 208:
			camSpecialThing([850, 750], [1050, 750], 0.6);

		case 224:
			camSpecialThing([960, 700], [960, 700], 0.5);

		case 254:
			camSpecialThing([1300, 800], [1300, 800], 0.6);

		case 262:
			camSpecialThing([1400, 800], [1400, 800], 0.7);

		case 270:
			camSpecialThing([1450, 800], [1450, 800], 0.8);

		case 278:
			camSpecialThing([1500, 800], [1500, 800], 0.9);

		case 294:
			camSpecialThing([850, 700], [850, 700], 0.4);

		case 312:
			camSpecialThing([850, 750], [1050, 750], 0.45);

		case 328:
			camSpecialThing([650, 750], [650, 750], 0.55);

		case 334:
			camSpecialThing([650, 750], [650, 750], 0.45);

		case 344:
			camSpecialThing([1400, 800], [1300, 800], 0.7);

		case 360:
			camSpecialThing([960, 700], [960, 700], 0.5);

		case 456:
			camSpecialThing([850, 750], [1050, 750], 0.6);
	}
}

var bfRimlight:ExtraDropShadowShader;
var petRimlight:ExtraDropShadowShader;

function defeatness(ya:Bool)
{
	if (!ClientPrefs.shaders)
		return;

	if (bfRimlight == null)
	{
		bfRimlight = new funkin.game.shaders.ExtraDropShadowShader();

		bfRimlight.threshold = .05;
		bfRimlight.strength = .85;

		bfRimlight.setColorMatrix([
			.4, .5, -.2, 0, -50,
			-.25, .7, -.15, 0, -20,
			.42, -.35, .85, 0, -72,
			0, 0, 0, 1, 0
		]);

		bfRimlight.addLayer([
			.7, .5, 1, 0, 192,
			.3, .4, -.5, 0, 64,
			-.1, .2, .35, 0, 74,
			0, 0, 0, 1, 0
		], 10, 14, .01);

		bfRimlight.addLayer(
			bfRimlight.addLayer([
				.9, .6, .4, 0, 4,
				-.2, .5, .1, 0, -18,
				-.2, .2, .4, 0, -28,
				0, 0, 0, 1, 0
			], 12, 40, .01, .4)
		.colorMatrix, 96, 24, .01, .4);

		petRimlight = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(bfRimlight);

		createBlackShader();
	}

	if (ya)
	{
		if (hasBfSkin && boyfriend.getFlag('backlit') != true)
		{
			bfRimlight.attachedSprite = boyfriend;
			boyfriend.useRenderTexture = true;
			boyfriend.shader = bfRimlight;
		}

		if (hasPet)
		{
			petRimlight.attachedSprite = pet;
			pet.useRenderTexture = true;
			pet.shader = petRimlight;
		}

		if (dad != null && dad.curCharacter == 'black')
			applyBlackShader();
	}
	else
	{
		if (boyfriend != null && boyfriend.shader == bfRimlight)
			boyfriend.shader = null;

		if (pet != null && pet.shader == petRimlight)
			pet.shader = null;

		clearBlackShader();
	}
}