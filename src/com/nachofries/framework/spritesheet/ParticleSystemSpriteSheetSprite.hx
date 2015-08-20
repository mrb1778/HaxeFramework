package com.nachofries.framework.spritesheet;
import com.nachofries.framework.util.ClassInfo;
import com.nachofries.framework.behavior.ParticleBehavior;
import com.nachofries.framework.sprite.SpriteSheetSpriteCreator;
import com.nachofries.framework.sprite.SpriteCreator;

import com.nachofries.framework.util.Placement;
import com.nachofries.framework.util.Pooling;

/**
 * ...
 * @author Michael R. Bernstein
 */

@final
class ParticleSystemSpriteSheetSprite extends AbstractSpriteSheetSprite {
    private var timeToLive:Int = -1;

    private var particleRate:Int;
    private var particleBurst:Int;
    private var startParticles:Int;
    private var nextParticleTimer:Int;
    private var maxParticles:Int;
    private var particles:List<AbstractSpriteSheetSprite> = new List<AbstractSpriteSheetSprite>();
    private var removeListener:ParticleSystemSpriteSheetSprite->Void;

    private var particleProperties:Dynamic;

    public static inline function createFromJson(json:Dynamic):ParticleSystemSpriteSheetSprite {
        var particleSystem:ParticleSystemSpriteSheetSprite = Pooling.get(ClassInfo.getClassName());
        if(particleSystem == null) {
            particleSystem = new ParticleSystemSpriteSheetSprite();
        }
        particleSystem.setProperties(json.system);
        particleSystem.particleProperties = json.particle;

        return particleSystem;
    }

    private function new() {
        super();
    }

    private inline function setProperties(properties:Dynamic):Void {

        if(properties.startParticles != null) {
            startParticles = properties.startParticles;
        }
        if(properties.particleBurst != null) {
            particleBurst = properties.particleBurst;
        }

        if(properties.timeToLive != null) {
            timeToLive = properties.timeToLive;
        }

        if(properties.particleRate != null) {
            particleRate = properties.particleRate;
            nextParticleTimer = particleRate;
        }

        init();
    }

    override public function setLayer(spriteSheetLayer:SpriteSheetLayer) {
        super.setLayer(spriteSheetLayer);
        if(spriteSheetLayer != null) {
            for(i in 0...startParticles) {
                createParticle();
            }
        }
    }

    public function setRemoveListener(removeListener:ParticleSystemSpriteSheetSprite->Void):Void {
        this.removeListener = removeListener;
    }

    override public function update():Void {
        super.update();
        if(timeToLive-- == 0) {
            if(removeListener != null) {
                removeListener(this);
            }
            destroy();
        } else {
            if(nextParticleTimer-- == 0) {
                nextParticleTimer = particleRate;
                for(i in 0...particleBurst) {
                    createParticle();
                }
            }
        }
    }

    private function createParticle():Void {
        var sprite:AbstractSpriteSheetSprite = SpriteSheetSpriteCreator.createFromJson(particleProperties);
        SpriteCreator.populateFromJson(sprite, particleProperties);
        Placement.alignCenters(this, sprite);
        var behavior:ParticleBehavior = ParticleBehavior.create(this, particleProperties);
        sprite.setBehavior(behavior);

        spriteSheetLayer.addSprite(sprite);
        particles.add(sprite);
    }

    public function removeParticle(particle:AbstractSpriteSheetSprite):Void {
        particles.remove(particle);
        particle.destroy();
    }

    override public function render():Void {}

    override public function destroy():Void {
        super.destroy();
        timeToLive = -1;

        particleRate = 0;
        particleBurst = 0;
        startParticles = 0;
        nextParticleTimer = 0;
        maxParticles = 0;
        for(particle in particles) {
            removeParticle(particle);
        }
        setRemoveListener(null);
        removeListener = null;

        particleProperties = null;
        Pooling.recycle(this);
    }
}