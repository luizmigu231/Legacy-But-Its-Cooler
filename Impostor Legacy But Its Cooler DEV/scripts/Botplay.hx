var botplayOffsetY:Float = 50;
var botplayBaseY:Float = 0;
var botplayPositioned:Bool = false;
public var forcedBotColor:Bool = false;

function onUpdate(elapsed:Float)
{
	if (PlayState.instance == null || PlayState.instance.botplayTxt == null)
		return;

	var txt = PlayState.instance.botplayTxt;

	if (!botplayPositioned)
	{
		botplayBaseY = txt.y;
		botplayPositioned = true;
	}

	txt.y = botplayBaseY + botplayOffsetY;
	if (!forcedBotColor) txt.color = playHUD.scoreTxt.color;
	txt.text = "Be_Impostor.exe";
	txt.size = 26;
}