import funkin.game.shaders.ChromaticAbberation;
import flixel.FlxG;
import flixel.addons.display.FlxRuntimeShader;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import openfl.filters.ShaderFilter;

var chromGame:ChromaticAbberation;
var chromHUD:FlxRuntimeShader;

var chromGameValue:Float = 0;
var chromHUDValue:Float = 0;

var chromGameTween:FlxTween;
var chromHUDTween:FlxTween;

var chromGameObj:Dynamic;
var chromHUDObj:Dynamic;

var chromReady:Bool = false;

function onCreatePost()
{
    if (!ClientPrefs.shaders) return;

    chromGame = new ChromaticAbberation(0);

    chromHUD = new FlxRuntimeShader(
        Paths.getTextFromFile('shaders/chromaticHUD.frag')
    );

    chromGame.amount = 0;
    chromHUD.setFloat('amount', 0);

    chromGameObj = {value: 0};
    chromHUDObj = {value: 0};

    FlxG.camera.filters = [
        new ShaderFilter(chromGame.shader)
    ];

    camHUD.filters = [
        new ShaderFilter(chromHUD)
    ];

    chromReady = true;
}

function onUpdate(elapsed:Float)
{
    if (!chromReady) return;

    chromGame.amount = chromGameObj.value;
    chromHUD.setFloat('amount', chromHUDObj.value);
}

function onEvent(eventName, value1, value2)
{
    if (eventName != 'chromControl') return;
    if (!chromReady) return;

    var amount:Float = Std.parseFloat(value1);
    if (Math.isNaN(amount))
        amount = 0;

    var duration:Float = Std.parseFloat(value2);
    if (Math.isNaN(duration))
        duration = 0;

    if (chromGameTween != null)
        chromGameTween.cancel();

    if (chromHUDTween != null)
        chromHUDTween.cancel();

    if (duration <= 0)
    {
        chromGameObj.value = amount;
        chromHUDObj.value = amount;

        chromGame.amount = amount;
        chromHUD.setFloat('amount', amount);
        return;
    }

    chromGameTween = FlxTween.tween(
        chromGameObj,
        {value: amount},
        duration,
        {
            ease: FlxEase.sineOut
        }
    );

    chromHUDTween = FlxTween.tween(
        chromHUDObj,
        {value: amount},
        duration,
        {
            ease: FlxEase.sineOut
        }
    );
}

function onDestroy()
{
    if (chromGameTween != null)
        chromGameTween.cancel();

    if (chromHUDTween != null)
        chromHUDTween.cancel();

    chromReady = false;
}