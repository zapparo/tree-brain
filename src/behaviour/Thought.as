package behaviour 
{
	import behaviour.tasks.ActionTask;
	import behaviour.tasks.DecoratorTask;
	import behaviour.tasks.DecoratorType;
	import behaviour.tasks.SelectorTask;
	import behaviour.tasks.Task;
	import behaviour.tasks.TaskState;
	/**
	 * ...
	 * @author Ionut Ghenade
	 */
	public class Thought 
	{
		private var _forever:DecoratorTask;
		private var _start:Task;
		
		private var _validated:Boolean = false;		
		
		public function Thought(name:String) 
		{
			_forever = new DecoratorTask("FOREVER", DecoratorType.REPEAT, 0);		
			
			_start = new SelectorTask(name);			
			_start.setParent(_forever);			
		}
		
		public function getStart():Task { return _start;	}
		
		public function start():void 
		{
			if (!_validated) { 
				validateTask(_start);
				if (!_validated) { throw new Error("ERROR: Thought needs at least one ActionTask leaf"); }		
			}
			
			_forever.setTickingTask(_forever);
			_forever.start();		
		}	
		
		private function validateTask(task:Task):void
		{
			if(!_validated) {		
				if (task.getChildren().length == 0) {		
					if (task is ActionTask) { _validated = true; }
				} else {
					for each(var taskChildren:Task in task.getChildren()) {	validateTask(taskChildren as Task); }
				} 
			}
		}
		
		public function cancel():void {	_forever.tickingTask = null; }	
		
		public function tick():void 
		{ 			
			if (_forever.tickingTask != null) {
				_forever.stopTicking = false;			
				while (!_forever.stopTicking) { _forever.tickingTask.tick(); }
			}
		}		
		
		public function isRunning():Boolean
		{
			if (_forever.tickingTask == null) { 
				return false;
			} else {
				if (_forever.tickingTask.getState() == TaskState.RUNNING) { return true; }
			}
			
			return false;
		}
		
		public function getName():String { return _start.getName();	}		
	}

}