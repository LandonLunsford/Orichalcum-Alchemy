package orichalcum.alchemy.process.chain 
{
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.alchemy.process.IAlchemyProcess;
	import orichalcum.alchemy.recipe.Recipe;


	public class ProcessChain implements IProcessChain
	{
		private var _processors:Array;
		
		public function ProcessChain(...processors) 
		{
			_processors = processors;
		}
		
		/* INTERFACE orichalcum.alchemy.lifecycle.process.IProcessChain */
		
		public function process(instance:*, id:*, type:Class, recipe:Recipe):* 
		{
			for each(var processor:IAlchemyProcess in _processors)
			{
				instance = processor.process(instance, id, type, recipe);
			}
			return instance;
		}
		
		public function add(process:IAlchemyProcess):void 
		{
			if (process)
			{
				_processors.push(process);
			}
		}
		
		public function remove(process:IAlchemyProcess):void 
		{
			if (process)
			{
				const index:int = _processors.lastIndexOf(process);
				if (index >= 0)
				{
					_processors.splice(index, 1);
				}
			}
		}
		
	}

}