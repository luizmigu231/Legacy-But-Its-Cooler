function onSpawnNotePost(note)
{
	if (note.noteType == "GKnifeNote")
	{
		note.texture = 'knifenote';
		note.rgbEnabled = false;
		note.hitPriority = 0;
		note.ignoreNote = note.mustPress;
		note.missHealth = note.isSustainNote ? 0.1 : 0.3;
		note.hitCausesMiss = true;
	}
}
