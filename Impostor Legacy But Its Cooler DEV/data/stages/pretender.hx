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
	
	moonlight = new FlxSprite(0, -350).loadGraphic(Paths.image(ext + 'moon light'));
	moonlight.scrollFactor.set(0.8, 0.8);
	moonlight.blend = BlendMode.ADD;
	add(moonlight);

	sun = new FlxSprite(0, -350).loadGraphic(Paths.image(ext + 'the sun'));
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

	rhmdead = new FlxSprite(1150, 630).loadGraphic(Paths.image(ext + 'rhm dead'));
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
			rimlightBase.addLayer([
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			], 20, 18, .025).colorMatrix,
			90,
			12,
			.025
		);

		var objectsRim:ExtraDropShadowShader = new funkin.game.shaders.ExtraDropShadowShader();

		objectsRim.threshold = .035;
		objectsRim.strength = .55;

		objectsRim.addLayer(
			objectsRim.addLayer([
				1.35, 0, 0, 0, 0,
				0, 0.92, 0, 0, 0,
				0, 0, 0.98, 0, 0,
				0, 0, 0, 1, 0
			], 20, 18, .025).colorMatrix,
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
		}

		if (boyfriend.curCharacter != 'pretender')
		{
			bfRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(rimlightBase);

			bfRim.layers[0].distance = 25;
			bfRim.layers[1].distance = 25;

			bfRim.layers[0].angle = 120;
			bfRim.layers[1].angle = 120;

			bfRim.attachedSprite = boyfriend;
			boyfriend.useRenderTexture = true;
		}

		{
			petRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(rimlightBase);

			petRim.layers[0].distance = 25;
			petRim.layers[1].distance = 25;

			petRim.layers[0].angle = 120;
			petRim.layers[1].angle = 120;

			petRim.attachedSprite = pet;
			pet.useRenderTexture = true;
		}

		if (ripbozo != null && ripbozo.visible)
		{
			ripbozoRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(objectsRim);
			ripbozoRim.attachedSprite = ripbozo;
		}

		if (blueMira != null)
		{
			blueMiraRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(objectsRim);
			blueMiraRim.attachedSprite = blueMira;
		}

		if (rhmdead != null)
		{
			rhmdeadRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(objectsRim);
			rhmdeadRim.attachedSprite = rhmdead;
		}

		if (deadmungus != null)
		{
			deadmungusRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(objectsRim);
			deadmungusRim.attachedSprite = deadmungus;
		}

		if (plant1 != null)
		{
			plant1Rim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(objectsRim);
			plant1Rim.attachedSprite = plant1;
		}

		if (plant2 != null)
		{
			plant2Rim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(objectsRim);
			plant2Rim.attachedSprite = plant2;
		}

		if (pot != null)
		{
			potRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(objectsRim);
			potRim.attachedSprite = pot;
		}
		
		if (plantfront != null)
		{
			plantfrontRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(objectsRim);
			plantfrontRim.attachedSprite = plantfront;
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

	

	cloudfar.color = 0xFF963F47;
	cloudfront.color = 0xFFA4464E;

	cloud1.color = 0xFF9B424A;
	cloud2.color = 0xFF914049;
	cloud3.color = 0xFF9F4149;
	cloud4.color = 0xFF89363F;
	cloudbig.color = 0xFF924049;

	ground.color = 0xFF713039;
	plantfront.color = 0xFF5D252D;

	plant1.color = 0xFF702A32;
	plant2.color = 0xFF702A32;

	deadmungus.color = 0xFF843039;

	if (ripbozo != null)
		ripbozo.color = 0xFF60272F;

	rhmdead.color = 0xFF59242C;

	blueMira.color = 0xFF8A3943;

	dad.color = 0xFF8A3943;
	gf.color = 0xFF8A3943;
	boyfriend.color = 0xFF8A3943;
	pet.color = 0xFF8A3943;

	pot.color = 0xFF6D282F;
	vines.color = 0xFF512128;

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
}