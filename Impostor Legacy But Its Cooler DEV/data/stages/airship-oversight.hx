import StringTools;
import funkin.game.shaders.ExtraDropShadowShader;

/*

VARIABLES

*/

var skySprites:Array<FlxSprite> = [];
var cloudSprites:Array<FlxSprite> = [];
var stageSprites:Array<FlxSprite> = [];

public var whiteAwkward:FlxSprite;

var henryTeleporter:FlxSprite;
var noticeYellow:Character;

var extraZoom:Float = 0;

var teleporter_songs:Array<String> = ['Mando', "D'low"];
var yellowdied:Array<String> = ['Oversight'];

public var you_can_press_the_teleporter:Bool = true;

var has_teleporter:Bool = false;
var teleporting:Bool = false;
var isyellowdead:Bool = false;

var ext:String = 'stages/airship/mando/';

var flashers:Array<FlxSprite>;

public var deadbody:FlxSprite;

var glow:FlxSprite;

/*

RIM LIGHT

*/

var bfRim:ExtraDropShadowShader = new ExtraDropShadowShader();
var petRim:ExtraDropShadowShader = new ExtraDropShadowShader();
var gfRim:ExtraDropShadowShader = new ExtraDropShadowShader();
var dadRim:ExtraDropShadowShader = new ExtraDropShadowShader();
var deadbodyRim:ExtraDropShadowShader = new ExtraDropShadowShader();

var drops:Array<ExtraDropShadowShader> = [
bfRim,
petRim,
gfRim,
dadRim,
deadbodyRim
];

var rimEnabled:Bool = false;

/*

CLOUDS

*/

var cloudStartX:Array<Float> = [];
var cloudSpeeds:Array<Float> = [];

/*

THUNDER

*/

var thunderTimer:Float = 0;

var lightningDarken:Array<FlxSprite> = [];
var lightningLighten:Array<FlxSprite> = [];

public var nextThunder:Int = 8;
public var canThunder:Bool = true;

var skyColorPlaceholder:FlxSprite;

var isThundering:Bool = false;

var lightningLightenBaseColors:Array<Int> = [];
var lightningDarkenBaseColors:Array<Int> = [];

/*

STAGE ELEMENTS

*/

var element0:FlxSprite;
var element1:FlxSprite;
var element2:FlxSprite;
var element4:FlxSprite;
var element5:FlxSprite;
var element6:FlxSprite;
var element7:FlxSprite;
var element8:FlxSprite;
var element9:FlxSprite;
var element10:FlxSprite;
var element11:FlxSprite;

/*

MISC

*/

var targetColor:Int;

var rim:ExtraDropShadowShader;

var songLower:String;
var dt:Float;
var startX:Float;

var dadAnim:String;
var shesDead:Bool;

var b:Float;
var w:Float;

var endSongStarted:Bool = false;
var hasDarkened:Bool = false;

var thunder:FlxSprite;
var thunder1:FlxSprite;
var thunder2:FlxSprite;

var thunders:Array<FlxSprite> = [
thunder,
thunder1,
thunder2
];

var thunderTween:FlxTween;

/*

LOAD

*/

