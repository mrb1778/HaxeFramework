package com.nachofries.framework.util;

import openfl.text.Font;
import openfl.Assets;
import openfl.net.URLRequest;
import haxe.Json;
import openfl.Lib;

class Resources {
    public static inline var ASSETS_LOCATION:String = "assets/";
    private static inline var FONT_LOCATION:String = ASSETS_LOCATION + "fonts/";
    private static inline var FONT_EXTENSION:String = ".ttf";
    public static inline var JSON_EXTENSION:String = ".json";


    public static inline function loadJson(name:String):Dynamic {
        var jsonText = Assets.getText(getJsonPath(name));
        return jsonText == null ? null : Json.parse(jsonText);
    }

    public static inline function getJsonPath(name:String):String {
        return ASSETS_LOCATION + name + JSON_EXTENSION;
    }

    public static inline function openURL(url:String):Void {
        Lib.getURL(new URLRequest(url));
    }

    public static inline function getDefaultFont():Font {
        return Assets.getFont(FONT_LOCATION + Settings.getSetting("font.default", "Chango-Regular") + FONT_EXTENSION);
    }


}
