import openfl.filters.ShaderFilter;

import funkin.game.shaders.ChromaticAbberation;
import funkin.game.shaders.HeatwaveShader;

var chromTween:FlxTween;
var caShader:ChromaticAbberation;
var heatwaveShader:HeatwaveShader;
var ref:FlxSprite;

function onCreatePost()
{
	caShader = new ChromaticAbberation(0);
	caShader.amount = -0.1;

	heatwaveShader = new HeatwaveShader();

	if (ClientPrefs.shaders)
	{
		FlxG.camera.filters = [
			new ShaderFilter(heatwaveShader.shader),
			new ShaderFilter(caShader.shader)
		];
	}

	snapCamToPos(1760, 340);
	defaultCamZoom = 0.7;
}