function onLoad()
{
has_teleporter =
teleporter_songs.contains(songName) &&
PlayState.isStoryMode;

isyellowdead = yellowdied.contains(songName);  

element8 = new FlxSprite(  
	-1468,  
	-995  
).loadGraphic(  
	Paths.image(  
		ext + 'fartingSky slightly dark'  
	)  
);  

element8.scrollFactor.set(  
	0.3,  
	0.3  
);  

element8.color = 0xFF1F1D36;  


element11 = new FlxSprite(  
	130,  
	350  
).loadGraphic(  
	Paths.image(  
		ext + 'yellow cloud 3 dark'  
	)  
);  

element11.scrollFactor.set(  
	0.5,  
	0.8  
);  

element11.color = 0xFF292929;  

stageSprites.push(element11);  

cloudSprites.push(element11);  
cloudStartX.push(element11.x);  
cloudSpeeds.push(17.5);  


element5 = new FlxSprite(  
	-1125,  
	284  
).loadGraphic(  
	Paths.image(  
		ext + 'backSkyyellow dark'  
	)  
);  

element5.scrollFactor.set(  
	0.4,  
	0.7  
);  

element5.color = 0xFF2C2C2C;  


element6 = new FlxSprite(  
	1330,  
	283  
).loadGraphic(  
	Paths.image(  
		ext + 'yellow cloud 3 dark'  
	)  
);  

element6.scrollFactor.set(  
	0.5,  
	0.8  
);  

element6.color = 0xFF2E2E2E;  

stageSprites.push(element6);  

cloudSprites.push(element6);  
cloudStartX.push(element6.x);  
cloudSpeeds.push(20);  


element7 = new FlxSprite(  
	-837,  
	304  
).loadGraphic(  
	Paths.image(  
		ext + 'yellow cloud 2 dark'  
	)  
);  

element7.scrollFactor.set(  
	0.6,  
	0.9  
);  

element7.color = 0xFF2C2C2C;  

stageSprites.push(element7);  

cloudSprites.push(element7);  
cloudStartX.push(element7.x);  
cloudSpeeds.push(15);  


element10 = new FlxSprite(  
	41,  
	242  
).loadGraphic(  
	Paths.image(  
		ext + 'cloudYellow 1 dark'  
	)  
);  

element10.scrollFactor.set(  
	0.8,  
	0.8  
);  

element10.color = 0xFF5F5F5F;  

cloudSprites.push(element10);  
cloudStartX.push(element10.x);  
cloudSpeeds.push(5.5);  


element4 = new FlxSprite(  
	-1541,  
	242  
).loadGraphic(  
	Paths.image(  
		ext + 'cloudYellow 1 slightly dark'  
	)  
);  

element4.scrollFactor.set(  
	0.8,  
	0.8  
);  

element4.color = 0xFF383838;  

stageSprites.push(element4);  

cloudSprites.push(element4);  
cloudStartX.push(element4.x);  
cloudSpeeds.push(5);  


element2 = new FlxSprite(  
	-1387,  
	-1231  
).loadGraphic(  
	Paths.image(  
		ext + 'window'  
	)  
);  

stageSprites.push(element2);  


element1 = new FlxSprite(  
	-642,  
	325  
).loadGraphic(  
	Paths.image(  
		ext + 'backDlowFloor'  
	)  
);  

element1.scrollFactor.set(  
	0.9,  
	1  
);  


element0 = new FlxSprite(  
	-2440,  
	336  
).loadGraphic(  
	Paths.image(  
		ext + 'DlowFloor'  
	)  
);  


element9 = new FlxSprite(  
	-568,  
	-895  
).loadGraphic(  
	Paths.image(  
		ext + 'airshiplight'  
	)  
);  

element9.scrollFactor.set(  
	0.9,  
	1  
);  

element9.alpha = 1;  
element9.visible = true;  

stageSprites.push(element9);

/*

THUNDER SPRITES

*/

thunder = new FlxSprite(  
	-514.75,  
	-373.05  
).loadGraphic(  
	Paths.image(  
		'stages/airship/danger/thunder'  
	)  
);  

thunder.scrollFactor.set(  
	1,  
	1  
);  

thunder.scale.set(  
	2,  
	2  
);  

thunder.updateHitbox();  
thunder.alpha = 0;  


thunder1 = new FlxSprite(  
	-514.75,  
	-500.05  
).loadGraphic(  
	Paths.image(  
		'stages/mira/reactorRuined/thunder1'  
	)  
);  

thunder1.scrollFactor.set(  
	1,  
	1  
);  

thunder1.updateHitbox();  
thunder1.alpha = 0;  


thunder2 = new FlxSprite(  
	-514.75,  
	-373.05  
).loadGraphic(  
	Paths.image(  
		'stages/mira/reactorRuined/thunder2'  
	)  
);  

thunder2.scrollFactor.set(  
	1,  
	1  
);  

thunder2.updateHitbox();  
thunder2.alpha = 0;  

thunders = [  
	thunder,  
	thunder1,  
	thunder2  
];

/*

STAGE COLORS

*/

for (sprite in stageSprites)  
{  
	targetColor = 0xFF222537;  

	FlxTween.color(  
		sprite,  
		120,  
		sprite.color,  
		targetColor  
	);  
}

/*

ADD STAGE

*/

for (item in [  
	element8,  
	element5,  
	element6,  
	thunder,  
	thunder1,  
	thunder2,  
	element11,  
	element10,  
	element7,  
	element2,  
	element4,  
	element1,  
	element0  
])  
{  
	item.scale.set(  
		2,  
		2  
	);  

	item.updateHitbox();  

	stageSprites.push(item);  

	add(item);  
}

/*

WHITE

*/

whiteAwkward = new FlxSprite(  
	298,  
	550  
);  

whiteAwkward.frames =  
	Paths.getSparrowAtlas(  
		ext + 'white_awkward'  
	);  

whiteAwkward.animation.addByPrefix(  
	'sweat',  
	'fetal position',  
	6,  
	true  
);  

whiteAwkward.animation.addByPrefix(  
	'stare',  
	'white stare',  
	24,  
	false  
);  

whiteAwkward.animation.play(  
	'sweat'  
);  

whiteAwkward.color = 0xFFF1F1F1;  

whiteAwkward.visible =  
	!isyellowdead;  

add(whiteAwkward);

/*

TELEPORTER

*/

henryTeleporter = new FlxSprite(  
	998,  
	620  
).loadGraphic(  
	Paths.image(  
		ext + 'Teleporter'  
	)  
);  

henryTeleporter.visible =  
	has_teleporter;  

add(henryTeleporter);

/*

DEAD BODY

*/

deadbody = new FlxSprite(  
	-400,  
	620  
).loadGraphic(  
	Paths.image(  
		ext + 'YELLOW'  
	)  
);  

deadbody.visible =  
	isyellowdead;  

add(deadbody);

/*

SKY

*/

skySprites.push(element6);  
skySprites.push(element11);  
skySprites.push(element7);  
skySprites.push(element4);  
skySprites.push(element10);  

skyColorPlaceholder =  
	new FlxSprite();  

skyColorPlaceholder.color =  
	skySprites[0].color;

}

