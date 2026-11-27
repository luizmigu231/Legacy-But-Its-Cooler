package funkin.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import funkin.Mods;
import funkin.objects.HealthIcon;
import haxe.Json;
import Reflect;
import Type;
import sys.FileSystem;
import sys.io.File;

var appearanceModFolder:String = '';  
var appearanceModRoot:String = '';
var appearanceConfigPath:String = '';
var appearanceInitialized:Bool = false;
var defeatBacklitSetting:String = 'On';
var appearanceSettingsPath:String = '';
var defeatBacklitTitle:FlxText = null;
var defeatBacklitSubtitle:FlxText = null;
var defeatBacklitValueText:FlxText = null;
var defeatBacklitStatusText:FlxText = null;
var defeatBacklitCard:FlxSprite = null;

var iconPacks:Array<String> = ['Default'];
var portraitPacks:Array<String> = ['Default'];
var selectedIconPack:String = 'Default';
var selectedPortraitPack:String = 'Default';

var configButton:FlxSprite = null;
var configButtonText:FlxText = null;
var panelOpen:Bool = false;
var panelObjects:Array<Dynamic> = [];
var panelButtons:Array<Dynamic> = [];
var panelButtonActions:Array<Dynamic> = [];
var iconPackTitle:FlxText = null;
var portraitPackTitle:FlxText = null;
var iconPackValueText:FlxText = null;
var portraitPackValueText:FlxText = null;
var iconPackCountText:FlxText = null;
var portraitPackCountText:FlxText = null;
var iconPackCard:FlxSprite = null;
var portraitPackCard:FlxSprite = null;
var panelCloseButton:FlxSprite = null;
var appliedIconCache:Array<Dynamic> = [];
var appliedPortraitCache:Array<Dynamic> = [];
var iconLookupCache:Array<Dynamic> = [];
var portraitLookupCache:Array<Dynamic> = [];
var activeRow:Int = 0;
var activeTab:Int = 0;
var appearanceTabButtons:Array<Dynamic> = [];
var appearanceTabLabels:Array<Dynamic> = [];
var appearanceTabContentObjects:Array<Dynamic> = [];
var backlitTabContentObjects:Array<Dynamic> = [];
var appearanceTabIconPreview:FlxSprite = null;
var scanElapsed:Float = 0;
var lastAppearanceState:Dynamic = null;
var previousMenuLockMovement:Bool = false;
var hadPreviousMenuLockMovement:Bool = false;

function initializeAppearancePacks()
{
    if (appearanceInitialized) return;

    try
    {
        if (modFolder != null && Std.string(modFolder) != '')
            appearanceModFolder = Std.string(modFolder);
    }
    catch (e:Dynamic) {}

    if (appearanceModFolder == '')
        appearanceModFolder = 'Impostor Legacy But Its Cooler DEV';

    appearanceModRoot = Paths.mods(appearanceModFolder);
    appearanceConfigPath = appearanceModRoot + '/scripts/storage/appearancePacks.json';
    appearanceSettingsPath = appearanceModRoot + '/settings.json';

    refreshPackLists();
    loadAppearanceConfig();
    loadDefeatBacklitSetting();
    appearanceInitialized = true;
}

function refreshPackLists()
{
    iconPacks = listPacks(appearanceModRoot + '/images/icons');
    portraitPacks = listPacks(appearanceModRoot + '/images/menu/freeplay/portraits');
}

function listPacks(directory:String):Array<String>
{
    var result:Array<String> = ['Default'];

    try
    {
        if (!FileSystem.exists(directory) || !FileSystem.isDirectory(directory))
            return result;

        for (entry in FileSystem.readDirectory(directory))
        {
            if (entry == null || entry == '' || entry == '.' || entry == '..' || entry == 'Default')
                continue;

            var path:String = directory + '/' + entry;
            if (FileSystem.exists(path) && FileSystem.isDirectory(path))
                result.push(entry);
        }
    }
    catch (e:Dynamic)
    {
        trace('[LBIC Appearance] Failed to list ' + directory + ': ' + e);
    }

    result.sort(function(a:String, b:String) return Reflect.compare(a.toLowerCase(), b.toLowerCase()));
    return result;
}

function loadAppearanceConfig()
{
    var data:Dynamic = null;

    try
    {
        if (FileSystem.exists(appearanceConfigPath))
            data = Json.parse(File.getContent(appearanceConfigPath));
    }
    catch (e:Dynamic)
    {
        trace('[LBIC Appearance] Failed to read appearancePacks.json: ' + e);
    }

    if (data != null)
    {
        if (Reflect.hasField(data, 'iconPack'))
            selectedIconPack = Std.string(Reflect.field(data, 'iconPack'));

        if (Reflect.hasField(data, 'portraitPack'))
            selectedPortraitPack = Std.string(Reflect.field(data, 'portraitPack'));
    }

    if (!iconPacks.contains(selectedIconPack)) selectedIconPack = 'Default';
    if (!portraitPacks.contains(selectedPortraitPack)) selectedPortraitPack = 'Default';

    saveAppearanceConfig();
}

function saveAppearanceConfig()
{
    try
    {
        var folder:String = appearanceModRoot + '/scripts/storage';
        if (!FileSystem.exists(folder)) FileSystem.createDirectory(folder);

        var data:Dynamic = {
            iconPack: selectedIconPack,
            portraitPack: selectedPortraitPack
        };

        File.saveContent(appearanceConfigPath, Json.stringify(data, null, '\t'));
    }
    catch (e:Dynamic)
    {
        trace('[LBIC Appearance] Failed to save appearancePacks.json: ' + e);
    }
}

function loadDefeatBacklitSetting()
{
    var settings:Dynamic = null;
    try
    {
        if (FileSystem.exists(appearanceSettingsPath))
            settings = Json.parse(File.getContent(appearanceSettingsPath));
    }
    catch (e:Dynamic)
    {
        trace('[LBIC Appearance] Failed to read settings.json: ' + e);
    }

    if (settings != null && Reflect.hasField(settings, 'Backlit'))
        defeatBacklitSetting = Std.string(Reflect.field(settings, 'Backlit'));

    if (defeatBacklitSetting != 'Off') defeatBacklitSetting = 'On';
}

