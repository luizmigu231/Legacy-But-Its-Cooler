package funkin.states;

import flixel.FlxG;
import haxe.Json;
import haxe.Reflect;
import Type;

import funkin.Mods;

import sys.FileSystem;
import sys.io.File;

var modFolder:String = 'Impostor Legacy But Its Cooler';
var wasMainMenu:Bool = false;

function onUpdate(elapsed:Float)
{
	var isMainMenu:Bool =
		FlxG.state != null
		&& Type.getClassName(Type.getClass(FlxG.state)) == 'funkin.states.MainMenuState';

	if (isMainMenu && !wasMainMenu)
		applySettings();

	wasMainMenu = isMainMenu;
}

function applySettings()
{
	if (!Mods.all.contains(modFolder))
		return;

	var basePath:String = 'content/' + modFolder + '/';
	var settingsPath:String = basePath + 'settings.json';
	var configPath:String = basePath + 'scripts/storage/config.json';

	if (!FileSystem.exists(settingsPath) || !FileSystem.exists(configPath))
		return;

	var settings:Dynamic = null;
	var config:Dynamic = null;

	try
	{
		settings = Json.parse(File.getContent(settingsPath));
		config = Json.parse(File.getContent(configPath));
	}
	catch (e:Dynamic)
	{
		return;
	}

	if (settings == null || config == null)
		return;

	var skin:String = getSetting(settings, 'Skins', 'Normal');
	var backlit:String = getSetting(settings, 'Backlit', 'On');

	for (songID in Reflect.fields(config))
	{
		var songConfig:Dynamic = Reflect.field(config, songID);
		if (songConfig == null)
			continue;

		var sourceRelative:String = getFieldString(songConfig, 'source');
		var destinationRelative:String = getFieldString(songConfig, 'destination');

		if (sourceRelative == '' || destinationRelative == '')
			continue;

		var sourcePath:String = basePath + sourceRelative;
		var destinationPath:String = basePath + destinationRelative;

		if (!FileSystem.exists(sourcePath))
			continue;

		var chart:Dynamic = null;

		try
		{
			chart = Json.parse(File.getContent(sourcePath));
		}
		catch (e:Dynamic)
		{
			continue;
		}

		if (chart == null)
			continue;

		var songData:Dynamic = chart;

		if (Reflect.hasField(chart, 'song'))
			songData = Reflect.field(chart, 'song');

		if (songData == null)
			continue;

		var originalOpponent:String = getFieldString(songData, 'player2');
		if (originalOpponent == '')
			continue;

		var opponent:String = originalOpponent;

		if (skin.toLowerCase() == 'skin')
			opponent = findSkinCharacter(basePath, originalOpponent);

		Reflect.setField(songData, 'player2', opponent);

		var stages:Dynamic = null;
		if (Reflect.hasField(songConfig, 'stage'))
			stages = Reflect.field(songConfig, 'stage');

		if (stages != null)
		{
			var stage:String = getStage(stages, backlit);
			if (stage != '')
				Reflect.setField(songData, 'stage', stage);
		}

		try
		{
			File.saveContent(
				destinationPath,
				Json.stringify(chart, null, '\t')
			);
		}
		catch (e:Dynamic)
		{
			continue;
		}
	}
}

function findSkinCharacter(basePath:String, character:String):String
{
	if (character == null || character.length == 0)
		return character;

	var candidate:String = character + 'skin';
	var characterPath:String = basePath + 'data/characters/' + candidate + '.json';

	if (FileSystem.exists(characterPath))
		return candidate;

	return character;
}

function getSetting(settings:Dynamic, name:String, fallback:String):String
{
	if (settings == null || !Reflect.hasField(settings, name))
		return fallback;

	var value:String = Std.string(Reflect.field(settings, name));
	return value.length > 0 ? value : fallback;
}

function getFieldString(value:Dynamic, name:String):String
{
	if (value == null || !Reflect.hasField(value, name))
		return '';

	var result:String = Std.string(Reflect.field(value, name));
	return result == null ? '' : result;
}

function getStage(stages:Dynamic, setting:String):String
{
	if (stages == null)
		return '';

	if (Reflect.hasField(stages, setting))
	{
		var value:String = Std.string(Reflect.field(stages, setting));
		if (value.length > 0)
			return value;
	}

	var fallback:String = setting.toLowerCase() == 'off' ? 'Off' : 'On';

	if (Reflect.hasField(stages, fallback))
	{
		var fallbackValue:String = Std.string(Reflect.field(stages, fallback));
		if (fallbackValue.length > 0)
			return fallbackValue;
	}

	return '';
}
