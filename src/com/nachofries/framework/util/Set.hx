package com.nachofries.framework.util;


/**
 * ...
 * @author Michael R. Bernstein
 */

//@:generic
import haxe.ds.StringMap;
import haxe.ds.ObjectMap;
class Set<T> {
    private var map:Map.IMap<Dynamic, Bool> = new ObjectMap<Dynamic, Bool>();
    private var length:Int = 0;

    public function new(?elements:Iterable<T>) {
        if(elements != null) {
            addAll(elements);
        }
    }
    public function add(element:T):Bool {
        if(element != null && !exists(element)) {
            map.set(element, true);
            length++;
            return true;
        }
        return false;
    }

    public function addAll(elements:Iterable<T>):Void {
        for(element in elements) {
            add(element);
        }
    }

    public inline function iterator():Iterator<T> {
        return map.keys();
    }

    public inline function remove(item:T):Bool {
        if(map.remove(item)) {
            length--;
            return true;
        }
        return false;
    }

    public inline function exists(item:T):Bool {
        return map.exists(item);
    }

    public inline function concat(other:Set<T>):Bool {
        var anyAdded:Bool = false;
        if(other != null) {
            for(item in other) {
                anyAdded = anyAdded || add(item);
            }
        }
        return anyAdded;
    }
    public inline function empty():Bool {
        return length == 0;
    }
    public inline function size():Int {
        return length;
    }

    public inline function clear():Void {
        for (key in map.keys()) {
            remove(key);
        }
    }

    public inline function pop():T {
        if(length == 0) {
            return null;
        }
        var key:T = map.keys().next();
        remove(key);
        return key;
    }

    public inline function peek():T {
        return map.keys().next();
    }

    @:to
    public function toArray():Array<T> {
        var arrayVal:Array<T> = [];
        for (key in map.keys()) {
            arrayVal.push(key);
        }
        return arrayVal;
    }


    public function mapAll(mapFun:T->Set<T>):Set<T> {
        var returnVal:Set<T> = new Set<T>();
        for (key in map.keys()) {
            returnVal.addAll(mapFun(key));
        }
        return returnVal;
    }

    public function filter(predicate:T->Bool):Set<T> {
        var returnVal:Set<T> = new Set<T>();
        for (key in map.keys()) {
            if(predicate(key)) {
                returnVal.add(key);
            }
        }
        return returnVal;
    }

    public function toString():String return map.toString();

    public static function createStringSet(?elements:Iterable<String>):Set<String> {
        var set:Set<String> = new Set<String>();
        set.map = new StringMap<Bool>();

        if(elements != null) {
            set.addAll(elements);
        }

        return set;
    }

    public static function flatten<T>(root:Iterable<Iterable<T>>):Set<T> {
        var flattenedSet:Set<T> = new Set<T>();
        for (child in root) {
            flattenedSet.addAll(child);
        }
        return flattenedSet;
    }
}