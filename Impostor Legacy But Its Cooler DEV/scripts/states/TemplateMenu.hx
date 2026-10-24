import funkin.Mods;
import funkin.objects.Alphabet;
import funkin.objects.menu.AmongControls;
import funkin.states.MainMenuState;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup.FlxTypedGroup;

import haxe.Json;
import Reflect;

import sys.FileSystem;
import sys.io.File;

var grpTexts:FlxTypedGroup;
var descriptionText:FlxText;
var backButton:FlxButton;

var CoolMods:Array<Dynamic> = [];

var defaultSettings:Dynamic = {};
var settings:Dynamic = {};
var descriptions:Dynamic = {};

var settingOrder:Array<String> = [];

var settingsjson:String = '';
var defaultjson:String = '';
var descjson:String = '';

var curSelected:Int = 0;
var inSettings:Bool = false;
var currentMod:Dynamic = null;

var moveHoldTimer:Float = 0;
var moveHoldDelay:Float = 0.35;
var moveHoldRepeat:Float = 0.08;
var moveHoldDirection:Int = 0;

var EvilMultipleChoiceHoldTimer:Float = 0;
var EvilMultipleChoiceHoldDelay:Float = 0.35;
var EvilMultipleChoiceHoldRepeat:Float = 0.08;
var EvilMultipleChoiceHoldDirection:Int = 0;

var touchDragging:Bool = false;
var touchMoved:Bool = false;

var touchStartX:Float = 0;
var touchStartY:Float = 0;

var touchLastX:Float = 0;
var touchLastY:Float = 0;

var touchMoveThreshold:Float = 30;
var touchStepThreshold:Float = 90;
var touchDragAccumX:Float = 0;
var touchDragAccumY:Float = 0;

function onCreate()
{
	grpTexts = new FlxTypedGroup();
	add(grpTexts);

	descriptionText = new FlxText(
		30,
		20,
		FlxG.width - 60,
		''
	);

	descriptionText.setFormat(
		null,
		20,
		0xFFFFFFFF,
		'left'
	);

	descriptionText.visible = false;
	add(descriptionText);

	backButton = new FlxButton(
    FlxG.width - 225,
    FlxG.height - 200,
    '',
    goBack
);

	backButton.loadGraphic(
		Paths.image('menu/common/reset')
	);

	backButton.scrollFactor.set(0, 0);
	add(backButton);

	Coolmodsthatusethis();
	generateModSections();

	var bottomControls:AmongControls = new AmongControls([
		['arrow', 'select'],
		['enter', 'Confirm'],
		['esc', 'back']
	], false);

	add(bottomControls);
}

function goBack()
{
	if (inSettings)
	{
		leaveModSettings();
	}
	else
	{
		FlxG.switchState(
			() -> new MainMenuState()
		);
	}
}

function Coolmodsthatusethis()
{
	CoolMods = [];

	for (mod in Mods.all)
	{
		var defaultPath:String =
			'content/' + mod + '/settings-default.json';

		var settingsjson:String =
			'content/' + mod + '/settings.json';

		if (
			!FileSystem.exists(defaultPath)
			|| !FileSystem.exists(settingsjson)
		)
			continue;

		var descjson:String =
			'content/' + mod + '/settings-desc.json';

		var modName = Mods.getModName(mod);
		var displayName:String = mod;

		if (modName != null && modName != '')
			displayName = modName;

		CoolMods.push({
			mod: mod,
			name: displayName,
			defaultPath: defaultPath,
			settingsjson: settingsjson,
			descjson: descjson
		});
	}
}

function generateModSections()
{
	grpTexts.clear();

	descriptionText.visible = false;
	descriptionText.text = '';

	for (i in 0...CoolMods.length)
	{
		var mod = CoolMods[i];

		var text:Alphabet = new Alphabet(
			0,
			(70 * i) + 30,
			mod.name,
			true,
			false
		);

		text.isMenuItem = true;
		text.targetY = i;

		grpTexts.add(text);
	}
}

