package com.nachofries.framework.spritesheet;
import com.nachofries.framework.util.ClassInfo;
import com.nachofries.framework.util.Pooling;

/**
 * ...
 * @author Michael R. Bernstein
 */
@final
class SpriteSheetSprite extends AbstractSpriteSheetSprite {
    public static inline function create(image:String):SpriteSheetSprite {
        var sprite:SpriteSheetSprite = Pooling.get(ClassInfo.getClassName());

        if(sprite == null) {
            sprite = new SpriteSheetSprite();
        }
        sprite.init(image);
        return sprite;
    }
    override public function destroy():Void {
        super.destroy();
        Pooling.recycle(this);
    }
}