function saveDefeatBacklitSetting()
{
    var settings:Dynamic = {};
    try
    {
        if (FileSystem.exists(appearanceSettingsPath))
            settings = Json.parse(File.getContent(appearanceSettingsPath));
    }
    catch (e:Dynamic) {}

    if (settings == null) settings = {};
    Reflect.setField(settings, 'Backlit', defeatBacklitSetting);

    try
    {
        File.saveContent(appearanceSettingsPath, Json.stringify(settings, null, '\t'));
    }
    catch (e:Dynamic)
    {
        trace('[LBIC Appearance] Failed to save Backlit setting: ' + e);
    }
}

function applyDefeatBacklitStage()
{
    var configPath:String = appearanceModRoot + '/scripts/storage/config.json';
    if (!FileSystem.exists(configPath)) return;

    var config:Dynamic = null;
    try { config = Json.parse(File.getContent(configPath)); }
    catch (e:Dynamic) { return; }
    if (config == null || !Reflect.hasField(config, 'defeat')) return;

    var defeatConfig:Dynamic = Reflect.field(config, 'defeat');
    if (defeatConfig == null) return;

    var stageOptions:Dynamic = Reflect.field(defeatConfig, 'stage');
    if (stageOptions == null || !Reflect.hasField(stageOptions, defeatBacklitSetting)) return;

    var stageName:String = Std.string(Reflect.field(stageOptions, defeatBacklitSetting));
    var sourceRelative:String = Std.string(Reflect.field(defeatConfig, 'source'));
    var destinationRelative:String = Std.string(Reflect.field(defeatConfig, 'destination'));
    if (stageName == '' || sourceRelative == '' || destinationRelative == '') return;

    var sourcePath:String = appearanceModRoot + '/' + sourceRelative;
    var destinationPath:String = appearanceModRoot + '/' + destinationRelative;
    var chart:Dynamic = null;

     
    try
    {
        if (FileSystem.exists(destinationPath))
            chart = Json.parse(File.getContent(destinationPath));
    }
    catch (e:Dynamic) { chart = null; }

    if (chart == null)
    {
        try
        {
            if (FileSystem.exists(sourcePath))
                chart = Json.parse(File.getContent(sourcePath));
        }
        catch (e:Dynamic) { chart = null; }
    }

    if (chart == null) return;

    var songData:Dynamic = chart;
    if (Reflect.hasField(chart, 'song')) songData = Reflect.field(chart, 'song');
    if (songData == null) return;

    Reflect.setField(songData, 'stage', stageName);

    try
    {
        var destinationFolder:String = destinationPath.substr(0, destinationPath.lastIndexOf('/'));
        if (!FileSystem.exists(destinationFolder)) FileSystem.createDirectory(destinationFolder);
        File.saveContent(destinationPath, Json.stringify(chart, null, '\t'));
    }
    catch (e:Dynamic)
    {
        trace('[LBIC Appearance] Failed to apply Defeat Backlit stage: ' + e);
    }
}

function cycleDefeatBacklit(direction:Int)
{
    defeatBacklitSetting = defeatBacklitSetting == 'On' ? 'Off' : 'On';
    saveDefeatBacklitSetting();
    applyDefeatBacklitStage();
    updateAppearancePanelLabels();
}

function isMainMenu():Bool
{
    if (FlxG.state == null) return false;
    return Type.getClassName(Type.getClass(FlxG.state)) == 'funkin.states.MainMenuState';
}

function strictFileExists(path:String):Bool
{
    var previous:Dynamic = Mods.currentModDirectory;
    var found:Bool = false;

    try
    {
        Mods.currentModDirectory = appearanceModFolder;
        found = Paths.fileExists(path, null, PathsTestMode.STRICT);
    }
    catch (e:Dynamic) {}

    Mods.currentModDirectory = previous;
    return found;
}

function strictImage(key:String, allowGPU:Bool):Dynamic
{
    var previous:Dynamic = Mods.currentModDirectory;
    var graphic:Dynamic = null;

    try
    {
        Mods.currentModDirectory = appearanceModFolder;
        graphic = Paths.image(key, null, allowGPU, PathsTestMode.STRICT);
    }
    catch (e:Dynamic)
    {
        trace('[LBIC Appearance] Could not load ' + key + ': ' + e);
    }

    Mods.currentModDirectory = previous;
    return graphic;
}

function getGraphicKey(sprite:Dynamic):String
{
    if (sprite == null || sprite.graphic == null) return '';
    try { return Std.string(Reflect.field(sprite.graphic, 'key')); }
    catch (e:Dynamic) { return ''; }
}

function isLBICOrLegacyAssetKey(key:String):Bool
{
    if (key == null || key == '') return false;

    var lbicImagesRoot:String = Paths.mods(appearanceModFolder + '/images/');
    var legacyImagesRoot:String = Paths.getCorePath('images/');

    return key.indexOf(lbicImagesRoot) == 0 || key.indexOf(legacyImagesRoot) == 0;
}

function isLBICOrLegacyGraphic(sprite:Dynamic):Bool
{
    return isLBICOrLegacyAssetKey(getGraphicKey(sprite));
}

function findAppearanceEntry(target:Dynamic, cache:Array<Dynamic>):Dynamic
{
    for (entry in cache)
        if (entry != null && entry.target == target)
            return entry;
    return null;
}

function removeAppearanceEntry(target:Dynamic, cache:Array<Dynamic>)
{
    var i:Int = cache.length - 1;
    while (i >= 0)
    {
        if (cache[i] != null && cache[i].target == target)
            cache.splice(i, 1);
        i--;
    }
}

function storeAppearanceEntry(entry:Dynamic, cache:Array<Dynamic>)
{
    removeAppearanceEntry(entry.target, cache);
    cache.push(entry);
    if (cache.length > 192) cache.shift();
}

function findLookupValue(cache:Array<Dynamic>, lookupKey:String):Dynamic
{
    for (entry in cache)
        if (entry != null && entry.key == lookupKey)
            return entry.value;
    return null;
}

function storeLookupValue(cache:Array<Dynamic>, lookupKey:String, value:Dynamic)
{
    cache.push({key: lookupKey, value: value});
    if (cache.length > 256) cache.shift();
}

function getIconImageKey(character:String):String
{
    if (selectedIconPack == 'Default' || character == null || character == '')
        return '';

    var lookupKey:String = selectedIconPack + '|' + character;
    var cached:Dynamic = findLookupValue(iconLookupCache, lookupKey);
    if (cached != null)
        return Std.string(cached) == '__MISSING__' ? '' : Std.string(cached);

    var candidates:Array<String> = [];
    candidates.push('icons/' + selectedIconPack + '/' + character);
    candidates.push('icons/' + selectedIconPack + '/icon-' + character);

    var result:String = '';
    for (candidate in candidates)
    {
        if (strictFileExists('images/' + candidate + '.png'))
        {
            result = candidate;
            break;
        }
    }

    storeLookupValue(iconLookupCache, lookupKey, result == '' ? '__MISSING__' : result);
    return result;
}

