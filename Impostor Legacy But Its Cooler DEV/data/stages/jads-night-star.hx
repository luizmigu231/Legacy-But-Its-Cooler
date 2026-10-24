import funkin.data.ClientPrefs;
import flixel.tweens.FlxEase;
import flixel.addons.display.FlxRuntimeShader;
import funkin.game.shaders.WiggleEffect;
import funkin.game.shaders.WiggleEffectType;

var bfRim:ExtraDropShadowShader;
var dadRim:ExtraDropShadowShader;
var gfRim:ExtraDropShadowShader;
var bars:FlxSpriteGroup;
var barTop:FlxSprite;
var barBottom:FlxSprite;

var spaceFadeGroup:FlxSpriteGroup;
var space:FlxSprite;
var spaceActive:Bool = false;

var starEmitter:FlxSpriteGroup;
var fallingStars:Array<FlxSprite> = [];
var fallingStarGlows:Array<FlxSprite> = [];
var starSpawnTimer:Float = 0;
var glowPulseTime:Float = 0;

var starBG:FlxBackdrop;
var starBGExtra:FlxSprite;
var starFG:FlxBackdrop;
var starFGExtra:FlxSprite;
var spaceWiggle:WiggleEffect;

var bg:FlxSprite;
var fans:FlxSprite;
var piss:FlxSprite;
var bg2:FlxSprite;
var fans2:FlxSprite;
var piss2:FlxSprite;
var white:FlxSprite;

var bgStartY:Float;
var fansStartY:Float;
var pissStartY:Float;
var bg2StartY:Float;
var fans2StartY:Float;
var piss2StartY:Float;

var ext:String = 'stages/skeld/jads-dark/';

function onLoad()
{
    bars = new FlxSpriteGroup();
    bars.cameras = [camHUD];
    bars.alpha = 1;
    add(bars);

    barTop = new FlxSprite().makeGraphic(FlxG.width + 3, 90, FlxColor.BLACK);
    barTop.y = 0;
    bars.add(barTop);

    barBottom = new FlxSprite().makeGraphic(FlxG.width + 3, 90, FlxColor.BLACK);
    barBottom.y = 630;
    bars.add(barBottom);

    bg = new FlxSprite(-595, -195).loadGraphic(Paths.image(ext + 'O2Background'));
    bgStartY = bg.y;
    bg.alpha = 0;

    bg2 = new FlxSprite(-595, -195).loadGraphic(Paths.image(ext + 'O2Backgroundstar'));
    bg2StartY = bg2.y;
    bg2.alpha = 0.2;

    fans = new FlxSprite(-166.25, 68.45);
    fans.frames = Paths.getSparrowAtlas(ext + 'fansss');
    fans.animation.addByPrefix('bop', 'fansss instance 1', 24, true);
    fans.animation.play('bop');
    fansStartY = fans.y;
    fans.alpha = 0;

    fans2 = new FlxSprite(-166.25, 68.45);
    fans2.frames = Paths.getSparrowAtlas(ext + 'fansssstar');
    fans2.animation.addByPrefix('bop', 'fansss instance 1', 24, true);
    fans2.animation.play('bop');
    fans2StartY = fans2.y;
    fans2.alpha = 0.2;

    piss = new FlxSprite(-453.9, 310.2).loadGraphic(Paths.image(ext + 'switch'));
    pissStartY = piss.y;
    piss.alpha = 0;

    piss2 = new FlxSprite(-453.9, 310.2).loadGraphic(Paths.image(ext + 'switchstar'));
    piss2StartY = piss2.y;
    piss2.alpha = 0.2;

    white = new FlxSprite(-595, -195).loadGraphic(Paths.image(ext + 'white'));
    white.alpha = 0;

    add(bg);
    add(fans);
    add(piss);
    add(bg2);
    add(fans2);
    add(piss2);
    add(white);

    spaceFadeGroup = new FlxSpriteGroup();
    spaceFadeGroup.alpha = 0;
    add(spaceFadeGroup);

    space = new FlxSprite(-500, -100).loadGraphic(Paths.image(ext + 'space/space'));
    space.setGraphicSize(Std.int(space.width * 2.4));

    spaceWiggle = new WiggleEffect();
    spaceWiggle.effectType = WiggleEffectType.DREAMY;
    spaceWiggle.waveSpeed = 1.0;
    spaceWiggle.waveFrequency = 4.0;
    spaceWiggle.waveAmplitude = 0.055;

    space.shader = null;
    space.visible = true;
    spaceFadeGroup.add(space);

    starEmitter = new FlxSpriteGroup();
    starEmitter.scrollFactor.set(1, 1);
    spaceFadeGroup.add(starEmitter);

    starBG = new FlxBackdrop(Paths.image(ext + 'space/starBG'));
    starBG.scrollFactor.set(1, 1);
    starBG.velocity.set(0, 0);
    starBG.alpha = 1;
    spaceFadeGroup.add(starBG);

    starBGExtra = new FlxSprite(FlxG.random.float(-500, 500), FlxG.random.float(-300, 300)).loadGraphic(Paths.image(ext + 'space/starBG'));
    starBGExtra.scrollFactor.set(1, 1);
    starBGExtra.angle = FlxG.random.float(0, 360);
    starBGExtra.alpha = 1;
    spaceFadeGroup.add(starBGExtra);

    starFG = new FlxBackdrop(Paths.image(ext + 'space/starFG'));
    starFG.scrollFactor.set(1, 1);
    starFG.velocity.set(-12, 0);
    starFG.alpha = 0;
    spaceFadeGroup.add(starFG);

    starFGExtra = new FlxSprite(FlxG.random.float(0, 1000), FlxG.random.float(-300, 500)).loadGraphic(Paths.image(ext + 'space/starFG'));
    starFGExtra.scrollFactor.set(1, 1);
    starFGExtra.angle = FlxG.random.float(0, 360);
    starFGExtra.velocity.set(-18, 0);
    starFGExtra.alpha = 0;
    spaceFadeGroup.add(starFGExtra);
}

