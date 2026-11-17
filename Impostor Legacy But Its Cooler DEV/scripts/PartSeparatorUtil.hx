import animate.FlxAnimateFrames;
import flixel.math.FlxMath;
import funkin.objects.FunkinSprite;

var partSeparatorManagers:Array<Dynamic> = [];
var partSeparatorSerial:Int = 0;
var partSeparatorLastError:String = '';

function psField(object:Dynamic, field:String, fallback:Dynamic = null):Dynamic
{
	if (object == null) return fallback;
	try
	{
		var value:Dynamic = Reflect.field(object, field);
		if (value != null) return value;
	}
	catch (e:Dynamic) {}
	return fallback;
}

function psString(value:Dynamic, fallback:String = ''):String
{
	if (value == null) return fallback;
	var result:String = Std.string(value);
	if (result == 'null' || result == 'undefined') return fallback;
	return result;
}

function psArray(value:Dynamic):Array<Dynamic>
{
	if (value == null) return [];
	try
	{
		if (value.length != null) return cast value;
	}
	catch (e:Dynamic) {}
	return [];
}

function psContains(values:Array<Dynamic>, value:String):Bool
{
	if (values == null || value == null || value == '') return false;
	for (entry in values)
		if (entry != null && Std.string(entry) == value) return true;
	return false;
}

function psAddUnique(values:Array<String>, value:String):Void
{
	if (values == null || value == null || value == '' || value == 'null' || value == 'undefined') return;
	if (values.indexOf(value) < 0) values.push(value);
}

function psGetLibrary(source:Dynamic):Dynamic
{
	return psField(source, 'library');
}

function psShadersEnabled():Bool
{
	try { return ClientPrefs.shaders; }
	catch (e:Dynamic) { return true; }
}

function psGetSymbol(library:Dynamic, symbolName:String):Dynamic
{
	if (library == null || symbolName == null || symbolName == '') return null;
	try { return library.getSymbol(symbolName); }
	catch (e:Dynamic) { return null; }
}

function psGetElementName(element:Dynamic):String
{
	if (element == null) return '';
	var child:Dynamic = psField(element, 'libraryItem');
	var name:String = psString(psField(child, 'name'));
	if (name != '') return name;
	name = psString(psField(element, 'symbolName'));
	if (name != '') return name;
	name = psString(psField(element, 'name'));
	if (name != '') return name;
	var frame:Dynamic = psField(element, 'frame');
	name = psString(psField(frame, 'name'));
	if (name != '') return name;
	return psString(psField(element, 'bitmap'));
}

function psGetElementNames(element:Dynamic):Array<String>
{
	var names:Array<String> = [];
	if (element == null) return names;
	for (field in ['symbolName', 'name', 'instanceName', 'bitmap'])
		psAddUnique(names, psString(psField(element, field)));
	var child:Dynamic = psField(element, 'libraryItem');
	psAddUnique(names, psString(psField(child, 'name')));
	var frame:Dynamic = psField(element, 'frame');
	psAddUnique(names, psString(psField(frame, 'name')));
	return names;
}

function psGetChildItem(sprite:Dynamic, element:Dynamic):Dynamic
{
	if (element == null) return null;
	var item:Dynamic = psField(element, 'libraryItem');
	if (item != null && psField(item, 'timeline') != null) return item;
	var childName:String = psGetElementName(element);
	var library:Dynamic = psGetLibrary(sprite);
	return psGetSymbol(library, childName);
}

