package com.nachofries.framework.util;

import openfl.geom.Point;
import openfl.events.MouseEvent;
import com.nachofries.framework.screen.LifecycleScreen;
class MouseDragHandler {
    private static inline var MIN_MOUSE_DRAG:Float = 5;
    
    private var screen:LifecycleScreen;
    private var mouseCheck:Void->Bool;
    private var mouseDownListener:Point->Void;
    private var mouseUpListener:Point->Point->Void;
    private var mouseMoveListener:Point->Point->Void;

    private var mouseDownPoint:Point;

    public function new(screen:LifecycleScreen, ?mouseUpListener:Point->Point->Void, ?mouseCheck:Void->Bool, ?mouseDownListener:Point->Void) {
        this.screen = screen;
        this.mouseUpListener = mouseUpListener;
        this.mouseCheck = mouseCheck;
        this.mouseDownListener = mouseDownListener;
    }
    public inline function setMouseUpListener(mouseUpListener:Point->Point->Void):Void {
        this.mouseUpListener = mouseUpListener;
    }
    public inline function setMouseDownListener(mouseDownListener:Point->Void):Void {
        this.mouseDownListener = mouseDownListener;
    }
    public inline function setMouseCheck(mouseCheck:Void->Bool):Void {
        this.mouseCheck = mouseCheck;
    }
    public inline function setMouseMoveListener(mouseMoveListener:Point->Point->Void):Void {
        this.mouseMoveListener = mouseMoveListener;
    }
    public function start():Void {
        screen.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        screen.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        screen.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    }
    public function stop():Void {
        screen.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        screen.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
        screen.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
    }

    private function onMouseDown(event:MouseEvent):Void {
        if(mouseCheck == null || mouseCheck()) {
            mouseDownPoint = screen.globalToLocal(new Point(event.stageX, event.stageY));
            if(mouseDownListener != null) {
                mouseDownListener(mouseDownPoint);
            }
        }
    }
    private function onMouseMove(event:MouseEvent):Void {
        if(mouseMoveListener != null) {
            var endPoint:Point = mouseDrag(event);
            if(endPoint != null) {
                mouseMoveListener(mouseDownPoint, endPoint);
            }
        }
    }
    private function onMouseUp(event:MouseEvent):Void {
        if(mouseUpListener != null) {
            var endPoint:Point = mouseDrag(event);
            if(endPoint != null) {
                mouseUpListener(mouseDownPoint, endPoint);
            }
        }
        mouseDownPoint = null;
    }

    private function mouseDrag(event:MouseEvent):Point {
        if(mouseDownPoint != null && (mouseCheck == null || mouseCheck())) {
            var endPoint = screen.globalToLocal(new Point(event.stageX, event.stageY));

            var xDistance = Math.abs(endPoint.x - mouseDownPoint.x);
            var yDistance = Math.abs(endPoint.y - mouseDownPoint.y);

            if(Math.max(xDistance, yDistance) > MIN_MOUSE_DRAG) {
                return endPoint;
            }
        }
        return null;
    }
}