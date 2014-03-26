package orichalcum.reflection.metadata.transform 
{
	
	public interface IMetadataTransform 
	{
		function transform(metadata:XML, flyweight:Object = null):*;
	}

}