package com.nachofries.framework.util;


import openfl.geom.Point;
class Placement {
    public static inline var IDENTIFIER_SELF = "self";

    public static inline function alignCenters(object1:Positionable, object2:Positionable, offsetX:Float = 0, offsetY:Float = 0):Void {
        alignCenterOf(object1, object2, offsetX);
        alignMiddleOf(object1, object2, offsetY);
    }

    public static inline function center(object:Positionable, offsetX:Float = 0, offsetY:Float = 0):Void {
        centerHorizontal(object, offsetX);
        centerVertical(object, offsetY);
    }
    public static inline function centerHorizontal(object:Positionable, offset:Float = 0, ?width:Float):Void {
        if(width == null) {
            width = Application.SCREEN_WIDTH;
        }
        object.setCenterX(width *.5 + offset);
    }
    public static inline function centerVertical(object:Positionable, offset:Float=0):Void {
        object.setCenterY(Application.SCREEN_HEIGHT * .5 + offset);
    }
    public static inline function alignTop(object:Positionable, offset:Float=0):Void {
        object.setTopY(offset);
    }
    public static inline function alignBottom(object:Positionable, offset:Float=0):Void {
        object.setBottomY(Application.SCREEN_HEIGHT - offset);
    }
    public static inline function alignLeft(object:Positionable, offset:Float = 0):Void {
        object.setLeftX(offset);
    }
    public static inline function alignRight(object:Positionable, offset:Float = 0):Void {
        object.setRightX(Application.SCREEN_WIDTH - offset);
    }
    public static inline function centerHorizontalIn(object1:Positionable, object2:Positionable, offset:Float=0):Void {
        object2.setCenterX(object1.getWidth()*.5 + offset);
    }
    public static inline function centerVerticalIn(object1:Positionable, object2:Positionable, offset:Float=0):Void {
        object2.setCenterY(object1.getHeight()*.5 + offset);
    }
    public static inline function centerIn(object1:Positionable, object2:Positionable, offsetX:Float=0, offsetY:Float=0):Void {
        centerHorizontalIn(object1, object2, offsetX);
        centerVerticalIn(object1, object2, offsetY);
    }
    public static inline function alignRightOf(object1:Positionable, object2:Positionable, offset:Float=0):Void {
        object2.setLeftX(object1.getRightX() + offset);
    }
    public static inline function alignCenterRightOf(object1:Positionable, object2:Positionable, offset:Float=0):Void {
        object2.setCenterX(object1.getRightX() + offset);
    }
    public static inline function alignLeftOf(object1:Positionable, object2:Positionable, offset:Float=0):Void {
        object2.setRightX(object1.getLeftX() - offset);
    }
    public static inline function alignBelow(object1:Positionable, object2:Positionable, offset:Float=0):Void {
        object2.setTopY(object1.getBottomY() + offset);
    }
    public static inline function alignChildBelow(object1:Positionable, object2:Positionable, offset:Float=0):Void {
        object2.setTopY(object1.getHeight() + offset);
    }
    public static inline function alignAbove(object1:Positionable, object2:Positionable, offset:Float=0):Void {
        object2.setBottomY(object1.getTopY() - offset);
    }
    public static inline function alignWithLeft(object1:Positionable, object2:Positionable, offset:Float=0):Void {
        object2.setLeftX(object1.getLeftX() + offset);
    }
    public static inline function alignWithRight(object1:Positionable, object2:Positionable, offset:Float=0):Void {
        object2.setRightX(object1.getRightX() - offset);
    }
    public static inline function alignWithTop(object1:Positionable, object2:Positionable, offset:Float=0):Void {
        object2.setTopY(object1.getTopY() + offset);
    }
    public static inline function alignWithBottom(object1:Positionable, object2:Positionable, offset:Float=0):Void {
        object2.setBottomY(object1.getBottomY() - offset);
    }
    public static inline function alignChildWithCenter(object1:Positionable, object2:Positionable, offset:Float=0):Void {
        object2.setCenterX(object1.getCenterX() + offset);
    }
    public static inline function alignChildWithTop(object:Positionable, offset:Float=0):Void {
        object.setTopY(offset);
    }
    public static inline function alignChildWithMiddle(object1:Positionable, object2:Positionable, offset:Float=0):Void {
        object2.setCenterY(object1.getHeight() *.5 + offset);
    }
    public static inline function alignChildWithBottom(object1:Positionable, object2:Positionable, offset:Float=0):Void {
        object2.setBottomY(object1.getHeight() - offset);
    }
    public static inline function alignCenterOf(object1:Positionable, object2:Positionable, offset:Float=0):Void {
        object2.setCenterX(object1.getCenterX() + offset);
    }
    public static inline function alignMiddleOf(object1:Positionable, object2:Positionable, offset:Float=0):Void {
        object2.setCenterY(object1.getCenterY() + offset);
    }

