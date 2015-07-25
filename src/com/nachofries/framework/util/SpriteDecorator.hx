package com.nachofries.framework.util;
import com.nachofries.framework.lifecycle.LifecycleSprite;
import com.nachofries.framework.lifecycle.LifecycleSpriteWatcher;
import com.nachofries.framework.sprite.SpriteCreator;

class SpriteDecorator {
    public static function decorate(parentSprite:LifecycleSpriteWatcher, graphics:Array<GraphicDefinition>, ?posisitionableMap:PositionableMap):Void {
        if(posisitionableMap == null) {
            posisitionableMap = new PositionableMap();
        }

        var i = 1;
        for (graphic in graphics) {
            if(graphic.image != null) {
                var numItems:Int = graphic.duplicates + 1;
                var graphicItem:GraphicDefinition = graphic;
                for (i in 0...numItems) {
                    if(i > 1 && graphic.duplicateProperties != null) {
                        graphicItem = JsonUtils.extend(graphic, graphic.duplicateProperties);
                    }

                    var sprite:LifecycleSprite = SpriteCreator.createLifecycleSpriteFromJson(graphicItem, false);
                    Placement.alignFromJson(sprite, graphicItem, posisitionableMap);
                    SpriteCreator.placementCallback(sprite, graphicItem);
                    parentSprite.addAndWatchSprite(sprite);
                    posisitionableMap.addPositionable(sprite, graphicItem, i);
                }
            } else {
                var placementRectangle:Rectangle = new Rectangle();
                placementRectangle.setLeftX(graphic.x*Application.SCALE);
                placementRectangle.setTopY(graphic.y*Application.SCALE);
                placementRectangle.setWidth(graphic.width == null || graphic.width == 0 ? Application.SCREEN_WIDTH : graphic.width*Application.SCALE);
                placementRectangle.setHeight(graphic.height == null || graphic.height == 0 ? Application.SCREEN_HEIGHT : graphic.height*Application.SCALE);
                Placement.alignFromJson(placementRectangle, graphic, posisitionableMap);

                Drawing.fillBox(
                    parentSprite.graphics,
                    graphic.fill,
                    placementRectangle.getLeftX(),
                    placementRectangle.getTopY(),
                    placementRectangle.getWidth(),
                    placementRectangle.getHeight());
                posisitionableMap.addPositionable(placementRectangle, graphic, i++);
            }
        }
    }
}


