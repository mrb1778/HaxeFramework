package com.nachofries.framework.lifecycle;



/**
 * ...
 * @author Michael R. Bernstein
 */

import com.nachofries.framework.util.Set;
import com.nachofries.framework.util.SpriteWatcher;
class LifecycleSpriteWatcher extends LifecycleSprite {
	public function new() {
		super();
	}

    public function removeSprite(sprite:LifecycleSprite):LifecycleSprite {
        removeChild(sprite);
        SpriteWatcher.stopWatching(this, sprite);
        return sprite;
    }
    public function addAndWatchSprite(sprite:LifecycleSprite):LifecycleSprite {
        addChild(sprite);
        SpriteWatcher.watch(this, sprite);
        return sprite;
    }
    override public function reset():Void {
        super.reset();
        var watchedSprites:Set<LifecycleSprite> = SpriteWatcher.getWatched(this);
        if(watchedSprites != null) {
            for(sprite in watchedSprites) {
                sprite.reset();
            }
        }
    }
    public function clearWatchedSprites():Void {
        var watchedSprites:Set<LifecycleSprite> = SpriteWatcher.getWatched(this);
        var watchedSprites:Set<LifecycleSprite> = SpriteWatcher.getWatched(this);
        if(watchedSprites != null) {
            for(sprite in watchedSprites) {
                sprite.destroy();
            }
        }
        while (numChildren > 0) {
            removeChildAt(0);
        }
    }

    override public function start():Void {
        super.start();
        var watchedSprites:Set<LifecycleSprite> = SpriteWatcher.getWatched(this);
        if(watchedSprites != null) {
            var watchedSprites:Set<LifecycleSprite> = SpriteWatcher.getWatched(this);
            if(watchedSprites != null) {
                for(sprite in watchedSprites) {
                    sprite.start();
                }
            }
        }
    }

    override public function stop():Void {
        super.stop();
        var watchedSprites:Set<LifecycleSprite> = SpriteWatcher.getWatched(this);
        if(watchedSprites != null) {
            for(sprite in watchedSprites) {
                sprite.stop();
            }
        }
    }

    override public function update():Void {
        super.update();
        var watchedSprites:Set<LifecycleSprite> = SpriteWatcher.getWatched(this);
        if(watchedSprites != null) {
            for(sprite in watchedSprites) {
                sprite.update();
            }
        }
    }
}