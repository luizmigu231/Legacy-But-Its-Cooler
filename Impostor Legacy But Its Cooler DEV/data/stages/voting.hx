import flixel.math.FlxRect;
var ext = 'stages/jorsawsee/voting-time/';
var sprites:Array<FlxSprite> = [];
var voting5:FlxSprite;
var voting6:FlxSprite;
var jorsa:Character;
var redmungus:Character;
var redmadgus:Character;
var headlights:Array<FlxSprite> = [];

var votedbf:FlxSprite;
var votedwar:FlxSprite;
var votedjelq:FlxSprite;
var votedred:FlxSprite;

var bfIcon:FlxSprite;
var warIcon:FlxSprite;
var jelqIcon:FlxSprite;
var redIcon:FlxSprite;

function onLoad()
{
	var bars:FlxSpriteGroup = new FlxSpriteGroup();
	bars.cameras = [camHUD];
	add(bars);
	
	for (i in 0...2) // maybe this is doin too much idk
	{
		var bar = new FlxSprite().makeGraphic(FlxG.width + 3, 90, FlxColor.BLACK);
		bar.y = i == 1 ? 630 : 0;
		bars.add(bar);
	}
	
	var voting1:FlxSprite = new FlxSprite(610, 168).loadGraphic(Paths.image(ext + 'back'));
	voting1.scrollFactor.set(.93, .93);
	voting1.color = 0xFF2c385e;
	add(voting1);
	
	var voting2:FlxSprite = new FlxSprite(-472, -295).loadGraphic(Paths.image(ext + 'front'));
	voting2.scrollFactor.set(.95, .97);
	voting2.color = 0xFF2c385e;
	add(voting2);
	
	var jorsawsee:FlxSprite = new FlxSprite(1690, 480).loadGraphic(Paths.image(ext + 'jorsawsee'));
	jorsawsee.scrollFactor.set(.975, .99);
	jorsawsee.scale.set(.7, .7);
	jorsawsee.updateHitbox();
	jorsawsee.color = 0xFF2c385e;
	add(jorsawsee);
	
	var votinguh:FlxSprite = new FlxSprite(500, 590).loadGraphic(Paths.image(ext + 'chair3'));
	votinguh.scrollFactor.set(.95, .95);
	votinguh.color = 0xFF2c385e;
	add(votinguh);
	
	var voting3:FlxSprite = new FlxSprite(160, 625).loadGraphic(Paths.image(ext + 'chair2'));
	voting3.scrollFactor.set(.98, .98);
	voting3.color = 0xFF2c385e;
	add(voting3);
	
	var voting4:FlxSprite = new FlxSprite(-190, 700).loadGraphic(Paths.image(ext + 'chair1'));
	voting4.color = 0xFF2c385e;
	add(voting4);
	
	sprites = [voting1, voting2, jorsawsee, votinguh, voting3, voting4];

	jorsa = new Character(1500, 200, 'jorsawghost');
	game.startCharacterPos(jorsa);
	jorsa.alpha = 0;
	add(jorsa);
	jorsa.flipX = true;
	jorsa.danceEveryNumBeats = 2;

	redmungus = new Character(1760, 225, 'mungus');
	game.startCharacterPos(redmungus);
	add(redmungus);
	redmungus.scale.set(1.2, 1.2);
	redmungus.danceEveryNumBeats = 1;

	redmadgus = new Character(1760, 225, 'madgus');
	game.startCharacterPos(redmadgus);
	add(redmadgus);
	redmadgus.alpha = 0.001;
	redmadgus.scale.set(1.2, 1.2);
	redmadgus.danceEveryNumBeats = 1;
}

