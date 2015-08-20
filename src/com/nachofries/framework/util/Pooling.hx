package com.nachofries.framework.util;

/**
 * ...
 * @author Michael Bernstein
 */

#if debug
import pgr.dconsole.DC;
#end
class Pooling  {
    private static var pool:Map<String, Dynamic>;
    #if debug
    private static var poolStats:Map<String, Int>;
    private static var createStats:Map<String, Int>;
    private static var recycleStats:Map<String, Int>;
    #end

    public static inline function initialize():Void {
        pool = new Map();
        #if debug
        DC.registerObject(pool, "pool");

        poolStats = new Map();
        DC.registerObject(poolStats, "poolStats");

        createStats = new Map();
        DC.registerObject(createStats, "createStats");

        recycleStats = new Map();
        DC.registerObject(recycleStats, "recycleStats");
        #end
    }

    private static inline function getPoolForType<T>(type:String):SimpleStack<T> {
        var typePool:SimpleStack<T> = pool.get(type);
        if(typePool == null) {
            typePool = new SimpleStack<T>();
            pool.set(type, typePool);
        }
        return typePool;
    }

    public static inline function get<T>(type:String):T {
        #if debug
        poolStats.set(type, (poolStats.get(type) == null ? 0 : poolStats.get(type)) -1);
        #end
        var typePool:SimpleStack<T> = pool.get(type);

        #if debug
        if(typePool == null || typePool.isEmpty()) {
            createStats.set(type, (createStats.get(type) == null ? 0 : createStats.get(type)) + 1);
        }
        #end
        if(typePool != null) {
            return typePool.pop();
        } else {
            return null;
        }
    }

    public static inline function recycle(object:Dynamic):Void {
        var type:String = Type.getClassName(Type.getClass(object));
        #if debug
        if(getPoolForType(type).exists(object)) {
            trace("---------------Line 66");
        }
        #end
        getPoolForType(type).add(object);
        #if debug
        poolStats.set(type, poolStats.get(type)+1);
        recycleStats.set(type, (recycleStats.get(type) == null ? 0 : recycleStats.get(type)) + 1);
        #end
    }
}