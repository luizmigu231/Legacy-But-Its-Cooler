function onMoveCamera(whosTurn:String)
{
	game.defaultCamZoom = (whosTurn == "boyfriend") ? 0.7 : 0.6;
}