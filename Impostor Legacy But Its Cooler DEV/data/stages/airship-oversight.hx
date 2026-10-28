import StringTools;
import animate.FlxAnimateFrames;
import funkin.objects.FunkinSprite;
import flixel.math.FlxMath;
import funkin.game.shaders.ExtraDropShadowShader;
import funkin.objects.Character;

var skySprites:Array<FlxSprite> = [];
var cloudSprites:Array<FlxSprite> = [];
var stageSprites:Array<FlxSprite> = [];
public var whiteAwkward:FlxSprite;
var henryTeleporter:FlxSprite;
var noticeYellow:Character;
var extraZoom:Float = 0;
var teleporter_songs:Array<String> = ['Mando', "D'low"];
var yellowdied:Array<String> = ['Oversight'];
public var you_can_press_the_teleporter:Bool = true;
var has_teleporter:Bool = false;
var teleporting:Bool = false;
var isyellowdead:Bool = false;
var ext:String = 'stages/airship/mando/';
var flashers:Array<FlxSprite>;
public var deadbody:FlxSprite;
var glow:FlxSprite;
var bfRim:ExtraDropShadowShader = new ExtraDropShadowShader();
var petRim:ExtraDropShadowShader = new ExtraDropShadowShader();
var gfRim:ExtraDropShadowShader = new ExtraDropShadowShader();
var dadRim:ExtraDropShadowShader = new ExtraDropShadowShader();
var dadForegroundRim:ExtraDropShadowShader = new ExtraDropShadowShader();
var deadbodyRim:ExtraDropShadowShader = new ExtraDropShadowShader();
var drops:Array<ExtraDropShadowShader> = [bfRim, petRim, gfRim, dadRim, dadForegroundRim, deadbodyRim];
var rimEnabled:Bool = false;
var cloudStartX:Array<Float> = [];
var cloudSpeeds:Array<Float> = [];
var thunderTimer:Float = 0;
var lightningDarken:Array<FlxSprite> = [];
var lightningLighten:Array<FlxSprite> = [];
public var nextThunder:Int = 8;
public var canThunder:Bool = true;
var skyColorPlaceholder:FlxSprite;
var isThundering:Bool = false;
var lightningLightenBaseColors:Array<Int> = [];
var lightningDarkenBaseColors:Array<Int> = [];
var element0:FlxSprite;
var element1:FlxSprite;
var element2:FlxSprite;
var element4:FlxSprite;
var element5:FlxSprite;
var element6:FlxSprite;
var element7:FlxSprite;
var element8:FlxSprite;
var element9:FlxSprite;
var element10:FlxSprite;
var element11:FlxSprite;
var targetColor:Int;
var rim:ExtraDropShadowShader;
var songLower:String;
var dt:Float;
var startX:Float;
var dadAnim:String;
var shesDead:Bool;
var b:Float;
var w:Float;
var endSongStarted:Bool = false;
var hasDarkened:Bool = false;
var thunder:FlxSprite;
var thunder1:FlxSprite;
var thunder2:FlxSprite;
var thunders:Array<FlxSprite> = [thunder, thunder1, thunder2];
var thunderTween:FlxTween;
var shaderExcludedParts:Array<String> = ['_bta_asi_13', '_bta_asi_18', '_bta_asi_19', 'halo'];
var shaderPartsOverlay:FunkinSprite = null;
var shaderPartsGlowWideOverlay:FunkinSprite = null;
var shaderPartsGlowMidOverlay:FunkinSprite = null;
var shaderPartsGlowOverlay:FunkinSprite = null;
var shaderPartsBodyOverlay:FunkinSprite = null;
var shaderPartsOcclusionOverlay:FunkinSprite = null;
var shaderPartsLayer:FlxSpriteGroup = null;
var shaderPartsOverlayCharacter:String = '';
var shaderPartsSource:Dynamic = null;
var shaderPartsSourceCharacter:String = '';
var shaderPartsHidden:Bool = false;
var shaderPartsOriginalVisible:Bool = true;

