var ext = 'stages/mira/greenhouse/pretender/';

var cloud1:FlxSprite;
var cloud2:FlxSprite;
var cloud3:FlxSprite;
var cloud4:FlxSprite;
var cloudbig:FlxSprite;
var blueMira:FlxSprite;
var super2:FlxSprite;
var super2Tween:FlxTween;

var sky:FlxSprite;
var moonlight:FlxSprite;
var sun:FlxSprite;
var cloudfar:FlxSprite;
var cloudfront:FlxSprite;
var ground:FlxSprite;
var plantfront:FlxSprite;
var plant1:FlxSprite;
var plant2:FlxSprite;
var deadmungus:FlxSprite;
var ripbozo:FlxSprite;
var rhmdead:FlxSprite;
var pot:FlxSprite;
var vines:FlxSprite;
var super1:FlxSprite;
var pretenderLighting:FlxSprite;

var ripbozoRim:ExtraDropShadowShader;
var blueMiraRim:ExtraDropShadowShader;
var rhmdeadRim:ExtraDropShadowShader;
var deadmungusRim:ExtraDropShadowShader;
var plant1Rim:ExtraDropShadowShader;
var plant2Rim:ExtraDropShadowShader;
var potRim:ExtraDropShadowShader;
var plantfrontRim:ExtraDropShadowShader;

function onLoad()
{
	sky = new FlxSprite(-1500, -800).loadGraphic(Paths.image(ext + 'bg sky'));
	sky.antialiasing = ClientPrefs.globalAntialiasing;
	add(sky);
	
	moonlight = new FlxSprite(0, 250).loadGraphic(Paths.image(ext + 'moon light'));
	moonlight.scrollFactor.set(0.8, 0.8);
	moonlight.blend = BlendMode.ADD;
	add(moonlight);

	sun = new FlxSprite(0, 250).loadGraphic(Paths.image(ext + 'the sun'));
	sun.scrollFactor.set(0.8, 0.8);
	add(sun);

	cloudfar = new FlxSprite(-1300, -100).loadGraphic(Paths.image(ext + 'cloud fathest'));
	cloudfar.antialiasing = ClientPrefs.globalAntialiasing;
    cloudfar.blend = BlendMode.ADD;
	add(cloudfar);

	cloudfront = new FlxSprite(-1300, 100).loadGraphic(Paths.image(ext + 'cloud front'));
	cloudfront.antialiasing = ClientPrefs.globalAntialiasing;
	cloudfront.alpha = 0.6;
	add(cloudfront);

	cloud1 = new FlxBackdrop(Paths.image(ext + 'cloud 1'));
	cloud1.setPosition(0, -1000);
	cloud1.updateHitbox();
	cloud1.antialiasing = ClientPrefs.globalAntialiasing;
	cloud1.alpha = 0.6;
	add(cloud1);

	cloud2 = new FlxBackdrop(Paths.image(ext + 'cloud 2'));
	cloud2.setPosition(0, -1100);
	cloud2.updateHitbox();
	cloud2.antialiasing = ClientPrefs.globalAntialiasing;
	cloud2.alpha = 0.6;
	add(cloud2);

	cloud3 = new FlxBackdrop(Paths.image(ext + 'cloud 3'));
	cloud3.setPosition(0, -1300);
	cloud3.updateHitbox();
	cloud3.antialiasing = ClientPrefs.globalAntialiasing;
	cloud3.alpha = 0.6;
	add(cloud3);

	cloud4 = new FlxBackdrop(Paths.image(ext + 'cloud 4'));
	cloud4.setPosition(0, -1600);
	cloud4.updateHitbox();
	cloud4.antialiasing = ClientPrefs.globalAntialiasing;
	cloud4.alpha = 0.6;
	add(cloud4);

	cloudbig = new FlxBackdrop(Paths.image(ext + 'bigcloud'));
	cloudbig.setPosition(0, -1100);
	cloudbig.updateHitbox();
	cloudbig.antialiasing = ClientPrefs.globalAntialiasing;
	cloudbig.blend = BlendMode.ADD;
	add(cloudbig);

	ground = new FlxSprite(-1200, -750).loadGraphic(Paths.image(ext + 'ground'));
	ground.antialiasing = ClientPrefs.globalAntialiasing;
	add(ground);

	plantfront = new FlxSprite(-2, -680).loadGraphic(Paths.image(ext + 'front plant'));
	plantfront.antialiasing = ClientPrefs.globalAntialiasing;
	add(plantfront);

	plant1 = new FlxSprite(1000, 190).loadGraphic(Paths.image(ext + 'knocked over plant'));
	plant1.antialiasing = ClientPrefs.globalAntialiasing;
	add(plant1);

	plant2 = new FlxSprite(-800, 260).loadGraphic(Paths.image(ext + 'knocked over plant 2'));
	plant2.antialiasing = ClientPrefs.globalAntialiasing;
	add(plant2);

	deadmungus = new FlxSprite(950, 250).loadGraphic(Paths.image(ext + 'tomatodead'));
	deadmungus.antialiasing = ClientPrefs.globalAntialiasing;
	add(deadmungus);

	ripbozo = new FlxSprite(900, 500).loadGraphic(Paths.image(ext + 'ripbozo'));
	ripbozo.scale.set(0.6, 0.6);
	ripbozo.updateHitbox();
	ripbozo.antialiasing = ClientPrefs.globalAntialiasing;
	ripbozo.visible = false;
	add(ripbozo);

	rhmdead = new FlxSprite(1150, 630).loadGraphic(Paths.image(ext + 'rhmdead dead'));
	rhmdead.scrollFactor.set(1.1, 1);
	rhmdead.antialiasing = ClientPrefs.globalAntialiasing;
	add(rhmdead);

	blueMira = new FlxSprite(-1150, 400);
	blueMira.frames = Paths.getSparrowAtlas(ext + 'blued');
	blueMira.animation.addByPrefix('bop', 'bob bop', 24, false);
	blueMira.animation.play('bop');
	blueMira.scrollFactor.set(1.2, 1);
	blueMira.antialiasing = ClientPrefs.globalAntialiasing;
}

