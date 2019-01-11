class HighScoreBook
{
	levelsOpened = 0;
	highScores = null;
	replays = null;
	targetScores = null;
	startingWeapons = null;

	constructor()
	{

		local tempInput = retrieve("FinityFlight","version");

		if(!tempInput || tempInput == "" || tempInput != getVersion())
		{
			clearHighScores();
			store("FinityFlight","version", getVersion() + "");
		}
		
		tempInput = retrieve("FinityFlight","levelsOpened");
		if(!tempInput || tempInput == "")
		{
			levelsOpened = 1;
			store("FinityFlight","levelsOpened", "" + levelsOpened);
		}
		else
			levelsOpened = tempInput.tointeger();
			
		//Load the high scores in!  =D
		highScores = [];
		replays = [];
		targetScores = [];
		startingWeapons = [];
		local curLevel = 1;
		while(curLevel <= ::totalLevels)
		{
			local curLevelName = "FinityFlight-Level" + curLevel;
			highScores.append([]);
			replays.append([]);
			startingWeapons.append([]);
			local curHighScore = 0;
			tempInput = retrieve(curLevelName,"targetScore");
			if(!tempInput || tempInput == "")
			{
				targetScores.append(1000);
				tempInput = " " + targetScores[curLevel-1];
				store(curLevelName,"targetScore", tempInput);
			}
			else
				targetScores.append(tempInput.tointeger());
			while(curHighScore < 5)
			{
				local curVariableName = "Score" + curHighScore;
				tempInput = retrieve(curLevelName,curVariableName);
				if(!tempInput || tempInput == "")
				{
					highScores[curLevel-1].append(-1);
					tempInput = " " + highScores[curLevel-1][curHighScore];
					store(curLevelName,curVariableName, tempInput);
				}
				else
					highScores[curLevel-1].append(tempInput.tointeger());
				local curVariableName = "StartingWeapon" + curHighScore;
				tempInput = retrieve(curLevelName,curVariableName);
				if(!tempInput || tempInput == "")
				{
					startingWeapons[curLevel-1].append(0);
					tempInput = " " + startingWeapons[curLevel-1][curHighScore];
					store(curLevelName,curVariableName, tempInput);
				}
				else
					startingWeapons[curLevel-1].append(tempInput.tointeger());
				local curVariableName = "Replay" + curHighScore;
				tempInput = retrieve(curLevelName,curVariableName);
				if(!tempInput || tempInput == "")
				{
					replays[curLevel-1].append("");
					tempInput = replays[curLevel-1][curHighScore];
					store(curLevelName,curVariableName, tempInput);
				}
				else
					replays[curLevel-1].append(tempInput);
				curHighScore++;
			}
			curLevel++;
		}
	}

	function update(t)
	{
	}
	
	function levelIsComplete()
	{
		if(::currentLevel >= levelsOpened)
		{
				levelsOpened = ::currentLevel + 1;
			if(levelsOpened > ::totalLevels)
				levelsOpened = ::totalLevels;
			store("FinityFlight","levelsOpened", "" + levelsOpened);
		}
		local targetHighScore = 5;
		while(targetHighScore > 0 && ::level.scoreKeeper.score > highScores[::currentLevel-1][targetHighScore-1])
		{
			targetHighScore--;
		}
		if(targetHighScore == 5)
			return;
		::level.scoreRank = targetHighScore;
		local currentSwap = 4;
		while(currentSwap > targetHighScore)
		{
			highScores[::currentLevel-1][currentSwap] = highScores[::currentLevel-1][currentSwap-1];
			startingWeapons[::currentLevel-1][currentSwap] = startingWeapons[::currentLevel-1][currentSwap-1];
			replays[::currentLevel-1][currentSwap] = replays[::currentLevel-1][currentSwap-1];
			currentSwap--;
		}
		highScores[::currentLevel-1][targetHighScore] = ::level.scoreKeeper.score;
		startingWeapons[::currentLevel-1][targetHighScore] = ::level.weaponStartedWith;
		replays[::currentLevel-1][targetHighScore] = ::level.controls.saveReplay();
		targetScores[::currentLevel-1] = ::level.scoreKeeper.parScore;
		store("FinityFlight-Level" + ::currentLevel,"targetScore", " " + targetScores[::currentLevel-1]);
	
		local curLevel = 1;
		local tempInput;
		local curLevelName = "FinityFlight-Level" + ::currentLevel;
		local curHighScore = targetHighScore;
		while(curHighScore < 5)
		{
			local curVariableName = "Score" + curHighScore;
			
			tempInput = " " + highScores[::currentLevel-1][curHighScore];
			store(curLevelName,curVariableName, tempInput);
			
			curVariableName = "StartingWeapon" + curHighScore;
			
			tempInput = " " + startingWeapons[::currentLevel-1][curHighScore];
			store(curLevelName,curVariableName, tempInput);
			
			curVariableName = "Replay" + curHighScore;
			
			tempInput = replays[::currentLevel-1][curHighScore];
			store(curLevelName,curVariableName, tempInput);
			
			curHighScore++;
		}
	}
	
	function clearHighScores()
	{
		local curLevel = 1;
		while(curLevel <= ::totalLevels)
		{
			local curLevelName = "FinityFlight-Level" + curLevel;
			local curHighScore = 0;
			while(curHighScore < 5)
			{
				local curVariableName = "Score" + curHighScore;
				store(curLevelName,curVariableName,"");
				local curVariableName = "StartingWeapon" + curHighScore;
				store(curLevelName,curVariableName,"");
				local curVariableName = "Replay" + curHighScore;
				store(curLevelName,curVariableName, "");
				curHighScore++;
			}
			curLevel++;
		}
	}
}
