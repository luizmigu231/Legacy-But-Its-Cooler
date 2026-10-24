import funkin.game.shaders.ChromaticAbberation;
import funkin.game.shaders.DropShadowShader;
import openfl.filters.ShaderFilter;
import animate.FlxAnimateFrames;
var gfGhost:Character;
var bg:FlxSprite;
var thebackground:FlxSprite;
var grayfg:FlxSprite;
var lightadd:FlxSprite;
var lightsubtract:FlxSprite;
var hudDarkShader:ExtraDropShadowShader;
var darkShader:ExtraDropShadowShader;
var grayShader:ExtraDropShadowShader;
var isDark:Bool = false;
var noshader:Bool = false;
var ext = 'stages/airship/gray/';
var isChrom:Bool;
var chromAmount:Float = 0;
var chromFreq:Int = 1;
var chromTween:FlxTween;
public var crowd:FlxSprite;
var caShader:ChromaticAbberation;
var bfdead:FlxSprite;
var brown:FlxSprite;
var red:FlxSprite;
var yellow:FlxSprite;
var blue:FlxSprite;
var grayanim:FlxSprite;
var dark:FlxSprite;
var defeat:FlxSprite;
var defeatPurple:FlxSprite;
var timer:Float = 0.1;
var bfRim:ExtraDropShadowShader;
var dadRim:ExtraDropShadowShader;
var gfRim:ExtraDropShadowShader;
var gfGhostRim:ExtraDropShadowShader;
var grayfgRim:ExtraDropShadowShader;
var petRim:ExtraDropShadowShader;
var brownBaseY:Float;
var redBaseY:Float;
var yellowBaseY:Float;
var blueBaseY:Float;
var ghostFloatTime:Float = 0;
var brownTween:FlxTween;
var redTween:FlxTween;
var yellowTween:FlxTween;
var blueTween:FlxTween;
var transformationDuration:Float = 10.0;
var transformationTween:FlxTween;
var transformationStarted:Bool = false;
var greyThreatEyeOverlay:FunkinSprite;
var greyThreatEyeOwner:Dynamic = null;
var greyThreatEyeAnim:String = '';
var greyThreatEyeOriginalVisibility:Array<Dynamic> = [];
var transparentRimLayer:Array<Float> = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
var rimStartMatrix:Array<Float> = [
	0.3, 0.2, 0, 0, 9,
	-0.5, 0.77, 0.2, 0, 13,
	0, -0.1, 0.69, 0, 20,
	0, 0, 0, 1, 0
];
var rimTargetMatrix:Array<Float> = [
	0.20, 0.04, 0.02, 0, 15,
	0.00, 0.16, 0.05, 0, 3,
	0.10, 0.03, 0.42, 0, 34,
	0, 0, 0, 1, 0
];
var rimStartInner:Array<Float> = [
	1.5, 0, 0, 0, -8,
	0, .8, .1, 0, 59,
	.1, 0, .8, 0, 57,
	0, 0, 0, 1, 0
];
var rimTargetInner:Array<Float> = [
	0.48, 0.02, 0.02, 0, 24,
	0.00, 0.20, 0.06, 0, 4,
	0.18, 0.02, 0.60, 0, 52,
	0, 0, 0, 1, 0
];
function createFinalRimShader(strength:Float):ExtraDropShadowShader
{
	var shader:ExtraDropShadowShader = new funkin.game.shaders.ExtraDropShadowShader();
	shader.setColorMatrix(rimTargetMatrix);
	shader.threshold = .028;
	shader.strength = strength;
	var rimInner = shader.addLayer(rimTargetInner, 12, 16, .01);
	shader.addLayer(rimInner.colorMatrix, 20, 11, .01);
	return shader;
}
function lerpTransformation(a:Float, b:Float, t:Float):Float
{
	return a + (b - a) * t;
}
function lerpMatrix(a:Array<Float>, b:Array<Float>, t:Float):Array<Float>
{
	var result:Array<Float> = [];
	for (i in 0...a.length)
		result.push(lerpTransformation(a[i], b[i], t));
	return result;
}
function updateRimTransformation(
	shader:ExtraDropShadowShader,
	t:Float,
	startStrength:Float,
	targetStrength:Float,
	startInnerDistance:Float,
	startInnerAngle:Float,
	startOuterDistance:Float,
	startOuterAngle:Float
)
{
	if (shader == null)
		return;
	var baseMatrix:Array<Float> = lerpMatrix(
		rimStartMatrix,
		rimTargetMatrix,
		t
	);
	var innerMatrix:Array<Float> = lerpMatrix(
		rimStartInner,
		rimTargetInner,
		t
	);
	shader.setColorMatrix(baseMatrix);
	shader.threshold = lerpTransformation(.02, .028, t);
	shader.strength = lerpTransformation(
		startStrength,
		targetStrength,
		t
	);
	if (shader.layers != null && shader.layers.length >= 2)
	{
		var fadeExtraLayers:Bool = shader == bfRim || shader == dadRim;
		shader.layers[0].colorMatrix = fadeExtraLayers ? lerpMatrix(innerMatrix, transparentRimLayer, t) : innerMatrix;
		if (fadeExtraLayers) shader.layers[1].colorMatrix = lerpMatrix(innerMatrix, transparentRimLayer, t);
		shader.layers[0].distance = lerpTransformation(startInnerDistance, fadeExtraLayers ? 0 : 12, t);
		shader.layers[0].angle = lerpTransformation(startInnerAngle, 16, t);
		shader.layers[1].distance = lerpTransformation(startOuterDistance, fadeExtraLayers ? 0 : 62, t);
		shader.layers[1].angle = lerpTransformation(startOuterAngle, 11, t);
	}
}
function updateRimTransformations(t:Float)
{
	updateRimTransformation(
		bfRim,
		t,
		.7,
		.55,
		20,
		25,
		20,
		15
	);
	updateRimTransformation(
		dadRim,
		t,
		.7,
		.55,
		20,
		25,
		20,
		15
	);
	updateRimTransformation(
		gfRim,
		t,
		.7,
		.55,
		20,
		60,
		20,
		120
	);
	updateRimTransformation(
		gfGhostRim,
		t,
		.55,
		.55,
		20,
		25,
		20,
		15
	);
	updateRimTransformation(
		grayfgRim,
		t,
		.55,
		.55,
		20,
		25,
		20,
		15
	);
	updateRimTransformation(
		petRim,
		t,
		.7,
		.48,
		20,
		25,
		20,
		15
	);
}
function updateStageTransformation(t:Float)
{
	bg.setColorTransform(
		lerpTransformation(1, .78, t),
		lerpTransformation(1, .48, t),
		lerpTransformation(1, .88, t),
		1,
		8 * t,
		0,
		18 * t,
		0
	);
	thebackground.setColorTransform(
		lerpTransformation(1, .82, t),
		lerpTransformation(1, .52, t),
		lerpTransformation(1, .90, t),
		1,
		10 * t,
		0,
		20 * t,
		0
	);
	crowd.setColorTransform(
		lerpTransformation(1, .78, t),
		lerpTransformation(1, .48, t),
		lerpTransformation(1, .86, t),
		1,
		8 * t,
		0,
		18 * t,
		0
	);
	brown.setColorTransform(
		lerpTransformation(1, .82, t),
		lerpTransformation(1, .56, t),
		lerpTransformation(1, .86, t),
		brown.alpha,
		8 * t,
		0,
		12 * t,
		0
	);
	red.setColorTransform(
		lerpTransformation(1, .92, t),
		lerpTransformation(1, .48, t),
		lerpTransformation(1, .72, t),
		red.alpha,
		12 * t,
		0,
		12 * t,
		0
	);
	yellow.setColorTransform(
		lerpTransformation(1, .92, t),
		lerpTransformation(1, .62, t),
		lerpTransformation(1, .78, t),
		yellow.alpha,
		12 * t,
		4 * t,
		10 * t,
		0
	);
	blue.setColorTransform(
		lerpTransformation(1, .70, t),
		lerpTransformation(1, .58, t),
		lerpTransformation(1, .95, t),
		blue.alpha,
		4 * t,
		0,
		20 * t,
		0
	);
}
function updateTransformation(t:Float)
{
	t = Math.max(0, Math.min(1, t));
	updateStageTransformation(t);
	updateRimTransformations(t);
}
function startTransformation()
{
	if (transformationStarted)
		return;
	transformationStarted = true;
	if (transformationTween != null)
		transformationTween.cancel();
	updateTransformation(0);
	transformationTween = FlxTween.num(
		0,
		1,
		transformationDuration,
		{
			ease: FlxEase.sineInOut,
			onComplete: function(tween:FlxTween)
			{
				updateTransformation(1);
			}
		},
		function(value:Float)
		{
			updateTransformation(value);
		}
	);
}
function onBeatHit()
{
	if (curBeat % chromFreq == 0)
	{
		if (chromTween != null)
			chromTween.cancel();
		caShader.amount = chromAmount;
		chromTween = FlxTween.tween(
			caShader,
			{amount: 0},
			.45,
			{ease: FlxEase.sineOut}
		);
	}
	gfGhost.onBeatHit();
	if (curBeat % 2 == 0) for (ghost in [brown, red, yellow, blue]) ghost.animation.play('idle', true);
	if (curBeat % 4 == 0)
		crowd.animation.play('bop', true);
	if (curBeat == 260)
		defeatPurple.alpha = .35;
	if (curBeat == 328)
		defeatPurple.alpha = 0;
	if (curBeat == 380)
	{
		tweenGhost(brown);
		grayanim.animation.play('bop');
		dad.alpha = 0;
		grayanim.alpha = 1;
		FlxTween.tween(
			defeat,
			{"alpha": 0.8},
			8,
			{ease: FlxEase.quadOut}
		);
		FlxTween.tween(
			dark,
			{"alpha": 0.5},
			2,
			{ease: FlxEase.quadOut}
		);
		changeCharacter("greythreat", 1);
		if (dadRim != null)
		{
			dadRim.attachedSprite = dad;
			dad.shader = dadRim;
			dad.useRenderTexture = true;
		}
		startTransformation();
	}
	if (curBeat == 388)
		tweenGhost(blue);
	if (curBeat == 396)
		tweenGhost(red);
	if (curBeat == 404)
		tweenGhost(yellow);
	if (curBeat == 428)
	{
		dark.alpha = 0;
		dad.alpha = 1;
		grayanim.alpha = 0;
		gfGhost.alpha = 1;
		gfGhost.playAnim('scared', true);
		gfGhost.stunned = true;
	}
	if (curBeat == 430)
		gfGhost.stunned = false;
}
function onLoad()
{
	gfGhost = new Character(1190, 250, "gf-ghost");
	startCharacterPos(gfGhost);
	gfGhost.alpha = 0.001;
	gfGhost.zIndex = 1;
	add(gfGhost);
	bg = new FlxSprite(0, 0).loadGraphic(
		Paths.image(ext + 'graybg')
	);
	add(bg);
	thebackground = new FlxSprite(1930, 400);
	thebackground.frames = Paths.getSparrowAtlas(
		ext + 'grayglowy'
	);
	thebackground.animation.addByPrefix(
		'bop',
		'jar??',
		24,
		true
	);
	thebackground.animation.play('bop');
	thebackground.antialiasing = true;
	thebackground.scrollFactor.set(1, 1);
	thebackground.setGraphicSize(
		Std.int(thebackground.width)
	);
	thebackground.active = true;
	add(thebackground);
	crowd = new FlxSprite(200, 350);
	crowd.frames = Paths.getSparrowAtlas(
		ext + 'grayblack'
	);
	crowd.animation.addByPrefix(
		'bop',
		'who instance 1',
		18,
		false
	);
	crowd.animation.play('bop');
	add(crowd);
	crowd.zIndex = 2;
	brown = new FlxSprite(760, 425);
	brown.frames = Paths.getSparrowAtlas(
		ext + 'graybrown'
	);
	brown.animation.addByPrefix(
		'idle',
		'ghosts idle',
		24,
		false
	);
	brown.animation.play('idle');
	brown.scale.set(.9, .9);
	brown.updateHitbox();
	brown.zIndex = 1;
	brown.alpha = 0;
	add(brown);
	red = new FlxSprite(1095, 455);
	red.frames = Paths.getSparrowAtlas(
		ext + 'grayred'
	);
	red.animation.addByPrefix(
		'idle',
		'ghosts idle',
		24,
		false
	);
	red.animation.play('idle');
	red.scale.set(.9, .9);
	red.updateHitbox();
	red.zIndex = 1;
	red.alpha = 0;
	add(red);
	yellow = new FlxSprite(1800, 365);
	yellow.frames = Paths.getSparrowAtlas(
		ext + 'grayyellow'
	);
	yellow.animation.addByPrefix(
		'idle',
		'ghosts idle',
		24,
		false
	);
	yellow.animation.play('idle');
	yellow.scale.set(.9, .9);
	yellow.updateHitbox();
	yellow.zIndex = 1;
	yellow.alpha = 0;
	add(yellow);
	blue = new FlxSprite(2135, 405);
	blue.frames = Paths.getSparrowAtlas(
		ext + 'grayblue'
	);
	blue.animation.addByPrefix(
		'idle',
		'ghosts idle',
		24,
		false
	);
	blue.animation.play('idle');
	blue.scale.set(.9, .9);
	blue.updateHitbox();
	blue.zIndex = 1;
	blue.alpha = 0;
	add(blue);
	brownBaseY = brown.y;
	redBaseY = red.y;
	yellowBaseY = yellow.y;
	blueBaseY = blue.y;
	bfdead = new FlxSprite(
		600,
		525
	).loadGraphic(
		Paths.image('stages/polus/red/bfdead')
	);
	bfdead.setGraphicSize(
		Std.int(bfdead.width * .8)
	);
	bfdead.updateHitbox();
	bfdead.alpha = 0;
}
function onCreatePost()
{
	if (hasGfSkin)
		gfGhost.visible = false;
	grayanim = new FlxSprite(
		dad.x - 150,
		dad.y - 20
	);
	grayanim.frames = Paths.getSparrowAtlas(
		'characters/triple/grey_blackoutanim'
	);
	grayanim.animation.addByPrefix(
		'bop',
		'gray',
		20,
		false
	);
	grayanim.alpha = 0;
	grayanim.scale.set(.95, .95);
	add(grayanim);
	grayanim.zIndex = 2;
	defeat = new FlxSprite(
		1200,
		500
	).loadGraphic(
		Paths.image('stages/void/iluminao omaga')
	);
	defeat.scale.set(4, 4);
	defeat.zIndex = 10;
	defeat.antialiasing = true;
	defeat.alpha = .55;
	defeat.color = 0xFF9A5CFF;
	add(defeat);
	defeatPurple = new FlxSprite(
		1200,
		500
	).loadGraphic(
		Paths.image('stages/void/iluminao omaga')
	);
	defeatPurple.scale.set(4, 4);
	defeatPurple.zIndex = 11;
	defeatPurple.antialiasing = true;
	defeatPurple.alpha = 0;
	defeatPurple.color = 0xFF5A2A99;
	defeatPurple.blend = BlendMode.ADD;
	add(defeatPurple);
	dark = new FlxSprite(0, 0).makeGraphic(
		FlxG.width,
		FlxG.height,
		FlxColor.BLACK
	);
	dark.zIndex = 11;
	dark.scrollFactor.set(0, 0);
	dark.alpha = 0;
	dark.cameras = [camOther];
	add(dark);
	if (ClientPrefs.shaders)
	{
		var darkVariant:String = boyfriend.getFlag('variants')?.dark;
		if (darkVariant != null)
			addCharacterToList(darkVariant, 0);
		darkShader = new funkin.game.shaders.ExtraDropShadowShader();
		darkShader.threshold = .03;
		darkShader.setHollowColorMatrix([
			0, 0, 0, 0, 255,
			0, 0, 0, 0, 255,
			0, 0, 0, 0, 255,
			0, 0, 0, 1, 0
		]);
		darkShader.setColorMatrix([
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 1, 0
		]);
		darkShader.antialiasStages = 4;
		hudDarkShader = new funkin.game.shaders.ExtraDropShadowShader()
			.copyFrom(darkShader);
		hudDarkShader.threshold = .12;
		hudDarkShader.setHollowColorMatrix([
			0, 0, 0, 0, 224,
			0, 0, 0, 0, 224,
			0, 0, 0, 0, 224,
			0, 0, 0, 1, 0
		]);
		darkShader.addLayer([
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 1, 0
		], -70, 22, 0);
		darkShader.addLayer([
			0, 0, 0, 0, 255,
			0, 0, 0, 0, 255,
			0, 0, 0, 0, 255,
			0, 0, 0, 1, 0
		], 140, 10, 0);
		darkShader.addLayer([
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 1, 0
		], -32, 12, 0);
		grayShader = new funkin.game.shaders.ExtraDropShadowShader();
		grayShader.threshold = .03;
		grayShader.setHollowColorMatrix([
			0, 0, 0, 0, 255,
			0, 0, 0, 0, 255,
			0, 0, 0, 0, 255,
			0, 0, 0, 1, 0
		]);
		grayShader.setColorMatrix([
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 1, 0
		]);
		grayShader.antialiasStages = 4;
		grayShader.addLayer([
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 1, 0
		], 200, 22, 0);
		grayShader.addLayer([
			0, 0, 0, 0, 255,
			0, 0, 0, 0, 255,
			0, 0, 0, 0, 255,
			0, 0, 0, 1, 0
		], 410, 10, 0);
		grayShader.addLayer([
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 1, 0
		], 238, 12, 0);
		darkShader.attachedSprite = boyfriend;
		grayShader.attachedSprite = dad;
		boyfriend.useRenderTexture = true;
		dad.useRenderTexture = true;
		boyfriend.shader = null;
		dad.shader = null;
	}
	snapCamToPos(1300, 700);
	camSpecialThing(
		[1300, 700],
		[1800, 700]
	);
	if (boyfriend.curCharacter == 'bf-ghost')
	{
		bfdead.alpha = 1;
		bfdead.setPosition(
			boyfriend.x - 150,
			boyfriend.y + 350
		);
		stage.insert(
			stage.members.indexOf(boyfriendGroup) - 1,
			bfdead
		);
		if (ClientPrefs.shaders)
		{
			var rim:DropShadowShader = new DropShadowShader();
			rim.setAdjustColor(
				-40,
				-25,
				-25,
				-25
			);
			rim.color = 0xFF447F80;
			rim.angle = 45;
			rim.threshold = .5;
			rim.distance = 25;
			bfdead.shader = rim;
			rim.attachedSprite = boyfriend;
			rim.updateFrameInfo(boyfriend.frame);
		}
		else
			bfdead.color = 0xffa0c0d6;
	}
	caShader = new ChromaticAbberation(0);
	caShader.amount = -.5;
	if (ClientPrefs.shaders)
		FlxG.camera.filters = [
			new ShaderFilter(caShader.shader)
		];
	grayfg = new FlxSprite(
		1200,
		1030
	).loadGraphic(
		Paths.image(
			ext + 'grayfg' +
			(boyfriend.curCharacter == 'yellowplayable'
				? '_noyellow'
				: '')
		)
	);
	grayfg.scrollFactor.set(1.1, 1.1);
	grayfg.zIndex = 3;
	add(grayfg);
	lightadd = new FlxSprite(
		-150,
		-200
	).loadGraphic(
		Paths.image(ext + 'grayadd')
	);
	lightadd.scale.set(2, 2);
	lightadd.updateHitbox();
	lightadd.blend = BlendMode.ADD;
	lightadd.alpha = 1;
	lightadd.zIndex = 4;
	add(lightadd);
	lightsubtract = new FlxSprite(
		-900,
		-200
	).loadGraphic(
		Paths.image(ext + 'graysubtract')
	);
	lightsubtract.scale.set(2, 2);
	lightsubtract.updateHitbox();
	lightsubtract.blend = BlendMode.SUBTRACT;
	lightsubtract.alpha = 1;
	lightsubtract.zIndex = 5;
	add(lightsubtract);
	if (hasGfSkin && gf.curCharacter == 'gfmira')
		changeCharacter(
			'gf-pretender',
			2
		);
	var rimlightBase:ExtraDropShadowShader =
		new funkin.game.shaders.ExtraDropShadowShader();
	rimlightBase.setColorMatrix(rimStartMatrix);
	rimlightBase.threshold = .02;
	rimlightBase.strength = .7;
	var rimInner = rimlightBase.addLayer(
		rimStartInner,
		20,
		25,
		.01
	);
	rimlightBase.addLayer(
		rimInner.colorMatrix,
		20,
		15,
		.01
	);
	if (boyfriend.getFlag('backlit') != true)
	{
		bfRim =
			new funkin.game.shaders.ExtraDropShadowShader()
				.copyFrom(rimlightBase);
		bfRim.attachedSprite = boyfriend;
		boyfriend.useRenderTexture = true;
		boyfriend.shader = bfRim;
	}
	if (gf.getFlag('backlit') != true)
	{
		gfRim =
			new funkin.game.shaders.ExtraDropShadowShader()
				.copyFrom(rimlightBase);
		gfRim.layers[0].distance = 20;
		gfRim.layers[1].distance = 20;
		gfRim.layers[0].angle = 60;
		gfRim.layers[1].angle = 120;
		gfRim.attachedSprite = gf;
		gf.useRenderTexture = true;
		gf.shader = gfRim;
	}
	if (hasPet)
	{
		petRim =
			new funkin.game.shaders.ExtraDropShadowShader()
				.copyFrom(rimlightBase);
		petRim.attachedSprite = pet;
		pet.shader = petRim;
	}
	dadRim =
		new funkin.game.shaders.ExtraDropShadowShader()
			.copyFrom(rimlightBase);
	dadRim.attachedSprite = dad;
	dad.useRenderTexture = true;
	dad.shader = dadRim;
	gfGhostRim =
		new funkin.game.shaders.ExtraDropShadowShader()
			.copyFrom(rimlightBase);
	gfGhostRim.strength = .55;
	gfGhostRim.attachedSprite = gfGhost;
	gfGhost.useRenderTexture = true;
	gfGhost.shader = gfGhostRim;
	grayfgRim =
		new funkin.game.shaders.ExtraDropShadowShader()
			.copyFrom(rimlightBase);
	grayfgRim.strength = .55;
	grayfgRim.attachedSprite = grayfg;
	grayfg.shader = grayfgRim;
	updateRimTransformations(0);
}
function onUpdatePost(elapsed)
{
	ghostFloatTime += elapsed;
	brown.y =
		brownBaseY +
		Math.sin(ghostFloatTime * 1.8) * 12;
	red.y =
		redBaseY +
		Math.sin(ghostFloatTime * 1.8 + 1.5) * 12;
	yellow.y =
		yellowBaseY +
		Math.sin(ghostFloatTime * 1.8 + 3.0) * 12;
	blue.y =
		blueBaseY +
		Math.sin(ghostFloatTime * 1.8 + 4.5) * 12;
	if (ClientPrefs.inDevMode && showDevInfo)
		dbText = dbText +
			'\nchrom (am, freq): ' +
			[chromAmount, chromFreq];
	if (
		playHUD.iconP2 != null &&
		dad.curCharacter == 'greythreat'
	)
	{
		timer -= elapsed;
		if (timer <= 0)
		{
			playHUD.iconP2.angle =
				(playHUD.iconP2.angle == 1)
					? -1
					: 1;
			timer = .05;
		}
	}
	if (ClientPrefs.shaders && dad != null && dad.curCharacter == 'greythreat' && greyThreatEyeOverlay == null)
		createGreyThreatEyeOverlay();
	syncGreyThreatEyeOverlay();
}
function onEvent(eventName, value1, value2)
{
	switch (eventName)
	{
		case 'chromToggle':
			var theAmount:Float =
				Std.parseFloat(value1 ?? 0);
			var theAmount2:Int =
				Std.int(
					value2 ??
					(theAmount > 0 ? 1 : 0)
				);
			if (showDevInfo)
				trace([
					theAmount,
					theAmount2
				]);
			if (theAmount > 0)
			{
				isChrom = true;
				chromAmount = theAmount;
				chromFreq = theAmount2;
			}
			else
			{
				isChrom = false;
				chromAmount = 0;
			}
		case 'Lights out':
			if (
				value1 == '2' ||
				(value1 == '1' && !ClientPrefs.flashing)
			)
				return;
			if (ClientPrefs.shaders)
			{
				isDark = true;
				isChrom = false;
				camGame.flash(
					ClientPrefs.flashing
						? FlxColor.WHITE
						: FlxColor.BLACK,
					.35
				);
				gf.alpha = .001;
				pet.alpha = .001;
				bg.alpha = .001;
				thebackground.alpha = .001;
				crowd.alpha = .001;
				bfdead.alpha = .001;
				grayfg.alpha = .001;
				lightadd.alpha = .001;
				lightsubtract.alpha = .001;
				playHUD.iconP1.shader = hudDarkShader;
				playHUD.iconP2.shader = hudDarkShader;
				dad.shader = grayShader;
				playHUD.healthBar.bg.setColorTransform(
					0,
					0,
					0,
					1,
					224,
					224,
					224
				);
				var darkVariant:String =
					boyfriend.getFlag('variants')?.dark;
				if (darkVariant != null)
				{
					changeCharacter(
						darkVariant,
						0
					);
					boyfriend.shader = null;
					noshader = true;
				}
				else if (boyfriend.getFlag('dark') != true)
				{
					boyfriend.shader = darkShader;
				}
				playHUD.healthBar.setColors(
					FlxColor.BLACK,
					0xffe0e0e0
				);
			}
		case 'Lights on':
			if (
				value1 == '1' &&
				!ClientPrefs.flashing
			)
				return;
			if (ClientPrefs.shaders)
			{
				isDark = false;
				gf.alpha = 1;
				pet.alpha = 1;
				bg.alpha = 1;
				thebackground.alpha = 1;
				crowd.alpha = 1;
				if (boyfriend.curCharacter == 'bfghost')
					bfdead.alpha = 1;
				grayfg.alpha = 1;
				lightadd.alpha = 1;
				lightsubtract.alpha = 1;
				playHUD.iconP1.shader = null;
				playHUD.iconP2.shader = null;
				camGame.flash(
					FlxColor.BLACK,
					.35
				);
				playHUD.healthBar.bg.setColorTransform();
				playHUD.healthBar.setColors(
					dad.healthColour,
					boyfriend.healthColour
				);
				if (noshader)
				{
					changeCharacter(
						hasBfSkin
							? ClientPrefs.bfSkin
							: PlayState.SONG.player1,
						0
					);
				}
				boyfriend.shader = null;
				if (dadRim != null)
				{
					dadRim.attachedSprite = dad;
					dad.shader = dadRim;
				}
				if (bfRim != null && !noshader)
				{
					bfRim.attachedSprite = boyfriend;
					boyfriend.shader = bfRim;
				}
				if (gfRim != null)
				{
					gfRim.attachedSprite = gf;
					gf.shader = gfRim;
				}
				if (gfGhostRim != null)
					gfGhost.shader = gfGhostRim;
				if (grayfgRim != null)
					grayfg.shader = grayfgRim;
			}
	}
}
function tweenGhost(ghost:FlxSprite)
{
	if (ghost == null)
		return;
	if (ghost == brown && brownTween != null)
		brownTween.cancel();
	else if (ghost == red && redTween != null)
		redTween.cancel();
	else if (ghost == yellow && yellowTween != null)
		yellowTween.cancel();
	else if (ghost == blue && blueTween != null)
		blueTween.cancel();
	ghost.alpha = 0;
	var tween:FlxTween = FlxTween.tween(
		ghost,
		{alpha: .45},
		1.5,
		{
			ease: FlxEase.quadOut
		}
	);
	if (ghost == brown)
		brownTween = tween;
	else if (ghost == red)
		redTween = tween;
	else if (ghost == yellow)
		yellowTween = tween;
	else if (ghost == blue)
		blueTween = tween;
}
function onGhostAnim(anim, note)
{
	if (isDark)
		return Function_Stop;
}
function getGreyThreatEyeLayers(symbolName:String):Array<String>
{
	switch (symbolName)
	{
		case 'idle':
			return ['Layer 4', 'Capa 17', 'Layer 2'];
		case 'right':
			return ['Layer 3', 'Layer 2'];
		case 'left':
			return ['Layer 3', 'Layer 7'];
		case 'down':
			return ['Layer 3', 'Layer 2'];
		case 'up':
			return ['Layer 3', 'Layer 8'];
	}
	return [];
}
function maskGreyThreatEyeOverlay(overlay:FunkinSprite):Void
{
	if (overlay == null || overlay.library == null)
		return;
	for (symbolName in ['idle', 'right', 'left', 'down', 'up'])
	{
		var symbol = overlay.library.getSymbol(symbolName);
		if (symbol == null || symbol.timeline == null)
			continue;
		var eyeLayers:Array<String> = getGreyThreatEyeLayers(symbolName);
		for (layer in symbol.timeline.layers)
		{
			var showLayer:Bool = eyeLayers.indexOf(layer.name) >= 0;
			layer.forEachFrame(function(frame)
			{
				if (frame == null || frame.elements == null)
					return;
				for (element in frame.elements)
					if (element != null)
						element.visible = showLayer;
			});
		}
	}
}
function hideOriginalGreyThreatEyes():Void
{
	if (dad == null || dad.library == null || greyThreatEyeOwner == dad)
		return;
	restoreOriginalGreyThreatEyes();
	greyThreatEyeOwner = dad;
	for (symbolName in ['idle', 'right', 'left', 'down', 'up'])
	{
		var symbol = dad.library.getSymbol(symbolName);
		if (symbol == null || symbol.timeline == null)
			continue;
		var eyeLayers:Array<String> = getGreyThreatEyeLayers(symbolName);
		for (layer in symbol.timeline.layers)
		{
			if (eyeLayers.indexOf(layer.name) < 0)
				continue;
			layer.forEachFrame(function(frame)
			{
				if (frame == null || frame.elements == null)
					return;
				for (element in frame.elements)
				{
					if (element == null)
						continue;
					greyThreatEyeOriginalVisibility.push({
						element: element,
						visible: element.visible
					});
					element.visible = false;
				}
			});
		}
	}
}
function restoreOriginalGreyThreatEyes():Void
{
	for (entry in greyThreatEyeOriginalVisibility)
	{
		if (entry != null && entry.element != null)
			entry.element.visible = entry.visible;
	}
	greyThreatEyeOriginalVisibility = [];
	greyThreatEyeOwner = null;
}
function createGreyThreatEyeOverlay():Void
{
	if (greyThreatEyeOverlay != null || dad == null || dad.curCharacter != 'greythreat')
		return;
	var char:FunkinSprite = dad;
	var atlasPath:String = Paths.getPath(
		'images/${char.imageFile}',
		null,
		PathsTestMode.LOOSE
	);
	var eyeFrames:FlxAnimateFrames = FlxAnimateFrames.fromAnimate(
		atlasPath,
		null,
		null,
		'greythreatEyesUnique',
		true,
		{cacheOnLoad:false}
	);
	if (eyeFrames == null)
		return;
	var overlay:FunkinSprite = new FunkinSprite(0, 0);
	overlay.frames = eyeFrames;
	for (anim in char.animations)
	{
		if (anim == null)
			continue;
		var animName:String = '' + anim.anim;
		var sourceName:String = '' + anim.name;
		var fps:Int = anim.fps;
		var looping:Bool = !!anim.loop;
		var indices:Array<Int> = anim.indices ?? [];
		var flipX:Bool = anim.flipX ?? false;
		var flipY:Bool = anim.flipY ?? false;
		if (indices.length > 0)
			overlay.addAnimByIndices(animName, sourceName, indices, fps, looping, flipX, flipY);
		else
			overlay.addAnimByPrefix(animName, sourceName, fps, looping, flipX, flipY);
	}
	overlay.scalableOffsets = char.scalableOffsets;
	overlay.rotatableOffsets = char.rotatableOffsets;
	overlay.skewableOffsets = char.skewableOffsets;
	overlay.baseFlipX = char.baseFlipX;
	overlay.baseFlipY = char.baseFlipY;
	overlay.antialiasing = char.antialiasing;
	overlay.shader = null;
	overlay.useRenderTexture = false;
	overlay.cameras = [camGame];
	overlay.scrollFactor.set(char.scrollFactor.x, char.scrollFactor.y);
	overlay.active = false;
	overlay.visible = false;
	overlay.zIndex = char.zIndex + 0.01;
	maskGreyThreatEyeOverlay(overlay);
	hideOriginalGreyThreatEyes();
	greyThreatEyeOverlay = overlay;
	dadGroup.add(greyThreatEyeOverlay);
	syncGreyThreatEyeOverlay();
}
function syncGreyThreatEyeOverlay():Void
{
	if (greyThreatEyeOverlay == null || dad == null)
		return;
	if (dad.curCharacter != 'greythreat')
	{
		greyThreatEyeOverlay.visible = false;
		greyThreatEyeOverlay.active = false;
		return;
	}
	if (greyThreatEyeOwner != dad)
		hideOriginalGreyThreatEyes();
	if (!dad.exists || !dad.visible || dad.alpha <= 0 || dad.isAnimNull())
	{
		greyThreatEyeOverlay.visible = false;
		greyThreatEyeOverlay.active = false;
		return;
	}
	var currentAnim:String = dad.getAnimName();
	if (currentAnim == '' || !greyThreatEyeOverlay.hasAnim(currentAnim))
	{
		greyThreatEyeOverlay.visible = false;
		greyThreatEyeOverlay.active = false;
		return;
	}
	if (greyThreatEyeAnim != currentAnim)
	{
		greyThreatEyeOverlay.playAnim(currentAnim, true, false);
		greyThreatEyeAnim = currentAnim;
	}
	var frameCount:Int = greyThreatEyeOverlay.getAnimNumFrames();
	if (frameCount > 0)
	{
		var frame:Int = dad.animCurFrame;
		if (frame < 0) frame = 0;
		if (frame >= frameCount) frame = frameCount - 1;
		greyThreatEyeOverlay.animCurFrame = frame;
	}
	greyThreatEyeOverlay.x = dad.x;
	greyThreatEyeOverlay.y = dad.y;
	greyThreatEyeOverlay.scale.set(dad.scale.x, dad.scale.y);
	greyThreatEyeOverlay.baseScale.set(dad.baseScale.x, dad.baseScale.y);
	greyThreatEyeOverlay.origin.set(dad.origin.x, dad.origin.y);
	greyThreatEyeOverlay.offset.set(dad.offset.x, dad.offset.y);
	greyThreatEyeOverlay.spriteOffset.set(dad.spriteOffset.x, dad.spriteOffset.y);
	greyThreatEyeOverlay.animOffset.set(dad.animOffset.x, dad.animOffset.y);
	greyThreatEyeOverlay.angle = dad.angle;
	greyThreatEyeOverlay.skew.set(dad.skew.x, dad.skew.y);
	greyThreatEyeOverlay.flipX = dad.flipX;
	greyThreatEyeOverlay.flipY = dad.flipY;
	greyThreatEyeOverlay.alpha = dad.alpha;
	greyThreatEyeOverlay.color = dad.color;
	greyThreatEyeOverlay.blend = dad.blend;
	greyThreatEyeOverlay.scrollFactor.set(dad.scrollFactor.x, dad.scrollFactor.y);
	greyThreatEyeOverlay.antialiasing = dad.antialiasing;
	greyThreatEyeOverlay.zIndex = dad.zIndex + 0.01;
	greyThreatEyeOverlay.shader = null;
	greyThreatEyeOverlay.useRenderTexture = false;
	greyThreatEyeOverlay.cameras = [camGame];
	greyThreatEyeOverlay.colorTransform.redMultiplier = dad.colorTransform.redMultiplier;
	greyThreatEyeOverlay.colorTransform.greenMultiplier = dad.colorTransform.greenMultiplier;
	greyThreatEyeOverlay.colorTransform.blueMultiplier = dad.colorTransform.blueMultiplier;
	greyThreatEyeOverlay.colorTransform.alphaMultiplier = dad.colorTransform.alphaMultiplier;
	greyThreatEyeOverlay.colorTransform.redOffset = dad.colorTransform.redOffset;
	greyThreatEyeOverlay.colorTransform.greenOffset = dad.colorTransform.greenOffset;
	greyThreatEyeOverlay.colorTransform.blueOffset = dad.colorTransform.blueOffset;
	greyThreatEyeOverlay.colorTransform.alphaOffset = dad.colorTransform.alphaOffset;
	greyThreatEyeOverlay.active = true;
	greyThreatEyeOverlay.visible = true;
}
function onDestroy()
{
	restoreOriginalGreyThreatEyes();
	if (greyThreatEyeOverlay != null)
	{
		greyThreatEyeOverlay.destroy();
		greyThreatEyeOverlay = null;
	}
	greyThreatEyeAnim = '';
}
