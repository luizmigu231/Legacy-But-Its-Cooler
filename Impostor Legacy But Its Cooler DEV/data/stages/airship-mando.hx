var stageSprites:Array<FlxSprite> = [];
import StringTools;
var cloudSprites:Array<FlxSprite> = [];
public var whiteAwkward:FlxSprite;
var henryTeleporter:FlxSprite;
var noticeYellow:Character;
var extraZoom:Float = 0;
var teleporter_songs:Array = ['Mando', "D'low"]; // coding it here because who gaf
var yellowdied:Array = ['Oversight'];
public var you_can_press_the_teleporter:Bool = true;
var has_teleporter:Bool = false;
var teleporting:Bool = false;
var isyellowdead:Bool = false;
var ext = 'stages/airship/mando/';
var flashers:Array<FlxSprite>;
public var deadbody:FlxSprite;
var element4:FlxBackdrop;
var element6:FlxBackdrop;
var element7:FlxBackdrop;
var element8:FlxSprite;
var bouncing:Bool = false;
var bouncingFreq:Float = 4;
var cloudSpeed1:Float = 0;
var cloudSpeed2:Float = 0;
var cloudSpeed3:Float = 0;

function onLoad()
{
        cloudSpeed1 = FlxG.random.float(1, 10);
        cloudSpeed2 = FlxG.random.float(1, 10);
        cloudSpeed3 = FlxG.random.float(1, 10);

	has_teleporter = teleporter_songs.contains(songName) && PlayState.isStoryMode;
	isyellowdead = yellowdied.contains(songName);
	
	var element8 = new FlxSprite(-1468, -995).loadGraphic(Paths.image(ext + 'fartingSky'));
	element8.scrollFactor.set(0.3, 0.3);
	
	var element5 = new FlxSprite(-1125, 284).loadGraphic(Paths.image(ext + 'backSkyyellow'));
	element5.scrollFactor.set(0.4, 0.7);

	element6 = new FlxBackdrop(Paths.image(ext + 'yellow cloud 3'), FlxAxes.X);
        element6.setPosition(1330, 283);
	element6.scrollFactor.set(0.5, 0.8);
	cloudSprites.push(element6);
	stageSprites.push(element6);

	element7 = new FlxBackdrop(Paths.image(ext + 'yellow could 2'), FlxAxes.X);
        element7.setPosition(-837, 304);
	element7.scrollFactor.set(0.6, 0.9);
	cloudSprites.push(element7);
	stageSprites.push(element7);


	element4 = new FlxBackdrop(Paths.image(ext + 'cloudYellow 1'), FlxAxes.X);
        element4.setPosition(-1541, 242);
	element4.scrollFactor.set(0.8, 0.8);
	cloudSprites.push(element4);
	stageSprites.push(element4);


	
	var element2 = new FlxSprite(-1387, -1231).loadGraphic(Paths.image(ext + 'window'));

	var element1 = new FlxSprite(-642, 325).loadGraphic(Paths.image(ext + 'backDlowFloor'));
	element1.scrollFactor.set(0.9, 1);
	var element0 = new FlxSprite(-2440, 336).loadGraphic(Paths.image(ext + 'DlowFloor'));
	var element3 = new FlxSprite(-1113, -1009).loadGraphic(Paths.image(ext + 'glowYellow'));
	element3.blend = BlendMode.ADD;

for (sprite in stageSprites)
{
    var targetColor = 0xFFC5C4C4;

    if (sprite == element4 || sprite == element6 || sprite == element7 || sprite == element8)
        targetColor = 0xFFAAAAAA;

    FlxTween.color(sprite, 110, sprite.color, targetColor);
}

for (item in [element8, element5, element6, element7, element2, element4, element1, element0, element3])
{
    item.scale.set(2, 2);
    item.updateHitbox();

    stageSprites.push(item);

    add(item);
}

	whiteAwkward = new FlxSprite(298, 550);
	whiteAwkward.frames = Paths.getSparrowAtlas(ext + 'white_awkward');
	whiteAwkward.animation.addByPrefix('sweat', 'fetal position', 6, true);
	whiteAwkward.animation.addByPrefix('stare', 'white stare', 24, false);
	whiteAwkward.animation.play('sweat');
	whiteAwkward.visible = !isyellowdead;
	add(whiteAwkward);
	
	henryTeleporter = new FlxSprite(998, 620).loadGraphic(Paths.image(ext + 'Teleporter'));
	henryTeleporter.visible = has_teleporter;
	add(henryTeleporter);
	
	deadbody = new FlxSprite(-400, 620).loadGraphic(Paths.image(ext + 'YELLOW'));
	deadbody.visible = isyellowdead;
	add(deadbody);

	add(element6);
	add(element7);
	add(element4);
	add(element8);
}

function onCreatePost()
{
	if (has_teleporter)
	{
		addCharacterToList('yellow-teleport', 1);
	}
	
	camSpecialThing([300, 500], [700, 500], 0.6);

	boyfriend.color = 0xFFFFFFFF;
	gf.color = 0xFFFFFFFF;
	dad.color = 0xFFFFFFFF;
}

