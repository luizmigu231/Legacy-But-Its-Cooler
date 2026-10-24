import funkin.game.shaders.ChromaticAbberation;
import funkin.game.shaders.DropShadowShader;
import openfl.filters.ShaderFilter;
import animate.FlxAnimateFrames;

var gfGhost:Character;
var noob69Exe:FunkinSprite;
var defeat:FlxSprite;
var bg:FlxSprite;
var thebackground:FlxSprite;
var grayfg:FlxSprite;
var lightadd:FlxSprite;
var lightsubtract:FlxSprite;
var defeatPurple:FlxSprite;
var purpleOverlay:FlxSprite;
var mist:FlxSprite;
var hudDarkShader:ExtraDropShadowShader;
var darkShader:ExtraDropShadowShader;
var grayShader:ExtraDropShadowShader;
var bfRim:ExtraDropShadowShader;
var petRim:ExtraDropShadowShader;
var dadRim:ExtraDropShadowShader;
var gfRim:ExtraDropShadowShader;
var grayfgRim:ExtraDropShadowShader;
var gfGhostRim:ExtraDropShadowShader;
var bfdeadRim:ExtraDropShadowShader;
var noobRim:ExtraDropShadowShader;
var isDark:Bool = false;
var noshader:Bool = false;
var purpleMode:Bool = false;
var ext = 'stages/airship/gray/';
var isChrom:Bool;
var chromAmount:Float = 0;
var chromFreq:Int = 1;
var setChromActive:Bool = false;

var chromTween:FlxTween;
var caGameShader:ChromaticAbberation;
var caHUDShader:FlxRuntimeShader;

var hudPurpleColor:Int = 0xFFAA46DC;
var hudP1OriginalColor:Int;
var hudP2OriginalColor:Int;

public var crowd:FlxSprite;
var bfdead:FlxSprite;
var brown:FlxSprite;
var red:FlxSprite;
var yellow:FlxSprite;
var blue:FlxSprite;
var timer:Float = 0.1;

var brownBaseX:Float;
var brownBaseY:Float;
var redBaseX:Float;
var redBaseY:Float;
var yellowBaseX:Float;
var yellowBaseY:Float;
var blueBaseX:Float;
var blueBaseY:Float;

var greyThreatEyeOverlay:FunkinSprite;
var greyThreatEyeOwner:Dynamic = null;
var greyThreatEyeAnim:String = '';
var greyThreatEyeOriginalVisibility:Array<Dynamic> = [];

