primaryLaserCannon <- null;

class LaserCannon
{
	name="";
	owner=null;
	x=0;
	y=0;
	r=0;
	beaconNum = 0;
	
	weaponActive = true;
	
	cooldown = 0;
	secondaryCooldown = 0;
	refire = 1.00;
	laserLifespan = 0.6;
	currentLaserTime = 0.0;
	textureCounter = 0.0;

	damage = 80;			//Damage Per Second
	laserRadius = 12.5;
	laserMaxLength = 1500;
	laserLength = 1500;
	
	
	constructor(name,x,y,r)
	{
		this.name = name;
		this.x = x;
		this.y = y;
		this.r = r;
	}

	function update(t)
	{
	
		if(::primaryLaserCannon == this)
		{
			::primaryLaserCannon = null;
		}
		cooldown -= t;
		if(cooldown<0)
			cooldown = 0;
		secondaryCooldown -= t;
		if(secondaryCooldown < 0)
			secondaryCooldown = 0;
		currentLaserTime -= t;
		if(currentLaserTime < 0 || ! weaponActive)
			currentLaserTime = 0;	
	
		if(currentLaserTime > 0)	//If true, laser is firing.
		{
			laserLength = laserMaxLength;
			local laserStartPos = add2(owner.pos, rotateDegrees2([this.x, this.y-30], r + owner.r));
			local laserDirection = setDegrees2(r + owner.r);
			
			local collidesList = ::level.enemies.collides(0, laserStartPos, laserDirection, laserLength, laserRadius);
			local collidedShield = null;
			local notShieldList = {};
			foreach(node in collidesList)
			{
				if(node.collType == 1)
				{
					local curLength = length2(sub2(laserStartPos,node.collPoint));
					if(curLength < laserLength)
					{
						laserLength = curLength;
						collidedShield = node.dyne;
					}
				}
				else
				{
					notShieldList[node.dyne.name] <- node;
				}
			}
			if(collidedShield)
				collidedShield.mods[4]["shield"].damage(damage * t, 2);
			
			local insideCollidesList = ::level.friends.collidesInside(notShieldList, 51, laserStartPos, laserLength);
			
			foreach(node in insideCollidesList)
			{
				local dir = scale2(laserDirection,damage*t*3);
				node.dyne.mods[1]["ship"].damage(damage * t,dir);
			}
		}
			
		return true;
	}

	function draw(t)
	{
		if (currentLaserTime > 0)
		{
			local laserStartPos = [this.x, this.y-30];
			local laserForward = setDegrees2(r);
			local laserEndPos = scale2(laserForward, laserLength);
			local laserRight = quarterCW2(laserForward);
			local laserDrawRadius = scale2(laserRight,laserRadius*2);
			local laserExpand = laserLength / 160.0;
			
			local br = add2(laserStartPos,laserDrawRadius);
			local bl = sub2(laserStartPos,laserDrawRadius);
			local tr = add2(laserEndPos,laserDrawRadius);
			local tl = sub2(laserEndPos,laserDrawRadius);
			
			
			additiveBlending(true);
			image(getArcadePrefix("FinityFlight")+"data/Laser.png",1,1);
			local alpha = 1;
			if(currentLaserTime<0.2) 
			{
				alpha = currentLaserTime/0.2;
			}
			//fillColor(0.9,0.8,1,alpha*0.6);
			fillColor(1,1,1,alpha);
			
			beginTriangles();
			textureCoord(0,0+textureCounter);
			vertex(br[0],br[1]);
			textureCoord(1,0+textureCounter);
			vertex(bl[0],bl[1]);
			textureCoord(1,laserExpand+textureCounter);
			vertex(tl[0],tl[1]);
			
			textureCoord(0,0+textureCounter);
			vertex(br[0],br[1]);
			textureCoord(1,laserExpand+textureCounter);
			vertex(tl[0],tl[1]);
			textureCoord(0,laserExpand+textureCounter);
			vertex(tr[0],tr[1]);
			endTriangles();
			
			textureCounter-= 5.0 * t;
			
			local imageSize = image(getArcadePrefix("FinityFlight")+"data/flare.png",1,1);
			modifyWindow(this.x, this.y-30,imageSize[0],imageSize[1],2,-owner.r,false);
			fillColor(0.7,0.4,1,alpha);
			rect(0,0,imageSize[0],imageSize[1]);
			revertWindow();
			
			modifyWindow(this.x, this.y-30,imageSize[0],imageSize[1],7,-owner.r,false);
			fillColor(0.7,0.4,1,alpha*0.4);
			rect(0,0,imageSize[0],imageSize[1]);
			revertWindow();
			
			for(local i = 0; i < 5; i++)
			{
				modifyWindow(laserEndPos[0], laserEndPos[1],imageSize[0],imageSize[1],1.0,0,false);
				fillColor(0.7,0.4,1,alpha*0.5);
				rect(0,0,imageSize[0],imageSize[1]);
				revertWindow();
			}
			
		}
	}

	function fire()
	{
		if(cooldown<=0 && secondaryCooldown<=0 && weaponActive)
		{
				currentLaserTime = laserLifespan;
				cooldown = refire;
				sound(getArcadePrefix("FinityFlight")+"data/laser.wav",0,0)
		}
	}
	
	function secondaryFire()
	{
		if (weaponActive && owner.mods[0]["pilot"].secondaryWeaponRecharge <= 0)
		{
			local angle = getDegrees2(owner.forward) + 45.0;
			for (local i = 0; i < 4; i++)
			{
				local beacon = Dyne(this.name + "laserBeacon"+i+":"+beaconNum,owner.pos[0],owner.pos[1],0,1,25);
				beacon.addMod(LaserBeacon(beacon.name+"beaconMod", ::level.friends.dynes["player"]), 1);
				beacon.push(scale2(owner.vel, 1.0));
				beacon.push(scale2(setDegrees2(angle), 400.0));
				beaconNum++;
				angle += 90.0;
				::level.friendsShots.addDyne(beacon);
			}
			
			secondaryCooldown = 0.5;
			owner.mods[0]["pilot"].secondaryWeaponRecharge = 13.0;
		}
	}
}