function psGetAnimationDescriptors(source:Dynamic, config:Dynamic = null):Array<Dynamic>
{
	var result:Array<Dynamic> = [];
	if (source == null) return result;
	var library:Dynamic = psGetLibrary(source);
	var animations:Array<Dynamic> = psArray(psField(source, 'animations'));
	for (data in animations)
	{
		if (data == null) continue;
		var first:String = psString(psField(data, 'anim'));
		var second:String = psString(psField(data, 'name'));
		if (first == '' && second == '') continue;
		var firstSymbol:Dynamic = psGetSymbol(library, first);
		var secondSymbol:Dynamic = psGetSymbol(library, second);
		var animationName:String = first;
		var symbolName:String = second;
		if (secondSymbol == null && firstSymbol != null)
		{
			animationName = second;
			symbolName = first;
		}
		if (animationName == '') animationName = symbolName;
		if (symbolName == '') symbolName = animationName;
		var duplicate:Bool = false;
		for (entry in result)
			if (entry.animation == animationName && entry.symbol == symbolName) duplicate = true;
		if (!duplicate)
			result.push({data:data, animation:animationName, symbol:symbolName});
	}
	for (overrideData in psArray(psField(config, 'animationOverrides')))
	{
		if (overrideData == null) continue;
		var animationName:String = psString(psField(overrideData, 'animation', psField(overrideData, 'name')));
		var symbolName:String = psString(psField(overrideData, 'symbol'));
		if (animationName == '' || symbolName == '') continue;
		var replaced:Bool = false;
		for (i in 0...result.length)
		{
			if (result[i].animation == animationName)
			{
				result[i] = {data:overrideData, animation:animationName, symbol:symbolName};
				replaced = true;
				break;
			}
		}
		if (!replaced) result.push({data:overrideData, animation:animationName, symbol:symbolName});
	}
	return result;
}

function psGetRootSymbols(source:Dynamic, descriptors:Array<Dynamic>):Array<String>
{
	var roots:Array<String> = [];
	var library:Dynamic = psGetLibrary(source);
	var timeline:Dynamic = psField(library, 'timeline');
	psAddUnique(roots, psString(psField(timeline, 'name')));
	for (entry in descriptors)
		if (entry != null) psAddUnique(roots, entry.symbol);
	return roots;
}

function psGetScopedSelectors(config:Dynamic):Array<Dynamic>
{
	var result:Array<Dynamic> = [];
	for (entry in psArray(psField(config, 'selectors')))
		if (entry != null) result.push(entry);
	for (entry in psArray(psField(config, 'layers')))
		if (entry != null) result.push(entry);
	return result;
}

function psIsWholeSymbol(config:Dynamic, symbolName:String):Bool
{
	if (symbolName == null || symbolName == '') return false;
	if (psContains(psArray(psField(config, 'symbols')), symbolName)) return true;
	for (entry in psGetScopedSelectors(config))
	{
		var selectedSymbol:String = psString(psField(entry, 'symbol'));
		if (selectedSymbol == symbolName && psField(entry, 'whole', false) == true) return true;
	}
	return false;
}

function psLayerSelected(config:Dynamic, symbolName:String, layerName:String):Bool
{
	if (layerName == null || layerName == '') return false;
	for (entry in psGetScopedSelectors(config))
	{
		var selectedSymbol:String = psString(psField(entry, 'symbol'));
		if (selectedSymbol != '' && selectedSymbol != symbolName) continue;
		var names:Array<Dynamic> = psArray(psField(entry, 'layers'));
		if (names.length == 0) names = psArray(psField(entry, 'names'));
		if (psContains(names, layerName)) return true;
	}
	return false;
}

function psElementSelected(config:Dynamic, symbolName:String, element:Dynamic):Bool
{
	var names:Array<String> = psGetElementNames(element);
	var selected:Array<Dynamic> = psArray(psField(config, 'elements'));
	if (selected.length == 0) selected = psArray(psField(config, 'matchElements'));
	for (name in names)
		if (psContains(selected, name)) return true;
	for (entry in psGetScopedSelectors(config))
	{
		var selectedSymbol:String = psString(psField(entry, 'symbol'));
		if (selectedSymbol != '' && selectedSymbol != symbolName) continue;
		var scoped:Array<Dynamic> = psArray(psField(entry, 'elements'));
		for (name in names)
			if (psContains(scoped, name)) return true;
	}
	return false;
}

function psMarkFrameDirty(frame:Dynamic):Void
{
	if (frame == null) return;
	try { frame.setDirty(); } catch (e:Dynamic) {}
}

function psInvalidateSprite(sprite:Dynamic):Void
{
	if (sprite == null) return;
	try { Reflect.setField(sprite, '_renderTextureDirty', true); } catch (e:Dynamic) {}
}

function psDetachShader(sprite:Dynamic):Void
{
	if (sprite == null) return;
	var shader:Dynamic = psField(sprite, 'shader');
	if (shader != null)
	{
		try
		{
			if (psField(shader, 'attachedSprite') == sprite)
				Reflect.setField(shader, 'attachedSprite', null);
		}
		catch (e:Dynamic) {}
	}
	try { sprite.shader = null; } catch (e:Dynamic) {}
	try { sprite.useRenderTexture = false; } catch (e:Dynamic) {}
}

