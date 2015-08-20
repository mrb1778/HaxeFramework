package com.nachofries.framework.spritesheet;

/**
 * ...
 * @author Michael R. Bernstein
 */

import com.nachofries.framework.util.Rectangle;
import com.nachofries.framework.util.Application;
class SpriteSheetLayer {
    public var renderer:SpriteSheetRenderer;

    public var sprites:List<AbstractSpriteSheetSprite>;
    public var syncedLayers:Array<SpriteSheetLayer>;
    private var offsetX:Float = 0;
    private var offsetY:Float = 0;

    private var trimSprites:Bool = true;

    public function new(?renderer:SpriteSheetRenderer) {
        this.renderer = renderer;
        sprites = new List<AbstractSpriteSheetSprite>();
    }
    public function setRenderer(renderer:SpriteSheetRenderer):Void {
        this.renderer = renderer;
    }
    public inline function move(x:Float, y:Float):Void {
        setOffset(offsetX + x, offsetY + y);
    }
    public inline function setOffset(x:Float, y:Float):Void {
        offsetX = x;
        offsetY = y;
        syncLayers();
    }
    public inline function getOffsetX():Float return offsetX;
    public inline function setOffsetX(x:Float):Void {
        setOffset(x, offsetY);
    }
    public inline function getOffsetY():Float return offsetY;
    public inline function setOffsetY(y:Float):Void {
        setOffset(offsetX, y);
    }
    public function setTrimSprites(trimSprites:Bool):Void {
        this.trimSprites = trimSprites;
    }
    public inline function syncOffsetWith(otherLayer:SpriteSheetLayer):Void {
        offsetX = otherLayer.offsetX;
        offsetY = otherLayer.offsetY;
    }
    public inline function addSprite(sprite:AbstractSpriteSheetSprite):Void {
        sprites.add(sprite);
        sprite.setLayer(this);
    }
    public function removeSprite(sprite:AbstractSpriteSheetSprite):Void {
        sprites.remove(sprite);
    }
    public function render():Void {
        for(sprite in sprites) {
            sprite.update();
            if(sprite.getVisible() && sprite.getAlpha() != 0) {
                sprite.render();
            }
        }
    }

    public function reset():Void {
        setOffset(0, 0);
        clear();
    }

    public function clear(trimSprites:Bool=false):Void {
        if(this.trimSprites || trimSprites) {
            for(sprite in sprites) {
                sprite.destroy();
            }
        }
    }

    public function removeSpritesIn(bounds:Rectangle):Void {
        //bounds.move(offsetX, offsetY); //todo: look into offset?
        for(sprite in sprites) {
            if(bounds.containsPositionable(sprite)) {
                sprite.destroy();
            }
        }
        //bounds.move(-offsetX, -offsetY);
    }


    public function addSyncedLayer(spriteSheetLayer:SpriteSheetLayer):Void {
        if(syncedLayers == null) {
            syncedLayers = new Array<SpriteSheetLayer>();
        }
        syncedLayers.push(spriteSheetLayer);
    }
    private inline function syncLayers():Void {
        if(syncedLayers != null) {
            for(syncedLayer in syncedLayers) {
                syncedLayer.syncOffsetWith(this);
            }
        }
    }

    private inline function shouldRender(x:Float, y:Float, widthRadius:Float, heightRadius:Float):Bool {
        //return true;
        if(x + widthRadius < -offsetX ||
           x - widthRadius > -offsetX + Application.SCREEN_WIDTH ||
           y + heightRadius < -offsetY ||
           y - heightRadius > -offsetY + Application.SCREEN_HEIGHT) {
            return false;
        } else {
            return true;
        }
    }

    public inline function renderSprite(
        x:Float,y:Float,
        width:Float, height:Float,
        spriteSheetIndex:Int,
        scaleX:Float=1, scaleY:Float=1,
        rotation:Float=0,
        alpha:Float=1,
        red:Float=1, green:Float=1, blue:Float=1,
        flipX:Bool=false, flipY:Bool=false) {
        if(shouldRender(x, y, width*.5, height*.5)) {
            renderer.renderSprite(
                x + offsetX, y + offsetY,
                spriteSheetIndex,
                scaleX, scaleY,
                rotation,
                alpha,
                red, green, blue,
                flipX, flipY);
        }
    }
}