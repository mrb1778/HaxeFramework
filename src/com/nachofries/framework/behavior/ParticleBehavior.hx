package com.nachofries.framework.behavior;
/**
 * ...
 * @author Michael R. Bernstein
 */
import com.nachofries.framework.util.NumberUtils;
import com.nachofries.framework.spritesheet.AbstractSpriteSheetSprite;
import com.nachofries.framework.util.Application;
import com.nachofries.framework.util.Displayable;
import com.nachofries.framework.util.ClassInfo;
import com.nachofries.framework.spritesheet.ParticleSystemSpriteSheetSprite;
import com.nachofries.framework.behavior.Behavior;

import com.nachofries.framework.util.Pooling;

@final
class ParticleBehavior extends Behavior {
    private var particleSystem:ParticleSystemSpriteSheetSprite;

    private var timeToLive:Int = -1;

    private var growthRate:Float = 0;
    private var rotationRate:Float = 0;
    private var alphaRate:Float = 0;
    private var velocityX:Float = 0;
    private var velocityY:Float = 0;
    private var gravity:Float = 0;
    private var accelerationX:Float = 0;
    private var accelerationY:Float = 0;

    var properties:Dynamic;


    public static inline function create(particleSystem:ParticleSystemSpriteSheetSprite, properties:Dynamic):ParticleBehavior {
        var item:ParticleBehavior = Pooling.get(ClassInfo.getClassName());
        if(item == null) {
            item = new ParticleBehavior();
        }
        item.particleSystem = particleSystem;
        item.setProperties(properties);
        return item;
    }
    private function new() {
        super();
    }

    private inline function setProperties(properties:Dynamic):Void {
        this.properties = properties;

        timeToLive = Std.int(NumberUtils.calcRandomVariance(properties.timeToLive, properties.timeToLiveVariance));
        growthRate = NumberUtils.calcRandomVariance(properties.growthRate, properties.growthRateVariance);
        alphaRate = NumberUtils.calcRandomVariance(properties.alphaRate, properties.alphaRateVariance);
        rotationRate = NumberUtils.calcRandomVariance(properties.rotationRate, properties.rotationRateVariance);
        velocityX = NumberUtils.calcRandomVariance(properties.velocityX, properties.velocityX) * Application.SCALE;
        velocityY = NumberUtils.calcRandomVariance(properties.velocityY, properties.velocityYVariance) * Application.SCALE;
        velocityX += NumberUtils.calcRandomVariance(properties.velocityOffsetX, properties.velocityOffsetXVariance) * Application.SCALE;
        velocityY += NumberUtils.calcRandomVariance(properties.velocityOffsetY, properties.velocityOffsetYVariance) * Application.SCALE;
        accelerationX = NumberUtils.calcRandomVariance(properties.accelerationX, properties.accelerationXVariance) * Application.SCALE;
        accelerationY = NumberUtils.calcRandomVariance(properties.accelerationY, properties.accelerationYVariance) * Application.SCALE;
        gravity = properties.gravity * Application.SCALE;

        if(properties.symmetricalVelocityX == true && Math.random() > .5) {
            velocityX *= -1;
        }
        if(properties.symmetricalVelocityY == true && Math.random() > .5) {
            velocityY *= -1;
        }
    }

    override public function setTarget(target:Displayable):Void {
        super.setTarget(target);
        if(properties != null) {
            if(properties.sourcePositionVarianceX != null) {
                target.setCenterX(NumberUtils.calcRandomVariance(target.getCenterX(), properties.sourcePositionVarianceX * Application.SCALE));
            }
            if(properties.sourcePositionVarianceY != null) {
                target.setCenterY(NumberUtils.calcRandomVariance(target.getCenterY(), properties.sourcePositionVarianceY * Application.SCALE));
            }
            if(properties.startColorRed != null) {
                target.setRed(NumberUtils.calcRandomVariance(properties.startColorRed, properties.startColorRedVariance));
            }
            if(properties.startColorGreen != null) {
                target.setGreen(NumberUtils.calcRandomVariance(properties.startColorGreen, properties.startColorGreenVariance));
            }
            if(properties.startColorBlue != null) {
                target.setBlue(NumberUtils.calcRandomVariance(properties.startColorBlue, properties.startColorBlueVariance));
            }
        }
    }


    override public function update():Void {
        super.update();

        if(--timeToLive == 0 || target.getAlpha() <= 0 || target.getScale() <= 0) {
            particleSystem.removeParticle(cast(target, AbstractSpriteSheetSprite));
        } else {
            target.setScale(target.getScale() + growthRate);
            target.setRotation(target.getRotation() + rotationRate);
            target.setAlpha(target.getAlpha() + alphaRate);

            target.setCenterX(target.getCenterX() + velocityX);
            target.setCenterY(target.getCenterY() + velocityY);
            
            velocityX += velocityX > 0 ? 1 : -1 * accelerationX;
            velocityY += velocityY > 0 ? 1 : -1 * accelerationY;

            velocityY += velocityY < 0 ? 1 : -1 * gravity;
        }
    }

    override public function destroy():Void {
        super.destroy();
        particleSystem = null;
        timeToLive = -1;

        growthRate = 0;
        rotationRate = 0;
        alphaRate = 0;
        velocityX = 0;
        velocityY = 0;
        gravity = 0;
        accelerationX = 0;
        accelerationY = 0;
        
        Pooling.recycle(this);
    }
}