function psFilterOverlayItem(sprite:Dynamic, item:Dynamic, config:Dynamic, stack:Array<String>, forceAll:Bool = false):Bool
{
	if (item == null) return false;
	var symbolName:String = psString(psField(item, 'name'));
	if (symbolName != '' && stack.indexOf(symbolName) >= 0) return false;
	var timeline:Dynamic = psField(item, 'timeline');
	var layers:Array<Dynamic> = psArray(psField(timeline, 'layers'));
	if (timeline == null || layers.length == 0) return false;
	if (symbolName != '' && psIsWholeSymbol(config, symbolName)) forceAll = true;
	if (symbolName != '') stack.push(symbolName);
	var found:Bool = forceAll;
	for (layer in layers)
	{
		if (layer == null) continue;
		var layerName:String = psString(psField(layer, 'name'));
		var keepLayer:Bool = forceAll || psLayerSelected(config, symbolName, layerName);
		if (keepLayer) found = true;
		try
		{
			layer.forEachFrame(function(frame)
			{
				if (frame == null || psField(frame, 'elements') == null) return;
				var elements:Array<Dynamic> = psArray(psField(frame, 'elements'));
				var changed:Bool = false;
				for (element in elements)
				{
					if (element == null) continue;
					var childName:String = psGetElementName(element);
					var direct:Bool = psElementSelected(config, symbolName, element);
					var wholeChild:Bool = psIsWholeSymbol(config, childName);
					var keep:Bool = keepLayer || direct || wholeChild;
					var childItem:Dynamic = psGetChildItem(sprite, element);
					if (childItem != null && childName != '')
					{
						var childHas:Bool = psFilterOverlayItem(sprite, childItem, config, stack, keepLayer || direct || wholeChild);
						if (!keep && childHas) keep = true;
					}
					var oldVisible:Bool = psField(element, 'visible', true) == true;
					var newVisible:Bool = oldVisible && keep;
					if (oldVisible != newVisible)
					{
						try { element.visible = newVisible; } catch (e:Dynamic) {}
						changed = true;
					}
					if (keep) found = true;
				}
				if (changed) psMarkFrameDirty(frame);
			});
		}
		catch (e:Dynamic) {}
	}
	if (symbolName != '') stack.pop();
	return found;
}

function psSaveAndHideElement(manager:Dynamic, element:Dynamic, frame:Dynamic):Int
{
	if (manager == null || element == null) return 0;
	var backup:Array<Dynamic> = psArray(psField(manager, 'visibilityBackup'));
	var exists:Bool = false;
	for (entry in backup)
		if (entry != null && entry.element == element) exists = true;
	if (!exists)
		backup.push({element:element, visible:psField(element, 'visible', true), frame:frame});
	try { element.visible = false; } catch (e:Dynamic) {}
	psMarkFrameDirty(frame);
	return 1;
}

function psHideSourceItem(manager:Dynamic, source:Dynamic, item:Dynamic, config:Dynamic, stack:Array<String>, forceAll:Bool = false):Int
{
	if (item == null) return 0;
	var symbolName:String = psString(psField(item, 'name'));
	if (symbolName != '' && stack.indexOf(symbolName) >= 0) return 0;
	var timeline:Dynamic = psField(item, 'timeline');
	var layers:Array<Dynamic> = psArray(psField(timeline, 'layers'));
	if (timeline == null || layers.length == 0) return 0;
	if (symbolName != '' && psIsWholeSymbol(config, symbolName)) forceAll = true;
	if (symbolName != '') stack.push(symbolName);
	var matched:Int = 0;
	for (layer in layers)
	{
		if (layer == null) continue;
		var layerName:String = psString(psField(layer, 'name'));
		var hideLayer:Bool = forceAll || psLayerSelected(config, symbolName, layerName);
		try
		{
			layer.forEachFrame(function(frame)
			{
				if (frame == null || psField(frame, 'elements') == null) return;
				var elements:Array<Dynamic> = psArray(psField(frame, 'elements'));
				var changed:Bool = false;
				for (element in elements)
				{
					if (element == null) continue;
					var childName:String = psGetElementName(element);
					var direct:Bool = hideLayer || psElementSelected(config, symbolName, element) || psIsWholeSymbol(config, childName);
					if (direct)
					{
						matched += psSaveAndHideElement(manager, element, frame);
					changed = true;
					}
					else
					{
						var childItem:Dynamic = psGetChildItem(source, element);
					if (childItem != null && childName != '')
						matched += psHideSourceItem(manager, source, childItem, config, stack, false);
					}
				}
				if (changed) psMarkFrameDirty(frame);
			});
		}
		catch (e:Dynamic) {}
	}
	if (symbolName != '') stack.pop();
	return matched;
}

