package com.nachofries.framework.tween;

/**
 * ...
 * @author Michael R. Bernstein
 */

enum Easing {
	LINEAR;
	SINOIDAL;
	SINOIDAL_PERIOD(period:Float);
    COSIGN_PERIOD(period:Float);
	REVERSE;
	FLICKER;
	WOBBLE;
	PULSE(pulses:Int);
	SPRING;
	NONE;
	FULL;

    EASE_IN;
    EASE_OUT;
    EASE_IN_OUT;
    EASE_OUT_IN;
    EASE_IN_BACK;
    EASE_OUT_BACK;
    EASE_IN_OUT_BACK;
    EASE_OUT_IN_BACK;
    EASE_IN_ELASTIC;
    EASE_OUT_ELASTIC;
    EASE_IN_OUT_ELASTIC;
    EASE_OUT_IN_ELASTIC;
    EASE_IN_BOUNCE;
    EASE_OUT_BOUNCE;
    EASE_IN_OUT_BOUNCE;
    EASE_OUT_IN_BOUNCE;


    QUAD_IN;
    BOUNCE_IN;
    CIRCLE_IN_OUT;
    EXPO_IN_OUT;
    BOUNCE_OUT;
}