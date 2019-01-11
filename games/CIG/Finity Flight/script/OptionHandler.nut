class OptionHandler
{
	soundVolume = 100;
	musicVolume = 100;
	fireButton = 32;
	weaponSwitch = 99;
	altMovement = 304;
	
	gunsUnlocked = 1;
	
	unlockedAttackRaptor = false;
	unlockedCottonMouth = false;
	unlockedFalcon = false;
	unlockedStealthFalcon = false;
	unlockedYellowJacket = false;
	
	shipSelected = 0;
	
	constructor()
	{			
		local tempButton = retrieve("FinityFlight","soundVolume");
		if(tempButton)
			soundVolume = tempButton.tointeger();
		
		tempButton = retrieve("FinityFlight","musicVolume");
		if(tempButton)
			musicVolume = tempButton.tointeger();
			
		tempButton = retrieve("FinityFlight", "fireButton");
		if(tempButton)
			fireButton = keyCode(tempButton);
		
		tempButton = retrieve("FinityFlight","weaponSwitch");
		if(tempButton)
			weaponSwitch = keyCode(tempButton);
		
		tempButton = retrieve("FinityFlight","altMovement");
		if(tempButton)
			altMovement = keyCode(tempButton);
		
		tempButton = retrieve("FinityFlight","unlockedAttackRaptor");
		if(tempButton == "true")
			unlockedAttackRaptor = true;
		
		tempButton = retrieve("FinityFlight","unlockedCottonMouth");
		if(tempButton == "true")
			unlockedCottonMouth = true;
		
		tempButton = retrieve("FinityFlight","unlockedFalcon");
		if(tempButton == "true")
			unlockedFalcon = true;
		
		tempButton = retrieve("FinityFlight","unlockedStealthFalcon");
		if(tempButton == "true")
			unlockedStealthFalcon = true;
		
		tempButton = retrieve("FinityFlight","unlockedYellowJacket");
		if(tempButton == "true")
			unlockedYellowJacket = true;
		
		tempButton = retrieve("FinityFlight","shipSelected");
		if(tempButton)
			shipSelected = tempButton.tointeger();
	}
	
	function addSoundVolume(change)
	{
		soundVolume += change;
		if(soundVolume > 100)
			soundVolume = 100;
		else if(soundVolume < 0)
			soundVolume = 0;
	}
	
	function addMusicVolume(change)
	{
		musicVolume += change;
		if(musicVolume > 100)
			musicVolume = 100;
		else if(musicVolume < 0)
			musicVolume = 0;
	}
}
