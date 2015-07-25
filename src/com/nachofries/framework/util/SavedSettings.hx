package com.nachofries.framework.util;

import openfl.net.SharedObject;
import haxe.Unserializer;
import haxe.Serializer;

class SavedSettings {
    private static var settings:SharedObject;
    static private var listeners:Map<String, Array<Dynamic->Void>> = new Map<String, Array<Dynamic->Void>>();

    public static inline function initialize():Void {
		settings = SharedObject.getLocal("settings");
	}
    public static inline function hasSetting(key:String):Bool {
        return Reflect.hasField(settings.data, key);
    }
    public static inline function getSetting(key:String):Dynamic {
        #if debug
        trace("get setting(" + key + " => " + Reflect.field(settings.data, key) + ")");
        #end
		return Reflect.field(settings.data, key);
	}
    public static inline function getSettingBool(key:String, defaultBool:Bool=false):Bool {
        var value:Bool;
        if(hasSetting(key)) {
            value = "true" == getSetting(key);
        } else {
            value = defaultBool;
        }
        return value;
	}
    public static inline function saveSettingBoolIfNotTrue(key:String):Bool {
        if(!getSettingBool(key)) {
            saveSetting(key, true);
            return true;
        }
        return false;
    }
    public static inline function toggleSettingBool(key:String):Bool {
        return saveSetting(key, !getSettingBool(key));
    }
    public static function toggleSettingBoolHandler(key:String, _):Void {
        toggleSettingBool(key);
    }

    public static inline function initSetting(key:String, defaultValue:Dynamic):Void {
        if(!hasSetting(key)) {
            saveSetting(key, Std.string(defaultValue));
        }
	}

    public static inline function getSettingInt(key:String, defaultNum:Int=0):Int {
        var value:Int;
        if(hasSetting(key)) {
            value = Std.parseInt(getSetting(key));
        } else {
            value = defaultNum;
        }
        return value;
	}
    public static inline function getSettingFloat(key:String, defaultNum:Float=0.0):Float {
        var value:Float;
        if(hasSetting(key)) {
            value = Std.parseFloat(getSetting(key));
        } else {
            value = defaultNum;
        }
        return value;
	}
    public static inline function incrementSetting(key:String, incrementAmount:Int=1, defaultNum:Int=0):Int {
		var setting:Int = getSettingInt(key, defaultNum);
        var value:Int = setting + incrementAmount;
        saveSetting(key, value);
        return value;
	}
    public static inline function decrementSetting(key:String, decrementAmount:Int=1, defaultNum:Int=0):Int {
		return incrementSetting(key, -decrementAmount, defaultNum);
	}
    public static inline function hasBalance(key:String, balanceAmount:Int=1):Bool {
		return getSettingInt(key) >= balanceAmount;
	}
	public static inline function saveHighSetting(key:String, value:Int):Bool {
        var highSetting:Int = getSettingInt(key, 0);

        if(value > highSetting) {
            saveSetting(key, value);
            highSetting = value;
            return true;
        }
        return false;
	}
    public static function saveSetting(key:String, value:Dynamic):Dynamic {
        #if debug
        trace("save setting(" + key + ", " + value + ")");
        #end
		settings.setProperty(key, Std.string(value));
		settings.flush();
        settingChanged(key, value);
        return value;
	}
    public static function deleteSetting(key:String):Void {
        Reflect.deleteField(settings.data, key);
        settingChanged(key, null);
	}

    public static inline function saveSettingArray(key:String, value:Array<Dynamic>):Void {
        saveSetting(key, value.join("|"));
	}
    public static inline function getSettingArray(key:String):Array<String> {
        var value:Array<String>;
        if(hasSetting(key)) {
            value = Std.string(getSetting(key)).split("|");
        } else {
            value = [];
        }
        return value;
    }

    public static inline function getSettingArrayInt(key:String):Array<Int> {
        return ArrayUtils.convertStringArrayToInt(getSettingArray(key));
    }


    public static inline function saveSettingMap(key:String, value:Map<String, String>):Void {
        var valueBuffer:StringBuf = new StringBuf();
        for(key in value.keys()) {
            valueBuffer.add(key);
            valueBuffer.add(":");
            valueBuffer.add(value.get(key));
            valueBuffer.add("|");
        }
        saveSetting(key, valueBuffer.toString());
    }
    public static inline function getSettingMap(key:String):Map<String, String> {
        var value:Map<String, String> = new Map<String, String>();
        if(hasSetting(key)) {
            var valueMap:Array<String> = Std.string(getSetting(key)).split("|");
            for(entry in valueMap) {
                var entrySplit:Array<String> = entry.split(":");
                var entryKey = entrySplit[0];
                var entryValue = entrySplit[1];
                if(entryKey != null && entryValue != null && entryKey.length > 0) {
                    value.set(entryKey, entryValue);
                }
            }
        }
        return value;
    }
    public static inline function hasMapSetting(settingsKey:String, key:String):Bool {
        var valueMap:Map<String, String> = getSettingMap(settingsKey);
        return valueMap.exists(key);
    }
    public static inline function addSettingMapValue(settingsKey:String, key:String, value:String):Void {
        var valueMap:Map<String, String> = getSettingMap(settingsKey);
        valueMap.set(key, value);
        saveSettingMap(settingsKey, valueMap);
    }

    static public function observe(setting:String, callback:Dynamic->Void):Void {
        if(listeners.exists(setting)) {
            listeners[setting].push(callback);
        } else {
            listeners[setting] = [callback];
        }
    }

    static public function setAndObserve(setting:String, callback:Dynamic->Void):Void {
        callback(getSetting(setting));
        observe(setting, callback);
    }

    static private inline function settingChanged(setting:String, value:Dynamic):Void {
        if(listeners.exists(setting)) {
            for(callback in listeners[setting]) {
                callback(value);
            }
        }
    }

    public static inline function clearAll():Void {
        settings.clear();
    }

    public static inline function serialize():String {
        var serializer:Serializer = new Serializer();
        serializer.serialize(settings.data);
        return serializer.toString();
    }

    public static inline function unSerialize(serialized:String):Void {
        var unserializer:Unserializer = new Unserializer(serialized);
        var unserialized:Dynamic = unserializer.unserialize();
        for(fieldName in Reflect.fields(unserialized)) {
            saveSetting(fieldName, Reflect.field(unserialized, fieldName));
        }
    }
}