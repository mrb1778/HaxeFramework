package com.nachofries.framework.util;
import openfl.geom.Point;

/**
 * ...
 * @author Michael R. Bernstein
 */

/**
 * ...
 * @author Michael R. Bernstein
 */

class NetworkUtils {
    public static inline function toQueryString(params:Map<String, Dynamic>):String {
        var paramsBuff:StringBuf = new StringBuf();
        var first:Bool = true;
        for (paramName in params.keys()) {
            if(first) {
                first = false;
            } else {
                paramsBuff.add("&");
            }
            paramsBuff.add(paramName);
            paramsBuff.add("=");
            paramsBuff.add(StringTools.urlEncode(params.get(paramName)));
        }
        return paramsBuff.toString();
    }
}