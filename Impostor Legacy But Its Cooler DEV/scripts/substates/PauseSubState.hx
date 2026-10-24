import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.graphics.frames.FlxAtlasFrames;

var xmlPausePortrait:FlxSprite = null;

var xmlPausePortraitName:String = '';
var xmlPausePortraitCreated:Bool = false;

var PAUSE_PORTRAIT_FPS:Int = 24;
var PAUSE_PORTRAIT_ANIMATION:String = 'pausePortrait';

var ORIGINAL_PORTRAIT_WIDTH:Int = 1215;
var ORIGINAL_PORTRAIT_HEIGHT:Int = 1097;

var XML_PORTRAIT_WIDTH:Int = 883;
var XML_PORTRAIT_HEIGHT:Int = 885;


// ============================================================
// CREATE
// ============================================================

function onCreatePost()
{
    xmlPausePortraitName = getPausePortraitName();

    xmlPausePortraitCreated = false;
}


// ============================================================
// PEGAR O NOME DO RETRATO
// ============================================================

function getPausePortraitName():String
{
    try
    {
        if (PlayState.instance.pauseOverride != '')
        {
            return Std.string(
                PlayState.instance.pauseOverride
            );
        }

        if (PlayState.instance.dad != null)
        {
            if (PlayState.instance.dad.pausePortrait != '')
            {
                return Std.string(
                    PlayState.instance.dad.pausePortrait
                );
            }

            return Std.string(
                PlayState.instance.dad.curCharacter
            );
        }
    }
    catch (e:Dynamic)
    {
        return '';
    }

    return '';
}


// ============================================================
// UPDATE
// ============================================================

function onUpdate(elapsed:Float)
{
    /*
        Espera o PauseSubState terminar de criar
        e adicionar o pauseGroup.

        Assim o XML fica por cima do retrato PNG.
    */

    if (!xmlPausePortraitCreated)
    {
        if (xmlPausePortraitName != null &&
            xmlPausePortraitName != '')
        {
            var xmlPath:String =
                'images/menu/freeplay/portraits/' +
                xmlPausePortraitName +
                '.xml';

            if (Paths.fileExists(xmlPath))
            {
                createXMLPausePortrait(
                    xmlPausePortraitName
                );
            }
        }

        xmlPausePortraitCreated = true;
    }
}


// ============================================================
// CRIAR RETRATO XML
// ============================================================

function createXMLPausePortrait(portraitName:String)
{
    var basePath:String =
        'menu/freeplay/portraits/' +
        portraitName;

    var atlas:FlxAtlasFrames = null;

    try
    {
        atlas = Paths.getSparrowAtlas(basePath);
    }
    catch (e:Dynamic)
    {
        return;
    }

    if (atlas == null)
        return;

    if (atlas.frames == null)
        return;

    if (atlas.frames.length <= 0)
        return;


    // ========================================================
    // SPRITE
    // ========================================================

    xmlPausePortrait = new FlxSprite(0, -125);

    xmlPausePortrait.frames = atlas;

    xmlPausePortrait.updateHitbox();


    // ========================================================
    // OFFSET
    // ========================================================

    xmlPausePortrait.offset.x =
        (XML_PORTRAIT_WIDTH -
        ORIGINAL_PORTRAIT_WIDTH) * 0.5;

    xmlPausePortrait.offset.y =
        (XML_PORTRAIT_HEIGHT -
        ORIGINAL_PORTRAIT_HEIGHT) * 0.5;


    // ========================================================
    // FRAMES
    // ========================================================

    var indices:Array<Int> = [];

    for (i in 0...atlas.frames.length)
    {
        indices.push(i);
    }


    // ========================================================
    // ANIMAÇÃO
    // ========================================================

    xmlPausePortrait.animation.add(
        PAUSE_PORTRAIT_ANIMATION,
        indices,
        PAUSE_PORTRAIT_FPS,
        true
    );


    xmlPausePortrait.animation.play(
        PAUSE_PORTRAIT_ANIMATION,
        true
    );


    // ========================================================
    // POSIÇÃO INICIAL
    // ========================================================

    xmlPausePortrait.x = FlxG.width;


    // ========================================================
    // ADICIONAR POR ÚLTIMO
    // ========================================================

    add(xmlPausePortrait);


    // ========================================================
    // MESMO MOVIMENTO DO RETRATO ORIGINAL
    // ========================================================

    FlxTween.tween(
        xmlPausePortrait,
        {x: 304.65},
        0.3,
        {
            ease: FlxEase.circOut
        }
    );
}


// ============================================================
// DESTROY
// ============================================================

function onDestroy()
{
    if (xmlPausePortrait != null)
    {
        xmlPausePortrait.destroy();
        xmlPausePortrait = null;
    }

    xmlPausePortraitName = '';
    xmlPausePortraitCreated = false;
}