function onBeatHit()
{
	if (curBeat % chromFreq == 0 && !setChromActive)
	{
		if (chromTween != null)
			chromTween.cancel();

		if (caGameShader != null && caHUDShader != null && isChrom)
		{
			caGameShader.amount = chromAmount;
			caHUDShader.setFloat('amount', chromAmount);

			chromTween = FlxTween.num(
				chromAmount,
				0,
				0.45,
				{
					ease: FlxEase.sineOut,
					onUpdate: function(tween:FlxTween)
					{
						if (caGameShader != null)
							caGameShader.amount = tween.value;

						if (caHUDShader != null)
							caHUDShader.setFloat('amount', tween.value);
					}
				}
			);
		}
	}

	if (curBeat % 4 == 0)
		crowd.animation.play('bop', true);

	gfGhost.onBeatHit();

	if (curBeat % 2 == 0)
	{
		brown.animation.play('idle', true);
		red.animation.play('idle', true);
		yellow.animation.play('idle', true);
		blue.animation.play('idle', true);

		if (noob69Exe != null)
			noob69Exe.playAnim('idle', true);
	}

	if (curBeat == 260)
	{
		purpleMode = true;

		gfGhost.alpha = 0;
		noob69Exe.alpha = 0;
		bfdead.alpha = 0;
		purpleOverlay.alpha = 0;
		mist.alpha = 0;
		mist.color = FlxColor.WHITE;

		boyfriend.shader = null;
		dad.shader = null;
		gf.shader = null;

		boyfriend.alpha = 1;
		dad.alpha = 1;
		gf.alpha = 1;

		boyfriend.setColorTransform();
		dad.setColorTransform();
		gf.setColorTransform();

		if (playHUD.iconP1 != null)
			hudP1OriginalColor = boyfriend.healthColour;

		if (playHUD.iconP2 != null)
			hudP2OriginalColor = dad.healthColour;

		FlxTween.num(
			0,
			1,
			0.5,
			{
				ease: FlxEase.sineInOut,
				onUpdate: function(tween:FlxTween)
				{
					var t:Float = tween.value;

					purpleOverlay.alpha = t;
					mist.alpha = 0.65 * t;

					bg.alpha = 1 - t;
					thebackground.alpha = 1 - t;
					crowd.alpha = 1 - t;
					brown.alpha = 0.22 * (1 - t);
					red.alpha = 0.22 * (1 - t);
					yellow.alpha = 0.22 * (1 - t);
					blue.alpha = 0.22 * (1 - t);
					grayfg.alpha = 1 - t;
					lightadd.alpha = 1 - t;
					lightsubtract.alpha = 1 - t;
					pet.alpha = 1 - t;
					noob69Exe.alpha = 0.5 * (1 - t);

					for (obj in [playHUD.scoreTxt, playHUD.timeBar, playHUD.timeTxt])
						obj.visible = false;

					defeat.alpha = 0.55;
					defeatPurple.alpha = 0.35;

					defeat.color = FlxColor.interpolate(
						0xFF9A5CFF,
						0xFFFF0000,
						t
					);

					defeatPurple.color = FlxColor.interpolate(
						0xFF5A2A99,
						0xFFFF0000,
						t
					);

					boyfriend.setColorTransform(
						1 - t,
						1 - t,
						1 - t,
						1,
						170 * t,
						70 * t,
						220 * t,
						0
					);

					dad.setColorTransform(
						1 - t,
						1 - t,
						1 - t,
						1,
						170 * t,
						70 * t,
						220 * t,
						0
					);

					gf.setColorTransform(
						1 - t,
						1 - t,
						1 - t,
						1,
						105 * t,
						35 * t,
						140 * t,
						0
					);

					mist.color = FlxColor.interpolate(
						FlxColor.WHITE,
						0xFF6A3A82,
						t
					);

					if (playHUD.iconP1 != null)
					{
						playHUD.iconP1.setColorTransform(
							1 - t,
							1 - t,
							1 - t,
							1,
							170 * t,
							70 * t,
							220 * t,
							0
						);
					}

					if (playHUD.iconP2 != null)
					{
						playHUD.iconP2.setColorTransform(
							1 - t,
							1 - t,
							1 - t,
							1,
							170 * t,
							70 * t,
							220 * t,
							0
						);
					}

					if (playHUD.healthBar != null)
					{
						var p1Color:Int = FlxColor.interpolate(
							hudP1OriginalColor,
							hudPurpleColor,
							t
						);

						var p2Color:Int = FlxColor.interpolate(
							hudP2OriginalColor,
							hudPurpleColor,
							t
						);

						playHUD.healthBar.setColors(p1Color, p2Color);

						if (playHUD.healthBar.bg != null)
						{
							playHUD.healthBar.bg.setColorTransform(
								1 - t,
								1 - t,
								1 - t,
								1,
								170 * t,
								70 * t,
								220 * t,
								0
							);
						}
					}
				},
				onComplete: function(tween:FlxTween)
				{
					purpleOverlay.alpha = 1;
					mist.alpha = 0.65;
					mist.color = 0xFF6A3A82;

					bg.alpha = 0;
					thebackground.alpha = 0;
					crowd.alpha = 0;
					brown.alpha = 0;
					red.alpha = 0;
					yellow.alpha = 0;
					blue.alpha = 0;
					noob69Exe.alpha = 0;
					bfdead.alpha = 0;
					grayfg.alpha = 0;
					lightadd.alpha = 0;
					lightsubtract.alpha = 0;
					pet.alpha = 0;

					defeat.alpha = 0.55;
					defeatPurple.alpha = 0.35;

					defeat.color = 0xFFFF0000;
					defeatPurple.color = 0xFFFF0000;

					boyfriend.setColorTransform(
						0, 0, 0, 1,
						170, 70, 220, 0
					);

					dad.setColorTransform(
						0, 0, 0, 1,
						170, 70, 220, 0
					);

					gf.setColorTransform(
						0, 0, 0, 1,
						105, 35, 140, 0
					);

					if (playHUD.iconP1 != null)
					{
						playHUD.iconP1.setColorTransform(
							0, 0, 0, 1,
							170, 70, 220, 0
						);
					}

					if (playHUD.iconP2 != null)
					{
						playHUD.iconP2.setColorTransform(
							0, 0, 0, 1,
							170, 70, 220, 0
						);
					}

					if (playHUD.healthBar != null)
					{
						playHUD.healthBar.setColors(
							hudPurpleColor,
							hudPurpleColor
						);

						if (playHUD.healthBar.bg != null)
						{
							playHUD.healthBar.bg.setColorTransform(
								0, 0, 0, 1,
								170, 70, 220, 0
							);
						}
					}
				}
			}
		);
	}

	if (curBeat == 328)
	{
		purpleMode = false;

		purpleOverlay.alpha = 1;
		mist.alpha = 0.65;
		mist.color = 0xFF6A3A82;

		gfGhost.alpha = 0;
		noob69Exe.alpha = 0;

		bg.alpha = 0;
		thebackground.alpha = 0;
		crowd.alpha = 0;
		brown.alpha = 0;
		red.alpha = 0;
		yellow.alpha = 0;
		blue.alpha = 0;
		bfdead.alpha = 0;
		grayfg.alpha = 0;
		lightadd.alpha = 0;
		lightsubtract.alpha = 0;
		pet.alpha = 0;

		for (obj in [playHUD.scoreTxt, playHUD.timeBar, playHUD.timeTxt])
			obj.visible = true;

		defeat.alpha = 0.55;
		defeatPurple.alpha = 0.35;

		defeat.color = 0xFFFF0000;
		defeatPurple.color = 0xFFFF0000;

		boyfriend.shader = null;
		dad.shader = null;
		gf.shader = null;

		boyfriend.setColorTransform(
			0, 0, 0, 1,
			170, 70, 220, 0
		);

		dad.setColorTransform(
			0, 0, 0, 1,
			170, 70, 220, 0
		);

		gf.setColorTransform(
			0, 0, 0, 1,
			105, 35, 140, 0
		);

		boyfriend.alpha = 1;
		dad.alpha = 1;
		gf.alpha = 1;

		FlxTween.num(
			0,
			1,
			0.5,
			{
				ease: FlxEase.sineInOut,
				onUpdate: function(tween:FlxTween)
				{
					var t:Float = tween.value;

					purpleOverlay.alpha = 1 - t;
					mist.alpha = 0.65 * (1 - t);

					bg.alpha = t;
					thebackground.alpha = t;
					crowd.alpha = t;
					brown.alpha = 0.22 * t;
					red.alpha = 0.22 * t;
					yellow.alpha = 0.22 * t;
					blue.alpha = 0.22 * t;
					grayfg.alpha = t;
					lightadd.alpha = t;
					lightsubtract.alpha = t;
					pet.alpha = t;
					noob69Exe.alpha = 0.5 * t;

					defeat.alpha = 0.55;
					defeatPurple.alpha = 0.35;

					defeat.color = FlxColor.interpolate(
						0xFFFF0000,
						0xFF9A5CFF,
						t
					);

					defeatPurple.color = FlxColor.interpolate(
						0xFFFF0000,
						0xFF5A2A99,
						t
					);

					boyfriend.setColorTransform(
						0,
						0,
						0,
						1,
						170 * (1 - t),
						70 * (1 - t),
						220 * (1 - t),
						0
					);

					dad.setColorTransform(
						0,
						0,
						0,
						1,
						170 * (1 - t),
						70 * (1 - t),
						220 * (1 - t),
						0
					);

					gf.setColorTransform(
						0,
						0,
						0,
						1,
						105 * (1 - t),
						35 * (1 - t),
						140 * (1 - t),
						0
					);

					mist.color = FlxColor.interpolate(
						0xFF6A3A82,
						FlxColor.WHITE,
						t
					);

					if (playHUD.iconP1 != null)
					{
						playHUD.iconP1.setColorTransform(
							0,
							0,
							0,
							1,
							170 * (1 - t),
							70 * (1 - t),
							220 * (1 - t),
							0
						);
					}

					if (playHUD.iconP2 != null)
					{
						playHUD.iconP2.setColorTransform(
							0,
							0,
							0,
							1,
							170 * (1 - t),
							70 * (1 - t),
							220 * (1 - t),
							0
						);
					}

					if (playHUD.healthBar != null)
					{
						var p1Color:Int = FlxColor.interpolate(
							hudPurpleColor,
							boyfriend.healthColour,
							t
						);

						var p2Color:Int = FlxColor.interpolate(
							hudPurpleColor,
							dad.healthColour,
							t
						);

						playHUD.healthBar.setColors(p1Color, p2Color);

						if (playHUD.healthBar.bg != null)
						{
							playHUD.healthBar.bg.setColorTransform(
								0,
								0,
								0,
								1,
								170 * (1 - t),
								70 * (1 - t),
								220 * (1 - t),
								0
							);
						}
					}
				},
				onComplete: function(tween:FlxTween)
				{
					purpleOverlay.alpha = 0;
					mist.alpha = 0;
					mist.x = 0;
					mist.color = FlxColor.WHITE;

					gfGhost.alpha = hasGfSkin ? 0 : 1;
					noob69Exe.alpha = 0.5;

					bg.alpha = 1;
					thebackground.alpha = 1;
					crowd.alpha = 1;
					brown.alpha = 0.22;
					red.alpha = 0.22;
					yellow.alpha = 0.22;
					blue.alpha = 0.22;

					if (boyfriend.curCharacter == "bfghost")
						bfdead.alpha = 1;
					else
						bfdead.alpha = 0;

					grayfg.alpha = 1;
					lightadd.alpha = 1;
					lightsubtract.alpha = 1;
					pet.alpha = 1;

					defeat.alpha = 0.55;
					defeatPurple.alpha = 0.35;

					defeat.color = 0xFF9A5CFF;
					defeatPurple.color = 0xFF5A2A99;

					boyfriend.setColorTransform();
					dad.setColorTransform();
					gf.setColorTransform();

					boyfriend.color = FlxColor.WHITE;
					dad.color = FlxColor.WHITE;
					gf.color = FlxColor.WHITE;

					if (playHUD.iconP1 != null)
						playHUD.iconP1.setColorTransform();

					if (playHUD.iconP2 != null)
						playHUD.iconP2.setColorTransform();

					if (playHUD.healthBar != null)
					{
						playHUD.healthBar.setColors(
							dad.healthColour,
							boyfriend.healthColour
						);

						if (playHUD.healthBar.bg != null)
							playHUD.healthBar.bg.setColorTransform();
					}

					if (ClientPrefs.shaders)
					{
						if (bfRim != null)
						{
							bfRim.attachedSprite = boyfriend;
							boyfriend.shader = bfRim;
						}

						if (dadRim != null)
						{
							dadRim.attachedSprite = dad;
							dad.shader = dadRim;
						}

						if (gfRim != null)
						{
							gfRim.attachedSprite = gf;
							gf.shader = gfRim;
						}

						if (gfGhostRim != null)
							gfGhost.shader = gfGhostRim;

						if (bfdeadRim != null)
							bfdead.shader = bfdeadRim;

						if (noobRim != null)
							noob69Exe.shader = noobRim;

						if (grayfgRim != null)
							grayfg.shader = grayfgRim;
					}
					else
					{
						if (hasBfSkin && boyfriend.curCharacter != 'bfairship')
							boyfriend.color = 0xffa0c0d6;

						if (hasGfSkin)
							gf.color = 0xffa0c0d6;

						if (hasPet)
							pet.color = 0xffa0c0d6;
					}
				}
			}
		);
	}
}

