import funkin.game.shaders.ExtraDropShadowShader;
import animate.FlxAnimateFrames;

var intro:FunkinVideoSprite;
var black:FlxSprite;
var tweeningChar:Bool = false;
var cloudScroll:Array<FlxSprite> = [];
var farClouds:Array<FlxSprite> = [];
var middleBuildings:Array<FlxSprite>;
var rightBuildings:Array<FlxSprite>;
var leftBuildings:Array<FlxSprite>;
var ejectedSpeed:Float = 9;
var fgCloud:FlxSprite;
var speedlines:FlxBackdrop;
public var sky:FlxSprite;
var speedPass:Array<Float> = [11000,11000,11000,11000];
var farSpeedPass:Array<Float> = [11000,11000,11000,11000,11000,11000,11000];
var ext:String = 'stages/mira/ejected/';
var thunderExt:String = 'stages/mira/reactorRuined/';
var platform:FlxSprite;

var bfShader:ExtraDropShadowShader = new ExtraDropShadowShader();
var gfShader:ExtraDropShadowShader = new ExtraDropShadowShader();
var petShader:ExtraDropShadowShader = new ExtraDropShadowShader();
var dadShader:ExtraDropShadowShader = new ExtraDropShadowShader();
var platformShader:ExtraDropShadowShader = new ExtraDropShadowShader();
var drops:Array<ExtraDropShadowShader> = [bfShader,gfShader,petShader,dadShader,platformShader];

var thunderGroup:FlxSpriteGroup;
var lightningDarken:Array<FlxSprite>;
var lightningLighten:Array<FlxSprite>;

public var nextThunder:Int = 4;
public var canThunder:Bool = true;

var dadEyeOverlay:FunkinSprite;
var dadEyeAnim:String = '';

function onLoad()
{
	for (i in 1...5) Paths.image('${thunderExt}thunder$i');
	for (i in 1...4) Paths.sound('stage/dtThunder$i');

	ejectedSpeed = ClientPrefs.flashing ? 9 : 3.3;
	camZoomingDecay = .5;

	sky = new FlxSprite(
		-2372.25 + 1000,
		-4181.7 + (656 * 5)
	).loadGraphic(Paths.image(ext + 'sky'));
	sky.antialiasing = true;
	sky.scale.set(5,5);
	sky.updateHitbox();
	sky.scrollFactor.set(0,0);
	add(sky);

	fgCloud = new FlxSprite(-2660.4,-402).loadGraphic(Paths.image(ext + 'fgClouds'));
	fgCloud.antialiasing = true;
	fgCloud.scale.set(2,2);
	fgCloud.updateHitbox();
	fgCloud.scrollFactor.set(.2,.2);
	add(fgCloud);

	thunderGroup = new FlxSpriteGroup();
	add(thunderGroup);

	rightBuildings = [];
	leftBuildings = [];
	middleBuildings = [];

	for (i in 0...2)
	{
		var rightBuilding = new FlxSprite(1022.3,-390.45);
		rightBuilding.loadGraphic(Paths.image(ext + 'buildingB'));
		rightBuilding.antialiasing = true;
		rightBuilding.scale.set(2,2);
		rightBuilding.updateHitbox();
		rightBuilding.scrollFactor.set(.5,.5);
		add(rightBuilding);
		rightBuildings.push(rightBuilding);
	}

	for (i in 0...2)
	{
		var middleBuilding = new FlxSprite(-76.15,1398.5);
		middleBuilding.loadGraphic(Paths.image(ext + 'buildingA'));
		middleBuilding.antialiasing = true;
		middleBuilding.scale.set(2,2);
		middleBuilding.updateHitbox();
		middleBuilding.scrollFactor.set(.5,.5);
		add(middleBuilding);
		middleBuildings.push(middleBuilding);
	}

	for (i in 0...2)
	{
		var leftBuilding = new FlxSprite(-1099.3,7286.55);
		leftBuilding.loadGraphic(Paths.image(ext + 'buildingB'));
		leftBuilding.antialiasing = true;
		leftBuilding.scale.set(2,2);
		leftBuilding.updateHitbox();
		leftBuilding.scrollFactor.set(.5,.5);
		add(leftBuilding);
		leftBuildings.push(leftBuilding);
	}

	rightBuildings[0].y = 6803.1;
	middleBuildings[0].y = 8570.5;
	leftBuildings[0].y = 14050.2;

	platform = new FlxSprite(955,1200);
	platform.frames = Paths.getSparrowAtlas('stages/common/platform');
	platform.animation.addByPrefix('bop','floating',24,true);
	platform.animation.play('bop');
	platform.alpha = .00001;
	add(platform);
}

