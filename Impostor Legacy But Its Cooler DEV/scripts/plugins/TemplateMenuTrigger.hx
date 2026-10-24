package funkin.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import Type;

var configButton:FlxButton = null;
var configButtonText:FlxText = null;
var configButtonCreated:Bool = false;

function isMainMenu():Bool
{
    if (FlxG.state == null)
        return false;

    return Type.getClassName(Type.getClass(FlxG.state)) == 'funkin.states.MainMenuState';
}

function openTemplateMenu()
{
    FlxG.switchState(new ScriptedState('TemplateMenu'));
}

function createConfigButton()
{
    if (!isMainMenu() || configButtonCreated)
        return;

    configButton = new FlxButton(
    FlxG.width - 140,
    FlxG.height - 110,
    '',
    openTemplateMenu
);

configButton.loadGraphic(Paths.image('menu/main/thing'));
configButton.scale.set(0.4, 0.4);
configButton.updateHitbox();
configButton.scrollFactor.set(0, 0);

FlxG.state.add(configButton);

configButtonText = new FlxText(
    FlxG.width - 200,
    FlxG.height - 30,
    200,
    'Mod Settings'
);

configButtonText.wordWrap = false;

configButtonText.setFormat(
    null,
    16,
    0xFFFFFFFF,
    'center'
);

    configButtonText.scrollFactor.set(0, 0);
    FlxG.state.add(configButtonText);

    configButtonCreated = true;
}

function onUpdate(elapsed:Float)
{
    if (isMainMenu())
    {
        if (!configButtonCreated)
            createConfigButton();

        if (FlxG.keys.justPressed.Q)
            openTemplateMenu();
    }
    else
    {
        configButton = null;
        configButtonText = null;
        configButtonCreated = false;
    }
}