package ru.gotoandstop.vacuum.controllers{
	import ru.gotoandstop.IDisposable;
	import ru.gotoandstop.vacuum.view.VertexView;

	/**
	 * Интерфейсный класс для объектов, описывающих зависимости между вьюшками вершин
	 * Creation date: Jul 28, 2011
	 * @author Roman Timashev (roman@tmshv.ru)
	 */
	public interface IDependencySet extends IDisposable{
		function createDependencies(verticies:Vector.<VertexView>):void;
	}
}