    public static inline function setLeftOfPoint(object:Positionable, x:Float = 0, offset:Float = 0):Void {
        object.setRightX(x - offset);
    }

    public static inline function setAbovePoint(object:Positionable, y:Float = 0, offset:Float = 0):Void {
        object.setBottomY(y - offset);
    }

    public static inline function alignVerticallyWith(object1:Positionable, object2:Positionable, offset:Float=0, alignBottom:Bool=false):Void {
        if(alignBottom) {
            object2.setBottomY(object1.getBottomY() - offset);
        } else {
            object2.setTopY(object1.getTopY() + offset);
        }
    }
    public static inline function alignHorizontallyWith(object1:Positionable, object2:Positionable, offset:Float=0, alignRight:Bool=false):Void {
        if(alignRight) {
            object2.setRightX(object1.getRightX() - offset);
        } else {
            object2.setLeftX(object1.getLeftX() + offset);
        }
    }

    public static inline function is(object1:Positionable, position:Position, object2:Positionable):Bool {
        return position == null ||
               (position == Position.ABOVE && Placement.isAbove(object1, object2)) ||
               (position == Position.BELOW && Placement.isBelow(object1, object2)) ||
               (position == Position.RIGHT && Placement.isRightOf(object1, object2)) ||
               (position == Position.LEFT && Placement.isLeftOf(object1, object2));
    }

    public static inline function move(object:Positionable, deltaX:Float, deltaY:Float):Void {
        moveHorizontal(object, deltaX);
        moveVertical(object, deltaY);
    }
    public static inline function moveHorizontal(object:Positionable, delta:Float):Void {
        object.setLeftX(object.getLeftX() + delta);
    }
    public static inline function moveVertical(object:Positionable, delta:Float):Void {
        object.setTopY(object.getTopY() + delta);
    }

    public static inline function rotate(object:Positionable, delta:Float):Void {
        object.setRotation(object.getRotation() + delta);
    }

    public static inline function isAbove(object1:Positionable, object2:Positionable):Bool {
        return object1.getBottomY() <= object2.getTopY();
    }

    public static inline function isAboveCenter(object1:Positionable, object2:Positionable):Bool {
        return object1.getCenterY() <= object2.getCenterY();
    }
    public static inline function isBottomAboveCenter(object1:Positionable, object2:Positionable):Bool {
        return object1.getBottomY() <= object2.getCenterY();
    }
    public static inline function isCenterAboveTop(object1:Positionable, object2:Positionable):Bool {
        return object1.getCenterY() <= object2.getTopY();
    }

    public static inline function isBelow(object1:Positionable, object2:Positionable):Bool {
        return object1.getTopY() >= object2.getBottomY();
    }

    public static inline function isLeftOf(object1:Positionable, object2:Positionable):Bool {
        return object1.getRightX() <= object2.getLeftX();
    }

    public static inline function isRightOf(object1:Positionable, object2:Positionable):Bool {
        return object1.getLeftX() >= object2.getRightX();
    }

