function onEvent(name, value1, value2)
{
  if (name == 'Camera Zoom Absolute Circ')
  {
    FlxTween.cancelTweensOf(FlxG.camera, ['zoom']);

    FlxTween.tween(FlxG.camera, {zoom: value1}, value2, {ease: FlxEase.circOut});
    defaultCamZoom = value1;
  }
}