function loadHealthIconGraphic(icon:Dynamic, graphic:Dynamic, character:String, frameIndex:Int)
{
    if (icon == null || graphic == null || character == null || character == '') return;

    var frameCount:Int = Std.int(Math.round(Math.max(graphic.width / graphic.height, 1)));
    var frameWidth:Int = Std.int(graphic.width / frameCount);
    if (frameWidth <= 0 || graphic.height <= 0) return;

    var isPlayer:Bool = false;
    try { isPlayer = Reflect.field(icon, 'isPlayer') == true; } catch (e:Dynamic) {}

    icon.loadGraphic(graphic, true, frameWidth, Std.int(graphic.height));

    var offsets:Dynamic = Reflect.field(icon, 'iconOffsets');
    if (offsets != null && offsets.length >= 2)
    {
        offsets[0] = (frameWidth - 150) / 2;
        offsets[1] = (graphic.height - 150) / 2;
    }

    icon.updateHitbox();
    icon.animation.add(character, [for (i in 0...frameCount) i], 0, false, isPlayer);
    icon.animation.play(character, true);
    if (frameIndex >= 0 && frameIndex < frameCount)
        icon.animation.frameIndex = frameIndex;

    icon.antialiasing = StringTools.endsWith(character, '-pixel') ? false : ClientPrefs.globalAntialiasing;
}

function applyIconPack(icon:Dynamic)
{
    if (icon == null || !isLBICOrLegacyGraphic(icon))
    {
        if (icon != null) removeAppearanceEntry(icon, appliedIconCache);
        return;
    }

    var character:String = '';
    try { character = Std.string(icon.characterName); } catch (e:Dynamic) {}
    if (character == null || character == '') return;

    var currentKey:String = getGraphicKey(icon);
    var entry:Dynamic = findAppearanceEntry(icon, appliedIconCache);
    var stillUsingOurGraphic:Bool = entry != null
        && entry.character == character
        && entry.lastAppliedKey != ''
        && currentKey == entry.lastAppliedKey;

    if (selectedIconPack == 'Default')
    {
        if (stillUsingOurGraphic)
        {
            var frame:Int = 0;
            try { frame = icon.animation.frameIndex; } catch (e:Dynamic) {}
            loadHealthIconGraphic(icon, entry.originalGraphic, character, frame);
        }
        removeAppearanceEntry(icon, appliedIconCache);
        return;
    }

    var imageKey:String = getIconImageKey(character);
    if (imageKey == '')
    {
        if (stillUsingOurGraphic)
        {
            var frame:Int = 0;
            try { frame = icon.animation.frameIndex; } catch (e:Dynamic) {}
            loadHealthIconGraphic(icon, entry.originalGraphic, character, frame);
        }
        removeAppearanceEntry(icon, appliedIconCache);
        return;
    }

    if (entry == null || entry.character != character || !stillUsingOurGraphic)
    {
        entry = {
            target: icon,
            character: character,
            originalGraphic: icon.graphic,
            lastAppliedKey: '',
            pack: ''
        };
        storeAppearanceEntry(entry, appliedIconCache);
    }
    else if (entry.pack == selectedIconPack && stillUsingOurGraphic)
    {
        return;
    }

    var graphic:Dynamic = strictImage(imageKey, false);
    if (graphic == null || graphic.width <= 0 || graphic.height <= 0)
    {
        if (stillUsingOurGraphic)
        {
            var frame:Int = 0;
            try { frame = icon.animation.frameIndex; } catch (e:Dynamic) {}
            loadHealthIconGraphic(icon, entry.originalGraphic, character, frame);
        }
        removeAppearanceEntry(icon, appliedIconCache);
        return;
    }

    var stateFrame:Int = 0;
    try { stateFrame = icon.animation.frameIndex; } catch (e:Dynamic) {}
    loadHealthIconGraphic(icon, graphic, character, stateFrame);

    entry.pack = selectedIconPack;
    entry.lastAppliedKey = getGraphicKey(icon);
    storeAppearanceEntry(entry, appliedIconCache);
}

function getPortraitNameFromGraphic(sprite:Dynamic):String
{
    var key:String = getGraphicKey(sprite);
    if (key == '' || !StringTools.contains(key, 'menu/freeplay/portraits/'))
        return '';

    var marker:Int = key.lastIndexOf('portraits/');
    if (marker < 0) return '';

    var relative:String = key.substr(marker + 'portraits/'.length);
    var parts:Array<String> = relative.split('/');
    var name:String = parts[parts.length - 1];
    var dot:Int = name.lastIndexOf('.');
    if (dot > 0) name = name.substr(0, dot);
    return name;
}

function getGraphicKeyFromGraphic(graphic:Dynamic):String
{
    if (graphic == null) return '';
    try { return Std.string(Reflect.field(graphic, 'key')); }
    catch (e:Dynamic) { return ''; }
}

function getPortraitImageKey(name:String):String
{
    if (selectedPortraitPack == 'Default' || name == null || name == '')
        return '';

    var lookupKey:String = selectedPortraitPack + '|' + name;
    var cached:Dynamic = findLookupValue(portraitLookupCache, lookupKey);
    if (cached != null)
        return Std.string(cached) == '__MISSING__' ? '' : Std.string(cached);

    var candidate:String = 'menu/freeplay/portraits/' + selectedPortraitPack + '/' + name;
    var result:String = strictFileExists('images/' + candidate + '.png') ? candidate : '';
    storeLookupValue(portraitLookupCache, lookupKey, result == '' ? '__MISSING__' : result);
    return result;
}

function restorePortraitGraphic(sprite:Dynamic, entry:Dynamic)
{
    if (sprite == null || entry == null || entry.originalGraphic == null) return;
    sprite.loadGraphic(entry.originalGraphic);
    sprite.updateHitbox();
    sprite.offset.x = entry.originalOffsetX;
    sprite.offset.y = entry.originalOffsetY;
}