/*

RIM TOGGLE

*/

function turnShader(should:Bool = false)
{
if (!ClientPrefs.shaders)
{
boyfriend.shader = null;
gf.shader = null;
dad.shader = null;

if (pet != null)  
		pet.shader = null;  

	if (deadbody != null)  
		deadbody.shader = null;  

	rimEnabled = false;  

	return;  
}  

rimEnabled = should;  

if (!should)  
{  
	boyfriend.shader = null;  
	gf.shader = null;  
	dad.shader = null;  

	if (pet != null)  
		pet.shader = null;  

	if (deadbody != null)  
		deadbody.shader = null;  

	return;  
}  

boyfriend.shader = bfRim;  
gf.shader = gfRim;  
dad.shader = dadRim;  

if (pet != null)  
	pet.shader = petRim;  

if (deadbody != null)  
	deadbody.shader = deadbodyRim;

/*

RIM STARTS INVISIBLE

*/

hideRim();

}

/*

HIDE RIM

*/

function hideRim()
{
if (bfRim != null &&
bfRim.layers.length > 0)
{
bfRim.layers[0].threshold = 1;
}

if (petRim != null &&  
	petRim.layers.length > 0)  
{  
	petRim.layers[0].threshold = 1;  
}  

if (gfRim != null &&  
	gfRim.layers.length > 0)  
{  
	gfRim.layers[0].threshold = 1;  
}  

if (dadRim != null &&  
	dadRim.layers.length > 0)  
{  
	dadRim.layers[0].threshold = 1;  
}  

if (deadbodyRim != null &&  
	deadbodyRim.layers.length > 0)  
{  
	deadbodyRim.layers[0].threshold = 1;  
}

}