    public static inline function placePosition(object1:Positionable, object2:Positionable, position:Position, offsetX:Float=0, offsetY:Float=0):Void {
        switch(position) {
            case ABOVE:
                alignAbove(object1, object2, offsetY);
            case ABOVE_LEFT:
                alignAbove(object1, object2, offsetY);
                alignLeftOf(object1, object2, offsetX);
            case ABOVE_WITH_LEFT:
                alignAbove(object1, object2, offsetY);
                alignWithLeft(object1, object2, offsetX);
            case ABOVE_CENTER:
                alignAbove(object1, object2, offsetY);
                alignCenterOf(object1, object2, offsetX);
            case ABOVE_RIGHT:
                alignAbove(object1, object2, offsetY);
                alignRightOf(object1, object2, offsetX);
            case ABOVE_WITH_RIGHT:
                alignAbove(object1, object2, offsetY);
                alignWithRight(object1, object2, offsetX);
            case TOP_LEFT:
                alignWithTop(object1, object2, offsetY);
                alignLeftOf(object1, object2, offsetX);
            case TOP_CENTER:
                alignWithTop(object1, object2, offsetY);
                alignCenterOf(object1, object2, offsetX);
            case TOP_RIGHT:
                alignWithTop(object1, object2, offsetY);
                alignRightOf(object1, object2, offsetX);
            case TOP_CENTER_RIGHT:
                alignWithTop(object1, object2, offsetY);
                alignCenterRightOf(object1, object2, offsetX);
            case TOP_MIDDLE_RIGHT_CENTER:
                object2.setCenterY(object1.getTopY() + offsetY);
                object2.setCenterX(object1.getRightX() + offsetY);
            case TOP_WITH_LEFT:
                alignWithTop(object1, object2, offsetY);
                alignWithLeft(object1, object2, offsetX);
            case TOP_WITH_RIGHT:
                alignWithTop(object1, object2, offsetY);
                alignWithRight(object1, object2, offsetX);
            case MIDDLE:
                alignMiddleOf(object1, object2, offsetY);
            case MIDDLE_LEFT:
                alignMiddleOf(object1, object2, offsetY);
                alignLeftOf(object1, object2, offsetX);
            case MIDDLE_WITH_LEFT:
                alignMiddleOf(object1, object2, offsetY);
                alignWithLeft(object1, object2, offsetX);
            case MIDDLE_CENTER:
                alignMiddleOf(object1, object2, offsetY);
                alignCenterOf(object1, object2, offsetX);
            case MIDDLE_RIGHT:
                alignMiddleOf(object1, object2, offsetY);
                alignRightOf(object1, object2, offsetX);
            case BELOW:
                alignBelow(object1, object2, offsetY);
            case BELOW_LEFT:
                alignBelow(object1, object2, offsetY);
                alignLeftOf(object1, object2, offsetX);
            case BELOW_WITH_LEFT:
                alignBelow(object1, object2, offsetY);
                alignWithLeft(object1, object2, offsetX);
            case BELOW_CENTER:
                alignBelow(object1, object2, offsetY);
                alignCenterOf(object1, object2, offsetX);
            case BELOW_RIGHT:
                alignBelow(object1, object2, offsetY);
                alignRightOf(object1, object2, offsetX);
            case BOTTOM:
                alignWithBottom(object1, object2, offsetY);
            case BOTTOM_WITH_LEFT:
                alignWithBottom(object1, object2, offsetY);
                alignWithLeft(object1, object2, offsetX);
            case BOTTOM_LEFT:
                alignWithBottom(object1, object2, offsetY);
                alignLeftOf(object1, object2, offsetX);
            case BOTTOM_CENTER:
                alignWithBottom(object1, object2, offsetY);
                alignCenterOf(object1, object2, offsetX);
            case BOTTOM_WITH_RIGHT:
                alignWithBottom(object1, object2, offsetY);
                alignWithRight(object1, object2, offsetX);
            case BOTTOM_RIGHT:
                alignWithBottom(object1, object2, offsetY);
                alignRightOf(object1, object2, offsetX);
            case WITH_LEFT:
                alignWithLeft(object1, object2, offsetX);
            case WITH_RIGHT:
                alignWithRight(object1, object2, offsetX);
            case WITH_BOTTOM:
                alignWithBottom(object1, object2, offsetY);
            case WITH_TOP:
                alignWithTop(object1, object2, offsetY);
            case LEFT:
                alignLeftOf(object1, object2, offsetX);
            case CENTER:
                alignCenterOf(object1, object2, offsetX);
            case RIGHT:
                alignRightOf(object1, object2, offsetX);
        }
    }

    public static inline function placePositionFromOffset(object1:Positionable, object2:Positionable, offset:PositionOffset):Void {
        placePosition(object1, object2, offset.position, offset.offsetX, offset.offsetY);
    }

    public static inline function placePositionFromJson(object1:Positionable, object2:Positionable, json:Dynamic):Void {
        placePosition(object1, object2, Type.createEnum(Position, json.position), json.offsetX, json.offsetY);
    }


    public static inline function placePositionWithRotation(object1:Positionable, object2:Positionable, position:Position, offsetX:Float=0, offsetY:Float=0):Void {
        //todo: rotate position
        placePosition(object1, object2, position);

        var locationX:Float = object2.getCenterX();
        var locationY:Float = object2.getCenterY();

        /*locationX -= object2.getCenterX();
        locationY -= object2.getCenterY();*/

        var rotation:Float = object1.getRotation();
        var cosRotation:Float = Math.cos(rotation);
        var sinRotation:Float = Math.sin(rotation);


        object2.setRotation(rotation);
        object2.setCenterX(locationX + offsetX*cosRotation - offsetY*sinRotation);
        object2.setCenterY(locationY + offsetX*sinRotation + offsetY*cosRotation);
    }
    public static inline function alignCentersWithRotation(object1:Positionable, object2:Positionable, offsetX:Float=0, offsetY:Float=0):Void {
        var locationX:Float = object1.getCenterX();
        var locationY:Float = object1.getCenterY();

        var rotation:Float = object1.getRotation();
        var cosRotation:Float = Math.cos(rotation);
        var sinRotation:Float = Math.sin(rotation);

        object2.setRotation(rotation);
        object2.setCenterX(locationX + offsetX*cosRotation - offsetY*sinRotation);
        object2.setCenterY(locationY + offsetX*sinRotation + offsetY*cosRotation);
    }

