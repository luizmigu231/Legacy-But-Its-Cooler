var vanished = false;

function goodNoteHitPre(note)
{
	if (note.isSustainNote) return;

	if (note.noteType == 'True Ghost Note')
	{
		note.noAnimation = vanished = true;
		boyfriend.alpha = 1;
	}

	if (note.noteType != 'Ghost Note' && note.noteType != 'True Ghost Note' && vanished)
	{
		note.noAnimation = true;
		boyfriend.alpha = 1;
	}
}

function goodNoteHit(note)
{
	final animToPlay = note.skin.singAnimations[Std.int(Math.abs(note.noteData))] + note.animSuffix;

	if (note.isSustainNote) return;

	if (note.noteType == 'True Ghost Note')
	{
		boyfriend.playGhostAnim(note.noteData, animToPlay, true);
		boyfriend.alpha = 0;
	}

	if (note.noteType != 'Ghost Note' && note.noteType != 'True Ghost Note' && vanished)
	{
		boyfriend.playGhostAnim(note.noteData, animToPlay, true);
		boyfriend.alpha = 0;
	}
}