function applyPortraitPackNamed(sprite:Dynamic, name:String)
{
    if (sprite == null || name == null || name == '') return;

    var currentKey:String = getGraphicKey(sprite);
    var entry:Dynamic = findAppearanceEntry(sprite, appliedPortraitCache);

     
     
     
    var stillUsingEntryGraphic:Bool = entry != null
        && entry.lastAppliedKey != ''
        && currentKey == entry.lastAppliedKey;
    var sourceKey:String = currentKey;
    if (stillUsingEntryGraphic && entry.originalGraphic != null)
    {
        var originalKey:String = getGraphicKeyFromGraphic(entry.originalGraphic);
        if (originalKey != '') sourceKey = originalKey;
    }

    if (!isLBICOrLegacyAssetKey(sourceKey))
    {
        removeAppearanceEntry(sprite, appliedPortraitCache);
        return;
    }

    try
    {
        if (sprite.animation != null && sprite.animation.curAnim != null)
            return;
    }
    catch (e:Dynamic) {}

    var stillUsingOurGraphic:Bool = entry != null
        && entry.name == name
        && entry.lastAppliedKey != ''
        && currentKey == entry.lastAppliedKey;

    if (selectedPortraitPack == 'Default')
    {
        if (stillUsingOurGraphic)
            restorePortraitGraphic(sprite, entry);
        removeAppearanceEntry(sprite, appliedPortraitCache);
        return;
    }

    var imageKey:String = getPortraitImageKey(name);
    if (imageKey == '')
    {
        if (stillUsingOurGraphic)
            restorePortraitGraphic(sprite, entry);
        removeAppearanceEntry(sprite, appliedPortraitCache);
        return;
    }

    if (entry == null || entry.name != name || !stillUsingOurGraphic)
    {
        entry = {
            target: sprite,
            name: name,
            originalGraphic: sprite.graphic,
            originalOffsetX: sprite.offset.x,
            originalOffsetY: sprite.offset.y,
            lastAppliedKey: '',
            pack: ''
        };
        storeAppearanceEntry(entry, appliedPortraitCache);
    }
    else if (entry.pack == selectedPortraitPack && stillUsingOurGraphic)
    {
        return;
    }

    var graphic:Dynamic = strictImage(imageKey, true);
    if (graphic == null)
    {
        if (stillUsingOurGraphic)
            restorePortraitGraphic(sprite, entry);
        removeAppearanceEntry(sprite, appliedPortraitCache);
        return;
    }

    sprite.loadGraphic(graphic);
    sprite.updateHitbox();
    sprite.offset.x = (sprite.frameWidth - 1215) * 0.5 * sprite.scale.x;
    sprite.offset.y = (sprite.frameHeight - 1097) * 0.5 * sprite.scale.y;

    entry.pack = selectedPortraitPack;
    entry.lastAppliedKey = getGraphicKey(sprite);
    storeAppearanceEntry(entry, appliedPortraitCache);
}

function applyPortraitPack(sprite:Dynamic)
{
    var name:String = getPortraitNameFromGraphic(sprite);
    applyPortraitPackNamed(sprite, name);
}

function applyFreeplayPortraitPack(state:Dynamic)
{
    if (state == null) return;

    var portrait:Dynamic = null;
    var portraitName:String = '';
    try { portrait = Reflect.field(state, 'portrait'); } catch (e:Dynamic) {}
    try { portraitName = Std.string(Reflect.field(state, 'prevPort')); } catch (e:Dynamic) {}

     
     
    if (portrait != null && portraitName != '')
        applyPortraitPackNamed(portrait, portraitName);
}

function scanCardIcons(cards:Dynamic)
{
    if (cards == null) return;

    var cardMembers:Dynamic = null;
    try { cardMembers = Reflect.field(cards, 'members'); } catch (e:Dynamic) {}
    if (cardMembers == null) return;

    var count:Int = 0;
    try { count = Std.int(cardMembers.length); } catch (e:Dynamic) { count = 0; }
    if (count <= 0) return;

    for (i in 0...count)
    {
        var card:Dynamic = null;
        try { card = cardMembers[i]; } catch (e:Dynamic) {}
        if (card == null) continue;

        var isVisible:Bool = true;
        try { isVisible = card.visible != false && card.alpha > 0.01; } catch (e:Dynamic) {}
        if (!isVisible) continue;

        var intersectsScreen:Bool = true;
        try
        {
            intersectsScreen = card.x < FlxG.width && card.x + card.width > 0
                && card.y < FlxG.height && card.y + card.height > 0;
        }
        catch (e:Dynamic) {}
        if (!intersectsScreen) continue;

        var icon:Dynamic = null;
        try { icon = Reflect.field(card, 'icon'); } catch (e:Dynamic) {}
        if (icon != null) applyIconPack(icon);
    }
}

function scanPausePortrait(subState:Dynamic)
{
    if (subState == null) return;

    var subStateClass:String = '';
    try { subStateClass = Type.getClassName(Type.getClass(subState)); } catch (e:Dynamic) {}
    if (subStateClass != 'funkin.states.substates.PauseSubState') return;

    var pauseGroup:Dynamic = null;
    try { pauseGroup = Reflect.field(subState, 'pauseGroup'); } catch (e:Dynamic) {}
    if (pauseGroup == null) return;

    var members:Dynamic = null;
    try { members = Reflect.field(pauseGroup, 'members'); } catch (e:Dynamic) {}
    if (members == null) return;

     
    var portrait:Dynamic = null;
    try { portrait = members[2]; } catch (e:Dynamic) {}
    if (portrait != null) applyPortraitPack(portrait);
}

function scanAppearanceTargets()
{
    var state:Dynamic = FlxG.state;
    if (state == null) return;

    var stateClass:String = '';
    try { stateClass = Type.getClassName(Type.getClass(state)); } catch (e:Dynamic) {}

    if (stateClass == 'funkin.states.PlayState')
    {
        if (selectedIconPack != 'Default' || appliedIconCache.length > 0)
        {
            var hud:Dynamic = Reflect.field(state, 'playHUD');
            if (hud != null)
            {
                applyIconPack(Reflect.field(hud, 'iconP1'));
                applyIconPack(Reflect.field(hud, 'iconP2'));
            }
        }

        if (selectedPortraitPack != 'Default' || appliedPortraitCache.length > 0)
            scanPausePortrait(Reflect.field(state, 'subState'));
    }
    else if (stateClass == 'funkin.states.FreeplayState')
    {
        if (selectedIconPack != 'Default' || appliedIconCache.length > 0)
            scanCardIcons(Reflect.field(state, 'cards'));

        if (selectedPortraitPack != 'Default' || appliedPortraitCache.length > 0)
            applyFreeplayPortraitPack(state);
    }
    else if (stateClass == 'funkin.states.StoryMenuState')
    {
        if (selectedIconPack != 'Default' || appliedIconCache.length > 0)
        {
            applyIconPack(Reflect.field(state, 'weekLeftIcon'));
            applyIconPack(Reflect.field(state, 'weekRightIcon'));
        }
    }
}

