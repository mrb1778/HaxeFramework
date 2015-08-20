package com.nachofries.framework.spritesheet;
import com.nachofries.framework.util.Application;
import com.nachofries.framework.behavior.Behavior;
import com.nachofries.framework.util.Displayable;

/**
 * ...
 * @author Michael R. Bernstein
 */

class AbstractSpriteSheetSprite implements Displayable {
    public var spriteSheetLayer:SpriteSheetLayer;
    public var spriteSheetIndex:Int;
    public var entry:SpriteSheetEntry;

    public var behavior:Behavior;

    private var x:Float = 0;
    private var y:Float = 0;
    private var width:Float = 0;
    private var height:Float = 0;

    private var scaleX:Float = 1;
    private var scaleY:Float = 1;

    private var red:Float = 1;
    private var green:Float = 1;
    private var blue:Float = 1;

    private var flipX:Bool = false;
    private var flipY:Bool = false;

    private var alpha:Float = 1;
    private var visible:Bool = true;

    private var rotation:Float = 0;

    private function new() {
    }
    public function init(?image:String):Void {
        if(image != null) {
            entry = SpriteSheetManager.getSpriteSheetEntry(image);
            #if debug
            if(entry == null) {
                trace("null sprite sheet sprite: " + image);
            }
            #end
            spriteSheetIndex = entry.index;
            width = entry.bounds.width;
            height = entry.bounds.height;
        }
        name = image;
    }

    public var name:String;
    public function start():Void {}
    public function update():Void {
        if(behavior != null) {
            behavior.update();
        }
    }
    public function render():Void {
        if(spriteSheetLayer != null) {
            spriteSheetLayer.renderSprite(
                x, y,
                width, height,
                spriteSheetIndex,
                scaleX * Application.SCALE, scaleY * Application.SCALE,
                rotation, alpha,
                red, green, blue,
                flipX, flipY
            );
        }
    }

    public function setMode(?mode:String, persist:Bool = true):Void { }
    public function getMode():String { return null; }
    public function isPrimaryMode():Bool { return true;  }
    public function hasMode(mode:String):Bool { return false;  }

    public function stop():Void {}
    public function resetDisplay():Void {}
    public function resetLocation():Void {
        x = 0;
        y = 0;
    }

    public function getLeftX():Float { return x - width * .5 * Application.SCALE; }
    public function setLeftX(x:Float):Void { this.x = x + width * .5 * Application.SCALE; }

    public function getCenterX():Float { return x; }
    public function setCenterX(x:Float):Void { this.x = x; }

    public function getRightX():Float { return x + width * .5 * Application.SCALE; }
    public function setRightX(x:Float):Void { this.x = x - width * .5 * Application.SCALE; }

    public function getTopY():Float { return y - height * .5 * Application.SCALE; }
    public function setTopY(y:Float):Void { this.y = y + height * .5 * Application.SCALE; }

    public function getCenterY():Float { return y; }
    public function setCenterY(y:Float):Void { this.y = y; }

    public function getBottomY():Float { return y + height * .5 * Application.SCALE; }
    public function setBottomY(y:Float):Void { this.y = y - height * .5 * Application.SCALE; }

    public function getWidth():Float { return width * scaleX * Application.SCALE; }
    public function getHeight():Float { return height * scaleY * Application.SCALE; }

    public function getAlpha():Float { return alpha; }
    public function setAlpha(value:Float):Void {
        this.alpha = value;
    }

    public function setRed(value:Float):Void { this.red = value; }
    public function getRed():Float { return red; }
    public function setGreen(value:Float):Void { this.green = value; }
    public function getGreen():Float { return green; }
    public function setBlue(value:Float):Void { this.blue = value; }
    public function getBlue():Float { return blue; }

    public function setFlipX(?value:Bool):Void {
        if(value == null) {
            flipX = !flipX;
        } else {
            flipX = value;
        }
    }
    public function getFlipX():Bool { return flipX; }

    public function setFlipY(?value:Bool):Void {
        if(value == null) {
            flipY = !flipY;
        } else {
            flipY = value;
        }
    }
    public function getFlipY():Bool { return flipY; }

    public function getVisible():Bool { return visible; }
    public function setVisible(value:Bool):Void {this.visible = value; }

    public function setRotation(value:Float):Void { this.rotation = value; }
    public function getRotation():Float { return rotation; }

    public function getScale():Float { return scaleX; }
    public function setScale(scale:Float):Void {
        setScaleX(scale);
        setScaleY(scale);
    }

    public function getScaleX():Float { return scaleX; }
    public function setScaleX(scale:Float):Void {
        this.scaleX = scale;
    }

    public function getScaleY():Float { return scaleY; }
    public function setScaleY(scale:Float):Void {
        this.scaleY = scale;
    }

    public function setMemo(value:String):Void { this.name = value; }
    public function getName():String { return name; }


    public function setBehavior(behavior:Behavior):Void {
        if(this.behavior != null) {
            this.behavior.destroy();
        }
        this.behavior = behavior;
        if(behavior != null) {
            behavior.setTarget(this);
        }
    }
    public function getBehavior():Behavior {return behavior; }

    public function destroy():Void {
        setLayer(null);
        spriteSheetIndex = 0;
        entry = null;

        setBehavior(null);

        x = 0;
        y = 0;
        width = 0;
        height = 0;

        setScale(1);

        red = 1;
        green = 1;
        blue = 1;

        flipX = false;
        flipY = false;
        alpha = 1;
        visible = true;
        rotation = 0;
    }

    public function getLayer():SpriteSheetLayer return spriteSheetLayer;

    public function setLayer(spriteSheetLayer:SpriteSheetLayer) {
        if(this.spriteSheetLayer != null) {
            this.spriteSheetLayer.removeSprite(this);
        }
        this.spriteSheetLayer = spriteSheetLayer;
    }

    public function getSpriteSheetEntry():SpriteSheetEntry {
        return SpriteSheetManager.getSpriteSheetEntry(name);
    }
}