package com.nachofries.framework.util;

import com.nachofries.framework.util.JsonUtils.JsonDynamicEntry;
class Settings {
    private static var settings = new Map<String, Dynamic>();

    public static inline function loadSettings(?directory:String, fileName:String="settings"):Void {
        var json:SettingsConfig = Resources.loadJson((directory == null ? "" : (directory + "/")) + fileName);
        populateSettings(json);
    }

    public static inline function populateSettings(json:SettingsConfig):Void {
        if(json != null) {
            JsonUtils.populateMapFrom(settings, json.settings);
        }
    }


    public static inline function hasSetting(key:String):Bool {
        return settings.exists(key);
    }

    public static inline function putSetting(key:String, value:Dynamic):Void {
        settings.set(key, value);
    }

    public static inline function getSetting<T>(key:String, ?defaultValue:T):T {
        if(hasSetting(key)) {
            return settings.get(key);
        } else {
            return defaultValue;
        }
    }

    public static function populateOptions(options:Map<String, Dynamic>, defaults:Map<String, Dynamic>, prefix:String):Map<String, Dynamic> {
        if(options == null) {
            options = new Map<String, Dynamic>();
        }
        for (setting in defaults.keys()) {
            if(!options.exists(setting)) {
                options.set(setting, getSetting(prefix + "." + setting, defaults.get(setting)));
            }
        }
        return options;
    }
}

typedef SettingsConfig = {
    settings: Array<JsonDynamicEntry>
}