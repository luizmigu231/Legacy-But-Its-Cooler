import flixel.addons.ui.FlxUIButton;

public var dbGroup = new FlxSpriteGroup();

var autoDebugButtons:Array<FlxUIButton> = [];
var autoDebugActions:Array<Dynamic> = [];

function onCreatePost()
{
	if (!ClientPrefs.inDevMode)
		return;

	game.paused = false;
	dbGroup.camera = game.camOther;

	final GAYLINE:Int = 90;

	closeButton = dbGroup.add(new FlxUIButton(GAYLINE - 52 - 8, 644, 'Reset\nSong', FlxG.resetState));
	closeButton.resize(52, 50);

	lqButton = dbGroup.add(new FlxUIButton(GAYLINE, 700, getBool('LowQ', ClientPrefs.lowQuality), () -> {
		lqButton.label.text = getBool('LowQ', ClientPrefs.lowQuality = !ClientPrefs.lowQuality);
	}));

	flButton = dbGroup.add(new FlxUIButton(GAYLINE * 2, 700, getBool('Flashing', ClientPrefs.flashing), () -> {
		flButton.label.text = getBool('Flashing', ClientPrefs.flashing = !ClientPrefs.flashing);
	}));

	shButton = dbGroup.add(new FlxUIButton(GAYLINE * 3, 700, getBool('Shaders', ClientPrefs.shaders), () -> {
		shButton.label.text = getBool('Shaders', ClientPrefs.shaders = !ClientPrefs.shaders);
	}));

	msButton = dbGroup.add(new FlxUIButton(GAYLINE * 4, 700, getBool('MScroll', ClientPrefs.middleScroll), () -> {
		msButton.label.text = getBool('MScroll', ClientPrefs.middleScroll = !ClientPrefs.middleScroll);
		recalculateMiddlescroll();
	}));

	dsButton = dbGroup.add(new FlxUIButton(GAYLINE * 5, 700, getBool('DScroll', ClientPrefs.downScroll), () -> {
		dsButton.label.text = getBool('DScroll', ClientPrefs.downScroll = !ClientPrefs.downScroll);
	}));

	playbackBG = dbGroup.add(new FlxUIButton(GAYLINE, 644));
	playbackBG.resize(440, 50);
	playbackBG.active = false;

	playbackSlider = dbGroup.add(new flixel.addons.ui.FlxSlider(
		game,
		'playbackRate',
		GAYLINE + 6,
		644,
		.25,
		4,
		413,
		16,
		6,
		0xff333333,
		0xff333333
	));

	playbackSlider.minLabel.alpha = playbackSlider.maxLabel.alpha = playbackSlider.body.alpha = .5;
	playbackSlider.minLabel.x += 4;
	playbackSlider.maxLabel.x += 3;
	playbackSlider.decimals = 2;
	playbackSlider.minLabel.y = playbackSlider.maxLabel.y = playbackSlider.valueLabel.y -= 5;
	playbackSlider.nameLabel.text = 'Playback Rate';
	playbackSlider.nameLabel.y += 5;

	detectDebugActions();
	createDebugButtons();
}

function detectDebugActions():Void
{
	autoDebugActions.resize(0);

	if (!ClientPrefs.inDevMode)
		return;

	if (game.scripts != null)
	{
		for (script in game.scripts.members)
		{
			if (script == null)
				continue;

			if (script.name == null || script.name == '')
				continue;

			readDebugScript(script.name);
		}
	}

	if (game.stage != null && game.stage.script != null)
	{
		if (game.stage.script.name != null && game.stage.script.name != '')
		{
			readDebugScript(game.stage.script.name);
		}
	}
}

function readDebugScript(scriptName:String):Void
{
	var path:String = scriptName;

	if (!FunkinScript.isHxFile(path))
		path = FunkinScript.getPath(path);

	if (path == null || path == '')
		return;

	if (!OpenFlAssets.exists(path))
		return;

	var source:String = OpenFlAssets.getText(path);

	if (source == null || source == '')
		return;

	parseDebugScript(source);
}

