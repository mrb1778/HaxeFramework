package com.nachofries.framework.game;
import com.nachofries.framework.screen.LifecycleScreen;
import com.nachofries.framework.util.DialogHandler;
import com.nachofries.framework.util.SavedSettings;
import com.nachofries.framework.util.Application;
import com.nachofries.framework.lifecycle.LifeCycleManager;

/**
 * ...
 * @author Michael R. Bernstein
 */

class GameLevel implements DialogHandler  {
    private static inline var SETTING_PREFIX_WORLD:String = "world.";
    private static inline var SETTING_PREFIX_LEVEL:String = "level.";
    private static inline var SETTING_LEVEL_COMPLETE:String = "complete";

    private var worldNum:Int = 1;
    var parentLevel:Int = -1;
    private var levelNum:Int;
    private var nextLevelNum:Int;

    private var backgroundImage:String;
    private var backgroundImageOverlay:String;
    private var middleGroundImage:String;
    private var midgroundAlpha:Float;

    private var newLevel:Bool = true;

    public function new() {}

	public function setup():Void {}
    public function reset():Void {
        newLevel = true;
    }
	public function start():Void {}
	public function update():Void {}
	public function stop():Void {}
    public function getName():String {
        return worldNum + "-" + (parentLevel != -1 ? parentLevel : levelNum);
    }

    public function isNewLevel():Bool {
        return getRestartLevelNum() == levelNum && newLevel;
    }
    public function setNewLevel(newLevel:Bool):Void {
        this.newLevel = newLevel;
    }

    public function getRestartLevelNum():Int {
        if(parentLevel != -1) {
            return parentLevel;
        }
        return levelNum;
    }
    public function getWidth():Float { return Application.SCREEN_WIDTH; }
	public function getHeight():Float { return Application.SCREEN_HEIGHT; }


	public function levelCompleted():Dynamic {
        var completeKey:String = getSettingKey(SETTING_LEVEL_COMPLETE);
        if(SavedSettings.getSettingBool(completeKey)) {
            SavedSettings.saveSetting(completeKey, true);
            var worldCountKey:String = "world." + worldNum + ".numComplete";
            SavedSettings.incrementSetting(worldCountKey);
        }
        return {};
    }

    private function getSetting(settingName:String):Int {
        return getSettingFor(worldNum, (parentLevel != -1 ? parentLevel : levelNum), settingName);
    }
    private function getSettingKey(settingName:String):String {
        return getSettingKeyFor(worldNum, (parentLevel != -1 ? parentLevel : levelNum), settingName);
    }
    private static inline function getSettingKeyFor(worldNum:Int, levelNum:Int, settingName:String):String {
        return SETTING_PREFIX_LEVEL + worldNum + "-" + levelNum + "." + settingName;
    }
    private static inline function getSettingFor(worldNum:Int, levelNum:Int, settingName:String):Int {
        return SavedSettings.getSettingInt(getSettingKeyFor(worldNum, levelNum, settingName));
    }
    private static inline function getWorldSettingFor(worldNum:Int, settingName:String):Int {
        return SavedSettings.getSettingInt(getWorldSettingKeyFor(worldNum, settingName));
    }
    public static function isLevelComplete(levelNum:Int, worldNum:Int):Bool {
        return SavedSettings.getSettingBool(getSettingKeyFor(levelNum, worldNum, SETTING_LEVEL_COMPLETE));
    }
    public static function getNumLevelsCompleteInWorld(worldNum:Int):Int {
        return SavedSettings.getSettingInt("world." + worldNum + ".numComplete", 0);
    }

    private function getWorldSettingKey(settingName:String):String {
        return getWorldSettingKeyFor(worldNum, settingName);
    }
    private static inline function getWorldSettingKeyFor(worldNum:Int, settingName:String):String {
        return SETTING_PREFIX_WORLD + worldNum + "." + settingName;
    }

    public function getGameScreen():LifecycleScreen { return null; }

    public function goToLevel(params:Dynamic):Void {
        LifeCycleManager.changeState(GameState.GAME, params);
    }
    public function restart():Void { goToLevel({level: getRestartLevelNum()}); }

    public function removeDialog():Void {
        getGameScreen().removeDialog();
    }
    public function quit():Void {
        getGameScreen().quit();
    }
}