/*

SET RIM THRESHOLD

*/

function setRimThreshold(value:Float)
{
if (!rimEnabled)
return;

if (bfRim != null &&  
	bfRim.layers.length > 0)  
{  
	bfRim.layers[0].threshold = value;  
}  

if (petRim != null &&  
	petRim.layers.length > 0)  
{  
	petRim.layers[0].threshold = value;  
}  

if (gfRim != null &&  
	gfRim.layers.length > 0)  
{  
	gfRim.layers[0].threshold = value;  
}  

if (dadRim != null &&  
	dadRim.layers.length > 0)  
{  
	dadRim.layers[0].threshold = value;  
}  

if (deadbodyRim != null &&  
	deadbodyRim.layers.length > 0)  
{  
	deadbodyRim.layers[0].threshold = value;  
}

}

/*

CREATE POST

*/

function onCreatePost()
{
if (has_teleporter)
{
addCharacterToList(
'yellow-teleport',
1
);
}

camSpecialThing(  
	[300, 500],  
	[700, 500],  
	0.6  
);  

boyfriend.color = 0xFFF1F1F1;  
gf.color = 0xFFF1F1F1;  
dad.color = 0xFFF1F1F1;  

applyBFEffect();  
applyGFEffect();  
applyDadEffect();  
applyDeadBodyEffect();

/*

DARKEN LIST

*/

lightningDarken = [  
	element1,  
	element0,  
	element9  
];

/*

LIGHTEN LIST

*/

lightningLighten = [  
	element8,  
	element11,  
	element5,  
	element6,  
	element7,  
	element10,  
	element4,  
	element2  
];

/*

BASE COLORS

*/

lightningLightenBaseColors = [];  

for (sprite in lightningLighten)  
{  
	if (sprite != null)  
	{  
		lightningLightenBaseColors.push(  
			sprite.color  
		);  
	}  
}

/*

INITIAL RIM STATE

*/

turnShader(false);

}

/*

BF RIM

*/

function applyBFEffect()
{
if (!ClientPrefs.shaders ||
boyfriend == null)
{
return;
}

rim = new ExtraDropShadowShader();  

rim.setAdjustColor(  
	-78,  
	-25,  
	-15,  
	-58  
);  

rim.addLayer([  
	0.8, 0, 0, 0, 0,  
	0, 1, 0, 0, 0,  
	0.3, 0, 1, 0, 0,  
	0, 0, 0, 1, 0  
], 90, 35, 0.01, 1, 0.5);  

bfRim = rim;  

bfRim.attachedSprite =  
	boyfriend;  

boyfriend.useRenderTexture =  
	true;

/*

PET RIM

*/

if (hasPet && pet != null)  
{  
	petRim =  
		new ExtraDropShadowShader();  

	petRim.copyFrom(  
		bfRim  
	);  

	petRim.attachedSprite =  
		pet;  

	pet.useRenderTexture =  
		true;  
}

}

/*

GF RIM

*/

function applyGFEffect()
{
if (!ClientPrefs.shaders ||
gf == null)
{
return;
}

gfRim =  
	new ExtraDropShadowShader();  

gfRim.copyFrom(  
	bfRim  
);  

gfRim.attachedSprite =  
	gf;  

gf.useRenderTexture =  
	true;

}

/*

DAD RIM

*/

function applyDadEffect()
{
if (!ClientPrefs.shaders ||
dad == null)
{
return;
}

dadRim =  
	new ExtraDropShadowShader();  

dadRim.copyFrom(  
	bfRim  
);  

dadRim.attachedSprite =  
	dad;  

dad.useRenderTexture =  
	true;

}

/*

DEAD BODY RIM

*/