function addPanelObject(target:Dynamic)
{
     
    target.scrollFactor.set(1, 1);
    FlxG.state.add(target);
    panelObjects.push(target);
}

function makePanelText(x:Float, y:Float, width:Float, text:String, size:Int, color:Dynamic, fontName:String):FlxText
{
    var result:FlxText = new FlxText(x, y, width, text, size);
    result.setFormat(Paths.font(fontName, false), size, color, 'center', FlxTextBorderStyle.OUTLINE, 0xFF14232B);
    result.borderSize = size >= 26 ? 2.5 : (size >= 18 ? 2 : 1.5);
    result.wordWrap = false;
    result.scrollFactor.set(1, 1);
    addPanelObject(result);
    return result;
}

function makeLegacyMenuButton(centerX:Float, centerY:Float, label:String, kind:String, row:Int, direction:Int, scale:Float):FlxSprite
{
    var result:FlxSprite = new FlxSprite();
    result.frames = Paths.getSparrowAtlas('menu/main/new buttons and stuff');
    result.animation.addByPrefix('idle', 'Small Button instance 1', 24, false);
    result.animation.play('idle');
    result.animation.pause();
    result.scale.set(scale, scale);
    result.updateHitbox();
    result.x = centerX - result.width * 0.5;
    result.y = centerY - result.height * 0.5;
    addPanelObject(result);

    var labelSize:Int = label == 'CLOSE' ? 19 : 25;
    var labelText:FlxText = new FlxText(result.x + 6, result.y, result.width - 12, label, labelSize);
    labelText.wordWrap = false;
    labelText.setFormat(Paths.font('liberbold.ttf', false), labelSize, 0xFF172630, 'center', FlxTextBorderStyle.OUTLINE, 0xFFE8EFFF);
    labelText.borderSize = 1.2;
    labelText.y = result.y + (result.height - labelText.height) * 0.5;
    addPanelObject(labelText);

    panelButtons.push(result);
    panelButtonActions.push({kind: kind, row: row, direction: direction});
    return result;
}

function makeAppearanceTabButton(centerX:Float, centerY:Float, tabIndex:Int, label:String, targetWidth:Float, targetHeight:Float):FlxSprite
{
    var button:FlxSprite = new FlxSprite();
    var blankGraphic:Dynamic = strictImage('menu/freeplay/sections/blank', true);

    if (blankGraphic != null && blankGraphic.width > 0 && blankGraphic.height > 0)
    {
        button.loadGraphic(blankGraphic);
        var fitScale:Float = Math.min(targetWidth / blankGraphic.width, targetHeight / blankGraphic.height);
        button.scale.set(fitScale, fitScale);
    }
    else
    {
         
        button.frames = Paths.getSparrowAtlas('menu/main/new buttons and stuff');
        button.animation.addByPrefix('idle', 'Small Button instance 1', 24, false);
        button.animation.play('idle');
        button.animation.pause();
        var fallbackScale:Float = Math.min(targetWidth / Math.max(button.frameWidth, 1), targetHeight / Math.max(button.frameHeight, 1));
        button.scale.set(fallbackScale, fallbackScale);
    }

    button.updateHitbox();
    button.x = centerX - button.width * 0.5;
    button.y = centerY - button.height * 0.5;
    addPanelObject(button);

    var labelText:Dynamic = null;
    if (label != null && label != '')
    {
        labelText = makePanelText(button.x + 8, button.y + (button.height - 24) * 0.5, button.width - 16, label, 20, FlxColor.WHITE, 'liberbold.ttf');
    }

    appearanceTabButtons.push(button);
    appearanceTabLabels.push(labelText);
    panelButtons.push(button);
    panelButtonActions.push({kind: 'tab', tab: tabIndex, row: 0, direction: 0});
    return button;
}

function setAppearanceTab(tabIndex:Int)
{
    activeTab = tabIndex == 1 ? 1 : 0;

    for (contentObject in appearanceTabContentObjects)
        if (contentObject != null) contentObject.visible = activeTab == 0;
    for (contentObject in backlitTabContentObjects)
        if (contentObject != null) contentObject.visible = activeTab == 1;

    for (i in 0...appearanceTabButtons.length)
    {
        var selected:Bool = i == activeTab;
        var button:Dynamic = appearanceTabButtons[i];
        if (button != null)
        {
            button.color = selected ? FlxColor.WHITE : 0xFF87999B;
            button.alpha = selected ? 1 : 0.82;
        }

        var label:Dynamic = i < appearanceTabLabels.length ? appearanceTabLabels[i] : null;
        if (label != null)
            label.color = FlxColor.WHITE;
    }

    updateAppearancePanelLabels();
}

function makePackCard(centerX:Float, centerY:Float, active:Bool, scale:Float):FlxSprite
{
    var card:FlxSprite = new FlxSprite();
    card.frames = Paths.getSparrowAtlas('menu/main/new buttons and stuff');
    card.animation.addByPrefix('idle', 'Small Button instance 1', 24, false);
    card.animation.play('idle');
    card.animation.pause();
    card.scale.set(scale, scale);
    card.updateHitbox();
    card.x = centerX - card.width * 0.5;
    card.y = centerY - card.height * 0.5;
    card.color = active ? FlxColor.WHITE : 0xFFB9C0C8;
    addPanelObject(card);
    return card;
}

function makePanelDivider(centerX:Float, y:Float, width:Float)
{
    var divider:FlxSprite = new FlxSprite(centerX - width * 0.5, y);
    divider.makeGraphic(Std.int(width), 3, 0x995A7F87);
    addPanelObject(divider);
}

function makeControlHint(asset:String, x:Float, y:Float, label:String, width:Float)
{
    var key:FlxSprite = new FlxSprite(x, y).loadGraphic(Paths.image('menu/common/controls/' + asset));
    key.setGraphicSize(0, 30);
    key.updateHitbox();
    addPanelObject(key);
    makePanelText(x + key.width + 8, y + 1, width, label, 17, FlxColor.WHITE, 'liberbold.ttf');
}