function psRestoreSource(manager:Dynamic):Void
{
	if (manager == null) return;
	var backup:Array<Dynamic> = psArray(psField(manager, 'visibilityBackup'));
	for (entry in backup)
	{
		if (entry == null || entry.element == null) continue;
		try { entry.element.visible = entry.visible; } catch (e:Dynamic) {}
		psMarkFrameDirty(entry.frame);
	}
	manager.visibilityBackup = [];
	var source:Dynamic = psField(manager, 'source');
	psInvalidateSprite(source);
}

function psCopyAnimations(source:Dynamic, target:FunkinSprite, descriptors:Array<Dynamic>):Int
{
	if (source == null || target == null) return 0;
	var added:Int = 0;
	var suffix:String = psString(psField(source, 'animSuffix'));
	for (entry in descriptors)
	{
		if (entry == null || entry.data == null) continue;
		var data:Dynamic = entry.data;
		var animationName:String = psString(entry.animation);
		var symbolName:String = psString(entry.symbol);
		if (animationName == '' || symbolName == '') continue;
		var fps:Int = Std.int(psField(data, 'fps', 24));
		if (fps <= 0) fps = 24;
		var looped:Bool = psField(data, 'loop', false) == true;
		var flipX:Bool = psField(data, 'flipX', false) == true;
		var flipY:Bool = psField(data, 'flipY', false) == true;
		var indices:Array<Dynamic> = psArray(psField(data, 'indices'));
		try
		{
			if (indices.length > 0)
				target.addAnimByIndices(animationName, symbolName, indices, fps, looped, flipX, flipY);
			else
				target.addAnimByPrefix(animationName, symbolName, fps, looped, flipX, flipY);
			var offsets:Array<Dynamic> = psArray(psField(data, 'offsets'));
			if (offsets.length > 1)
				target.addOffset(animationName, offsets[0], offsets[1]);
			else
				target.addOffset(animationName, 0, 0);
			added++;
		}
		catch (e:Dynamic) {}
		if (suffix != '')
		{
			var suffixed:String = animationName + suffix;
			if (!target.hasAnim(suffixed))
			{
				try
				{
					if (indices.length > 0)
					target.addAnimByIndices(suffixed, symbolName, indices, fps, looped, flipX, flipY);
					else
					target.addAnimByPrefix(suffixed, symbolName, fps, looped, flipX, flipY);
					var suffixedOffsets:Array<Dynamic> = psArray(psField(data, 'offsets'));
					if (suffixedOffsets.length > 1)
						target.addOffset(suffixed, suffixedOffsets[0], suffixedOffsets[1]);
					else
						target.addOffset(suffixed, 0, 0);
				}
				catch (e:Dynamic) {}
			}
		}
	}
	return added;
}

