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
var combosPadding:Float = 0;
var pinkCanPulse:Bool = false;
var heartColorShader:ColorSwap;

var cloud1:FlxSprite;
var cloud2:FlxSprite;
var cloud3:FlxSprite;
var cloud4:FlxSprite;
var cloudbig:FlxSprite;
var pretendSky:FlxSprite;
var greenhouseSky:FlxSprite;
var greenhouseSun:FlxSprite;
var greenhouseCloudfar:FlxSprite;
var greenhouseCloudfront:FlxSprite;
var greenhouseCloudFill:FlxSprite;
var greenhouseGlasses:FlxSprite;
var greenhouseMystery:FlxSprite;
var greenhouseLmao:FlxSprite;
var greenhouseHelp:FlxSprite;

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

	var baseMatrix:Array<Float> = [];
	var rimLayerMatrix:Array<Float> = [];

	if (PlayState.SONG.song == 'Pinkwave')
	{
		baseMatrix = [
			0.3, 0.2, 0, 0, 9,
			-0.5, 0.77, 0.2, 0, 13,
			0, -0.1, 0.69, 0, 20,
			0, 0, 0, 1, 0
		];
		rimLayerMatrix = [
			1.10, 0.02, 0.00, 0, 15,
			0.04, 0.72, 0.00, 0, 7,
			0.00, 0.02, 0.32, 0, 0,
			0.00, 0.00, 0.00, 1, 0
		];
	}
	else
	{
		baseMatrix = getBaseMatrix();
		rimLayerMatrix = getBaseMatrix();
	}
	rim.setColorMatrix(baseMatrix.copy());
	rim.threshold = 0.02;
	rim.strength = 0.7;
	var layer1 = rim.addLayer(rimLayerMatrix.copy(), 90, 15, 0.01, 0.38);
	var layer2 = rim.addLayer(rimLayerMatrix.copy(), 90, 25, 0.01, 0.18);
	rim.attachedSprite = sprite;
	sprite.shader = rim;
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

