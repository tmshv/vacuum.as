/**
 * Created by IntelliJ IDEA.
 * User: tmshv
 * Date: 3/16/12
 * Time: 4:10 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.commands {
import caurina.transitions.Tweener;

import flash.display.DisplayObject;

import flash.display.DisplayObject;

import ru.gotoandstop.command.ICommand;

public class ShakeCommand implements ICommand {
    private var object:DisplayObject;
    private var power:Number;
    private var time:Number;

    private var _startX:Number;
    private var _startY:Number;
    private var _startScaleX:Number;
    private var _startScaleY:Number;

    public function ShakeCommand(object:DisplayObject, power:Number, time:Number) {
        this.object = object;
        this.power = power;
        this.time = time;
    }

    public function execute():void {
        _startScaleX = object.scaleX;
        _startScaleY = object.scaleY;
        _startX = object.x;
        _startY = object.y;

        var w:uint = object.width;
        var nw:uint = w * power;
        var h:uint = object.height;
        var nh:uint = h * power;
        var x:int = object.x - (nw - w) / 2;
        var y:int = object.y - (nh - h) / 2;
        animate(x, y, power, power, shakeComplete);
    }

    private function animate(x:Number, y:Number, scaleX:Number, scaleY:Number, complete:Function = null):void {
        Tweener.removeTweens(object);
        Tweener.addTween(object, {time:time, scaleX:scaleX, scaleY:scaleY, x:x, y:y, transition:'easeOutElastic', onComplete:complete});
    }

    private function shakeComplete():void {
        animate(_startX, _startY, _startScaleX, _startScaleY);
    }
}
}
