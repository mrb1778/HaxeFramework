package com.nachofries.framework.spritesheet;
import com.nachofries.framework.lifecycle.LifecycleSprite;

/**
 * ...
 * @author Michael R. Bernstein
 */

class SpriteSheetRenderer extends LifecycleSprite {
    private var data:Array<Float>;
    private var layers:Array<SpriteSheetLayer>;
    private var primaryLayer:Int = 0;

    private var currentIndex:Int = 0;

    public function new() {
        super();
        data = new Array<Float>();
        layers = new Array<SpriteSheetLayer>();
        layers.push(new SpriteSheetLayer(this));
    }

    public function addBackgroundLayer():SpriteSheetLayer {
        var layer = new SpriteSheetLayer(this);
        layers.unshift(layer);
        primaryLayer++;
        return layer;
    }
    public function addLayer():SpriteSheetLayer {
        var layer = new SpriteSheetLayer(this);
        layers.push(layer);
        return layer;
    }
    public function removeLayer(spriteSheetLayer:SpriteSheetLayer):Void {
        spriteSheetLayer.reset();
        layers.remove(spriteSheetLayer);
    }
    public function getPrimaryLayer():SpriteSheetLayer { return layers[primaryLayer]; }

    public function moveLayer(x:Float, y:Float, ?layer:Int):Void {
        if(layer == null) {
            layer = primaryLayer;
        }
        layers[layer].move(x, y);
    }

    public function addSprite(sprite:SpriteSheetSprite, ?layer:Int):Void {
        if(layer == null) {
            layer = primaryLayer;
        }
        layers[layer].addSprite(sprite);
    }

    public function removeSprite(sprite:SpriteSheetSprite, ?layer:Int):Void {
        if(layer == null) {
            layer = primaryLayer;
        }
        layers[layer].removeSprite(sprite);
    }

    private inline function render():Void {
        currentIndex = 0;
        for(layer in layers) {
            layer.render();
        }

        if(data.length > currentIndex) {
            if(data.length - currentIndex > 20 * SpriteSheetManager.DATA_LENGTH) {
                data.splice(currentIndex, data.length - currentIndex);
            } else {
                while (currentIndex < data.length) {
                    data[currentIndex + 2] = -2.0; // set invalid ID
                    currentIndex += SpriteSheetManager.DATA_LENGTH;
                }
            }
        }
        SpriteSheetManager.render(graphics, data);
    }

    override public function update():Void {
        super.update();
        render();
    }

    private inline function resetSprites():Void {
        trim();
        for(layer in layers) {
            layer.reset();
        }
    }

    public inline function trim():Void {
        data.splice(0, data.length);
    }

    override public function resetDisplay():Void {
        super.resetDisplay();
        resetSprites();
    }


    public inline function renderSprite(x:Float,
                                        y:Float,
                                        spriteSheetIndex:Int,
                                        scaleX:Float=1, scaleY:Float=1,
                                        rotation:Float=0,
                                        alpha:Float=1,
                                        red:Float=1, green:Float=1, blue:Float=1,
                                        flipX:Bool=false, flipY:Bool=false) {
            data[currentIndex] = x;
            data[currentIndex+1] = y;
            data[currentIndex+2] = spriteSheetIndex;
            data[currentIndex+3] = Math.cos(rotation) * scaleX * (flipX ? -1 : 1);
            data[currentIndex+4] = Math.sin(rotation) * scaleX;
            data[currentIndex+5] = -Math.sin(rotation) * scaleY;
            data[currentIndex+6] = Math.cos(rotation) * scaleY * (flipY ? -1 : 1);
            data[currentIndex+7] = red;
            data[currentIndex+8] = green;
            data[currentIndex+9] = blue;
            data[currentIndex+10] = alpha;

            currentIndex += SpriteSheetManager.DATA_LENGTH;
    }
}