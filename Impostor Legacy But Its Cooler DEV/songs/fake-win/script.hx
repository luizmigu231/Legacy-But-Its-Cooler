import funkin.game.shaders.ExtraDropShadowShader;

var maroon:Character;

function createRim(angle:Float):ExtraDropShadowShader
{
	var rim = new ExtraDropShadowShader();
	rim.threshold = 0.05;
	rim.strength = 0.85;
	rim.setColorMatrix([
		0.70, 0.10,  0.00, 0, -5,
		0.00, 0.70, -0.25, 0,  0,
		0.00,-0.15, 0.75, 0, -1,
		0.00, 0.80, 0.00, 1,  0
	]);
	var layerMatrix = [
		8, 18,  0, -1,   0,
		0.3, 2.5, -1.5, 0, 85,
		0, -1.5, -5.5, 0, -5,
		0,  9,   0,  9,  0
	];
	rim.addLayer(layerMatrix, angle, 16, 0.08, 0.30, 1.00);
	return rim;
}


function onCreatePost()
{
	maroon = new Character(gfGroup.x - 480, gfGroup.y + 100, "maroon");
	maroon.scale.set(0.87, 0.87);
	stage.insert(stage.members.indexOf(gfGroup), maroon);
	maroon.onBeatHit();
	maroon.alpha = 0;
	maroon.useRenderTexture = true;
	maroon.shader = createRim(46);
	maroon.shader.attachedSprite = maroon;

	playHUD.timeBar.visible = playHUD.timeTxt.visible = false;
}

function onEvent(ev, v1, v2)
{
	if (ev == "Play Animation")
	{
		dad.canDance = false;
		FlxTween.tween(opponentStrums, {alpha: 0}, 1, {ease:FlxEase.quadOut});
	}
}

function onBeatHit()
{
	if (curBeat == 12)
	{
		FlxTween.tween(maroon, {alpha: 1}, 2, {ease:FlxEase.quadOut});
		maroon.playAnim("hey");
		FlxG.sound.play(Paths.sound("gaster"));
	}
}