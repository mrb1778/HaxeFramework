package com.nachofries.framework.util;

/**
 * ...
 * @author Michael Bernstein
 */

class Pooling  {
    private static var pool:Map<String, Dynamic>;
    private static inline function getPoolForType<T>(type:String):Set<T> {
        if(pool == null) {
            pool = new Map();
        }
        var typePool:Set<T> = pool.get(type);
        if(typePool == null) {
            typePool = new Set<T>();
            pool.set(type, typePool);
        }
        return typePool;
    }

    public static inline function get<T>(type:String):T {
        return getPoolForType(type).pop();
    }

    public static inline function recycle(object:Dynamic):Void {
        getPoolForType(Type.getClassName(Type.getClass(object))).add(object);
    }
}