function onLoad()
{
	has_teleporter = teleporter_songs.contains(songName) && PlayState.isStoryMode;
	isyellowdead = yellowdied.contains(songName);
	element8 = new FlxSprite(-1468, -995).loadGraphic(Paths.image(ext + 'fartingSky slightly dark'));
	element8.scrollFactor.set(0.3, 0.3);
	element8.color = 0xFF1F1D36;
	element11 = new FlxSprite(130, 350).loadGraphic(Paths.image(ext + 'yellow cloud 3 dark'));
	element11.scrollFactor.set(0.5, 0.8);
	element11.color = 0xFF292929;
	stageSprites.push(element11);
	cloudSprites.push(element11);
	cloudStartX.push(element11.x);
	cloudSpeeds.push(17.5);
	element5 = new FlxSprite(-1125, 284).loadGraphic(Paths.image(ext + 'backSkyyellow dark'));
	element5.scrollFactor.set(0.4, 0.7);
	element5.color = 0xFF2C2C2C;
	element6 = new FlxSprite(1330, 283).loadGraphic(Paths.image(ext + 'yellow cloud 3 dark'));
	element6.scrollFactor.set(0.5, 0.8);
	element6.color = 0xFF2E2E2E;
	stageSprites.push(element6);
	cloudSprites.push(element6);
	cloudStartX.push(element6.x);
	cloudSpeeds.push(20);
	element7 = new FlxSprite(-837, 304).loadGraphic(Paths.image(ext + 'yellow cloud 2 dark'));
	element7.scrollFactor.set(0.6, 0.9);
	element7.color = 0xFF2C2C2C;
	stageSprites.push(element7);
	cloudSprites.push(element7);
	cloudStartX.push(element7.x);
	cloudSpeeds.push(15);
	element10 = new FlxSprite(41, 242).loadGraphic(Paths.image(ext + 'cloudYellow 1 dark'));
	element10.scrollFactor.set(0.8, 0.8);
	element10.color = 0xFF5F5F5F;
	cloudSprites.push(element10);
	cloudStartX.push(element10.x);
	cloudSpeeds.push(5.5);
	element4 = new FlxSprite(-1541, 242).loadGraphic(Paths.image(ext + 'cloudYellow 1 slightly dark'));
	element4.scrollFactor.set(0.8, 0.8);
	element4.color = 0xFF383838;
	stageSprites.push(element4);
	cloudSprites.push(element4);
	cloudStartX.push(element4.x);
	cloudSpeeds.push(5);
	element2 = new FlxSprite(-1387, -1231).loadGraphic(Paths.image(ext + 'window'));
	stageSprites.push(element2);
	element1 = new FlxSprite(-642, 325).loadGraphic(Paths.image(ext + 'backDlowFloor'));
	element1.scrollFactor.set(0.9, 1);
	element0 = new FlxSprite(-2440, 336).loadGraphic(Paths.image(ext + 'DlowFloor'));
	element9 = new FlxSprite(-568, -895).loadGraphic(Paths.image(ext + 'airshiplight'));
	element9.scrollFactor.set(0.9, 1);
	element9.alpha = 1;
	element9.visible = true;
	stageSprites.push(element9);
	thunder = new FlxSprite(-514.75, -373.05).loadGraphic(Paths.image('stages/airship/danger/thunder'));
	thunder.scrollFactor.set(1, 1);
	thunder.scale.set(2, 2);
	thunder.updateHitbox();
	thunder.alpha = 0;
	thunder1 = new FlxSprite(-514.75, -500.05).loadGraphic(Paths.image('stages/mira/reactorRuined/thunder1'));
	thunder1.scrollFactor.set(1, 1);
	thunder1.updateHitbox();
	thunder1.alpha = 0;
	thunder2 = new FlxSprite(-514.75, -373.05).loadGraphic(Paths.image('stages/mira/reactorRuined/thunder2'));
	thunder2.scrollFactor.set(1, 1);
	thunder2.updateHitbox();
	thunder2.alpha = 0;
	thunders = [thunder, thunder1, thunder2];
	for (sprite in stageSprites)
	{
		targetColor = 0xFF222537;
		FlxTween.color(sprite, 120, sprite.color, targetColor);
	}
	for (item in [element8, element5, element6, thunder, thunder1, thunder2, element11, element10, element7, element2, element4, element1, element0])
	{
		item.scale.set(2, 2);
		item.updateHitbox();
		stageSprites.push(item);
		add(item);
	}
	whiteAwkward = new FlxSprite(298, 550);
	whiteAwkward.frames = Paths.getSparrowAtlas(ext + 'white_awkward');
	whiteAwkward.animation.addByPrefix('sweat', 'fetal position', 6, true);
	whiteAwkward.animation.addByPrefix('stare', 'white stare', 24, false);
	whiteAwkward.animation.play('sweat');
	whiteAwkward.color = 0xFFF1F1F1;
	whiteAwkward.visible = !isyellowdead;
	add(whiteAwkward);
	henryTeleporter = new FlxSprite(998, 620).loadGraphic(Paths.image(ext + 'Teleporter'));
	henryTeleporter.visible = has_teleporter;
	add(henryTeleporter);
	deadbody = new FlxSprite(-400, 620).loadGraphic(Paths.image(ext + 'YELLOW'));
	deadbody.visible = isyellowdead;
	add(deadbody);
	skySprites.push(element6);
	skySprites.push(element11);
	skySprites.push(element7);
	skySprites.push(element4);
	skySprites.push(element10);
	skyColorPlaceholder = new FlxSprite();
	skyColorPlaceholder.color = skySprites[0].color;
}

function turnShader(should:Bool = false)
{
	if (!ClientPrefs.shaders) should = false;
	rimEnabled = should;
	if (boyfriend != null) boyfriend.shader = null;
	if (bfRim != null) bfRim.attachedSprite = null;
	if (dad != null) dad.shader = null;
	if (dadRim != null) dadRim.attachedSprite = null;
	if (dadForegroundRim != null) dadForegroundRim.attachedSprite = null;
	if (!should)
	{
		if (gf != null) gf.shader = null;
		if (pet != null) pet.shader = null;
		if (deadbody != null) deadbody.shader = null;
		refreshParts();
		return;
	}
	if (boyfriend != null && bfRim != null)
	{
		bfRim.attachedSprite = boyfriend;
		boyfriend.useRenderTexture = true;
	}
	if (gf != null) gf.shader = gfRim;
	if (pet != null) pet.shader = petRim;
	if (deadbody != null) deadbody.shader = deadbodyRim;
	hideRim();
	refreshParts();
}

function setShaderLayersThreshold(shader:ExtraDropShadowShader, value:Float):Void
{
	if (shader == null || shader.layers == null) return;
	for (layer in shader.layers)
		if (layer != null) layer.threshold = value;
}

function hideRim()
{
	setShaderLayersThreshold(bfRim, 1);
	setShaderLayersThreshold(petRim, 1);
	setShaderLayersThreshold(gfRim, 1);
	setShaderLayersThreshold(deadbodyRim, 1);
	if (dadRim != null && dadRim.layers != null)
	{
		for (i in 0...dadRim.layers.length)
			dadRim.layers[i].threshold = (i == 0 ? 1 : 0.025);
	}
	if (dadForegroundRim != null && dadForegroundRim.layers != null)
	{
		for (i in 0...dadForegroundRim.layers.length)
			dadForegroundRim.layers[i].threshold = (i == 0 ? 1 : 0.025);
	}
}

function setRimThreshold(value:Float)
{
	if (!rimEnabled) return;
	setShaderLayersThreshold(bfRim, value);
	setShaderLayersThreshold(petRim, value);
	setShaderLayersThreshold(gfRim, value);
	setShaderLayersThreshold(dadRim, value);
	setShaderLayersThreshold(dadForegroundRim, value);
	setShaderLayersThreshold(deadbodyRim, value);
}

