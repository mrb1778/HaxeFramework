package com.nachofries.framework.game;

/**
 * ...
 * @author Michael R. Bernstein
 */

import com.nachofries.framework.util.State;
class GameState {
	public static inline var EVENT_STATE_CHANGED:String = "gameState.changed";

	public static inline var MAIN:String = "mainScreen";
	public static inline var SPLASH:String = "splashScreen";
	public static inline var SPLASH2:String = "splashScreen2";
	public static inline var TITLE:String = "titleScreen";
	public static inline var WORLD_CHOOSE:String = "worldChooserScreen";
	public static inline var LEVEL_CHOOSE:String = "levelChooserScreen";
	public static inline var GAME:String = "gameScreen";
	public static inline var LEVEL_COMPLETE:String = "levelCompleteScreen";
	public static inline var LEVEL_FAILED:String = "levelFailedScreen";
    public static inline var ACCOMPLISHMENTS:String = "accomplishmentsScreen";
    public static inline var STORE:String = "storeScreen";
    public static inline var ITEM_FOUND:String = "itemFoundScreen";

    public static function canGoNext():Bool {
        return State.getState("level") < State.getState("numLevels") && !State.isStateTrue("levelLocked" + getNextLevel());
    }
    public static function getNextLevel():Int {
        return State.getState("level") + 1;
    }
}