function spawnFallingStar()
{
    var star = new FlxSprite();
    star.frames = Paths.getSparrowAtlas(ext + 'space/fallingstar');
    star.animation.addByPrefix('star1', 'star0001', 24, true);
    star.animation.addByPrefix('star2', 'star0002', 24, true);
    star.animation.addByPrefix('star3', 'star0003', 24, true);

    var chosenStar:Int = FlxG.random.int(1, 3);
    star.animation.play('star' + chosenStar);

    var starScale:Float = FlxG.random.float(0.55, 0.9);
    star.scale.set(starScale, starScale);
    star.updateHitbox();
    star.x = FlxG.random.float(-200, FlxG.width + 200);
    star.y = FlxG.random.float(-300, -20);
    star.angle = FlxG.random.float(-35, 35);
    star.velocity.x = -FlxG.random.float(450, 700);
    star.velocity.y = FlxG.random.float(300, 500);
    star.angularVelocity = -FlxG.random.float(20, 35);
    star.alpha = 1;

    starEmitter.add(star);
    fallingStars.push(star);

    var glow = new FlxSprite();
    glow.frames = Paths.getSparrowAtlas(ext + 'space/fallingstar');
    glow.animation.addByPrefix('star1', 'star0001', 24, true);
    glow.animation.addByPrefix('star2', 'star0002', 24, true);
    glow.animation.addByPrefix('star3', 'star0003', 24, true);
    glow.animation.play('star' + chosenStar);
    glow.scale.set(starScale, starScale);
    glow.updateHitbox();
    glow.x = star.x;
    glow.y = star.y;
    glow.angle = star.angle;
    glow.velocity.x = star.velocity.x;
    glow.velocity.y = star.velocity.y;
    glow.angularVelocity = star.angularVelocity;
    glow.blend = BlendMode.ADD;
    glow.alpha = 1.0;

    starEmitter.add(glow);
    fallingStarGlows.push(glow);
}

