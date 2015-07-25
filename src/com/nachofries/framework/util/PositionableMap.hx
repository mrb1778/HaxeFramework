package com.nachofries.framework.util;

/**
 * ...
 * @author Michael Bernstein
 */

import haxe.ds.StringMap;
class PositionableMap extends StringMap<Positionable> {
    public static inline var IDENTIFIER_PREVIOUS = "previous";

    public function new():Void {
        super();
        set(Application.SCREEN_NAME, Application.SCREEN_RECTANGLE);
    }

    public function addPositionable(object:Positionable, ?definition:Dynamic, ?index:Int) {
        if(definition != null) {
            var name:String = definition.name;
            if (name != null) {
                if(index == 0 || !exists(name)) {
                    set(name, object);
                }
                set(name + index, object);
            }
            var templateName:String = definition.template;
            if (templateName != null) {
                if(index == 0 || !exists(templateName)) {
                    set(templateName, object);
                }
                set(templateName + index, object);
            }
        }
        set(IDENTIFIER_PREVIOUS, object);
    }

    public inline function getPrevious():Null<Positionable> {
        return get(IDENTIFIER_PREVIOUS);
    }
}