function onCreatePost()
{
	pet.zIndex = 1;
	redmungus.zIndex = 2;
	redmadgus.zIndex = 2;
	for (playField in playFields)
		if (playField.ID != 0) playField.playerControls = false;
	
	pet.scrollFactor.set(.95, .94);
	gf.scrollFactor.set(1.05, 1);
	redmungus.scrollFactor.set(.96, 1);
	redmadgus.scrollFactor.set(.96, 1);
	boyfriend.scrollFactor.set(.95 /* genius! */, 1.05);
	dad.scrollFactor.set(1.05, 1.05);
	
	boyfriend.color = gf.color = dad.color = pet.color = redmungus.color = 0xFF2c385e;
	boyfriend.alpha = gf.alpha = dad.alpha = pet.alpha = redmungus.alpha = 0;

	game.boyfriend.scale.x *= 1.2;
	game.boyfriend.scale.y *= 1.2;
	game.dad.scale.set(1.2, 1.2);
	game.boyfriend.updateHitbox();
	game.boyfriend.offset.set();
	game.boyfriend.dance();

	votedbf = new FlxSprite(2190, 580).loadGraphic(Paths.image("Voted"));
	votedbf.zIndex = 3;
	votedbf.scale.set(1.2, 1.2);
	votedbf.alpha = 0;
	add(votedbf);

	votedwar = new FlxSprite(-110, 580).loadGraphic(Paths.image("Voted"));
	votedwar.zIndex = 2;
	votedwar.scale.set(1.2, 1.2);
	votedwar.alpha = 0;
	add(votedwar);

	votedjelq = new FlxSprite(250, 460).loadGraphic(Paths.image("Voted"));
	votedjelq.scale.set(1, 1);
	votedjelq.alpha = 0;
	stage.insert(stage.members.indexOf(dadGroup), votedjelq);

	votedred = new FlxSprite(1890, 520).loadGraphic(Paths.image("Voted"));
	votedred.zIndex = 2;
	votedred.scale.set(1, 1);
	votedred.alpha = 0;
	add(votedred);

	bfIcon = new FlxSprite(1920, 520).loadGraphic(Paths.image("icons/icon-bf"));
	bfIcon.zIndex = 3;
	bfIcon.scrollFactor.set(.96, 1);
	bfIcon.clipRect = new FlxRect(0, 0, 150, 150);
	add(bfIcon);
	bfIcon.alpha = 0;

	warIcon = new FlxSprite(1800, 520).loadGraphic(Paths.image("icons/icon-warchief"));
	warIcon.zIndex = 2;
	warIcon.scrollFactor.set(.96, 1);
	warIcon.clipRect = new FlxRect(0, 0, 150, 150);
	add(warIcon);
	warIcon.alpha = 0;

	jelqIcon = new FlxSprite(2040, 520).loadGraphic(Paths.image("icons/icon-thejelqer"));
	jelqIcon.zIndex = 2;
	jelqIcon.scrollFactor.set(.96, 1);
	jelqIcon.clipRect = new FlxRect(0, 0, 150, 150);
	add(jelqIcon);
	jelqIcon.alpha = 0;

	redIcon = new FlxSprite(2100, 580).loadGraphic(Paths.image("icons/icon-redmungus"));
	redIcon.zIndex = 3;
	redIcon.scale.set(1.2, 1.2);
	redIcon.scrollFactor.set(.95, 1.05);
	redIcon.clipRect = new FlxRect(0, 0, 150, 150);
	add(redIcon);
	redIcon.alpha = 0;

	for (i in 0...3)
	{
		var pos = switch(i)
		{
			case 0: [dadGroup.x - 80, dadGroup.y, 0];
			case 1: [boyfriendGroup.x + 150, boyfriendGroup.y, 3];
			case 2: [redmungus.x - 20, redmungus.y - 300, 2];
		}	

		var headlight:FlxSprite = new FlxSprite(pos[0], pos[1]);
		headlight.loadGraphic(Paths.image('stages/jorsawsee/voting-time/headlight'));
		headlight.scrollFactor.set(1.1, 1.1);
		headlight.alpha = 0;
		headlight.zIndex = pos[2];
		headlight.blend = BlendMode.ADD;
		add(headlight);
	
		headlights.push(headlight);
	}

	var voting5:FlxSprite = new FlxSprite(-90, 732).loadGraphic(Paths.image(ext + 'table'));
	voting5.scale.set(1.5 / 1.8, 1.5 / 1.8);
	voting5.scrollFactor.set(1.04, 1.15);
	voting5.updateHitbox();
	voting5.zIndex = 3;
	voting5.color = 0xFF2c385e;
	add(voting5);
	sprites.push(voting5);

	var voting6:FlxSprite = new FlxSprite(-428, 20).loadGraphic(Paths.image(ext + 'light'));
	voting6.scrollFactor.set(.7, .8);
	voting6.scale.set(6, 6);
	voting6.updateHitbox();
	voting6.blend = BlendMode.ADD;
	voting6.alpha = 0;
	voting6.zIndex = 3;
	add(voting6);
	sprites.push(voting6);

	snapCamToPos(1205, 575);
	// snapCamToPos(1800, 575);
	game.isCameraOnForcedPos = true;
	
	playFields.members[2].owner = game.gf;
	playFields.members[2].isPlayer = playFields.members[3].isPlayer = false;
	playFields.members[3].singers = [redmungus, redmadgus];
	
	for (i in playFields.members)
	{
		final orgID = (3 - i.ID);
		final wrap = Math.floor(orgID / 2) == 1;
		
		i.visible = (i.ID == 0 || ClientPrefs.opponentStrums);
		
		if (wrap)
		{
			i.zIndex = 999;
		}
		else
		{
			i.underlay.kill();
			
			modManager.setValue("noteAlpha", 1, i.ID);
			modManager.setValue("alpha", 0.7, i.ID);
			modManager.setValue("stealth", 0.5, i.ID);
			// modManager.setValue("sustainSplashAlpha", 1, i.ID);
			// modManager.setValue("reverse", 1, i.ID);
			modManager.setValue("transformZ", -1, i.ID);
			modManager.setValue("transformY", -90 * (ClientPrefs.downScroll ? -1 : 1), i.ID);
			modManager.setValue("stealthPastReceptors", 1, i.ID);
			
			final space = 865;
			
			if (!ClientPrefs.middleScroll) modManager.setValue("transformX", i.ID == 2 ? -(space) : space, i.ID);
			else if (!ClientPrefs.opponentStrums) i.visible = false;
			// modManager.setValue("")
		}
	}
	
	refreshZ(playFields);
	
	if (boyfriend.gameoverLoopDeathSound == null) boyfriend.gameoverLoopDeathSound = 'Jorsawsee_Loop';
	if (boyfriend.gameoverConfirmDeathSound == null) boyfriend.gameoverConfirmDeathSound = 'Jorsawsee_End';
}