function fitPackName(textObject:FlxText, packName:String)
{
    if (textObject == null) return;
    textObject.text = packName;
    var size:Int = 29;
    textObject.setFormat(Paths.font('liberbold.ttf', false), size, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, 0xFF14232B);
    textObject.borderSize = 2.5;
    textObject.wordWrap = false;
    while (size > 15 && textObject.textField != null && textObject.textField.textWidth > textObject.fieldWidth - 22)
    {
        size--;
        textObject.setFormat(Paths.font('liberbold.ttf', false), size, FlxColor.WHITE, 'center', FlxTextBorderStyle.OUTLINE, 0xFF14232B);
        textObject.borderSize = 2;
        textObject.wordWrap = false;
    }
}

function getPackPosition(packs:Array<String>, selected:String):String
{
    var index:Int = packs.indexOf(selected);
    if (index < 0) index = 0;
    return 'PACK ' + Std.string(index + 1) + ' / ' + Std.string(packs.length);
}

function createAppearanceButton()
{
    if (!isMainMenu() || configButton != null) return;

    var scale:Float = 0.82;
    configButton = new FlxSprite();
    configButton.frames = Paths.getSparrowAtlas('menu/main/new buttons and stuff');
    configButton.animation.addByPrefix('idle', 'Small Button instance 1', 24, false);
    configButton.animation.play('idle');
    configButton.animation.pause();
    configButton.scale.set(scale, scale);
    configButton.updateHitbox();
    configButton.x = FlxG.width - configButton.width - 34;
    configButton.y = FlxG.height - configButton.height - 30;
     
    configButton.scrollFactor.set(1, 1);
    FlxG.state.add(configButton);

    configButtonText = new FlxText(configButton.x + 8, configButton.y, configButton.width - 16, 'APPEARANCE', 20);
    configButtonText.wordWrap = false;
    configButtonText.setFormat(Paths.font('liberbold.ttf', false), 20, 0xFF172630, 'center', FlxTextBorderStyle.OUTLINE, 0xFFE8EFFF);
    configButtonText.borderSize = 1.2;
    configButtonText.y = configButton.y + (configButton.height - configButtonText.height) * 0.5;
    configButtonText.scrollFactor.set(1, 1);
    FlxG.state.add(configButtonText);
}

