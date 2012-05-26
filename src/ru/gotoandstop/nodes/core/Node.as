package ru.gotoandstop.nodes.core {
import by.blooddy.crypto.serialization.JSON;

import caurina.transitions.Tweener;

import com.bit101.components.Label;
import com.bit101.components.Panel;
import com.bit101.components.PushButton;
import com.bit101.components.Text;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import ru.gotoandstop.command.ICommand;
import ru.gotoandstop.math.Calculate;
import ru.gotoandstop.nodes.links.PortPointType;
import ru.gotoandstop.vacuum.CombinedVertex;
import ru.gotoandstop.vacuum.RelativeVertex;
import ru.gotoandstop.vacuum.RelativeVertex;
import ru.gotoandstop.nodes.VacuumEvent;
import ru.gotoandstop.nodes.VacuumLayout;
import ru.gotoandstop.nodes.core.NodeField;
import ru.gotoandstop.nodes.core.NodeField;
import ru.gotoandstop.nodes.events.NodeEvent;
import ru.gotoandstop.nodes.links.PortPoint;
import ru.gotoandstop.nodes.view.Bit101Text;
import ru.gotoandstop.storage.Storage;
import ru.gotoandstop.storage.Storage;
import ru.gotoandstop.ui.ISelectable;
import ru.gotoandstop.vacuum.controllers.MouseController;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.core.ModifiableVertex;
import ru.gotoandstop.vacuum.core.Vertex;
import ru.gotoandstop.vacuum.view.CircleIcon;
import ru.gotoandstop.vacuum.view.RectIcon;
import ru.gotoandstop.vacuum.view.VertexView;

[Event(name='move', type='ru.gotoandstop.nodes.events.NodeEvent')]

/**
 * @author tmshv
 */
public class Node extends VertexView implements IVertex, INode, ISelectable {
    protected static function getComplexifiedObject(object:Object):Object {
        if (object == null || object == undefined) return null;
        try {
            var value:Object = object.value;
            object.visible = object.visible ? object.visible : true;
            return object;
        } catch (error:Error) {
            return {
                value:object,
                visible:true
            }
        }
        return null;
    }

    protected var _vacuum:VacuumLayout;

    private var _object:INode;
    public function get object():INode {
        return _object;
    }

    private var closeButton:PushButton;
    private var closeButtonTimeout:int;

    private var closeButtonCommand:ICommand;
    internal var pos:ModifiableVertex;
    private var mover:MouseController;

    private var _selected:Boolean;

    protected var _drawContainer:DisplayObjectContainer;
    private var _fieldsContainer:DisplayObjectContainer;
    private var _fields:Storage;
    private var _ports:Storage;
    private var _fieldSnapPoints:Storage = new Storage();

    private var _panel:Panel;
    private var _input:Text;
    private var editableParam:String;

    private var _lt:IVertex;
    private var _rb:IVertex;
    private var _lb:IVertex;
    private var _rt:IVertex;

    protected var leftTop:IVertex;
    protected var rightBottom:IVertex;

    protected var _selectedShape:DisplayObject;

    private var _nativeSize:Point = new Point();

    public var portStep:uint;

    public function get id():String {
//        createPoints(getMarkers());
        return _object.id;
    }

    public function set id(value:String):void {
        _object.id = value;
    }

    public function get type():String {
        return object.type;
    }

    public function set type(value:String):void {
        object.type = value;
    }

    public function get system():INodeSystem {
        return object.system;
    }

    public function set system(value:INodeSystem):void {
        object.system = value;
    }

    public function get lastTransfer():TransportObject {
        return object.lastTransfer;
    }

    public function set lastTransfer(value:TransportObject):void {
        object.lastTransfer = value;
    }

    public function Node(object:INode, vacuum:VacuumLayout) {
        _vacuum = vacuum;
        _vacuum.layout.scale.addEventListener(Event.CHANGE, handleLayoutChange);
        pos = new ModifiableVertex();
        pos.addEventListener(Event.CHANGE, handlePositionChange);
        super(pos, vacuum.layout, null);
//        super.considerScaleLayout = false;
        mover = new MouseController(this);
        _ports = new Storage();
        _fields = new Storage();
        _object = object;
        _object.addEventListener(Event.CHANGE, handleObjectChange);

        _drawContainer = new Sprite();
        super.addChild(_drawContainer);
        _fieldsContainer = new Sprite();
        super.addChild(_fieldsContainer);

        leftTop = new Vertex();
        rightBottom = new Vertex();
        _lt = new RelativeVertex(this, leftTop);
        _rb = new RelativeVertex(this, rightBottom);
        _lb = new CombinedVertex(_lt, _rb, true);
        _rt = new CombinedVertex(_lt, _rb, false);

//        var vtx:VertexView;
//        var vtxc:Boolean = true;
//        vtx = new VertexView(_lt, vacuum.layout, new RectIcon(0, 0xff0000ff, 3), vtxc);
//        vacuum.showVertex(vtx);
//        vtx = new VertexView(_rb, vacuum.layout, new RectIcon(0, 0xff0000ff, 3), vtxc);
//        vacuum.showVertex(vtx);
//        vtx = new VertexView(_lb, vacuum.layout, new RectIcon(0, 0xff0000ff, 3), vtxc);
//        vacuum.showVertex(vtx);
//        vtx = new VertexView(_rt, vacuum.layout, new RectIcon(0, 0xff0000ff, 3), vtxc);
//        vacuum.showVertex(vtx);

        closeButton = new PushButton(null, 0, -18, 'X');
        closeButton.addEventListener(MouseEvent.CLICK, handleClickClose);
        closeButton.alpha = 0;
        closeButton.width = 16;
        closeButton.height = 16;

        super.addChild(closeButton);
        super.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
        super.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
        super.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);

        draw();
        setSize(100, 30);

        var params:Vector.<String> = object.getParams();
        for each(var param:String in params) {
            updateField(param, object.get(param));
        }
    }

    protected function setSize(w:uint, h:uint):void {
        w = w == 0 ? _nativeSize.x : w;
        h += 20;
        _nativeSize.x = w;
        _nativeSize.y = h;
        scaleNode(_vacuum.layout.scale.value);
    }

    private function scaleNode(scale:Number):void {
        var w:uint = _nativeSize.x * scale;
        var h:uint = _nativeSize.y * scale;
//        w = Math.max(20, w);
//        w = Math.min(100, w);
//        h = Math.max(40, h);
//        h = Math.min(100, h);

        rightBottom.setCoord(w, h);
        _panel.width = w * scale;
        _panel.height = h * scale;

        portStep = h * 0.1;
    }

    private function handleLayoutChange(event:Event):void {
        scaleNode(_vacuum.layout.scale.value);
        relocateFields();
    }

    override public function dispose():void {
        pos.removeEventListener(Event.CHANGE, handlePositionChange);
        mover.dispose();
        Tweener.removeTweens(closeButton);
        clearTimeout(closeButtonTimeout);
        closeButton.removeEventListener(MouseEvent.CLICK, handleClickClose);
        super.stage.removeEventListener(MouseEvent.CLICK, handleStageClick);
        super.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
        super.removeEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
        super.removeEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
        super.removeEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
        _object.removeEventListener(Event.CHANGE, super.dispatchEvent);
        _object.dispose();
        _object = null;
        pos = null;
        super.dispose();
    }

    public function get(key:String):* {
        return object.get(key);
    }

    public function set(key:String, value:*):void {
        if (NodeObject.isLink(key)) {
            object.set(key, value);
        } else {
            var complex:Object = getComplexifiedObject(value);
            object.set(key, complex.value);
            updateField(key, complex);
        }
    }

    public function setComplex(key:String, value:*, markerParams:Object = null):void {
        if (!markerParams) markerParams = new Object();
        var object:Object = new Object();
        for (var i:String in markerParams) {
            object[i] = markerParams[i];
        }
        object.key = key;
        object.value = value;
        set(key, object);
    }

    public function exist(key:String):Boolean {
        return object.exist(key);
    }

    public function kill(key:String):void {
        object.kill(key);
    }

    public function getParams():Vector.<String> {
        return object.getParams();
    }

    protected function updateField(key:String, value:*):void {
        key = NodeObject.param(key);
        if (value != undefined && value != null) {
            var complex:Object = getComplexifiedObject(value);
            var visible:Boolean = complex.visible;

            if (!_fields.exist(key) && visible) {
                createField(key, value);
            }

            var field:NodeField = _fields.get(key);
            if (field) {
                field.update(complex);

                var visible_port:Boolean = field.access != "none";
                if (!_ports.exist(key) && visible_port) {
                    var type:String = complex.access == 'read' ? 'out' : 'in';
                    var dir:String = type == 'in' ? 'left' : 'right';
                    var pos:Object = {
                        x:dir == 'left' ? '0 left' : '0 right',
                        y:''
                    };
                    createPort(key, {
                        visible:visible_port,
                        type:type,
                        dir:dir,
                        position:pos
                    });
                }
            }
        }
    }

    private function relocateFields():void {
        var scale:Number = _vacuum.layout.scale.value;
        var key_list:Vector.<String> = _fields.getKeyList();
        var top:Number = Calculate.interpolate(-2, 0, Math.min(scale, 1));
        for each(var key:String in key_list) {
            var field:NodeField = _fields.get(key);
            field.x = 10 * scale;
            field.y = top + field.getPosition() * scale;// * Calculate.interpolate(0.8, 1, Math.min(scale, 1));
        }
    }

    private function createField(key:String, definition:Object = null):void {
        var index:uint = _fieldsContainer.numChildren;
        var field:NodeField = new NodeField(key, definition, index);
        field.setSize(80, 15);

        field.addEventListener(MouseEvent.DOUBLE_CLICK, handleMarkerLabelClick);
        field.updateValue(object.get(key));

        var x:Number = 0;
        var y:Number = 10 + field.getPosition();

        var vtx:IVertex = new RelativeVertex(_lt, new Vertex(x, y));
//        var vvtx:VertexView = new VertexView(vtx, _vacuum.layout, new RectIcon(0, 0xff00ff00, 3), true);
//        _vacuum.showVertex(vvtx);

        _fieldSnapPoints.set(key, vtx);

        _fieldsContainer.addChild(field);
        _fields.set(key, field);

        var h:uint = 7 + 15 * (index + 1);
        setSize(0, h);

        relocateFields();
    }

    private function createPort(key:String, port:Object):void {
        if (port.visible) {
            var field:NodeField = _fieldsContainer.getChildByName(key) as NodeField;
            var type:String = port.type;

            var port_vertex:RelativeVertex;
            if (type == PortPointType.IN) {
                port_vertex = _fieldSnapPoints.get(key);
            } else if (type == PortPointType.OUT) {
                port_vertex = new RelativeVertex(_fieldSnapPoints.get(key), new CombinedVertex(rightBottom, new Vertex()));
            }

            var point:PortPoint = new PortPoint(port_vertex, _vacuum.layout, this, key, type, port.dir);
            _vacuum.showPort(point);
            _ports.set(key, point);
        }
    }

    private function handleObjectChange(event:Event):void {
        var change:NodeChangeEvent = event as NodeChangeEvent;
        if (change) {
            var key:String = change.key;
            var value:String = object.get(key);
            var field:NodeField = _fieldsContainer.getChildByName(key) as NodeField;
            if (field) {
                field.updateValue(value);
            }
            super.dispatchEvent(change);
        }
    }

    private function handleMarkerLabelClick(event:MouseEvent):void {
        var marker:NodeField = event.currentTarget as NodeField;
        editableParam = marker.name;
        _input.x = marker.x;
        _input.y = marker.y;
        _input.visible = true;
        _input.text = object.get(editableParam);
        marker.visible = false;
    }

    private function handleStageClick(event:MouseEvent):void {
        if (!_input.contains(event.target as DisplayObject) && _input.visible) {
            var marker:NodeField = _fieldsContainer.getChildByName(editableParam) as NodeField;
            marker.visible = true;
            _input.visible = false;
            modifyEditableParam();
            editableParam = null;
        }
    }

    private function modifyEditableParam(event:Event = null):void {
        if (editableParam) {
            var old_value:String = object.get(editableParam).toString();
            var new_value:String = _input.text;
            if (old_value != new_value) {
                object.set(editableParam, _input.text);
            }
        }
    }

    protected function draw():void {
        _panel = new Panel();
        _panel.shadow = false;
        mover.setTarget(_panel);
        _drawContainer.addChild(_panel);
//        _selectedShape = _panel;

        _input = new Bit101Text();
        _input.addEventListener(Event.CHANGE, modifyEditableParam);
//        _input.addEventListener(TextEvent.TEXT_INPUT, modifyEditableParam);
        _input.width = 50;
        _input.height = 21;
        _input.visible = false;
        _drawContainer.addChild(_input);
    }

    public function getMarkerDefinition(key:String):Object {
        return _fields.get(key);
    }

    private function deletePort(key:String):void {

    }

    public function getPort(key:String):PortPoint {
        return _ports.get(key);
    }

    public function getPortList():Vector.<PortPoint> {
        var result:Vector.<PortPoint> = new Vector.<PortPoint>();
        var list:Vector.<String> = _ports.getKeyList();
        for each(var key:String in list) {
            result.push(_ports.get(key));
        }
        return result;
    }

    protected function setDragTarget(target:DisplayObject):void {
        mover.setTarget(target);
    }

    private function handleAddedToStage(event:Event):void {
        super.removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
        super.addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
        super.stage.addEventListener(MouseEvent.CLICK, handleStageClick);
    }

    private function handleRemovedFromStage(event:Event):void {
        super.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
        super.removeEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
        super.stage.removeEventListener(MouseEvent.CLICK, handleStageClick);
    }

    override public function get x():Number {
        return pos.x;
    }

    override public function set x(value:Number):void {
        pos.x = value;
    }

    override public function get y():Number {
        return pos.y;
    }

    override public function set y(value:Number):void {
        pos.y = value;
    }

    private function showClose():void {
        closeButton.mouseEnabled = true;
        Tweener.removeTweens(closeButton);
        Tweener.addTween(closeButton, {alpha:1, time:0.3});
    }

    private function hideClose():void {
        closeButton.mouseEnabled = false;
        Tweener.removeTweens(closeButton);
        Tweener.addTween(closeButton, {alpha:0, time:0.5});
    }

    public function setCloseCommand(cmd:ICommand):void {
        closeButtonCommand = cmd;
    }

    private function handleMouseOver(event:MouseEvent):void {
        clearTimeout(closeButtonTimeout);
        closeButtonTimeout = setTimeout(showClose, 500);
    }

    private function handleMouseOut(event:MouseEvent):void {
        clearTimeout(closeButtonTimeout);
        closeButtonTimeout = setTimeout(hideClose, 300);
    }

    private function handleClickClose(event:Event):void {
        if (closeButtonCommand) closeButtonCommand.execute(null);
    }

    public function select():void {
        _selected = true;
        if (_selectedShape) {
            _selectedShape.filters = [new GlowFilter(0x0000ff, 0.3, 2, 2, 255)];
        }
    }

    public function deselect():void {
        _selected = false;
        if (_selectedShape) {
            _selectedShape.filters = [];
        }
    }

    public function get isSelected():Boolean {
        return _selected;
    }

    private function handlePositionChange(event:Event):void {
        super.dispatchEvent(new NodeEvent(NodeEvent.MOVE));
    }

    override public function toString():String {
        var msg:String = '[node id]';
        return msg.replace(/id/, id);
    }


}
}