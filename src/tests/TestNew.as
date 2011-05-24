package tests 
{

	public class TestNew extends ArrayClearTest
	{
		public function TestNew() 
		{
			name = "Test: Using array = new Array()\t";
		}
		
		override public function clearArrays():void 
		{
			var array:Array;
			for (var i:int = 0; i < m_array.length; i++)
			{
				m_array[i] = new Array()
			}
		}		
	}
	
}