    public static function alignFromJson(target:Positionable, json:Dynamic, ?objectMap:PositionableMap, ?width:Float, ?height:Float, ?offsetPoint:Point) {
        if(width == null) {
            width = Application.SCREEN_WIDTH;
        }
        if(height == null) {
            height = Application.SCREEN_HEIGHT;
        }
        if(objectMap == null) {
            objectMap = new PositionableMap();
        }

        var relatedObject:Positionable;

        var offsetX:Float = json.offsetX;
        offsetX *= Application.SCALE;

        var offsetY:Float = json.offsetY;
        offsetY *= Application.SCALE;

        /*if(target.getBottomY() > height) {
            setAbovePoint(target, height);
        }*/

        if(objectMap.exists(IDENTIFIER_SELF)) {
            relatedObject = objectMap.get(IDENTIFIER_SELF);
            placePosition(relatedObject, target, Position.MIDDLE_CENTER, offsetX, offsetY);
        }

        if (json.position != null) {
            var position:Position = Type.createEnum(Position, json.position);
            relatedObject = objectMap.get(json.positionObject);
            #if debug
            if(relatedObject == null) {
                trace("Null related object: " + json.positionObject);
            }
            #end
            placePosition(relatedObject, target, position, offsetX, offsetY);
        }

        if (json.rightOf != null) {
            relatedObject = objectMap.get(json.rightOf);
            alignRightOf(relatedObject, target, offsetX);
            if (json.verticalAlign == true) {
                alignVerticallyWith(relatedObject, target, offsetY);
            }
        } else if (json.leftOf != null) {
            relatedObject = objectMap.get(json.leftOf);
            alignLeftOf(relatedObject, target, offsetX);
            if (json.verticalAlign == true) {
                alignVerticallyWith(relatedObject, target, offsetY);
            }
        } else if (json.centerOf != null) {
            relatedObject = objectMap.get(json.centerOf);
            alignCenterOf(relatedObject, target, offsetX);
            if (json.verticalAlign == true) {
                alignVerticallyWith(relatedObject, target, offsetY);
            }
        } else if (json.alignWithX != null) {
            relatedObject = objectMap.get(json.alignWithX);
            alignHorizontallyWith(relatedObject, target, offsetX);
        } else if (json.x != null) {
            target.setLeftX(json.x*Application.SCALE + (offsetPoint == null ? 0 : offsetPoint.x));
        } else if (json.rightX != null) {
            setLeftOfPoint(target, width - json.rightX*Application.SCALE);
        }

        if (json.above != null) {
            relatedObject = objectMap.get(json.above);
            alignAbove(relatedObject, target, offsetY);
            if (json.horizontalAlign == true) {
                alignHorizontallyWith(relatedObject, target, offsetX);
            }
        } else if (json.below != null) {
            relatedObject = objectMap.get(json.below);
            alignBelow(relatedObject, target, offsetY);
            if (json.horizontalAlign == true) {
                alignHorizontallyWith(relatedObject, target, offsetX);
            }
        } else if(json.alignVerticallyWith != null) {
            relatedObject = objectMap.get(json.alignVerticallyWith);
            alignVerticallyWith(relatedObject, target, offsetY);
            if (json.horizontalAlign == true) {
                alignHorizontallyWith(relatedObject, target, offsetX);
            }

        } else if(json.topY != null) {
            target.setTopY(json.topY * Application.SCALE + (offsetPoint == null ? 0 : offsetPoint.y));
        } else if (json.y != null) {
            //setAbovePoint(target, height, json.y*Application.SCALE);
            target.setBottomY(height - json.y*Application.SCALE - json.verticalOffset*Application.SCALE - (offsetPoint == null ? 0 : offsetPoint.y));
        }
    }
}

typedef Placeable = {
    ?positionObject:String,
    ?position:String,
    ?offsetX:Float,
    ?offsetY:Float
}

typedef Offset = {
    var offsetX:Float;
    var offsetY:Float;
}