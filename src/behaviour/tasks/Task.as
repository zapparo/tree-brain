package behaviour.tasks 
{
	import behaviour.Neuron;
	import behaviour.NeuronSelectionType;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Ionut Ghenade
	 */
	public class Task extends Neuron
	{
		private var _name:String;
		private var _state:uint;
		private var _method:Function;
		
		private var _selectionType:uint;
		private var _waitTime:Number;
		private var _testedChildren:Vector.<Task>;
		
		private var _waitTick:Number;
		
		public var stopTicking:Boolean;
		public var tickingTask:Task;
		public var limitedTasks:Dictionary;
		
		public function Task(name:String, parent:Neuron, method:Function, waitTime:Number = 0, neuronSelectionType:uint = 0) 
		{			
			super(parent);
			_name = name;			
			_method = method;
			
			_selectionType = neuronSelectionType;
			
			_waitTime = waitTime;			
			_waitTick = 0;
			
			_testedChildren = new Vector.<Task>();
		}

		public function getName():String { return _name; }
		
		public function succeded():void { }
		
		public function failed():void { }
		
		public function next():Task
		{
			var result:Task = null;
			
			switch(_selectionType) {
				case NeuronSelectionType.ASCENDING: 
					result = getNextChildAscending();
				break;
				case NeuronSelectionType.DESCENDING: 
					result = getNextChildDescending();
				break;
				case NeuronSelectionType.RANDOM: 
					result = getNextChildRandom();
				break;
			}		
			
			if (_testedChildren.indexOf(result) >= 0) { throw new Error("ERROR: already tested this child"); }
			
			return result;
		}	
		
		public function addTestedChild(child:Task):void { _testedChildren.push(child); }
		
		public function getTestedChildren():Vector.<Task> { return _testedChildren; }
		
		private function getNextChildAscending():Task
		{		
			var idx:int = 0;
			
			if (_testedChildren.length == 0) { 
				idx = 0; 			
			} else {
				idx = getChildren().indexOf(_testedChildren[_testedChildren.length - 1]) + 1;
				if (idx  > getChildren().length -1) { return null; }			
			}
			
			return getChildren()[idx] as Task;
		}
		
		private function getNextChildDescending():Task
		{
			var idx:int = 0;
			
			if (_testedChildren.length == 0) { 
				idx = getChildren().length - 1;
			} else {
				idx = getChildren().indexOf(_testedChildren[_testedChildren.length - 1]) - 1;
				if (idx < 0) { return null; }
			}
			
			return getChildren()[idx] as Task;
		}	
		
		private function getNextChildRandom():Task
		{
			var result:Task = null;
			
			var available:Vector.<Neuron> = getChildren().concat();
			for each(var child:Neuron in _testedChildren) { available.splice(available.indexOf(child), 1); }		
			
			if (available.length > 0 ) {				
				var idx:int = Math.floor(available.length * Math.random());
				result = getChildren()[idx] as Task;
			}
			
			while (available.length > 0) { available.pop(); }
			available = null;			
			
			return result;
		}
		
		public function allChildrenTestedAndSucceded():Boolean
		{
			var result:Boolean = false;
			
			if (_testedChildren.length == getChildren().length) {
				for each(var child:Neuron in _testedChildren) { if ((child as Task).getState() == TaskState.FAILED) { result = false; break; } }
			} 

			return result;
		}		
		
		public function lastTestedChildSucceded():Boolean
		{
			if (_testedChildren.length > 0) {
				return (_testedChildren[_testedChildren.length - 1] as Task).getState() == TaskState.SUCCES;
			}
			
			return false;
		}
		
		public function start():void 
		{	
			(getRoot() as Task).stopTicking = false;
			
			while (_testedChildren.length > 0) { _testedChildren.pop(); }

			setState(TaskState.RUNNING); 	
		}
		
		public function setTickingTask(task:Task):void
		{	
			if (task != null) { (getRoot() as Task).tickingTask = task; }
		}
		
		public function getTickingTask():Task  { return (getRoot() as Task).tickingTask; }	
		
		public function getLimitedTasksMap():Dictionary { return (getRoot() as Task).limitedTasks; }
		
		public function cancel():void {	setState(TaskState.FAILED); }		
		
		public function tick():void { }	

		public function setState(value:uint):void
		{			
			if (getState() != TaskState.SUCCES && value == TaskState.SUCCES) { 	
				if (getParent() != null) { 
					(getParent() as Task).addTestedChild(this);
					setTickingTask(getParent() as Task); 				
				}		
			}

			if (getState() != TaskState.FAILED && value == TaskState.FAILED) { 
				if (getParent() != null) { 
					(getParent() as Task).addTestedChild(this);
					setTickingTask(getParent() as Task);			
				}
			}
			
			_state = value;
		}
		
		public function setMethod(method:Function):void { _method = method; }
		
		public function callMethod():Boolean
		{				
			var result:Boolean = false;
			var callResult:* = _method.call();
			
			if (callResult is Boolean) { 
				return (callResult as Boolean);
			} else {
				if (callResult != null) { result = true; }
			}
			
			return result;
		}
		
		public function getState():uint { return _state; }
		
		public function copy():Task
		{
			return null;
		}
		
		public function dispose():void
		{
			
		}	
	}
}