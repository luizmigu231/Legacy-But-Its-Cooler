import flixel.math.FlxMath;
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

var dadForegroundRim:ExtraDropShadowShader = null;
var whiteDkExcludedParts:Array<String> = ['halo', '_bta_asi_36', '_bta_asi_37', 'halo__00__sprite_38', 'halo__01__sprite_39'];
var whiteDkHaloOverlay:FunkinSprite = null;
var whiteDkGlowWideOverlay:FunkinSprite = null;
var whiteDkGlowMidOverlay:FunkinSprite = null;
var whiteDkGlowOverlay:FunkinSprite = null;
var whiteDkBodyBackOverlay:FunkinSprite = null;
var whiteDkBodyFrontOverlay:FunkinSprite = null;
var whiteDkPartsLayer:FlxSpriteGroup = null;
var whiteDkOverlayCharacter:String = '';
var whiteDkSource:Dynamic = null;
var whiteDkSourceCharacter:String = '';
var whiteDkHidden:Bool = false;
var whiteDkOriginalVisible:Bool = true;

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
        case 36:
            blackanim.visible = false;
            black.alpha = 1;
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

    blackanim = new FunkinSprite(0,0);
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
    wdkRefreshParts();
}

function onUpdatePost(elapsed:Float)
{
    wdkRefreshParts();
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

function createDarkLightShader(angle:Float, distance:Float):ExtraDropShadowShader
{
    if (!ClientPrefs.shaders) return null;
    var effect = new ExtraDropShadowShader();
    effect.threshold = 0;
    effect.strength = 1;
    effect.roughness = 1;
    effect.setColorMatrix(darkMatrix);
    effect.addLayer(originalColorMatrix, angle, distance, 0.01, 0.9, 1);
    return effect;
}

function applyDarkLightEffect(target:FlxSprite, angle:Float, distance:Float):ExtraDropShadowShader
{
    if (target == null) return null;
    var effect = createDarkLightShader(angle, distance);
    if (effect == null) return null;
    target.useRenderTexture = true;
    effect.attachedSprite = target;
    target.shader = effect;
    return effect;
}

function wdkGetLibrary(sprite:Dynamic):Dynamic
{
    if (sprite == null) return null;
    var library:Dynamic = sprite.library;
    if (library == null) return null;
    return library;
}

function wdkGetElementName(element:Dynamic):String
{
    if (element == null) return '';
    var kind:String = '' + element.elementType;
    if (kind != 'graphic' && kind != 'movieclip' && kind != 'button') return '';
    var child:Dynamic = element.libraryItem;
    if (child == null || child.name == null) return '';
    var result:String = '' + child.name;
    if (result == '' || result == 'null' || result == 'undefined') return '';
    return result;
}

function wdkCheckItem(item:Dynamic, cacheTrue:Array<String>, cacheFalse:Array<String>, stack:Array<String>):Bool
{
    if (item == null || item.name == null) return false;
    var name:String = '' + item.name;
    if (whiteDkExcludedParts.indexOf(name) != -1) return true;
    if (cacheTrue.indexOf(name) != -1) return true;
    if (cacheFalse.indexOf(name) != -1 || stack.indexOf(name) != -1) return false;
    var timeline:Dynamic = item.timeline;
    if (timeline == null || timeline.layers == null)
    {
        if (cacheFalse.indexOf(name) == -1) cacheFalse.push(name);
        return false;
    }
    stack.push(name);
    var found:Bool = false;
    for (layer in timeline.layers)
    {
        if (layer == null) continue;
        layer.forEachFrame(function(frame)
        {
            if (found || frame == null || frame.elements == null) return;
            for (element in frame.elements)
            {
                var childName:String = wdkGetElementName(element);
                if (childName == '') continue;
                if (whiteDkExcludedParts.indexOf(childName) != -1 || wdkCheckItem(element.libraryItem, cacheTrue, cacheFalse, stack))
                {
                    found = true;
                    break;
                }
            }
        });
        if (found) break;
    }
    stack.pop();
    if (found)
    {
        if (cacheTrue.indexOf(name) == -1) cacheTrue.push(name);
    }
    else if (cacheFalse.indexOf(name) == -1) cacheFalse.push(name);
    return found;
}

function wdkSetupSymbol(item:Dynamic, mode:String, glowScale:Float):Void
{
    if (item == null || item.timeline == null) return;
    var symbolName:String = '' + item.name;
    var cacheTrue:Array<String> = [];
    var cacheFalse:Array<String> = [];
    if (mode == 'excluded' && whiteDkExcludedParts.indexOf(symbolName) != -1)
        return;
    for (layer in item.timeline.layers)
    {
        if (layer == null) continue;
        layer.forEachFrame(function(frame)
        {
            if (frame == null || frame.elements == null) return;
            for (element in frame.elements)
            {
                if (element == null) continue;
                var childName:String = wdkGetElementName(element);
                if (mode != 'excluded')
                {
                    if (childName != '' && whiteDkExcludedParts.indexOf(childName) != -1)
                        element.visible = false;
                    continue;
                }
                if (childName == '')
                {
                    element.visible = false;
                    continue;
                }
                var isExcluded:Bool = whiteDkExcludedParts.indexOf(childName) != -1;
                var childItem:Dynamic = element.libraryItem;
                var hasExcluded:Bool = isExcluded || wdkCheckItem(childItem, cacheTrue, cacheFalse, []);
                element.visible = hasExcluded;
                if (glowScale > 1 && childName == 'halo' && isExcluded && symbolName != 'halo' && element.matrix != null && childItem != null && childItem.timeline != null)
                {
                    var localBounds:Dynamic = childItem.timeline.getWholeBounds(false, null, null, true);
                    if (localBounds != null && localBounds.width > 0 && localBounds.height > 0)
                        wdkScaleAround(element, glowScale, localBounds.x + localBounds.width * 0.5, localBounds.y + localBounds.height * 0.5);
                }
            }
        });
    }
}

function wdkHasParts(sprite:Dynamic):Bool
{
    var library:Dynamic = wdkGetLibrary(sprite);
    if (library == null) return false;
    for (part in ['halo', '_bta_asi_36', '_bta_asi_37'])
    {
        var item = library.getSymbol(part);
        if (item == null || item.timeline == null) return false;
    }
    var halo = library.getSymbol('halo');
    return halo.timeline.layers != null && halo.timeline.layers.length >= 2;
}

function wdkCheckSymbol(sprite:Dynamic, symbolName:String, cacheTrue:Array<String>, cacheFalse:Array<String>, stack:Array<String>):Bool
{
    if (symbolName == null || symbolName == '') return false;
    if (whiteDkExcludedParts.indexOf(symbolName) != -1) return true;
    if (cacheTrue.indexOf(symbolName) != -1) return true;
    if (cacheFalse.indexOf(symbolName) != -1) return false;
    if (stack.indexOf(symbolName) != -1) return false;
    var library:Dynamic = wdkGetLibrary(sprite);
    if (library == null) return false;
    var symbol = library.getSymbol(symbolName);
    if (symbol == null || symbol.timeline == null)
    {
        if (cacheFalse.indexOf(symbolName) == -1) cacheFalse.push(symbolName);
        return false;
    }
    stack.push(symbolName);
    var found:Bool = false;
    for (layer in symbol.timeline.layers)
    {
        if (layer == null) continue;
        layer.forEachFrame(function(frame)
        {
            if (found || frame == null || frame.elements == null) return;
            for (element in frame.elements)
            {
                var childName:String = wdkGetElementName(element);
                if (childName == '') continue;
                if (wdkCheckSymbol(sprite, childName, cacheTrue, cacheFalse, stack))
                {
                    found = true;
                    break;
                }
            }
        });
        if (found) break;
    }
    stack.pop();
    if (found)
    {
        if (cacheTrue.indexOf(symbolName) == -1) cacheTrue.push(symbolName);
    }
    else if (cacheFalse.indexOf(symbolName) == -1) cacheFalse.push(symbolName);
    return found;
}

function wdkGetDepthSymbol(symbolName:String):String
{
    if (symbolName == null || symbolName == '') return symbolName;
    return symbolName;
}

function wdkFindLayer(sprite:Dynamic, symbolName:String, cacheTrue:Array<String>, cacheFalse:Array<String>):Int
{
    symbolName = wdkGetDepthSymbol(symbolName);
    var library:Dynamic = wdkGetLibrary(sprite);
    if (library == null) return -1;
    var symbol = library.getSymbol(symbolName);
    if (symbol == null || symbol.timeline == null) return -1;
    var targetLayer:Int = -1;
    for (layerOrder in 0...symbol.timeline.layers.length)
    {
        var layerIndex:Int = symbol.timeline.layers.length - 1 - layerOrder;
        var layer = symbol.timeline.layers[layerIndex];
        if (layer == null) continue;
        layer.forEachFrame(function(frame)
        {
            if (targetLayer >= 0 || frame == null || frame.elements == null) return;
            for (element in frame.elements)
            {
                var childName:String = wdkGetElementName(element);
                if (childName != '' && wdkCheckSymbol(sprite, childName, cacheTrue, cacheFalse, []))
                {
                    targetLayer = layerIndex;
                    break;
                }
            }
        });
        if (targetLayer >= 0) break;
    }
    return targetLayer;
}

function wdkFindElement(sprite:Dynamic, symbolName:String, targetLayer:Int, cacheTrue:Array<String>, cacheFalse:Array<String>):Int
{
    symbolName = wdkGetDepthSymbol(symbolName);
    var library:Dynamic = wdkGetLibrary(sprite);
    if (library == null || targetLayer < 0) return -1;
    var symbol = library.getSymbol(symbolName);
    if (symbol == null || symbol.timeline == null || targetLayer >= symbol.timeline.layers.length) return -1;
    var targetElement:Int = -1;
    var layer = symbol.timeline.layers[targetLayer];
    if (layer == null) return -1;
    layer.forEachFrame(function(frame)
    {
        if (targetElement >= 0 || frame == null || frame.elements == null) return;
        for (i in 0...frame.elements.length)
        {
            var childName:String = wdkGetElementName(frame.elements[i]);
            if (childName != '' && wdkCheckSymbol(sprite, childName, cacheTrue, cacheFalse, []))
            {
                targetElement = i;
                break;
            }
        }
    });
    return targetElement;
}

function wdkSetLayerOrder(sprite:Dynamic, rootSymbols:Array<String>, showForeground:Bool):Void
{
    for (symbolName in rootSymbols)
    {
        var depthSymbolName:String = wdkGetDepthSymbol(symbolName);
        var library:Dynamic = wdkGetLibrary(sprite);
        if (library == null) return;
        var symbol = library.getSymbol(depthSymbolName);
        if (symbol == null || symbol.timeline == null) continue;
        var cacheTrue:Array<String> = [];
        var cacheFalse:Array<String> = [];
        var targetLayer:Int = wdkFindLayer(sprite, depthSymbolName, cacheTrue, cacheFalse);
        if (targetLayer < 0)
        {
            if (showForeground)
            {
                for (layer in symbol.timeline.layers)
                {
                    if (layer == null) continue;
                    layer.forEachFrame(function(frame)
                    {
                        if (frame == null || frame.elements == null) return;
                        for (element in frame.elements)
                            if (element != null) element.visible = false;
                    });
                }
            }
            continue;
        }
        var targetElement:Int = wdkFindElement(sprite, depthSymbolName, targetLayer, cacheTrue, cacheFalse);
        if (targetElement < 0) continue;
        for (layerIndex in 0...symbol.timeline.layers.length)
        {
            var layer = symbol.timeline.layers[layerIndex];
            if (layer == null) continue;
            layer.forEachFrame(function(frame)
            {
                if (frame == null || frame.elements == null) return;
                var frameTargetElement:Int = -1;
                if (layerIndex == targetLayer)
                {
                    for (i in 0...frame.elements.length)
                    {
                        var targetChild:String = wdkGetElementName(frame.elements[i]);
                        if (targetChild != '' && wdkCheckSymbol(sprite, targetChild, cacheTrue, cacheFalse, []))
                        {
                            frameTargetElement = i;
                            break;
                        }
                    }
                }
                if (frameTargetElement < 0) frameTargetElement = targetElement;
                for (i in 0...frame.elements.length)
                {
                    var element = frame.elements[i];
                    if (element == null) continue;
                    var childName:String = wdkGetElementName(element);
                    if (childName != '' && whiteDkExcludedParts.indexOf(childName) != -1)
                    {
                        element.visible = false;
                        continue;
                    }
                    if (showForeground)
                        element.visible = layerIndex < targetLayer || (layerIndex == targetLayer && i > frameTargetElement);
                    else
                        element.visible = layerIndex > targetLayer || (layerIndex == targetLayer && i < frameTargetElement);
                }
            });
        }
    }
}

function wdkDisposePart(sprite:FunkinSprite):Void
{
    if (sprite == null) return;
    if (whiteDkPartsLayer != null) whiteDkPartsLayer.remove(sprite, true);
    sprite.destroy();
}

function wdkDisposeLayers():Void
{
    if (dadRim != null && whiteDkBodyBackOverlay != null && dadRim.attachedSprite == whiteDkBodyBackOverlay)
        dadRim.attachedSprite = null;
    if (dadForegroundRim != null && whiteDkBodyFrontOverlay != null && dadForegroundRim.attachedSprite == whiteDkBodyFrontOverlay)
        dadForegroundRim.attachedSprite = null;
    wdkDisposePart(whiteDkBodyBackOverlay);
    wdkDisposePart(whiteDkGlowWideOverlay);
    wdkDisposePart(whiteDkGlowMidOverlay);
    wdkDisposePart(whiteDkGlowOverlay);
    wdkDisposePart(whiteDkHaloOverlay);
    wdkDisposePart(whiteDkBodyFrontOverlay);
    if (whiteDkPartsLayer != null)
    {
        if (game != null && game.dadGroup != null) game.dadGroup.remove(whiteDkPartsLayer, true);
        whiteDkPartsLayer.destroy();
        whiteDkPartsLayer = null;
    }
    whiteDkBodyBackOverlay = null;
    whiteDkGlowWideOverlay = null;
    whiteDkGlowMidOverlay = null;
    whiteDkGlowOverlay = null;
    whiteDkHaloOverlay = null;
    whiteDkBodyFrontOverlay = null;
    whiteDkOverlayCharacter = '';
}

function wdkScaleAround(element:Dynamic, factor:Float, centerX:Float, centerY:Float):Void
{
    if (element == null || element.matrix == null) return;
    var a:Float = element.matrix.a;
    var b:Float = element.matrix.b;
    var c:Float = element.matrix.c;
    var d:Float = element.matrix.d;
    element.matrix.tx = element.matrix.tx + (1 - factor) * (a * centerX + c * centerY);
    element.matrix.ty = element.matrix.ty + (1 - factor) * (b * centerX + d * centerY);
    element.matrix.a = a * factor;
    element.matrix.b = b * factor;
    element.matrix.c = c * factor;
    element.matrix.d = d * factor;
}

function wdkBuildPart(mode:String, suffix:String, glowScale:Float = 1):FunkinSprite
{
    var atlasPath:String = Paths.getPath('images/${dad.imageFile}', null, PathsTestMode.LOOSE);
    var settings:Dynamic = {
        cacheOnLoad: mode != 'excluded',
        onSymbolCreate: function(item:Dynamic) wdkSetupSymbol(item, mode, glowScale)
    };
    var frames:FlxAnimateFrames = FlxAnimateFrames.fromAnimate(atlasPath, null, null, 'shaderParts_${suffix}_${dad.curCharacter}', true, settings);
    if (frames == null) return null;
    var sprite:FunkinSprite = new FunkinSprite(0, 0);
    sprite.frames = frames;
    var addedAnimations:Int = 0;
    var rootSymbols:Array<String> = [];
    for (anim in dad.animations)
    {
        if (anim == null) continue;
        var animName:String = '' + anim.anim;
        var symbolName:String = '' + anim.name;
        if (animName == '' || symbolName == '') continue;
        if (anim.indices != null && anim.indices.length > 0)
            sprite.addAnimByIndices(animName, symbolName, anim.indices, anim.fps, anim.loop, anim.flipX, anim.flipY);
        else
            sprite.addAnimByPrefix(animName, symbolName, anim.fps, anim.loop, anim.flipX, anim.flipY);
        if (dad.animSuffix != null && dad.animSuffix != '')
        {
            var suffixedName:String = animName + dad.animSuffix;
            if (!sprite.hasAnim(suffixedName))
            {
                if (anim.indices != null && anim.indices.length > 0)
                    sprite.addAnimByIndices(suffixedName, symbolName, anim.indices, anim.fps, anim.loop, anim.flipX, anim.flipY);
                else
                    sprite.addAnimByPrefix(suffixedName, symbolName, anim.fps, anim.loop, anim.flipX, anim.flipY);
            }
        }
        if (rootSymbols.indexOf(symbolName) == -1) rootSymbols.push(symbolName);
        addedAnimations++;
    }
    if (addedAnimations == 0)
    {
        sprite.destroy();
        return null;
    }
    if (mode != 'excluded') wdkSetLayerOrder(sprite, rootSymbols, mode == 'foreground');
    sprite.shader = null;
    sprite.useRenderTexture = false;
    sprite.cameras = [camGame];
    sprite.scrollFactor.set(dad.scrollFactor.x, dad.scrollFactor.y);
    sprite.active = false;
    sprite.visible = false;
    if (whiteDkPartsLayer == null) return sprite;
    whiteDkPartsLayer.add(sprite);
    return sprite;
}

function wdkSetupParts():Bool
{
    if (!wdkHasParts(dad) || dadRim == null || dadForegroundRim == null || game == null || game.dadGroup == null) return false;
    if (whiteDkPartsLayer != null && whiteDkHaloOverlay != null && whiteDkGlowOverlay != null && whiteDkGlowMidOverlay != null && whiteDkGlowWideOverlay != null && whiteDkBodyBackOverlay != null && whiteDkBodyFrontOverlay != null && whiteDkOverlayCharacter == dad.curCharacter) return true;
    wdkDisposeLayers();
    whiteDkPartsLayer = new FlxSpriteGroup(0, 0);
    whiteDkPartsLayer.zIndex = dad.zIndex;
    whiteDkPartsLayer.visible = false;
    game.dadGroup.add(whiteDkPartsLayer);
    whiteDkBodyBackOverlay = wdkBuildPart('background', 'body_back', 1);
    whiteDkGlowWideOverlay = wdkBuildPart('excluded', 'excluded_glow_wide', 1.34);
    whiteDkGlowMidOverlay = wdkBuildPart('excluded', 'excluded_glow_mid', 1.20);
    whiteDkGlowOverlay = wdkBuildPart('excluded', 'excluded_glow_near', 1.075);
    whiteDkHaloOverlay = wdkBuildPart('excluded', 'excluded', 1);
    whiteDkBodyFrontOverlay = wdkBuildPart('foreground', 'body_front', 1);
    if (whiteDkBodyBackOverlay == null || whiteDkGlowWideOverlay == null || whiteDkGlowMidOverlay == null || whiteDkGlowOverlay == null || whiteDkHaloOverlay == null || whiteDkBodyFrontOverlay == null)
    {
        wdkDisposeLayers();
        return false;
    }
    whiteDkBodyBackOverlay.zIndex = 0;
    whiteDkGlowWideOverlay.zIndex = 1;
    whiteDkGlowMidOverlay.zIndex = 2;
    whiteDkGlowOverlay.zIndex = 3;
    whiteDkHaloOverlay.zIndex = 4;
    whiteDkBodyFrontOverlay.zIndex = 5;
    whiteDkOverlayCharacter = dad.curCharacter;
    refreshZ(whiteDkPartsLayer);
    refreshZ(game.dadGroup);
    return true;
}

function wdkSyncPart(sprite:FunkinSprite, shouldShow:Bool):Void
{
    if (sprite == null || dad == null) return;
    if (!whiteDkOriginalVisible || !dad.exists || dad.alpha <= 0)
    {
        sprite.visible = false;
        return;
    }
    var animName:String = dad.getAnimName();
    if (animName != null && animName != '' && sprite.hasAnim(animName) && sprite.getAnimName() != animName)
    {
        sprite.playAnim(animName, true, false);
        if (sprite.animation.curAnim != null) sprite.animation.curAnim.pause();
    }
    if (sprite.animation.curAnim == null)
    {
        sprite.visible = false;
        return;
    }
    if (dad.animation.curAnim != null && sprite.animation.curAnim != null)
    {
        var sourceFrames:Int = dad.animation.curAnim.numFrames;
        var overlayFrames:Int = sprite.animation.curAnim.numFrames;
        if (sourceFrames > 0 && overlayFrames > 0)
        {
            var sourceFrame:Int = Std.int(FlxMath.bound(dad.animation.curAnim.curFrame, 0, sourceFrames - 1));
            var overlayFrame:Int = sourceFrames == overlayFrames ? sourceFrame : Math.round((sourceFrames <= 1 ? 0 : sourceFrame / (sourceFrames - 1)) * (overlayFrames - 1));
            overlayFrame = Std.int(FlxMath.bound(overlayFrame, 0, overlayFrames - 1));
            if (sprite.animation.curAnim.curFrame != overlayFrame)
                sprite.animation.curAnim.curFrame = overlayFrame;
        }
    }
    sprite.x = dad.x;
    sprite.y = dad.y;
    sprite.scale.set(dad.scale.x, dad.scale.y);
    sprite.baseScale.set(dad.baseScale.x, dad.baseScale.y);
    sprite.baseFlipX = dad.baseFlipX;
    sprite.baseFlipY = dad.baseFlipY;
    sprite.scalableOffsets = dad.scalableOffsets;
    sprite.rotatableOffsets = dad.rotatableOffsets;
    sprite.skewableOffsets = dad.skewableOffsets;
    sprite.angle = dad.angle;
    sprite.skew.set(dad.skew.x, dad.skew.y);
    sprite.flipX = dad.flipX;
    sprite.flipY = dad.flipY;
    sprite.alpha = dad.alpha;
    sprite.color = dad.color;
    sprite.blend = dad.blend;
    sprite.offset.set(dad.offset.x, dad.offset.y);
    sprite.origin.set(dad.origin.x, dad.origin.y);
    sprite.spriteOffset.set(dad.spriteOffset.x, dad.spriteOffset.y);
    sprite.animOffset.set(dad.animOffset.x, dad.animOffset.y);
    sprite.scrollFactor.set(dad.scrollFactor.x, dad.scrollFactor.y);
    sprite.cameras = dad.cameras;
    sprite.antialiasing = dad.antialiasing;
    sprite.active = false;
    sprite.visible = shouldShow;
}

function wdkRefreshParts():Void
{
    if (dad == null) return;
    if (whiteDkSource != dad || whiteDkSourceCharacter != dad.curCharacter)
    {
        if (whiteDkHidden && whiteDkSource != null) whiteDkSource.visible = whiteDkOriginalVisible;
        whiteDkHidden = false;
        wdkDisposeLayers();
        whiteDkSource = dad;
        whiteDkSourceCharacter = dad.curCharacter;
    }
    var hasHaloParts:Bool = wdkHasParts(dad);
    var shouldSplit:Bool = ClientPrefs.shaders && hasHaloParts && dadRim != null && dadForegroundRim != null && game != null && game.dadGroup != null;
    if (shouldSplit && !wdkSetupParts()) shouldSplit = false;
    if (!shouldSplit)
    {
        if (whiteDkHidden && whiteDkSource != null) whiteDkSource.visible = whiteDkOriginalVisible;
        whiteDkHidden = false;
        if (whiteDkPartsLayer != null) whiteDkPartsLayer.visible = false;
        for (sprite in [whiteDkHaloOverlay, whiteDkGlowWideOverlay, whiteDkGlowMidOverlay, whiteDkGlowOverlay, whiteDkBodyBackOverlay, whiteDkBodyFrontOverlay])
            if (sprite != null) sprite.visible = false;
        if (dadRim != null && whiteDkBodyBackOverlay != null && dadRim.attachedSprite == whiteDkBodyBackOverlay) dadRim.attachedSprite = null;
        if (dadForegroundRim != null && whiteDkBodyFrontOverlay != null && dadForegroundRim.attachedSprite == whiteDkBodyFrontOverlay) dadForegroundRim.attachedSprite = null;
        if (ClientPrefs.shaders && dadRim != null)
        {
            dad.useRenderTexture = true;
            if (dadRim.attachedSprite != dad) dadRim.attachedSprite = dad;
            dad.shader = dadRim;
        }
        else
        {
            dad.shader = null;
            dad.useRenderTexture = false;
        }
        return;
    }
    if (!whiteDkHidden)
    {
        whiteDkOriginalVisible = dad.visible;
        dad.shader = null;
        dad.visible = false;
        whiteDkHidden = true;
    }
    else
    {
        dad.shader = null;
        dad.visible = false;
    }
    if (whiteDkPartsLayer.zIndex != dad.zIndex)
    {
        whiteDkPartsLayer.zIndex = dad.zIndex;
        refreshZ(game.dadGroup);
    }
    wdkSyncPart(whiteDkBodyBackOverlay, whiteDkOriginalVisible);
    wdkSyncPart(whiteDkGlowWideOverlay, whiteDkOriginalVisible);
    wdkSyncPart(whiteDkGlowMidOverlay, whiteDkOriginalVisible);
    wdkSyncPart(whiteDkGlowOverlay, whiteDkOriginalVisible);
    wdkSyncPart(whiteDkHaloOverlay, whiteDkOriginalVisible);
    wdkSyncPart(whiteDkBodyFrontOverlay, whiteDkOriginalVisible);
    whiteDkGlowWideOverlay.color = 0xFFFFD34A;
    whiteDkGlowWideOverlay.alpha = dad.alpha * 0.10;
    whiteDkGlowWideOverlay.blend = BlendMode.ADD;
    whiteDkGlowMidOverlay.color = 0xFFFFC83A;
    whiteDkGlowMidOverlay.alpha = dad.alpha * 0.16;
    whiteDkGlowMidOverlay.blend = BlendMode.ADD;
    whiteDkGlowOverlay.color = 0xFFFFD84A;
    whiteDkGlowOverlay.alpha = dad.alpha * 0.24;
    whiteDkGlowOverlay.blend = BlendMode.ADD;
    whiteDkPartsLayer.visible = whiteDkOriginalVisible && dad.exists && dad.alpha > 0;
    if (!whiteDkBodyBackOverlay.useRenderTexture) whiteDkBodyBackOverlay.useRenderTexture = true;
    if (!whiteDkBodyFrontOverlay.useRenderTexture) whiteDkBodyFrontOverlay.useRenderTexture = true;
    if (dadRim.attachedSprite != whiteDkBodyBackOverlay) dadRim.attachedSprite = whiteDkBodyBackOverlay;
    if (dadForegroundRim.attachedSprite != whiteDkBodyFrontOverlay) dadForegroundRim.attachedSprite = whiteDkBodyFrontOverlay;
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
    applyDarkLightEffect(blackanim, -85, -25);
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
    dadForegroundRim = createDarkLightShader(-85, -35);
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
            if (bothSing)
            {
                playHUD.healthBar.setColors(black.healthColour, boyfriend.healthColour);
                if (hasColor) playHUD.scoreTxt.color = black.healthColour;
            }
            else refreshDoubleKillIcon();
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
    else if (note.noteType == 'Both Opponents Sing')
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
    if (whiteDkHidden && whiteDkSource != null) whiteDkSource.visible = whiteDkOriginalVisible;
    whiteDkHidden = false;
    wdkDisposeLayers();
    restoreOriginalBlackDkEye();

    if (blackDkEyeOverlay != null)
    {
        blackDkEyeOverlay.destroy();
        blackDkEyeOverlay = null;
    }

    blackDkEyeAnim = '';
}