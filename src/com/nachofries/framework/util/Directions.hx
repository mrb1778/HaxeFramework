package com.nachofries.framework.util;
import com.nachofries.framework.util.Pair;
import openfl.geom.Point;
class Directions {
    public static var standardDirections:Array<Direction> = [
        Direction.UP,
        Direction.RIGHT,
        Direction.DOWN,
        Direction.LEFT
    ];
    public static var verticalDirections:Array<Direction> = [
        Direction.UP,
        Direction.DOWN
    ];
    public static var horizontalDirections:Array<Direction> = [
        Direction.RIGHT,
        Direction.LEFT
    ];
    public static var diagnals:Array<Array<Direction>> = [
        [Direction.UP, Direction.RIGHT],
        [Direction.DOWN, Direction.RIGHT],
        [Direction.DOWN, Direction.LEFT],
        [Direction.UP, Direction.LEFT]
    ];


    public static inline function getDirectionFromPoints(startPoint:Point, endPoint:Point):Direction {
        var xDistance = Math.abs(endPoint.x - startPoint.x);
        var yDistance = Math.abs(endPoint.y - startPoint.y);

        if(xDistance > yDistance) {
            return getHorizontalDirectionFromPoints(startPoint, endPoint);
        } else {
            return getVerticalDirectionFromPoints(startPoint, endPoint);
        }
    }
    public static inline function getHorizontalDirectionFromPoints(startPoint:Point, endPoint:Point):Direction {
        return endPoint.x > startPoint.x ? Direction.RIGHT : Direction.LEFT;
    }
    public static inline function getVerticalDirectionFromPoints(startPoint:Point, endPoint:Point):Direction {
        return endPoint.y > startPoint.y ? Direction.DOWN : Direction.UP;
    }


    public static inline function getOpposite(direction:Direction):Direction {
        return switch(direction) {
            case UP: Direction.DOWN;
            case DOWN: Direction.UP;
            case RIGHT: Direction.LEFT;
            case LEFT: Direction.RIGHT;
        }
    }

    public static inline function getRightOf(direction:Direction):Direction {
        return switch(direction) {
            case UP: Direction.RIGHT;
            case RIGHT: Direction.DOWN;
            case DOWN: Direction.LEFT;
            case LEFT: Direction.UP;
        }
    }

    public static inline function getFromShortcut(shortcut:String):Direction {
        return switch(shortcut.toLowerCase()) {
            case 'u': Direction.UP;
            case 'r': Direction.RIGHT;
            case 'd': Direction.DOWN;
            case 'l': Direction.LEFT;
            default: Direction.DOWN;
        }
    }

    public static inline function getPerpendicular(direction:Direction):Pair<Direction> {
        if(direction == Direction.UP || direction == Direction.DOWN) {
            return new Pair(Direction.LEFT, Direction.RIGHT);
        } else {
            return new Pair(Direction.UP, Direction.DOWN);
        }
    }

    public static inline function getHorizontal(direction1:Direction, direction2:Direction):Direction {
        if(direction1 == Direction.LEFT || direction1 == Direction.RIGHT) {
            return direction1;
        } else {
            return direction2;
        }
    }

    public static inline function getVertical(direction1:Direction, direction2:Direction):Direction {
        if(direction1 == Direction.UP || direction1 == Direction.DOWN) {
            return direction1;
        } else {
            return direction2;
        }
    }


    public static function convertToSign(direction:Direction):Int {
        return switch(direction) {
            case UP:
                -1;
            case RIGHT:
                1;
            case DOWN:
                1;
            case LEFT:
                -1;
        }
    }
}