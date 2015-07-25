package com.nachofries.framework.util;
class Events {
    static private var listeners:Map<String, Array<Dynamic -> Bool>> = new Map<String, Array<Dynamic -> Bool>>();
    static private var onceListeners:Map<String, Array<Dynamic -> Bool>> = new Map<String, Array<Dynamic -> Bool>>();

    static public function fire(event:String, ?params:Dynamic):Bool {
        var handled:Bool = false;
        if(listeners.exists(event)) {
            for(callback in listeners[event]) {
                if(callback(params)) {
                    handled = true;
                }
            }
        }
        if(onceListeners.exists(event)) {
            while(onceListeners[event].length > 0) {
                if(onceListeners[event].pop()(params)) {
                    handled = true;
                }
            }
        }
        return handled;
    }

    static public function on(event:String, callback:Dynamic -> Bool):Void {
        if(listeners.exists(event)) {
            listeners[event].push(callback);
        } else {
            listeners[event] = [ callback ];
        }
    }

    static public function stopListening(event:String, callback:Dynamic -> Bool):Void {
        if(listeners.exists(event)) {
            listeners[event].remove(callback);
        }

        if(onceListeners.exists(event)) {
            onceListeners[event].remove(callback);
        }
    }

    static public function once(event:String, callback:Dynamic -> Bool):Void {
        if(onceListeners.exists(event)) {
            onceListeners[event].push(callback);
        } else {
            onceListeners[event] = [ callback ];
        }
    }

    static public function clear():Void {
        listeners = new Map<String, Array<Dynamic -> Bool>>();
        onceListeners = new Map<String, Array<Dynamic -> Bool>>();
    }

    static public function listenerFunction(fun:Void->Void, params:Dynamic):Bool {
        fun();
        return true;
    }
    static public function listenerFunctionBool(fun:Bool->Void, value:Bool, params:Dynamic):Bool {
        fun(value);
        return true;
    }
    static public function listenerFunctionInt(fun:Int->Void, value:Int, params:Dynamic):Bool {
        fun(value);
        return true;
    }
}