function applyDeadBodyEffect()
{
if (!ClientPrefs.shaders ||
deadbody == null)
{
return;
}

deadbodyRim =  
	new ExtraDropShadowShader();  

deadbodyRim.setAdjustColor(  
	-78,  
	-25,  
	-15,  
	-58  
);  

deadbodyRim.addLayer([  
	0.8, 0, 0, 0, 0,  
	0, 1, 0, 0, 0,  
	0.3, 0, 1, 0, 0,  
	0, 0, 0, 1, 0  
], 90, 35, 0.01, 1, 0.5);  

deadbodyRim.attachedSprite =  
	deadbody;

}

/*

SONG START

*/

function onSongStart()
{
songLower =
Paths.sanitize(songName);

switch (songLower)  
{  
	case 'mando', 'd\'low':  
		if (gf.getFlag('seeThrough'))  
		{  
			unlockAchievementPopup(  
				'oh_hey_there'  
			);  
		}  

	case 'oversight':  
		if (  
			boyfriend.curCharacter ==  
			'yellowplayable'  
		)  
		{  
			game.unlockAchievementPopup(  
				'revenge'  
			);  
		}  
}  

FlxTween.color(  
	skyColorPlaceholder,  
	120,  
	skyColorPlaceholder.color,  
	0xFF222537,  
	{  
		onUpdate: function(_)  
		{  
			if (!isThundering)  
			{  
				for (sky in skySprites)  
				{  
					sky.color =  
						skyColorPlaceholder.color;  
				}  
			}  
		}  
	}  
);

}

/*

UPDATE

*/

function onUpdate()
{
if (
!game.startingSong &&
!game.endingSong &&
FlxG.mouse.justPressed &&
canPause &&
henryTeleporter.visible &&
you_can_press_the_teleporter &&
FlxG.mouse.overlaps(
henryTeleporter
)
)
{
henryTeleport();
}

if (  
	!hasDarkened &&  
	curStep >= 128  
)  
{  
	darkenStage();  
}  

dt = FlxG.elapsed;  

for (i in 0...cloudSprites.length)  
{  
	var cloud =  
		cloudSprites[i];  

	cloud.x -=  
		cloudSpeeds[i] * dt;  

	startX =  
		cloudStartX[i];  

	if (  
		cloud.x <  
		startX - 2500  
	)  
	{  
		cloud.x =  
			startX + 2000;  
	}  
}  

thunderTimer +=  
	FlxG.elapsed;  

if (thunderTimer >= 4)  
{  
	thunderTimer = 0;  

	if (  
		FlxG.random.int(1, 5) == 1  
	)  
	{  
		var thunderSounds:Array<String> = [  
			'thunder11',  
			'thunder22',  
			'thunder33'  
		];  

		FlxG.sound.play(  
			Paths.sound(  
				thunderSounds[  
					FlxG.random.int(  
						0,  
						thunderSounds.length - 1  
					)  
				]  
			),  
			1  
		);  
	}  
}

}

/*

END SONG

*/

function onEndSong()
{
if (endSongStarted)
return Function_Continue;

endSongStarted = true;  

camZooming = false;  
inCutscene = true;  

FlxG.sound.music.volume = 0;  
vocals.volume = 0;  

FlxTween.tween(  
	FlxG.camera.scroll,  
	{  
		y:  
			FlxG.camera.scroll.y - 800  
	},  
	3.99,  
	{  
		ease:  
			FlxEase.sineInOut  
	}  
);  

FlxTween.tween(  
	camHUD,  
	{  
		alpha: 0  
	},  
	1.2,  
	{  
		ease:  
			FlxEase.quadOut  
	}  
);  

new FlxTimer().start(  
	2,  
	function(_)  
	{  
		FlxG.sound.play(  
			Paths.sound(  
				'thunder44'  
			),  
			1  
		);  
	}  
);  

new FlxTimer().start(  
	6,  
	function(_)  
	{  
		endSongStarted = false;  
		endSongFinished = true;  
	}  
);

}

/*

TELEPORT

*/

