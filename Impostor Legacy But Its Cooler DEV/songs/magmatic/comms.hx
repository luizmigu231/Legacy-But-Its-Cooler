var text:FlxText;

function onSongStart()
{
	text = taskGroup.members[1];
        text.text = Lang.str("comms");
        text.updateHitbox();
        text.color = FlxColor.RED;
        taskGroup.members[2].text = "";
        taskGroup.members[0].origin.y = 0;
        taskGroup.members[0].makeGraphic(Math.floor(text.width + 24), Std.int(text.height + 15), FlxColor.WHITE);
        playHUD.timeBar.setColors(0xFF2e412e, 0xFF2e412e);
}

function onBeatHit()
{
	if (curBeat != 0 && curBeat < 8)
		text.color = (text.color == FlxColor.RED) ? FlxColor.YELLOW : FlxColor.RED;
        else if (curBeat == 8)
		playHUD.timeBar.setColors(0xFF44d844, 0xFF2e412e);
}