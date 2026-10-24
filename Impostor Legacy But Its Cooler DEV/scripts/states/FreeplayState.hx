import funkin.Mods;
import funkin.objects.menu.FreeplayCard;

function onCreatePost() {
    var state = parent;
    if (state == null || state.weeks == null) return;

    var erectSong:Dynamic = null;
    var targetBoth:Dynamic = null;
    var targetEjected:Dynamic = null;
    var targetMando:Dynamic = null;

    for (section in state.weeks) {
        if (section == null || section.songs == null) continue;

        for (song in section.songs) {
            if (song != null && song[0] == "Ejected Erect") {
                if (erectSong == null) erectSong = song;
            }
        }
    }

    for (section in state.weeks) {
        if (section == null || section.songs == null) continue;

        var hasEjected = false;
        var hasMando = false;

        for (song in section.songs) {
            if (song == null) continue;

            if (song[0] == "Ejected") hasEjected = true;
            if (song[0] == "Mando") hasMando = true;
        }

        if (hasEjected && hasMando && targetBoth == null) targetBoth = section;
        if (hasEjected && targetEjected == null) targetEjected = section;
        if (hasMando && targetMando == null) targetMando = section;
    }

    var targetSection = targetBoth;

    if (targetSection == null) targetSection = targetEjected;
    if (targetSection == null) targetSection = targetMando;
    if (targetSection == null) return;

    for (section in state.weeks) {
        if (section == null || section.songs == null) continue;

        var songs = section.songs;
        var i = 0;

        while (i < songs.length) {
            if (songs[i] != null && songs[i][0] == "Ejected Erect") {
                if (erectSong == null) erectSong = songs[i];
                songs.splice(i, 1);
            } else {
                i++;
            }
        }
    }

    var songs = targetSection.songs;
    var ejectedIndex = -1;
    var mandoIndex = -1;

    for (i in 0...songs.length) {
        if (songs[i] == null) continue;

        if (songs[i][0] == "Ejected") ejectedIndex = i;
        if (songs[i][0] == "Mando") mandoIndex = i;
    }

    var erectMod = Mods.currentModDirectory;

    if (erectMod == null || erectMod == "") erectMod = targetSection.mod;

    if (erectSong == null) {
        erectSong = [
            "Ejected Erect",
            "green-parasite",
            "greenp",
            FlxColor.fromRGB(0, 255, 0),
            "story",
            [],
            0,
            "Rareblin",
            "beans",
            false,
            erectMod
        ];
    } else if ((erectSong[10] == null || erectSong[10] == "") && erectMod != null && erectMod != "") {
        erectSong[10] = erectMod;
    }

    var insertIndex = songs.length;

    if (ejectedIndex >= 0) {
        insertIndex = ejectedIndex + 1;
    } else if (mandoIndex >= 0) {
        insertIndex = mandoIndex;
    }

    if (mandoIndex >= 0 && ejectedIndex >= 0 && ejectedIndex < mandoIndex && insertIndex > mandoIndex) {
        insertIndex = mandoIndex;
    }

    if (insertIndex < 0) insertIndex = 0;
    if (insertIndex > songs.length) insertIndex = songs.length;

    songs.insert(insertIndex, erectSong);
}

function onSectionPost(curMonth) {
    var erectMod = Mods.currentModDirectory;

    for (song in week_songs) {
        if (song != null && song.songName == "Ejected Erect") {
            if ((song.mod == null || song.mod == "") && erectMod != null && erectMod != "") {
                song[10] = erectMod;
            }
        }
    }

    if (curMonth != 1) return;

    var stealthExists = false;

    for (song in week_songs) {
        if (song != null && song.songName == "Stealth") {
            stealthExists = true;
            break;
        }
    }

    if (stealthExists) return;

    final stealthSong:SongInformation = [
        "Stealth",
        "maroon",
        "maroon",
        FlxColor.fromRGB(181, 0, 0),
        "special",
        ["stealth"],
        0,
        "8 Bit Beeps, Hmm111",
        "beans",
        false,
        "stealth"
    ];

    var stealthIndex = 2;
    if (stealthIndex > week_songs.length) stealthIndex = week_songs.length;

    final isLocked:Bool = checkLock(stealthSong);
    var animate:Bool = false;

    ws_lock.insert(stealthIndex, isLocked);
    week_songs.insert(stealthIndex, stealthSong);

    if (ClientPrefs.checkoutUnlockedSongs.contains(stealthSong.songName) == isLocked) {
        if (isLocked) {
            ClientPrefs.checkoutUnlockedSongs.remove(stealthSong.songName);
        } else {
            ClientPrefs.checkoutUnlockedSongs.push(stealthSong.songName);
            if (stealthSong.lock == "special") animate = true;
        }
    }

    Mods.currentModDirectory = stealthSong.mod;

    for (card in cards.members) {
        if (card.ID >= stealthIndex) card.ID++;
    }

    var c = cachedCards.recycle(FreeplayCard);
    c.initCard(stealthSong, ws_lock[stealthIndex] || animate);
    c.ID = stealthIndex;
    cards.insert(stealthIndex, c);
    c.zIndex = 5;

    for (card in cards.members) {
        if (card.ID >= stealthIndex) {
            moveCard(card, smoothSelect, true);
            card.x -= 700;
        }
    }

    if (animate) animateCards.push(c);
}