function getLibrary(sprite:Dynamic):Dynamic
{
	if (sprite == null) return null;
	var library:Dynamic = sprite.library;
	if (library == null) return null;
	return library;
}

function getElementName(element:Dynamic):String
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

function checkItem(item:Dynamic, cacheTrue:Array<String>, cacheFalse:Array<String>, stack:Array<String>):Bool
{
	if (item == null || item.name == null) return false;
	var name:String = '' + item.name;
	if (shaderExcludedParts.indexOf(name) != -1) return true;
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
				var childName:String = getElementName(element);
				if (childName == '') continue;
				if (shaderExcludedParts.indexOf(childName) != -1 || checkItem(element.libraryItem, cacheTrue, cacheFalse, stack))
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

function setupSymbol(item:Dynamic, mode:String, glowScale:Float):Void
{
	if (item == null || item.timeline == null) return;
	var symbolName:String = '' + item.name;
	var cacheTrue:Array<String> = [];
	var cacheFalse:Array<String> = [];
	if (mode == 'excluded' && shaderExcludedParts.indexOf(symbolName) != -1)
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
				var childName:String = getElementName(element);
				if (mode != 'excluded')
				{
					if (childName != '' && shaderExcludedParts.indexOf(childName) != -1)
						element.visible = false;
					continue;
				}
				if (childName == '')
				{
					element.visible = false;
					continue;
				}
				var isExcluded:Bool = shaderExcludedParts.indexOf(childName) != -1;
				var childItem:Dynamic = element.libraryItem;
				var hasExcluded:Bool = isExcluded || checkItem(childItem, cacheTrue, cacheFalse, []);
				element.visible = hasExcluded;
				var isBrokenDownAltHalo:Bool = childName == 'halo' && StringTools.startsWith(symbolName.toLowerCase(), 'down alt');
				if (glowScale > 1 && isExcluded && symbolName != 'halo' && !isBrokenDownAltHalo && element.matrix != null && childItem != null && childItem.timeline != null)
				{
					var localBounds:Dynamic = childItem.timeline.getWholeBounds(false, null, null, true);
					if (localBounds != null && localBounds.width > 0 && localBounds.height > 0)
						scaleAround(element, glowScale, localBounds.x + localBounds.width * 0.5, localBounds.y + localBounds.height * 0.5);
				}
			}
		});
	}
}

function hasParts(sprite:Dynamic):Bool
{
	var library:Dynamic = getLibrary(sprite);
	if (library == null) return false;
	for (part in shaderExcludedParts)
		if (library.getSymbol(part) == null) return false;
	return true;
}

function checkSymbol(sprite:Dynamic, symbolName:String, cacheTrue:Array<String>, cacheFalse:Array<String>, stack:Array<String>):Bool
{
	if (symbolName == null || symbolName == '') return false;
	if (shaderExcludedParts.indexOf(symbolName) != -1) return true;
	if (cacheTrue.indexOf(symbolName) != -1) return true;
	if (cacheFalse.indexOf(symbolName) != -1) return false;
	if (stack.indexOf(symbolName) != -1) return false;
	var library:Dynamic = getLibrary(sprite);
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
				var childName:String = getElementName(element);
				if (childName == '') continue;
				if (checkSymbol(sprite, childName, cacheTrue, cacheFalse, stack))
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

function filterSymbol(sprite:Dynamic, symbolName:String, onlyExcluded:Bool, visited:Array<String>, cacheTrue:Array<String>, cacheFalse:Array<String>):Void
{
	if (symbolName == null || symbolName == '' || visited.indexOf(symbolName) != -1) return;
	visited.push(symbolName);
	if (onlyExcluded && shaderExcludedParts.indexOf(symbolName) != -1) return;
	var library:Dynamic = getLibrary(sprite);
	if (library == null) return;
	var symbol = library.getSymbol(symbolName);
	if (symbol == null || symbol.timeline == null) return;
	var children:Array<String> = [];
	for (layer in symbol.timeline.layers)
	{
		if (layer == null) continue;
		layer.forEachFrame(function(frame)
		{
			if (frame == null || frame.elements == null) return;
			for (element in frame.elements)
			{
				if (element == null) continue;
				var childName:String = getElementName(element);
				if (childName == '')
				{
					if (onlyExcluded) element.visible = false;
					continue;
				}
				var isExcluded:Bool = shaderExcludedParts.indexOf(childName) != -1;
				if (onlyExcluded)
					element.visible = isExcluded || checkSymbol(sprite, childName, cacheTrue, cacheFalse, []);
				else if (isExcluded)
					element.visible = false;
				if (children.indexOf(childName) == -1) children.push(childName);
			}
		});
	}
	for (childName in children)
		filterSymbol(sprite, childName, onlyExcluded, visited, cacheTrue, cacheFalse);
}

function filterBody(sprite:Dynamic, rootSymbols:Array<String>):Void
{
	var visited:Array<String> = [];
	var cacheTrue:Array<String> = [];
	var cacheFalse:Array<String> = [];
	for (symbolName in rootSymbols)
		filterSymbol(sprite, symbolName, false, visited, cacheTrue, cacheFalse);
}

function filterOverlay(sprite:Dynamic, rootSymbols:Array<String>):Void
{
	var visited:Array<String> = [];
	var cacheTrue:Array<String> = [];
	var cacheFalse:Array<String> = [];
	for (symbolName in rootSymbols)
		filterSymbol(sprite, symbolName, true, visited, cacheTrue, cacheFalse);
}

function hasHalo(sprite:Dynamic, symbolName:String, stack:Array<String>):Bool
{
	if (symbolName == 'halo') return true;
	if (symbolName == null || symbolName == '' || stack.indexOf(symbolName) != -1) return false;
	var library:Dynamic = getLibrary(sprite);
	if (library == null) return false;
	var symbol = library.getSymbol(symbolName);
	if (symbol == null || symbol.timeline == null) return false;
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
				var childName:String = getElementName(element);
				if (childName != '' && hasHalo(sprite, childName, stack))
				{
					found = true;
					break;
				}
			}
		});
		if (found) break;
	}
	stack.pop();
	return found;
}

