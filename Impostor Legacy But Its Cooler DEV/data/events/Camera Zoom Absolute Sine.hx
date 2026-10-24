function onEvent(name, value1, value2)
{
  if (name == 'Camera Zoom Absolute Sine')
  {
    FlxTween.cancelTweensOf(FlxG.camera, ['zoom']);

    FlxTween.tween(FlxG.camera, {zoom: value1}, value2, {ease: FlxEase.sineOut});
    defaultCamZoom = value1;
  }
}