function psCreateOverlay(manager:Dynamic, source:Dynamic, ownerGroup:Dynamic, partConfig:Dynamic, descriptors:Array<Dynamic>, partId:String):Dynamic
{
	if (source == null || psGetLibrary(source) == null || ownerGroup == null) return null;
	var imageFile:String = psString(psField(source, 'imageFile'));
	if (imageFile == '') return null;
	var atlasPath:String = '';
	try { atlasPath = Paths.getPath('images/' + imageFile, null, PathsTestMode.LOOSE); }
	catch (e:Dynamic) { return null; }
	if (atlasPath == null || atlasPath == '') return null;
	partSeparatorSerial++;
	var characterName:String = psString(psField(source, 'curCharacter'), 'character');
	var safeImage:String = StringTools.replace(imageFile, '/', '_');
	var uniqueName:String = 'partSeparator_${partSeparatorSerial}_${characterName}_${partId}_${safeImage}';
	var frames:FlxAnimateFrames = null;
	try
	{
		frames = FlxAnimateFrames.fromAnimate(atlasPath, null, null, uniqueName, true, {cacheOnLoad:false});
	}
	catch (e:Dynamic) { frames = null; }
	if (frames == null) return null;
	var sprite:FunkinSprite = new FunkinSprite(0, 0);
	sprite.frames = frames;
	var animationCount:Int = psCopyAnimations(source, sprite, descriptors);
	if (animationCount <= 0)
	{
		sprite.destroy();
		return null;
	}
	var found:Int = 0;
	for (entry in descriptors)
	{
		if (entry == null) continue;
		var symbol:Dynamic = psGetSymbol(psGetLibrary(sprite), psString(entry.symbol));
		if (symbol == null) continue;
		if (psFilterOverlayItem(sprite, symbol, partConfig, [], false)) found++;
	}
	if (found <= 0)
	{
		sprite.destroy();
		return null;
	}
	try
	{
		sprite.scalableOffsets = source.scalableOffsets;
		sprite.rotatableOffsets = source.rotatableOffsets;
		sprite.skewableOffsets = source.skewableOffsets;
		sprite.baseFlipX = source.baseFlipX;
		sprite.baseFlipY = source.baseFlipY;
		sprite.antialiasing = source.antialiasing;
	}
	catch (e:Dynamic) {}
	sprite.shader = null;
	sprite.useRenderTexture = false;
	sprite.cameras = psField(source, 'cameras', [camGame]);
	sprite.scrollFactor.set(source.scrollFactor.x, source.scrollFactor.y);
	sprite.active = false;
	sprite.visible = false;
	try { ownerGroup.add(sprite); }
	catch (e:Dynamic)
	{
		sprite.destroy();
		return null;
	}
	return {
		id:partId,
		config:partConfig,
		sprite:sprite,
		lastAnimation:'',
		allowShader:psField(partConfig, 'allowShader', false) == true,
		allowRenderTexture:psField(partConfig, 'allowRenderTexture', false) == true,
		registered:false
	};
}

function psFindPart(manager:Dynamic, partId:String):Dynamic
{
	if (manager == null || partId == null) return null;
	for (part in psArray(psField(manager, 'parts')))
		if (part != null && part.id == partId) return part;
	return null;
}

function psRemoveOverlay(manager:Dynamic, part:Dynamic):Void
{
	if (part == null || part.sprite == null) return;
	var sprite:FunkinSprite = part.sprite;
	psDetachShader(sprite);
	var group:Dynamic = psField(manager, 'ownerGroup');
	try
	{
		if (group != null) group.remove(sprite, true);
	}
	catch (e:Dynamic) {}
	try { sprite.destroy(); } catch (e:Dynamic) {}
	part.sprite = null;
}

function psDisposeParts(manager:Dynamic):Void
{
	if (manager == null) return;
	for (part in psArray(psField(manager, 'parts')))
		psRemoveOverlay(manager, part);
	manager.parts = [];
}

function psSourceSignature(source:Dynamic):String
{
	if (source == null) return '';
	return psString(psField(source, 'curCharacter')) + '|' + psString(psField(source, 'imageFile'));
}

function psBuildManager(manager:Dynamic, source:Dynamic):Bool
{
	if (manager == null || source == null || psGetLibrary(source) == null) return false;
	manager.source = source;
	manager.signature = psSourceSignature(source);
	manager.library = psGetLibrary(source);
	manager.visibilityBackup = [];
	manager.parts = [];
	var descriptors:Array<Dynamic> = psGetAnimationDescriptors(source, manager.config);
	if (descriptors.length == 0) return false;
	var configs:Array<Dynamic> = psArray(psField(manager.config, 'parts'));
	for (index in 0...configs.length)
	{
		var partConfig:Dynamic = configs[index];
		if (partConfig == null) continue;
		var partId:String = psString(psField(partConfig, 'id'), 'part' + index);
		if (psFindPart(manager, partId) != null) continue;
		var part:Dynamic = psCreateOverlay(manager, source, manager.ownerGroup, partConfig, descriptors, partId);
		if (part != null) manager.parts.push(part);
	}
	if (manager.parts.length == 0)
	{
		manager.lastError = 'No configured part could be extracted from this Animate atlas.';
		partSeparatorLastError = manager.lastError;
		return false;
	}
	var validParts:Array<Dynamic> = [];
	for (part in manager.parts)
	{
		var matched:Int = 0;
		var roots:Array<String> = psGetRootSymbols(source, descriptors);
		for (rootName in roots)
		{
			var root:Dynamic = psGetSymbol(psGetLibrary(source), rootName);
			if (root != null)
				matched += psHideSourceItem(manager, source, root, part.config, [], false);
		}
		if (matched > 0)
		{
			part.registered = true;
			validParts.push(part);
		}
		else
		{
			psRemoveOverlay(manager, part);
		}
	}
	manager.parts = validParts;
	if (manager.parts.length == 0)
	{
		psRestoreSource(manager);
		manager.lastError = 'The selected elements were found in the overlay atlas but not in the source character.';
		partSeparatorLastError = manager.lastError;
		return false;
	}
	psInvalidateSprite(source);
	for (part in manager.parts) psSyncPart(source, part);
	try { refreshZ(); } catch (e:Dynamic) {}
	manager.lastError = '';
	partSeparatorLastError = '';
	return true;
}