function henryTeleport()
{
dadAnim =
dad.animation.curAnim != null
? dad.animation.curAnim.name
: '';

shesDead =  
	isyellowdead ||  
	dadAnim == 'death' ||  
	dad.__prevPlayedAnimation == 'death';  

if (!shesDead)  
{  
	changeCharacter(  
		'yellow-teleport',  
		1  
	);  

	dad.playAnim(  
		'first',  
		true  
	);  

	dad.stunned = true;  
}  

flashers = [  
	boyfriend  
];  

canPause = false;  
inCutscene = true;  
camZooming = false;  
teleporting = true;  

henryTeleporter.visible = false;  

KillNotes();  

audio.playerVolume = 0;  
audio.opponentVolume = 0;  
audio.inst.stop();  

FlxTween.tween(  
	camHUD,  
	{  
		alpha: 0  
	},  
	0.7,  
	{  
		ease:  
			FlxEase.quadInOut  
	}  
);  

FlxG.sound.play(  
	Paths.sound(  
		'stage/teleport_sound'  
	)  
);  

triggerEventNote(  
	'Camera Follow Pos',  
	'750',  
	'500'  
);  

if (!ClientPrefs.flashing)  
{  
	FlxTween.num(  
		0,  
		1,  
		2.8,  
		{  
			ease:  
				FlxEase.expoIn  
		},  
		flash  
	);  
}  

new FlxTimer().start(  
	0.45,  
	function(_)  
	{  
		shaderFlash(  
			0,  
			0.73  
		);  
	}  
);  

new FlxTimer().start(  
	1.28,  
	function(_)  
	{  
		flashers.push(gf);  

		shaderFlash(  
			0.1,  
			0.55  
		);  
	}  
);  

new FlxTimer().start(  
	1.93,  
	function(_)  
	{  
		flashers.push(pet);  

		shaderFlash(  
			0.2,  
			0.2  
		);  

		if (!shesDead)  
		{  
			dad.playAnim(  
				'second',  
				true  
			);  
		}  
	}  
);  

new FlxTimer().start(  
	2.23,  
	function(_)  
	{  
		shaderFlash(  
			0.4,  
			0.22  
		);  
	}  
);  

new FlxTimer().start(  
	2.55,  
	function(_)  
	{  
		shaderFlash(  
			0.8,  
			0.05  
		);  
	}  
);  

new FlxTimer().start(  
	2.7,  
	function(_)  
	{  
		flash(1);  

		FlxTween.tween(  
			boyfriend,  
			{  
				"scale.y": 0  
			},  
			0.7,  
			{  
				ease:  
					FlxEase.expoOut  
			}  
		);  

		FlxTween.tween(  
			boyfriend,  
			{  
				"scale.x": 3.5  
			},  
			0.7,  
			{  
				ease:  
					FlxEase.expoOut  
			}  
		);  
	}  
);  

new FlxTimer().start(  
	2.8,  
	function(_)  
	{  
		FlxTween.tween(  
			gf,  
			{  
				"scale.y": 0  
			},  
			0.7,  
			{  
				ease:  
					FlxEase.expoOut  
			}  
		);  

		FlxTween.tween(  
			gf,  
			{  
				"scale.x": 3.5  
			},  
			0.7,  
			{  
				ease:  
					FlxEase.expoOut  
			}  
		);  
	}  
);  

new FlxTimer().start(  
	2.75,  
	function(_)  
	{  
		FlxTween.tween(  
			pet,  
			{  
				"scale.y": 0  
			},  
			0.7,  
			{  
				ease:  
					FlxEase.expoOut  
			}  
		);  

		FlxTween.tween(  
			pet,  
			{  
				"scale.x": 3.5  
			},  
			0.7,  
			{  
				ease:  
					FlxEase.expoOut  
			}  
		);  
	}  
);  

new FlxTimer().start(  
	2.9,  
	function(_)  
	{  
		if (!shesDead)  
		{  
			whiteAwkward.setPosition(  
				298,  
				476  
			);  

			whiteAwkward.animation.play(  
				'stare'  
			);  

			dad.playAnim(  
				'third',  
				true  
			);  
		}  
	}  
);  

new FlxTimer().start(  
	4.5,  
	function(_)  
	{  
		FlxG.camera.fade(  
			FlxColor.BLACK,  
			1.4,  
			false,  
			function()  
			{  
				FlxG.switchState(  
					() -> new funkin.states.HenryState()  
				);  
			},  
			true  
		);  
	}  
);

}

