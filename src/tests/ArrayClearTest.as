package tests
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ArrayClearTest 
	{
		public static var NUMBER_OF_ARRAYS:int = 10000;
		public static var ARRAY_LENGTH:int = 100;
		public static var ARRAY_POOL_SIZE:int = 12000;
		public var name:String = "overwrite";
		
		protected var m_array:Array;
		protected static var m_objectPool:Array;

		public function ArrayClearTest() 
		{
		}
		
		public function setTestParameters(_num:int, _len:int):void 
		{
			NUMBER_OF_ARRAYS = _num;
			ARRAY_LENGTH = _len;
			if (m_objectPool == null && false)
			{
				m_objectPool = new Array(ARRAY_POOL_SIZE);
				for (var i:int = 0; i < m_objectPool.length; i++)
				{
					m_objectPool[i] = new Object();
				}			
			}
		}
		
		public function init():void 
		{
			m_array = new Array(NUMBER_OF_ARRAYS);
			for (var a:int = 0; a < m_array.length; a++)
			{
				m_array[a] = new Array(ARRAY_LENGTH);
				for (var i:int = 0; i < m_array[a].length; i++)
				{
					m_array[a][i] = a + i;// m_objectPool[i % ARRAY_POOL_SIZE];
				}
			}
		}
		
		public function clearArrays():void 
		{
			// overwrite
		}
		
		public function isInitialized():Boolean
		{
			return m_array != null
		}
		
	}
	
}