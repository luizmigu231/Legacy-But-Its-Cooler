import extensions.funkinvis.SpectralAnalyzerEx;
import funkin.states.substates.GameOverSubstate;
import funkin.states.PlayState;

var gameOverAnalyzer:Dynamic = null;
var gameOverBars:Array<FlxSprite> = [];
var gameOverPeakBarsTop:Array<FlxSprite> = [];
var gameOverPeakBarsBottom:Array<FlxSprite> = [];
var gameOverBarLevels:Array<Float> = [];
var gameOverBarPeaks:Array<Float> = [];
var gameOverPeakHold:Array<Float> = [];
var gameOverBarCount:Int = 48;
var gameOverBarColor:Int = FlxColor.WHITE;
var gameOverBarWidth:Float = 1;
var gameOverBarStep:Float = 1;
var gameOverVisualizerTime:Float = 0;
var gameOverVisualizerSub:Dynamic = null;
var gameOverVisualizerMusic:Dynamic = null;
var gameOverVisualizerLine:FlxSprite = null;
var gameOverVisualizerActive:Bool = false;
var gameOverReviveFlash:FlxSprite = null;
var gameOverReviveFlashElapsed:Float = 0;
var gameOverReviveFlashDuration:Float = 0.46;
var gameOverReviveFlashStartAlpha:Float = 0.48;

function gameOverMixColor(colorA:Int, colorB:Int, amount:Float):Int
{
    if (amount < 0) amount = 0;
    if (amount > 1) amount = 1;

    var inverse:Float = 1 - amount;
    var red:Int = Std.int(((colorA >> 16) & 0xFF) * inverse + ((colorB >> 16) & 0xFF) * amount);
    var green:Int = Std.int(((colorA >> 8) & 0xFF) * inverse + ((colorB >> 8) & 0xFF) * amount);
    var blue:Int = Std.int((colorA & 0xFF) * inverse + (colorB & 0xFF) * amount);

    return 0xFF000000 | (red << 16) | (green << 8) | blue;
}

function gameOverSetScreenTransform(sprite:FlxSprite, screenX:Float, screenY:Float, width:Float, height:Float, zoom:Float):Void
{
    if (sprite == null) return;

    var frameWidth:Float = sprite.frameWidth;
    var frameHeight:Float = sprite.frameHeight;
    if (frameWidth <= 0 || frameHeight <= 0) return;

    var cam = FlxG.camera;
    var worldCenterX:Float = screenX / zoom + cam.viewMarginLeft;
    var worldCenterY:Float = screenY / zoom + cam.viewMarginTop;

    sprite.origin.set(frameWidth * 0.5, frameHeight * 0.5);
    sprite.x = worldCenterX - frameWidth * 0.5;
    sprite.y = worldCenterY - frameHeight * 0.5;
    sprite.scale.set(width / frameWidth / zoom, height / frameHeight / zoom);
}

function gameOverDisposeSprite(sprite:FlxSprite):Void
{
    if (sprite == null) return;

    try
    {
        if (gameOverVisualizerSub != null)
            gameOverVisualizerSub.remove(sprite, true);
        sprite.destroy();
    }
    catch (e:Dynamic)
    {
        try
        {
            sprite.kill();
            sprite.destroy();
        }
        catch (ignored:Dynamic) {}
    }
}

function gameOverHideVisualizer():Void
{
    if (gameOverAnalyzer != null)
    {
        try
        {
            gameOverAnalyzer.dispose();
        }
        catch (e:Dynamic) {}
    }

    for (bar in gameOverBars)
        gameOverDisposeSprite(bar);

    for (peak in gameOverPeakBarsTop)
        gameOverDisposeSprite(peak);

    for (peak in gameOverPeakBarsBottom)
        gameOverDisposeSprite(peak);

    gameOverDisposeSprite(gameOverVisualizerLine);
    gameOverDisposeSprite(gameOverReviveFlash);

    gameOverAnalyzer = null;
    gameOverBars = [];
    gameOverPeakBarsTop = [];
    gameOverPeakBarsBottom = [];
    gameOverBarLevels = [];
    gameOverBarPeaks = [];
    gameOverPeakHold = [];
    gameOverVisualizerSub = null;
    gameOverVisualizerMusic = null;
    gameOverVisualizerLine = null;
    gameOverReviveFlash = null;
    gameOverReviveFlashElapsed = 0;
    gameOverVisualizerActive = false;
    gameOverVisualizerTime = 0;
}

