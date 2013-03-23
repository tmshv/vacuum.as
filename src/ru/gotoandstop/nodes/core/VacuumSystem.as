/**
 * Created with IntelliJ IDEA.
 * User: Roman
 * Date: 16.03.13
 * Time: 22:40
 * To change this template use File | Settings | File Templates.
 */
package ru.gotoandstop.nodes.core {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import ru.gotoandstop.ISelectable;
import ru.gotoandstop.nodes.MouseVertex;
import ru.gotoandstop.nodes.NodeDefinition;
import ru.gotoandstop.nodes.VacuumEvent;
import ru.gotoandstop.nodes.VacuumLayout;
import ru.gotoandstop.nodes.links.DirectLinkProvider;
import ru.gotoandstop.nodes.links.ILinkProvider;
import ru.gotoandstop.nodes.links.Pin;
import ru.gotoandstop.nodes.links.PinType;
import ru.gotoandstop.storage.Storage;
import ru.gotoandstop.ui.Element;
import ru.gotoandstop.vacuum.Layout;
import ru.gotoandstop.vacuum.core.IVertex;
import ru.gotoandstop.vacuum.modificators.SnapModifier;

public class VacuumSystem extends Element implements INodeSystem {
    private var _system:NodeSystem;
    private var _canvas:Sprite;
    private var _vacuum:VacuumLayout;
    public function get vacuum():VacuumLayout {
        return _vacuum;
    }

    private var fakeConnection:String;
    private var firstPortFake:Pin;
    private var _cursorPin:MouseVertex;
    private var _mouseDownCoord:Point = new Point();
    private var selectedNodes:Vector.<ISelectable> = new Vector.<ISelectable>();
    private var snapVerticles:Vector.<IVertex> = new Vector.<IVertex>();

    public function VacuumSystem(canvas:Sprite, storage:Storage = null, linkProvider:ILinkProvider = null) {
        _canvas = canvas;
        linkProvider = linkProvider ? linkProvider : new DirectLinkProvider();

        _vacuum = new VacuumLayout(new Layout(), linkProvider);
        vacuum.addEventListener(VacuumEvent.ADDED_VERTEX, onVertexAddedToVacuum);
        push(vacuum);

        _cursorPin = new MouseVertex();
        vacuum.cursor = _cursorPin;

        _system = new NodeSystem(storage);
        _system.initVacuum(vacuum);
        _system.addEventListener(NodeSystemEvent.NODE_ADDED, onNodeAdded);
        _system.addEventListener(NodeSystemEvent.NODE_REMOVED, onNodeRemoved);

        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    public function getSelectedNodes():Vector.<Node> {
        var result:Vector.<Node> = new Vector.<Node>();
        for each(var n:ISelectable in selectedNodes) {
            result.push(n as Node);
        }
        return result;
    }

    public function clearSelection():void {
        for each(var n:ISelectable in selectedNodes) {
            n.deselect();
        }
        selectedNodes.splice(0, selectedNodes.length);
    }

    public function addSnapVertex(vertex:IVertex):void {
        snapVerticles.push(vertex);
    }

    private function addMouseListeners():void{
        stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
//        stage.addEventListener(MouseEvent.MOUSE_DOWN, _system.handleMouseDown);
    }

    private function removeMouseListeners():void{
        stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
//        stage.removeEventListener(MouseEvent.MOUSE_DOWN, _system.handleMouseDown);
    }

    private function onAddedToStage(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        addMouseListeners();

        _cursorPin.setEventTarget(stage);
    }

    private function onRemovedFromStage(event:Event):void {
        removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        removeMouseListeners();
    }

    private function onStageMouseUp(event:MouseEvent):void {
        if (!contains(event.target as DisplayObject)) {
            clearSelection();
        }

        vacuum.breakConnection(fakeConnection);
        fakeConnection = null;
        firstPortFake = null;
    }

    private function onNodeMouseDown(event:MouseEvent):void {
        _mouseDownCoord.x = event.stageX;
        _mouseDownCoord.y = event.stageY;
    }

    private function onNodeMouseUp(event:MouseEvent):void {
        if (_mouseDownCoord.equals(new Point(event.stageX, event.stageY))) {
            var node:Node = event.currentTarget as Node;
            if (node.isSelected) {
                var index:int = selectedNodes.indexOf(node);
                selectedNodes.splice(index, 1);
                node.deselect();
            } else {
                if (!event.shiftKey) {
                    clearSelection();
                }
                selectedNodes.push(node);
                node.select();
            }
        }
    }


    private function onNodeAdded(event:NodeSystemEvent):void {
        const node:Node = event.node as Node;

        node.pos.addModifier(new SnapModifier(snapVerticles, 10));

        node.addEventListener(MouseEvent.MOUSE_DOWN, onNodeMouseDown);
        node.addEventListener(MouseEvent.MOUSE_UP, onNodeMouseUp);
//        if (node.type == "clip") {
//            var proxy:MovieClipNodeProxy = new MovieClipNodeProxy(node, element("canvas"), assets, storage);
//            proxies.set(node.id, proxy);
//        } else if (node.type == "coord2D") {
//            var picker:MouseCoordPicker = new MouseCoordPicker(node, element("coord2D-markers"));
//            proxies.set(node.id, picker);
//        }
        dispatchEvent(event);
    }

    private function onNodeRemoved(event:NodeSystemEvent):void {
        const node:Node = event.node as Node;
        node.removeEventListener(MouseEvent.MOUSE_DOWN, onNodeMouseDown);
        node.removeEventListener(MouseEvent.MOUSE_UP, onNodeMouseUp);

        var index:int = selectedNodes.indexOf(node);
        selectedNodes.splice(index, 1);

//        if (proxies.exist(node.id)) {
//            var proxy:IDisposable = proxies.get(node.id);
//            proxy.dispose();
//            proxies.kill(node.id);
//        }
        dispatchEvent(event);
    }

    private function onVertexAddedToVacuum(event:VacuumEvent):void {
        const vertex:Pin = event.vertex as Pin;
        if (vertex.type == PinType.INPUT) {
            vertex.addEventListener(MouseEvent.MOUSE_DOWN, this.handleInVertexMouseDown);
            vertex.addEventListener(MouseEvent.MOUSE_UP, this.handleInVertexMouseUp);
            vertex.addEventListener(MouseEvent.MOUSE_OVER, this.handleInVertexMouseOver);
            vertex.addEventListener(MouseEvent.MOUSE_OUT, this.handleInVertexMouseOut);
        } else if (vertex.type == PinType.OUTPUT) {
            vertex.addEventListener(MouseEvent.MOUSE_DOWN, this.handleOutVertexMouseDown);
        }
    }

    /**
     * Нажатие на черную
     * @param event
     *
     */
    private function handleOutVertexMouseDown(event:MouseEvent):void {
        var vertex:Pin = event.currentTarget as Pin;
        firstPortFake = vertex;
        fakeConnection = vacuum.connectWithMouse(firstPortFake);
    }

    /**
     * Нажатие на input
     * @param event
     *
     */
    private function handleInVertexMouseDown(event:MouseEvent):void {
        const vertex:Pin = event.currentTarget as Pin;

        for each(var connection:Object in _system.connections) {
            if (connection.to == vertex) {
                _system.unlink(connection);
                fakeConnection = vacuum.connectWithMouse(connection.from, connection.vacuumLinkID);
                firstPortFake = connection.from;
            }
        }

        handleInVertexMouseOver(event);
    }

    /**
     * Отпуск    над input
     * @param event
     *
     */
    private function handleInVertexMouseUp(event:MouseEvent):void {
        const vertex:Pin = event.currentTarget as Pin;
        if (firstPortFake) {
            _system.makeLink(firstPortFake, vertex, fakeConnection);
        }
        fakeConnection = null;
        firstPortFake = null;
    }

    private function handleInVertexMouseOver(event:MouseEvent):void {
        const vertex:Pin = event.currentTarget as Pin;
        if (fakeConnection) {
            vacuum.connect(firstPortFake, vertex, fakeConnection);
        }
    }

    private function handleInVertexMouseOut(event:MouseEvent):void {
        if (fakeConnection) {
            vacuum.connectWithMouse(firstPortFake, fakeConnection);
        }
    }

    public function registerNodeDefinition(nodeDefinition:NodeDefinition):void {
        _system.registerNodeDefinition(nodeDefinition);
    }

    public function createNode(type:String, model:Object = null):INode {
        return _system.createNode(type, model);
    }

    public function deleteNode(node:INode):void {
        _system.deleteNode(node);
    }

    public function getNodesID():Vector.<String> {
        return _system.getNodesID();
    }

    public function getNodeByID(id:String):INode {
        return _system.getNodeByID(id);
    }

    public function getLinkedValue(link:String):Object {
        return _system.getLinkedValue(link);
    }

    public function matchNodeIDs(pattern:RegExp):Vector.<INode> {
        return _system.matchNodeIDs(pattern);
    }

    public function getRegistredTypes():Vector.<String> {
        return _system.getRegistredTypes();
    }

    public function getNodeDefinition(type:String):NodeDefinition {
        return _system.getNodeDefinition(type);
    }

    public function connect(outputNodeID:String, outputNodeField:String, intputNodeID:String, inputNodeField:String):void {
        _system.connect(outputNodeID, outputNodeField, intputNodeID, inputNodeField);
    }

    public function breakConnection(nodeID:String, nodeField:String):void {
        _system.breakConnection(nodeID, nodeField);
    }

    public function get storage():Storage {
        return _system.storage;
    }

    public function dispose():void {
        removeMouseListeners();
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

        vacuum.removeEventListener(VacuumEvent.ADDED_VERTEX, this.onVertexAddedToVacuum);
        vacuum.dispose();
        _vacuum = null;

        _system.removeEventListener(NodeSystemEvent.NODE_ADDED, onNodeAdded);
        _system.removeEventListener(NodeSystemEvent.NODE_REMOVED, onNodeRemoved);
        _system.dispose();
        _system = null;
    }

    public function serialize():Object {
        return _system.serialize();
    }
}
}
