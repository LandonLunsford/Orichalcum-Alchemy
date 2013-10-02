package orichalcum.alchemy.process.chain 
{
	import orichalcum.alchemy.process.IAlchemyProcess;
	
	public interface IProcessChain extends IAlchemyProcess
	{
		function add(process:IAlchemyProcess):void;
		function remove(process:IAlchemyProcess):void;
	}

}