function generateSettings()
{
	grpTexts.clear();

	if (currentMod == null)
		return;

	for (i in 0...settingOrder.length)
	{
		var key:String = settingOrder[i];

		var text:Alphabet = new Alphabet(
			0,
			(i * 70) + 130,
			getSettingDisplay(key),
			true,
			false
		);

		text.isMenuItem = true;
		text.targetY = i;

		grpTexts.add(text);
	}

	updateDescription();
}

function getSettingDisplay(key:String):String
{
	var value = Reflect.field(settings, key);

	if (value == true || value == false)
		return key + ': ' + (value == true ? 'ON' : 'OFF');

	if (value == null)
		return key;

	return key + ': < ' + Std.string(value) + ' >';
}

function getStringParts(value:String):Array<String>
{
	var parts:Array<String> = [];

	for (part in value.split(','))
	{
		var trimmed:String = StringTools.trim(part);

		if (trimmed != '')
			parts.push(trimmed);
	}

	return parts;
}

function isNumber(value:String):Bool
{
	value = StringTools.trim(value);

	if (value == '')
		return false;

	var start:Int = 0;

	if (value.charAt(0) == '-')
	{
		if (value.length == 1)
			return false;

		start = 1;
	}

	for (i in start...value.length)
	{
		var char:String = value.charAt(i);

		if (char < '0' || char > '9')
			return false;
	}

	return true;
}

function isDecimalNumber(value:String):Bool
{
	value = StringTools.trim(value);

	if (value == '')
		return false;

	var start:Int = 0;
	var decimalFound:Bool = false;
	var digitFound:Bool = false;

	if (value.charAt(0) == '-')
	{
		if (value.length == 1)
			return false;

		start = 1;
	}

	for (i in start...value.length)
	{
		var char:String = value.charAt(i);

		if (char >= '0' && char <= '9')
		{
			digitFound = true;
			continue;
		}

		if (char == '.' && !decimalFound)
		{
			decimalFound = true;
			continue;
		}

		return false;
	}

	return digitFound;
}

function isIntegerRange(key:String):Bool
{
	var defaultValue = Reflect.field(
		defaultSettings,
		key
	);

	if (defaultValue == null)
		return false;

	var parts:Array<String> = getStringParts(
		Std.string(defaultValue)
	);

	if (parts.length != 2)
		return false;

	return isNumber(parts[0]) && isNumber(parts[1]);
}

function isNumberList(key:String):Bool
{
	var defaultValue = Reflect.field(
		defaultSettings,
		key
	);

	if (defaultValue == null)
		return false;

	var parts:Array<String> = getStringParts(
		Std.string(defaultValue)
	);

	if (parts.length < 2)
		return false;

	if (
		parts.length == 2
		&& isNumber(parts[0])
		&& isNumber(parts[1])
	)
		return false;

	for (part in parts)
	{
		if (!isDecimalNumber(part))
			return false;
	}

	return true;
}

function MultiChoice(key:String):Bool
{
	var defaultValue = Reflect.field(
		defaultSettings,
		key
	);

	if (defaultValue == null)
		return false;

	var parts:Array<String> = getStringParts(
		Std.string(defaultValue)
	);

	if (parts.length < 2)
		return false;

	if (isIntegerRange(key))
		return false;

	if (isNumberList(key))
		return false;

	return true;
}

