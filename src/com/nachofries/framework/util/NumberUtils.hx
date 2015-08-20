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

class NumberUtils {
    public static inline var GESTURE_BACK:Int = 27;
    public static inline var KEYCODE_BACK:Int = 4;

    private static inline var RADIANS_CONVERSION:Float  = 57.29577951308232;//180 / Math.PI;
    private static inline var DEGREES_CONVERSION:Float = 0.017453292519943295;//Math.PI /180;

    private function new() {}


    public static inline function getValue<T>(value:Null<T>, defaultValue:T):T {
        return value == null ? defaultValue : value;
    }

    public static inline function rand( min : Float, max : Float ):Float {
        return Math.round(Math.random() * (max - min + 1)) + min;
    }
    public static inline function radiansToDegrees(angle : Float):Float {
        return (angle * RADIANS_CONVERSION) % 360.0;
    }
    public static inline function degreesToRadians(angle : Float):Float {
        return angle * DEGREES_CONVERSION;
    }
    public static inline function distanceBetween(x1:Float, y1:Float, x2:Float, y2:Float):Float {
        return Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2));
    }
    public static inline function angleBetween(x1:Float, y1:Float, x2:Float, y2:Float):Float {
        return Math.atan((y2 - y1) / (x2 - x1));
    }
    public static inline function degreesBetween(x1:Float, y1:Float, x2:Float, y2:Float):Float {
        return radiansToDegrees(angleBetween(x1, x2, y1, y2));
    }
    public static inline function rotatePoint(v1x:Float, v1y:Float, v2x:Float, v2y:Float):Point {
        return new Point(v1x * v2x - v1y * v2y, v1x * v2y + v1y * v2x);
    }


/*public static inline function copy<T>(fromObject:T, toObject:T): T {
		var fields = Reflect.fields(fromObject);
		for (field in fields) {
            var baseFieldValue:Dynamic = Reflect.field(fromObject, field);
            Reflect.setField(toObject, field, Reflect.field(fromObject, field));
		}
		return toObject;
	}*/

/**
	 * Clamps the value within the minimum and maximum values.
	 * @param	value		The Float to evaluate.
	 * @param	min			The minimum range.
	 * @param	max			The maximum range.
	 * @return	The clamped value.
	 */
    public static function clamp(value:Float, min:Float=0.0, max:Float=1.0):Float {
        if (max > min) {
            if (value < min) return min;
            else if (value > max) return max;
            else return value;
        } else { // Min/max swapped
            if (value < max) return max;
            else if (value > min) return min;
            else return value;
        }
    }

    public static function inRange(value:Float, min:Float=0.0, max:Float=1.0):Bool {
        if (max > min) {
            if (value < min) return false;
            else if (value > max) return false;
            else return true;
        } else { // Min/max swapped
            if (value < max) return false;
            else if (value > min) return false;
            else return true;
        }
    }


    private static inline var UID_CHARS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

    public static inline function randomUID(?size:Int=32):String {
        var nchars = UID_CHARS.length;
        var uid = new StringBuf();
        for (i in 0 ... size) {
            uid.addChar(UID_CHARS.charCodeAt(Std.random(nchars)));
        }
        return uid.toString();
    }

    public static inline function calcRandomVariance(value:Float, variance:Float):Float {
        return value + (-.5 + Math.random()) * variance;
    }
}