package com.nachofries.framework.util;


/**
 * ...
 * @author Michael R. Bernstein
 */

class Pair<T> {
    private var first:T;
    private var second:T;

    public function new(first:T, second:T) {
        this.first = first;
        this.second = second;
    }

    public inline function getFirst():T return first;
    public inline function getSecond():T return second;
    public inline function getOther(item:T):T {
        return item == first ? second : first;
    }

    public function toString():String return "Pair("+first+", "+second+")";
}