function onUpdate(elapsed)
{
	cloud1.x = FlxMath.lerp(cloud1.x, cloud1.x - 1, FlxMath.bound(elapsed * 9, 0, 1));
	cloud2.x = FlxMath.lerp(cloud2.x, cloud2.x - 3, FlxMath.bound(elapsed * 9, 0, 1));
	cloud3.x = FlxMath.lerp(cloud3.x, cloud3.x - 2, FlxMath.bound(elapsed * 9, 0, 1));
	cloud4.x = FlxMath.lerp(cloud4.x, cloud4.x - 0.1, FlxMath.bound(elapsed * 9, 0, 1));
	cloudbig.x = FlxMath.lerp(cloudbig.x, cloudbig.x - 0.5, FlxMath.bound(elapsed * 9, 0, 1));
}

function onBeatHit()
{
	if (curBeat % 4 == 0)
	{
		if (blueMira != null && blueMira.animation != null)
			blueMira.animation.play('bop');

		if (super2Tween != null)
			super2Tween.cancel();

		super2Tween = FlxTween.tween(super2, {alpha: 0.62}, 0.4, {
			ease: FlxEase.linear
		});
	}
	else if (curBeat % 4 == 2)
	{
		if (super2Tween != null)
			super2Tween.cancel();

		super2Tween = FlxTween.tween(super2, {alpha: 0.68}, 0.4, {
			ease: FlxEase.linear
		});
	}
}