/*

BEAT

*/

function onBeatHit()
{
if (
canThunder &&
nextThunder >= 0 &&
curBeat >= nextThunder
)
{
thunderfunc();
}
}

/*

DARKEN

*/

function darkenStage()
{
if (hasDarkened)
return;

hasDarkened = true;

/*

ACTIVATE RIM

*/

turnShader(true);  

hideRim();

/*

STAGE DARKEN

*/

element0.color =  
	0xFF474747;  

element1.color =  
	0xFF474747;

/*

WHITE

*/

whiteAwkward.color =  
	0xFF474747;

/*

DEAD BODY

*/

/*
DELIBERADAMENTE NÃO ALTERAMOS
A COR DO DEAD BODY AQUI.
*/

element9.alpha = 0;  

element11.color =  
	0xFF202020;  

element10.color =  
	0xFF202020;  

element6.color =  
	0xFF202020;  

element7.color =  
	0xFF202020;  

element5.color =  
	0xFF202020;  

element4.color =  
	0xFF202020;

/*

DARKEN BASE COLORS

*/

lightningDarkenBaseColors = [];  

for (sprite in lightningDarken)  
{  
	if (sprite != null)  
	{  
		lightningDarkenBaseColors.push(  
			sprite.color  
		);  
	}  
}

/*

RIM STAYS HIDDEN

*/

hideRim();

}

/*

STEP

*/

function onStepHit()
{
if (
!hasDarkened &&
curStep >= 128
)
{
darkenStage();
}

if (curStep == 128)  
{

/*

FLASH

*/

FlxG.camera.flash(  
		FlxColor.WHITE,  
		0.2  
	);

/*

CAMERA ZOOM

*/

var oldZoom:Float =  
		FlxG.camera.zoom;  

	FlxG.camera.zoom =  
		oldZoom * 1.08;  

	FlxTween.tween(  
		FlxG.camera,  
		{  
			zoom: oldZoom  
		},  
		0.45,  
		{  
			ease: FlxEase.quadOut  
		}  
	);

/*

SOUND

*/

FlxG.sound.play(  
		Paths.sound(  
			'AHHFREDDY'  
		)  
	);  
}

}

/*

THUNDER

*/

