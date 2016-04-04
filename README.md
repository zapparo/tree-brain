# tree-brain

This is an implementation of the code driven behaviour tree.

## Leaf nodes
* **Action task** - executes a method
* **Condition task** - executes a query and returns a boolean

## Composite nodes
* **Selector task** - executes children behaviours in order or randomly until one succeeds, if all children fail returns a fail status
* **Sequence task** - executes children behaviours in order or randomly , if one children fails returns a fail status
* **Decorator task** - has only one child and modifies the behaviour of that child
	* allways fail
	* always succed
	* inverter
	* limit
	* repeat
	* repeat until condition
	* repeat until fail
	* repeat until succes

## Usage
``` actionscript

					  behaviour - run around                        
                    /						\    
                  /      					  \
			    /							    \
        	  /									\
			/        								\
Sequnce: I am tired?								   \
        /   \										    \  
	   /      \										    \
      /         \										    \
	 /			\											\
condition:		decorator:									random selector:
 am i Tired?	   repeat until condition: 			       /        /         \
 				   fully rested					action:  	action:    	 action:          
                  	|							 run left	 run forward	  run right
                  action:
                  	rest

``` 
###Equals
``` actionscript
    _behaviour = new Brain("RUN AROUND");

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
    
    _behaviour.think("RUN AROUND");
```


