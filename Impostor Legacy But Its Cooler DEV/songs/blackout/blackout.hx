var defeat:FlxSprite;

function onCreatePost()
{
	defeat = new FlxSprite(0, 0).loadGraphic(Paths.image('stages/void/iluminao omaga'));
	defeat.antialiasing = true;
	defeat.setGraphicSize(FlxG.width * 1.5, FlxG.height * 1.5);
	defeat.updateHitbox();
	defeat.screenCenter();
	defeat.visible = false;
	add(defeat);
	defeat.cameras = [camOther];
}

function onEvent(n, v1, v2)
{
	switch (n)
	{
		case 'Grey Darkness':
			camGame.visible = v1 == 'on' ? false : true;
			defeat.visible = !camGame.visible;
	}
}

function onUpdate()
{
  if (FlxG.keys.justPressed.T && ClientPrefs.inDevMode)
  {
    trace('Gray Angry');
    setSongTime(120000);
    }
}