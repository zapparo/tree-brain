package behaviour 
{
	/**
	 * ...
	 * @author Ionut Ghenade
	 */
	public class Neuron 
	{
		private var _children:Vector.<Neuron>;
		private var _parent:Neuron;				
		
		public function Neuron(parent:Neuron = null) 
		{
			_children = new Vector.<Neuron>();
			setParent(parent);
		}
		
		public function getChildren():Vector.<Neuron> { return _children; }
		
		public function getRoot():Neuron
		{
			var root:Neuron = this;			
			while (root.getParent() != null) { root = root.getParent(); }		
			return root;
		}
		
		public function getParent():Neuron { return _parent; }
		
		public function setParent(value:Neuron):void 
		{ 
			_parent = value; 				
			if (_parent != null) { _parent.addChild(this); }
		}
		
		public function addChild(child:Neuron):void
		{	
			if(_children.indexOf(child) <= 0) { _children.push(child); }
		}
		
		public function isRoot():Boolean { return _parent == null; }
		
		public function isLeaf():Boolean { return _children.length == 0; }		
	}

}