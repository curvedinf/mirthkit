primaryRocketLauncher <- null;

class RocketLauncher
{
	name="";
	owner=null;
	x=0;
	y=0;
	r=0;
	shotnum=0;
	shotSequencePlacement = null;
	shotSeqNum = 0;
	
	weaponActive = true;
	
	cooldown=0;
	secondaryCooldown=0;
	refire=1.0;
	
	rocketBurstFireRate = 0.02;
	rocketBurstSize = 20;
	rocketBurstFireTimer = 0;
	rocketBurstFireNumber = -1;
	damage = 3.0;
	collisionRadius = 64;
	projectileLifeSpan = 1.5;
	
	secondaryShotCount = 15;
	secondaryCurrentShot = 0;
	secondaryInterval = 0.1;
	secondaryFireTimer = 0;
	
	
	constructor(name,x,y,r)
	{
		this.name = name;
		this.x = x;
		this.y = y;
		this.r = r;
		
		shotSequencePlacement = [[0,0],[-15,0],[15,0],[-25,0],[25,0]]; 
	}
	
	function update(t)
	{
		if(::primaryRocketLauncher == this)
		{
			::primaryRocketLauncher = null;
		}
		
		cooldown -= t;
		if(cooldown<0)
			cooldown = 0;
		secondaryCooldown -= t;
		if(secondaryCooldown < 0)
			secondaryCooldown = 0;
		if (weaponActive == false)
			rocketBurstFireNumber = -1;
			
		if (rocketBurstFireNumber != -1)	//if not -1, we should be looking to shoot rockets.
		{
			rocketBurstFireTimer -= t;
			if (rocketBurstFireTimer <= 0)
			{
				local localStart = rotateDegrees2(shotSequencePlacement[shotSeqNum], r + owner.r);
				local rocketPos = add2(owner.pos, rotateDegrees2([this.x, this.y], r + owner.r));
				rocketPos = add2(rocketPos, localStart);
				
				local forward = setDegrees2(owner.r + r);
				local right = quarterCW2(forward);
				
				local forwardComponent = scale2(forward,length2(owner.vel)*0.75);
				local rightComponent = scale2(right,rand()%300-150);
				
				local rocketVel = add2(forwardComponent,rightComponent);
				
				local shot = Dyne(owner.name+name+"burst"+shotnum+"rocketNum"+rocketBurstFireNumber, rocketPos[0], rocketPos[1], owner.r+r, 1, collisionRadius);
				shot.addMod(Rocket("rocket",damage,getArcadePrefix("FinityFlight")+"data/Rocket.png",2.0,projectileLifeSpan,::level.enemies),1);
				shot.push(rocketVel);
				
				//shot.addMod(Streamer("streamer1",0,-8,1,2),2);
				
				::level.friendsShots.addDyne(shot);
				
				if(primaryRocketLauncher == null)
				{
					primaryRocketLauncher = this;
					sound(getArcadePrefix("FinityFlight")+"data/Rocket.wav",0,0)
				}
				
				shotnum+=1;
				shotSeqNum += 1;
				if (shotSeqNum > 4) 
					shotSeqNum = 0;
				rocketBurstFireTimer = rocketBurstFireRate;
				rocketBurstFireNumber += 1;
				if(rocketBurstFireNumber >= rocketBurstSize)
					rocketBurstFireNumber = -1;
			}
		}
		
		if(secondaryCurrentShot>0)
		{
			secondaryFireTimer -= t;
			if (secondaryFireTimer <= 0)
			{
				local rocketDirection = (1.0*secondaryCurrentShot)/secondaryShotCount*360*3;
				
				local rocketStartPos = add2(owner.pos, rotateDegrees2([this.x, this.y], r + owner.r));
				local rocketStartVel = add2(scale2(owner.vel,1.5), scale2(setDegrees2(owner.r+r+rocketDirection), 500));
				local shot = Dyne(owner.name+name+"m"+secondaryCurrentShot, rocketStartPos[0], rocketStartPos[1], owner.r+r+rocketDirection, 1, collisionRadius);
				shot.addMod(Missile("missile",damage * 15,1,projectileLifeSpan * 2,::level.enemies),1);
				shot.push(rocketStartVel);
			
				shot.addMod(Streamer("streamer1",0,0,3,30),2);
				shot.mods[2]["streamer1"].countdownLength = 0.05;
				
				::level.friendsShots.addDyne(shot);
				secondaryFireTimer = secondaryInterval;
				secondaryCurrentShot-=1;
			}
		}
		return true;
	}
	
	function draw(t)
	{
	
	}
	
	function fire()
	{
		if(cooldown<=0 && secondaryCooldown <= 0 && weaponActive)
		{
			if (rocketBurstFireNumber == -1)
			{
				rocketBurstFireNumber = 0;
				rocketBurstFireTimer = rocketBurstFireRate;
				cooldown = refire;
			}
		}
	}
	
	function secondaryFire()
	{
		if (weaponActive && secondaryCurrentShot==0 && owner.mods[0]["pilot"].secondaryWeaponRecharge <= 0)
		{
			secondaryCurrentShot = secondaryShotCount;
			secondaryCooldown = 2.3;
			rocketBurstFireNumber = -1;
			owner.mods[0]["pilot"].secondaryWeaponRecharge = 13.0;
		}
	}
	
}
