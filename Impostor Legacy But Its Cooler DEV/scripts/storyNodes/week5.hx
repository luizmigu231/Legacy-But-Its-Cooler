import funkin.data.WeekData;

function onSelect():Void {
	weekPlaylist.text = "NEVER WIN\nASHES\nMAGMATIC\nBOILING POINT";
	weekPlaylist.size = Std.int(Math.min(128 / 4, 50));
}

function onAccept():Void {
		this.meta.songs.insert(0, ["Fake Win", "maroon", [181, 0, 0], "maroon", "EthanTheDoodler"]);
}