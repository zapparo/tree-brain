package behaviour.tasks 
{
	import behaviour.Neuron;
	/**
	 * ...
	 * @author Ionut Ghenade
	 */
	public class ActionTask extends Task
	{
		public function ActionTask(name:String, method:Function, waitTime:Number = 0) 
		{
			super(name, null, method, waitTime) 		
		}		
		
		override public function tick():void 
		{
			super.tick();	
			
			if(getState() == TaskState.RUNNING) {
				callMethod();
				setState(TaskState.SUCCES);			
				(getRoot() as Task).stopTicking = true;
			}
		}
		
		override public function addChild(child:Neuron):void 
		{
			throw new Error("ERROR: ACTION TASK can't have children");			
		}		
	}
}