function getJsonKeyOrder(contents:String):Array<String>
{
	var keys:Array<String> = [];

	var depth:Int = 0;
	var i:Int = 0;

	while (i < contents.length)
	{
		var char:String = contents.charAt(i);

		if (char == '"')
		{
			var stringStart:Int = i;
			var stringEnd:Int = i + 1;
			var escaped:Bool = false;

			while (stringEnd < contents.length)
			{
				var stringChar:String = contents.charAt(stringEnd);

				if (escaped)
				{
					escaped = false;
				}
				else if (stringChar == '\\')
				{
					escaped = true;
				}
				else if (stringChar == '"')
				{
					break;
				}

				stringEnd++;
			}

			if (depth == 1 && stringEnd < contents.length)
			{
				var after:Int = stringEnd + 1;

				while (after < contents.length)
				{
					var afterChar:String = contents.charAt(after);

					if (
						afterChar == ' '
						|| afterChar == '\t'
						|| afterChar == '\n'
						|| afterChar == '\r'
					)
					{
						after++;
						continue;
					}

					break;
				}

				if (
					after < contents.length
					&& contents.charAt(after) == ':'
				)
				{
					var rawKey:String = contents.substring(
						stringStart + 1,
						stringEnd
					);

					keys.push(unescapeJsonString(rawKey));
				}
			}

			i = stringEnd + 1;
			continue;
		}

		if (char == '{')
			depth++;
		else if (char == '}')
			depth--;

		i++;
	}

	return keys;
}

function unescapeJsonString(value:String):String
{
	return value
		.split('\\"').join('"')
		.split('\\\\').join('\\')
		.split('\\n').join('\n')
		.split('\\r').join('\r')
		.split('\\t').join('\t');
}

function loadSettings(mod:Dynamic)
{
	currentMod = mod;

	defaultjson = mod.defaultPath;
	settingsjson = mod.settingsjson;
	descjson = mod.descjson;

	defaultSettings = {};
	settings = {};
	descriptions = {};
	settingOrder = [];

	var defaultContents:String = '';

	try
	{
		defaultContents = File.getContent(
			defaultjson
		);

		defaultSettings = Json.parse(
			defaultContents
		);

		if (defaultSettings == null)
			defaultSettings = {};

		var allKeys:Array<String> = getJsonKeyOrder(
			defaultContents
		);

		for (key in allKeys)
			settingOrder.push(key);
	}
	catch (e:Dynamic)
	{
		trace('Failed to load settings-default.json: ' + e);

		defaultSettings = {};
		settingOrder = [];
	}

	try
	{
		settings = Json.parse(
			File.getContent(settingsjson)
		);

		if (settings == null)
			settings = {};
	}
	catch (e:Dynamic)
	{
		trace('Failed to load settings.json: ' + e);
		settings = {};
	}

	if (FileSystem.exists(descjson))
	{
		try
		{
			descriptions = Json.parse(
				File.getContent(descjson)
			);

			if (descriptions == null)
				descriptions = {};
		}
		catch (e:Dynamic)
		{
			trace('Failed to load settings-desc.json: ' + e);
			descriptions = {};
		}
	}

	applyDefaults();
	saveSettings();
}

function applyDefaults()
{
	for (key in settingOrder)
	{
		if (!Reflect.hasField(settings, key))
		{
			var defaultValue = Reflect.field(
				defaultSettings,
				key
			);

			Reflect.setField(
				settings,
				key,
				getInitialValue(defaultValue)
			);
		}
	}
}

function getInitialValue(defaultValue:Dynamic):Dynamic
{
	if (defaultValue == null)
		return null;

	if (defaultValue == true || defaultValue == false)
		return defaultValue;

	var value:String = Std.string(defaultValue);
	var parts:Array<String> = getStringParts(value);

	if (parts.length <= 0)
		return value;

	if (
		parts.length == 2
		&& isNumber(parts[0])
		&& isNumber(parts[1])
	)
	{
		return parts[0];
	}

	if (parts.length >= 2)
	{
		var allNumbers:Bool = true;

		for (part in parts)
		{
			if (!isDecimalNumber(part))
			{
				allNumbers = false;
				break;
			}
		}

		if (allNumbers)
			return parts[0];
	}

	if (parts.length >= 2)
		return parts[0];

	return value;
}

