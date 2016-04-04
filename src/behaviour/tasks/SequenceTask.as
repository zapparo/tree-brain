package behaviour.tasks 
{
	/**
	 * ...
	 * @author Ionut Ghenade
	 */
	public class SequenceTask extends Task
	{
		
		public function SequenceTask(name:String, neuronSelectionType:uint = 0) 
		{
			super(name, null, null, 0, neuronSelectionType);
		}
		
		override public function tick():void 
		{
			super.tick();
			
			if (getState() == TaskState.RUNNING)  { 	
				
				if (allChildrenTestedAndSucceded()) {
					setState(TaskState.SUCCES);
				} else {
					if (getTestedChildren().length > 0 && !lastTestedChildSucceded()) { 
						setState(TaskState.FAILED); 					
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

}