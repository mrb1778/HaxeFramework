package com.nachofries.framework.lifecycle;
import com.nachofries.framework.util.Application;

/**
 * ...
 * @author Michael R. Bernstein
 */

class AnimatedSprite extends LifecycleSprite {
	private static inline var DEFAULT_ANIMATION_RATE:Int = 15;
	private static inline var ANIMATION_NAME_PRIMARY:String = "primary";

	private var animations:Map<String, Array<String>>;
	private var animationRates:Map<String, Array<Int>>;

    private var currentAnimationName:String;
    private var currentAnimation:Array<String>;
	private var currentAnimationRates:Array<Int>;
	private var animationRate:Int;
	
	private var loopCurrentAnimation:Bool;
	private var reverseAnimation:Bool;
	private var removeAfterAnimate:Bool;
	private var onAnimationFinished:Dynamic->Bool;

	private var currentIndex:Int;
	private var currentFrameDuration:Int;
    private var primaryMode:Bool;
    private var animationBitmap:LifecycleBitmap;

	
	public function new(?primaryAnimationName:String, ?primaryNumFrames:Int, ?primaryAnimationRates:Array<Int>, ?primaryFrameNumbers:Array<Int>, ?reverseAnimation:Bool) {
		super();
		animations = new Map<String, Array<String>>();
		animationRates = new Map<String, Array<Int>>();

        currentAnimationName = null;

        animationRate = DEFAULT_ANIMATION_RATE;

		this.reverseAnimation = reverseAnimation;
		currentIndex = 0;
		currentFrameDuration = 0;
		
		primaryMode = true;


        animationBitmap = new LifecycleBitmap();
        animationBitmap.scaleX = Application.SCALE;
        animationBitmap.scaleY = Application.SCALE;

        addChild(animationBitmap);

		if (primaryAnimationName != null) {
			addAnimation(ANIMATION_NAME_PRIMARY, primaryAnimationName, primaryNumFrames, primaryAnimationRates, primaryFrameNumbers);
		}

        name = primaryAnimationName;
	}	
	override public function update():Void  {
		super.update();
		
		var currentAnimationRate = animationRate;		
		if (currentAnimationRates != null) {
			currentAnimationRate = currentAnimationRates[currentIndex];
		}
        if (currentFrameDuration++ > currentAnimationRate) {
			currentFrameDuration = 0;
			
			//currentAnimation[currentIndex].visible = false;
			currentIndex++;
			
			if (currentIndex >= currentAnimation.length) {
				currentIndex = 0;
				if (removeAfterAnimate) {
					destroy();
				}
				if(onAnimationFinished != null) {
                    onAnimationFinished(this);
                }
				if (!primaryMode && !loopCurrentAnimation) {
					setAnimation();
				} else if (reverseAnimation) {
					currentAnimation.reverse();
					if (currentAnimationRates != null) {
						currentAnimationRates.reverse();
					}
				}
			}
            animationBitmap.loadBitmapData(currentAnimation[currentIndex]);
		}				
	}

	public static inline function loadBitmapDataArray(name:String, num:Int, ?frameNumbers:Array<Int>):Array<String> {
		var images:Array<String> = new Array<String>();
		for (i in 0...num) {
			var loadFrameNumber:Int = i;
			if(frameNumbers != null) {
				loadFrameNumber = frameNumbers[i];
			}
			var imageName = name + loadFrameNumber;
			images.push(imageName);
		}
		return images;
	}

	public function addAnimation(name:String, imageName:String, num:Int, ?rates:Array<Int>, ?frameNumbers:Array<Int>):Void {
		var animation:Array<String> = loadBitmapDataArray(imageName, num, frameNumbers);
		var firstAnimation:Bool = Lambda.empty(animations);
		animations.set(name, animation);
		if (rates != null) {
			animationRates.set(name, rates);
		}
		if (firstAnimation) {
			setAnimation(name);
		}
	}
	public function setAnimation(?name:String, loop:Bool = true):Void {
        if (name == null) {
            name = ANIMATION_NAME_PRIMARY;
        }

        if(animations.exists(name) && currentAnimationName != name) {
            if (name == ANIMATION_NAME_PRIMARY) {
                primaryMode = true;
            } else {
                primaryMode = false;
            }

            currentIndex = 0;
            currentFrameDuration = 0;

            currentAnimationName = name;
            currentAnimation = animations.get(name);
            animationBitmap.loadBitmapData(currentAnimation[currentIndex]);
            currentAnimationRates = animationRates.get(name);
            loopCurrentAnimation = loop;
        }
	}
	override public function setMode(?mode:String, persist:Bool = true):Void { setAnimation(mode, persist); }
    override public function getMode():String { return currentAnimationName; }
	override public function hasMode(mode:String):Bool { return animations.exists(mode); }
	override public function isPrimaryMode():Bool { return primaryMode;  }

    public function setOnAnimationFinished(onAnimationFinished:Dynamic->Bool):Void {
        this.onAnimationFinished = onAnimationFinished;
    }
}