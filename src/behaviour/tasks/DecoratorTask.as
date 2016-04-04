package behaviour.tasks 
{
	import behaviour.Neuron;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Ionut Ghenade
	 */
	public class DecoratorTask extends Task
	{
		private var _type:uint;
		private var _count:int = 0;
		
		private var _graft:Task;
		private var _limit:int = 0;
		private var _repeatFor:int = 0;		
		
		public function DecoratorTask(name:String, type:uint, argument:* = null)
		{					
			super(name, null, method);
			
			_type = type;				
			
			if (_type == DecoratorType.LIMIT) {
				if(argument == null) { throw new Error("ERROR: GRAFT DECORATOR needs non-null int as argument"); }
				if (argument is int) { throw new Error("ERROR: LIMIT DECORATOR needs int as argument"); }
				_limit = argument as int;
			}
			
			if (_type == DecoratorType.REPEAT) {
				if(argument == null) { throw new Error("ERROR: GRAFT DECORATOR needs non-null int as argument"); }
				if (!(argument is int)) { throw new Error("ERROR: REPEAT DECORATOR needs int as argument"); }
				_repeatFor = argument as int;
			}
			
			var method:Function = null;
			
			if (_type == DecoratorType.REPEAT_UNTIL_CONDITION) {
				if(argument == null) { throw new Error("ERROR: GRAFT DECORATOR needs non-null int as argument"); }
				if (!(argument is Function)) { throw new Error("ERROR: REPEAT UNTIL CONDITION DECORATOR needs Function as argument"); }
				 setMethod(argument as Function);
			}
		}
		
		private function buildFrom(argument:Task):Task
		{
			var result:Task = argument.copy();
			result.setParent(null);			
			return result;
		}
		
		override public function addChild(child:Neuron):void 
		{
			if (getChildren().length == 0) {
				super.addChild(child);
				if(_type == DecoratorType.LIMIT) { getLimitedTasksMap()[child as Task] = _limit; }
			} else {
				throw new Error("ERROR: DECORATOR can't have more than one child");
			}
		}
	
		override public function tick():void 
		{
			super.tick();
			
			if (getState() == TaskState.RUNNING) {			
				
				var child:Task = getChildren()[0] as Task;
				
				if (getTestedChildren().length == 0) { 
					if (getTickingTask() != child) { 
						setTickingTask(child); 					
						getTickingTask().start();
					}
				} else {			
					_count++;
					
					switch(_type) {
						case DecoratorType.ALWAYS_FAIL:
							if (child.getState() == TaskState.FAILED || child.getState() == TaskState.SUCCES) { setState(TaskState.FAILED); }
						break;
						case DecoratorType.ALWAYS_SUCCED:
							if (child.getState() == TaskState.FAILED || child.getState() == TaskState.SUCCES) { setState(TaskState.SUCCES); }						
						break;
						case DecoratorType.INVERTER:
							child.getState() == TaskState.SUCCES ? setState(TaskState.FAILED) : setState(TaskState.SUCCES);							
						break;
						case DecoratorType.LIMIT:
							var limitCount:int = _count + 1;
							var limitedTasks:Dictionary = getLimitedTasksMap();
							if (limitedTasks.exists(child)) { limitCount = limitedTasks.get(child); }
							_count <= limitCount ? setState(child.getState()) : setState(TaskState.FAILED);						
						break;
						case DecoratorType.REPEAT:						
							if (_repeatFor == 0) {
								setTickingTask(child);
								getTickingTask().start();
							} else {
								if (_count <= _repeatFor) {
									setTickingTask(child);
									getTickingTask().start();
								} else {
									_count = 0;
									setState(TaskState.SUCCES);
								}
							}						
						break;
						case DecoratorType.REPEAT_UNTIL_CONDITION:
							if (callMethod()) {
								setState(TaskState.SUCCES);
							} else {
								setTickingTask(child);
								getTickingTask().start();							
							}
						break;
						case DecoratorType.REPEAT_UNTIL_FAIL:
							if (child.getState() != TaskState.FAILED) {
								setTickingTask(child);
								getTickingTask().start();
							} else {
								setState(TaskState.FAILED);
							}
						break;
						case DecoratorType.REPEAT_UNTIL_SUCCES:
							if (child.getState() != TaskState.SUCCES) {
								setTickingTask(child);
								getTickingTask().start();
							} else {
								setState(TaskState.SUCCES);
							}
						break;
					}
				}
			}

		}		
	}
}