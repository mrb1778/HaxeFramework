package com.nachofries.framework.util;

import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.Assets;

class Sounds {
    public static inline var SOUND_LOCATION:String = Resources.ASSETS_LOCATION + "sounds/";
    public static inline var SOUND_EXTENSION:String = ".ogg";
    //public static inline var MUSIC_EXTENSION:String = ".wav";
    public static inline var MUSIC_EXTENSION:String = ".ogg";

    public static inline var SETTING_BACKGROUND_MUTED = "muted.background";
    public static inline var SETTING_MUTED = "muted.sounds";
    private static var backgroundMusic:SoundChannel;
    private static var lastBackgroundMusicName:String = null;
    private static var backgroundMusicPosition:Float = 0;

    public static function initialize():Void {
        SavedSettings.observe(SETTING_BACKGROUND_MUTED, onBackgroundMuted);
    }

    private static inline function getSound(name:String, extension:String=SOUND_EXTENSION):Sound {
        return Assets.getSound(SOUND_LOCATION + name + extension);
    }
    public static inline function playSound(name:String, numTimes:Int=0, extension:String=SOUND_EXTENSION, position:Float=0):SoundChannel {
        var soundChannel:SoundChannel = null;
        if (!isMuted() && name != null && name != "") {
            var sound:Sound = getSound(name, extension);
            if(sound != null) {
                soundChannel = sound.play(position, numTimes);
            }
        }
        return soundChannel;
    }
    public static inline function playBackgroundMusic(?name:String, position:Float=0, numTimes:Int=10000):Void {
        if(name == null) {
            name = lastBackgroundMusicName;
        }
        if(backgroundMusic == null || lastBackgroundMusicName != name) {
            stopBackgroundMusic();
            lastBackgroundMusicName = name;
            if (!isBackgroundMuted() && name != null && name != "") {
                var sound:Sound = getSound(name, MUSIC_EXTENSION);
                if(sound != null) {
                    backgroundMusic = sound.play(position, numTimes);
                }
            }
        }
    }

    public static inline function resumeBackgroundMusic():Void {
        playBackgroundMusic(lastBackgroundMusicName, backgroundMusicPosition);
    }

    public static inline function pauseBackgroundMusic():Void {
        if(backgroundMusic != null) {
            backgroundMusicPosition = backgroundMusic.position;
            backgroundMusic.stop();
            backgroundMusic = null;
        }
    }
    public static inline function stopBackgroundMusic():Void {
        lastBackgroundMusicName = null;
        backgroundMusicPosition = 0;
        if(backgroundMusic != null) {
            backgroundMusic.stop();
            backgroundMusic = null;
        }
    }

    public static inline function isBackgroundMuted():Bool {
        return SavedSettings.getSettingBool(SETTING_BACKGROUND_MUTED);
    }
    public static inline function isMuted():Bool {
        return SavedSettings.getSettingBool(SETTING_MUTED);
    }
    public static inline function toggleBackgroundMute():Bool {
        if(SavedSettings.toggleSettingBool(SETTING_BACKGROUND_MUTED)) {
            pauseBackgroundMusic();
            return true;
        } else if(lastBackgroundMusicName != null) {
            playBackgroundMusic(lastBackgroundMusicName);
        }
        return false;
    }
    public static inline function onBackgroundMuted(muted:Bool):Bool {
        if(muted) {
            pauseBackgroundMusic();
            return true;
        } else if(lastBackgroundMusicName != null) {
            playBackgroundMusic(lastBackgroundMusicName);
        }
        return false;
    }
    public static inline function toggleMute():Bool {
        return SavedSettings.toggleSettingBool(SETTING_MUTED);
    }
}