function onStartCountdown()
{
	return;
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

	if (boyfriend.curCharacter == 'pretender')
	{
		ripbozo.visible = true;
	}

	if (ClientPrefs.shaders)
	{
		var rimlightBase:ExtraDropShadowShader = new funkin.game.shaders.ExtraDropShadowShader();

		rimlightBase.threshold = .035;
		rimlightBase.strength = .55;

		rimlightBase.addLayer(
			rimlightBase.addLayer(getBaseMatrix(), 20, 18, .025).colorMatrix,
			90,
			12,
			.025
		);

		var objectsRim:ExtraDropShadowShader = new funkin.game.shaders.ExtraDropShadowShader();

		objectsRim.threshold = .035;
		objectsRim.strength = .55;

		objectsRim.addLayer(
			objectsRim.addLayer(getBaseMatrix(), 20, 18, .025).colorMatrix,
			120,
			25,
			.025
		);

		if (gf.getFlag('backlit') != true)
		{
			gfRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(rimlightBase);

			gfRim.layers[0].distance = 25;
			gfRim.layers[1].distance = 25;

			gfRim.layers[0].angle = 60;
			gfRim.layers[1].angle = 120;

			gfRim.attachedSprite = gf;
			gf.useRenderTexture = true;
			gf.shader = gfRim;
		}

		if (boyfriend.getFlag('backlit') != true)
		{
			bfRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(rimlightBase);

			bfRim.layers[0].distance = 25;
			bfRim.layers[1].distance = 25;

			bfRim.layers[0].angle = 120;
			bfRim.layers[1].angle = 120;

			bfRim.attachedSprite = boyfriend;
			boyfriend.useRenderTexture = true;
			boyfriend.shader = bfRim;
		}

			dadRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(rimlightBase);

			dadRim.layers[0].distance = 25;
			dadRim.layers[1].distance = 25;

			dadRim.layers[0].angle = 120;
			dadRim.layers[1].angle = 120;

			dadRim.attachedSprite = dad;
			dad.useRenderTexture = true;
			dad.shader = dadRim;

		if (hasPet)
		{
			petRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(rimlightBase);

			petRim.layers[0].distance = 25;
			petRim.layers[1].distance = 25;

			petRim.layers[0].angle = 120;
			petRim.layers[1].angle = 120;

			petRim.attachedSprite = pet;
			pet.useRenderTexture = true;
			pet.shader = petRim;
		}

		if (ripbozo != null && ripbozo.visible)
		{
			ripbozoRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(objectsRim);
			ripbozoRim.attachedSprite = ripbozo;
			ripbozo.shader = ripbozoRim;
		}

		if (blueMira != null)
		{
			blueMiraRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(objectsRim);
			blueMiraRim.attachedSprite = blueMira;
			blueMira.shader = blueMiraRim;
		}

		if (rhmdead != null)
		{
			rhmdeadRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(objectsRim);
			rhmdeadRim.attachedSprite = rhmdead;
			rhmdead.shader = rhmdeadRim;
		}

		if (deadmungus != null)
		{
			deadmungusRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(objectsRim);
			deadmungusRim.attachedSprite = deadmungus;
			deadmungus.shader = deadmungusRim;
		}

		if (plant1 != null)
		{
			plant1Rim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(objectsRim);
			plant1Rim.attachedSprite = plant1;
			plant1.shader = plant1Rim;
		}

		if (plant2 != null)
		{
			plant2Rim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(objectsRim);
			plant2Rim.attachedSprite = plant2;
			plant2.shader = plant2Rim;
		}

		if (pot != null)
		{
			potRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(objectsRim);
			potRim.attachedSprite = pot;
			pot.shader = potRim;
		}
		
		if (plantfront != null)
		{
			plantfrontRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(objectsRim);
			plantfrontRim.attachedSprite = plantfront;
			plantfront.shader = plantfrontRim;
		}
	}

	pot = new FlxSprite(-1550, 650).loadGraphic(Paths.image(ext + 'front pot'));
	pot.scrollFactor.set(1.2, 1);
	pot.antialiasing = ClientPrefs.globalAntialiasing;

	vines = new FlxSprite(-1450, -700).loadGraphic(Paths.image(ext + 'green'));
	vines.scrollFactor.set(1.2, 1);
	vines.antialiasing = ClientPrefs.globalAntialiasing;

	super1 = new FlxSprite(-1270, -700).loadGraphic(Paths.image(ext + 'overlay1'));
	super1.antialiasing = ClientPrefs.globalAntialiasing;
	super1.blend = BlendMode.ADD;
	super1.alpha = 0.6;

	super2 = new FlxSprite(-1270, -700).loadGraphic(Paths.image(ext + 'overlay2'));
	super2.antialiasing = ClientPrefs.globalAntialiasing;
	super2.blend = BlendMode.SUBTRACT;
	super2.alpha = 0.8;

	pretenderLighting = new FlxSprite(-1670, -700).loadGraphic(Paths.image(ext + 'lightingpretender'));
	pretenderLighting.alpha = 0.35;
	pretenderLighting.antialiasing = ClientPrefs.globalAntialiasing;

	add(blueMira);
	add(pot);
	add(vines);
	add(super2);
	add(super1);
	add(pretenderLighting);

	

	cloudfar.color = 0xFF192141;
	cloudfront.color = 0xFF192141;

	cloud1.color = 0xFF192141;
	cloud2.color = 0xFF192141;
	cloud3.color = 0xFF192141;
	cloud4.color = 0xFF192141;
	cloudbig.color = 0xFF192141;

	ground.color = 0xFF192141;
	plantfront.color = 0xFF192141;

	plant1.color = 0xFF192141;
	plant2.color = 0xFF192141;

	deadmungus.color = 0xFF192141;

	if (ripbozo != null)
		ripbozo.color = 0xFF192141;

	rhmdead.color = 0xFF192141;

	blueMira.color = 0xFF192141;

	dad.color = 0xFF192141;
	gf.color = 0xFF192141;
	boyfriend.color = 0xFF192141;
	pet.color = 0xFF192141;

	pot.color = 0xFF192141;
	vines.color = 0xFF192141;

	super1.color = 0xFFD9434B;
	super2.color = 0xFF7B282F;
	pretenderLighting.color = 0xFFB63840;

	if (ClientPrefs.shaders)
	{
		if (ripbozoRim != null)
			ripbozoRim.attachedSprite = ripbozo;

		if (blueMiraRim != null)
			blueMiraRim.attachedSprite = blueMira;

		if (rhmdeadRim != null)
			rhmdeadRim.attachedSprite = rhmdead;

		if (deadmungusRim != null)
			deadmungusRim.attachedSprite = deadmungus;

		plant1Rim = new funkin.game.shaders.ExtraDropShadowShader();
		plant2Rim = new funkin.game.shaders.ExtraDropShadowShader();
		potRim = new funkin.game.shaders.ExtraDropShadowShader();
		plantfrontRim = new funkin.game.shaders.ExtraDropShadowShader();
	}

	snapCamToPos(450, 300);
	camSpecialThing([160, 200], [380, 200], 0.5);
}

