package com.nachofries.framework.spritesheet;

import com.nachofries.framework.util.Placement;
import com.nachofries.framework.util.Placement.Offset;
import com.nachofries.framework.util.ClassInfo;
import com.nachofries.framework.util.Pooling;
import com.nachofries.framework.spritesheet.SpriteSheetSprite;

/**
 * ...
 * @author Michael R. Bernstein
 */

class SpriteSheetLayeredSprite extends SpriteSheetSprite {
    private var primarySprite:SpriteSheetSprite;
    private var layers:Array<SpriteSheetSpriteOffset> = [];

    public static inline function create(?layerSprites:Array<SpriteSheetSprite>):SpriteSheetLayeredSprite {
        var sprite:SpriteSheetLayeredSprite = Pooling.get(ClassInfo.getClassName());

        if(sprite == null) {
            sprite = new SpriteSheetLayeredSprite();
        }

        if(layerSprites != null) {
            for (layerSprite in layerSprites) {
                sprite.addLayeredSprite(layerSprite);
            }
        }
        sprite.init();
        return sprite;
    }

    public function setLayers(sprites:Array<SpriteSheetSpriteOffset>):Void {
        this.layers = sprites;
    }

    public function getLayers():Array<SpriteSheetSpriteOffset> {
        return layers;
    }

    public function setPrimarySprite(sprite:SpriteSheetSprite):Void {
        primarySprite = sprite;
    }

    public inline function getPrimarySprite():SpriteSheetSprite {
        return primarySprite;
    }

    public function addLayeredSprite(sprite:SpriteSheetSprite, offsetX:Float=0, offsetY:Float=0):Void {
        sprite.setScale(primarySprite.getScale());
        layers.push({sprite: sprite, offsetX: offsetX, offsetY: offsetY});
    }

    public function getLayeredSprite(index:Int):SpriteSheetSprite {
        return layers[index].sprite;
    }

    private function syncLayers():Void {
        for(layer in layers) {
            Placement.alignCentersWithRotation(primarySprite, layer.sprite, layer.offsetX, layer.offsetY);
        }
    }

    override public function init(?image:String):Void {
        super.init(image);
        //todo: ???
    }

    override public function render():Void {
        primarySprite.render();
        for(layer in layers) {
            layer.sprite.render();
        }
    }

    override public inline function start():Void {
        super.start();
        primarySprite.start();
        for(layer in layers) {
            layer.sprite.start();
        }
    }

    override public function update():Void {
        super.update();
        primarySprite.update();
        for(layer in layers) {
            layer.sprite.update();
        }
    }

    override public function hasMode(mode:String):Bool {
        if(primarySprite.hasMode(mode)) {
            return true;
        }
        for(layer in layers) {
            if(layer.sprite.hasMode(mode)) {
                return true;
            }
        }
        return super.hasMode(mode);
    }
    override public function setMode(?mode:String, persist:Bool = true):Void {
        super.setMode(mode, persist);
        primarySprite.setMode(mode, persist);
        for(layer in layers) {
            layer.sprite.setMode(mode, persist);
        }
    }

    override public function getMode():String {
        return primarySprite.getMode();
    }

    override public function isPrimaryMode():Bool {
        return primarySprite.isPrimaryMode();
    }

    override public inline function stop():Void {
        super.stop();
        primarySprite.stop();
        for(layer in layers) {
            layer.sprite.stop();
        }
    }

    override public inline function resetDisplay():Void {
        super.resetDisplay();
        primarySprite.resetDisplay();
        for(layer in layers) {
            layer.sprite.resetDisplay();
        }
    }

    override public inline function resetLocation():Void {
        super.resetLocation();
        primarySprite.resetLocation();
        for(layer in layers) {
            layer.sprite.resetLocation();
        }
    }

    override public function getLeftX():Float {
        return primarySprite.getLeftX();
    }

    override public function setLeftX(x:Float):Void {
        super.setLeftX(x);
        primarySprite.setLeftX(x);
        syncLayers();
    }

    override public function getCenterX():Float {
        return primarySprite.getCenterX();
    }

    override public function setCenterX(x:Float):Void {
        super.setCenterX(x);
        primarySprite.setCenterX(x);
        syncLayers();
    }

    override public function getRightX():Float {
        return primarySprite.getRightX();
    }

    override public function setRightX(x:Float):Void {
        super.setCenterX(x);
        primarySprite.setCenterX(x);
        syncLayers();
    }

    override public function getTopY():Float {
        return primarySprite.getTopY();
    }

    override public function setTopY(y:Float):Void {
        super.setTopY(y);
        primarySprite.setTopY(y);
        syncLayers();
    }

