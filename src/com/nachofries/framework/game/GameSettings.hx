package com.nachofries.framework.game;

/**
 * ...
 * @author Michael R. Bernstein
 */

import com.nachofries.framework.util.NumberUtils;
import com.nachofries.basegame.util.Tracking;
import com.nachofries.framework.util.Events;
import com.nachofries.framework.util.Settings;
import com.nachofries.framework.util.SavedSettings;
class GameSettings {
    public static inline var SETTING_NUM_COINS:String = "game.coins";
    public static inline var SETTING_NUM_LIVES:String = "game.numLives";
    public static inline var SETTING_MAX_LIVES:String = "game.maxLives";
    public static inline var SETTING_INITIAL_COIN:String = "game.initialCoin";
    public static inline var SETTING_TOTAL_STARS:String = "game.numStars";
    public static inline var SETTING_NUM_STARS:String = "game.num.stars.";
    public  static inline var SETTING_CURRENT_LEVEL:String = "game.currentLevel";

    public static inline var SETTING_LEVEL_COMPLETE:String = "level.complete.";
    public static inline var SETTING_LEVEL_STARS:String = "level.stars.";
    public static inline var SETTING_LEVEL_MOVES:String = "level.moves.";
    public static inline var SETTING_LEVEL_SCORE:String = "level.score.";

    public static inline var EVENT_LEVEL_COMPLETE:String = "level-complete";
    public static inline var EVENT_LEVEL_FAIL:String = "level-fail";


    private static inline var COINS_PREFIX:String = "money_";


    public static inline function initialize():Void {
        SavedSettings.initSetting(SETTING_NUM_LIVES, getMaxLives());
        SavedSettings.initSetting(SETTING_NUM_COINS, Settings.getSetting(SETTING_INITIAL_COIN, 40));
    }

    public static inline function getMaxLives():Int {
        return Settings.getSetting(SETTING_MAX_LIVES, 10);
    }

    public static inline function getNumCoins():Int {
        return SavedSettings.getSettingInt(SETTING_NUM_COINS);
    }
    public static inline function addCoins(coins:Int):Void {
        SavedSettings.incrementSetting(SETTING_NUM_COINS, coins);
    }
    public static inline function addCoinsForPurchase(string:String):Void {
        addCoins(getCoinAmount(string));
    }
    public static inline function canBuyItem(cost:Int):Bool {
        return SavedSettings.hasBalance(SETTING_NUM_COINS, cost);
    }
    public static inline function buyItem(setting:String, amount:Int, cost:Int):Bool {
        if(canBuyItem(cost)) {
            addCoins(-cost);
            SavedSettings.incrementSetting(setting, amount);
            return true;
        }
        return false;
    }
    public static inline function getItem(setting:String, amount:Int):Bool {
        SavedSettings.incrementSetting(setting, amount);
        return true;
    }
    public static inline function isCoinAmount(string:String):Bool {
        return StringTools.startsWith(string, COINS_PREFIX);
    }
    public static inline function getCoinAmount(string:String):Int {
        if(isCoinAmount(string)) {
            return Std.parseInt(string.substr(COINS_PREFIX.length));
        }
        return 0;
    }
    
    public static inline function addLives(lives:Int):Void {
        SavedSettings.saveSetting(SETTING_NUM_LIVES, NumberUtils.clamp(getNumLives() + lives, 0, getMaxLives()));
    }
    public static inline function getNumLives():Int {
        return SavedSettings.getSettingInt(SETTING_NUM_LIVES);
    }
    public static inline function hasLives():Bool {
        return SavedSettings.hasBalance(SETTING_NUM_LIVES);
    }
    public static inline function hasMaxLives():Bool {
        return SavedSettings.getSettingInt(SETTING_NUM_LIVES) >= getMaxLives();
    }
    
    public static inline function beatLevel(?moves:Int, ?stars:Int, ?score:Int, ?level:Int):Void {
        if(level == null) {
            level = getCurrentLevel();
        }
        SavedSettings.saveSettingBoolIfNotTrue(SETTING_LEVEL_COMPLETE + level);

        if(moves != null) {
            SavedSettings.saveHighSetting(SETTING_LEVEL_MOVES + level, moves);
        }

        if(stars != null) {
            SavedSettings.saveSettingBoolIfNotTrue(SETTING_NUM_STARS + stars);
            SavedSettings.saveHighSetting(SETTING_LEVEL_STARS + level, stars);
        }

        if(score != null) {
            SavedSettings.saveHighSetting(SETTING_LEVEL_SCORE + level, score);
        }
        Events.fire(EVENT_LEVEL_COMPLETE, {level: level, score: score, stars: stars, moves: moves});
        Events.fire(GameState.EVENT_STATE_CHANGED);

        //todo: move to event based
        Tracking.track(EVENT_LEVEL_COMPLETE, ["level"=>level, "moves"=>moves, "stars" => stars, "score" => score]);
    }

    public static inline function levelFail(?moves:Int, ?level:Int):Void { //todo: move to event based
        if(level == null) {
            level = getCurrentLevel();
        }
        Tracking.track(EVENT_LEVEL_FAIL, ["level"=>level, "moves"=>moves]);
    }


    public static inline function getCompleteSetting(level:Int):String {
        return SETTING_LEVEL_COMPLETE + level;
    }
    public static inline function isLevelComplete(level:Int):Bool {
        return SavedSettings.getSettingBool(getCompleteSetting(level), false);
    }
    
    public static inline function setCurrentLevel(level:Int):Void {
        SavedSettings.saveSetting(SETTING_CURRENT_LEVEL, level);
    }
    public static inline function getCurrentLevel():Int {
        return SavedSettings.getSettingInt(SETTING_CURRENT_LEVEL, 1);
    }
    public static inline function incrementCurrentLevel():Int {
        return SavedSettings.incrementSetting(SETTING_CURRENT_LEVEL, 1);
    }

    public static inline function getLevelStars(?level:Int):Int {
        if(level == null) {
            level = getCurrentLevel();
        }
        return SavedSettings.getSettingInt(SETTING_LEVEL_STARS + level, 0);
    }
}