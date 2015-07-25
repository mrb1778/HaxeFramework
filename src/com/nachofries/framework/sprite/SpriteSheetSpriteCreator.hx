package com.nachofries.framework.sprite;


/**
 * ...
 * @author Michael R. Bernstein
 */


import com.nachofries.framework.util.Application;
import com.nachofries.framework.util.ArrayUtils;
import com.nachofries.framework.util.TemplateManager;
import com.nachofries.framework.sprite.SpriteCreator;
import com.nachofries.framework.spritesheet.TextSpriteSheetSprite;
import com.nachofries.framework.spritesheet.SpriteSheetLayeredSprite;

import com.nachofries.framework.spritesheet.SpriteSheetSprite;
import com.nachofries.framework.spritesheet.SpriteSheetAnimatedSprite;

class SpriteSheetSpriteCreator {
    public static inline function createFromJson(json:Dynamic, ignoreLayers:Bool=false):SpriteSheetSprite {
        var sprite:SpriteSheetSprite = null;
        if (!ignoreLayers && json.layers != null) {
            var layeredSprite:SpriteSheetLayeredSprite = SpriteSheetLayeredSprite.create();

            var baseSprite:SpriteSheetSprite = createFromJson(json, true);
            if(baseSprite != null) {
                layeredSprite.setPrimarySprite(baseSprite);
            }
            var layers:Array<Dynamic> = json.layers;
            for (layer in layers) {
                var layerSprite:SpriteSheetSprite = createFromJson(layer);
                if(layeredSprite.getPrimarySprite() == null) {
                    layeredSprite.setPrimarySprite(layerSprite);
                } else {
                    layeredSprite.addLayeredSprite(layerSprite, layer.offsetX*Application.SCALE, layer.offsetY*Application.SCALE);
                }
            }
            sprite = layeredSprite;
        } else if(json.image != null) {
            if (json.numFrames == null) {
                sprite = SpriteSheetSprite.create(json.image);
            } else {
                sprite = SpriteSheetAnimatedSprite.createFromJson(json);
            }
        } else if(json.randomImages != null) {
            var randomImages:Array<String> = json.randomImages;
            sprite = SpriteSheetSprite.create(ArrayUtils.pickRandom(randomImages));
        } else if(json.text != null) {
            sprite = TextSpriteSheetSprite.create(json.text, json.textStyle, json.modeRegEx);
        }
        if(sprite != null) {
            SpriteCreator.populateFromJson(sprite, json);
        }
        #if debug
        if(sprite == null) {
            trace("Sprite is null: " + json);
        }
        #end
        return sprite;
    }

    public static inline function createArrayFromTemplateArray(templates:Array<String>):Array<SpriteSheetSprite> {
        var sprites:Array<SpriteSheetSprite> = [];
        for (template in templates) {
            sprites.push(createFromJson(TemplateManager.getTemplate(template)));
        }
        return sprites;
    }
}