function thunderfunc():Void
{
nextThunder = -1;

if (thunderTween != null)  
{  
	thunderTween.cancel();  
}  

var theThunder =  
	thunders[  
		FlxG.random.int(  
			0,  
			2  
		)  
	];  

theThunder.flipX =  
	FlxG.random.bool(50);  

theThunder.alpha = 0;

/*

THUNDER POSITION

*/

var thunderPositions:Array<Float> = [  
	-200,  
	100,  
	400,  
	700  
];  

theThunder.x =  
	thunderPositions[  
		FlxG.random.int(  
			0,  
			thunderPositions.length - 1  
		)  
	];

/*

THUNDER SPRITE

*/

FlxTween.tween(  
	theThunder,  
	{  
		alpha:  
			FlxG.random.float(  
				0.5,  
				1  
			)  
	},  
	0.1,  
	{  
		ease:  
			FlxEase.sineIn,  

		onComplete: function(_)  
		{  
			thunderTween =  
				FlxTween.tween(  
					theThunder,  
					{  
						alpha: 0  
					},  
					FlxG.random.float(  
						1.5,  
						2.2  
					),  
					{  
						ease:  
							FlxEase.sineIn,  

						onComplete:  
							function(_)  
						{  
						}  
					}  
				);  
		}  
	}  
);

/*

THUNDER SOUND

*/

new FlxTimer().start(  
		FlxG.random.float(  
			0.1,  
			2  
		),  
		function(_)  
		{  
			var soundNumber:Int =  
				FlxG.random.int(  
					1,  
					3  
				);  
  
			FlxG.sound.play(  
				Paths.sound(  
					'stage/dtThunder' +  
					soundNumber  
				),  
				FlxG.random.float(  
					0.7,  
					1  
				)  
			);  
		}  
	);  
  
	isThundering = true;  
  
  
/*  
====================================================  
LIGHTNING IN  
====================================================  
*/  
  
	var flashDuration:Float =  
		0.5;  
  
	var flashEndDuration:Float =  
		FlxG.random.float(  
			0.7,  
			1.2  
		);  
  
	var flashStart:Float =  
		FlxG.random.float(  
			0.5,  
			0.7  
		);  
  
	FlxTween.num(  
		0,  
		flashStart,  
		flashDuration,  
		{  
			ease:  
				FlxEase.elasticInOut  
		},  
		function(intensity:Float)  
		{  
			lightningStuff(  
				intensity  
			);  
		}  
	);  
  
  
/*  
====================================================  
LIGHTNING OUT  
====================================================  
*/  
  
	new FlxTimer().start(  
		flashDuration,  
		function(_)  
		{  
			FlxTween.num(  
				flashStart,  
				0,  
				flashEndDuration,  
				{  
					ease:  
						FlxEase.sineIn,  
  
					onComplete:  
						function(_)  
					{  
						isThundering =  
							false;  
  
						hideRim();  
  
						setNextThunder();  
					}  
				},  
				function(intensity:Float)  
				{  
					lightningStuff(  
						intensity  
					);  
				}  
			);  
		}  
	);  
}  
  
  
/*  
====================================================  
LIGHTNING  
====================================================  
*/  
  
function lightningStuff(  
	intensity:Float  
):Void  
{  
	var c:FlxColor =  
		FlxColor.interpolate(  
			FlxColor.WHITE,  
			FlxColor.BLACK,  
			(  
				1 -  
				Math.pow(  
					1 - intensity,  
					2  
				)  
			) * 0.8  
		);  
  
  
/*  
====================================================  
DARKEN  
====================================================  
*/  
  
	for (  
		i in 0...lightningDarken.length  
	)  
	{  
		var sprite =  
			lightningDarken[i];  
  
		if (  
			sprite == null ||  
			!sprite.exists  
		)  
		{  
			continue;  
		}  
  
		if (hasDarkened)  
		{  
			var baseColor:Int =  
				lightningDarkenBaseColors[i];  
  
			var c2:FlxColor =  
				FlxColor.interpolate(  
					baseColor,  
					FlxColor.BLACK,  
					(  
						1 -  
						Math.pow(  
							1 - intensity,  
							2  
						)  
					) * 0.8  
				);  
  
			sprite.color = c2;  
		}  
		else  
		{  
			sprite.color = c;  
		}  
	}  
  
  
/*  
====================================================  
LIGHTEN  
====================================================  
*/  
  
	for (  
		i in 0...lightningLighten.length  
	)  
	{  
		var sprite =  
			lightningLighten[i];  
  
		if (  
			sprite == null ||  
			!sprite.exists  
		)  
		{  
			continue;  
		}  
  
		var baseColor:Int =  
			lightningLightenBaseColors[i];  
  
		sprite.color =  
			FlxColor.interpolate(  
				baseColor,  
				FlxColor.WHITE,  
				intensity * 0.75  
			);  
	}  
  
  
/*  
====================================================  
RIM FLASH  
====================================================  
*/  
  
	if (  
		rimEnabled &&  
		hasDarkened  
	)  
	{  
		var threshold:Float =  
			Math.pow(  
				1 - intensity,  
				3  
			);  
  
		setRimThreshold(  
			threshold  
		);  
	}  
}  
  
  
/*  
====================================================  
NEXT THUNDER  
====================================================  
*/  
  
function setNextThunder():Void  
{  
	nextThunder =  
		(  
			Math.ceil(  
				(  
					curBeat +  
					FlxG.random.int(  
						32,  
						48  
					)  
				) / 2  
			) * 2  
		);  
}  