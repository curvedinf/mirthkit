class EnemySpawner
{
	waves = null;
	currentWave = 0;
	waveTime = 0;
	activeEnemies  = 0;
	startingGnatSwarms = 4;
	madeStartingSwarms = false;
	activeGnatSwarms = 0;
	maxGnatSwarms = 4;
	
	spawnCounter = 0;
	swarmCounter = 0;
	
	swarmSpawnTimer = 0.0;
	swarmSpawnDelay = 2.0;
	swarmSize = 4;
	
	congrats = false;
	
	constructor()
	{
		waves = [[]];
	}
	
	function update(t)
	{
		waveTime += t;
		for (local i = 0; i < waves[currentWave].len(); i++)
		{
			local tempSpawn = waves[currentWave][i];
			if (tempSpawn.time <= waveTime && tempSpawn.spawned == false)
			{
				spawnEnemy(tempSpawn.number, tempSpawn.type, tempSpawn.subType);
				tempSpawn.spawned = true;
			}
		}
		
		if (!madeStartingSwarms)		//This can't go into the constructor because of the order things are created in getCurrentLevel()
		{
			spawnEnemy(startingGnatSwarms, "GnatSwarm", swarmSize);
			madeStartingSwarms = true;
		}
		
		swarmSpawnTimer -= t;
		if (swarmSpawnTimer <= 0 || congrats)
		{
			swarmSpawnTimer = swarmSpawnDelay;
			if(::level.scoreKeeper.comboTimeLeft > 0.0 || congrats)
			{
				if(activeGnatSwarms < maxGnatSwarms)
				{
					spawnEnemy(1, "GnatSwarm", swarmSize);
				}
			}
		}
			
		return true;
	}
	
	function draw(t)
	{
		
	}
	
	function addEnemyToWave(waveNumber, waveTime, numberOfEnemies, enemyType, enemySubtype)
	{
		local tempEntry = {time = waveTime, number = numberOfEnemies, type = enemyType, subType = enemySubtype, spawned = false};
		waves[waveNumber].push(tempEntry);
	}
	
	function spawnEnemy(number, type, subtype)
	{
		if (type == "GnatSwarm")
			for (local i = 0; i < number; i++)
			{
				makeGnatSwarm(subtype);
				activeGnatSwarms += 1;
			}
				
		if (type == "Regulus")
			for (local i = 0; i < number; i++)
			{
				makeRegulus(subtype);
				activeEnemies += 1;
			}
		
		if (type == "Naiad")
			for (local i = 0; i < number; i++)
			{
				makeNaiad(subtype);
				activeEnemies += 1;
			}

		if (type == "Janus")
			for (local i = 0; i < number; i++)
			{
				makeJanus(subtype);
				activeEnemies += 1;
			}
		
		if (type == "Hoplite")
			for (local i = 0; i < number; i++)
			{
				makeHoplite(subtype);
				activeEnemies += 1;
			}

		if (type == "Mercury")
			for (local i = 0; i < number; i++)
			{
				makeMercury(subtype);
				activeEnemies += 1;
			}
			
		::triedToSpawn = true;	
	}
	
	function enemyKilled()
	{
		activeEnemies -= 1;
		
		if (activeEnemies <= 0)
		{
			activeEnemies = 0;
			local waveDone = true;
			for (local i = 0; i < waves[currentWave].len(); i++)			//Check to see if all enemies have been spawned.
			{
				local tempSpawn = waves[currentWave][i];
				if (tempSpawn.spawned == false)
				{
					waveDone = false;													//If any haven't the wave isn't done.
				}
			}
			if (waveDone)
			{
				nextWave();
			}
		}
	}
	
	function swarmKilled()
	{
		activeGnatSwarms -= 1;
	}
	
	function nextWave()
	{
		waveTime = 0;
		if (currentWave < waves.len() - 1)
			currentWave += 1;
		else
			::level.endLevel();
	}
	
	function positionNearPlayer(entrySide)
	{
		local playerPos = ::level.friends.dynes["player"].pos;
		
		if(entrySide==null)
			entrySide = rand()%4;
		
		if(entrySide==0) // top
		{
			return add2(playerPos,[rand()%700-350,700]);
		} else if(entrySide==1) { // bottom
			return add2(playerPos,[rand()%700-350,-700]);
		} else if(entrySide==2) { // right
			return add2(playerPos,[700,rand()%700-350]);
		} else if(entrySide==3) { // left
			return add2(playerPos,[700,rand()%700-350]);
		}
	}
	
	function makeGnatSwarm(subtype)
	{
		local startPos = positionNearPlayer(null);
		local swarm = GnatSwarm("GnatSwarm:"+swarmCounter, subtype, startPos);
		swarmCounter++;
		
		for (local i = 0; i < subtype; i++)
		{
			local ship = Dyne("Gnat:"+spawnCounter + " Type " + subtype,startPos[0],startPos[1],::level.friends.dynes["player"].r,0.1,12);
			ship.addMod(Ship("ship",0.5,getArcadePrefix("FinityFlight")+"data/Gnat.png",1,200,0.8,500,4.0),1);
			if(congrats)
				ship.mods[1]["ship"].firework = true;
			ship.addMod(AIGnat("pilot", swarm, i),0);
			
			ship.mods[1]["ship"].typeID = "Gnat";
			ship.mods[1]["ship"].scoreAmount = 10;
			ship.mods[1]["ship"].isGnat = true;
			
			ship.addMod(Thruster("thruster1",0,10,0.3,0,0.3),2);
			ship.addMod(Streamer("streamer1",0,-1,1,4),2);
			ship.mods[2]["streamer1"].countdownLength = 0.05;
			
			::level.enemies.addDyne(ship);
			spawnCounter++
		}
		
		::level.gnatSwarms[swarm.name] <- swarm; 
	}
	
	function makeRegulus(subtype)
	{
		local startPos = positionNearPlayer(null);
		local ship = Dyne("Regulus:"+spawnCounter + " Type " + subtype,startPos[0],startPos[1],0,0.5,48);
		ship.addMod(Ship("ship",30,getArcadePrefix("FinityFlight")+"data/Regulus.png",1,600,0.8,800,6.0),1);
		
		ship.addMod(AIRegulus("pilot", subtype),0);
		
		local forwardGun = EnemyGun("gun0",20,0,0);  
		local backwardGun = EnemyGun("gun1",-20, 0,180); 
		ship.addMod(forwardGun, 3);
		ship.addMod(backwardGun, 3);
		
		ship.mods[1]["ship"].typeID = "Regulus";
		ship.mods[1]["ship"].scoreAmount = 100;
		
		local thrustHue = 75;
		if (subtype == -1)												
		{
			ship.mods[1]["ship"].color = [0.4, 0.4, 0.4, 1.0];	
		}
		if (subtype == 0)												
		{
			ship.mods[1]["ship"].color = [1.0, 1.0, 1.0, 1.0];	
		}
		if (subtype == 1)
		{
			ship.mods[1]["ship"].color = [0.85, 0.85, 1.0, 1.0];
			thrustHue = 160;
		}
		if (subtype == 2)
		{
			ship.mods[1]["ship"].color = [1.0, 0.45, 0.45, 1.0];
			thrustHue = 239;
			ship.mods[1]["ship"].typeID = "Super Regulus";
			ship.mods[1]["ship"].scoreAmount = 150;
			ship.mods[1]["ship"].health = 50;
			ship.mods[1]["ship"].originalHealth = 50;
			ship.mods[0]["pilot"].timeBetweenFireMin = 1.5;
			ship.mods[0]["pilot"].timeBetweenFireMax = 3.0;
		}
		
		ship.addMod(Thruster("thruster1",0,20,0.6,0,0.3),2);
		ship.addMod(Streamer("streamer1",25,-10,1,5),2);
		ship.addMod(Streamer("streamer2",-25,-10,1,5),2);
		
		::level.enemies.addDyne(ship);
		spawnCounter++		
	}
	
	function makeNaiad(subtype)
	{
		local startPos = positionNearPlayer(null);
		local ship = Dyne("Naiad:"+spawnCounter + " Type " + subtype,startPos[0],startPos[1],::level.friends.dynes["player"].r,0.5,48);
		ship.addMod(ShipNaiad("ship",50,getArcadePrefix("FinityFlight")+"data/NaiadBase.png",0.75,1500,0.8,600,4.8,
			getArcadePrefix("FinityFlight")+"data/NaiadProp.png"),1);
						
		//ship.mods[1]["ship"].color = [0.8, 0.2, 0.8, 1.0];	//DEBUG

		ship.addMod(AINaiad("pilot", subtype),0);
		
		local gun = NaiadGun("gun0",0,0,0,getArcadePrefix("FinityFlight")+"data/NaiadTurret.png");  
		ship.addMod(gun, 3);
		
		ship.mods[1]["ship"].typeID = "Naiad";
		ship.mods[1]["ship"].scoreAmount = 150;
		
		ship.addMod(Streamer("streamer1",25,0,1,4),2);
		ship.addMod(Streamer("streamer2",-25,0,1,4),2);
		
		::level.enemies.addDyne(ship);
		spawnCounter++		
	}
	
	function makeJanus(subtype)
	{
		local startPos = positionNearPlayer(null);
		local ship = Dyne("Janus:"+spawnCounter + " Type " + subtype,startPos[0],startPos[1],::level.friends.dynes["player"].r,2.0,48);
		ship.addMod(ShipJanus("ship",50,getArcadePrefix("FinityFlight")+"data/Janus.png",1.0,1500,0.8,1800,4.8),1);
						
		//ship.mods[1]["ship"].color = [0.3, 0.3, 0.33, 1.0];	//DEBUG

		ship.addMod(AIJanus("pilot", subtype),0);
		
		local gun = NaiadGun("gun0",0,20,0,getArcadePrefix("FinityFlight")+"data/JanusTurret.png");  
		ship.addMod(gun, 3);
		
		ship.mods[1]["ship"].typeID = "Janus";
		ship.mods[1]["ship"].scoreAmount = 300;
		
		ship.addMod(Thruster("thruster1",13,46,0.8,0,1),2);
		ship.addMod(Streamer("streamer1",13,-46,2,10),2);
		
		ship.addMod(Thruster("thruster2",-13,46,0.8,0,1),2);
		ship.addMod(Streamer("streamer2",-13,-46,2,10),2);
		
		::level.enemies.addDyne(ship);
		spawnCounter++		
	}
	
	function makeHoplite(subtype)
	{
		local startPos = positionNearPlayer(null);

		local ship = Dyne("Hoplite:"+spawnCounter + " Type " + subtype,
						startPos[0],startPos[1],::level.friends.dynes["player"].r,5.0,20);
		ship.addMod(Ship("ship",90,getArcadePrefix("FinityFlight")+"data/Hoplite.png",1,4100,0.8,6000,4.8),1);
					
		//ship.mods[1]["ship"].color = [0.0, 1, 0.0, 1.0];	//DEBUG

		ship.addMod(AIHoplite("pilot", subtype),0);
		
		local gun = EnemyGun("gun0",0,20,0);  
		ship.addMod(gun, 3);
		
		ship.mods[1]["ship"].typeID = "Hoplite";
		ship.mods[1]["ship"].scoreAmount = 400;
		
		ship.addMod(Shield("shield", 300, 50, 120, 0.5),4);
		ship.mods[4]["shield"].color = [1.0, 1.0, 0.0, 1.0];
		
		::level.enemies.addDyne(ship);
		spawnCounter++		
	}
	
	function makeMercury(subtype)
	{
		local startPos = positionNearPlayer(null);
		local ship = Dyne("Mercury:" + spawnCounter + " Type " + subtype,startPos[0],startPos[1],::level.friends.dynes["player"].r,1.7,48);
		ship.addMod(Ship("ship",250,getArcadePrefix("FinityFlight")+"data/Mercury.png",1,2000,0.8,1200,4.8),1);
						
		//ship.mods[1]["ship"].color = [0.2, 0.7, 0.2, 1.0];	//DEBUG

		ship.addMod(AIMercury("pilot", subtype),0);
		
		local gun = GiantLaser("gun0",0,20,0);  
		ship.addMod(gun, 3);
		
		ship.mods[1]["ship"].typeID = "Mercury";
		ship.mods[1]["ship"].scoreAmount = 500;
		
		ship.addMod(Thruster("thruster1",0,60,1,0,1),2);
		ship.addMod(Streamer("streamer1",0,-60,5,10),2);
		
		::level.enemies.addDyne(ship);
		spawnCounter++;
	}
}
