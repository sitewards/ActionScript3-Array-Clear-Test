package tests 
{

	public class TestSplice extends ArrayClearTest
	{
		public function TestSplice() 
		{
			name = "Test: Splice(0, length)\t\t\t";
		}
		
		override public function clearArrays():void 
		{
			var array:Array;
			for (var i:int = 0; i < m_array.length; i++)
			{
				array = m_array[i];
				array.splice(0, array.length);
			}
		}
		
	}
	
}