function openAppearancePanel()
{
    if (panelOpen || !isMainMenu()) return;

    if (!iconPacks.contains(selectedIconPack)) selectedIconPack = 'Default';
    if (!portraitPacks.contains(selectedPortraitPack)) selectedPortraitPack = 'Default';

    panelOpen = true;
    activeRow = 0;
    activeTab = 0;
    appearanceTabButtons = [];
    appearanceTabLabels = [];
    appearanceTabContentObjects = [];
    backlitTabContentObjects = [];
    hadPreviousMenuLockMovement = false;
    try
    {
        previousMenuLockMovement = Reflect.field(FlxG.state, 'lockMovement') == true;
        hadPreviousMenuLockMovement = true;
    }
    catch (e:Dynamic) {}
    Reflect.setField(FlxG.state, 'lockMovement', true);

    var shade:FlxSprite = new FlxSprite(0, 0);
    shade.makeGraphic(FlxG.width, FlxG.height, 0x58000000);
    addPanelObject(shade);

     
     
    var panelGraphic:Dynamic = strictImage('menu/main/tablet', true);

    var background:FlxSprite = new FlxSprite();
    if (panelGraphic != null) background.loadGraphic(panelGraphic);
    else background.makeGraphic(1100, 650, 0xFF17232C);

    var panelScale:Float = 1.0;
    if (background.width > 0 && background.height > 0)
    {
        var fitX:Float = (FlxG.width - 44) / background.width;
        var fitY:Float = (FlxG.height - 28) / background.height;
        panelScale = Math.min(1.08, Math.min(fitX, fitY));
    }
    background.scale.set(panelScale, panelScale);
    background.updateHitbox();
    background.x = (FlxG.width - background.width) * 0.5;
    background.y = (FlxG.height - background.height) * 0.5;
    addPanelObject(background);

    var panelX:Float = background.x;
    var panelY:Float = background.y;
    var panelWidth:Float = background.width;
    var panelHeight:Float = background.height;
    var centerX:Float = panelX + panelWidth * 0.5;

    makePanelText(panelX + panelWidth * 0.16, panelY + panelHeight * 0.075, panelWidth * 0.68, 'APPEARANCE', 37, 0xFF5DE3C5, 'liberbold.ttf');
    makePanelText(panelX + panelWidth * 0.15, panelY + panelHeight * 0.155, panelWidth * 0.70, 'CUSTOMIZE ICONS, PORTRAITS AND STAGES', 18, FlxColor.WHITE, 'liberbold.ttf');
    makePanelDivider(centerX, panelY + panelHeight * 0.225, panelWidth * 0.78);

    panelCloseButton = new FlxSprite();
    panelCloseButton.loadGraphic(Paths.image('menu/common/menuBack'));
    panelCloseButton.scale.set(panelScale * 0.78, panelScale * 0.78);
    panelCloseButton.updateHitbox();
    panelCloseButton.x = panelX + panelWidth - panelCloseButton.width - 24 * panelScale;
    panelCloseButton.y = panelY + 18 * panelScale;
    addPanelObject(panelCloseButton);
    panelButtons.push(panelCloseButton);
    panelButtonActions.push({kind: 'close', row: 0, direction: 0});

     
     
     
    var tabWidth:Float = panelWidth * 0.205;
    var tabHeight:Float = panelHeight * 0.185;
    var tabGap:Float = 12 * panelScale;
    var tabCenterX:Float = panelX - (tabWidth * 0.5) - tabGap;
    var packsTabButton:FlxSprite = makeAppearanceTabButton(tabCenterX, panelY + panelHeight * 0.425, 0, '', tabWidth, tabHeight);
    makeAppearanceTabButton(tabCenterX, panelY + panelHeight * 0.715, 1, '', tabWidth, tabHeight);

     
    appearanceTabIconPreview = new FlxSprite();
    var redIconGraphic:Dynamic = strictImage('icons/icon-red', true);
    if (redIconGraphic != null && redIconGraphic.width > 0 && redIconGraphic.height > 0)
    {
        var redFrameSize:Int = Std.int(redIconGraphic.height);
        appearanceTabIconPreview.loadGraphic(redIconGraphic, true, redFrameSize, redFrameSize);
        appearanceTabIconPreview.animation.add('preview', [0], 0, false);
        appearanceTabIconPreview.animation.play('preview', true);
        var iconSize:Float = Math.min(packsTabButton.width, packsTabButton.height) * 0.72;
        appearanceTabIconPreview.setGraphicSize(Std.int(iconSize), Std.int(iconSize));
        appearanceTabIconPreview.updateHitbox();
        appearanceTabIconPreview.x = packsTabButton.x + (packsTabButton.width - appearanceTabIconPreview.width) * 0.5;
        appearanceTabIconPreview.y = packsTabButton.y + (packsTabButton.height - appearanceTabIconPreview.height) * 0.5;
        appearanceTabIconPreview.scrollFactor.set(1, 1);
        addPanelObject(appearanceTabIconPreview);
    }

    var tabContentStart:Int = panelObjects.length;

     
     
    var contentCenterX:Float = centerX;
    var contentWidth:Float = panelWidth * 0.76;
    var iconTitleY:Float = panelY + panelHeight * 0.315;
    var iconValueY:Float = panelY + panelHeight * 0.425;
    var portraitTitleY:Float = panelY + panelHeight * 0.605;
    var portraitValueY:Float = panelY + panelHeight * 0.715;

    iconPackTitle = makePanelText(panelX + panelWidth * 0.12, iconTitleY, contentWidth, 'ICON PACK', 29, FlxColor.WHITE, 'liberbold.ttf');
    iconPackCard = makePackCard(contentCenterX, iconValueY, true, panelScale * 0.78);
    iconPackValueText = makePanelText(iconPackCard.x + 8, iconValueY - 15 * panelScale, iconPackCard.width - 16, selectedIconPack, 29, 0xFF123B36, 'liberbold.ttf');
    fitPackName(iconPackValueText, selectedIconPack);
    iconPackCountText = makePanelText(iconPackCard.x + 8, iconPackCard.y + iconPackCard.height + 2 * panelScale, iconPackCard.width - 16, getPackPosition(iconPacks, selectedIconPack), 18, FlxColor.WHITE, 'liberbold.ttf');

    var arrowScale:Float = panelScale * 0.44;
    makeLegacyMenuButton(panelX + panelWidth * 0.18, iconValueY, '<', 'cycle', 0, -1, arrowScale);
    makeLegacyMenuButton(panelX + panelWidth * 0.82, iconValueY, '>', 'cycle', 0, 1, arrowScale);

    makePanelDivider(centerX, panelY + panelHeight * 0.535, panelWidth * 0.78);

    portraitPackTitle = makePanelText(panelX + panelWidth * 0.12, portraitTitleY, contentWidth, 'PORTRAIT PACK', 29, FlxColor.WHITE, 'liberbold.ttf');
    portraitPackCard = makePackCard(contentCenterX, portraitValueY, false, panelScale * 0.78);
    portraitPackValueText = makePanelText(portraitPackCard.x + 8, portraitValueY - 15 * panelScale, portraitPackCard.width - 16, selectedPortraitPack, 29, 0xFF123B36, 'liberbold.ttf');
    fitPackName(portraitPackValueText, selectedPortraitPack);
    portraitPackCountText = makePanelText(portraitPackCard.x + 8, portraitPackCard.y + portraitPackCard.height + 2 * panelScale, portraitPackCard.width - 16, getPackPosition(portraitPacks, selectedPortraitPack), 18, FlxColor.WHITE, 'liberbold.ttf');

    makeLegacyMenuButton(panelX + panelWidth * 0.18, portraitValueY, '<', 'cycle', 1, -1, arrowScale);
    makeLegacyMenuButton(panelX + panelWidth * 0.82, portraitValueY, '>', 'cycle', 1, 1, arrowScale);

    makeControlHint('arrow', panelX + panelWidth * 0.20, panelY + panelHeight * 0.855, 'CHANGE PACK', panelWidth * 0.29);
    makeControlHint('esc', panelX + panelWidth * 0.58, panelY + panelHeight * 0.855, 'Q / ESC: CLOSE', panelWidth * 0.25);

    for (i in tabContentStart...panelObjects.length)
        appearanceTabContentObjects.push(panelObjects[i]);

     
    var backlitContentStart:Int = panelObjects.length;
    var backlitCenterY:Float = panelY + panelHeight * 0.575;
    defeatBacklitTitle = makePanelText(panelX + panelWidth * 0.12, panelY + panelHeight * 0.355, contentWidth, 'DEFEAT', 36, FlxColor.WHITE, 'liberbold.ttf');
    defeatBacklitSubtitle = makePanelText(panelX + panelWidth * 0.12, panelY + panelHeight * 0.435, contentWidth, 'BLACK SHADERS', 25, FlxColor.WHITE, 'liberbold.ttf');
    defeatBacklitCard = makePackCard(contentCenterX, backlitCenterY, true, panelScale * 0.88);
    defeatBacklitValueText = makePanelText(defeatBacklitCard.x + 8, backlitCenterY - 16 * panelScale, defeatBacklitCard.width - 16, (defeatBacklitSetting == 'On' ? 'ON' : 'OFF'), 31, 0xFF123B36, 'liberbold.ttf');
    defeatBacklitStatusText = makePanelText(defeatBacklitCard.x + 8, defeatBacklitCard.y + defeatBacklitCard.height + 12 * panelScale, defeatBacklitCard.width - 16, defeatBacklitSetting == 'On' ? 'BLACK SHADERS ENABLED' : 'BLACK SHADERS DISABLED', 19, FlxColor.WHITE, 'liberbold.ttf');
    makeLegacyMenuButton(panelX + panelWidth * 0.18, backlitCenterY, '<', 'backlit', 0, -1, arrowScale);
    makeLegacyMenuButton(panelX + panelWidth * 0.82, backlitCenterY, '>', 'backlit', 0, 1, arrowScale);
    makeControlHint('arrow', panelX + panelWidth * 0.20, panelY + panelHeight * 0.855, 'CHANGE BLACK SHADERS', panelWidth * 0.34);
    makeControlHint('esc', panelX + panelWidth * 0.60, panelY + panelHeight * 0.855, 'Q / ESC: CLOSE', panelWidth * 0.25);
    for (i in backlitContentStart...panelObjects.length)
        backlitTabContentObjects.push(panelObjects[i]);

    updateAppearancePanelLabels();
    setAppearanceTab(0);
}