function getDepthSymbol(symbolName:String):String
{
	if (symbolName == null || symbolName == '') return symbolName;
	var normalized:String = symbolName.toLowerCase();
	if (normalized == 'aldown') return 'down alt';
	return symbolName;
}

function findLayer(sprite:Dynamic, symbolName:String, cacheTrue:Array<String>, cacheFalse:Array<String>):Int
{
	symbolName = getDepthSymbol(symbolName);
	var library:Dynamic = getLibrary(sprite);
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
				var childName:String = getElementName(element);
				if (childName != '' && checkSymbol(sprite, childName, cacheTrue, cacheFalse, []))
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

function findElement(sprite:Dynamic, symbolName:String, targetLayer:Int, cacheTrue:Array<String>, cacheFalse:Array<String>):Int
{
	symbolName = getDepthSymbol(symbolName);
	var library:Dynamic = getLibrary(sprite);
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
			var childName:String = getElementName(frame.elements[i]);
			if (childName != '' && checkSymbol(sprite, childName, cacheTrue, cacheFalse, []))
			{
				targetElement = i;
				break;
			}
		}
	});
	return targetElement;
}

function hideNested(sprite:Dynamic, symbolName:String, visited:Array<String>):Void
{
	if (sprite == null || symbolName == null || symbolName == '' || visited.indexOf(symbolName) != -1) return;
	visited.push(symbolName);
	var library:Dynamic = getLibrary(sprite);
	if (library == null) return;
	var symbol = library.getSymbol(symbolName);
	if (symbol == null || symbol.timeline == null) return;
	var children:Array<String> = [];
	for (layer in symbol.timeline.layers)
	{
		if (layer == null) continue;
		layer.forEachFrame(function(frame)
		{
			if (frame == null || frame.elements == null) return;
			for (element in frame.elements)
			{
				if (element == null) continue;
				var childName:String = getElementName(element);
				if (childName == '') continue;
				if (shaderExcludedParts.indexOf(childName) != -1)
					element.visible = false;
				else if (children.indexOf(childName) == -1)
					children.push(childName);
			}
		});
	}
	for (childName in children) hideNested(sprite, childName, visited);
}