function onCreatePost()
{
	boyfriend.useRenderTexture = true;
	gf.useRenderTexture = true;
	dad.useRenderTexture = true;
	pet.useRenderTexture = true;

	gf.scrollFactor.set(.7,.7);

	speedlines = new FlxBackdrop().loadGraphic(Paths.image(ext + 'speedlines'));
	speedlines.scale.set(3,3);
	speedlines.updateHitbox();
	speedlines.scrollFactor.set(.3,.3);
	speedlines.alpha = .5;
	add(speedlines);

	pet.origin.set(pet.width / 2,pet.height / 2);
	pet.setColorTransform(1,1,1,1,0,20,40,-127);
	pet.colorTransform.alphaMultiplier = 1;
	pet.colorTransform.alphaOffset = 0;
	pet.scrollFactor.set(1.2,1.2);

	if (pet.getFlag('spin') != false)
		pet.angularVelocity = 450;

	if (!ClientPrefs.lowQuality && ClientPrefs.flashing)
	{
		for (i in 0...3)
		{
			var newCloud:FlxSprite = new FlxSprite();
			newCloud.frames = Paths.getSparrowAtlas(ext + 'scrollingClouds');
			newCloud.animation.addByPrefix('idle','Cloud' + i,24,false);
			newCloud.animation.play('idle');

			switch (i)
			{
				case 0:
					newCloud.setPosition(-9.65,-224.35);
					newCloud.scrollFactor.set(.8,.8);
				case 1:
					newCloud.setPosition(-1342.85,-350.45);
					newCloud.scrollFactor.set(.6,.6);
				case 2:
					newCloud.setPosition(1784.65,-957.05);
					newCloud.scrollFactor.set(1.3,1.3);
			}

			add(newCloud);
			cloudScroll.push(newCloud);
		}

		for (i in 0...7)
		{
			var newCloud:FlxSprite = new FlxSprite();
			newCloud.frames = Paths.getSparrowAtlas(ext + 'scrollingClouds');
			newCloud.animation.addByPrefix('idle','Cloud' + i,24,false);
			newCloud.animation.play('idle');
			newCloud.alpha = .5;

			switch (i)
			{
				case 0:
					newCloud.setPosition(-1308,-1039.9);
				case 1:
					newCloud.setPosition(464.3,-890.5);
				case 2:
					newCloud.setPosition(2458.45,-1085.85);
				case 3:
					newCloud.setPosition(-666.95,-172.05);
				case 4:
					newCloud.setPosition(-1616.6,1016.95);
				case 5:
					newCloud.setPosition(1714.25,200.45);
				case 6:
					newCloud.setPosition(-167.05,710.25);
			}

			add(newCloud);
			farClouds.push(newCloud);
		}
	}

	bfShader.setAdjustColor(-78,-25,-15,-58);

	bfShader.addLayer([
		.8,0,0,0,0,
		0,1,0,0,0,
		.3,0,1,0,0,
		0,0,0,1,0
	],90,35,.01,1,.5);

	gfShader.copyFrom(bfShader);
	petShader.copyFrom(bfShader);
	dadShader.copyFrom(bfShader);
	platformShader.copyFrom(bfShader);

	dadShader.setAdjustColor(-28,-22,-10,-60);

	bfShader.layers[0].angle = 110;
	gfShader.layers[0].angle = 90;
	petShader.layers[0].angle = 70;
	dadShader.layers[0].angle = 70;
	platformShader.layers[0].angle = 110;

	bfShader.attachedSprite = boyfriend;
	gfShader.attachedSprite = gf;
	petShader.attachedSprite = pet;
	dadShader.attachedSprite = dad;
	platformShader.attachedSprite = platform;

	boyfriend.shader = bfShader;
	gf.shader = gfShader;
	pet.shader = petShader;
	dad.shader = dadShader;

	if (hasBfSkin && !boyfriend.getFlag('floating'))
	{
		platform.shader = platformShader;
		platform.alpha = 1;
	}

	lightningDarken = [
		boyfriendGroup,
		dadGroup,
		gfGroup,
		pet
	];

	lightningLighten = [
		sky,
		fgCloud,
		rightBuildings[0],
		rightBuildings[1],
		middleBuildings[0],
		middleBuildings[1],
		leftBuildings[0],
		leftBuildings[1],
		platform
	];

	createDadEyeOverlay();
	lightningStuff(0);
}