function onCountdownTick(tick:Int)
{
	if (tick < 4) redmungus.onBeatHit(curBeat);
}

function onBeatHit()
{
	redmadgus.onBeatHit(curBeat);
	redmungus.onBeatHit(curBeat);
	jorsa.onBeatHit(curBeat);

	switch(curBeat)
	{
		case 4: doTheThing(dad, true);
		case 12:
			doTheThing(dad, false);
			doTheThing(boyfriend, true);
		case 20: doTheThing(redmungus, true);
		case 28:
			doTheThing(boyfriend, false);
			doTheThing(redmungus, false);
			doTheThing(dad, true);
		case 30:
			doTheThing(dad, false);
			doTheThing(redmungus, true);
		case 32:
			doTheThing(redmungus, false);
			doTheThing(boyfriend, true);
		case 34:
			doTheThing(dad, true);
			doTheThing(redmungus, true);
		case 64:
			for (sprite in sprites) FlxTween.color(sprite, 0.7, sprite.color, FlxColor.WHITE, {ease:FlxEase.quadOut});
			sprites[7].alpha = 1;
			FlxTween.color(gf, 0.7, gf.color, FlxColor.WHITE, {ease:FlxEase.quadOut});
			gf.alpha = 1;
			for (headlight in headlights) headlight.alpha = 0;
		case 228:
			for (sprite in sprites) FlxTween.color(sprite, 4, FlxColor.WHITE, 0xFF2c385e, {ease:FlxEase.quadOut});
			FlxTween.color(boyfriend, 4, FlxColor.WHITE, 0x002c385e, {ease:FlxEase.quadOut});
			FlxTween.tween(jorsa, {alpha: 0.7}, 13, {ease:FlxEase.quadOut});
			FlxTween.tween(headlights[2], {alpha: 0.6}, 4, {ease:FlxEase.quadOut});
		case 260:
			for (sprite in sprites) FlxTween.color(sprite, 2, 0xFF2c385e, FlxColor.WHITE, {ease:FlxEase.quadOut});
			FlxTween.color(boyfriend, 2, 0x002c385e, FlxColor.WHITE, {ease:FlxEase.quadOut});
			FlxTween.tween(jorsa, {alpha: 0}, 2, {ease:FlxEase.quadOut});
			FlxTween.tween(headlights[2], {alpha: 0}, 2, {ease:FlxEase.quadOut});
		case 292:
			redmungus.alpha = 0;
			redmadgus.alpha = 1;
		case 324:
			votedwar.alpha = 1;
		case 325:
			votedbf.alpha = 1;
		case 326:
			votedjelq.alpha = 1;
		case 327:
			votedred.alpha = 1;
		case 328:
			votedwar.alpha = 0;
			votedbf.alpha = 0;
			votedjelq.alpha = 0;
			votedred.alpha = 0;

			FlxTween.tween(warIcon, {alpha: 1}, 0.7, {ease:FlxEase.quadOut});
			FlxTween.tween(redIcon, {alpha: 1}, 0.7, {ease:FlxEase.quadOut});
		case 329:
			FlxTween.tween(bfIcon, {alpha: 1}, 0.7, {ease:FlxEase.quadOut});
		case 330:
			FlxTween.tween(jelqIcon, {alpha: 1}, 0.7, {ease:FlxEase.quadOut});
	}
}

