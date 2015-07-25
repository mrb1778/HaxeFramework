package com.nachofries.framework.spritesheet;

import com.nachofries.framework.util.Application;
import com.nachofries.framework.util.ClassInfo;
import com.nachofries.framework.util.Pooling;
import com.nachofries.framework.spritesheet.SpriteSheetSprite;

/**
 * ...
 * @author Michael R. Bernstein
 */

class TiledSpriteSheetSprite extends SpriteSheetSprite {
    private var tileWidth:Float;
    private var tileHeight:Float;

    private var columns:Int;
    private var rows:Int;

    public static inline function create(image:String, columns:Int, rows:Int):TiledSpriteSheetSprite {
        var sprite:TiledSpriteSheetSprite = Pooling.get(ClassInfo.getClassName());
        if(sprite == null) {
            sprite = new TiledSpriteSheetSprite();
        }

        sprite.columns = columns;
        sprite.rows = rows;
        sprite.init(image);

        return sprite;
    }
    override public function init(?image:String):Void {
        super.init(image);

        if(rows == 0) {
            rows = 1;
        }
        if(columns == 0) {
            columns = 1;
        }

        tileWidth = getWidth();
        tileHeight = getHeight();

        width *= columns;
        height *= rows;

        /*x -= tileWidth * .5;
        y -= tileHeight * .5;*/

        /*Placement.alignTop(this);
        Placement.alignLeft(this);*/
    }

    override public function render():Void {
        for(i in 0...columns) {
            for(j in 0...rows) {
                spriteSheetLayer.renderSprite(
                    x + (i-.5) * tileWidth * scaleX * Application.SCALE,
                    y + j * tileHeight * scaleY * Application.SCALE,
                    tileWidth, tileHeight,
                    spriteSheetIndex,
                    scaleX * Application.SCALE, scaleY * Application.SCALE,
                    rotation,
                    alpha,
                    red, green, blue,
                    flipX, flipY);
            }
        }
    }

    override public function destroy():Void {
        super.destroy();
        if(behavior != null) {
            behavior.destroy();
            behavior = null;
        }
        Pooling.recycle(this);
    }
}