/**
 * Created by IntelliJ IDEA.
 * User: tmshv
 * Date: 3/27/12
 * Time: 1:42 PM
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.view {
import com.bit101.components.Text;

import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

public class Bit101Text extends Text {
    public function Bit101Text(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, text:String = "") {
        super(parent, xpos, ypos, text);
    }

    override protected function addChildren():void {
        super.addChildren();
        super._panel.shadow = false;

        super._tf.autoSize = TextFieldAutoSize.LEFT;
        super._tf.wordWrap = false;
        super._tf.multiline = false;
        super._tf.addEventListener(Event.CHANGE, handleTextChange);
    }

    private function handleTextChange(event:Event):void {
        super.setSize(super._tf.width + 4, super._tf.height + 4);
    }
}
}
