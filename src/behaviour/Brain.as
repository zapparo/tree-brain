package behaviour 
{
	/**
	 * ...
	 * @author Ionut Ghenade
	 */
	public class Brain 
	{
		private var _name:String;
		private var _thouhgts:Vector.<Thought>;
		
		private var _currentThought:Thought;		
		
		public function Brain(name:String) 
		{
			_name = name;
			_thouhgts = new Vector.<Thought>();			
		}			
	
		public function think(value:*):void
		{
			var thought:Thought = null;
			
			if (value is String) { thought = getThoughWithName(value); }
			if (value is Thought) { thought = value; }
			
			if (thought != null) {
				if (_thouhgts.indexOf(thought) >= 0) {
					_currentThought = thought;
					_currentThought.start();				
				} else {
					throw new Error("Brain ERROR: I am trying to think a thought that's not in my list"); 
				}
			} else {
				throw new Error("Brain ERROR: I am trying to think - null"); 
			}
		}
		
		public function add(value:Thought):void 
		{
			if (_thouhgts.indexOf(value) < 0) { _thouhgts.push(value); }
		}
		
		public function getThoughWithName(name:String):Thought
		{
			for each(var thouhgt:Thought in _thouhgts) { if (thouhgt.getName() == name) { return thouhgt; } }		
			
			return null;
		}
		
		public function getRandomThought():Thought
		{
			if (_thouhgts.length > 0) {	return _thouhgts[Math.floor(Math.random() * _thouhgts.length)];	}	
			return null;
		}		

		public function update():void 
		{
			if (_currentThought != null) { _currentThought.tick(); }
		}		
	}
}