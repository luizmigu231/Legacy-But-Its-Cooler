function onEvent(n, v1, v2)
{
	switch (n)
	{
		case 'Grey Darkness':
			camGame.visible = v1 == 'on' ? false : true;
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