package com.nachofries.framework.util;

class JsonUtils {
    public static inline function extend<T>(base:T, extended:T): T {
        var extended:T = Reflect.copy(extended);

        var fields = Reflect.fields(base);
        for (field in fields) {
            var baseFieldValue:Dynamic = Reflect.field(base, field);
            if (!Reflect.hasField(extended, field)) {
                Reflect.setField(extended, field, baseFieldValue);
            } else if(Type.typeof(baseFieldValue) == Type.ValueType.TObject) {
                Reflect.setField(extended, field, extend(baseFieldValue, Reflect.field(extended, field)));
            }
        }
        return extended;
    }

    public static inline function createMapFrom<T>(json:Dynamic):Map<String, T> {
        var map:Map<String, T> = new Map<String, T>();
        populateMapFrom(map, json);
        return map;
    }

    public static inline function populateMapFrom<T>(map:Map<String, T>, json:Array<JsonDynamicEntry>):Void {
        if(json != null) {
            for(jsonEntry in json) {
                map.set(jsonEntry.key, jsonEntry.value);
            }
        }
    }
    public static inline function getKeysFrom(json:Array<JsonDynamicEntry>):Array<String> {
        var keys:Array<String> = [];
        if(json != null) {
            for(jsonEntry in json) {
                keys.push(jsonEntry.key);
            }
        }
        return keys;
    }
}

typedef JsonStringEntry = {
    key:String,
    value:String
}
typedef JsonDynamicEntry = {
    key:String,
    value:Dynamic
}


