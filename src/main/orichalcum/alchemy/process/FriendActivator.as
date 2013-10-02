package orichalcum.alchemy.process 
{
	import flash.utils.Dictionary;
	import orichalcum.alchemy.alchemist.IAlchemist;
	import orichalcum.alchemy.evaluator.IEvaluator;
	import orichalcum.alchemy.recipe.Recipe;


	public class FriendActivator implements IAlchemyProcess
	{
		private var _alchemist:IAlchemist;
		private var _friendsByInstance:Dictionary;
		
		public function FriendActivator(alchemist:IAlchemist, friendsByInstance:Dictionary)
		{
			_alchemist = alchemist;
			_friendsByInstance = friendsByInstance;
		}
		
		/* INTERFACE orichalcum.alchemy.process.IAlchemyProcess */
		
		public function process(instance:*, id:*, type:Class, recipe:Recipe):* 
		{
			for each(var friendId:* in recipe.friends)
			{
				(_friendsByInstance[instance] ||= [])
					.push(_alchemist.conjure(friendId));
			}
			return instance;
		}
		
	}

}