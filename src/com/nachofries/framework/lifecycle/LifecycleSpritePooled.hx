package com.nachofries.framework.lifecycle;

/**
 * ...
 * @author Michael R. Bernstein
 */

import com.nachofries.framework.util.ClassInfo;
import com.nachofries.framework.util.Pooling;
@final
class LifecycleSpritePooled extends LifecycleSprite {
    public static inline function create():LifecycleSpritePooled {
        var sprite:LifecycleSpritePooled = Pooling.get(ClassInfo.getClassName());

        if(sprite == null) {
            sprite = new LifecycleSpritePooled();
        }
        return sprite;
    }

    private function new() {
        super();
    }

    override public function destroy():Void {
        super.destroy();
        resetDisplay();
        resetLocation();
        Pooling.recycle(this);
    }
}