function parseDebugScript(source:String):Void
{
	var lines:Array<String> = source.split('\n');

	for (i in 0...lines.length)
	{
		var line:String = cleanDebugLine(lines[i]);

		if (line == '')
			continue;

		var keyMarker:String = 'FlxG.keys.justPressed.';
		var keyPos:Int = line.indexOf(keyMarker);

		if (keyPos == -1)
			continue;

		var keyStart:Int = keyPos + keyMarker.length;
		var keyEnd:Int = keyStart;

		while (keyEnd < line.length)
		{
			var char:String = line.charAt(keyEnd);

			if (!isKeyCharacter(char))
				break;

			keyEnd++;
		}

		if (keyEnd <= keyStart)
			continue;

		var key:String = line.substring(keyStart, keyEnd);

		var foundEvent:Bool = false;

		var sameLineEvent:Dynamic = findTriggerEvent(line);

		if (sameLineEvent != null)
		{
			addDebugAction(key, sameLineEvent.event, sameLineEvent.value);
			foundEvent = true;
		}

		if (foundEvent)
			continue;

		var openBrace:Int = line.indexOf('{');

		if (openBrace != -1)
		{
			var depth:Int = countBraces(line);

			for (j in (i + 1)...lines.length)
			{
				var searchLine:String = cleanDebugLine(lines[j]);

				if (searchLine == '')
					continue;

				var eventData:Dynamic = findTriggerEvent(searchLine);

				if (eventData != null)
				{
					addDebugAction(key, eventData.event, eventData.value);
					foundEvent = true;
					break;
				}

				depth += countBraces(searchLine);

				if (depth <= 0)
					break;

				if (searchLine.indexOf(keyMarker) != -1 && depth <= 0)
					break;
			}
		}
		else
		{
			for (j in (i + 1)...lines.length)
			{
				var searchLine:String = cleanDebugLine(lines[j]);

				if (searchLine == '')
					continue;

				var eventData:Dynamic = findTriggerEvent(searchLine);

				if (eventData != null)
				{
					addDebugAction(key, eventData.event, eventData.value);
					foundEvent = true;
				}

				break;
			}
		}
	}
}

function cleanDebugLine(line:String):String
{
	if (line == null)
		return '';

	var commentPos:Int = line.indexOf('//');

	if (commentPos != -1)
		line = line.substring(0, commentPos);

	return StringTools.trim(line);
}

function countBraces(line:String):Int
{
	var depth:Int = 0;

	for (i in 0...line.length)
	{
		var char:String = line.charAt(i);

		if (char == '{')
			depth++;
		else if (char == '}')
			depth--;
	}

	return depth;
}

function findTriggerEvent(source:String):Dynamic
{
	if (source == null || source == '')
		return null;

	var marker:String = 'triggerEventNote';
	var eventPos:Int = source.indexOf(marker);

	if (eventPos == -1)
		return null;

	var openParen:Int = source.indexOf('(', eventPos + marker.length);

	if (openParen == -1)
		return null;

	var closeParen:Int = findClosingParen(source, openParen);

	if (closeParen == -1)
		return null;

	var arguments:String = source.substring(openParen + 1, closeParen);

	var values:Array<String> = splitEventArguments(arguments);

	if (values.length < 2)
		return null;

	var eventName:String = extractArgumentString(values[0]);
	var eventValue:String = extractArgumentString(values[1]);

	if (eventName == null || eventName == '')
		return null;

	if (eventValue == null)
		return null;

	return {
		event: eventName,
		value: eventValue
	};
}

function findClosingParen(source:String, start:Int):Int
{
	var depth:Int = 0;
	var quote:String = '';

	for (i in start...source.length)
	{
		var char:String = source.charAt(i);

		if (quote != '')
		{
			if (char == quote && (i == 0 || source.charAt(i - 1) != '\\'))
				quote = '';

			continue;
		}

		if (char == '"' || char == "'")
		{
			quote = char;
			continue;
		}

		if (char == '(')
		{
			depth++;
		}
		else if (char == ')')
		{
			depth--;

			if (depth <= 0)
				return i;
		}
	}

	return -1;
}

