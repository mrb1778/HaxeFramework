package com.nachofries.framework.util;

import com.nachofries.framework.util.JsonUtils.JsonStringEntry;
import extension.locale.Locale;


class I18N {
    private static var text = new Map<String, String>();

    public static inline function getText(key:String, ?param:Dynamic, ?param1:Dynamic, ?param2:Dynamic, ?params:Array<Dynamic>):String {
        var text:String = lookupText(key);
        if(param != null) {
            text = StringTools.replace(text, "{0}", Std.string(param));
        }
        if(param1 != null) {
            text = StringTools.replace(text, "{1}", Std.string(param));
        }
        if(param2 != null) {
            text = StringTools.replace(text, "{2}", Std.string(param));
        }
        if(params != null) {
            for(i in 0...params.length) {
                var param = params[i];
                text = StringTools.replace(text, "{" + i + "}", Std.string(param));
            }
        }
        return text;
    }

    public static inline function lookupText(key:String):String {
        if(text.exists(key)) {
            return text.get(key);
        } else {
            return key;
        }
    }

    public static function initialize(?directory:String, fileName:String="messages"):Void {
        var language = Locale.getSmartLangCode();
        loadText(directory, fileName, language);
    }

    public static function loadText(?directory:String, fileName:String="messages", language:String=""):Void {
        if(language == Settings.getSetting("language.default", "en")) {
            language = "";
        }

        var json = Resources.loadJson((directory == null ? "" : (directory + "/")) + fileName + ((language == "" || language == null) ? "" : "-" + language));
        if(json != null) {
            JsonUtils.populateMapFrom(text, json.messages);
        } else if(language != "") {
            loadText(directory, fileName);
        }
    }
}