function createDadEyeOverlay():Void
{
	if (dad == null || dadEyeOverlay != null)
		return;

	if (dad.imageFile != 'characters/story/green/parasite')
		return;

	var atlasPath:String = Paths.getPath(
		'images/${dad.imageFile}',
		null,
		PathsTestMode.LOOSE
	);

	var eyeFrames:FlxAnimateFrames = FlxAnimateFrames.fromAnimate(
		atlasPath,
		null,
		null,
		'dadEyeOverlayAtlas',
		true,
		{cacheOnLoad:false}
	);

	if (eyeFrames == null)
		return;

	dadEyeOverlay = new FunkinSprite(0,0);
	dadEyeOverlay.frames = eyeFrames;

	dadEyeOverlay.addAnimByPrefix('idle','anims/idle',24,true);
	dadEyeOverlay.addAnimByPrefix('singLEFT','anims/left',24,false);
	dadEyeOverlay.addAnimByPrefix('singDOWN','anims/down',24,false);
	dadEyeOverlay.addAnimByPrefix('singUP','anims/up',24,false);
	dadEyeOverlay.addAnimByPrefix('singRIGHT','anims/right',24,false);

	dadEyeOverlay.scalableOffsets = dad.scalableOffsets;
	dadEyeOverlay.rotatableOffsets = dad.rotatableOffsets;
	dadEyeOverlay.skewableOffsets = dad.skewableOffsets;
	dadEyeOverlay.baseFlipX = dad.baseFlipX;
	dadEyeOverlay.baseFlipY = dad.baseFlipY;
	dadEyeOverlay.antialiasing = dad.antialiasing;
	dadEyeOverlay.shader = null;
	dadEyeOverlay.active = false;
	dadEyeOverlay.visible = false;

	maskDadEyeSymbol('anims/idle',['glint','glint2']);
	maskDadEyeSymbol('anims/left',['glint']);
	maskDadEyeSymbol('anims/down',['glint','glint_glow']);
	maskDadEyeSymbol('anims/up',['glint','glow_shit']);
	maskDadEyeSymbol('anims/right',['glint','glow_shit']);

	dadGroup.add(dadEyeOverlay);

	syncDadEyeOverlay();
}

function maskDadEyeSymbol(symbolName:String,eyeLayers:Array<String>):Void
{
	if (dadEyeOverlay == null || dadEyeOverlay.library == null)
		return;

	var symbol = dadEyeOverlay.library.getSymbol(symbolName);

	if (symbol == null || symbol.timeline == null)
		return;

	for (layer in symbol.timeline.layers)
	{
		var showLayer:Bool = eyeLayers.indexOf(layer.name) >= 0;

		layer.forEachFrame(function(frame)
		{
			if (frame == null || frame.elements == null)
				return;

			for (element in frame.elements)
				element.visible = showLayer;
		});
	}
}

