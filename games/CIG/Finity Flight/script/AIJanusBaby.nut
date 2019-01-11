class AIJanusBaby extends AIBase
{
		firstFunTarget = null;
		secondFunTarget = null;
		positionMode = 0;
		positionChangeTimer = 5.0;
		preferredDistance = 300.0;
		shipSpread = 250.0;
	
		isDominantTwin = false;
	
		constructor(name, firstTarg, secondTarg)
		{
			this.name = name;
			firstFunTarget = firstTarg;
			secondFunTarget = secondTarg;
			funspaceTarget = firstTarg;
		}
		
		function update(t)
		{
			if(!(owner.mods[1].rawin("ship")) || !(::level.enemies.dynes.rawin(owner.mods[1]["ship"].twinName)))
			return false;
			local ship = owner.mods[1]["ship"];	
			if(isDominantTwin)
			{
				local twin = ::level.enemies.dynes[ship.twinName];
				local twinAI = ::level.enemies.dynes[ship.twinName].mods[0]["pilot"];
			
				positionChangeTimer -= t;
				if(positionChangeTimer <= 5)
				{
					local pointBetweenShips = scale2(add2(twin.pos, owner.pos), 0.5);
					local vectorFromPlayer = sub2(pointBetweenShips, level.player.pos);
					local vectorFromPlayerLength = length2(vectorFromPlayer);
					if(vectorFromPlayerLength < 0.001)
					{
						vectorFromPlayer = [0.0, 1.0];
						vectorFromPlayerLength = 1.0;
					}
					//This moves the point between the ships to where it preferrably SHOULD be
					vectorFromPlayer = scale2(vectorFromPlayer, ((preferredDistance) / vectorFromPlayerLength));
					local normalLine = normalize2(quarterCW2(vectorFromPlayer));
					local vectorToTwin = sub2(twin.pos, owner.pos);
					if(dot2(normalLine, vectorToTwin) < 0)
						normalLine = scale2(normalLine, -shipSpread);
					else
						normalLine = scale2(normalLine, shipSpread);
					//funToGlobal_noRot
					funspaceTarget = add2(vectorFromPlayer, normalLine);
					twinAI.funspaceTarget = add2(vectorFromPlayer, negate2(normalLine));
					if (positionChangeTimer <= 0)
					{
						local tempFunspaceTarget = funspaceTarget;
						funspaceTarget = negate2(twinAI.funspaceTarget);
						twinAI.funspaceTarget = negate2(tempFunspaceTarget);
						positionChangeTimer = 7.0;
					}
				}
			}
		
			headTowardFunTarget(ship);
			
			if(ship.health <= 0)
				::level.enemies.dynes[ship.twinName].mods[1]["ship"].lastDamageDirection = ship.lastDamageDirection;
				
			
			return true;
		}
		
		function draw(t)
		{
			return true;
		}
		
		
		function mergeWithTwin()
		{
		}
}