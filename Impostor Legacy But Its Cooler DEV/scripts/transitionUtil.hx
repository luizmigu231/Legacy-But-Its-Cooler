public function tweenColorTransform(sprite:FlxSprite, red:Float, green:Float, blue:Float, duration:Float, ease:FlxEase)
{
	FlxTween.tween(sprite.colorTransform, {redMultiplier: red, greenMultiplier: green, blueMultiplier: blue}, duration, {ease: ease});
}

public function tweenShadowLayer(layer1:Dynamic, layer2:Array<Dynamic>, duration:Float, ease:FlxEase)
{
    var startMatrix:Array<Float> = layer1.colorMatrix.copy();
    var targetMatrix:Array<Float> = layer2[0];

    for (i in 0...startMatrix.length)
    {
        var index = i;

        FlxTween.num(startMatrix[index], targetMatrix[index], duration, {
            ease: ease,
            onUpdate: function(twn:FlxTween)
            {
                var matrix:Array<Float> = layer1.colorMatrix.copy();
                matrix[index] = twn.value;
                layer1.colorMatrix = matrix;
            }
        });
    }

    FlxTween.tween(layer1, {
        angle: layer2[1] ?? 0,
        distance: layer2[2] ?? 20,
        threshold: layer2[3] ?? .01,
        strength: layer2[4] ?? 1,
        roughness: layer2[5] ?? 1
    }, duration, {ease: ease});
}

public function tweenColorMatrix(shader:ExtraDropShadowShader, target:Array<Float>, duration:Float, ease:FlxEase)
{
    var startMatrix:Array<Float> = shader.colorMatrix.copy();
    for (i in 0...4)
        startMatrix[i * 5 + 4] *= 255;

    for (i in 0...startMatrix.length)
    {
        var index = i;

        FlxTween.num(startMatrix[index], target[index], duration, {
            ease: ease,
            onUpdate: function(twn:FlxTween)
            {
                var matrix:Array<Float> = shader.colorMatrix.copy();

                for (j in 0...4)
                    matrix[j * 5 + 4] *= 255;

                matrix[index] = twn.value;
                shader.colorMatrix = matrix;
            }
        });
    }
}

public function getBaseMatrix()
{
	return [
		1, 0, 0, 0, 0,
		0, 1, 0, 0, 0,
		0, 0, 1, 0, 0,
		0, 0, 0, 1, 0
	];
}