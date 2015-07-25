package com.nachofries.framework.lifecycle;

/**
 * ...
 * @author Michael R. Bernstein
 */

import com.nachofries.framework.util.Events;
class LifeCycleManager {
	static var lifecycleController:LifeCycleController;

    public static function initialize(lifecycleController:LifeCycleController):Void {
        LifeCycleManager.lifecycleController = lifecycleController;

        Events.on(LifecycleEvent.CHANGE_STATE, changeStateHandler);
        Events.on(LifecycleEvent.NEXT, nextHandler);
        Events.on(LifecycleEvent.BACK, backHandler);
        Events.on(LifecycleEvent.RESTART, restartHandler);
    }

	public static function changeState(newState:String, ?params:Dynamic):Void {
        lifecycleController.changeState(newState, params);
    }
    public static function goNext(?params:Dynamic):Void {
        lifecycleController.goNext(params);
    }
	public static function goBack(?params:Dynamic):Void {
        lifecycleController.goBack(params);
    }
    public static function restart(?params:Dynamic):Void {
        lifecycleController.restart(params);
    }

    private static function changeStateHandler(?option:StateChangeRequest):Bool {
        changeState(option.state, option.options);
        return true;
    }
    private static function nextHandler(?option:Dynamic):Bool {
        goNext(option);
        return true;
    }
    private static function backHandler(?option:Dynamic):Bool {
        goBack();
        return true;
    }
    private static function restartHandler(?option:Dynamic):Bool {
        restart();
        return true;
    }
}

typedef StateChangeRequest = {
    state:String,
    ?options:Dynamic
}