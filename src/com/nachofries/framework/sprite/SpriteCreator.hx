package com.nachofries.framework.sprite;


/**
 * ...
 * @author Michael R. Bernstein
 */


import com.nachofries.framework.behavior.RepeatFallBehavior;
import com.nachofries.framework.util.ArrayUtils;
import com.nachofries.framework.util.NumberUtils;
import com.nachofries.framework.util.Drawing;
import com.nachofries.framework.lifecycle.AnimatedSprite;
import com.nachofries.framework.behavior.BehaviorUtil;
import com.nachofries.framework.util.PositionableMap;
import com.nachofries.framework.util.Colorize;
import com.nachofries.framework.util.Positionable;
import com.nachofries.framework.util.SpriteAddable;
import com.nachofries.framework.spritesheet.ParticleSystemSpriteSheetSprite;
import com.nachofries.framework.util.Application;
import com.nachofries.framework.behavior.Behavior;

import com.nachofries.framework.util.Placement;
import com.nachofries.framework.spritesheet.SpriteSheetSprite;
import com.nachofries.framework.lifecycle.TextSprite;
import com.nachofries.framework.lifecycle.LifecycleSprite;
import com.nachofries.framework.util.Displayable;
import com.nachofries.framework.util.Rectangle;

class SpriteCreator {
    public static function canCreate(json:Dynamic):Bool {
        return json.type == "Image" || json.type == "RepeatFallImage" || json.type == "ParticleSystem"|| json.type == "FillImage" || json.type == "Message" || json.type == "FadeMessage";
    }

    public static function addFromJson(spriteAddable:SpriteAddable, json:Dynamic, objectMap:PositionableMap, levelWidth:Float, levelHeight:Float):Positionable {
        //var location:Rectangle = new Rectangle(json.x, json.y, 0, 0);
        //location.setScale(Application.SCALE);

        if(json.type == "Image") {
            var sprite:SpriteSheetSprite = SpriteSheetSpriteCreator.createFromJson(json);
            Placement.alignFromJson(sprite, json, objectMap, levelWidth, levelHeight, spriteAddable.getCreateLocation());
            spriteAddable.addSprite(sprite, json.foreground == true);
            placementCallback(sprite, json);
            return sprite;
        } else if(json.type == "FillImage") {
            var sprite = Drawing.createFilledSprite(json.background, json.width*Application.SCALE, json.height*Application.SCALE);
            Placement.alignFromJson(sprite, json, objectMap, levelWidth, levelHeight, spriteAddable.getCreateLocation());
            spriteAddable.addSprite(sprite, json.foreground == true);
            return sprite;
        } /*else if(json.type == "RepeatFallImage") {
            var sprite:SpriteSheetSprite = SpriteSheetSpriteCreator.createFromJson(json);
            var width:Float = json.width != null ? json.width * Application.SCALE : levelWidth;
            var height:Float = json.height != null ? json.height * Application.SCALE : levelHeight;

            if(json.scale != null) {
                sprite.setScale(json.scale * Application.SCALE);
            }

            sprite.setBehavior(RepeatFallBehavior.create(json.verticalSpeed, json.horizontalSpeed, 0, 0, width, height));
            //sprite.setLeftX(location.getLeftX());
            //sprite.setTopY(location.getTopY());
            spriteAddable.addSprite(sprite, json.foreground == true);
            location.setWidth(width);
            location.setHeight(height);
        } else if(json.type == "ParticleSystem") {
            var sprite = ParticleSystemSpriteSheetSprite.createFromJson(json);
            location.setWidth(sprite.getWidth());
            location.setHeight(sprite.getHeight());
            Placement.alignFromJson(location, json, objectMap, levelWidth, levelHeight);
            spriteAddable.addSprite(sprite, location.getLeftX(), location.getTopY(), json.foreground == true);
        } else if(json.type == "Message") {
            var sprite = new LifecycleSprite();
            if(json.image != null) {
                sprite.addChild(Drawing.loadImage(json.image));
            }
            var textField:TextSprite = new TextSprite(json.message, json.size==0?15:json.size, json.color);
            sprite.addChild(textField);
            spriteAddable.addSprite(sprite, location.getLeftX(), location.getTopY() - sprite.height, json.foreground == true);
            location.setWidth(sprite.width);
            location.setHeight(sprite.height);
        } else if(json.type == "FadeMessage") {
            var image = new FadeOutImage(null, json.delay);
            if(json.image != null) {
                image.addChild(Drawing.loadImageSprite(json.image));
            }
            var textField:TextSprite = new TextSprite(json.size==0?15:json.size);
            textField.text = json.message;
            image.addChild(textField);
            screen.addSprite(image, location.getLeftX(), location.getTopY() - image.height, json.foreground == true);
            location.setWidth(image.width);
            location.setHeight(image.height);
        }
        return location;*/
        return null;
    }

    public static inline function createLifecycleSpriteFromJson(json:Dynamic, placed:Bool=true):LifecycleSprite {
        var sprite:LifecycleSprite = null;
        if(json.image != null) {
            if (json.numFrames == null || json.numFrames < 2) {
                sprite = Drawing.loadImageSprite(json.image);
            } else {
                var frameRates:Array<Int> = json.frameRates;
                sprite = new AnimatedSprite(json.image, json.numFrames, frameRates, json.reverseAnimation == true);
            }
        } else if(json.randomImages != null) {
            var randomImages:Array<String> = json.randomImages;
            sprite = Drawing.loadImageSprite(ArrayUtils.pickRandom(randomImages));
        } else if(json.text != null) {
            sprite = new TextSprite(json.text, json.size, json.color, json.bold == true);
        }
        if(sprite != null) {
            SpriteCreator.populateFromJson(sprite, json, placed);
        }
        return sprite;
    }


    public static inline function populateFromJson(sprite:Displayable, json:Dynamic, placed:Bool=true):Void {
        if(json.scale != null) {
            sprite.setScale(json.scale);
        }
        if(json.color != null) {
            Colorize.setHexColor(sprite, Colorize.parseColor(json.color));
        }
        if(json.red != null) {
            sprite.setRed(json.red);
        }
        if(json.green != null) {
            sprite.setGreen(json.green);
        }
        if(json.blue != null) {
            sprite.setBlue(json.blue);
        }
        if(json.alpha != null) {
            sprite.setAlpha(json.alpha);
        }
        if(json.rotation != null) {
            sprite.setRotation(json.rotation);
        }
        if(json.flipX != null) {
            sprite.setFlipX(json.flipX);
        }
        if(json.flipY != null) {
            sprite.setFlipY(json.flipY);
        }
        if(placed) {
            sprite.setBehavior(BehaviorUtil.createFromJson(json.behavior));
        }
    }

    public static inline function placementCallback(sprite:Displayable, json:Dynamic):Void {
        sprite.setBehavior(BehaviorUtil.createFromJson(json.behavior));
    }
}