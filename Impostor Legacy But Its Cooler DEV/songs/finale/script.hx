import funkin.states.substates.PauseSubState;

function onSubstateOpen()
{
	FlxG.signals.postUpdate.addOnce(() -> {
		
		if (PauseSubState.instance != null)
		{
			var pause = PauseSubState.instance;
			
			for (option in pause.optionText)
			{
				option.color = FlxColor.RED;
			}
			
			pause.infoTitle.color = FlxColor.RED;
			pause.infoSubtext.color = FlxColor.RED;
			pause.looksie.loadGraphic(Paths.image('menu/pause/looksie-defeat'));
		}
	});
}