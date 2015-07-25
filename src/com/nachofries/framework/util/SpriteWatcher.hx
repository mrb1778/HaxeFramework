package com.nachofries.framework.util;
import haxe.ds.ObjectMap;
import com.nachofries.framework.lifecycle.LifecycleSprite;
class SpriteWatcher {
    static private var watchers:Map.IMap<Dynamic, Set<LifecycleSprite>> = new ObjectMap<Dynamic, Set<LifecycleSprite>>();

    static public function getWatched(watcher:Dynamic):Set<LifecycleSprite> {
        return watchers.get(watcher);
    }
    static public function findWatchedByName(watcher:Dynamic, name:String):Set<LifecycleSprite> {
        var watchedByName:Set<LifecycleSprite> = new Set<LifecycleSprite>();

        for(sprite in getWatched(watcher)) {
            if (name == null || name == sprite.getName()) {
                watchedByName.add(sprite);
            }
        }
        return watchedByName;
    }
    static public function watch(watcher:Dynamic, watchee:LifecycleSprite):Void {
        var watched:Set<LifecycleSprite> = getWatched(watcher);
        if(watched == null) {
            watched = new Set<LifecycleSprite>();
            watchers.set(watcher, watched);
        }
        watched.add(watchee);
    }

    static public function stopWatching(watcher:Dynamic, watchee:LifecycleSprite):Void {
        var watched:Set<LifecycleSprite> = getWatched(watcher);
        if(watched != null) {
            watched.remove(watchee);
        }
    }
    static public function clearWatching(watcher:Dynamic):Void {
        var watched:Set<LifecycleSprite> = getWatched(watcher);
        if(watched != null) {
            watched.clear();
        }
    }

    static public function unWatch(watchee:LifecycleSprite):Void {
        for(watcherList in watchers) {
            watcherList.remove(watchee);
        }
    }
}