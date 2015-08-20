package com.nachofries.framework.util;

class JsonUtils {
    public static inline function extend<T>(base:T, extended:T): T {
        var extended:T = Reflect.copy(extended);

        var fieldNames = Reflect.fields(base);
        for (fieldName in fieldNames) {
            var baseFieldValue:Dynamic = Reflect.field(base, fieldName);
            if(Std.is(baseFieldValue, Array)) {
                var baseFieldValueArray:Array<Dynamic> = baseFieldValue;

                var extendedFieldValueArray:Array<Dynamic>;
                if(Reflect.hasField(extended, fieldName)) {
                    extendedFieldValueArray = Reflect.field(extended, fieldName);
                } else {
                    extendedFieldValueArray = Reflect.copy(baseFieldValueArray);
                }

                var minusFieldName:String = fieldName + "-";
                if (Reflect.hasField(extended, minusFieldName)) {
                    var minusFields:Array<Dynamic> = Reflect.field(extended, minusFieldName);
                    for (minusField in minusFields) {
                        extendedFieldValueArray.unshift(minusField);
                    }
                }
                var plusFieldName:String = fieldName + "+";
                if (Reflect.hasField(extended, plusFieldName)) {
                    var plusFields:Array<Dynamic> = Reflect.field(extended, plusFieldName);
                    for (plusField in plusFields) {
                        extendedFieldValueArray.push(plusField);
                    }
                }

                Reflect.setField(extended, fieldName, extendedFieldValueArray);
            } else if (!Reflect.hasField(extended, fieldName)) {
                Reflect.setField(extended, fieldName, baseFieldValue);
            }  else if(Reflect.isObject(baseFieldValue)) {
                Reflect.setField(extended, fieldName, extend(baseFieldValue, Reflect.field(extended, fieldName)));
            }
        }
        return extended;
    }

    public static inline function replaceVariables(json:Dynamic, variables:Map<String, Dynamic>):Void {
        var fieldNames = Reflect.fields(json);
        for (fieldName in fieldNames) {
            var fieldValue:Dynamic = Reflect.field(json, fieldName);
            if(Std.is(fieldValue, String)) {
                var fieldValueStr:String = cast(fieldValue, String);
                if(fieldValueStr.charAt(0) == '$') {
                    fieldValueStr = fieldValueStr.substring(1);
                    if(variables.exists(fieldValueStr)) {
                        Reflect.setField(json, fieldName, variables.get(fieldValueStr));
                    }
                }
            } /*else if(Std.is(fieldValue, Array)) {
                *//*var baseFieldValueArray:Array<Dynamic> = baseFieldValue;

                var extendedFieldValueArray:Array<Dynamic>;
                if(Reflect.hasField(extended, fieldName)) {
                    extendedFieldValueArray = Reflect.field(extended, fieldName);
                } else {
                    extendedFieldValueArray = Reflect.copy(baseFieldValueArray);
                }

                var minusFieldName:String = fieldName + "-";
                if (Reflect.hasField(extended, minusFieldName)) {
                    var minusFields:Array<Dynamic> = Reflect.field(extended, minusFieldName);
                    for (minusField in minusFields) {
                        extendedFieldValueArray.unshift(minusField);
                    }
                }
                var plusFieldName:String = fieldName + "+";
                if (Reflect.hasField(extended, plusFieldName)) {
                    var plusFields:Array<Dynamic> = Reflect.field(extended, plusFieldName);
                    for (plusField in plusFields) {
                        extendedFieldValueArray.push(plusField);
                    }
                }

                Reflect.setField(extended, fieldName, extendedFieldValueArray);*//*
            } else if(Reflect.isObject(fieldValue)) {
                //Reflect.setField(extended, fieldName, extend(baseFieldValue, Reflect.field(extended, fieldName)));
            } else */
        }
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