function onLoad()
{
	gfGhost = new Character(1190, 250, "gf-ghost");
	startCharacterPos(gfGhost);
	gfGhost.alpha = 1;
	gfGhost.zIndex = 1;
	add(gfGhost);

	noob69Exe = new FunkinSprite(500, 550);
	noob69Exe.frames = Paths.getSparrowAtlas(ext + 'noob49Exe');
	noob69Exe.addAnimByPrefix('idle', '49', 24, false);
	noob69Exe.scale.set(1.2, 1.2);
	noob69Exe.updateHitbox();
	noob69Exe.zIndex = 1;
	noob69Exe.alpha = 0.8;
	add(noob69Exe);

	bg = new FlxSprite(0, 0).loadGraphic(Paths.image(ext + 'graybg'));
	add(bg);

	thebackground = new FlxSprite(1930, 400);
	thebackground.frames = Paths.getSparrowAtlas(ext + 'grayglowy');
	thebackground.animation.addByPrefix('bop', 'jar??', 24, true);
	thebackground.animation.play('bop');
	thebackground.antialiasing = true;
	thebackground.scrollFactor.set(1, 1);
	thebackground.setGraphicSize(Std.int(thebackground.width * 1));
	thebackground.active = true;
	add(thebackground);

	crowd = new FlxSprite(200, 350);
	crowd.frames = Paths.getSparrowAtlas(ext + 'grayblack');
	crowd.animation.addByPrefix('bop', 'who instance 1', 18, false);
	crowd.animation.play('bop');
	add(crowd);

	brown = new FlxSprite(760, 425);
	brown.frames = Paths.getSparrowAtlas(ext + 'graybrown');
	brown.animation.addByPrefix('idle', 'ghosts idle', 24, false);
	brown.animation.play('idle');
	brown.scale.set(0.9, 0.9);
	brown.updateHitbox();
	brown.zIndex = 1;
	brown.alpha = 0.22;
	add(brown);

	red = new FlxSprite(1095, 455);
	red.frames = Paths.getSparrowAtlas(ext + 'grayred');
	red.animation.addByPrefix('idle', 'ghosts idle', 24, false);
	red.animation.play('idle');
	red.scale.set(0.9, 0.9);
	red.updateHitbox();
	red.zIndex = 1;
	red.alpha = 0.22;
	add(red);

	yellow = new FlxSprite(1800, 365);
	yellow.frames = Paths.getSparrowAtlas(ext + 'grayyellow');
	yellow.animation.addByPrefix('idle', 'ghosts idle', 24, false);
	yellow.animation.play('idle');
	yellow.scale.set(0.9, 0.9);
	yellow.updateHitbox();
	yellow.zIndex = 1;
	yellow.alpha = 0.22;
	add(yellow);

	blue = new FlxSprite(2135, 405);
	blue.frames = Paths.getSparrowAtlas(ext + 'grayblue');
	blue.animation.addByPrefix('idle', 'ghosts idle', 24, false);
	blue.animation.play('idle');
	blue.scale.set(0.9, 0.9);
	blue.updateHitbox();
	blue.zIndex = 1;
	blue.alpha = 0.22;
	add(blue);

	brownBaseX = brown.x;
	brownBaseY = brown.y;
	redBaseX = red.x;
	redBaseY = red.y;
	yellowBaseX = yellow.x;
	yellowBaseY = yellow.y;
	blueBaseX = blue.x;
	blueBaseY = blue.y;

	bfdead = new FlxSprite(600, 525).loadGraphic(Paths.image('stages/polus/red/bfdead'));
	bfdead.setGraphicSize(Std.int(bfdead.width * 0.8));
	bfdead.updateHitbox();
	bfdead.alpha = 0;

	purpleOverlay = new FlxSprite(0, 0);
	purpleOverlay.makeGraphic(FlxG.width, FlxG.height, 0xFF4A075C);
	purpleOverlay.scrollFactor.set(0, 0);
	purpleOverlay.alpha = 0;
	purpleOverlay.cameras = [camGame];

	mist = new FlxSprite(0, 0);
	mist.loadGraphic(Paths.image('stages/mira/reactorRuined/mist'));
	mist.setGraphicSize(FlxG.width, FlxG.height);
	mist.updateHitbox();
	mist.scrollFactor.set(0, 0);
	mist.alpha = 0;
	mist.color = FlxColor.WHITE;
	mist.blend = BlendMode.ADD;
	mist.cameras = [camGame];
}

