package com.nachofries.framework.screen;
import com.nachofries.framework.behavior.BehaviorUtil;
import com.nachofries.framework.behavior.Behavior;

import com.nachofries.framework.screen.LifecycleScreen;
import com.nachofries.framework.util.Drawing;
import com.nachofries.framework.util.Placement;
import com.nachofries.framework.util.Settings;
import com.nachofries.framework.lifecycle.LifeCycleManager;


/**
 * ...
 * @author Michael R. Bernstein 
 */
class ImageBehaviorScreen extends LifecycleScreen {
	public function new(name:String) {
        super(name);

        var logo = Drawing.loadImageSprite(Settings.getSetting(name + ".image", "screens/splash-logo"));
        Placement.center(logo);
        addAndWatchSprite(logo);

        behavior = BehaviorUtil.fadeOut(100);
        behavior.setOnCompleteCallback(aninmationFinished);
        logo.setBehavior(behavior);
	}

    function aninmationFinished(behavior:Behavior):Void {
        LifeCycleManager.goNext();
    }
}