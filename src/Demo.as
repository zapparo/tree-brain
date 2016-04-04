package 
{
	import behaviour.Brain;
	import behaviour.NeuronSelectionType;
	import behaviour.tasks.ActionTask;
	import behaviour.tasks.ConditionTask;
	import behaviour.tasks.DecoratorTask;
	import behaviour.tasks.DecoratorType;
	import behaviour.tasks.SelectorTask;
	import behaviour.tasks.SequenceTask;
	import behaviour.Thought;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Ionut Ghenade
	 */
	public class Demo extends Sprite
	{
		private var _behaviour:Brain;
		private var _runner:Object = {}
		
		public function Demo() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			_behaviour = new Brain("RUN AROUND");
			
			_runner.stamina = 5;
			_runner.fullStamina = 5;						
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);		
			
			buildBehavior();
			
			_behaviour.think("RUN AROUND");
			
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:Event):void 
		{
			_behaviour.update();	
		}
		
		private function buildBehavior():void
		{
			var runAround:Thought = new Thought("RUN AROUND");			
				var amITiredQuestion:SequenceTask = new SequenceTask("am I tired?");
				amITiredQuestion.setParent(runAround.getStart());
					
					var tiredResult:ConditionTask = new ConditionTask("tired result", amITired);
					tiredResult.setParent(amITiredQuestion);
				
					var fullyRested:DecoratorTask = new DecoratorTask("rest", DecoratorType.REPEAT_UNTIL_CONDITION, amIFullyRested);		
						var restAction:ActionTask = new ActionTask("resting", rest);
						restAction.setParent(fullyRested);
					fullyRested.setParent(amITiredQuestion);
			
				var choseDirection:SelectorTask = new SelectorTask("chose a direction", NeuronSelectionType.RANDOM);		
				choseDirection.setParent(runAround.getStart());			
				
					var runForward:ActionTask = new ActionTask("run forward", runForward, 1);
					runForward.setParent(choseDirection);
					var runLeft:ActionTask = new ActionTask("run left", runLeft, 1);
					runLeft.setParent(choseDirection);
					var runRight:ActionTask = new ActionTask("run right", runRight, 1);
					runRight.setParent(choseDirection);
							
			_behaviour.add(runAround);		
		}		
		
		public function amITired():Boolean { return _runner.stamina <= 0; }	
		
		public function rest():void { _runner.stamina++; trace("I am resting:" + String(int(_runner.stamina / _runner.fullStamina * 100)) + "%"); }
		
		public function amIFullyRested():Boolean { return _runner.stamina >= _runner.fullStamina; }
		
		public function runForward():void { trace("I am running forwards"); _runner.stamina--; }
		
		public function runLeft():void { trace("I am running left"); _runner.stamina--; }
		
		public function runRight():void { trace("I am running right"); _runner.stamina--;}			
		
	}
}
