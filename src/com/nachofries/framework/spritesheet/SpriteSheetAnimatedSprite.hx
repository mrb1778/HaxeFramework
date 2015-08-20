package com.nachofries.framework.spritesheet;


/**
 * ...
 * @author Michael R. Bernstein
 */


import com.nachofries.framework.util.ClassInfo;
import com.nachofries.framework.util.Pooling;

@final
class SpriteSheetAnimatedSprite extends AbstractSpriteSheetSprite {
    static inline var DEFAULT_ANIMATION_RATE:Int = 15;
    static inline var ANIMATION_NAME_PRIMARY:String = "primary";

    var animations:Map<String, Array<Int>>;
    var animationRates:Map<String, Array<Int>>;

    var currentAnimationName:String;
    var currentAnimation:Array<Int>;
    var currentAnimationRates:Array<Int>;

    public var animationRate:Int;

    public var loopCurrentAnimation:Bool;
    public var reverseAnimation:Bool;
    public var removeAfterAnimate:Bool;

    var currentIndex:Int;
    var currentFrameDuration:Int;

    var primaryMode:Bool;

    public var shouldRecycle:Bool;

    private function new() {
        super();
        shouldRecycle = true;
    }
    public function initAnimation(primaryAnimationName:String, primaryNumFrames:Int, ?primaryAnimationRates:Array<Int>, ?primaryFrameNumbers:Array<Int>, ?removeAfterAnimate:Bool, ?reverseAnimation:Bool, animationRate:Int=DEFAULT_ANIMATION_RATE):Void {
        super.init(primaryAnimationName + "0");
        animations = new Map<String, Array<Int>>();
        animationRates = new Map<String, Array<Int>>();

        currentAnimationName = null;
        currentAnimation = null;
        currentAnimationRates = null;

        this.animationRate = animationRate;

        loopCurrentAnimation = false;
        this.removeAfterAnimate = removeAfterAnimate;
        this.reverseAnimation = reverseAnimation;

        currentIndex = 0;
        currentFrameDuration = 0;

        primaryMode = true;

        addAnimation(ANIMATION_NAME_PRIMARY, primaryAnimationName, primaryNumFrames, primaryAnimationRates, primaryFrameNumbers);
    }

   public static inline function createFromJson(json:Dynamic):SpriteSheetAnimatedSprite {
       var animatedSprite:SpriteSheetAnimatedSprite = create(json.image, json.numFrames, json.frameRates, false, json.reverseAnimation);
       if(json.randomAnimation == true) {
           animatedSprite.currentFrameDuration = Math.round(Math.random() * animatedSprite.getCurrentAnimationRate());
       }
       if (json.animations != null) {
           var animations:Array<Dynamic> = json.animations;
           for (animation in animations) {
               animatedSprite.addAnimation(animation.name, animation.image, animation.numFrames, animation.frameRates);
           }
       }
       return animatedSprite;
   }
   public static inline function create(primaryAnimationName:String, primaryNumFrames:Int, ?primaryAnimationRates:Array<Int>, ?primaryFrameNumbers:Array<Int>, ?removeAfterAnimate:Bool, ?reverseAnimation:Bool, animationRate:Int=DEFAULT_ANIMATION_RATE):SpriteSheetAnimatedSprite {
        var sprite:SpriteSheetAnimatedSprite = Pooling.get(ClassInfo.getClassName());
        if(sprite == null) {
            sprite = new SpriteSheetAnimatedSprite();
        }
        sprite.initAnimation(primaryAnimationName, primaryNumFrames, primaryAnimationRates, primaryFrameNumbers, removeAfterAnimate, reverseAnimation, animationRate);
        return sprite;
    }
    private inline function getCurrentAnimationRate():Int {
        if (currentAnimationRates != null) {
            return currentAnimationRates[currentIndex];
        } else {
            return animationRate;
        }
    }

    override public function update():Void  {
        super.update();

        if (currentFrameDuration++ > getCurrentAnimationRate()) {
            currentFrameDuration = 0;

            //currentAnimation[currentIndex].visible = false;
            currentIndex++;

            if (currentIndex >= currentAnimation.length) {
                currentIndex = 0;
                if (removeAfterAnimate) {
                    destroy();
                    return;
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
            spriteSheetIndex = currentAnimation[currentIndex];
        }
    }
    public inline function addAnimation(name:String, imageName:String, num:Int, ?rates:Array<Int>, ?frameNumbers:Array<Int>):Void {
        var animation:Array<Int> = SpriteSheetManager.getSpriteSheetEntries(imageName, num, frameNumbers);
        var firstAnimation:Bool = Lambda.empty(animations);
        animations.set(name, animation);
        if (rates != null) {
            animationRates.set(name, rates);
        }
        if (firstAnimation) {
            setAnimation(name);
        }
    }
    public inline function setAnimation(?name:String, loop:Bool = true):Void {
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
            spriteSheetIndex = currentAnimation[currentIndex];
            currentAnimationRates = animationRates.get(name);
            loopCurrentAnimation = loop;
        }
    }

    override public function destroy():Void {
        super.destroy();
        if(shouldRecycle) {
            if(behavior != null) {
                behavior.destroy();
                behavior = null;
            }
            Pooling.recycle(this);
        }
    }


    override public function setMode(?mode:String, persist:Bool = true):Void { setAnimation(mode, persist); }
    override public function getMode():String { return currentAnimationName; }
    override public function hasMode(mode:String):Bool { return animations.exists(mode); }
    override public function isPrimaryMode():Bool { return primaryMode;  }
}