function onGameOverStart()
{
    gameOverHideVisualizer();

    var deathFlashColor:Int = FlxColor.WHITE;
    try
    {
        if (PlayState.instance != null && PlayState.instance.dad != null)
            deathFlashColor = PlayState.instance.dad.healthColour;

        FlxG.camera.flash(deathFlashColor, 0.48);
    }
    catch (e:Dynamic) {}
}

function onGameOverConfirm()
{
    var sub = GameOverSubstate.instance;
    if (sub == null) return;

    var reviveFlashColor:Int = FlxColor.WHITE;
    try
    {
        if (PlayState.instance != null && PlayState.instance.boyfriend != null)
            reviveFlashColor = PlayState.instance.boyfriend.healthColour;
        else if (sub.boyfriend != null)
            reviveFlashColor = sub.boyfriend.healthColour;
    }
    catch (e:Dynamic) {}

    if (gameOverReviveFlash != null)
        gameOverDisposeSprite(gameOverReviveFlash);

    var flash:FlxSprite = new FlxSprite();
    flash.makeGraphic(1, 1, reviveFlashColor);
    flash.alpha = gameOverReviveFlashStartAlpha;
    flash.blend = BlendMode.NORMAL;
    flash.antialiasing = false;
    flash.scrollFactor.set(0, 0);
    flash.cameras = [FlxG.camera];
    sub.add(flash);

    gameOverReviveFlash = flash;
    gameOverReviveFlashElapsed = 0;
}

function deathAnimStart(volume)
{
    var sub = GameOverSubstate.instance;
    var music = FlxG.sound.music;
    if (sub == null || sub.boyfriend == null) return;

    if (gameOverVisualizerSub == sub && gameOverBars.length > 0) return;
    gameOverHideVisualizer();

    gameOverVisualizerSub = sub;
    gameOverVisualizerMusic = music;

    var visualizerColor:Int = sub.boyfriend.healthColour;
    if (PlayState.instance != null && PlayState.instance.boyfriend != null)
        visualizerColor = PlayState.instance.boyfriend.healthColour;
    gameOverBarColor = visualizerColor;

    if (music != null)
    {
        try
        {
            var channel = music._channel;
            if (channel != null && channel.__audioSource != null)
            {
                gameOverAnalyzer = new SpectralAnalyzerEx(channel.__audioSource, gameOverBarCount, 0.1, 40);
                gameOverAnalyzer.audioClip.trackedSource = music;
                gameOverAnalyzer.minDb = -65;
                gameOverAnalyzer.maxDb = -25;
                gameOverAnalyzer.maxFreq = 22000;
                gameOverAnalyzer.minFreq = 10;
                gameOverAnalyzer.fftN = 256;
            }
        }
        catch (e:Dynamic)
        {
            if (gameOverAnalyzer != null)
            {
                try
                {
                    gameOverAnalyzer.dispose();
                }
                catch (ignored:Dynamic) {}
            }
            gameOverAnalyzer = null;
        }
    }

    gameOverBars = [];
    gameOverPeakBarsTop = [];
    gameOverPeakBarsBottom = [];
    gameOverBarLevels = [];
    gameOverBarPeaks = [];
    gameOverPeakHold = [];
    gameOverVisualizerTime = 0;
    gameOverBarStep = FlxG.width / gameOverBarCount;
    gameOverBarWidth = gameOverBarStep * 0.72;
    if (gameOverBarWidth < 3) gameOverBarWidth = 3;

    var line:FlxSprite = new FlxSprite();
    line.makeGraphic(1, 1, FlxColor.WHITE);
    line.color = gameOverMixColor(gameOverBarColor, FlxColor.WHITE, 0.48);
    line.alpha = 0.13;
    line.blend = BlendMode.ADD;
    line.antialiasing = true;
    line.scrollFactor.set(0, 0);
    line.cameras = [FlxG.camera];
    sub.insert(0, line);
    gameOverVisualizerLine = line;

    for (i in 0...gameOverBarCount)
    {
        var frequency:Float = i / (gameOverBarCount - 1);
        var bandColor:Int = gameOverMixColor(gameOverBarColor, FlxColor.WHITE, 0.06 + frequency * 0.38);
        var peakColor:Int = gameOverMixColor(bandColor, FlxColor.WHITE, 0.78);

        var bar:FlxSprite = new FlxSprite();
        bar.loadGraphic(Paths.image('circle'));
        bar.color = bandColor;
        bar.alpha = 0.34;
        bar.blend = BlendMode.ADD;
        bar.antialiasing = true;
        bar.scrollFactor.set(0, 0);
        bar.cameras = [FlxG.camera];
        sub.insert(0, bar);
        gameOverBars.push(bar);

        var peakTop:FlxSprite = new FlxSprite();
        peakTop.loadGraphic(Paths.image('circle'));
        peakTop.color = peakColor;
        peakTop.alpha = 0;
        peakTop.blend = BlendMode.ADD;
        peakTop.antialiasing = true;
        peakTop.scrollFactor.set(0, 0);
        peakTop.cameras = [FlxG.camera];
        sub.insert(0, peakTop);
        gameOverPeakBarsTop.push(peakTop);

        var peakBottom:FlxSprite = new FlxSprite();
        peakBottom.loadGraphic(Paths.image('circle'));
        peakBottom.color = peakColor;
        peakBottom.alpha = 0;
        peakBottom.blend = BlendMode.ADD;
        peakBottom.antialiasing = true;
        peakBottom.scrollFactor.set(0, 0);
        peakBottom.cameras = [FlxG.camera];
        sub.insert(0, peakBottom);
        gameOverPeakBarsBottom.push(peakBottom);

        gameOverBarLevels.push(0.035);
        gameOverBarPeaks.push(0.035);
        gameOverPeakHold.push(0);
    }

    gameOverVisualizerActive = true;
}

