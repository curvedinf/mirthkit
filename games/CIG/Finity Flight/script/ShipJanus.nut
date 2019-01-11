class ShipJanus extends Ship
{
	
	function update(t)
	{
		if(health<=0)
		{
			owner.remove = true;
			makeDeathExplosion();	//Change this to unique explosion.
			spawnJanusBabies();
			return true;
		}
	
		owner.push(scale2(owner.forward,thrustAmount*thrustMax*t));
		owner.spin(turnAmount*turnMax*t);
		
		local proj = scale2(project2(owner.vel,quarterCW2(owner.forward)),rotFriction*t);
		local directedVel = sub2(owner.vel,proj);
		
		local velMag = length2(proj)*0.4+length2(directedVel)*(1-(friction*t));
		
		if(!sliding)
			owner.vel = scale2(normalize2(directedVel),velMag);
		else
			owner.vel = owner.vel;
		sliding = false;
		
		owner.rv -= owner.rv*rotFriction*t;
		
		return true;
	}
	
	function spawnJanusBabies()
	{
		local name1 = "JanusBaby:"+::level.enemySpawner.spawnCounter+"Dom";
		local name2 = "JanusBaby:"+::level.enemySpawner.spawnCounter+"Sub";
		local targetInfo = getJanusBabyFunTargets();
		local leftPos = scale2(quarterCCW2(owner.forward), 10.0);
		local rightPos = scale2(quarterCW2(owner.forward), 10.0);
		
		for (local i = 0; i < 2; i++)
		{
			local startPos = add2(owner.pos, leftPos);
			local thisName = name1;
			local otherName = name2;
			local isDom = true;
			local target1 = [-100,0];//targetInfo.domTarget1;
			local target2 = [100,0];//targetInfo.domTarget2;
			if (i == 1) 
			{
				startPos = add2(owner.pos, rightPos);
				thisName = name2;
				otherName = name1;
				isDom = false;
				startPos[0] += 100;
				target1 = targetInfo.subTarget1;
				target2 = targetInfo.subTarget2;
			}

			local ship = Dyne(thisName,startPos[0],startPos[1],::level.friends.dynes["player"].r,1.0,32);
			local imagePath = getArcadePrefix("FinityFlight")+"data/JanusLeft.png";
			if(i==1)
				imagePath = getArcadePrefix("FinityFlight")+"data/JanusRight.png"
			ship.addMod(ShipJanusBaby("ship",40,imagePath,scale,1200,0.8,1800,4.8, otherName, isDom),1);
			ship.vel[0] = owner.vel[0];
			ship.vel[1] = owner.vel[1];
			ship.r = owner.r;
			//ship.mods[1]["ship"].color = [0.3, 0.5, 0.5, 1.0];	//DEBUG
			
			ship.addMod(Thruster("thruster1",0,46,0.8,0,1),2);
			ship.addMod(Streamer("streamer1",0,-46,2,10),2);
			
			ship.addMod(AIJanusBaby("pilot", target1, target2),0);	
			ship.mods[1]["ship"].typeID = "Janus";
			ship.mods[1]["ship"].scoreAmount = 300;
			
			::level.enemies.addDyne(ship);
		}
		::level.enemies.dynes[name1].mods[0]["pilot"].isDominantTwin = true;
		
		::level.enemySpawner.spawnCounter++		
		
	}
	
	function getJanusBabyFunTargets()
	{
		local vecToPlayer = sub2(::level.funspace.pos, this.owner.pos);
		local dirToPlayer = normalize2(vecToPlayer);
		local globalTarget = scale2(dirToPlayer, 200);
		local babyAtarget0 = scale2(quarterCCW2(dirToPlayer), 300);						//These quarterCircle functions are backwards
		local babyBtarget0 = scale2(quarterCW2(dirToPlayer), 300);
		local babyAtarget1 = add2(babyAtarget0, scale2(dirToPlayer, -70));
		local babyBtarget1 = add2(babyBtarget0, scale2(dirToPlayer, -70));
		babyAtarget1 = sub2(babyAtarget0, vecToPlayer);
		babyBtarget1 = sub2(babyBtarget0, vecToPlayer);
		local babyAtarget2 = add2(babyAtarget0, scale2(dirToPlayer, 500));
		local babyBtarget2 = add2(babyBtarget0, scale2(dirToPlayer, 500));
		
		babyAtarget1[0] *= -1; //scale2(babyAtarget1, -1); //::level.funspace.globalToFun(babyAtarget1);
		babyBtarget1[0] *= -1; //scale2(babyBtarget1, -1); //::level.funspace.globalToFun(babyBtarget1);
	//	babyAtarget2 = ::level.funspace.globalToFun_noRot(babyAtarget2);
	//	babyBtarget2 = ::level.funspace.globalToFun_noRot(babyBtarget2);
		
	//	babyAtarget1 = [200, -200];
	//	babyBtarget1 = [-200, -200];
	//	babyAtarget2 = [200, 200];
	//	babyBtarget2 = [-200, 200];
		
		return { domTarget1 = babyAtarget1, domTarget2 = babyAtarget2, subTarget1 = babyBtarget1, subTarget2 = babyBtarget2 };
	}
	
	function makeDeathExplosion()
	{
		local particle = Dyne("p" + ::particleNum,owner.pos[0],owner.pos[1],0,1,32);
		::particleNum += 1;
		particle.addMod(Particle("particle",0.05,getArcadePrefix("FinityFlight")+"data/flare.png",6,1,1,1,1,0.1,true),1);
		::level.topParticles.addDyne(particle);
		
		for(local i=0;i<1;i++)
		{
			particle = Dyne("p" + ::particleNum,owner.pos[0],owner.pos[1],0,1,32);
			::particleNum += 1;
			particle.addMod(Particle("particle",2,getArcadePrefix("FinityFlight")+"data/smoke.png",3,15,0.3,0.3,0.3,1,false),1);
			particle.push([rand()%50-25+lastDamageDirection[0],rand()%50-25+lastDamageDirection[1]]);
			particle.spin(rand()%300-150);
			::level.bottomParticles.addDyne(particle);
			
			particle = Dyne("p" + ::particleNum,owner.pos[0],owner.pos[1],0,1,32);
			::particleNum += 1;
			particle.addMod(Particle("particle",0.4,getArcadePrefix("FinityFlight")+"data/smoke.png",3,14,0.9,0.5,0.1,0.9,true),1);
			particle.push([rand()%80-40+lastDamageDirection[0],rand()%80-40+lastDamageDirection[1]]);
			particle.spin(rand()%300-150);
			::level.topParticles.addDyne(particle);
		}
		
		particle = Dyne("p" + ::particleNum,owner.pos[0],owner.pos[1],0,1,32);
		::particleNum += 1;
		particle.addMod(Particle("particle",0.1,getArcadePrefix("FinityFlight")+"data/flare.png",10,0.1,1,1,1,1,true),1);
		particle.push([rand()%40-20+lastDamageDirection[0],rand()%40-20+lastDamageDirection[1]]);
		::level.topParticles.addDyne(particle);
		
		local particle = Dyne("p" + ::particleNum,owner.pos[0]+lastDamageDirection[0]/5,owner.pos[1]+lastDamageDirection[1]/5,0,1,32);
		::particleNum += 1;
		particle.addMod(Particle("particle",0.15,getArcadePrefix("FinityFlight")+"data/debris.png",6,10,0.5,0.5,1,1,true),1);
		particle.r = getDegrees2(lastDamageDirection);
		particle.rv = 0;
		particle.push(scale2(lastDamageDirection,2));
		::level.bottomParticles.addDyne(particle);
		
		local myPos = owner.pos;
		local playerPos = ::level.friends.dynes["player"].pos;
		
		local playerToMe = sub2(myPos,playerPos);
		local normalizedDistance = scale2(playerToMe,1/100.0);
		local directionDegrees = getDegrees2(playerToMe);
		
		sound(getArcadePrefix("FinityFlight")+"data/explosion.wav",directionDegrees,normalizedDistance);
	}
}
