import funkin.states.substates.PauseSubState;

function onSubstateOpen()
{
	FlxG.signals.postUpdate.addOnce(() -> {
		
		if (PauseSubState.instance != null && game.subState == PauseSubState.instance)
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