function syncDadEyeOverlay():Void
{
	if (dad == null || dadEyeOverlay == null)
		return;

	if (dad.imageFile != 'characters/story/green/parasite')
	{
		dadEyeOverlay.visible = false;
		return;
	}

	if (!dad.exists || !dad.visible || dad.alpha <= 0 || dad.isAnimNull())
	{
		dadEyeOverlay.visible = false;
		return;
	}

	var currentAnim:String = dad.getAnimName();

	if (currentAnim == '')
	{
		dadEyeOverlay.visible = false;
		return;
	}

	var overlayAnim:String = currentAnim;

	switch (currentAnim)
	{
		case 'idle':
			overlayAnim = 'idle';
		case 'singLEFT':
			overlayAnim = 'singLEFT';
		case 'singDOWN':
			overlayAnim = 'singDOWN';
		case 'singUP':
			overlayAnim = 'singUP';
		case 'singRIGHT':
			overlayAnim = 'singRIGHT';
		default:
			dadEyeOverlay.visible = false;
			return;
	}

	if (dadEyeAnim != overlayAnim)
	{
		dadEyeOverlay.playAnim(overlayAnim,true,false);
		dadEyeAnim = overlayAnim;
	}

	var frameCount:Int = dadEyeOverlay.getAnimNumFrames();

	if (frameCount > 0)
	{
		var frame:Int = dad.animCurFrame;

		if (frame < 0)
			frame = 0;

		if (frame >= frameCount)
			frame = frameCount - 1;

		dadEyeOverlay.animCurFrame = frame;
	}

	dadEyeOverlay.x = dad.x;
	dadEyeOverlay.y = dad.y;

	dadEyeOverlay.scale.set(
		dad.scale.x,
		dad.scale.y
	);

	dadEyeOverlay.baseScale.set(
		dad.baseScale.x,
		dad.baseScale.y
	);

	dadEyeOverlay.origin.set(
		dad.origin.x,
		dad.origin.y
	);

	dadEyeOverlay.offset.set(
		dad.offset.x,
		dad.offset.y
	);

	dadEyeOverlay.spriteOffset.set(
		dad.spriteOffset.x,
		dad.spriteOffset.y
	);

	dadEyeOverlay.animOffset.set(
		dad.animOffset.x,
		dad.animOffset.y
	);

	dadEyeOverlay.angle = dad.angle;
	dadEyeOverlay.skew.set(dad.skew.x,dad.skew.y);
	dadEyeOverlay.flipX = dad.flipX;
	dadEyeOverlay.flipY = dad.flipY;
	dadEyeOverlay.alpha = dad.alpha;
	dadEyeOverlay.color = dad.color;
	dadEyeOverlay.blend = dad.blend;

	dadEyeOverlay.scrollFactor.set(
		dad.scrollFactor.x,
		dad.scrollFactor.y
	);

	dadEyeOverlay.antialiasing = dad.antialiasing;

	dadEyeOverlay.colorTransform.redMultiplier = dad.colorTransform.redMultiplier;
	dadEyeOverlay.colorTransform.greenMultiplier = dad.colorTransform.greenMultiplier;
	dadEyeOverlay.colorTransform.blueMultiplier = dad.colorTransform.blueMultiplier;
	dadEyeOverlay.colorTransform.alphaMultiplier = dad.colorTransform.alphaMultiplier;
	dadEyeOverlay.colorTransform.redOffset = dad.colorTransform.redOffset;
	dadEyeOverlay.colorTransform.greenOffset = dad.colorTransform.greenOffset;
	dadEyeOverlay.colorTransform.blueOffset = dad.colorTransform.blueOffset;
	dadEyeOverlay.colorTransform.alphaOffset = dad.colorTransform.alphaOffset;

	dadEyeOverlay.visible = true;
}

function lockLayerAngle(rim:ExtraDropShadowShader,fixedAngle:Float):Void
{
	if (rim == null || rim.attachedSprite == null || rim.layers.length == 0)
		return;

	rim.layers[0].angle = fixedAngle - rim.attachedSprite.angle;
}