function onUpdate(elapsed:Float)
{
    if (spaceWiggle != null)
        spaceWiggle.update(elapsed);

    glowPulseTime += elapsed * 3.0;

    var pulse:Float = 1.0 + (Math.sin(glowPulseTime) * 0.25 + 0.25);
    var starFGPulse:Float = 0.9 + Math.sin(glowPulseTime) * 0.3;

    if (spaceActive)
    {
        if (starBG != null)
            starBG.alpha = pulse;
        if (starBGExtra != null)
            starBGExtra.alpha = pulse;
        if (starFG != null)
            starFG.alpha = starFGPulse;
        if (starFGExtra != null)
            starFGExtra.alpha = starFGPulse;

        for (glow in fallingStarGlows)
        {
            if (glow != null)
                glow.alpha = pulse;
        }
    }
    else
    {
        if (starFG != null)
            starFG.alpha = 0;
        if (starFGExtra != null)
            starFGExtra.alpha = 0;
    }

    if (spaceActive && spaceFadeGroup != null && spaceFadeGroup.alpha > 0)
    {
        starSpawnTimer += elapsed;
        if (starSpawnTimer >= 0.16)
        {
            starSpawnTimer -= 0.16;
            spawnFallingStar();
        }
    }

    for (i in fallingStars.length - 1...-1)
    {
        var star = fallingStars[i];
        var glow = fallingStarGlows[i];

        if (star == null || star.x < -500 || star.y > FlxG.height + 500)
        {
            if (star != null)
                starEmitter.remove(star, true);
            if (glow != null)
                starEmitter.remove(glow, true);

            fallingStars.splice(i, 1);
            fallingStarGlows.splice(i, 1);
        }
        else if (glow != null)
        {
            glow.x = star.x;
            glow.y = star.y;
            glow.angle = star.angle;
        }
    }
}

function onCreatePost()
{
    camSpecialThing([600, 440], [1150, 440]);
    applyBFEffect();
    applyDadEffect();
    applyGFEffect();

    gf.alpha = 0;

    if (!ClientPrefs.shaders)
    {
        dad.color = 0xFF8038A3;
        boyfriend.color = 0xFF8038A3;
        gf.color = 0xFF8038A3;
        pet.color = 0xFF8038A3;
    }
}

function onSongStart()
{
    onStepHit();
}

public var woo_party:Int = 0;

function onEndSong()
{
    woo_party = 0;
}

function onStepHit()
{
    modchart(curStep);

    if (curStep == 240)
    {
        FlxTween.tween(bg2, {alpha: 0.75}, 0.5);
        FlxTween.tween(fans2, {alpha: 0.75}, 0.5);
        FlxTween.tween(piss2, {alpha: 0.75}, 0.5);
    }

    if (curStep == 760)
    {
        FlxTween.tween(bg2, {y: bg2StartY + 900, alpha: 0}, 2.5, {ease: FlxEase.quadIn});
        FlxTween.tween(fans2, {y: fans2StartY + 900, alpha: 0}, 2.5, {ease: FlxEase.quadIn});
        FlxTween.tween(piss2, {y: piss2StartY + 900, alpha: 0}, 2.5, {ease: FlxEase.quadIn});
    }

    if (curStep == 770)
    {
        spaceActive = true;
        space.shader = null;
        space.visible = true;
        spaceFadeGroup.alpha = 0;
        starFG.alpha = 0;
        starFGExtra.alpha = 0;
        gf.alpha = 0;

        FlxTween.tween(barTop, {y: -90}, 2.5, {ease: FlxEase.quadInOut});
        FlxTween.tween(barBottom, {y: 720}, 2.5, {ease: FlxEase.quadInOut});

        FlxTween.tween(spaceFadeGroup, {alpha: 0.6}, 0.6, {
            ease: FlxEase.quadOut,
            onComplete: function(twn:FlxTween)
            {
                space.shader = spaceWiggle.shader;
            }
        });

        FlxTween.tween(gf, {alpha: 0.5}, 2.5, {
            ease: FlxEase.quadOut,
            onUpdate: function(twn:FlxTween)
            {
                gf.alpha = FlxMath.lerp(0, 0.5, twn.percent);
            },
            onComplete: function(twn:FlxTween)
            {
                gf.alpha = 0.5;
            }
        });

        triggerEventNote('flash', '3', '');
    }

    if (curStep == 780)
        triggerEventNote('Camera Zoom', '0.55', '2, elasticOut');

    if (curStep == 1265)
    {
        FlxTween.tween(bg2, {y: bg2StartY, alpha: 0.9}, 0.6, {ease: FlxEase.quadOut});
        FlxTween.tween(fans2, {y: fans2StartY, alpha: 0.9}, 0.6, {ease: FlxEase.quadOut});
        FlxTween.tween(piss2, {y: piss2StartY, alpha: 0.9}, 0.6, {ease: FlxEase.quadOut});
    }

    if (curStep == 1279)
    {
        spaceActive = false;
        space.shader = null;
        starFG.alpha = 0;
        starFGExtra.alpha = 0;

        FlxTween.tween(barTop, {y: 0}, 2.5, {ease: FlxEase.quadInOut});
        FlxTween.tween(barBottom, {y: 630}, 2.5, {ease: FlxEase.quadInOut});

        FlxTween.tween(gf, {alpha: 0}, 2.5, {
            ease: FlxEase.quadIn,
            onUpdate: function(twn:FlxTween)
            {
                gf.alpha = 0.5 * (1 - twn.percent);
            },
            onComplete: function(twn:FlxTween)
            {
                gf.alpha = 0;
            }
        });

        FlxTween.tween(spaceFadeGroup, {alpha: 0}, 0.6, {
            ease: FlxEase.quadIn,
            onComplete: function(twn:FlxTween)
            {
                space.visible = false;
                starFG.alpha = 0;
                starFGExtra.alpha = 0;
                gf.alpha = 0;
            }
        });

        triggerEventNote('flash', '3', '');
    }
    
    if (curStep == 1659)
    {
    FlxTween.tween(barTop, {y: -90}, 0.6, {ease: FlxEase.quadInOut});
        FlxTween.tween(barBottom, {y: 720}, 0.6, {ease: FlxEase.quadInOut});
    }
}

