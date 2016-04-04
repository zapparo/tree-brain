package behaviour.tasks 
{
	/**
	 * ...
	 * @author Ionut Ghenade
	 */
	public class SelectorTask extends Task
	{
		
		public function SelectorTask(name:String, neuronSelectionType:uint = 0) 
		{
			super(name, null, null, 0, neuronSelectionType);
		}
		
		override public function tick():void 
		{
			super.tick();
			
			if (getState() == TaskState.RUNNING)  {
				if (lastTestedChildSucceded()) {
					setState(TaskState.SUCCES);
				} else {
					var nextTask:Task = next();
					if (nextTask == null) {
						setState(TaskState.FAILED);
					} else {
						setTickingTask(nextTask);
						getTickingTask().start();					
					}
				}
			}
		}		
	}

}