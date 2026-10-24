import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;


// ============================================================
// PORTRAIT XML
// ============================================================

var xmlPortraitName:String = '';
var xmlPortraitApplied:String = '';
var xmlPortraitPending:Bool = false;

var PORTRAIT_FPS:Int = 24;
var PORTRAIT_ANIMATION_NAME:String = 'idle';


// ============================================================
// TAMANHO DO PORTRAIT
// ============================================================

var ORIGINAL_PORTRAIT_WIDTH:Int = 1215;
var ORIGINAL_PORTRAIT_HEIGHT:Int = 1097;

var XML_PORTRAIT_WIDTH:Int = 883;
var XML_PORTRAIT_HEIGHT:Int = 885;


// ============================================================
// CREATE
// ============================================================

function onCreatePost()
{
    xmlPortraitName = '';
    xmlPortraitApplied = '';
    xmlPortraitPending = true;
}


// ============================================================
// QUANDO O PORTRAIT MUDA
// ============================================================

function onPortraitChange(porty:String, prevPort:String)
{
    xmlPortraitName = Std.string(porty);
    xmlPortraitPending = true;
}


// ============================================================
// UPDATE
// ============================================================

function onUpdate(elapsed:Float)
{
    if (parent == null)
        return;

    if (parent.portrait == null)
        return;


    var portraitName:String = '';


    if (xmlPortraitName != null &&
        xmlPortraitName != '')
    {
        portraitName = xmlPortraitName;
    }
    else
    {
        try
        {
            if (parent.week_songs != null &&
                parent.curSelect >= 0 &&
                parent.curSelect < parent.week_songs.length)
            {
                portraitName =
                    Std.string(
                        parent.week_songs[
                            parent.curSelect
                        ].portrait
                    );
            }
        }
        catch (e:Dynamic)
        {
            return;
        }
    }


    if (portraitName == null ||
        portraitName == '')
        return;


    if (xmlPortraitPending ||
        xmlPortraitApplied != portraitName)
    {
        applyXMLPortrait(
            portraitName
        );
    }
}


// ============================================================
// APLICA O XML
// ============================================================

function applyXMLPortrait(portraitName:String)
{
    var portrait:FlxSprite =
        parent.portrait;


    if (portrait == null)
        return;


    var basePath:String =
        'menu/freeplay/portraits/'
        + portraitName;


    var xmlPath:String =
        'images/'
        + basePath
        + '.xml';


    // --------------------------------------------------------
    // Se não tiver XML, mantém o portrait normal
    // --------------------------------------------------------

    if (!Paths.fileExists(xmlPath))
    {
        xmlPortraitApplied =
            portraitName;

        xmlPortraitPending =
            false;

        return;
    }


    try
    {
        var atlas:FlxAtlasFrames =
            Paths.getSparrowAtlas(
                basePath
            );


        if (atlas == null)
            return;


        if (atlas.frames.length <= 0)
            return;


        // ----------------------------------------------------
        // ATLAS
        // ----------------------------------------------------

        portrait.frames =
            atlas;

        portrait.updateHitbox();


        // ----------------------------------------------------
        // CORREÇÃO DE POSIÇÃO
        // ----------------------------------------------------

        portrait.offset.x =
            (
                XML_PORTRAIT_WIDTH
                - ORIGINAL_PORTRAIT_WIDTH
            ) * 0.5;


        portrait.offset.y =
            (
                XML_PORTRAIT_HEIGHT
                - ORIGINAL_PORTRAIT_HEIGHT
            ) * 0.5;


        // ----------------------------------------------------
        // FRAMES
        // ----------------------------------------------------

        var indices:Array<Int> = [];


        for (i in 0...atlas.frames.length)
        {
            indices.push(i);
        }


        // ----------------------------------------------------
        // ANIMAÇÃO
        // ----------------------------------------------------

        portrait.animation.add(
            PORTRAIT_ANIMATION_NAME,
            indices,
            PORTRAIT_FPS,
            true
        );


        portrait.animation.play(
            PORTRAIT_ANIMATION_NAME,
            true
        );


        // ----------------------------------------------------
        // FINALIZA
        // ----------------------------------------------------

        xmlPortraitApplied =
            portraitName;

        xmlPortraitPending =
            false;
    }
    catch (e:Dynamic)
    {
        xmlPortraitPending =
            false;
    }
}


// ============================================================
// DESTROY
// ============================================================

function onDestroy()
{
    xmlPortraitName = '';
    xmlPortraitApplied = '';
    xmlPortraitPending = false;
}