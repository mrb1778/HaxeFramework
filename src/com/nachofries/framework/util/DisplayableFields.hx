package com.nachofries.framework.util;

/**
 * ...
 * @author Michael Bernstein
 */

import com.nachofries.framework.util.Application;
class DisplayableFields {
    public static function getYEquivalent(field:DisplayableField):DisplayableField {
        if(field == DisplayableField.X_LEFT) {
            return DisplayableField.Y_TOP;
        } else if(field == DisplayableField.X_CENTER) {
            return DisplayableField.Y_CENTER;
        } else if(field == DisplayableField.X_RIGHT) {
            return DisplayableField.Y_BOTTOM;
        }
        return null;
    }
    public static function getXEquivalent(field:DisplayableField):DisplayableField {
        if(field == DisplayableField.Y_TOP) {
            return DisplayableField.X_LEFT;
        } else if(field == DisplayableField.Y_CENTER) {
            return DisplayableField.X_CENTER;
        } else if(field == DisplayableField.Y_BOTTOM) {
            return DisplayableField.X_RIGHT;
        }
        return null;
    }

    public static function isX(field:DisplayableField):Bool {
        return
            field == DisplayableField.X_LEFT ||
            field == DisplayableField.X_CENTER ||
            field == DisplayableField.X_RIGHT;
    }

    public static function isY(field:DisplayableField):Bool {
        return
            field == DisplayableField.Y_TOP ||
            field == DisplayableField.Y_CENTER ||
            field == DisplayableField.Y_BOTTOM;
    }

    public static function getValue(target:Displayable, field:DisplayableField):Float {
        return switch(field) {
            case X_LEFT:
                target.getLeftX();
            case X_CENTER:
                target.getCenterX();
            case X_RIGHT:
                target.getRightX();
            case Y_TOP:
                target.getTopY();
            case Y_CENTER:
                target.getCenterY();
            case Y_BOTTOM:
                target.getBottomY();
            case ALPHA:
                target.getAlpha();
            case SCALE:
                target.getScale();
            case SCALE_X:
                target.getScaleX();
            case SCALE_Y:
                target.getScaleY();
            case ROTATION:
                target.getRotation();
        }
    }

    public static inline function setValue(target:Displayable, field:DisplayableField, value:Float):Void {
        switch(field) {
            case X_LEFT:
                target.setLeftX(value);
            case X_CENTER:
                target.setCenterX(value);
            case X_RIGHT:
                target.setRightX(value);
            case Y_TOP:
                target.setTopY(value);
            case Y_CENTER:
                target.setCenterY(value);
            case Y_BOTTOM:
                target.setBottomY(value);
            case ALPHA:
                target.setAlpha(value);
            case SCALE:
                target.setScale(value);
            case SCALE_X:
                target.setScaleX(value);
            case SCALE_Y:
                target.setScaleY(value);
            case ROTATION:
                target.setRotation(value);
        }
    }

    public static inline function moveValue(target:Displayable, field:DisplayableField, delta:Float):Float {
        var value:Float = getValue(target, field);
        var newValue:Float = value + delta;
        setValue(target, field, newValue);
        return newValue;
    }

    public static inline function scaleValue(target:Displayable, field:DisplayableField, value:Float):Float {
        return switch(field) {
            case X_LEFT:
                Application.SCALE * value;
            case X_CENTER:
                Application.SCALE * value;
            case X_RIGHT:
                Application.SCALE * value;
            case Y_TOP:
                Application.SCALE * value;
            case Y_CENTER:
                Application.SCALE * value;
            case Y_BOTTOM:
                Application.SCALE * value;
            case ALPHA:
                value;
            case SCALE:
                value;
            case SCALE_X:
                Application.SCALE * value;
            case SCALE_Y:
                Application.SCALE * value;
            case ROTATION:
                value;
        }
    }
}