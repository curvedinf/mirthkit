class ControlHandler
{
	
	mousePosition = null;
	buttonDown = null;
	
	replaying = false;
	recording = false;
	
	replayPosition = 0;
	replayArray = null;
	
	fireButton = 32;
	weaponSwitch = 99;
	altMovement = 304;
	
	constructor()
	{
		mousePosition = [0,0];
		buttonDown = [0,0,0,0];
		replayArray = [];
	}
	function update()
	{
		if(replaying)
		{
			if(replayPosition < replayArray.len())
			{
				local controls = replayArray[replayPosition];
				replayPosition++;
				mousePosition[0] = controls[0];
				mousePosition[1] = controls[1];
				buttonDown[0] = controls[2];
				buttonDown[1] = controls[3];
				buttonDown[2] = controls[4];
				buttonDown[3] = controls[5];
			} else {
				replaying = false;
			}
			return;
		}
		
		mousePosition = ::mousePos;
		buttonDown[0] = mouseButton(1) || key(::options.fireButton);
		buttonDown[1] = mouseButton(2) || key(::options.weaponSwitch);
		buttonDown[2] = mouseButton(3) || key(::options.altMovement);
		buttonDown[3] = key(keyCode("TAB"));
		
		if(recording) {
			local controls = [mousePosition[0],
							mousePosition[1],
							buttonDown[0],
							buttonDown[1],
							buttonDown[2],
							buttonDown[3]];
			replayArray.push(controls);
		}
	}
	
	function clearReplay() {
		replayArray = [];
		recording = false;
		replaying = false;
	}
	
	function startRecording() {
		replayArray = [];
		recording = true;
		replaying = false;
	}
	
	function startReplaying() {
		recording = false;
		replaying = true;
		replayPosition = 0;
	}
	
	function saveReplay() {
		local string = "[";
		for(local i=0;i<replayArray.len();i++) {
			if(i>0)
				string += ",";
			local controls = replayArray[i];
			local controlsString = "["+controls[0];
			controlsString += ","+controls[1];
			controlsString += ","+controls[2];
			controlsString += ","+controls[3];
			controlsString += ","+controls[4];
			controlsString += ","+controls[5]+"]";
			string += controlsString;
		}
		string  += "]";
		return string;
	}
	
	function loadReplay(string) {
		replayArray = compilestring("return "+string+";")();
	}
	
	function isButtonDown(index)
	{
		return buttonDown[index-1];
	}
	function getMousePosition()
	{
		return mousePosition;
	}
}
