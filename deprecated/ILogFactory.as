package orichalcum.logging 
{

	public interface ILogFactory
	{
		function getLogger(source:Object):ILog;
	}

}