function bump(game:Float, hud:Float)
{
    if (!ClientPrefs.camZooms)
        return;

    camGame.zoom += game;
    camHUD.zoom += hud;
}

function applyBFEffect()
{
    if (ClientPrefs.shaders)
    {
        var blackRimlightBase:ExtraDropShadowShader = new funkin.game.shaders.ExtraDropShadowShader();
        var baseAngle:Float = 10;

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
        ], 100, 14, .01);

        if (boyfriend.getFlag('backlit') != true)
        {
            bfRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(blackRimlightBase);
            bfRim.attachedSprite = boyfriend;
            boyfriend.useRenderTexture = true;
            bfRim.layers[0].angle = boyfriend.flipX ? (180 - baseAngle) : baseAngle;
        }

        if (hasPet)
        {
            petRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(blackRimlightBase);
            petRim.attachedSprite = pet;
            pet.useRenderTexture = true;
            petRim.layers[0].angle = pet.flipX ? (180 - baseAngle) : baseAngle;
        }
    }
}

function applyDadEffect()
{
    if (ClientPrefs.shaders)
    {
        var blackRimlightBase:ExtraDropShadowShader = new funkin.game.shaders.ExtraDropShadowShader();
        var baseAngle:Float = 10;

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
        ], baseAngle, 14, .01);

        if (dad.getFlag('backlit') != true)
        {
            dadRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(blackRimlightBase);
            dadRim.attachedSprite = dad;
            dad.useRenderTexture = true;
            dadRim.layers[0].angle = dad.flipX ? (180 - baseAngle) : baseAngle;
        }
    }
}

function applyGFEffect()
{
    if (ClientPrefs.shaders)
    {
        var blackRimlightBase:ExtraDropShadowShader = new funkin.game.shaders.ExtraDropShadowShader();
        var baseAngle:Float = 10;

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
        ], baseAngle, 14, .01);

        gfRim = new funkin.game.shaders.ExtraDropShadowShader().copyFrom(blackRimlightBase);
        gfRim.attachedSprite = gf;
        gf.useRenderTexture = true;
        gfRim.layers[0].angle = gf.flipX ? (180 - baseAngle) : baseAngle;
    }
}