function createPartSeparator(source:FunkinSprite, ownerGroup:Dynamic, config:Dynamic):Dynamic
{
	if (source == null || ownerGroup == null || config == null) return null;
	for (existing in partSeparatorManagers)
	{
		if (existing == null || existing.active != true || existing.source != source) continue;
		if (existing.ownerGroup != ownerGroup) return existing;
		var merged:Array<Dynamic> = psArray(psField(existing.config, 'parts')).copy();
		for (incoming in psArray(psField(config, 'parts')))
		{
			if (incoming == null) continue;
			var incomingId:String = psString(psField(incoming, 'id'));
			var replaced:Bool = false;
			for (i in 0...merged.length)
			{
				if (psString(psField(merged[i], 'id')) == incomingId && incomingId != '')
				{
					merged[i] = incoming;
					replaced = true;
					break;
				}
			}
			if (!replaced) merged.push(incoming);
		}
		var mergedConfig:Dynamic = {parts:merged};
		var incomingOverrides:Dynamic = psField(config, 'animationOverrides', psField(existing.config, 'animationOverrides'));
		if (incomingOverrides != null) mergedConfig.animationOverrides = incomingOverrides;
		psRestoreSource(existing);
		psDisposeParts(existing);
		existing.config = mergedConfig;
		if (!psBuildManager(existing, source))
		{
			psRestoreSource(existing);
			psDisposeParts(existing);
			existing.lastError = 'Could not merge the additional part definitions.';
			partSeparatorLastError = existing.lastError;
		}
		return existing;
	}
	var manager:Dynamic = {
		source:source,
		ownerGroup:ownerGroup,
		config:config,
		parts:[],
		visibilityBackup:[],
		active:true,
		signature:'',
		library:null,
		lastError:''
	};
	if (!psBuildManager(manager, source))
	{
		psRestoreSource(manager);
		psDisposeParts(manager);
		manager.active = false;
		partSeparatorLastError = manager.lastError;
		return null;
	}
	partSeparatorManagers.push(manager);
	return manager;
}

function psCopyColorTransform(source:Dynamic, target:Dynamic):Void
{
	if (source == null || target == null) return;
	var sourceTransform:Dynamic = psField(source, 'colorTransform');
	var targetTransform:Dynamic = psField(target, 'colorTransform');
	if (sourceTransform == null || targetTransform == null) return;
	for (field in ['redMultiplier', 'greenMultiplier', 'blueMultiplier', 'alphaMultiplier', 'redOffset', 'greenOffset', 'blueOffset', 'alphaOffset'])
	{
		try { Reflect.setField(targetTransform, field, Reflect.field(sourceTransform, field)); }
		catch (e:Dynamic) {}
	}
}

function psResolvePartAnimation(source:Dynamic, sprite:FunkinSprite, partConfig:Dynamic):String
{
	var current:String = '';
	try { current = source.getAnimName(); } catch (e:Dynamic) {}
	if (current == '')
	{
		var cur:Dynamic = psField(psField(source, 'animation'), 'curAnim');
		current = psString(psField(cur, 'name'));
	}
	if (current == '') return '';
	var map:Dynamic = psField(partConfig, 'animationMap');
	var mapped:String = psString(psField(map, current));
	if (mapped != '') current = mapped;
	if (sprite.hasAnim(current)) return current;
	var suffix:String = psString(psField(source, 'animSuffix'));
	if (suffix != '' && sprite.hasAnim(current + suffix)) return current + suffix;
	return '';
}