function saveSettings()
{
	if (settingsjson == '')
		return;

	try
	{
		var output:Dynamic = {};

		for (key in settingOrder)
		{
			if (Reflect.hasField(settings, key))
			{
				Reflect.setField(
					output,
					key,
					Reflect.field(settings, key)
				);
			}
		}

		File.saveContent(
			settingsjson,
			Json.stringify(output, null, '\t')
		);
	}
	catch (e:Dynamic)
	{
		trace('Failed to save settings: ' + e);
	}
}

function getSettingDescription(key:String):String
{
	if (descriptions == null)
		return '';

	if (!Reflect.hasField(descriptions, key))
		return '';

	var description = Reflect.field(
		descriptions,
		key
	);

	if (description == null)
		return '';

	return Std.string(description);
}

function updateDescription()
{
	if (!inSettings || settingOrder.length <= 0)
	{
		descriptionText.visible = false;
		descriptionText.text = '';
		return;
	}

	var key:String = settingOrder[curSelected];
	var description:String = getSettingDescription(key);

	if (description == '')
	{
		descriptionText.visible = false;
		descriptionText.text = '';
	}
	else
	{
		descriptionText.visible = true;
		descriptionText.text = description;
	}
}

function mouseOverMenuItem(index:Int):Bool
{
	if (index < 0 || index >= grpTexts.members.length)
		return false;

	var item = grpTexts.members[index];

	if (item == null)
		return false;

	return item.overlapsPoint(
		FlxG.mouse.getWorldPosition()
	);
}

function handleMobileClick()
{
	if (FlxG.mouse.justPressed)
	{
		touchDragging = true;
		touchMoved = false;
		touchStartX = FlxG.mouse.x;
		touchStartY = FlxG.mouse.y;
		touchLastX = FlxG.mouse.x;
		touchLastY = FlxG.mouse.y;
		touchDragAccumX = 0;
		touchDragAccumY = 0;
		return;
	}

	if (touchDragging && FlxG.mouse.pressed)
	{
		var currentX:Float = FlxG.mouse.x;
		var currentY:Float = FlxG.mouse.y;
		var deltaX:Float = currentX - touchLastX;
		var deltaY:Float = currentY - touchLastY;

		if (Math.abs(currentX - touchStartX) >= touchMoveThreshold || Math.abs(currentY - touchStartY) >= touchMoveThreshold)
			touchMoved = true;

		if (touchMoved)
		{
			if (Math.abs(deltaY) > Math.abs(deltaX))
			{
				touchDragAccumY += deltaY;

				while (Math.abs(touchDragAccumY) >= touchStepThreshold)
				{
					if (touchDragAccumY < 0)
					{
						changeSelection(1);
						touchDragAccumY += touchStepThreshold;
					}
					else
					{
						changeSelection(-1);
						touchDragAccumY -= touchStepThreshold;
					}
				}
			}
			else if (inSettings)
			{
				touchDragAccumX += deltaX;

				while (Math.abs(touchDragAccumX) >= touchStepThreshold)
				{
					var key:String = settingOrder[curSelected];

					if (touchDragAccumX < 0)
					{
						changeString(key, 1);
						touchDragAccumX += touchStepThreshold;
					}
					else
					{
						changeString(key, -1);
						touchDragAccumX -= touchStepThreshold;
					}
				}
			}
		}

		touchLastX = currentX;
		touchLastY = currentY;
		return;
	}

	if (touchDragging && FlxG.mouse.justReleased)
	{
		if (!touchMoved)
		{
			if (!inSettings)
			{
				for (i in 0...CoolMods.length)
				{
					if (mouseOverMenuItem(i))
					{
						curSelected = i;
						enterModSettings();
						break;
					}
				}
			}
			else if (settingOrder.length > 0 && mouseOverMenuItem(curSelected))
			{
				var key:String = settingOrder[curSelected];
				var value = Reflect.field(settings, key);

				if (value == true || value == false)
					toggleBool(key);
				else
					changeString(key, 1);
			}
		}

		touchDragging = false;
		touchMoved = false;
		touchDragAccumX = 0;
		touchDragAccumY = 0;
	}
}