function thunder():Void
{
	if (!canThunder)
		return;

	nextThunder = -1;

	var thunder:FlxSprite = thunderGroup.recycle(FlxSprite);

	thunder.scrollFactor.set(0,0);
	thunder.loadGraphic(
		Paths.image(
			'${thunderExt}thunder${FlxG.random.int(1,4)}'
		)
	);

	thunder.flipX = FlxG.random.bool(50);
	thunder.x = FlxG.random.float(-1500,1000);
	thunder.y = -700;
	thunder.alpha = 0;
	thunder.blend = BlendMode.ADD;

	FlxTween.tween(
		thunder,
		{alpha:FlxG.random.float(.5,1)},
		.1,
		{
			ease:FlxEase.sineIn,
			onComplete:function(_)
			{
				FlxTween.tween(
					thunder,
					{alpha:0},
					FlxG.random.float(1.5,2.2),
					{
						ease:FlxEase.sineIn,
						onComplete:function(_)
						{
							thunder.kill();
						}
					}
				);
			}
		}
	);

	new FlxTimer().start(
		FlxG.random.float(.1,2),
		function(_)
		{
			FlxG.sound.play(
				Paths.sound(
					'stage/dtThunder${FlxG.random.int(1,3)}'
				),
				FlxG.random.float(.7,1)
			);
		}
	);

	FlxTween.num(
		FlxG.random.float(.5,.7),
		.4,
		.5,
		{
			ease:FlxEase.elasticInOut,
			onComplete:function(_)
			{
				FlxTween.num(
					.4,
					0,
					FlxG.random.float(.7,1.2),
					{
						ease:FlxEase.sineIn,
						onComplete:function(_)
						{
							setNextThunder();
						}
					},
					lightningStuff
				);
			}
		},
		lightningStuff
	);
}

function lightningStuff(intensity:Float):Void
{
	var c:FlxColor = FlxColor.interpolate(
		FlxColor.WHITE,
		FlxColor.BLACK,
		(1 - Math.pow(1 - intensity,2)) * .8
	);

	for (sprite in lightningDarken)
	{
		if (sprite == null || !sprite.exists)
			continue;

		sprite.color = c;
	}

	var m:Float = 1 + intensity * 1.25;

	for (sprite in lightningLighten)
	{
		if (sprite == null || !sprite.exists)
			continue;

		sprite.colorTransform.redMultiplier = m;
		sprite.colorTransform.greenMultiplier = m;
		sprite.colorTransform.blueMultiplier = m;
	}

	for (drop in drops)
	{
		if (drop != null && drop.layers.length > 0)
			drop.layers[0].threshold = Math.pow(1 - intensity,3);
	}
}

function setNextThunder():Void
{
	nextThunder = Math.ceil(
		(curBeat + FlxG.random.int(4,32)) / 2
	) * 2;
}