function psSyncAnimation(source:Dynamic, part:Dynamic):Bool
{
	if (source == null || part == null || part.sprite == null) return false;
	var sprite:FunkinSprite = part.sprite;
	var wanted:String = psResolvePartAnimation(source, sprite, part.config);
	if (wanted == '')
	{
		part.lastAnimation = '';
		return false;
	}
	var sourceCur:Dynamic = psField(psField(source, 'animation'), 'curAnim');
	var targetCur:Dynamic = psField(psField(sprite, 'animation'), 'curAnim');
	var reversed:Bool = psField(sourceCur, 'reversed', false) == true;
	var sourceFrame:Int = Std.int(psField(sourceCur, 'curFrame', psField(source, 'animCurFrame', 0)));
	if (part.lastAnimation != wanted || sprite.isAnimNull())
	{
		try { sprite.playAnim(wanted, true, reversed, sourceFrame); }
		catch (e:Dynamic)
		{
			try { sprite.playAnim(wanted, true, reversed); }
			catch (e2:Dynamic) { return false; }
		}
		part.lastAnimation = wanted;
		try
		{
			if (sprite.animation.curAnim != null) sprite.animation.curAnim.pause();
		}
		catch (e:Dynamic) {}
	}
	targetCur = psField(psField(sprite, 'animation'), 'curAnim');
	if (sourceCur != null && targetCur != null)
	{
		var sourceFrames:Int = Std.int(psField(sourceCur, 'numFrames', 0));
		var targetFrames:Int = Std.int(psField(targetCur, 'numFrames', 0));
		if (sourceFrames <= 0) sourceFrames = Std.int(psField(source, 'animNumFrames', 0));
		if (targetFrames <= 0) targetFrames = Std.int(psField(sprite, 'animNumFrames', 0));
		if (sourceFrames > 0 && targetFrames > 0)
		{
			sourceFrame = Std.int(FlxMath.bound(sourceFrame, 0, sourceFrames - 1));
			var targetFrame:Int = sourceFrames == targetFrames
				? sourceFrame
				: Math.round((sourceFrames <= 1 ? 0 : sourceFrame / (sourceFrames - 1)) * (targetFrames - 1));
			targetFrame = Std.int(FlxMath.bound(targetFrame, 0, targetFrames - 1));
			try { targetCur.curFrame = targetFrame; } catch (e:Dynamic) {}
			try { sprite.animCurFrame = targetFrame; } catch (e:Dynamic) {}
			try { sprite.animation.frameIndex = targetFrame; } catch (e:Dynamic) {}
		}
		for (field in ['frameTimer', 'finished', 'reversed'])
		{
			try
			{
				var value:Dynamic = Reflect.field(sourceCur, field);
				if (value != null) Reflect.setField(targetCur, field, value);
			}
			catch (e:Dynamic) {}
		}
	}
	return true;
}

