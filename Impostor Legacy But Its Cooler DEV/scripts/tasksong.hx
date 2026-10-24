import flixel.FlxSprite;

var originalWidth:Float = -1;
var originalScaleX:Float = 1;
var taskIcon:FlxSprite;

function onUpdatePost(elapsed)
{
	if (taskGroup == null)
		return;

	if (taskGroup.members.length <= 0)
		return;

	var bg = taskGroup.members[0];

	if (bg == null)
		return;

	bg.color = dad.healthColour;
	bg.alpha = 0.3;

	if (originalWidth < 0)
	{
		originalWidth = bg.width;
		originalScaleX = bg.scale.x;
	}

	bg.scale.x = originalScaleX * ((originalWidth + 100) / originalWidth);

	if (taskIcon == null)
	{
		if (iconP2 == null)
			return;

		taskIcon = new FlxSprite();

		taskIcon.loadGraphic(
			iconP2.graphic,
			true,
			Std.int(iconP2.frameWidth),
			Std.int(iconP2.frameHeight)
		);

		taskIcon.frame = 0;
		taskIcon.setGraphicSize(70, 70);
		taskIcon.updateHitbox();

		taskGroup.add(taskIcon);
	}

	taskIcon.x = bg.x + bg.width - taskIcon.width + 55;
	taskIcon.y = bg.y + bg.height - taskIcon.height + 25;

	var bgRight:Float = taskGroup.x + bg.x + bg.width;

	if (bgRight <= 0)
	{
		bg.visible = false;
		taskIcon.visible = false;
	}
	else
	{
		bg.visible = true;
		taskIcon.visible = true;
	}
}