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

class ArrayUtils {
    public static inline function convertStringArrayToInt(stringValues:Array<String>):Array<Int> {
        var valuesInt:Array<Int> = [];
        for (stringValue in stringValues) {
            valuesInt.push(Std.parseInt(stringValue));
        }
        return valuesInt;
    }

    public static inline function clearArray<T> (array:Array<T>):Void {
        if(array != null) {
            array.splice(0, array.length);
        }
    }

    public static inline function randomizeArray<T> (array:Array<T>):Array<T> {
        var arrayCopy = array.copy ();
        var randomArray = new Array<T> ();

        while (arrayCopy.length > 0) {
            var randomIndex = Math.round (Math.random () * (arrayCopy.length - 1));
            randomArray.push (arrayCopy.splice (randomIndex, 1)[0]);
        }
        return randomArray;
    }

    public static inline function pickRandom<T>(array:Array<T>):T {
        return array[Math.floor(Math.random()*array.length)];
    }
    public static inline function pickRandomCharacter(characterList:String):String {
        return characterList.charAt(Math.floor(Math.random() * characterList.length));
    }

    public static inline function popRandom<T>(array:Array<T>):T {
        return array.splice(Math.floor(Math.random()*array.length), 1)[0];
    }

    public static inline function appendToArray<T>(array:Array<T>, items:Array<T>):Array<T> {
        if(array == null) {
            return items;
        } else {
            for(item in items) {
                array.push(item);
            }
            return array;
        }
    }
}