function onCreatePost()
{
	if (hasGfSkin)
		gfGhost.visible = false;

	defeat = new FlxSprite(1200, 500).loadGraphic(Paths.image('stages/void/iluminao omaga'));
	defeat.scale.set(4, 4);
	defeat.color = 0xFF9A5CFF;
	defeat.alpha = 0.55;
	defeat.zIndex = 10;
	defeat.antialiasing = true;
	add(defeat);

	defeatPurple = new FlxSprite(1200, 500).loadGraphic(Paths.image('stages/void/iluminao omaga'));
	defeatPurple.scale.set(4, 4);
	defeatPurple.color = 0xFF5A2A99;
	defeatPurple.alpha = 0.35;
	defeatPurple.blend = BlendMode.ADD;
	defeatPurple.zIndex = 11;
	defeatPurple.antialiasing = true;
	add(defeatPurple);

	if (ClientPrefs.shaders)
	{
		var dark:Null<String> = boyfriend.getFlag('variants')?.dark;

		if (dark != null)
			addCharacterToList(dark, 0);

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

		hudDarkShader = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(darkShader);
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
	camSpecialThing([1300, 700], [1800, 700]);

	if (boyfriend.curCharacter == 'bf-ghost')
	{
		bfdead.alpha = 1;
		bfdead.setPosition(boyfriend.x - 150, boyfriend.y + 350);
		stage.insert(stage.members.indexOf(boyfriendGroup) - 1, bfdead);
	}

	var gfIndex:Int = stage.members.indexOf(gfGroup);
	stage.insert(gfIndex, purpleOverlay);

	var dadIndex:Int = stage.members.indexOf(dadGroup);
	stage.insert(dadIndex, mist);

	if (ClientPrefs.shaders)
	{
		caGameShader = new ChromaticAbberation(0);
		caGameShader.amount = -0.5;

		caHUDShader = new FlxRuntimeShader(
			Paths.getTextFromFile('shaders/chromaticHUD.frag')
		);

		caHUDShader.setFloat('amount', 0);

		FlxG.camera.filters = [
			new ShaderFilter(caGameShader.shader)
		];

		camHUD.filters = [
			new ShaderFilter(caHUDShader)
		];
	}

	grayfg = new FlxSprite(1200, 1030).loadGraphic(Paths.image(
		ext + 'grayfg' + (boyfriend.curCharacter == 'yellowplayable' ? '_noyellow' : '')
	));

	grayfg.scrollFactor.set(1.1, 1.1);
	grayfg.zIndex = 3;
	add(grayfg);

	lightadd = new FlxSprite(-150, -200).loadGraphic(Paths.image(ext + 'grayadd'));
	lightadd.scale.set(2, 2);
	lightadd.updateHitbox();
	lightadd.blend = BlendMode.ADD;
	lightadd.alpha = 1;
	lightadd.zIndex = 4;
	add(lightadd);

	lightsubtract = new FlxSprite(-900, -200).loadGraphic(Paths.image(ext + 'graysubtract'));
	lightsubtract.scale.set(2, 2);
	lightsubtract.updateHitbox();
	lightsubtract.blend = BlendMode.SUBTRACT;
	lightsubtract.alpha = 1;
	lightsubtract.zIndex = 5;
	add(lightsubtract);

	if (hasGfSkin && gf.curCharacter == 'gfmira')
		changeCharacter('gf-pretender', 2);

	if (ClientPrefs.shaders)
	{
		var rimlightBase:ExtraDropShadowShader = new funkin.game.shaders.ExtraDropShadowShader();

		rimlightBase.setColorMatrix([
			0.20, 0.04, 0.02, 0, 15,
			0.00, 0.16, 0.05, 0, 3,
			0.10, 0.03, 0.42, 0, 34,
			0, 0, 0, 1, 0
		]);

		rimlightBase.threshold = .028;
		rimlightBase.strength = .62;

		var rimInner = rimlightBase.addLayer([
			0.48, 0.02, 0.02, 0, 24,
			0.00, 0.20, 0.06, 0, 4,
			0.18, 0.02, 0.60, 0, 52,
			0, 0, 0, 1, 0
		], 12, 16, .01);

		rimlightBase.addLayer(
			rimInner.colorMatrix,
			62,
			11,
			.01
		);

		bfRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(rimlightBase);
		bfRim.strength = .55;
		bfRim.attachedSprite = boyfriend;
		boyfriend.useRenderTexture = true;

		gfGhostRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(rimlightBase);
		gfGhostRim.strength = .55;
		gfGhostRim.attachedSprite = gfGhost;
		gfGhost.useRenderTexture = true;
		gfGhost.shader = gfGhostRim;

		bfdeadRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(rimlightBase);
		bfdeadRim.strength = .55;
		bfdeadRim.attachedSprite = bfdead;
		bfdead.shader = bfdeadRim;

		gfRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(rimlightBase);
		gfRim.strength = .55;
		gfRim.attachedSprite = gf;
		gf.useRenderTexture = true;

		if (hasPet)
		{
			petRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(rimlightBase);
			petRim.strength = .48;
			petRim.attachedSprite = pet;
		}

		dadRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(rimlightBase);
		dadRim.strength = .55;
		dadRim.attachedSprite = dad;
		dad.useRenderTexture = true;

		grayfgRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(rimlightBase);
		grayfgRim.strength = .55;
		grayfgRim.attachedSprite = grayfg;
		grayfg.shader = grayfgRim;

		noobRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(rimlightBase);
		noobRim.strength = .55;
		noobRim.attachedSprite = noob69Exe;
		noob69Exe.shader = noobRim;
	}

	bg.setColorTransform(
		0.78, 0.48, 0.88, 1,
		8, 0, 18, 0
	);

	thebackground.setColorTransform(
		0.82, 0.52, 0.90, 1,
		10, 0, 20, 0
	);

	crowd.setColorTransform(
		0.78, 0.48, 0.86, 1,
		8, 0, 18, 0
	);

	brown.setColorTransform(
		0.82, 0.56, 0.86, 1,
		8, 0, 12, 0
	);

	red.setColorTransform(
		0.92, 0.48, 0.72, 1,
		12, 0, 12, 0
	);

	yellow.setColorTransform(
		0.92, 0.62, 0.78, 1,
		12, 4, 10, 0
	);

	blue.setColorTransform(
		0.70, 0.58, 0.95, 1,
		4, 0, 20, 0
	);

	brown.alpha = 0.22;
	red.alpha = 0.22;
	yellow.alpha = 0.22;
	blue.alpha = 0.22;

	if (ClientPrefs.shaders && dad != null && dad.curCharacter == 'greythreat')
		createGreyThreatEyeOverlay();
}

function onUpdatePost(elapsed)
{
	if (ClientPrefs.inDevMode && showDevInfo)
		dbText = dbText + ('\nchrom (am, freq): ' + [chromAmount, chromFreq]);

	if (mist != null && mist.alpha > 0)
		mist.x = Math.sin(Conductor.songPosition / 3500) * 40;

	if (brown != null)
	{
		brown.y = brownBaseY + Math.sin(Conductor.songPosition / 900) * 18;
		brown.x = brownBaseX + Math.sin(Conductor.songPosition / 1400) * 10;
	}

	if (red != null)
	{
		red.y = redBaseY + Math.sin(Conductor.songPosition / 1050 + 1.5) * 22;
		red.x = redBaseX + Math.sin(Conductor.songPosition / 1600 + 1.5) * 12;
	}

	if (yellow != null)
	{
		yellow.y = yellowBaseY + Math.sin(Conductor.songPosition / 850 + 3.0) * 16;
		yellow.x = yellowBaseX + Math.sin(Conductor.songPosition / 1300 + 3.0) * 9;
	}

	if (blue != null)
	{
		blue.y = blueBaseY + Math.sin(Conductor.songPosition / 1150 + 4.5) * 20;
		blue.x = blueBaseX + Math.sin(Conductor.songPosition / 1500 + 4.5) * 11;
	}

	if (playHUD.iconP2 != null && dad.curCharacter == "greythreat")
	{
		timer -= elapsed;

		if (timer <= 0)
		{
			playHUD.iconP2.angle = (playHUD.iconP2.angle == 1) ? -1 : 1;
			timer = 0.05;
		}
	}

	if (greyThreatEyeOverlay == null && ClientPrefs.shaders && dad != null && dad.curCharacter == 'greythreat')
		createGreyThreatEyeOverlay();

	syncGreyThreatEyeOverlay();
}

function onEvent(eventName, value1, value2)
{
	switch (eventName)
	{
		case 'setChrom':
			var theAmount:Float = Std.parseFloat(value1);

			if (Math.isNaN(theAmount))
				theAmount = 0;

			var theSpeed:Float = Std.parseFloat(value2);

			if (Math.isNaN(theSpeed))
				theSpeed = 0;

			if (chromTween != null)
				chromTween.cancel();

			setChromActive = (theAmount != 0);

			if (caGameShader != null && caHUDShader != null)
			{
				var startAmount:Float = caGameShader.amount;

				chromTween = FlxTween.num(
					startAmount,
					theAmount,
					theSpeed,
					{
						ease: FlxEase.sineOut,
						onUpdate: function(tween:FlxTween)
						{
							if (caGameShader != null)
								caGameShader.amount = tween.value;

							if (caHUDShader != null)
								caHUDShader.setFloat('amount', tween.value);
						},
						onComplete: function(tween:FlxTween)
						{
							if (caGameShader != null)
								caGameShader.amount = theAmount;

							if (caHUDShader != null)
								caHUDShader.setFloat('amount', theAmount);

							setChromActive = (theAmount != 0);
						}
					}
				);
			}
			else
			{
				setChromActive = false;
			}

		case 'chromToggle':
			var theAmount:Float = Std.parseFloat(value1 ?? 0);
			var theAmount2:Int = Std.int(value2 ?? (theAmount > 0 ? 1 : 0));

			if (showDevInfo)
				trace([theAmount, theAmount2]);

			if (chromTween != null)
				chromTween.cancel();

			setChromActive = false;

			if (theAmount > 0)
			{
				isChrom = true;
				chromAmount = theAmount;
				chromFreq = theAmount2;
				return;
			}
			else
			{
				isChrom = false;
				chromAmount = 0;

				if (caGameShader != null)
					caGameShader.amount = 0;

				if (caHUDShader != null)
					caHUDShader.setFloat('amount', 0);

				return;
			}

		case 'Lights out':
			if (value1 == '2' || (value1 == '1' && !ClientPrefs.flashing))
				return;

			if (ClientPrefs.shaders)
			{
				isDark = true;
				isChrom = false;
				setChromActive = false;

				if (chromTween != null)
					chromTween.cancel();

				if (caGameShader != null)
					caGameShader.amount = 0;

				if (caHUDShader != null)
					caHUDShader.setFloat('amount', 0);

				camGame.flash(
					ClientPrefs.flashing ? FlxColor.WHITE : FlxColor.BLACK,
					0.35
				);

				gf.alpha = 0.001;
				pet.alpha = 0.001;
				bg.alpha = 0.001;
				thebackground.alpha = 0.001;
				crowd.alpha = 0.001;
				bfdead.alpha = 0.001;
				grayfg.alpha = 0.001;
				lightadd.alpha = 0.001;
				lightsubtract.alpha = 0.001;
				defeat.alpha = 0.001;
				defeatPurple.alpha = 0.001;
				mist.alpha = 0.001;
				noob69Exe.alpha = 0.001;

				brown.alpha = 0.001;
				red.alpha = 0.001;
				yellow.alpha = 0.001;
				blue.alpha = 0.001;

				playHUD.iconP1.shader = hudDarkShader;
				playHUD.iconP2.shader = hudDarkShader;

				dad.shader = grayShader;

				playHUD.healthBar.bg.setColorTransform(
					0, 0, 0, 1,
					224, 224, 224
				);

				var dark:Null<String> = boyfriend.getFlag('variants')?.dark;

				if (dark != null)
				{
					changeCharacter(dark, 0);
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
			if (value1 == '1' && !ClientPrefs.flashing)
				return;

			if (ClientPrefs.shaders)
			{
				isDark = false;
				setChromActive = false;

				if (chromTween != null)
					chromTween.cancel();

				if (caGameShader != null)
					caGameShader.amount = 0;

				if (caHUDShader != null)
					caHUDShader.setFloat('amount', 0);

				gf.alpha = 1;
				pet.alpha = 1;
				bg.alpha = 1;
				thebackground.alpha = 1;
				crowd.alpha = 1;

				if (boyfriend.curCharacter == "bfghost")
					bfdead.alpha = 1;
				else
					bfdead.alpha = 0;

				grayfg.alpha = 1;
				lightadd.alpha = 1;
				lightsubtract.alpha = 1;
				defeat.alpha = 0.55;
				defeatPurple.alpha = 0.35;

				if (purpleMode)
				{
					mist.alpha = 0.65;
					noob69Exe.alpha = 0;
				}
				else
				{
					mist.alpha = 0;
					noob69Exe.alpha = 0.5;
				}

				brown.alpha = 0.22;
				red.alpha = 0.22;
				yellow.alpha = 0.22;
				blue.alpha = 0.22;

				playHUD.iconP1.shader = null;
				playHUD.iconP2.shader = null;

				camGame.flash(FlxColor.BLACK, 0.35);

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

				if (noobRim != null && !purpleMode)
					noob69Exe.shader = noobRim;

				if (grayfgRim != null)
					grayfg.shader = grayfgRim;

				if (gfGhostRim != null)
					gfGhost.shader = gfGhostRim;

				if (bfdeadRim != null)
					bfdead.shader = bfdeadRim;
			}
	}
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
