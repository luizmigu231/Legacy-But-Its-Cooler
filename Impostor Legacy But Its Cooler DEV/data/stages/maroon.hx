import StringTools;
import funkin.game.shaders.ExtraDropShadowShader;
import funkin.objects.SnowEmitter;
var bfRim:ExtraDropShadowShader;
var gfRim:ExtraDropShadowShader;
var snowAlpha = 0.3;
var snowEmitter:SnowEmitter;
var ext:String = 'stages/polus/maroon/';

function createRim(angleX:Float, angleY:Float):ExtraDropShadowShader
{
	var rim = new ExtraDropShadowShader();

	rim.threshold = 0.05;
	rim.strength = 0.85;

	rim.setColorMatrix([
    0.70, 0.10,  0.00, 0, -5,
    0.00, 0.70, -0.25, 0,  0,
    0.00,-0.15, 0.75, 0, -1,
    0.00, 0.80, 0.00, 1,  0
]);

	// Halo
	rim.addLayer([
       8, 18,  0, -1,   0,
     0.3, 2.5, -1.5, 0, 85,
       0, -1.5, -5.5, 0, -5,
       0,  9,   0,  9,  0
], angleX + 86, angleY + 10, 0.08, 0.30);

	return rim;
}

function createRim2(angleX:Float, angleY:Float):ExtraDropShadowShader
{
	var rim = new ExtraDropShadowShader();

	rim.threshold = 0.05;
	rim.strength = 0.85;

	rim.setColorMatrix([
    0.70, 0.10,  0.00, 0, -5,
    0.00, 0.70, -0.25, 0,  0,
    0.00,-0.15, 0.75, 0, -1,
    0.00, 0.80, 0.00, 1,  0
]);

	// Halo
rim.addLayer([
       8, 18,  0, -1,   0,
     0.3, 2.5, -1.5, 0, 85,
       0, -1.5, -5.5, 0, -5,
       0,  9,   0,  9,  0
], angleX + 86, angleY + 10, 0.08, 0.40);

	return rim;
}

function onLoad()
{
	var bg:FlxSprite = new FlxSprite(-200).loadGraphic(Paths.image(ext + "newsky"));
bg.scrollFactor.x = 0.7;
bg.scale.set(0.75, 0.75);
bg.color = 0xFF5C6E91;
add(bg);

var cloud:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image(ext + "newcloud"));
cloud.scrollFactor.x = 0.9;
cloud.alpha = 0.9;
cloud.color = 0xFF7488A8;
add(cloud);

var rocks:FlxSprite = new FlxSprite().loadGraphic(Paths.image(ext + "newrocks"));
rocks.alpha = 0.49;
rocks.color = 0xFF4F5E7C;
add(rocks);

var backwall:FlxSprite = new FlxSprite().loadGraphic(Paths.image(ext + "backwall"));
backwall.scrollFactor.x = 0.9;
backwall.color = 0xFF566885;
add(backwall);

var ground:FlxSprite = new FlxSprite().loadGraphic(Paths.image(ext + "newstage"));
ground.color = 0xFF5A6C8A;
add(ground);
	
	snowEmitter = new SnowEmitter(1000, 800, 2700);
snowEmitter.start(false, ClientPrefs.lowQuality ? 0.1 : 0.04);
snowEmitter.scrollFactor.x.set(1, 1.5);
snowEmitter.scrollFactor.y.set(1, 1.5);
add(snowEmitter);
snowEmitter.alpha.active = false;
snowEmitter.onEmit.add((particle) ->
{
	particle.alpha = snowAlpha;
	particle.color = 0xFFFFF2EA;
});
snowEmitter.zIndex = 13;
snowEmitter.speed.set(1000, 1500);
	
var lava:FlxSprite = new FlxSprite().loadGraphic(Paths.image(ext + "newlava"));
lava.blend = BlendMode.ADD;
lava.color = 0xFFFFF2EA;
add(lava);
	
	for (i in [bg, cloud, rocks, backwall, ground, lava])
	{
		i.scale.set(0.75, 0.75);
	}
}

function goodNoteHit(note)
{
	if (note.noteType == 'Hey!')
	{
		game.boyfriend.playAnim('hey', true);
		game.boyfriend.specialAnim = true;
	}
}

function opponentNoteHit(note)
{
	game.defaultCamZoom = 0.7;
}

function onCreatePost()
{
	if (hasBfSkin && game.boyfriend.curCharacter == 'bfpolus')
	{
		triggerEventNote('Change Character', 'boyfriend', 'bfpolusblow');
	}

	camSpecialThing([1600, 1300], [1800, 1300]);

	boyfriend.color = 0xFF8A9BC0;
    gf.color = 0xFF8A9BC0;
    dad.color = 0xFF8A9BC0;
    pet.color = 0xFF8A9BC0;

	// ==========================
	// RIM LIGHT
	// ==========================
	
	if (ClientPrefs.shaders)
	{
		boyfriend.useRenderTexture = true;
		
		if (boyfriend.flipX)
    bfRim = createRim(320, 6); // invert
	else
    bfRim = createRim(380, 6); // normal
    
		bfRim.attachedSprite = boyfriend;
		boyfriend.shader = bfRim;

		if (hasPet)
{
    pet.useRenderTexture = true;
    petRim = createRim(380, 6);
    petRim.attachedSprite = pet;
    pet.shader = petRim;
}

    gf.useRenderTexture = true;
    gfRim = createRim2(180, -28);
    gfRim.attachedSprite = gf;
    gf.shader = gfRim;

    dad.useRenderTexture = true;
    dadRim = createRim(320, 6);
    dadRim.attachedSprite = dad;
    dad.shader = dadRim;
}

	// ==========================
	// Overlay
	// ==========================
	var mainoverlay:FlxSprite = new FlxSprite(0, 0);
	mainoverlay.loadGraphic(Paths.image(ext + "newoverlay"));
	mainoverlay.scrollFactor.set(1, 1);
	mainoverlay.scale.set(0.75, 0.75);
	mainoverlay.alpha = 0.60;
	mainoverlay.blend = 0;

	if (!ClientPrefs.lowQuality)
		add(mainoverlay);
}