function setLayerOrder(sprite:Dynamic, rootSymbols:Array<String>, showForeground:Bool):Void
{
	for (symbolName in rootSymbols)
	{
		var depthSymbolName:String = getDepthSymbol(symbolName);
		var library:Dynamic = getLibrary(sprite);
		if (library == null) return;
		var symbol = library.getSymbol(depthSymbolName);
		if (symbol == null || symbol.timeline == null) continue;
		var cacheTrue:Array<String> = [];
		var cacheFalse:Array<String> = [];
		var targetLayer:Int = findLayer(sprite, depthSymbolName, cacheTrue, cacheFalse);
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
		var targetElement:Int = findElement(sprite, depthSymbolName, targetLayer, cacheTrue, cacheFalse);
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
						var targetChild:String = getElementName(frame.elements[i]);
						if (targetChild != '' && checkSymbol(sprite, targetChild, cacheTrue, cacheFalse, []))
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
					var childName:String = getElementName(element);
					if (childName != '' && shaderExcludedParts.indexOf(childName) != -1)
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

function disposePart(sprite:FunkinSprite):Void
{
	if (sprite == null) return;
	if (shaderPartsLayer != null) shaderPartsLayer.remove(sprite, true);
	sprite.destroy();
}

function disposeLayers():Void
{
	if (dadRim != null && shaderPartsBodyOverlay != null && dadRim.attachedSprite == shaderPartsBodyOverlay)
		dadRim.attachedSprite = null;
	if (dadForegroundRim != null && shaderPartsOcclusionOverlay != null && dadForegroundRim.attachedSprite == shaderPartsOcclusionOverlay)
		dadForegroundRim.attachedSprite = null;
	disposePart(shaderPartsBodyOverlay);
	disposePart(shaderPartsGlowWideOverlay);
	disposePart(shaderPartsGlowMidOverlay);
	disposePart(shaderPartsGlowOverlay);
	disposePart(shaderPartsOverlay);
	disposePart(shaderPartsOcclusionOverlay);
	if (shaderPartsLayer != null)
	{
		if (game != null && game.dadGroup != null) game.dadGroup.remove(shaderPartsLayer, true);
		shaderPartsLayer.destroy();
		shaderPartsLayer = null;
	}
	shaderPartsBodyOverlay = null;
	shaderPartsGlowWideOverlay = null;
	shaderPartsGlowMidOverlay = null;
	shaderPartsGlowOverlay = null;
	shaderPartsOverlay = null;
	shaderPartsOcclusionOverlay = null;
	shaderPartsOverlayCharacter = '';
}

function scaleAround(element:Dynamic, factor:Float, centerX:Float, centerY:Float):Void
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

function scaleNested(element:Dynamic, factor:Float, centerX:Float, centerY:Float):Void
{
	if (element == null || element.matrix == null) return;
	element.matrix.tx = centerX + (element.matrix.tx - centerX) * factor;
	element.matrix.ty = centerY + (element.matrix.ty - centerY) * factor;
	element.matrix.a = element.matrix.a * factor;
	element.matrix.b = element.matrix.b * factor;
	element.matrix.c = element.matrix.c * factor;
	element.matrix.d = element.matrix.d * factor;
}

function scaleParts(sprite:FunkinSprite, symbolName:String, factor:Float, visited:Array<String>, insideExcluded:Bool, scaledHalo:Array<String>):Void
{
	if (sprite == null || symbolName == null || symbolName == '' || visited.indexOf(symbolName) != -1) return;
	visited.push(symbolName);
	var library:Dynamic = getLibrary(sprite);
	if (library == null) return;
	var symbol = library.getSymbol(symbolName);
	if (symbol == null || symbol.timeline == null) return;
	if (insideExcluded)
	{
		if (symbolName == 'halo' && scaledHalo.indexOf(symbolName) == -1)
		{
			var bounds:Dynamic = symbol.timeline.getWholeBounds(false, null, null, true);
			if (bounds != null && bounds.width > 0 && bounds.height > 0)
			{
				var centerX:Float = bounds.x + bounds.width * 0.5;
				var centerY:Float = bounds.y + bounds.height * 0.5;
				for (layer in symbol.timeline.layers)
				{
					if (layer == null) continue;
					layer.forEachFrame(function(frame)
					{
						if (frame == null || frame.elements == null) return;
						for (element in frame.elements) scaleNested(element, factor, centerX, centerY);
					});
				}
			}
			scaledHalo.push(symbolName);
		}
		return;
	}
	var children:Array<String> = [];
	for (layer in symbol.timeline.layers)
	{
		if (layer == null) continue;
		layer.forEachFrame(function(frame)
		{
			if (frame == null || frame.elements == null) return;
			for (element in frame.elements)
			{
				if (element == null) continue;
				var childName:String = getElementName(element);
				if (childName == '') continue;
				var isExcluded:Bool = shaderExcludedParts.indexOf(childName) != -1;
				if (isExcluded && childName != 'halo' && element.matrix != null)
				{
					var childSymbol:Dynamic = library.getSymbol(childName);
					var localBounds:Dynamic = null;
					if (childSymbol != null && childSymbol.timeline != null)
						localBounds = childSymbol.timeline.getWholeBounds(false, null, null, true);
					if (localBounds != null && localBounds.width > 0 && localBounds.height > 0)
						scaleAround(element, factor, localBounds.x + localBounds.width * 0.5, localBounds.y + localBounds.height * 0.5);
				}
				if (children.indexOf(childName) == -1) children.push(childName);
			}
		});
	}
	for (childName in children)
		scaleParts(sprite, childName, factor, visited, shaderExcludedParts.indexOf(childName) != -1, scaledHalo);
}

function buildPart(mode:String, suffix:String, glowScale:Float = 1):FunkinSprite
{
	var atlasPath:String = Paths.getPath('images/${dad.imageFile}', null, PathsTestMode.LOOSE);
	var settings:Dynamic = {
		cacheOnLoad: mode != 'excluded',
		onSymbolCreate: function(item:Dynamic) setupSymbol(item, mode, glowScale)
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
	if (mode != 'excluded') setLayerOrder(sprite, rootSymbols, mode == 'foreground');
	sprite.shader = null;
	sprite.useRenderTexture = false;
	sprite.cameras = [camGame];
	sprite.scrollFactor.set(dad.scrollFactor.x, dad.scrollFactor.y);
	sprite.active = false;
	sprite.visible = false;
	if (shaderPartsLayer == null) return sprite;
	shaderPartsLayer.add(sprite);
	return sprite;
}

function setupParts():Bool
{
	if (!hasParts(dad) || dadRim == null || dadForegroundRim == null || game == null || game.dadGroup == null) return false;
	if (shaderPartsLayer != null && shaderPartsOverlay != null && shaderPartsGlowOverlay != null && shaderPartsGlowMidOverlay != null && shaderPartsGlowWideOverlay != null && shaderPartsBodyOverlay != null && shaderPartsOcclusionOverlay != null && shaderPartsOverlayCharacter == dad.curCharacter) return true;
	disposeLayers();
	shaderPartsLayer = new FlxSpriteGroup(0, 0);
	shaderPartsLayer.zIndex = dad.zIndex;
	shaderPartsLayer.visible = false;
	game.dadGroup.add(shaderPartsLayer);
	shaderPartsBodyOverlay = buildPart('background', 'body_back', 1);
	shaderPartsGlowWideOverlay = buildPart('excluded', 'excluded_glow_wide', 1.34);
	shaderPartsGlowMidOverlay = buildPart('excluded', 'excluded_glow_mid', 1.20);
	shaderPartsGlowOverlay = buildPart('excluded', 'excluded_glow_near', 1.075);
	shaderPartsOverlay = buildPart('excluded', 'excluded', 1);
	shaderPartsOcclusionOverlay = buildPart('foreground', 'body_front', 1);
	if (shaderPartsBodyOverlay == null || shaderPartsGlowWideOverlay == null || shaderPartsGlowMidOverlay == null || shaderPartsGlowOverlay == null || shaderPartsOverlay == null || shaderPartsOcclusionOverlay == null)
	{
		disposeLayers();
		return false;
	}
	shaderPartsBodyOverlay.zIndex = 0;
	shaderPartsGlowWideOverlay.zIndex = 1;
	shaderPartsGlowMidOverlay.zIndex = 2;
	shaderPartsGlowOverlay.zIndex = 3;
	shaderPartsOverlay.zIndex = 4;
	shaderPartsOcclusionOverlay.zIndex = 5;
	shaderPartsOverlayCharacter = dad.curCharacter;
	refreshZ(shaderPartsLayer);
	refreshZ(game.dadGroup);
	return true;
}

function syncPart(sprite:FunkinSprite, shouldShow:Bool):Void
{
	if (sprite == null || dad == null) return;
	if (!shaderPartsOriginalVisible || !dad.exists || dad.alpha <= 0)
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

function isAltDown():Bool
{
	if (dad == null) return false;
	var animName:String = dad.getAnimName();
	if ((animName == null || animName == '') && dad.animation.curAnim != null)
		animName = dad.animation.curAnim.name;
	if (animName == null || animName == '') return false;
	var normalized:String = animName.toLowerCase();
	return StringTools.contains(normalized, 'down') && StringTools.contains(normalized, 'alt');
}

function setPartDepth():Void
{
	if (shaderPartsLayer == null || shaderPartsOverlay == null) return;
	var desiredZ:Int = isAltDown() ? 6 : 4;
	if (shaderPartsOverlay.zIndex != desiredZ)
	{
		shaderPartsOverlay.zIndex = desiredZ;
		refreshZ(shaderPartsLayer);
	}
}

function refreshParts():Void
{
	if (dad == null) return;
	if (hasParts(dad)) dad.shader = null;
	if (shaderPartsSource != dad || shaderPartsSourceCharacter != dad.curCharacter)
	{
		if (shaderPartsHidden && shaderPartsSource != null) shaderPartsSource.visible = shaderPartsOriginalVisible;
		disposeLayers();
		shaderPartsSource = dad;
		shaderPartsSourceCharacter = dad.curCharacter;
		shaderPartsHidden = false;
	}
	var hasExcludedAtlas:Bool = hasParts(dad);
	if (hasExcludedAtlas) dad.shader = null;
	var shouldHide:Bool = ClientPrefs.shaders && rimEnabled && hasDarkened && hasExcludedAtlas && dadRim != null;
	if (shouldHide && !setupParts()) shouldHide = false;
	if (!shouldHide)
	{
		dad.shader = null;
		if (dadRim != null && (dadRim.attachedSprite == dad || dadRim.attachedSprite == shaderPartsBodyOverlay))
			dadRim.attachedSprite = null;
		if (dadForegroundRim != null && dadForegroundRim.attachedSprite == shaderPartsOcclusionOverlay)
			dadForegroundRim.attachedSprite = null;
		if (shaderPartsHidden && shaderPartsSource != null) shaderPartsSource.visible = shaderPartsOriginalVisible;
		if (shaderPartsLayer != null) shaderPartsLayer.visible = false;
		if (shaderPartsOverlay != null) shaderPartsOverlay.visible = false;
		if (shaderPartsGlowWideOverlay != null) shaderPartsGlowWideOverlay.visible = false;
		if (shaderPartsGlowMidOverlay != null) shaderPartsGlowMidOverlay.visible = false;
		if (shaderPartsGlowOverlay != null) shaderPartsGlowOverlay.visible = false;
		if (shaderPartsBodyOverlay != null) shaderPartsBodyOverlay.visible = false;
		if (shaderPartsOcclusionOverlay != null) shaderPartsOcclusionOverlay.visible = false;
		shaderPartsHidden = false;
		return;
	}
	if (!shaderPartsHidden)
	{
		shaderPartsOriginalVisible = dad.visible;
		dad.shader = null;
		dad.visible = false;
		shaderPartsHidden = true;
	}
	else
	{
		dad.shader = null;
		dad.visible = false;
	}
	if (shaderPartsLayer != null && shaderPartsLayer.zIndex != dad.zIndex)
	{
		shaderPartsLayer.zIndex = dad.zIndex;
		refreshZ(game.dadGroup);
	}
	syncPart(shaderPartsBodyOverlay, shaderPartsOriginalVisible);
	syncPart(shaderPartsGlowWideOverlay, shaderPartsOriginalVisible);
	syncPart(shaderPartsGlowMidOverlay, shaderPartsOriginalVisible);
	syncPart(shaderPartsGlowOverlay, shaderPartsOriginalVisible);
	syncPart(shaderPartsOverlay, shaderPartsOriginalVisible);
	syncPart(shaderPartsOcclusionOverlay, shaderPartsOriginalVisible);
	setPartDepth();
	shaderPartsGlowWideOverlay.color = 0xFFFFD34A;
	shaderPartsGlowWideOverlay.alpha = dad.alpha * 0.10;
	shaderPartsGlowWideOverlay.blend = BlendMode.ADD;
	shaderPartsGlowMidOverlay.color = 0xFFFFC83A;
	shaderPartsGlowMidOverlay.alpha = dad.alpha * 0.16;
	shaderPartsGlowMidOverlay.blend = BlendMode.ADD;
	shaderPartsGlowOverlay.color = 0xFFFFD84A;
	shaderPartsGlowOverlay.alpha = dad.alpha * 0.24;
	shaderPartsGlowOverlay.blend = BlendMode.ADD;
	if (shaderPartsLayer != null) shaderPartsLayer.visible = shaderPartsOriginalVisible && dad.exists && dad.alpha > 0;
	if (!shaderPartsBodyOverlay.useRenderTexture) shaderPartsBodyOverlay.useRenderTexture = true;
	if (!shaderPartsOcclusionOverlay.useRenderTexture) shaderPartsOcclusionOverlay.useRenderTexture = true;
	if (dadRim.attachedSprite != shaderPartsBodyOverlay) dadRim.attachedSprite = shaderPartsBodyOverlay;
	if (dadForegroundRim.attachedSprite != shaderPartsOcclusionOverlay) dadForegroundRim.attachedSprite = shaderPartsOcclusionOverlay;
}

function onCreatePost()
{
	if (has_teleporter) addCharacterToList('yellow-teleport', 1);
	camSpecialThing([300, 500], [700, 500], 0.6);
	boyfriend.color = 0xFFF1F1F1;
	gf.color = 0xFFF1F1F1;
	dad.color = 0xFFF1F1F1;
	applyBFEffect();
	applyGFEffect();
	applyDadEffect();
	applyDeadBodyEffect();
	lightningDarken = [element1, element0, element9];
	lightningLighten = [element8, element11, element5, element6, element7, element10, element4, element2];
	lightningLightenBaseColors = [];
	for (sprite in lightningLighten)
		if (sprite != null) lightningLightenBaseColors.push(sprite.color);
	turnShader(false);
	if (ClientPrefs.shaders && dad != null && hasParts(dad))
	{
		shaderPartsSource = dad;
		shaderPartsSourceCharacter = dad.curCharacter;
		setupParts();
	}
}

function configureRim(shader:ExtraDropShadowShader):Void
{
	if (shader == null) return;
	shader.setAdjustColor(-78, -25, -15, -58);
	shader.addLayer([0.8, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0.3, 0, 1, 0, 0, 0, 0, 0, 1, 0], 90, 35, 0.01, 1, 0.5);
}

function configureDadGlow(shader:ExtraDropShadowShader):Void
{
	configureRim(shader);
}

function applyBFEffect()
{
	if (!ClientPrefs.shaders || boyfriend == null) return;
	rim = new ExtraDropShadowShader();
	rim.setAdjustColor(-78, -25, -15, -58);
	rim.addLayer([0.8, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0.3, 0, 1, 0, 0, 0, 0, 0, 1, 0], 90, 35, 0.01, 1, 0.5);
	bfRim = rim;
	bfRim.attachedSprite = boyfriend;
	boyfriend.useRenderTexture = true;
	if (hasPet && pet != null)
	{
			petRim = new ExtraDropShadowShader();
		configureRim(petRim);
		petRim.attachedSprite = pet;
		pet.useRenderTexture = true;
	}
}

function applyGFEffect()
{
	if (!ClientPrefs.shaders || gf == null) return;
	gfRim = new ExtraDropShadowShader();
	configureRim(gfRim);
	gfRim.attachedSprite = gf;
	gf.useRenderTexture = true;
}

function applyDadEffect()
{
	if (!ClientPrefs.shaders || dad == null) return;
	dadRim = new ExtraDropShadowShader();
	configureDadGlow(dadRim);
	dadForegroundRim = new ExtraDropShadowShader();
	configureDadGlow(dadForegroundRim);
	dad.shader = null;
	dad.useRenderTexture = false;
	dadRim.attachedSprite = null;
	dadForegroundRim.attachedSprite = null;
}

function applyDeadBodyEffect()
{
	if (!ClientPrefs.shaders || deadbody == null) return;
	deadbodyRim = new ExtraDropShadowShader();
	configureRim(deadbodyRim);
	deadbodyRim.attachedSprite = deadbody;
}

function onSongStart()
{
	songLower = Paths.sanitize(songName);
	switch (songLower)
	{
		case 'mando', 'd\'low':
			if (gf.getFlag('seeThrough')) unlockAchievementPopup('oh_hey_there');
		case 'oversight':
			if (boyfriend.curCharacter == 'yellowplayable') game.unlockAchievementPopup('revenge');
	}
	FlxTween.color(skyColorPlaceholder, 120, skyColorPlaceholder.color, 0xFF222537, {
		onUpdate: function(_)
		{
			if (!isThundering)
				for (sky in skySprites) sky.color = skyColorPlaceholder.color;
		}
	});
}

function onUpdate()
{
	if (!game.startingSong && !game.endingSong && FlxG.mouse.justPressed && canPause && henryTeleporter.visible && you_can_press_the_teleporter && FlxG.mouse.overlaps(henryTeleporter)) henryTeleport();
	if (!hasDarkened && curStep >= 128) darkenStage();
	dt = FlxG.elapsed;
	for (i in 0...cloudSprites.length)
	{
		var cloud = cloudSprites[i];
		cloud.x -= cloudSpeeds[i] * dt;
		startX = cloudStartX[i];
		if (cloud.x < startX - 2500) cloud.x = startX + 2000;
	}
	thunderTimer += FlxG.elapsed;
	if (thunderTimer >= 4)
	{
		thunderTimer = 0;
		if (FlxG.random.int(1, 5) == 1)
		{
			var thunderSounds:Array<String> = ['thunder11', 'thunder22', 'thunder33'];
			FlxG.sound.play(Paths.sound(thunderSounds[FlxG.random.int(0, thunderSounds.length - 1)]), 1);
		}
	}
}

function onUpdatePost()
{
	refreshParts();
}

function onEndSong()
{
	if (endSongStarted) return Function_Continue;
	endSongStarted = true;
	camZooming = false;
	inCutscene = true;
	FlxG.sound.music.volume = 0;
	vocals.volume = 0;
	FlxTween.tween(FlxG.camera.scroll, {y: FlxG.camera.scroll.y - 800}, 3.99, {ease: FlxEase.sineInOut});
	FlxTween.tween(camHUD, {alpha: 0}, 1.2, {ease: FlxEase.quadOut});
	new FlxTimer().start(2, function(_) { FlxG.sound.play(Paths.sound('thunder44'), 1); });
	new FlxTimer().start(6, function(_) { endSongStarted = false; endSongFinished = true; });
}

function henryTeleport()
{
	dadAnim = dad.animation.curAnim != null ? dad.animation.curAnim.name : '';
	shesDead = isyellowdead || dadAnim == 'death' || dad.__prevPlayedAnimation == 'death';
	if (!shesDead)
	{
		changeCharacter('yellow-teleport', 1);
		dad.playAnim('first', true);
		dad.stunned = true;
	}
	flashers = [boyfriend];
	canPause = false;
	inCutscene = true;
	camZooming = false;
	teleporting = true;
	henryTeleporter.visible = false;
	KillNotes();
	audio.playerVolume = 0;
	audio.opponentVolume = 0;
	audio.inst.stop();
	FlxTween.tween(camHUD, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
	FlxG.sound.play(Paths.sound('stage/teleport_sound'));
	triggerEventNote('Camera Follow Pos', '750', '500');
	if (!ClientPrefs.flashing) FlxTween.num(0, 1, 2.8, {ease: FlxEase.expoIn}, flash);
	new FlxTimer().start(0.45, function(_) { shaderFlash(0, 0.73); });
	new FlxTimer().start(1.28, function(_) { flashers.push(gf); shaderFlash(0.1, 0.55); });
	new FlxTimer().start(1.93, function(_) { flashers.push(pet); shaderFlash(0.2, 0.2); if (!shesDead) dad.playAnim('second', true); });
	new FlxTimer().start(2.23, function(_) { shaderFlash(0.4, 0.22); });
	new FlxTimer().start(2.55, function(_) { shaderFlash(0.8, 0.05); });
	new FlxTimer().start(2.7, function(_) {
		flash(1);
		FlxTween.tween(boyfriend, {'scale.y': 0}, 0.7, {ease: FlxEase.expoOut});
		FlxTween.tween(boyfriend, {'scale.x': 3.5}, 0.7, {ease: FlxEase.expoOut});
	});
	new FlxTimer().start(2.8, function(_) {
		FlxTween.tween(gf, {'scale.y': 0}, 0.7, {ease: FlxEase.expoOut});
		FlxTween.tween(gf, {'scale.x': 3.5}, 0.7, {ease: FlxEase.expoOut});
	});
	new FlxTimer().start(2.75, function(_) {
		FlxTween.tween(pet, {'scale.y': 0}, 0.7, {ease: FlxEase.expoOut});
		FlxTween.tween(pet, {'scale.x': 3.5}, 0.7, {ease: FlxEase.expoOut});
	});
	new FlxTimer().start(2.9, function(_) {
		if (!shesDead)
		{
			whiteAwkward.setPosition(298, 476);
			whiteAwkward.animation.play('stare');
			dad.playAnim('third', true);
		}
	});
	new FlxTimer().start(4.5, function(_) {
		FlxG.camera.fade(FlxColor.BLACK, 1.4, false, function() { FlxG.switchState(() -> new funkin.states.HenryState()); }, true);
	});
}

function onBeatHit()
{
	if (canThunder && nextThunder >= 0 && curBeat >= nextThunder) thunderfunc();
}

function darkenStage()
{
	if (hasDarkened) return;
	hasDarkened = true;
	turnShader(true);
	hideRim();
	element0.color = 0xFF474747;
	element1.color = 0xFF474747;
	whiteAwkward.color = 0xFF474747;
	element9.alpha = 0;
	element11.color = 0xFF202020;
	element10.color = 0xFF202020;
	element6.color = 0xFF202020;
	element7.color = 0xFF202020;
	element5.color = 0xFF202020;
	element4.color = 0xFF202020;
	lightningDarkenBaseColors = [];
	for (sprite in lightningDarken)
		if (sprite != null) lightningDarkenBaseColors.push(sprite.color);
	hideRim();
}

function onStepHit()
{
	if (!hasDarkened && curStep >= 128) darkenStage();
	if (curStep == 128)
	{
		FlxG.camera.flash(FlxColor.WHITE, 0.2);
		var oldZoom:Float = FlxG.camera.zoom;
		FlxG.camera.zoom = oldZoom * 1.08;
		FlxTween.tween(FlxG.camera, {zoom: oldZoom}, 0.45, {ease: FlxEase.quadOut});
		FlxG.sound.play(Paths.sound('AHHFREDDY'));
	}
}

function thunderfunc():Void
{
	nextThunder = -1;
	if (thunderTween != null) thunderTween.cancel();
	var theThunder = thunders[FlxG.random.int(0, 2)];
	theThunder.flipX = FlxG.random.bool(50);
	theThunder.alpha = 0;
	var thunderPositions:Array<Float> = [-200, 100, 400, 700];
	theThunder.x = thunderPositions[FlxG.random.int(0, thunderPositions.length - 1)];
	FlxTween.tween(theThunder, {alpha: FlxG.random.float(0.5, 1)}, 0.1, {
		ease: FlxEase.sineIn,
		onComplete: function(_) {
			thunderTween = FlxTween.tween(theThunder, {alpha: 0}, FlxG.random.float(1.5, 2.2), {ease: FlxEase.sineIn});
		}
	});
	new FlxTimer().start(FlxG.random.float(0.1, 2), function(_) {
		var soundNumber:Int = FlxG.random.int(1, 3);
		FlxG.sound.play(Paths.sound('stage/dtThunder' + soundNumber), FlxG.random.float(0.7, 1));
	});
	isThundering = true;
	var flashDuration:Float = 0.5;
	var flashEndDuration:Float = FlxG.random.float(0.7, 1.2);
	var flashStart:Float = FlxG.random.float(0.5, 0.7);
	FlxTween.num(0, flashStart, flashDuration, {ease: FlxEase.elasticInOut}, function(intensity:Float) { lightningStuff(intensity); });
	new FlxTimer().start(flashDuration, function(_) {
		FlxTween.num(flashStart, 0, flashEndDuration, {
			ease: FlxEase.sineIn,
			onComplete: function(_) {
				isThundering = false;
				hideRim();
				setNextThunder();
			}
		}, function(intensity:Float) { lightningStuff(intensity); });
	});
}

function lightningStuff(intensity:Float):Void
{
	var c:FlxColor = FlxColor.interpolate(FlxColor.WHITE, FlxColor.BLACK, (1 - Math.pow(1 - intensity, 2)) * 0.8);
	for (i in 0...lightningDarken.length)
	{
		var sprite = lightningDarken[i];
		if (sprite == null || !sprite.exists) continue;
		if (hasDarkened)
		{
			var baseColor:Int = lightningDarkenBaseColors[i];
			var c2:FlxColor = FlxColor.interpolate(baseColor, FlxColor.BLACK, (1 - Math.pow(1 - intensity, 2)) * 0.8);
			sprite.color = c2;
		}
		else sprite.color = c;
	}
	for (i in 0...lightningLighten.length)
	{
		var sprite = lightningLighten[i];
		if (sprite == null || !sprite.exists) continue;
		var baseColor:Int = lightningLightenBaseColors[i];
		sprite.color = FlxColor.interpolate(baseColor, FlxColor.WHITE, intensity * 0.75);
	}
	if (rimEnabled && hasDarkened)
	{
		var threshold:Float = Math.pow(1 - intensity, 3);
		setRimThreshold(threshold);
	}
}

function setNextThunder():Void
{
	nextThunder = Math.ceil((curBeat + FlxG.random.int(32, 48)) / 2) * 2;
}


function onDestroy()
{
	if (shaderPartsHidden && shaderPartsSource != null) shaderPartsSource.visible = shaderPartsOriginalVisible;
	shaderPartsHidden = false;
	disposeLayers();
	shaderPartsSource = null;
	shaderPartsSourceCharacter = '';
}