function onUpdate(elapsed:Float)
{
	handleMobileClick();

	if (inSettings)
		updateSettings(elapsed);
	else
		updateModSections(elapsed);

	var i:Int = 0;

	for (item in grpTexts.members)
	{
		if (item == null)
			continue;

		item.targetY = i - curSelected;

		item.alpha = item.targetY == 0 ? 1 : 0.6;

		item.color = item.targetY == 0
			? 0xFFFFFFFF
			: 0xFFAAAAAA;

		i++;
	}
}

function updateModSections(elapsed:Float)
{
	if (CoolMods.length <= 0)
		return;

	if (controls.UI_UP_P)
	{
		changeSelection(-1);

		moveHoldDirection = -1;
		moveHoldTimer = 0;
	}
	else if (controls.UI_DOWN_P)
	{
		changeSelection(1);

		moveHoldDirection = 1;
		moveHoldTimer = 0;
	}
	else
	{
		handleHeldSelection(elapsed);
	}

	if (FlxG.mouse.wheel != 0)
		changeSelection(
			FlxG.mouse.wheel > 0 ? -1 : 1
		);

	if (controls.ACCEPT)
		enterModSettings();

	if (controls.BACK)
		goBack();
}

function updateSettings(elapsed:Float)
{
	if (settingOrder.length <= 0)
		return;

	if (controls.UI_UP_P)
	{
		changeSelection(-1);

		moveHoldDirection = -1;
		moveHoldTimer = 0;
	}
	else if (controls.UI_DOWN_P)
	{
		changeSelection(1);

		moveHoldDirection = 1;
		moveHoldTimer = 0;
	}
	else
	{
		handleHeldSelection(elapsed);
	}

	if (FlxG.mouse.wheel != 0)
		changeSelection(
			FlxG.mouse.wheel > 0 ? -1 : 1
		);

	var key:String = settingOrder[curSelected];

	var value = Reflect.field(
		settings,
		key
	);

	if (value == true || value == false)
	{
		EvilMultipleChoiceHoldTimer = 0;
		EvilMultipleChoiceHoldDirection = 0;

		if (controls.ACCEPT)
			toggleBool(key);
	}
	else
	{
		handleHeldStringChange(elapsed, key);
	}

	updateDescription();

	if (controls.BACK)
		goBack();
}

function handleHeldSelection(elapsed:Float)
{
	var direction:Int = 0;

	if (controls.UI_UP)
		direction = -1;
	else if (controls.UI_DOWN)
		direction = 1;

	if (direction == 0)
	{
		moveHoldTimer = 0;
		moveHoldDirection = 0;
		return;
	}

	if (direction != moveHoldDirection)
	{
		moveHoldDirection = direction;
		moveHoldTimer = 0;
		return;
	}

	moveHoldTimer += elapsed;

	if (moveHoldTimer >= moveHoldDelay)
	{
		moveHoldTimer -= moveHoldRepeat;
		changeSelection(direction);
	}
}

function handleHeldStringChange(elapsed:Float, key:String)
{
	var direction:Int = 0;

	if (controls.UI_LEFT)
		direction = -1;
	else if (controls.UI_RIGHT)
		direction = 1;

	if (direction == 0)
	{
		EvilMultipleChoiceHoldTimer = 0;
		EvilMultipleChoiceHoldDirection = 0;
		return;
	}

	if (direction != EvilMultipleChoiceHoldDirection)
	{
		EvilMultipleChoiceHoldDirection = direction;
		EvilMultipleChoiceHoldTimer = 0;

		changeString(key, direction);
		return;
	}

	EvilMultipleChoiceHoldTimer += elapsed;

	if (EvilMultipleChoiceHoldTimer >= EvilMultipleChoiceHoldDelay)
	{
		EvilMultipleChoiceHoldTimer -= EvilMultipleChoiceHoldRepeat;
		changeString(key, direction);
	}
}

