package  
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import gui.TextBox;
	import gui.TextInput;
	import tests.ArrayClearTest;
	import tests.TestBrackets;
	import tests.TestLength;
	import tests.TestNew;
	import tests.TestSplice;
	
	public class TestTool extends Sprite
	{
		private static const BORDER_WIDTH:int = 5;
		private static const FPS:int = 25;
		
		private static const STATE_INTRODUCE:int = 0;
		private static const STATE_INIT:int = 1;
		private static const STATE_RUN:int = 2;
		
		private var m_headline:TextBox;
		private var m_textOutput:TextBox;
		private var m_arrayLength:TextInput;
		private var m_arrayNum:TextInput;
		private var m_arrayLengthLabel:TextBox;
		private var m_arrayNumLabel:TextBox;		
		private var m_startButton:TextBox;
		private var m_timer:Timer;
		private var m_tests:Array;
		private var m_currentTest:int;
		private var m_state:int = STATE_INTRODUCE;
		
		public function init():void 
		{
			initGui();
			
			// create the test
			m_tests = new Array();
			m_tests.push(new TestLength());
			m_tests.push(new TestSplice());
			m_tests.push(new TestNew());
			m_tests.push(new TestBrackets());
			
			// create the timer
			m_timer = new Timer(1000 / FPS);
			m_timer.addEventListener(TimerEvent.TIMER, update);
			m_timer.start();
			
			// pretend to be done already
			m_currentTest = m_tests.length;			
		}
		
		public function updateHeadline():void 
		{
			m_headline.clear();
			m_headline.writeLn("\n<font size=\"14\"><b>AS3 ARRAY CLEAR PERFORMANCE TEST</b></font>");
			var rec:Rectangle = m_headline.getTextMetrics();
			
			m_arrayLengthLabel.y = m_arrayNumLabel.y = m_headline.y + rec.height + BORDER_WIDTH + BORDER_WIDTH;
			m_arrayLength.y = m_arrayNum.y = m_startButton.y = m_arrayLengthLabel.y + m_arrayLengthLabel.height + BORDER_WIDTH;

			m_textOutput.y = m_arrayLength.y + m_arrayLength.height + (3* BORDER_WIDTH);
			m_textOutput.height = stage.stageHeight - m_textOutput.y - BORDER_WIDTH - BORDER_WIDTH;			
		}
		
		public function startTest():void 
		{
			var numArrays:Number = parseFloat(m_arrayNum.getText());
			var lenArrays:Number = parseFloat(m_arrayLength.getText());
			m_textOutput.clear();
			
			if (isNaN(numArrays))
			{
				m_textOutput.writeLn("Error parsing \"number of arrays\"! Only decimals allowed.");
				return;
			}
			if (isNaN(lenArrays))
			{
				m_textOutput.writeLn("Error parsing \"arrays length\"! Only decimals allowed.");
				return;
			}
			
			for (var i:int = 0 ; i < m_tests.length; i++)
			{
				var test:ArrayClearTest = m_tests[i];
				test.setTestParameters(numArrays, lenArrays);
			}
			
			m_currentTest = 0;
			m_state = STATE_INTRODUCE;			
			m_startButton.visible = false;
		}
		
		public function update(_e:TimerEvent):void 
		{
			updateHeadline();
			
			if (m_currentTest >= m_tests.length)
			{
				m_startButton.visible = true;
				return;
			}
			
			var test:ArrayClearTest = m_tests[m_currentTest];
			var timestart:int, timeend:int;
			
			if (m_state == STATE_INTRODUCE)
			{
				m_textOutput.write(test.name + ": ");
				m_state = STATE_INIT;
				return;
			}
			
			if (m_state == STATE_INIT)
			{
				test.init();
				m_state = STATE_RUN;
				return;
			}
			
			if (m_state == STATE_RUN)
			{
				// run the test and take the time
				timestart = getTimer();
				test.clearArrays();
				timeend = getTimer();
				
				m_textOutput.writeLn((timeend - timestart) + " ms", "#777777");
				m_currentTest++;
				m_state = STATE_INTRODUCE;
			}
		}
		
		private function initGui():void 
		{
			m_headline = new TextBox();
			m_textOutput = new TextBox();
			stage.addChild(m_headline);
			stage.addChild(m_textOutput);
			m_headline.width = stage.stageWidth - BORDER_WIDTH - BORDER_WIDTH;
			m_headline.height = stage.stageHeight -BORDER_WIDTH - BORDER_WIDTH;
			m_headline.x = BORDER_WIDTH;
			m_headline.y = BORDER_WIDTH;
			
			// inputs
			m_arrayLength = new TextInput();
			m_arrayLengthLabel = new TextBox();
			m_arrayNum = new TextInput();
			m_arrayNumLabel = new TextBox();
			m_startButton = new TextBox();
			
			var std_height:int = (m_arrayLength.textformat.size as Number) + 6;
			var std_width:int = 150;
			
			m_arrayNumLabel.width = std_width;
			m_arrayNumLabel.height = std_height;
			m_arrayNumLabel.x = BORDER_WIDTH + BORDER_WIDTH;				
			m_arrayNumLabel.write("Number of Arrays:", "#FFFFFF");

			m_arrayLengthLabel.width = std_width;
			m_arrayLengthLabel.height = std_height;
			m_arrayLengthLabel.x = m_arrayNumLabel.x + m_arrayNumLabel.width + BORDER_WIDTH;
			m_arrayLengthLabel.write("Array Length:", "#FFFFFF");			
			
			m_arrayLength.width = std_width;
			m_arrayLength.height = std_height;
			m_arrayLength.x = m_arrayLengthLabel.x;
			m_arrayLength.write("1000", "#FFFFFF");
			
			m_arrayNum.width = std_width;
			m_arrayNum.height = std_height;
			m_arrayNum.x = m_arrayNumLabel.x;
			m_arrayNum.write("1000", "#FFFFFF");
			
			m_startButton.width = std_width;
			m_startButton.height = std_height;
			m_startButton.x = m_arrayLengthLabel.x + m_arrayLengthLabel.width + BORDER_WIDTH;
			m_startButton.setType(TextBox.TYPE_BUTTON);
			m_startButton.write("Start Tests", "#FFFFFF");
			m_startButton.setClickCallback(startTest);
			
			m_textOutput.width = m_headline.width - BORDER_WIDTH - BORDER_WIDTH;
			m_textOutput.x = m_headline.x + BORDER_WIDTH ;
		
			stage.addChild(m_arrayLengthLabel);
			stage.addChild(m_arrayLength);
			stage.addChild(m_arrayNumLabel);
			stage.addChild(m_arrayNum);
			stage.addChild(m_startButton);			
			
			m_textOutput.writeLn("You may change array length and number of arrays used in the test. Press \"Start Tests\" to start.");
		}
		
	}
	
}