function onLoad()
{
	heartColorShader = new ColorSwap();

	pretendSky = new FlxSprite(-1500, -800).loadGraphic(Paths.image(ext + 'pretender/bg sky'));
	pretendSky.antialiasing = ClientPrefs.globalAntialiasing;
	add(pretendSky);
	pretendSky.alpha = 0;

	greenhouseSky = new FlxSprite(-1500, -800).loadGraphic(Paths.image(ext + 'bg sky'));
	greenhouseSky.antialiasing = ClientPrefs.globalAntialiasing;
	greenhouseSky.cameras = [camGame];
	greenhouseSky.scrollFactor.set(0.8, 0.8);
	add(greenhouseSky);

	greenhouseSun = new FlxSprite(-400, PlayState.SONG.song == 'Heartbeart' ? -900 : -1200).loadGraphic(Paths.image(ext + 'the sun'));
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

	if (PlayState.SONG.song == 'Pinkwave')
	{
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

	if (PlayState.SONG.song == 'Pinkwave')
	{
		if (dad != null) dad.color = 0xFFFF6B70;
		if (gf != null) gf.color = 0xFFFF6B70;
		if (boyfriend != null) boyfriend.color = 0xFFFF6B70;
		if (hasPet && pet != null) pet.color = 0xFFFF6B70;
	}

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

	snapCamToPos(450, 300);
	camSpecialThing([160, 200], [380, 200], 0.5);
}

function onUpdate(elapsed:Float)
{
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
	if (PlayState.SONG.song == "Pinkwave")
	{
		var dur = songLength / 1000;

		if (greenhouseSun != null)
		{
			FlxTween.tween(greenhouseSun, {y: -1800}, dur, {ease: FlxEase.linear});
		}
		if (greenhouseCloudfar != null)
		{
			FlxTween.color(greenhouseCloudfar, dur, greenhouseCloudfar.color, 0xFF192141, {ease: FlxEase.linear});
		}
		if (greenhouseCloudfront != null)
		{
			FlxTween.color(greenhouseCloudfront, dur, greenhouseCloudfront.color, 0xFF192141, {ease: FlxEase.linear});
		}
		if (greenhouseCloudFill != null)
		{
			FlxTween.color(greenhouseCloudFill, dur, greenhouseCloudFill.color, 0xFF192141, {ease: FlxEase.linear});
		}
		if (cloud1 != null)
		{
			FlxTween.color(cloud1, dur, cloud1.color, 0xFF192141, {ease: FlxEase.linear});
		}
		if (cloud2 != null)
		{
			FlxTween.color(cloud2, dur, cloud2.color, 0xFF192141, {ease: FlxEase.linear});
		}
		if (cloud3 != null)
		{
			FlxTween.color(cloud3, dur, cloud3.color, 0xFF192141, {ease: FlxEase.linear});
		}
		if (cloud4 != null)
		{
			FlxTween.color(cloud4, dur, cloud4.color, 0xFF192141, {ease: FlxEase.linear});
		}
		if (cloudbig != null)
		{
			FlxTween.color(cloudbig, dur, cloudbig.color, 0xFF192141, {ease: FlxEase.linear});
		}
		if (greenhouseSky != null)
			FlxTween.tween(greenhouseSky, {alpha: 0}, dur, {ease: FlxEase.linear});
		if (pretendSky != null)
			FlxTween.tween(pretendSky, {alpha: 1}, dur, {ease: FlxEase.linear});
		if (greenhouseGlasses != null)
			FlxTween.color(greenhouseGlasses, dur, greenhouseGlasses.color, 0xFF192141, {ease: FlxEase.linear});
		if (greenhouseMystery != null)
		{
			FlxTween.color(greenhouseMystery, dur, greenhouseMystery.color, 0xFF192141, {ease: FlxEase.linear});
			FlxTween.tween(greenhouseMystery.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(greenhouseMystery.shader, getBaseMatrix(), dur, FlxEase.linear);
			tweenShadowLayer(greenhouseMystery.shader.layers[0], [getBaseMatrix()], dur, FlxEase.linear);
			tweenShadowLayer(greenhouseMystery.shader.layers[1], [getBaseMatrix()], dur, FlxEase.linear);
		}
		if (greenhouseLmao != null)
		{
			FlxTween.color(greenhouseLmao, dur, greenhouseLmao.color, 0xFF192141, {ease: FlxEase.linear});
			FlxTween.tween(greenhouseLmao.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(greenhouseLmao.shader, getBaseMatrix(), dur, FlxEase.linear);
			tweenShadowLayer(greenhouseLmao.shader.layers[0], [getBaseMatrix()], dur, FlxEase.linear);
			tweenShadowLayer(greenhouseLmao.shader.layers[1], [getBaseMatrix()], dur, FlxEase.linear);
		}
		if (greenhouseHelp != null)
		{
			FlxTween.color(greenhouseHelp, dur, greenhouseHelp.color, 0xFF192141, {ease: FlxEase.linear});
			FlxTween.tween(greenhouseHelp.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(greenhouseHelp.shader, getBaseMatrix(), dur, FlxEase.linear);
			tweenShadowLayer(greenhouseHelp.shader.layers[0], [getBaseMatrix()], dur, FlxEase.linear);
			tweenShadowLayer(greenhouseHelp.shader.layers[1], [getBaseMatrix()], dur, FlxEase.linear);
		}
		if (greymira != null)
		{
			FlxTween.color(greymira, dur, greymira.color, 0xFF192141, {ease: FlxEase.linear});
			FlxTween.tween(greymira.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(greymira.shader, getBaseMatrix(), dur, FlxEase.linear);
			tweenShadowLayer(greymira.shader.layers[0], [getBaseMatrix()], dur, FlxEase.linear);
			tweenShadowLayer(greymira.shader.layers[1], [getBaseMatrix()], dur, FlxEase.linear);
		}
		if (bluemira != null)
		{
			FlxTween.color(bluemira, dur, bluemira.color, 0xFF192141, {ease: FlxEase.linear});
			FlxTween.tween(bluemira.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(bluemira.shader, getBaseMatrix(), dur, FlxEase.linear);
			tweenShadowLayer(bluemira.shader.layers[0], [getBaseMatrix()], dur, FlxEase.linear);
			tweenShadowLayer(bluemira.shader.layers[1], [getBaseMatrix()], dur, FlxEase.linear);
		}
		if (pot != null)
		{
			FlxTween.color(pot, dur, pot.color, 0xFF192141, {ease: FlxEase.linear});
			FlxTween.tween(pot.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(pot.shader, getBaseMatrix(), dur, FlxEase.linear);
			tweenShadowLayer(pot.shader.layers[0], [getBaseMatrix()], dur, FlxEase.linear);
			tweenShadowLayer(pot.shader.layers[1], [getBaseMatrix()], dur, FlxEase.linear);
		}
		if (tomato != null)
		{
			FlxTween.color(tomato, dur, tomato.color, 0xFF192141, {ease: FlxEase.linear});
			FlxTween.tween(tomato.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(tomato.shader, getBaseMatrix(), dur, FlxEase.linear);
			tweenShadowLayer(tomato.shader.layers[0], [getBaseMatrix()], dur, FlxEase.linear);
			tweenShadowLayer(tomato.shader.layers[1], [getBaseMatrix()], dur, FlxEase.linear);
		}
		if (longus != null)
		{
			FlxTween.color(longus, dur, longus.color, 0xFF192141, {ease: FlxEase.linear});
			FlxTween.tween(longus.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(longus.shader, getBaseMatrix(), dur, FlxEase.linear);
			tweenShadowLayer(longus.shader.layers[0], [getBaseMatrix()], dur, FlxEase.linear);
			tweenShadowLayer(longus.shader.layers[1], [getBaseMatrix()], dur, FlxEase.linear);
		}
		if (rhmmira != null)
		{
			FlxTween.color(rhmmira, dur, rhmmira.color, 0xFF192141, {ease: FlxEase.linear});
			FlxTween.tween(rhmmira.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(rhmmira.shader, getBaseMatrix(), dur, FlxEase.linear);
			tweenShadowLayer(rhmmira.shader.layers[0], [getBaseMatrix()], dur, FlxEase.linear);
			tweenShadowLayer(rhmmira.shader.layers[1], [getBaseMatrix()], dur, FlxEase.linear);
		}
		if (vines != null)
		{
			FlxTween.color(vines, dur, vines.color, 0xFF192141, {ease: FlxEase.linear});
			FlxTween.tween(vines.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(vines.shader, getBaseMatrix(), dur, FlxEase.linear);
			tweenShadowLayer(vines.shader.layers[0], [getBaseMatrix()], dur, FlxEase.linear);
			tweenShadowLayer(vines.shader.layers[1], [getBaseMatrix()], dur, FlxEase.linear);
		}
		if (boyfriend != null)
		{
			FlxTween.color(boyfriend, dur, boyfriend.color, 0xFF192141, {ease: FlxEase.linear});
			FlxTween.tween(boyfriend.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(boyfriend.shader, getBaseMatrix(), dur, FlxEase.linear);
			tweenShadowLayer(boyfriend.shader.layers[0], [getBaseMatrix()], dur, FlxEase.linear);
			tweenShadowLayer(boyfriend.shader.layers[1], [getBaseMatrix()], dur, FlxEase.linear);
		}
		if (hasPet)
		{
			FlxTween.color(pet, dur, pet.color, 0xFF192141, {ease: FlxEase.linear});
			FlxTween.tween(pet.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(pet.shader, getBaseMatrix(), dur, FlxEase.linear);
			tweenShadowLayer(pet.shader.layers[0], [getBaseMatrix()], dur, FlxEase.linear);
			tweenShadowLayer(pet.shader.layers[1], [getBaseMatrix()], dur, FlxEase.linear);
		}
		if (gf != null)
		{
			FlxTween.color(gf, dur, gf.color, 0xFF192141, {ease: FlxEase.linear});
			FlxTween.tween(gf.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(gf.shader, getBaseMatrix(), dur, FlxEase.linear);
			tweenShadowLayer(gf.shader.layers[0], [getBaseMatrix()], dur, FlxEase.linear);
			tweenShadowLayer(gf.shader.layers[1], [getBaseMatrix()], dur, FlxEase.linear);
		}
		if (dad != null)
		{
			FlxTween.color(dad, dur, dad.color, 0xFF192141, {ease: FlxEase.linear});
			FlxTween.tween(dad.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(dad.shader, getBaseMatrix(), dur, FlxEase.linear);
			tweenShadowLayer(dad.shader.layers[0], [getBaseMatrix()], dur, FlxEase.linear);
			tweenShadowLayer(dad.shader.layers[1], [getBaseMatrix()], dur, FlxEase.linear);
		}
	}
	else
	{
		var dur = songLength / 1000;

		var colorMatrix:Array<Float> = [
			0.3, 0.2, 0, 0, 9,
			-0.5, 0.77, 0.2, 0, 13,
			0, -0.1, 0.69, 0, 20,
			0, 0, 0, 1, 0
		];
		var layerMatrix = [
			1.10, 0.02, 0.00, 0, 15,
			0.04, 0.72, 0.00, 0, 7,
			0.00, 0.02, 0.32, 0, 0,
			0.00, 0.00, 0.00, 1, 0
		];

		if (greenhouseSun != null)
		{
			FlxTween.tween(greenhouseSun, {y: -1200}, dur, {ease: FlxEase.linear});
		}
		if (greenhouseCloudfar != null)
		{
			FlxTween.color(greenhouseCloudfar, dur, greenhouseCloudfar.color, 0xFF963F47, {ease: FlxEase.linear});
		}
		if (greenhouseCloudfront != null)
		{
			FlxTween.color(greenhouseCloudfront, dur, greenhouseCloudfront.color, 0xFFA4464E, {ease: FlxEase.linear});
		}
		if (greenhouseCloudFill != null)
		{
			FlxTween.color(greenhouseCloudFill, dur, greenhouseCloudFill.color, 0xFFFF7777, {ease: FlxEase.linear});
		}
		if (cloud1 != null)
		{
			FlxTween.color(cloud1, dur, cloud1.color, 0xFF9B424A, {ease: FlxEase.linear});
		}
		if (cloud2 != null)
		{
			FlxTween.color(cloud2, dur, cloud2.color, 0xFF914049, {ease: FlxEase.linear});
		}
		if (cloud3 != null)
		{
			FlxTween.color(cloud3, dur, cloud3.color, 0xFF9F4149, {ease: FlxEase.linear});
		}
		if (cloud4 != null)
		{
			FlxTween.color(cloud4, dur, cloud4.color, 0xFF89363F, {ease: FlxEase.linear});
		}
		if (cloudbig != null)
		{
			FlxTween.color(cloudbig, dur, cloudbig.color, 0xFF924049, {ease: FlxEase.linear});
		}
		if (greenhouseSky != null)
			FlxTween.color(greenhouseSky, dur, greenhouseSky.color, 0xFFFF7777, {ease: FlxEase.linear});
		if (greenhouseGlasses != null)
			FlxTween.color(greenhouseGlasses, dur, greenhouseGlasses.color, 0xFFE95761, {ease: FlxEase.linear});
		if (greenhouseMystery != null)
		{
			FlxTween.color(greenhouseMystery, dur, greenhouseMystery.color, 0xFFFF8580, {ease: FlxEase.linear});
			FlxTween.tween(greenhouseMystery.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(greenhouseMystery.shader, colorMatrix, dur, FlxEase.linear);
			tweenShadowLayer(greenhouseMystery.shader.layers[0], [layerMatrix], dur, FlxEase.linear);
			tweenShadowLayer(greenhouseMystery.shader.layers[1], [layerMatrix], dur, FlxEase.linear);
		}
		if (greenhouseLmao != null)
		{
			FlxTween.color(greenhouseLmao, dur, greenhouseLmao.color, 0xFFE84A55, {ease: FlxEase.linear});
			FlxTween.tween(greenhouseLmao.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(greenhouseLmao.shader, colorMatrix, dur, FlxEase.linear);
			tweenShadowLayer(greenhouseLmao.shader.layers[0], [layerMatrix], dur, FlxEase.linear);
			tweenShadowLayer(greenhouseLmao.shader.layers[1], [layerMatrix], dur, FlxEase.linear);
		}
		if (greenhouseHelp != null)
		{
			FlxTween.color(greenhouseHelp, dur, greenhouseHelp.color, 0xFFE84A55, {ease: FlxEase.linear});
			FlxTween.tween(greenhouseHelp.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(greenhouseHelp.shader, colorMatrix, dur, FlxEase.linear);
			tweenShadowLayer(greenhouseHelp.shader.layers[0], [layerMatrix], dur, FlxEase.linear);
			tweenShadowLayer(greenhouseHelp.shader.layers[1], [layerMatrix], dur, FlxEase.linear);
		}
		if (greymira != null)
		{
			FlxTween.color(greymira, dur, greymira.color, 0xFFFF6262, {ease: FlxEase.linear});
			FlxTween.tween(greymira.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(greymira.shader, colorMatrix, dur, FlxEase.linear);
			tweenShadowLayer(greymira.shader.layers[0], [layerMatrix], dur, FlxEase.linear);
			tweenShadowLayer(greymira.shader.layers[1], [layerMatrix], dur, FlxEase.linear);
		}
		if (bluemira != null)
		{
			FlxTween.color(bluemira, dur, bluemira.color, 0xFF8A3943, {ease: FlxEase.linear});
			FlxTween.tween(bluemira.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(bluemira.shader, colorMatrix, dur, FlxEase.linear);
			tweenShadowLayer(bluemira.shader.layers[0], [layerMatrix], dur, FlxEase.linear);
			tweenShadowLayer(bluemira.shader.layers[1], [layerMatrix], dur, FlxEase.linear);
		}
		if (pot != null)
		{
			FlxTween.color(pot, dur, pot.color, 0xFFE54852, {ease: FlxEase.linear});
			FlxTween.tween(pot.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(pot.shader, colorMatrix, dur, FlxEase.linear);
			tweenShadowLayer(pot.shader.layers[0], [layerMatrix], dur, FlxEase.linear);
			tweenShadowLayer(pot.shader.layers[1], [layerMatrix], dur, FlxEase.linear);
		}
		if (tomato != null)
		{
			FlxTween.color(tomato, dur, tomato.color, 0xFFFF6262, {ease: FlxEase.linear});
			FlxTween.tween(tomato.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(tomato.shader, colorMatrix, dur, FlxEase.linear);
			tweenShadowLayer(tomato.shader.layers[0], [layerMatrix], dur, FlxEase.linear);
			tweenShadowLayer(tomato.shader.layers[1], [layerMatrix], dur, FlxEase.linear);
		}
		if (longus != null)
		{
			FlxTween.color(longus, dur, longus.color, 0xFFFF6262, {ease: FlxEase.linear});
			FlxTween.tween(longus.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(longus.shader, colorMatrix, dur, FlxEase.linear);
			tweenShadowLayer(longus.shader.layers[0], [layerMatrix], dur, FlxEase.linear);
			tweenShadowLayer(longus.shader.layers[1], [layerMatrix], dur, FlxEase.linear);
		}
		if (rhmmira != null)
		{
			FlxTween.color(rhmmira, dur, rhmmira.color, 0xFF192141, {ease: FlxEase.linear});
			FlxTween.tween(rhmmira.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(rhmmira.shader, colorMatrix, dur, FlxEase.linear);
			tweenShadowLayer(rhmmira.shader.layers[0], [layerMatrix], dur, FlxEase.linear);
			tweenShadowLayer(rhmmira.shader.layers[1], [layerMatrix], dur, FlxEase.linear);
		}
		if (vines != null)
		{
			FlxTween.color(vines, dur, vines.color, 0xFFE54852, {ease: FlxEase.linear});
			FlxTween.tween(vines.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(vines.shader, colorMatrix, dur, FlxEase.linear);
			tweenShadowLayer(vines.shader.layers[0], [layerMatrix], dur, FlxEase.linear);
			tweenShadowLayer(vines.shader.layers[1], [layerMatrix], dur, FlxEase.linear);
		}
		if (boyfriend != null)
		{
			FlxTween.color(boyfriend, dur, boyfriend.color, 0xFFFF6B70, {ease: FlxEase.linear});
			FlxTween.tween(boyfriend.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(boyfriend.shader, colorMatrix, dur, FlxEase.linear);
			tweenShadowLayer(boyfriend.shader.layers[0], [layerMatrix], dur, FlxEase.linear);
			tweenShadowLayer(boyfriend.shader.layers[1], [layerMatrix], dur, FlxEase.linear);
		}
		if (hasPet)
		{
			FlxTween.color(pet, dur, pet.color, 0xFFFF6B70, {ease: FlxEase.linear});
			FlxTween.tween(pet.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(pet.shader, colorMatrix, dur, FlxEase.linear);
			tweenShadowLayer(pet.shader.layers[0], [layerMatrix], dur, FlxEase.linear);
			tweenShadowLayer(pet.shader.layers[1], [layerMatrix], dur, FlxEase.linear);
		}
		if (gf != null)
		{
			FlxTween.color(gf, dur, gf.color, 0xFFFF6B70, {ease: FlxEase.linear});
			FlxTween.tween(gf.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(gf.shader, colorMatrix, dur, FlxEase.linear);
			tweenShadowLayer(gf.shader.layers[0], [layerMatrix], dur, FlxEase.linear);
			tweenShadowLayer(gf.shader.layers[1], [layerMatrix], dur, FlxEase.linear);
		}
		if (dad != null)
		{
			FlxTween.color(dad, dur, dad.color, 0xFFFF6B70, {ease: FlxEase.linear});
			FlxTween.tween(dad.shader, {threshold: .01, strength: 1}, dur, {ease: FlxEase.linear});
			tweenColorMatrix(dad.shader, colorMatrix, dur, FlxEase.linear);
			tweenShadowLayer(dad.shader.layers[0], [layerMatrix], dur, FlxEase.linear);
			tweenShadowLayer(dad.shader.layers[1], [layerMatrix], dur, FlxEase.linear);
		}
	}
}