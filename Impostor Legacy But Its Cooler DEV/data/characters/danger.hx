import funkin.game.shaders.ExtraDropShadowShader;

public var dadLegs:Character;
var legs:Character;
var legsRim:ExtraDropShadowShader;
var dadAnchorPoint:Array<Float> = [0, 0];
var legPosY = [13, 7, -3, -1, -1, 2, 7, 9, 7, 2, 0, 0, 3, 1, 3, 7, 13];
var legEvilPosY = [-8, -3, 5, 2, -8, -13, -16, -14, -9, -4, 5, -4, -9, -10];

function createRim(angleX:Float, angleY:Float):ExtraDropShadowShader
{
	var rim = new ExtraDropShadowShader();

	rim.threshold = 0.05;
	rim.strength = 0.85;

	rim.setColorMatrix([
    0.7, 0, 0, 0, 0,
    0, 0.7, 0, 0, 0,
    0, 0, 0.7, 0, 0,
    0, 0, 0, 1, 0
	]);

	return rim;
}

function onLoad()
{
	dadLegs = legs = new Character(0, 0, 'danger', false);
	legs.skipDance = true;
	legs.playAnim('legs', true);
	dadGroup.insert(0, legs);
	legsRim = createRim(355, 6);
	legsRim.attachedSprite = legs;
	legs.shader = legsRim;
}

function onCreatePost()
{
	dadAnchorPoint[0] = legs.x = parent.x;
	dadAnchorPoint[1] = legs.y = parent.y;
	parent.flipX = parent.baseFlipX = false;
}

function onUpdate(elapsed)
{
        var targetX = FlxMath.remapToRange(
         game.health,
         0, 2,
         DAD_X + 404, DAD_X - 404
        );

        dadGroup.x = FlxMath.lerp(dadGroup.x, targetX, FlxMath.bound(4.5 * elapsed, 0, 1));

	legs.animation.pause();
	
	var dadIdle:Bool = StringTools.startsWith(parent.animation.name, 'idle');
	
	legs.animation.curAnim.curFrame = Math.floor(FlxMath.mod(curDecBeat, 2) / 2 * legs.animation.curAnim.numFrames);
	if (dadIdle)
	{
		parent.animation.pause();
		parent.animation.curAnim.curFrame = legs.animation.curAnim.curFrame;
	}
	else
	{
		parent.animation.resume();
	}
	
	parent.y = (dadAnchorPoint[1] + (dadIdle ? 0 : ((parent.animSuffix == '-mad' ? legEvilPosY : legPosY)[legs.animation.curAnim.curFrame])));
	legs.y = dadAnchorPoint[1];
	legs.flipX = parent.flipX;
}
