import funkin.game.shaders.ExtraDropShadowShader;
import animate.FlxAnimateFrames;

var bothSing:Bool = false;
var twoSing:Bool = false;
public var cargoDark:FlxSprite;
public var lightoverlayDK:FlxSprite;
public var mainoverlayDK:FlxSprite;
var cargoAirship:FlxSprite;
var blackanim:FlxSprite;
var ext = 'stages/airship/double-kill/';
public var yellow:Character;
public var isBfGhost:Bool = false;
var bg:FlxSprite;
var mandoSing:Bool = false;
var bfRim:ExtraDropShadowShader;
var petRim:ExtraDropShadowShader;
var blackRim:ExtraDropShadowShader;
var gfRim:ExtraDropShadowShader;
var dadRim:ExtraDropShadowShader;
var blackDkEyeOverlay:FunkinSprite;
var blackDkEyeAnim:String = '';
var blackDkEyeHidden:Bool = false;
var thunderTimer:Float = 0;
public var black:Character;

var darkMatrix:Array<Float> = [
    0.24, 0.08, 0.04, 0, 2,
    0.05, 0.19, 0.09, 0, 2,
    0.08, 0.09, 0.29, 0, 5,
    0, 0, 0, 1, 0
];

var originalColorMatrix:Array<Float> = [
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0, 0, 0, 1, 0
];

function onLoad()
{
    bg = new FlxSprite(0, 0).loadGraphic(Paths.image(ext + 'cargo night'));
    bg.antialiasing = true;
    bg.scale.set(2, 2);
    bg.updateHitbox();
    bg.scrollFactor.set(1, 1);
    bg.active = false;
    add(bg);

    cargoDark = new FlxSprite(-1000, -1000).makeScaledGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
    cargoDark.antialiasing = true;
    cargoDark.scrollFactor.set(0, 0);
    cargoDark.alpha = 0.001;
    add(cargoDark);
}

function onSongStart()
{
    black.alpha = 0;
}

function goodNoteHit(note)
{
    if (mandoSing) characterSing(yellow, note);
}

function onBeatHit()
{
    if (yellow != null) yellow.onBeatHit(curBeat);
    black.onBeatHit();

    switch(curBeat)
    {
        case 32:
            blackanim.setPosition(black.x, black.y - 1400);
            blackanim.animation.play('intro');
            blackanim.alpha = 1;
            blackanim.animation.onFinish.addOnce((anim)->{ blackanim.alpha = 0.001; black.alpha = 1; });
        case 196, 228, 272, 288, 488, 520, 756, 764, 784, 816:
            extraStrums(true);
        case 212, 244, 276, 292, 504, 536, 760, 768, 800, 832:
            extraStrums(false);
    }
}

function onCreatePost()
{
    for (playField in playFields)
        if (playField.ID != 0) playField.playerControls = false;
    if (!hasGfSkin || PlayState.isStoryMode) gf.visible = false;

    black = new Character(1550, 600, "blackdk");
    startCharacterPos(black);
    stage.insert(stage.members.indexOf(dadGroup), black);

    blackanim = new FlxSprite(0,0);
    blackanim.frames = Paths.getSparrowAtlas('characters/story/black/black_anim');
    blackanim.animation.addByPrefix('intro', 'black anim', 24, false);
    blackanim.alpha = 0.001;
    stage.insert(stage.members.indexOf(black) + 1, blackanim);

    createBlackDkEyeOverlay();

    playFields.members[2].isPlayer = false;
    playFields.members[2].owner = null;

    for (i in playFields.members)
    {
        final orgID = (2 - i.ID);
        final wrap = (i.ID == 0 || i.ID == 1);
        i.visible = (i.ID == 0 || ClientPrefs.opponentStrums);

        if (wrap)
        {
            i.zIndex = 999;
        }
        else
        {
            i.underlay.kill();
            modManager.setValue("noteAlpha", 1, i.ID);
            modManager.setValue("alpha", 1, i.ID);
            modManager.setValue("stealth", 0.5, i.ID);
            modManager.setValue("transformZ", -1, i.ID);
            modManager.setValue("transformY", -90 * (ClientPrefs.downScroll ? -1 : 1), i.ID);
            modManager.setValue("stealthPastReceptors", 1, i.ID);

            final space = 865;
            if (!ClientPrefs.middleScroll) modManager.setValue("transformX", i.ID == 2 ? -(space) : space, i.ID);
            else if (!ClientPrefs.opponentStrums) i.visible = false;
        }
    }

    isBfGhost = boyfriend.getFlag('ghost');
    if (isBfGhost)
    {
        mandoSing = true;
        yellow = new Character(3100, 650, 'yellow-ghost', true);
        yellow.alpha = 0.001;
        startCharacterPos(yellow);
        add(yellow);
    }

    mainoverlayDK = new FlxSprite(1000, 350).loadGraphic(Paths.image(ext + 'newoverlay1 night'));
    mainoverlayDK.scale.set(1.8, 1.6);
    mainoverlayDK.updateHitbox();
    mainoverlayDK.alpha = .51;
    mainoverlayDK.blend = BlendMode.SUBTRACT;
    add(mainoverlayDK);

    lightoverlayDK = new FlxSprite(bg.x, bg.y).loadGraphic(Paths.image(ext + 'overlay ass dk'));
    lightoverlayDK.setGraphicSize(bg.width * 1.5, bg.height);
    lightoverlayDK.updateHitbox();
    lightoverlayDK.alpha = 0.4;
    lightoverlayDK.blend = BlendMode.ADD;
    add(lightoverlayDK);

    applyBFEffect();
    applyBLACKEffect();
    applyGFEffect();
    applyDadEffect();
}