function changeUI(who:Character)
{
	if (hasColor) scoreTxt.color = who.healthColour;
	if (who != boyfriend)
	{
		iconP2.changeIcon(who.healthIcon);
		playHUD.healthBar.setColors(who.healthColour, boyfriend.healthColour);
	}
}

function doTheThing(char:Character, yes:Bool)
{
	var headlight = switch(char)
	{
		case dad: headlights[0];
		case boyfriend: headlights[1];
		case redmungus: headlights[2];
	}

	if (yes)
	{
		FlxTween.color(char, 0.4, 0x002c385e, FlxColor.WHITE, {ease:FlxEase.quadOut});
		FlxTween.tween(headlight, {alpha: 0.5}, 0.4, {ease:FlxEase.quadOut});
	}
	else
	{
		FlxTween.color(char, 0.4, FlxColor.WHITE, 0xF002c385e, {ease:FlxEase.quadOut});
		FlxTween.tween(headlight, {alpha: 0}, 0.4, {ease:FlxEase.quadOut});
	}

}

function onEvent(eventName, value1, value2)
{
	switch (eventName)
	{
		case 'Cam lock in Voting Time':
			if (value1 == 'in')
			{
				FlxG.camera.zoom = .9;
				defaultCamZoom = .9;
				
				if (value2 == 'dad')
				{
					snapCamToPos(460, 700);
					changeUI(dad);
				}
				else
				{
					changeUI(boyfriend);
					snapCamToPos(2100, 700);
				}
			}
			else if (value1 == 'close')
			{
				FlxG.camera.zoom = 1;
				defaultCamZoom = 1;
				
				if (value2 == 'dad')
				{
					snapCamToPos(480, 680);
					changeUI(gf);
				}
				else
				{
					snapCamToPos(2100, 680);
					changeUI(redmungus);
				}
			}
			else
			{
				defaultCamZoom = 0.55;
				FlxG.camera.zoom = 0.55;
				snapCamToPos(1205, 575);
			}
			
		case 'Play Animation':
			if (value1 == 'redmungus')
			{
				redmadgus.playAnim(value2, true);
				redmadgus.specialAnim = true;
			}
	}
}
