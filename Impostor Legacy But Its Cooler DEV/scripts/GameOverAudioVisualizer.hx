import extensions.funkinvis.SpectralAnalyzerEx;
import funkin.states.substates.GameOverSubstate;
import funkin.states.PlayState;

var gameOverAnalyzer:Dynamic = null;
var gameOverBars:Array<FlxSprite> = [];
var gameOverBarLevels:Array<Float> = [];
var gameOverBarCount:Int = 48;
var gameOverBarColor:Int = FlxColor.WHITE;
var gameOverBarWidth:Float = 1;
var gameOverBarStep:Float = 1;

function deathAnimStart(volume)
{
    if (gameOverAnalyzer != null) return;

    var sub = GameOverSubstate.instance;
    var music = FlxG.sound.music;
    if (sub == null || sub.boyfriend == null || music == null) return;

    var visualizerColor:Int = sub.boyfriend.healthColour;
    if (PlayState.instance != null && PlayState.instance.boyfriend != null)
        visualizerColor = PlayState.instance.boyfriend.healthColour;
    gameOverBarColor = visualizerColor;

    try
    {
        var channel = music._channel;
        if (channel == null || channel.__audioSource == null) return;

        gameOverAnalyzer = new SpectralAnalyzerEx(channel.__audioSource, gameOverBarCount, 0.1, 40);
        gameOverAnalyzer.audioClip.trackedSource = music;
        gameOverAnalyzer.minDb = -65;
        gameOverAnalyzer.maxDb = -25;
        gameOverAnalyzer.maxFreq = 22000;
        gameOverAnalyzer.minFreq = 10;
        gameOverAnalyzer.fftN = 256;
    }
    catch (e:Dynamic)
    {
        gameOverAnalyzer = null;
        return;
    }

    gameOverBars = [];
    gameOverBarLevels = [];
    gameOverBarStep = FlxG.width / gameOverBarCount;
    gameOverBarWidth = gameOverBarStep * 0.76;
    if (gameOverBarWidth < 4) gameOverBarWidth = 4;

    for (i in 0...gameOverBarCount)
    {
        var bar:FlxSprite = new FlxSprite();
        bar.loadGraphic(Paths.image('circle'));
        bar.color = gameOverBarColor;
        bar.alpha = 0.55;
        bar.blend = BlendMode.ADD;
        bar.antialiasing = true;
        bar.scrollFactor.set(0, 0);
        bar.cameras = [FlxG.camera];
        sub.insert(0, bar);
        gameOverBars.push(bar);
        gameOverBarLevels.push(0.12);
    }
}

function onUpdatePost(elapsed)
{
    if (gameOverAnalyzer == null || gameOverBars.length == 0) return;

    var levels = gameOverAnalyzer.getLevels();
    if (levels == null) return;

    var cam = FlxG.camera;
    var zoom:Float = cam.zoom;
    if (zoom <= 0) zoom = 1;

    var muted:Bool = FlxG.sound.muted || FlxG.sound.volume <= 0;
    var count:Int = gameOverBars.length;
    var screenCenterY:Float = FlxG.height * 0.5;
    var smoothing:Float = elapsed * 7;
    if (smoothing > 1) smoothing = 1;
    if (smoothing < 0) smoothing = 0;

    for (i in 0...count)
    {
        var targetLevel:Float = 0.12;
        if (!muted && i < levels.length && levels[i] != null)
        {
            var audioLevel:Float = levels[i].value * 2.0;
            if (audioLevel < 0) audioLevel = 0;
            if (audioLevel > 1) audioLevel = 1;
            targetLevel = 0.12 + ((1 - audioLevel) * 0.36);
        }

        if (targetLevel > 0.48) targetLevel = 0.48;
        if (targetLevel < 0.12) targetLevel = 0.12;

        gameOverBarLevels[i] = FlxMath.lerp(gameOverBarLevels[i], targetLevel, smoothing);

        var fullScreenHeight:Float = FlxG.height * gameOverBarLevels[i];
        var fullWorldHeight:Float = fullScreenHeight / zoom;
        var screenX:Float = i * gameOverBarStep + gameOverBarStep * 0.5;
        var worldCenterX:Float = screenX / zoom + cam.viewMarginLeft;
        var worldCenterY:Float = screenCenterY / zoom + cam.viewMarginTop;
        var bar:FlxSprite = gameOverBars[i];
        var frameWidth:Float = bar.frameWidth;
        var frameHeight:Float = bar.frameHeight;
        if (frameWidth <= 0 || frameHeight <= 0) continue;

        bar.origin.set(frameWidth * 0.5, frameHeight * 0.5);
        bar.x = worldCenterX - frameWidth * 0.5;
        bar.y = worldCenterY - frameHeight * 0.5;
        bar.scale.set(gameOverBarWidth / frameWidth / zoom, fullWorldHeight / frameHeight);
    }
}
