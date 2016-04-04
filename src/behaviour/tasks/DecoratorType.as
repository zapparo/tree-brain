package behaviour.tasks 
{
	/**
	 * ...
	 * @author Ionut Ghenade
	 */
	public class DecoratorType 
	{
		public static const ALWAYS_FAIL:uint = 0;
		public static const ALWAYS_SUCCED:uint = 1;
		public static const INVERTER:uint = 2;
		public static const LIMIT:uint = 3;
		public static const REPEAT:uint = 4;
		public static const REPEAT_UNTIL_CONDITION:uint = 5;
		public static const REPEAT_UNTIL_FAIL:uint = 6;
		public static const REPEAT_UNTIL_SUCCES:uint = 7;		
		
		public function DecoratorType() 
		{
			
		}
		
	}

}