import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.graphics.frames.FlxAtlasFrames;
import funkin.Mods;
import haxe.Json;
import Reflect;
import sys.FileSystem;
import sys.io.File;

var xmlPausePortrait:FlxSprite = null;
var xmlPausePortraitName:String = '';
var xmlPausePortraitCreated:Bool = false;
var xmlPausePortraitPack:String = 'Default';
var xmlPausePortraitModFolder:String = '';

var PAUSE_PORTRAIT_FPS:Int = 24;
var PAUSE_PORTRAIT_ANIMATION:String = 'pausePortrait';
var ORIGINAL_PORTRAIT_WIDTH:Int = 1215;
var ORIGINAL_PORTRAIT_HEIGHT:Int = 1097;
var XML_PORTRAIT_WIDTH:Int = 883;
var XML_PORTRAIT_HEIGHT:Int = 885;

function onCreatePost()
{
    xmlPausePortraitName = getPausePortraitName();
    xmlPausePortraitCreated = false;

    try
    {
        if (modFolder != null && Std.string(modFolder) != '')
            xmlPausePortraitModFolder = Std.string(modFolder);
    }
    catch (e:Dynamic) {}

    if (xmlPausePortraitModFolder == '')
        xmlPausePortraitModFolder = 'Impostor Legacy But Its Cooler DEV';

    xmlPausePortraitPack = loadSelectedPortraitPack();
}

function loadSelectedPortraitPack():String
{
    var path:String = Paths.mods(xmlPausePortraitModFolder + '/scripts/storage/appearancePacks.json');

    try
    {
        if (FileSystem.exists(path))
        {
            var data:Dynamic = Json.parse(File.getContent(path));
            if (data != null && Reflect.hasField(data, 'portraitPack'))
            {
                var value:String = Std.string(Reflect.field(data, 'portraitPack'));
                if (value != '') return value;
            }
        }
    }
    catch (e:Dynamic)
    {
        trace('[LBIC Appearance] Could not read portrait pack setting: ' + e);
    }

    return 'Default';
}

function getPausePortraitName():String
{
    try
    {
        if (PlayState.instance.pauseOverride != '')
            return Std.string(PlayState.instance.pauseOverride);

        if (PlayState.instance.dad != null)
        {
            if (PlayState.instance.dad.pausePortrait != '')
                return Std.string(PlayState.instance.dad.pausePortrait);

            return Std.string(PlayState.instance.dad.curCharacter);
        }
    }
    catch (e:Dynamic)
    {
        return '';
    }

    return '';
}

function portraitAtlasExists(atlasKey:String, strictPack:Bool):Bool
{
    if (!strictPack)
        return Paths.fileExists('images/' + atlasKey + '.png')
            && Paths.fileExists('images/' + atlasKey + '.xml');

    var previous:Dynamic = Mods.currentModDirectory;
    var found:Bool = false;
    try
    {
        Mods.currentModDirectory = xmlPausePortraitModFolder;
        found = Paths.fileExists('images/' + atlasKey + '.png', null, PathsTestMode.STRICT)
            && Paths.fileExists('images/' + atlasKey + '.xml', null, PathsTestMode.STRICT);
    }
    catch (e:Dynamic) {}
    Mods.currentModDirectory = previous;
    return found;
}

function resolvePausePortraitAtlas(portraitName:String):String
{
    if (portraitName == null || portraitName == '') return '';

    if (xmlPausePortraitPack != 'Default')
    {
        var packedKey:String = 'menu/freeplay/portraits/' + xmlPausePortraitPack + '/' + portraitName;
        return portraitAtlasExists(packedKey, true) ? packedKey : '';
    }

     
     
    var defaultKey:String = 'menu/freeplay/portraits/' + portraitName;
    return portraitAtlasExists(defaultKey, false) ? defaultKey : '';
}

function loadPausePortraitAtlas(atlasKey:String):FlxAtlasFrames
{
    var atlas:FlxAtlasFrames = null;
    try
    {
        if (xmlPausePortraitPack == 'Default')
        {
             
            atlas = Paths.getSparrowAtlas(atlasKey);
        }
        else
        {
            var previous:Dynamic = Mods.currentModDirectory;
            Mods.currentModDirectory = xmlPausePortraitModFolder;
            atlas = Paths.getSparrowAtlas(atlasKey, null, true, PathsTestMode.STRICT);
            Mods.currentModDirectory = previous;
        }
    }
    catch (e:Dynamic)
    {
        trace('[LBIC Appearance] Could not load pause portrait atlas ' + atlasKey + ': ' + e);
    }
    return atlas;
}

function onUpdate(elapsed:Float)
{
    if (xmlPausePortraitCreated) return;

    if (xmlPausePortraitName != null && xmlPausePortraitName != '')
    {
        var atlasKey:String = resolvePausePortraitAtlas(xmlPausePortraitName);
        if (atlasKey != '')
            createXMLPausePortrait(xmlPausePortraitName, atlasKey);
    }

    xmlPausePortraitCreated = true;
}

function createXMLPausePortrait(portraitName:String, atlasKey:String)
{
    var atlas:FlxAtlasFrames = loadPausePortraitAtlas(atlasKey);
    if (atlas == null || atlas.frames == null || atlas.frames.length <= 0)
        return;

    xmlPausePortrait = new FlxSprite(0, -125);
    xmlPausePortrait.frames = atlas;
    xmlPausePortrait.updateHitbox();

    xmlPausePortrait.offset.x = (XML_PORTRAIT_WIDTH - ORIGINAL_PORTRAIT_WIDTH) * 0.5;
    xmlPausePortrait.offset.y = (XML_PORTRAIT_HEIGHT - ORIGINAL_PORTRAIT_HEIGHT) * 0.5;

    var indices:Array<Int> = [];
    for (i in 0...atlas.frames.length)
        indices.push(i);

    xmlPausePortrait.animation.add(PAUSE_PORTRAIT_ANIMATION, indices, PAUSE_PORTRAIT_FPS, true);
    xmlPausePortrait.animation.play(PAUSE_PORTRAIT_ANIMATION, true);
    xmlPausePortrait.x = FlxG.width;

    add(xmlPausePortrait);
    FlxTween.tween(xmlPausePortrait, {x: 304.65}, 0.3, {ease: FlxEase.circOut});
}

function onDestroy()
{
    if (xmlPausePortrait != null)
    {
        xmlPausePortrait.destroy();
        xmlPausePortrait = null;
    }

    xmlPausePortraitName = '';
    xmlPausePortraitCreated = false;
    xmlPausePortraitPack = 'Default';
    xmlPausePortraitModFolder = '';
}