function onUpdatePost(elapsed:Float)
{
    syncBlackDkEyeOverlay();
}

function onUpdate()
{
    thunderTimer += FlxG.elapsed;

    if (thunderTimer >= 5)
    {
        thunderTimer = 0;

        if (FlxG.random.int(1, 10) == 1)
        {
            var thunderSounds:Array<String> = ['thunder11', 'thunder22', 'thunder33'];
            FlxG.sound.play(Paths.sound(thunderSounds[FlxG.random.int(0, thunderSounds.length - 1)]), 2);
        }

        if (FlxG.random.int(1, 10000000) == 1)
        {
            var thunderSounds:Array<String> = ['thunder44'];
            FlxG.sound.play(Paths.sound(thunderSounds[FlxG.random.int(0, thunderSounds.length - 1)]), 3);
        }
    }
}

function createBlackDkEyeOverlay():Void
{
    if (black == null || blackDkEyeOverlay != null)
        return;

    var char = black;
    var atlasPath:String = Paths.getPath(
        'images/${char.imageFile}',
        null,
        PathsTestMode.LOOSE
    );

    var eyeFrames:FlxAnimateFrames = FlxAnimateFrames.fromAnimate(
        atlasPath,
        null,
        null,
        'blackDkEyeUnique',
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

        if (anim.anim == 'fall')
            continue;

        var animName:String = '' + anim.anim;
        var sourceName:String = '' + anim.name;
        var fps:Int = anim.fps;
        var looping:Bool = !!anim.loop;
        var indices:Array<Int> = anim.indices ?? [];
        var flipX:Bool = anim.flipX ?? false;
        var flipY:Bool = anim.flipY ?? false;

        if (indices.length > 0)
        {
            overlay.addAnimByIndices(
                animName,
                sourceName,
                indices,
                fps,
                looping,
                flipX,
                flipY
            );
        }
        else
        {
            overlay.addAnimByPrefix(
                animName,
                sourceName,
                fps,
                looping,
                flipX,
                flipY
            );
        }
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
    overlay.zIndex = char.zIndex + 0.01;
    overlay.active = false;
    overlay.visible = false;

    maskBlackDkEyeSymbol(overlay, 'Símbolo 30', ['Capa 17', 'Símbolo 25']);
    maskBlackDkEyeSymbol(overlay, 'Símbolo 36', ['Símbolo 25']);
    maskBlackDkEyeSymbol(overlay, 'BLACK RIGHT', ['Símbolo 25']);
    maskBlackDkEyeSymbol(overlay, 'Símbolo 31', ['Símbolo 25']);
    maskBlackDkEyeSymbol(overlay, 'Símbolo 35', ['Símbolo 25']);
    maskBlackDkEyeSymbol(overlay, 'Símbolo 25', [
        'Capa 4',
        'Capa 5',
        'Capa 3',
        'Capa 2 copy 3',
        'Capa 2 copy 4',
        'Capa 2 copy 2',
        'Capa 2'
    ]);

    stage.insert(stage.members.indexOf(blackanim), overlay);
    blackDkEyeOverlay = overlay;

    hideOriginalBlackDkEye();
    syncBlackDkEyeOverlay();
}

function maskBlackDkEyeSymbol(
    overlay:FunkinSprite,
    symbolName:String,
    eyeLayers:Array<String>
):Void
{
    if (overlay == null || overlay.library == null)
        return;

    var symbol = overlay.library.getSymbol(symbolName);
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

function hideOriginalBlackDkEye():Void
{
    if (black == null || black.library == null || blackDkEyeHidden)
        return;

    hideBlackDkEyeLayers(black, 'Símbolo 30', ['Capa 17', 'Símbolo 25']);
    hideBlackDkEyeLayers(black, 'Símbolo 36', ['Símbolo 25']);
    hideBlackDkEyeLayers(black, 'BLACK RIGHT', ['Símbolo 25']);
    hideBlackDkEyeLayers(black, 'Símbolo 31', ['Símbolo 25']);
    hideBlackDkEyeLayers(black, 'Símbolo 35', ['Símbolo 25']);

    blackDkEyeHidden = true;
}

function hideBlackDkEyeLayers(
    sprite:FunkinSprite,
    symbolName:String,
    hiddenLayers:Array<String>
):Void
{
    if (sprite == null || sprite.library == null)
        return;

    var symbol = sprite.library.getSymbol(symbolName);
    if (symbol == null || symbol.timeline == null)
        return;

    for (layer in symbol.timeline.layers)
    {
        if (hiddenLayers.indexOf(layer.name) < 0)
            continue;

        layer.forEachFrame(function(frame)
        {
            if (frame == null || frame.elements == null)
                return;

            for (element in frame.elements)
                element.visible = false;
        });
    }
}

function restoreOriginalBlackDkEye():Void
{
    if (black == null || black.library == null)
        return;

    restoreBlackDkEyeLayers(black, 'Símbolo 30', ['Capa 17', 'Símbolo 25']);
    restoreBlackDkEyeLayers(black, 'Símbolo 36', ['Símbolo 25']);
    restoreBlackDkEyeLayers(black, 'BLACK RIGHT', ['Símbolo 25']);
    restoreBlackDkEyeLayers(black, 'Símbolo 31', ['Símbolo 25']);
    restoreBlackDkEyeLayers(black, 'Símbolo 35', ['Símbolo 25']);

    blackDkEyeHidden = false;
}

function restoreBlackDkEyeLayers(
    sprite:FunkinSprite,
    symbolName:String,
    hiddenLayers:Array<String>
):Void
{
    if (sprite == null || sprite.library == null)
        return;

    var symbol = sprite.library.getSymbol(symbolName);
    if (symbol == null || symbol.timeline == null)
        return;

    for (layer in symbol.timeline.layers)
    {
        if (hiddenLayers.indexOf(layer.name) < 0)
            continue;

        layer.forEachFrame(function(frame)
        {
            if (frame == null || frame.elements == null)
                return;

            for (element in frame.elements)
                element.visible = true;
        });
    }
}

function syncBlackDkEyeOverlay():Void
{
    if (black == null || blackDkEyeOverlay == null)
        return;

    var overlay = blackDkEyeOverlay;

    if (!black.exists || !black.visible || black.alpha <= 0 || black.isAnimNull())
    {
        overlay.visible = false;
        overlay.active = false;
        return;
    }

    var currentAnim:String = black.getAnimName();
    if (currentAnim == '' || !overlay.hasAnim(currentAnim))
    {
        overlay.visible = false;
        overlay.active = false;
        return;
    }

    if (blackDkEyeAnim != currentAnim)
    {
        overlay.playAnim(currentAnim, true, false);
        blackDkEyeAnim = currentAnim;
    }

    var frameCount:Int = overlay.getAnimNumFrames();
    if (frameCount > 0)
    {
        var frame:Int = black.animCurFrame;
        if (frame < 0)
            frame = 0;
        if (frame >= frameCount)
            frame = frameCount - 1;
        overlay.animCurFrame = frame;
    }

    overlay.x = black.x;
    overlay.y = black.y;
    overlay.scale.set(black.scale.x, black.scale.y);
    overlay.baseScale.set(black.baseScale.x, black.baseScale.y);
    overlay.origin.set(black.origin.x, black.origin.y);
    overlay.offset.set(black.offset.x, black.offset.y);
    overlay.spriteOffset.set(black.spriteOffset.x, black.spriteOffset.y);
    overlay.animOffset.set(black.animOffset.x, black.animOffset.y);
    overlay.angle = black.angle;
    overlay.skew.set(black.skew.x, black.skew.y);
    overlay.flipX = black.flipX;
    overlay.flipY = black.flipY;
    overlay.alpha = black.alpha;
    overlay.color = black.color;
    overlay.blend = black.blend;
    overlay.scrollFactor.set(black.scrollFactor.x, black.scrollFactor.y);
    overlay.antialiasing = black.antialiasing;
    overlay.zIndex = black.zIndex + 0.01;
    overlay.shader = null;
    overlay.useRenderTexture = false;
    overlay.cameras = [camGame];

    overlay.colorTransform.redMultiplier = black.colorTransform.redMultiplier;
    overlay.colorTransform.greenMultiplier = black.colorTransform.greenMultiplier;
    overlay.colorTransform.blueMultiplier = black.colorTransform.blueMultiplier;
    overlay.colorTransform.alphaMultiplier = black.colorTransform.alphaMultiplier;
    overlay.colorTransform.redOffset = black.colorTransform.redOffset;
    overlay.colorTransform.greenOffset = black.colorTransform.greenOffset;
    overlay.colorTransform.blueOffset = black.colorTransform.blueOffset;
    overlay.colorTransform.alphaOffset = black.colorTransform.alphaOffset;

    overlay.active = true;
    overlay.visible = true;
}

function applyDarkLightEffect(target:FlxSprite, angle:Float, distance:Float):ExtraDropShadowShader
{
    if (!ClientPrefs.shaders || target == null) return null;

    var effect = new ExtraDropShadowShader();
    effect.threshold = 0;
    effect.strength = 1;
    effect.roughness = 1;
    effect.setColorMatrix(darkMatrix);
    effect.addLayer(originalColorMatrix, angle, distance, 0.01, 0.9, 1);

    target.useRenderTexture = true;
    effect.attachedSprite = target;
    target.shader = effect;
    return effect;
}

function applyBFEffect()
{
    if (boyfriend == null) return;

    bfRim = applyDarkLightEffect(boyfriend, boyfriend.flipX ? -125 : -79, -25);

    if (hasPet && pet != null)
        petRim = applyDarkLightEffect(pet, pet.flipX ? -125 : -79, -25);
}

function applyBLACKEffect()
{
    if (black == null) return;
    blackRim = applyDarkLightEffect(black, -85, -25);
}

function applyGFEffect()
{
    if (gf == null) return;
    gfRim = applyDarkLightEffect(gf, -85, -25);
}

function applyDadEffect()
{
    if (dad == null) return;
    dadRim = applyDarkLightEffect(dad, -85, -35);
}

function onEvent(eventName, value1, value2)
{
    switch (eventName)
    {
        case 'Legacy':
            switch (value1)
            {
                case 'black':
                    camCurTarget = black;
                case 'not black':
                    camCurTarget = null;
            }
        case 'Opponent Two':
            twoSing = Std.int(value1) == 1;
            if (!bothSing) refreshDoubleKillIcon();
        case 'Both Opponents':
            bothSing = Std.int(value1) == 1;
            playHUD.iconP2.changeIcon(bothSing ? 'double-kill' : (twoSing ? 'black' : 'white'));
    }
}

function refreshDoubleKillIcon()
{
    if (hasColor) scoreTxt.color = (twoSing ? black : dad).healthColour;
    playHUD.healthBar.setColors((twoSing ? black : dad).healthColour, boyfriend.healthColour);
    playHUD.iconP2.changeIcon(twoSing ? 'black' : 'white');
}

function opponentNoteHitPre(note)
{
    if (note.noteType == 'Opponent 2 Sing')
    {
        note.owner = black;
    }
    else if (bothSing || note.noteType == 'Both Opponents Sing')
    {
        characterSing(dad, note);
        characterSing(black, note);
        note.noAnimation = true;
    }
    else if (twoSing)
    {
        note.owner = black;
    }
    if (note.noteType == 'Opponent 1 Sing')
    {
        note.owner = dad;
    }
}

function extraStrums(happyChristmas:Bool)
{
    if (happyChristmas)
        FlxTween.num(1, 0.7, 0.3, {ease: FlxEase.quadOut, onUpdate: function(twn:FlxTween)
            modManager.setValue("alpha", twn.value, 2)
        });
    else
        FlxTween.num(0.7, 1, 0.3, {ease: FlxEase.quadOut, onUpdate: function(twn:FlxTween)
            modManager.setValue("alpha", twn.value, 2)
        });
}

function onDestroy()
{
    restoreOriginalBlackDkEye();

    if (blackDkEyeOverlay != null)
    {
        blackDkEyeOverlay.destroy();
        blackDkEyeOverlay = null;
    }

    blackDkEyeAnim = '';
}
