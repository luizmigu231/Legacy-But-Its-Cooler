import funkin.states.substates.PauseSubState;

function onSubstateOpen()
{
	FlxG.signals.postUpdate.addOnce(() -> {
		
		if (PauseSubState.instance != null)
		{
			var pause = PauseSubState.instance;
			
			var color = dad.healthColour;

			for (option in pause.optionText)
			{
				option.color = color;
			}
			
			pause.infoTitle.color = color;
			pause.infoSubtext.color = color;
			pause.looksie.loadGraphic(Paths.image('menu/pause/looksie-defeat'));
		}
	});
}