function enterModSettings()
{
	if (CoolMods.length <= 0)
		return;

	currentMod = CoolMods[curSelected];

	loadSettings(currentMod);

	curSelected = 0;
	inSettings = true;

	EvilMultipleChoiceHoldTimer = 0;
	EvilMultipleChoiceHoldDirection = 0;
	moveHoldTimer = 0;
	moveHoldDirection = 0;

	descriptionText.visible = false;

	generateSettings();
}

function leaveModSettings()
{
	saveSettings();

	inSettings = false;
	currentMod = null;

	settings = {};
	defaultSettings = {};
	descriptions = {};
	settingOrder = [];

	settingsjson = '';
	defaultjson = '';
	descjson = '';

	curSelected = 0;

	EvilMultipleChoiceHoldTimer = 0;
	EvilMultipleChoiceHoldDirection = 0;
	moveHoldTimer = 0;
	moveHoldDirection = 0;

	touchDragging = false;
	touchMoved = false;
	touchDragAccumX = 0;
	touchDragAccumY = 0;

	descriptionText.visible = false;
	descriptionText.text = '';

	generateModSections();
}

function changeSelection(change:Int = 0)
{
	var amount:Int = inSettings
		? settingOrder.length
		: CoolMods.length;

	if (amount <= 0)
		return;

	FlxG.sound.play(
		Paths.sound('scrollMenu'),
		0.4
	);

	curSelected += change;

	if (curSelected < 0)
		curSelected = amount - 1;

	if (curSelected >= amount)
		curSelected = 0;

	if (inSettings)
		updateDescription();
}

function toggleBool(key:String)
{
	var value:Bool = Reflect.field(
		settings,
		key
	);

	Reflect.setField(
		settings,
		key,
		!value
	);

	saveSettings();
	generateSettings();
}

function changeString(key:String, change:Int)
{
	var defaultValue = Reflect.field(
		defaultSettings,
		key
	);

	if (defaultValue == null)
		return;

	var defaultParts:Array<String> = getStringParts(
		Std.string(defaultValue)
	);

	if (defaultParts.length <= 0)
		return;

	var currentValue = Reflect.field(
		settings,
		key
	);

	var currentString:String = Std.string(
		currentValue
	);

	if (isIntegerRange(key))
	{
		var minimum:Int = Std.parseInt(
			defaultParts[0]
		);

		var maximum:Int = Std.parseInt(
			defaultParts[1]
		);

		var current:Int = minimum;

		if (isNumber(currentString))
		{
			current = Std.parseInt(
				currentString
			);

			if (current < minimum || current > maximum)
				current = minimum;
		}

		current += change;

		if (current < minimum)
			current = maximum;

		if (current > maximum)
			current = minimum;

		Reflect.setField(
			settings,
			key,
			Std.string(current)
		);

		saveSettings();
		generateSettings();
		return;
	}

	if (isNumberList(key))
	{
		var selectedIndex:Int = 0;

		for (i in 0...defaultParts.length)
		{
			if (defaultParts[i] == currentString)
			{
				selectedIndex = i;
				break;
			}
		}

		selectedIndex += change;

		if (selectedIndex < 0)
			selectedIndex = defaultParts.length - 1;

		if (selectedIndex >= defaultParts.length)
			selectedIndex = 0;

		Reflect.setField(
			settings,
			key,
			defaultParts[selectedIndex]
		);

		saveSettings();
		generateSettings();
		return;
	}

	if (MultiChoice(key))
	{
		var selectedIndex:Int = 0;

		for (i in 0...defaultParts.length)
		{
			if (defaultParts[i] == currentString)
			{
				selectedIndex = i;
				break;
			}
		}

		selectedIndex += change;

		if (selectedIndex < 0)
			selectedIndex = defaultParts.length - 1;

		if (selectedIndex >= defaultParts.length)
			selectedIndex = 0;

		Reflect.setField(
			settings,
			key,
			defaultParts[selectedIndex]
		);

		saveSettings();
		generateSettings();
		return;
	}
}