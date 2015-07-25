package com.nachofries.framework.util;

class State {
    private static var states = new Map<String, Int>();

    public static inline function setState(key:String, state:Int):Void {
        states.set(key, state);
    }
    public static inline function getState(key:String):Int {
        return states.get(key);
    }

    public static inline function setBooleanState(key:String, state:Bool):Void {
        setState(key, state == true ? 1 : 0);
    }
    public static inline function isStateTrue(key:String):Bool {
        return getState(key) == 1;
    }
}