function onSongStart()
{
	if (ClientPrefs.bfSkin == 'pinkplayable')
	{
		game.unlockAchievementPopup('lets_be_friends');
	}
		var dur = 17282.5355 / 1000;

		var layerMatrix = [
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			];

		if (sun != null)
		{
			FlxTween.tween(sun, {y: -1350}, dur * 3.3, {ease: FlxEase.linear});
		}
		if (moonlight != null)
		{
			FlxTween.tween(moonlight, {y: -1350}, dur * 3.3, {ease: FlxEase.linear});
		}
		if (cloudfar != null)
		{
			FlxTween.color(cloudfar, dur, cloudfar.color, 0xFF963F47, {ease: FlxEase.linear});
		}
		if (cloudfront != null)
		{
			FlxTween.color(cloudfront, dur, cloudfront.color, 0xFFA4464E, {ease: FlxEase.linear});
		}
		if (cloud1 != null)
		{
			FlxTween.color(cloud1, dur, cloud1.color, 0xFF9B424A, {ease: FlxEase.linear});
			FlxTween.tween(cloud1, {alpha: 0.6}, dur, {ease: FlxEase.linear});
		}
		if (cloud2 != null)
		{
			FlxTween.color(cloud2, dur, cloud2.color, 0xFF914049, {ease: FlxEase.linear});
			FlxTween.tween(cloud2, {alpha: 0.6}, dur, {ease: FlxEase.linear});
		}
		if (cloud3 != null)
		{
			FlxTween.color(cloud3, dur, cloud3.color, 0xFF9F4149, {ease: FlxEase.linear});
			FlxTween.tween(cloud3, {alpha: 0.6}, dur, {ease: FlxEase.linear});
		}
		if (cloud4 != null)
		{
			FlxTween.color(cloud4, dur, cloud4.color, 0xFF89363F, {ease: FlxEase.linear});
			FlxTween.tween(cloud4, {alpha: 0.6}, dur, {ease: FlxEase.linear});
		}
		if (cloudbig != null)
		{
			FlxTween.color(cloudbig, dur, cloudbig.color, 0xFF924049, {ease: FlxEase.linear});
			FlxTween.tween(cloudbig, {alpha: 0.6}, dur, {ease: FlxEase.linear});
		}
		if (ground != null)
			FlxTween.color(ground, dur, ground.color, 0xFF713039, {ease: FlxEase.linear});
		if (plantfront != null)
		{
			FlxTween.color(plantfront, dur, plantfront.color, 0xFF5D252D, {ease: FlxEase.linear});
			FlxTween.tween(plantfront.shader, {threshold: .035, strength: .55}, dur, {ease: FlxEase.linear});
			tweenShadowLayer(plantfront.shader.layers[0], [[
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			], 20, 18, .025], dur, FlxEase.linear);
			tweenShadowLayer(plantfront.shader.layers[1], [[
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			], 120, 25, .025], dur, FlxEase.linear);
		}
		if (plant1 != null)
			FlxTween.color(plant1, dur, plant1.color, 0xFF702A32, {ease: FlxEase.linear});
		if (plant2 != null)
			FlxTween.color(plant2, dur, plant2.color, 0xFF702A32, {ease: FlxEase.linear});
		if (blueMira != null)
		{
			FlxTween.color(blueMira, dur, blueMira.color, 0xFF8A3943, {ease: FlxEase.linear});
			FlxTween.tween(blueMira.shader, {threshold: .035, strength: .55}, dur, {ease: FlxEase.linear});
			tweenShadowLayer(blueMira.shader.layers[0], [[
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			], 20, 18, .025], dur, FlxEase.linear);
			tweenShadowLayer(blueMira.shader.layers[1], [[
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			], 120, 25, .025], dur, FlxEase.linear);
		}
		if (deadmungus != null)
		{
			FlxTween.color(deadmungus, dur, deadmungus.color, 0xFF843039, {ease: FlxEase.linear});
			FlxTween.tween(deadmungus.shader, {threshold: .035, strength: .55}, dur, {ease: FlxEase.linear});
			tweenShadowLayer(deadmungus.shader.layers[0], [[
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			], 20, 18, .025], dur, FlxEase.linear);
			tweenShadowLayer(deadmungus.shader.layers[1], [[
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			], 120, 25, .025], dur, FlxEase.linear);
		}
		if (rhmdead != null)
		{
			FlxTween.color(rhmdead, dur, rhmdead.color, 0xFF59242C, {ease: FlxEase.linear});
			FlxTween.tween(rhmdead.shader, {threshold: .035, strength: .55}, dur, {ease: FlxEase.linear});
			tweenShadowLayer(rhmdead.shader.layers[0], [[
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			], 20, 18, .025], dur, FlxEase.linear);
			tweenShadowLayer(rhmdead.shader.layers[1], [[
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			], 120, 25, .025], dur, FlxEase.linear);
		}
		if (vines != null)
			FlxTween.color(vines, dur, vines.color, 0xFF512128, {ease: FlxEase.linear});
		if (boyfriend != null)
		{
			FlxTween.color(boyfriend, dur, boyfriend.color, 0xFF8A3943, {ease: FlxEase.linear});
			FlxTween.tween(boyfriend.shader, {threshold: .035, strength: .55}, dur, {ease: FlxEase.linear});
			tweenShadowLayer(boyfriend.shader.layers[0], [[
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			], 20, 18, .025], dur, FlxEase.linear);
			tweenShadowLayer(boyfriend.shader.layers[1], [[
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			], 90, 12, .025], dur, FlxEase.linear);
		}
		if (hasPet)
		{
			FlxTween.color(pet, dur, pet.color, 0xFF8A3943, {ease: FlxEase.linear});
			FlxTween.tween(pet.shader, {threshold: .035, strength: .55}, dur, {ease: FlxEase.linear});
			tweenShadowLayer(pet.shader.layers[0], [[
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			], 20, 18, .025], dur, FlxEase.linear);
			tweenShadowLayer(pet.shader.layers[1], [[
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			], 90, 12, .025], dur, FlxEase.linear);
		}
		if (gf != null)
		{
			FlxTween.color(gf, dur, gf.color, 0xFF8A3943, {ease: FlxEase.linear});
			FlxTween.tween(gf.shader, {threshold: .035, strength: .55}, dur, {ease: FlxEase.linear});
			tweenShadowLayer(gf.shader.layers[0], [[
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			], 20, 18, .025], dur, FlxEase.linear);
			tweenShadowLayer(gf.shader.layers[1], [[
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			], 90, 12, .025], dur, FlxEase.linear);
		}
		if (dad != null)
		{
			FlxTween.color(dad, dur, dad.color, 0xFF8A3943, {ease: FlxEase.linear});
			FlxTween.tween(dad.shader, {threshold: .035, strength: .55}, dur, {ease: FlxEase.linear});
			tweenShadowLayer(dad.shader.layers[0], [[
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			], 20, 18, .025], dur, FlxEase.linear);
			tweenShadowLayer(dad.shader.layers[1], [[
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			], 90, 12, .025], dur, FlxEase.linear);
		}
}