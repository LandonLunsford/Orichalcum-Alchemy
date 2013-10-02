package orichalcum.alchemy.process 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.alchemy.recipe.Recipe;


	public class FriendDeactivator implements IAlchemyProcess
	{
		
		private var _alchemist:IAlchemist;
		private var _friendsByInstance:Dictionary;
		
		public function FriendDeactivator(alchemist:IAlchemist, friendsByInstance:Dictionary)
		{
			_alchemist = alchemist;
			_friendsByInstance = friendsByInstance;
		}
		
		/* INTERFACE orichalcum.alchemy.process.IAlchemyProcess */
		
		public function process(instance:*, id:*, type:Class, recipe:Recipe):* 
		{
			const friends:* = _friendsByInstance[instance];
			if (friends)
			{
				for each(var friend:* in friends)
				{
					_alchemist.destroy(friend);
				}
				delete _friendsByInstance[instance];
			}
			
			// instance will be destroyed down the chain
			
			return instance;
		}
		
	}

}