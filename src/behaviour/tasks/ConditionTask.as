package behaviour.tasks 
{
	import behaviour.Neuron;
	/**
	 * ...
	 * @author Ionut Ghenade
	 */
	public class ConditionTask extends Task
	{
		
		public function ConditionTask(name:String, method:Function, waitTime:Number = 0) 
		{
			super(name, null, method, waitTime);
		}
		
		override public function tick():void 		
		{
			super.tick();			

			if (getState() == TaskState.RUNNING) {
				callMethod() ? setState(TaskState.SUCCES) : setState(TaskState.FAILED);
			}
		}
		
		override public function addChild(child:Neuron):void 
		{
			throw new Error("ERROR: CONDITION TASK can't have children");
		}		
	}
}