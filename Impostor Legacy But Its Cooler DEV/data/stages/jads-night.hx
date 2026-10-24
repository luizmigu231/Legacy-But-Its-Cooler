import funkin.data.ClientPrefs;							// thanks demonino and lumi :3
import flixel.tweens.FlxEase;
import flixel.addons.display.FlxRuntimeShader;

var bfRim:DropShadowShader;
var dadRim:DropShadowShader;
var petRim:DropShadowShader;
var bars:FlxSpriteGroup;

var bg:FlxSprite;
var fans:FlxSprite;
var piss:FlxSprite;
var bg2:FlxSprite;
var fans2:FlxSprite;
var piss2:FlxSprite;
var white:FlxSprite;

var ext:String = 'stages/skeld/jads-dark/';

function onLoad()
{
	bars = new FlxSpriteGroup();
	bars.cameras = [camHUD];
    bars.alpha = 0;
	add(bars);
	
	for (i in 0...2)
	{
		var bar = new FlxSprite().makeGraphic(FlxG.width + 3, 90, FlxColor.BLACK);
		bar.y = i == 1 ? 630 : 0;
		bars.add(bar);
	}

	bg = new FlxSprite(-595, -195).loadGraphic(Paths.image(ext + 'O2Background'));
	bg2 = new FlxSprite(-595, -195).loadGraphic(Paths.image(ext + 'O2Backgroundstar'));
	bg2.alpha = 0;

	
	fans = new FlxSprite(-166.25, 68.45);
	fans.frames = Paths.getSparrowAtlas(ext + 'fansss');
	fans.animation.addByPrefix('bop', 'fansss instance 1', 24, true);
	fans.animation.play('bop');

	fans2 = new FlxSprite(-166.25, 68.45);
	fans2.frames = Paths.getSparrowAtlas(ext + 'fansssstar');
	fans2.animation.addByPrefix('bop', 'fansss instance 1', 24, true);
	fans2.animation.play('bop');
	fans2.alpha = 0;
	
	piss = new FlxSprite(-453.9, 310.2).loadGraphic(Paths.image(ext + 'switch'));
	piss2 = new FlxSprite(-453.9, 310.2).loadGraphic(Paths.image(ext + 'switchstar'));
	piss2.alpha = 0;

	white = new FlxSprite(-595, -195).loadGraphic(Paths.image(ext + 'white'));
	white.alpha = 0;

	add(bg);
	add(fans);
	add(piss);
	add(bg2);
	add(fans2);
	add(piss2);
	add(white);	
}

function onCreatePost()
{
	camSpecialThing([600, 440], [1150, 440]);

	applyBFEffect();
	applyDadEffect();

	//iconP1.color = 0xFF8038A3;

	if (!ClientPrefs.shaders)
	{
		dad.color = 0xFF8038A3;
		boyfriend.color = 0xFF8038A3;
		pet.color = 0xFF8038A3;
	}
}

function onSongStart() onStepHit(); // fuk you
public var woo_party:Int = 0;
function onEndSong() woo_party = 0;

function onStepHit()
{
	modchart(curStep);		
}

function bump(game:Float, hud:Float)
{
	if (!ClientPrefs.camZooms) return;
	
	camGame.zoom += game;
	camHUD.zoom += hud;
}

function applyBFEffect()
{
	if (ClientPrefs.shaders)
	{
		var blackRimlightBase:ExtraDropShadowShader = new funkin.game.shaders.ExtraDropShadowShader();
		
		blackRimlightBase.threshold = .05;
		blackRimlightBase.strength = .85;
		blackRimlightBase.setColorMatrix([
			.4, .5, -.2, 0, -50,
			-.25, .7, -.15, 0, -20,
			.42, -.35, .85, 0, -72,
			0, 0, 0, 1, 0
		]);
		blackRimlightBase.addLayer([
			-.1, .15, .3, 0, 60,
			.25, .35, -.4, 0, 50,
			.55, .4, .8, 0, 150,
			0, 0, 0, 1, 0
		], 10, 14, .01);
		
		if (boyfriend.getFlag('backlit') != true)
		{
			bfRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(blackRimlightBase);
			bfRim.attachedSprite = boyfriend;
			boyfriend.useRenderTexture = true;
		}
		
		if (hasPet)
		{
			petRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(blackRimlightBase);
			petRim.attachedSprite = pet;
			pet.useRenderTexture = true;
		}
	}
}

function applyDadEffect()
{
	if (ClientPrefs.shaders)
	{
		var blackRimlightBase:ExtraDropShadowShader = new funkin.game.shaders.ExtraDropShadowShader();
		
		blackRimlightBase.threshold = .05;
		blackRimlightBase.strength = .85;
		blackRimlightBase.setColorMatrix([
			.4, .5, -.2, 0, -50,
			-.25, .7, -.15, 0, -20,
			.42, -.35, .85, 0, -72,
			0, 0, 0, 1, 0
		]);
		blackRimlightBase.addLayer([
			-.1, .15, .3, 0, 60,
			.25, .35, -.4, 0, 50,
			.55, .4, .8, 0, 150,
			0, 0, 0, 1, 0
		], 10, 14, .01);

		if (boyfriend.getFlag('backlit') != true)
		{
			dadRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(blackRimlightBase);
			dadRim.attachedSprite = dad;
			dad.useRenderTexture = true;
		}
	}
}