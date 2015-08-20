package com.nachofries.framework.spritesheet;

import com.nachofries.framework.util.Application;
import com.nachofries.framework.util.ClassInfo;
import com.nachofries.framework.util.Pooling;

/**
 * ...
 * @author Michael R. Bernstein
 */

@final
class TiledSpriteSheetSprite extends AbstractSpriteSheetSprite {
    private var tileWidth:Float;
    private var tileHeight:Float;

    private var columns:Int;
    private var rows:Int;

    public static inline function create(image:String, columns:Int=1, rows:Int=1):TiledSpriteSheetSprite {
        var sprite:TiledSpriteSheetSprite = Pooling.get(ClassInfo.getClassName());
        if(sprite == null) {
            sprite = new TiledSpriteSheetSprite();
        }

        sprite.init(image);
        sprite.setColumns(columns);
        sprite.setRows(columns);        

        return sprite;
    }
    override public function init(?image:String):Void {
        super.init(image);
        rows = 1;
        columns = 1;
        tileWidth = width;
        tileHeight = height;
    }

    public function setColumns(columns:Int=1):Void {        
        if(columns == 0) {
            columns = 1;
        }
        this.columns = columns;
        width = tileWidth * columns;
    }
    
    public function setRows(rows:Int=1):Void {
        if(rows == 0) {
            rows = 1;
        }
        this.rows = rows;
        height = tileHeight * rows;
    }

    public function setWidth(width:Float):Void {
        setColumns(Math.floor((width/Application.SCALE)/tileWidth));
    }

    public function setHeight(height:Float):Void {
        setRows(Math.floor((height/Application.SCALE)/tileHeight));
    }

    override public function render():Void {
        var startX:Float = getLeftX();
        var startY:Float = getTopY();
        for(i in 0...columns) {
            for(j in 0...rows) {
                spriteSheetLayer.renderSprite(
                    startX + (i + .5) * tileWidth *  Application.SCALE,
                    startY + (j + .5) * tileHeight *  Application.SCALE,
                    tileWidth, tileHeight,
                    spriteSheetIndex,
                    scaleX * Application.SCALE, scaleY * Application.SCALE,
                    rotation, alpha,
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