function splitEventArguments(source:String):Array<String>
{
	var result:Array<String> = [];
	var current:String = '';
	var depth:Int = 0;
	var quote:String = '';

	for (i in 0...source.length)
	{
		var char:String = source.charAt(i);

		if (quote != '')
		{
			current += char;

			if (char == quote && (i == 0 || source.charAt(i - 1) != '\\'))
				quote = '';

			continue;
		}

		if (char == '"' || char == "'")
		{
			quote = char;
			current += char;
			continue;
		}

		if (char == '(' || char == '[' || char == '{')
		{
			depth++;
			current += char;
			continue;
		}

		if (char == ')' || char == ']' || char == '}')
		{
			depth--;
			current += char;
			continue;
		}

		if (char == ',' && depth == 0)
		{
			result.push(StringTools.trim(current));
			current = '';
			continue;
		}

		current += char;
	}

	if (StringTools.trim(current) != '')
		result.push(StringTools.trim(current));

	return result;
}

function extractArgumentString(value:String):String
{
	if (value == null)
		return null;

	value = StringTools.trim(value);

	if (value.length < 2)
		return null;

	var first:String = value.charAt(0);
	var last:String = value.charAt(value.length - 1);

	if ((first != '"' && first != "'") || first != last)
		return null;

	return value.substring(1, value.length - 1);
}

function isKeyCharacter(char:String):Bool
{
	if (char == null || char == '')
		return false;

	var code:Int = char.charCodeAt(0);

	if (code >= 48 && code <= 57)
		return true;

	if (code >= 65 && code <= 90)
		return true;

	if (code >= 97 && code <= 122)
		return true;

	if (char == '_')
		return true;

	return false;
}

function addDebugAction(key:String, eventName:String, value1:String):Void
{
	if (key == null || key == '')
		return;

	if (eventName == null || eventName == '')
		return;

	if (value1 == null)
		return;

	for (action in autoDebugActions)
	{
		if (action.key == key &&
			action.event == eventName &&
			action.value == value1)
		{
			return;
		}
	}

	autoDebugActions.push({
		key: key,
		event: eventName,
		value: value1
	});
}

function createDebugButtons():Void
{
	for (button in autoDebugButtons)
	{
		if (button != null)
			dbGroup.remove(button, true);
	}

	autoDebugButtons.resize(0);

	if (autoDebugActions.length <= 0)
		return;

	final BUTTON_WIDTH:Int = 110;
	final BUTTON_HEIGHT:Int = 40;
	final SPACING:Int = 4;
	final START_X:Int = 560;
	final START_Y:Int = 680;
	final BUTTONS_PER_ROW:Int = 6;

	for (i in 0...autoDebugActions.length)
	{
		var action:Dynamic = autoDebugActions[i];

		var column:Int = i % BUTTONS_PER_ROW;
		var row:Int = Std.int(i / BUTTONS_PER_ROW);

		var x:Int = START_X + column * (BUTTON_WIDTH + SPACING);
		var y:Int = START_Y - row * (BUTTON_HEIGHT + SPACING);

		var eventName:String = action.event;
		var eventValue:String = action.value;
		var buttonText:String = action.key + ': ' + action.value;

		var button:FlxUIButton = new FlxUIButton(
			x,
			y,
			buttonText,
			function()
			{
				triggerEventNote(eventName, eventValue);
			}
		);

		button.resize(BUTTON_WIDTH, BUTTON_HEIGHT);

		dbGroup.add(button);
		autoDebugButtons.push(button);
	}
}

var warping:Bool = false;

function onUpdate()
{
	if (ClientPrefs.inDevMode || PlayState.chartingMode)
	{
		if (FlxG.keys.pressed.THREE)
		{
			playbackRate = (FlxG.keys.pressed.SHIFT ? .5 : 2);
			warping = true;
		}
		else if (warping)
		{
			playbackRate = 1;
			warping = false;
		}
	}
}

function recalculateMiddlescroll():Void
{
	for (playField in playFields)
	{
		if (playField.isPlayer)
		{
			modManager.setValue(
				'opponentSwap',
				ClientPrefs.middleScroll ? .5 : 0,
				playField.ID
			);

			continue;
		}

		playField.visible = !ClientPrefs.middleScroll;

		modManager.setValue(
			'alpha',
			ClientPrefs.middleScroll ? 1 : 0,
			playField.ID
		);
	}
}