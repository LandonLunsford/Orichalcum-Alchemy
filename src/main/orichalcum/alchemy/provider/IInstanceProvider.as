package orichalcum.alchemy.provider 
{
	
	public interface IInstanceProvider extends IProvider
	{
		function get type():Class;
	}

}