function psSyncPart(source:Dynamic, part:Dynamic):Void
{
	if (source == null || part == null || part.sprite == null) return;
	var sprite:FunkinSprite = part.sprite;
	var valid:Bool = psSyncAnimation(source, part);
	var config:Dynamic = part.config;
	var xOffset:Float = psField(config, 'xOffset', 0.0);
	var yOffset:Float = psField(config, 'yOffset', 0.0);
	var scaleX:Float = psField(config, 'scaleX', 1.0);
	var scaleY:Float = psField(config, 'scaleY', 1.0);
	var alphaMultiplier:Float = psField(config, 'alpha', 1.0);
	var angleOffset:Float = psField(config, 'angleOffset', 0.0);
	var zOffset:Float = psField(config, 'zOffset', 0.01);
	try
	{
		sprite.x = source.x + xOffset;
		sprite.y = source.y + yOffset;
		sprite.scale.set(source.scale.x * scaleX, source.scale.y * scaleY);
		sprite.baseScale.set(source.baseScale.x * scaleX, source.baseScale.y * scaleY);
		sprite.origin.set(source.origin.x, source.origin.y);
		sprite.offset.set(source.offset.x, source.offset.y);
		sprite.spriteOffset.set(source.spriteOffset.x, source.spriteOffset.y);
		sprite.animOffset.set(source.animOffset.x, source.animOffset.y);
		sprite.angle = source.angle + angleOffset;
		sprite.skew.set(source.skew.x, source.skew.y);
		sprite.flipX = source.flipX;
		sprite.flipY = source.flipY;
		if (psField(config, 'inheritAlpha', true) == true)
			sprite.alpha = source.alpha * alphaMultiplier;
		if (psField(config, 'inheritColor', true) == true)
			sprite.color = source.color;
		if (psField(config, 'inheritBlend', true) == true)
			sprite.blend = source.blend;
		sprite.scrollFactor.set(source.scrollFactor.x, source.scrollFactor.y);
		sprite.antialiasing = source.antialiasing;
		sprite.scalableOffsets = source.scalableOffsets;
		sprite.rotatableOffsets = source.rotatableOffsets;
		sprite.skewableOffsets = source.skewableOffsets;
		sprite.baseFlipX = source.baseFlipX;
		sprite.baseFlipY = source.baseFlipY;
		sprite.cameras = psField(source, 'cameras', [camGame]);
	}
	catch (e:Dynamic) {}
	if (psField(config, 'inheritColorTransform', true) == true)
		psCopyColorTransform(source, sprite);
	try { sprite.applyStageMatrix = source.applyStageMatrix; } catch (e:Dynamic) {}
	try { sprite.postStageMatrixApply = source.postStageMatrixApply; } catch (e:Dynamic) {}
	var desiredZ:Float = source.zIndex + zOffset;
	if (sprite.zIndex != desiredZ)
	{
		sprite.zIndex = desiredZ;
		try { refreshZ(); } catch (e:Dynamic) {}
	}
	if (part.allowShader != true || !psShadersEnabled())
		psDetachShader(sprite);
	else if (part.allowRenderTexture != true)
	{
		sprite.useRenderTexture = false;
	}
	var shouldShow:Bool = valid && source.exists && source.visible && source.alpha > 0 && psField(config, 'visible', true) != false;
	sprite.active = false;
	sprite.visible = shouldShow;
}

function updatePartSeparator(manager:Dynamic, source:FunkinSprite = null):Void
{
	if (manager == null || manager.active != true) return;
	var currentSource:FunkinSprite = source != null ? source : manager.source;
	if (currentSource == null) return;
	var changed:Bool = currentSource != manager.source
		|| psSourceSignature(currentSource) != manager.signature
		|| psGetLibrary(currentSource) != manager.library;
	if (changed)
	{
		psRestoreSource(manager);
		psDisposeParts(manager);
		manager.source = currentSource;
		if (!psBuildManager(manager, currentSource))
		{
			psRestoreSource(manager);
			psDisposeParts(manager);
			manager.lastError = 'Could not rebuild separated parts for the new character.';
			partSeparatorLastError = manager.lastError;
			return;
		}
	}
	for (part in psArray(manager.parts))
		psSyncPart(currentSource, part);
}

function getSeparatedPart(manager:Dynamic, partId:String):FunkinSprite
{
	var part:Dynamic = psFindPart(manager, partId);
	return part == null ? null : part.sprite;
}

function getPartSeparatorError(manager:Dynamic = null):String
{
	return manager != null ? psString(psField(manager, 'lastError')) : partSeparatorLastError;
}

function setSeparatedPartShader(manager:Dynamic, partId:String, shader:Dynamic, useRenderTexture:Bool = false):Bool
{
	var part:Dynamic = psFindPart(manager, partId);
	if (part == null || part.sprite == null) return false;
	if (shader == null)
	{
		part.sprite.shader = null;
		part.sprite.useRenderTexture = false;
		return true;
	}
	if (part.allowShader != true || !psShadersEnabled()) return false;
	if (useRenderTexture && part.allowRenderTexture != true) return false;
	part.sprite.shader = shader;
	part.sprite.useRenderTexture = useRenderTexture;
	try { Reflect.setField(shader, 'attachedSprite', part.sprite); } catch (e:Dynamic) {}
	return true;
}

function destroyPartSeparator(manager:Dynamic):Void
{
	if (manager == null || manager.active != true) return;
	psRestoreSource(manager);
	psDisposeParts(manager);
	manager.active = false;
	for (i in 0...partSeparatorManagers.length)
	{
		if (partSeparatorManagers[i] == manager)
		{
			partSeparatorManagers.splice(i, 1);
			break;
		}
	}
	try { refreshZ(); } catch (e:Dynamic) {}
}
