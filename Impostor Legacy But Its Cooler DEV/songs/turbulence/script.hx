import funkin.states.substates.PauseSubState;

function onSubstateOpen()
{
	FlxG.signals.postUpdate.addOnce(() -> {
		
		if (PauseSubState.instance != null && game.subState == PauseSubState.instance)
		{
			var pause = PauseSubState.instance;

			pause.looksie.centerOrigin();
			pause.looksie.angle = -90;
		}
	});
}