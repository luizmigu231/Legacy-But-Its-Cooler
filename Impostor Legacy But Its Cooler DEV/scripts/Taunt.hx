var gfTaunting:Bool = false;
var justStartedTaunt:Bool = false;
var tauntCheckDelay:Int = 0;

var currentTauntAnim:String = '';

function onUpdate(elapsed:Float):Void
{
	if (inCutscene || cpuControlled)
		return;

	if (boyfriend == null || gf == null)
		return;

	if (controls.NOTE_TAUNT_P && boyfriend.canTaunt)
	{
		if (!gfTaunting)
		{
			currentTauntAnim = '';

			if (gf.animation.exists('combo50') ||
				gf.animation.exists('combo200'))
			{
				if (combo < 200)
				{
					if (gf.animation.exists('combo50'))
						currentTauntAnim = 'combo50';
				}
				else
				{
					if (gf.animation.exists('combo200'))
						currentTauntAnim = 'combo200';
				}
			}
			else if (gf.animation.exists('combo100') ||
				gf.animation.exists('combo250'))
			{
				if (combo < 250)
				{
					if (gf.animation.exists('combo100'))
						currentTauntAnim = 'combo100';
					else if (gf.animation.exists('combo250'))
						currentTauntAnim = 'combo250';
				}
				else
				{
					if (gf.animation.exists('combo250'))
						currentTauntAnim = 'combo250';
					else if (gf.animation.exists('combo100'))
						currentTauntAnim = 'combo100';
				}
			}
			else if (gf.animation.exists('cheer'))
			{
				currentTauntAnim = 'cheer';
			}

			if (currentTauntAnim == '')
				return;

			gf.playAnim(currentTauntAnim);
			gf.specialAnim = true;

			gfTaunting = true;

			justStartedTaunt = true;
			tauntCheckDelay = 2;
		}
	}

	if (justStartedTaunt)
	{
		tauntCheckDelay--;

		if (tauntCheckDelay <= 0)
		{
			justStartedTaunt = false;
		}
	}

	if (gfTaunting && !justStartedTaunt)
	{
		if (boyfriend.specialAnim)
		{
			if (gf.animation.curAnim != null &&
				gf.getAnimName() == currentTauntAnim)
			{
				var anim = gf.animation.curAnim;

				if (anim.curFrame >= anim.numFrames - 1)
				{
					anim.curFrame = anim.numFrames - 1;
					anim.paused = true;
				}
			}
		}
		else
		{
			gfTaunting = false;

			if (gf.animation.curAnim != null)
				gf.animation.curAnim.paused = false;

			gf.specialAnim = false;
			gf.dance();

			currentTauntAnim = '';
		}
	}
}