function onUpdate(elapsed:Float)
{
	lockLayerAngle(gfShader,90);
	lockLayerAngle(petShader,70);

	if (!gf.getFlag('floating') && hasGfSkin)
	{
		gf.angle = -25 + Math.sin(
			Conductor.songPosition / 500
		) * 10;
	}

	pet.x += Math.sin(
		Conductor.songPosition / 100
	) * 200 * FlxG.elapsed;

	pet.y = 800 + Math.sin(
		Conductor.songPosition / 100
	) * 50;

	var musicTime:Float = Conductor.songPosition;
	funTime = musicTime;

	if (speedlines != null)
	{
		speedlines.y = -(
			funTime *
			2 *
			(ClientPrefs.flashing ? 1.75 : .75)
		);
	}

	if (isDead)
		return;

	camHUD.scroll.y = Math.sin(
		(Conductor.songPosition / 1000) *
		(Conductor.bpm / 60) *
		-1
	) * 15;

	camHUD.scrollAngle = Math.sin(
		(Conductor.songPosition / 1200) *
		(Conductor.bpm / 60) *
		-1
	) * 1.2;

	if (cloudScroll.length >= 3)
	{
		for (i in 0...cloudScroll.length)
		{
			cloudScroll[i].y = FlxMath.lerp(
				cloudScroll[i].y,
				cloudScroll[i].y - speedPass[i],
				FlxMath.bound(
					elapsed * ejectedSpeed,
					0,
					1
				)
			);

			if (cloudScroll[i].y < -1789.65)
			{
				var randomScale:Float =
					FlxG.random.float(1.5,2.2);

				var randomScroll:Float =
					FlxG.random.float(1,1.3);

				speedPass[i] =
					FlxG.random.float(1100,1300);

				cloudScroll[i].scale.set(
					randomScale,
					randomScale
				);

				cloudScroll[i].scrollFactor.set(
					randomScroll,
					randomScroll
				);

				cloudScroll[i].x =
					FlxG.random.float(
						-3578.95,
						3259.6
					);

				cloudScroll[i].y = 2196.15;
			}
		}
	}

	if (farClouds.length == 7)
	{
		for (i in 0...farClouds.length)
		{
			farClouds[i].y = FlxMath.lerp(
				farClouds[i].y,
				farClouds[i].y - farSpeedPass[i],
				FlxMath.bound(
					elapsed * ejectedSpeed,
					0,
					1
				)
			);

			if (farClouds[i].y < -1614)
			{
				var randomScale:Float =
					FlxG.random.float(.2,.5);

				var randomScroll:Float =
					FlxG.random.float(.2,.4);

				farSpeedPass[i] =
					FlxG.random.float(1100,1300);

				farClouds[i].scale.set(
					randomScale,
					randomScale
				);

				farClouds[i].scrollFactor.set(
					randomScroll,
					randomScroll
				);

				farClouds[i].x =
					FlxG.random.float(
						-2737.85,
						3485.4
					);

				farClouds[i].y = 1738.6;
			}
		}
	}

	if (leftBuildings.length > 0)
	{
		for (i in 0...leftBuildings.length)
			leftBuildings[i].y =
				middleBuildings[i].y + 5888;
	}

	if (middleBuildings.length > 0)
	{
		for (i in 0...middleBuildings.length)
		{
			if (middleBuildings[i].y < -11759.9)
			{
				middleBuildings[i].y = 3190.5;

				middleBuildings[i].animation.play(
					FlxG.random.bool(50)
						? '1'
						: '2'
				);
			}

			middleBuildings[i].y = FlxMath.lerp(
				middleBuildings[i].y,
				middleBuildings[i].y - 1300,
				FlxMath.bound(
					elapsed * ejectedSpeed,
					0,
					1
				)
			);
		}
	}

	if (rightBuildings.length > 0)
	{
		for (i in 0...rightBuildings.length)
			rightBuildings[i].y =
				leftBuildings[i].y;
	}

	if (!tweeningChar && !inCutscene)
	{
		tweeningChar = true;

		if (!hasBfSkin || boyfriend.getFlag('floating'))
		{
			FlxTween.tween(
				boyfriendGroup,
				{
					x:FlxG.random.float(
						BF_X - 15,
						BF_X + 15
					),
					y:FlxG.random.float(
						BF_Y - 15,
						BF_Y + 15
					)
				},
				.4,
				{
					ease:FlxEase.smoothStepInOut
				}
			);
		}

		FlxTween.tween(
			gf,
			{
				x:FlxG.random.float(
					game.GF_X - 10,
					game.GF_X + 10
				),
				y:FlxG.random.float(
					game.GF_Y - 10,
					game.GF_Y + 10
				)
			},
			.4,
			{
				ease:FlxEase.smoothStepInOut
			}
		);

		FlxTween.tween(
			dad,
			{
				x:FlxG.random.float(
					DAD_X - 15,
					DAD_X + 15
				),
				y:FlxG.random.float(
					game.DAD_Y - 15,
					game.DAD_Y + 15
				)
			},
			.4,
			{
				ease:FlxEase.smoothStepInOut,
				onComplete:function(_)
				{
					tweeningChar = false;
				}
			}
		);
	}

	if (!inCutscene && ClientPrefs.flashing)
		camGame.shake(.002,.1);

	if (fgCloud != null)
	{
		fgCloud.y = FlxMath.lerp(
			-402 - 300,
			-402 - 500,
			songPercent
		);
	}
}

function onUpdatePost(elapsed:Float)
{
	syncDadEyeOverlay();
}

function onBeatHit()
{
	if (
		canThunder &&
		nextThunder >= 0 &&
		curBeat >= nextThunder
	)
	{
		thunder();
	}
}

function onDestroy()
{
	if (dadEyeOverlay != null)
	{
		dadEyeOverlay.destroy();
		dadEyeOverlay = null;
	}
}