function onSongStart()
{
    var songLower = Paths.sanitize(songName);

    switch (songLower)
    {
        case 'mando', 'd\'low':
            if (gf.getFlag('seeThrough'))
                unlockAchievementPopup('oh_hey_there');

        case 'oversight':
            if (boyfriend.curCharacter == 'yellowplayable')
                game.unlockAchievementPopup('revenge');
    }

    new FlxTimer().start(0.05, function(_)
    {
        for (sprite in stageSprites)
        {
            var targetColor = 0xFFAAAAAA;

            if (sprite == element4 || sprite == element6 || sprite == element7 || sprite == element8)
                targetColor = 0xFF8D8D8D;

            FlxTween.color(sprite, 110, sprite.color, targetColor);
        }

        for (char in [boyfriend, gf, dad, pet])
            FlxTween.color(char, 110, char.color, 0xFFC5C4C4);
    });
}
function onUpdate(elapsed)
{
        element6.x -= cloudSpeed1 * elapsed;
        element7.x += cloudSpeed2 * elapsed;
        element4.x -= cloudSpeed3 * elapsed;

	if (!game.startingSong && !game.endingSong && FlxG.mouse.justPressed && canPause && henryTeleporter.visible && you_can_press_the_teleporter && FlxG.mouse.overlaps(henryTeleporter))
	{
		henryTeleport();
	}
}


function onEndSong()
{
	if (teleporting) return Function_Stop;
}

function onStepHit()
{
    if (bounceFreq == 0 || curStep % bounceFreq != 0) return;

    FlxTween.tween(
        camHUD,
        { y: 30 },
        0.05,
        { ease: FlxEase.quadIn }
    );

    FlxTween.tween(
        camHUD,
        { y: 0 },
        0.15,
        {
            ease: FlxEase.circOut,
            startDelay: 0.10 // 0.15 - 0.05
        }
    );
}

function henryTeleport()
{
	// lets try this one last time
	var dadAnim:String = dad.animation.curAnim != null ? dad.animation.curAnim.name : '';
	var shesDead:Bool = isyellowdead || dadAnim == 'death' || dad.__prevPlayedAnimation == 'death';
	
	if (!shesDead)
	{
		changeCharacter('yellow-teleport', 1);
		dad.playAnim('first', true);
		dad.stunned = true;
	}
	
	flashers = [boyfriend];
	
	canPause = false;
	inCutscene = true;
	camZooming = false;
	teleporting = true;
	henryTeleporter.visible = false;
	
	KillNotes();
	
	audio.playerVolume = 0;
	audio.opponentVolume = 0;
	audio.inst.stop();
	
	FlxTween.tween(camHUD, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
	FlxG.sound.play(Paths.sound('stage/teleport_sound'));
	
	triggerEventNote('Camera Follow Pos', '750', '500');
	
	if (!ClientPrefs.flashing) FlxTween.num(0, 1, 2.8, {ease: FlxEase.expoIn}, flash);
	
	new FlxTimer().start(0.45, function(tmr:FlxTimer) {
		shaderFlash(0, 0.73);
	});
	
	new FlxTimer().start(1.28, function(tmr:FlxTimer) {
		flashers.push(gf);
		shaderFlash(0.1, 0.55);
	});
	
	new FlxTimer().start(1.93, function(tmr:FlxTimer) {
		flashers.push(pet);
		shaderFlash(0.2, 0.2);
		
		if (!shesDead) dad.playAnim('second', true);
	});
	
	new FlxTimer().start(2.23, function(tmr:FlxTimer) {
		shaderFlash(0.4, 0.22);
	});
	new FlxTimer().start(2.55, function(tmr:FlxTimer) {
		shaderFlash(0.8, 0.05);
	});
	
	new FlxTimer().start(2.7, function(tmr:FlxTimer) {
		flash(1);
		
		FlxTween.tween(boyfriend, {"scale.y": 0}, 0.7, {ease: FlxEase.expoOut});
		FlxTween.tween(boyfriend, {"scale.x": 3.5}, 0.7, {ease: FlxEase.expoOut});
	});
	
	new FlxTimer().start(2.8, function(tmr:FlxTimer) {
		FlxTween.tween(gf, {"scale.y": 0}, 0.7, {ease: FlxEase.expoOut});
		FlxTween.tween(gf, {"scale.x": 3.5}, 0.7, {ease: FlxEase.expoOut});
	});
	
	new FlxTimer().start(2.75, function(tmr:FlxTimer) {
		FlxTween.tween(pet, {"scale.y": 0}, 0.7, {ease: FlxEase.expoOut});
		FlxTween.tween(pet, {"scale.x": 3.5}, 0.7, {ease: FlxEase.expoOut});
	});
	
	new FlxTimer().start(2.9, function(tmr:FlxTimer) {
		if (shesDead) {}
		else
		{
			whiteAwkward.setPosition(298, 476);
			whiteAwkward.animation.play('stare');
			dad.playAnim('third', true);
		}
	});
	
	new FlxTimer().start(4.5, function(tmr:FlxTimer) {
		FlxG.camera.fade(FlxColor.BLACK, 1.4, false, function() {
			FlxG.switchState(() -> new funkin.states.HenryState());
		}, true);
	});
}

function shaderFlash(a = 0, b = 0.05, ?ignoreOption = false)
{
	if (!ignoreOption && !ClientPrefs.flashing) return;
	
	FlxTween.num(1, a, b, {ease: FlxEase.expoOut}, flash);
}

function onEvent(ev, v1, v2)
{
        if (ev == 'hudBounce') {
                 bouncing = true;
                 bounceFreq = v1;
        }
}

function flash(n:Float):Void
{
	var b:Float = (1 - n);
	var w:Float = (n * 255);
	
	for (sprite in flashers)
		sprite.setColorTransform(b, b, b, 1, w, w, w);
}