    override public function getCenterY():Float {
        return primarySprite.getCenterY();
    }

    override public function setCenterY(y:Float):Void {
        super.setCenterY(y);
        primarySprite.setCenterY(y);
        syncLayers();        
    }

    override public function getBottomY():Float {
        return primarySprite.getBottomY();
    }

    override public function setBottomY(y:Float):Void {
        super.setBottomY(y);
        primarySprite.setBottomY(y);
        syncLayers();
    }

    override public inline function getWidth():Float {
        return primarySprite.getWidth();
    }

    override public inline function getHeight():Float {
        return primarySprite.getHeight();
    }

    override public inline function getAlpha():Float {
        return primarySprite.getAlpha();
    }

    override public inline function setAlpha(value:Float):Void {
        super.setAlpha(value);
        primarySprite.setAlpha(value);        
        for(layer in layers) {
            layer.sprite.setAlpha(value);
        }
    }

    override public inline function setRed(value:Float):Void {
        super.setRed(value);
        primarySprite.setRed(value);
        for(layer in layers) {
            layer.sprite.setRed(value);
        }
    }

    override public inline function getRed():Float {
        return primarySprite.getRed();
    }

    override public inline function setGreen(value:Float):Void {
        super.setGreen(value);
        primarySprite.setGreen(value);
        for(layer in layers) {
            layer.sprite.setGreen(value);
        }
    }

    override public inline function getGreen():Float {
        return primarySprite.getGreen();
    }

    override public inline function setBlue(value:Float):Void {
        super.setBlue(value);
        primarySprite.setBlue(value);
        for(layer in layers) {
            layer.sprite.setBlue(value);
        }
    }

    override public inline function getBlue():Float {
        return primarySprite.getBlue();
    }

    override public function setFlipX(?value:Bool):Void {
        super.setFlipX(value);
        primarySprite.setFlipX(value);        
        for(layer in layers) {
            layer.sprite.setFlipX(value);
        }
    }

    override public function getFlipX():Bool {
        return primarySprite.getFlipX();
    }

    override public function setFlipY(?value:Bool):Void {
        super.setFlipY(value);
        primarySprite.setFlipY(value);
        for(layer in layers) {
            layer.sprite.setFlipY(value);
        }
    }

    override public function getFlipY():Bool {
        return primarySprite.getFlipY();
    }

    override public inline function getVisible():Bool {
        if(primarySprite == null) {
            #if debug
            trace("Primary Sprite null..." + this);
            #end
            return false;
        }
        return primarySprite.getVisible();
    }

    override public inline function setVisible(value:Bool):Void {
        super.setVisible(value);
        primarySprite.setVisible(value);
        for(layer in layers) {
            layer.sprite.setVisible(value);
        }
    }

    override public inline function setRotation(value:Float):Void {
        super.setRotation(value);
        primarySprite.setRotation(value);
        syncLayers();
    }

    override public inline function getRotation():Float {
        return primarySprite.getRotation();
    }

    override public function getScale():Float {
        return primarySprite.getScale();
    }

    override public function setScale(scale:Float):Void {
        super.setScale(scale);
        primarySprite.setScale(scale);
        syncLayers();
    }

    override public function getScaleX():Float {
        return primarySprite.getScaleX();
    }

    override public function setScaleX(scale:Float):Void {
        super.setScaleX(scale);
        primarySprite.setScaleX(scale);
        syncLayers();
    }

    override public function getScaleY():Float {
        return primarySprite.getScaleY();
    }

    override public function setScaleY(scale:Float):Void {
        super.setScaleY(scale);
        primarySprite.setScaleY(scale);        
        syncLayers();        
    }

    override public inline function setMemo(value:String):Void {
        super.setMemo(value);
        primarySprite.setMemo(value);
        for(layer in layers) {
            layer.sprite.setMemo(value);
        }
    }

    override public inline function getName():String {
        return primarySprite.getName();
    }

    override public function setLayer(spriteSheetLayer:SpriteSheetLayer) {
        super.setLayer(spriteSheetLayer);
        primarySprite.setLayer(spriteSheetLayer);        
        for(layer in layers) {
            layer.sprite.setLayer(spriteSheetLayer);
        }
    }

    override public function destroy():Void {
        super.destroy();
        primarySprite.destroy();
        for(layer in layers) {
            layer.sprite.destroy();
        }
        layers.splice(0, layers.length);
        Pooling.recycle(this);
    }

    override public function getSpriteSheetEntry():SpriteSheetEntry {
        return primarySprite.getSpriteSheetEntry();
    }
}

typedef SpriteSheetSpriteOffset  = {
    > Offset,
    var sprite:SpriteSheetSprite;
}