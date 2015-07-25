package com.nachofries.framework.lifecycle;

/**
 * ...
 * @author Michael R. Bernstein
 */

interface LifeCycleController {
	public function changeState(newState:String, ?option:Dynamic):Void;
	public function goNext(?params:Dynamic):Void;
	public function goBack(?params:Dynamic):Void;
	public function restart(?params:Dynamic):Void;
}