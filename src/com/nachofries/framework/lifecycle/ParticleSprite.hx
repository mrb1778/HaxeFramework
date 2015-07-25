package com.nachofries.framework.lifecycle;

#if cpp
import com.nachofries.framework.util.Resources;
import asparticleengine.ASParticleSystem;

/**
 * ...
 * @author Michael R. Bernstein
 */

class ParticleSprite extends LifecycleSprite {
    public static inline var LOCATION_PARTICLES:String = Resources.ASSETS_LOCATION + "particles/";
    public static inline var EXTENSION_PARTICLES:String = ".plist";

    var	particleSystem:ASParticleSystem;
	
	public function new(name:String) {
		super();
        particleSystem = ASParticleSystem.particleWithFile(name + EXTENSION_PARTICLES, LOCATION_PARTICLES);
        addChild(particleSystem);
	}
    override public function update():Void {
        super.update();
        particleSystem.updateSystem();
    }
}
#else

class ParticleSprite extends LifecycleSprite {
    public function new(name:String) {
        super();
    }
}
#end