class ScoreKeeper			//Responsible for tracking and drawing score.
{
	score = 0;
	
	parScore = 10000;
	
	//Multiplier that builds as the player kills enemies without being damaged.
	streakMultiplier = 1;
	nextStreakKillRequirement = null;
	currentStreakKills = 0;
	
	//Multiplier that builds as the player quickly makes consecutive kills.  
	//Resets if no kills are made after a set time limit (below)
	comboMultiplier = 1;
	nextComboKillRequirement = null;
	currentComboKills = 0;
	
	comboTimeLimit = 8.00;
	comboTimeLeft = 0;
	
	scoresOnscreen = null;
	scoreLifeSpan = 2.00;
	
	scoreEnabled = true;
	
	
	function constructor()
	{
		scoresOnscreen = [];
		nextStreakKillRequirement = [4, 8, 16, 24];
		nextComboKillRequirement = [3, 6, 9, 12];

	}
	
	function update(t)
	{
		comboTimeLeft -= t;
		if (comboTimeLeft <= 0)
		{
			comboTimeLeft = 0;
			comboMultiplier -= 1;
			if (comboMultiplier < 1)
				comboMultiplier = 1;
			currentComboKills = 0;
		}
		
		for (local i = 0; i < scoresOnscreen.len(); i++)		
		{
			local thisScore = scoresOnscreen[i];
			thisScore.time -= t;
			if (thisScore.time <= 0)
			{
				scoresOnscreen.remove(i);
				i--;
			}
			thisScore.pos = add2(thisScore.pos,scale2(thisScore.vel,t));
			thisScore.vel = sub2(thisScore.vel,scale2(thisScore.vel,t));
		}
		
	}
	
	function draw(t)
	{
		for (local i = 0; i < scoresOnscreen.len(); i++)		
		{
			local thisScore = scoresOnscreen[i];
			local alpha = thisScore.time/scoreLifeSpan;
			local hughHefner = ((thisScore.time*10)%2)*0.05;
			font(getArcadePrefix("FinityFlight")+"data/f500.ttf",28);
			fillColor(0,0,0,alpha*0.5);
			cursorText(thisScore.text,thisScore.pos[0]+2,thisScore.pos[1]+2,1000,0,0);
			
			local rgb = hsvToRgb([0.06+hughHefner,1,1]);
			
			fillColor(rgb[0],rgb[1],rgb[2],alpha);
			cursorText(thisScore.text,thisScore.pos[0],thisScore.pos[1],1000,0,0)
		}
		
		
		
	}
	
	
	function addScore(position, velocity, points, typeID)
	{
		if(scoreEnabled)
		{
			local totalPointValue = points * (streakMultiplier + comboMultiplier - 1);
			local camPos = ::level.camera.pos;
			local tempScore = {pos=position, vel=velocity, value = totalPointValue, text="+"+totalPointValue, time=scoreLifeSpan}; //x"+streakMultiplier+" x"+comboMultiplier
			scoresOnscreen.append(tempScore);
			
			score += totalPointValue;

			::level.hud.addHUDScore(totalPointValue, typeID);
		}
	}
	
	function addKill()
	{
		currentStreakKills += 1;	
		currentComboKills += 1;
		
		if (streakMultiplier < nextStreakKillRequirement.len() + 1)
		{
			if (currentStreakKills > nextStreakKillRequirement[streakMultiplier - 1])
			{
				currentStreakKills = 0;
				streakMultiplier += 1;
				//if (nextStreakKillRequirement.len() <= streakMultiplier - 1)
					//streakMultiplier = nextStreakKillRequirement.len() - 1;
			}
		}
		
		if (comboMultiplier < nextComboKillRequirement.len() + 1)
		{
			if (currentComboKills > nextComboKillRequirement[comboMultiplier - 1])
			{
				currentComboKills = 0;
				comboMultiplier += 1;
				//if (nextComboKillRequirement.len() <= comboMultiplier - 1)
				//	comboMultiplier = nextComboKillRequirement.len() - 1;
			}
		}
		
		comboTimeLeft = comboTimeLimit;

	}
	
	function playerHit()
	{
		//In the future, consider having the streak multiplier only go down by a percentage when the player is hit,
		//	rather than resetting to zero.
		streakMultiplier -= 1;
		if (streakMultiplier < 1)
			streakMultiplier = 1;
		currentStreakKills = 0;
	}
	
	function getParPercent()
	{
		local numberOf100s = floor(score / parScore);
		local multiplier = 1.0 + (0.30 * numberOf100s);
		local returnPercent = numberOf100s * 100;
		local tempScore = score - (parScore * numberOf100s);
		returnPercent += (tempScore / (parScore * multiplier)) * 100.0
		return returnPercent;
	}
}