function handlePanelPointer()
{
    if (!FlxG.mouse.justPressed) return;

    if (!panelOpen)
    {
        if (configButton != null && FlxG.mouse.overlaps(configButton))
            openAppearancePanel();
        return;
    }

    for (i in 0...panelButtons.length)
    {
        var button:Dynamic = panelButtons[i];
        if (button == null || !FlxG.mouse.overlaps(button)) continue;

        var action:Dynamic = panelButtonActions[i];
        if (action.kind == 'cycle')
        {
            if (activeTab == 0) cyclePack(action.row, action.direction);
        }
        else if (action.kind == 'backlit')
        {
            if (activeTab == 1) cycleDefeatBacklit(action.direction);
        }
        else if (action.kind == 'tab')
            setAppearanceTab(action.tab);
        else if (action.kind == 'close')
            closeAppearancePanel();
        return;
    }
}

function updateAppearancePanelLabels()
{
    if (iconPackTitle != null)
    {
        iconPackTitle.color = FlxColor.WHITE;
        iconPackTitle.text = 'ICON PACK';
    }
    if (portraitPackTitle != null)
    {
        portraitPackTitle.color = FlxColor.WHITE;
        portraitPackTitle.text = 'PORTRAIT PACK';
    }
    if (iconPackValueText != null) fitPackName(iconPackValueText, selectedIconPack);
    if (portraitPackValueText != null) fitPackName(portraitPackValueText, selectedPortraitPack);
    if (iconPackCountText != null) iconPackCountText.text = getPackPosition(iconPacks, selectedIconPack);
    if (portraitPackCountText != null) portraitPackCountText.text = getPackPosition(portraitPacks, selectedPortraitPack);
    if (defeatBacklitValueText != null) defeatBacklitValueText.text = (defeatBacklitSetting == 'On' ? 'ON' : 'OFF');
    if (defeatBacklitStatusText != null) defeatBacklitStatusText.text = defeatBacklitSetting == 'On' ? 'BLACK SHADERS ENABLED' : 'BLACK SHADERS DISABLED';

    if (iconPackCard != null)
        iconPackCard.color = activeRow == 0 ? FlxColor.WHITE : 0xFFB9C0C8;
    if (portraitPackCard != null)
        portraitPackCard.color = activeRow == 1 ? FlxColor.WHITE : 0xFFB9C0C8;
    if (defeatBacklitCard != null)
        defeatBacklitCard.color = activeTab == 1 ? FlxColor.WHITE : 0xFFB9C0C8;
}

function cyclePack(row:Int, direction:Int)
{
    if (row == 0)
    {
        if (iconPacks.length <= 1) return;
        var index:Int = iconPacks.indexOf(selectedIconPack);
        index = (index + direction + iconPacks.length) % iconPacks.length;
        selectedIconPack = iconPacks[index];
    }
    else
    {
        if (portraitPacks.length <= 1) return;
        var index:Int = portraitPacks.indexOf(selectedPortraitPack);
        index = (index + direction + portraitPacks.length) % portraitPacks.length;
        selectedPortraitPack = portraitPacks[index];
    }

    saveAppearanceConfig();
    updateAppearancePanelLabels();
}

function closeAppearancePanel()
{
    if (!panelOpen) return;

    if (FlxG.state != null)
    {
        for (panelObject in panelObjects.copy())
            FlxG.state.remove(panelObject, true);
    }

    panelObjects = [];
    panelButtons = [];
    panelButtonActions = [];
    appearanceTabButtons = [];
    appearanceTabLabels = [];
    appearanceTabContentObjects = [];
    backlitTabContentObjects = [];
    activeTab = 0;
    iconPackTitle = null;
    portraitPackTitle = null;
    iconPackValueText = null;
    portraitPackValueText = null;
    iconPackCountText = null;
    portraitPackCountText = null;
    iconPackCard = null;
    portraitPackCard = null;
    panelCloseButton = null;
    appearanceTabIconPreview = null;
    defeatBacklitTitle = null;
    defeatBacklitSubtitle = null;
    defeatBacklitValueText = null;
    defeatBacklitStatusText = null;
    defeatBacklitCard = null;
    panelOpen = false;

    if (isMainMenu() && hadPreviousMenuLockMovement)
        Reflect.setField(FlxG.state, 'lockMovement', previousMenuLockMovement);
    hadPreviousMenuLockMovement = false;
}

function onUpdate(elapsed:Float)
{
    initializeAppearancePacks();

    var mainMenu:Bool = isMainMenu();
    if (mainMenu)
    {
        if (configButton == null)
            createAppearanceButton();

        handlePanelPointer();

        if (FlxG.keys.justPressed.Q)
        {
            if (panelOpen) closeAppearancePanel();
            else openAppearancePanel();
        }

        if (panelOpen)
        {
            if (FlxG.keys.justPressed.TAB)
                setAppearanceTab(1 - activeTab);

            if (activeTab == 0)
            {
                if (FlxG.keys.justPressed.LEFT) cyclePack(activeRow, -1);
                if (FlxG.keys.justPressed.RIGHT) cyclePack(activeRow, 1);
                if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN)
                {
                    activeRow = 1 - activeRow;
                    updateAppearancePanelLabels();
                }
            }
            else if (activeTab == 1)
            {
                if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT)
                    cycleDefeatBacklit(FlxG.keys.justPressed.LEFT ? -1 : 1);
            }

            if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE)
                closeAppearancePanel();
        }
    }
    else
    {
        configButton = null;
        configButtonText = null;
        if (panelOpen)
        {
            panelOpen = false;
            panelObjects = [];
            panelButtons = [];
            panelButtonActions = [];
            appearanceTabButtons = [];
            appearanceTabLabels = [];
            appearanceTabContentObjects = [];
            backlitTabContentObjects = [];
            appearanceTabIconPreview = null;
        }
    }

     
     
    var currentState:Dynamic = FlxG.state;
    if (currentState != lastAppearanceState)
    {
        lastAppearanceState = currentState;
        appliedIconCache = [];
        appliedPortraitCache = [];
        scanElapsed = 0;
    }

    if (selectedIconPack == 'Default' && selectedPortraitPack == 'Default'
        && appliedIconCache.length == 0 && appliedPortraitCache.length == 0)
        return;

    if (!mainMenu)
    {
        scanElapsed += elapsed;
        if (scanElapsed >= 0.55)
        {
            scanElapsed = 0;
            scanAppearanceTargets();
        }
    }
}