function onUpdatePost(elapsed:Float)
{
    var frameTime:Float = elapsed;
    if (frameTime < 0) frameTime = 0;
    if (frameTime > 0.1) frameTime = 0.1;

    if (gameOverReviveFlash != null)
    {
        var flashCam = FlxG.camera;
        var flashZoom:Float = flashCam.zoom;
        if (flashZoom <= 0.001) flashZoom = 1;
        gameOverReviveFlashElapsed += frameTime;
        gameOverSetScreenTransform(gameOverReviveFlash, FlxG.width * 0.5, FlxG.height * 0.5, FlxG.width, FlxG.height, flashZoom);

        var flashProgress:Float = gameOverReviveFlashElapsed / gameOverReviveFlashDuration;
        if (flashProgress > 1) flashProgress = 1;
        var flashFade:Float = 1 - flashProgress;
        gameOverReviveFlash.alpha = gameOverReviveFlashStartAlpha * flashFade * flashFade;

        if (gameOverReviveFlashElapsed >= gameOverReviveFlashDuration)
        {
            gameOverDisposeSprite(gameOverReviveFlash);
            gameOverReviveFlash = null;
            gameOverReviveFlashElapsed = 0;
        }
    }

    if (!gameOverVisualizerActive || gameOverBars.length == 0) return;

    var levels:Dynamic = null;
    if (gameOverAnalyzer != null)
    {
        try
        {
            levels = gameOverAnalyzer.getLevels();
        }
        catch (e:Dynamic)
        {
            gameOverAnalyzer = null;
        }
    }

    var cam = FlxG.camera;
    var zoom:Float = cam.zoom;
    if (zoom <= 0.001) zoom = 1;

    var music = gameOverVisualizerMusic;
    var muted:Bool = FlxG.sound.muted || FlxG.sound.volume <= 0.001 || music == null || music.volume <= 0.001;
    var count:Int = gameOverBars.length;
    var screenCenterY:Float = FlxG.height * 0.5;
    var screenCenterX:Float = FlxG.width * 0.5;
    gameOverVisualizerTime += frameTime;

    var totalEnergy:Float = 0;

    if (gameOverVisualizerLine != null)
        gameOverSetScreenTransform(gameOverVisualizerLine, 0, screenCenterY, FlxG.width * 2.2, 3.0, zoom);


    for (i in 0...count)
    {
        var frequency:Float = i / (count - 1);
        var ambient:Float = Math.sin(gameOverVisualizerTime * 1.35 + i * 0.31) * 0.003;
        var targetLevel:Float = 0.035 + ambient;
        var audioLevel:Float = 0;

        if (!muted && levels != null && i < levels.length && levels[i] != null)
        {
            var rawLevel:Float = levels[i].value;
            if (rawLevel < 0) rawLevel = 0;
            if (rawLevel > 1) rawLevel = 1;

            if (rawLevel < 0.015) rawLevel = 0;

            audioLevel = Math.pow(rawLevel, 0.72) * 1.15;
            audioLevel *= 0.92 + frequency * 0.16;
            if (audioLevel > 1) audioLevel = 1;
            targetLevel = 0.035 + audioLevel * 0.56;
        }

        var currentLevel:Float = gameOverBarLevels[i];
        var speed:Float = targetLevel > currentLevel ? 21.0 : 6.4;
        var smoothing:Float = frameTime * speed;
        if (smoothing > 1) smoothing = 1;
        gameOverBarLevels[i] = FlxMath.lerp(currentLevel, targetLevel, smoothing);
        currentLevel = gameOverBarLevels[i];
        totalEnergy += currentLevel;

        var peakLevel:Float = gameOverBarPeaks[i];
        if (currentLevel >= peakLevel)
        {
            peakLevel = currentLevel;
            gameOverPeakHold[i] = 0.14;
        }
        else if (gameOverPeakHold[i] > 0)
        {
            gameOverPeakHold[i] -= frameTime;
        }
        else
        {
            peakLevel -= frameTime * 0.42;
            if (peakLevel < currentLevel) peakLevel = currentLevel;
        }
        gameOverBarPeaks[i] = peakLevel;

        var screenHeight:Float = FlxG.height * currentLevel;
        var screenX:Float = i * gameOverBarStep + gameOverBarStep * 0.5;
        var widthScale:Float = gameOverBarWidth * (0.95 + frequency * 0.12);
        if (i % 6 == 5) widthScale *= 0.90;

        var bar:FlxSprite = gameOverBars[i];
        gameOverSetScreenTransform(bar, screenX, screenCenterY, widthScale, screenHeight, zoom);

        var energy:Float = (currentLevel - 0.035) / 0.56;
        if (energy < 0) energy = 0;
        if (energy > 1) energy = 1;
        bar.alpha = 0.25 + energy * 0.42;

        var peakTop:FlxSprite = gameOverPeakBarsTop[i];
        var peakBottom:FlxSprite = gameOverPeakBarsBottom[i];
        var peakVisible:Bool = peakLevel > currentLevel + 0.018;
        peakTop.visible = peakVisible;
        peakBottom.visible = peakVisible;
        if (peakVisible)
        {
            var peakHalfHeight:Float = FlxG.height * peakLevel * 0.5;
            var markerWidth:Float = widthScale * 0.78;
            var markerYTop:Float = screenCenterY - peakHalfHeight - 2.5;
            var markerYBottom:Float = screenCenterY + peakHalfHeight + 2.5;
            gameOverSetScreenTransform(peakTop, screenX, markerYTop, markerWidth, 2.8, zoom);
            gameOverSetScreenTransform(peakBottom, screenX, markerYBottom, markerWidth, 2.8, zoom);
            peakTop.alpha = 0.46 + energy * 0.34;
            peakBottom.alpha = peakTop.alpha;
        }
    }

    if (gameOverVisualizerLine != null)
    {
        var averageEnergy:Float = totalEnergy / count;
        var lineEnergy:Float = (averageEnergy - 0.035) / 0.56;
        if (lineEnergy < 0) lineEnergy = 0;
        if (lineEnergy > 1) lineEnergy = 1;
        gameOverVisualizerLine.alpha = 0.24 + lineEnergy * 0.24;
    }
}
