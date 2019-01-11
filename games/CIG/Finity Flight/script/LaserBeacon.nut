class LaserBeacon
{
	name="";
	owner=null;
	img = null;
	imgScale = 1;
	
	target = null;
	
	lifeSpan = 3.0;
	laserWidth = 20;
	laserLength = 0.0;
	damage = 40;		//Damage Per Second
	textureCounter=0;
	laserCollided = false;
	
	constructor(name, target)
	{		
		this.name = name;
		this.target = target;
		this.img = getArcadePrefix("FinityFlight")+"data/flare.png";
	}
	
	function update(t)
	{
		if (::level.player.mods[1]["ship"].health <= 0)
			owner.remove = true;
		lifeSpan -= t;
		if (lifeSpan <= 0)
			owner.remove = true;
			
		local laserStartPos = target.pos;
		local beaconToTarget = sub2(owner.pos, target.pos);
		local laserDirection = normalize2(beaconToTarget);
		laserLength = length2(beaconToTarget);
		
	//	if(laserLength>1500)
	//		owner.remove = true;
		
		//local collidesList = ::level.enemies.collides(0, laserStartPos, laserDirection, laserLength, laserWidth);
		//foreach(node in collidesList)
		//{
		//	local dyne = node.dyne;
		//	local dir = scale2(laserDirection,damage*t*3);
		//	dyne.mods[1]["ship"].damage(damage * t,dir);
		//}
		
			laserCollided = false;
			
			local collidesList = ::level.enemies.collides(0, laserStartPos, laserDirection, laserLength, laserWidth);
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
						laserCollided = true;
					}
				}
				else
				{
					notShieldList[node.dyne.name] <- node;
				}
			}
			if(collidedShield)
			{
					collidedShield.mods[4]["shield"].damage(damage * t, "laser");
			}
			
			local insideCollidesList = ::level.enemies.collidesInside(notShieldList, 51, laserStartPos, laserLength);
			
			foreach(node in insideCollidesList)
			{
				local dir = scale2(laserDirection,damage*3*t);
				node.dyne.mods[1]["ship"].damage(damage * t,dir);
			}
		return true;
	}
	
	function draw(t)
	{
		local laserStartPos = sub2(target.pos,owner.pos);
		local laserEndPos = [0,0];
		local formerLaserLength = length2(laserStartPos);
		laserEndPos = add2(laserEndPos, scale2(laserStartPos, (formerLaserLength - laserLength) / formerLaserLength));
		local laserForward = normalize2(laserStartPos);
		local laserRight = quarterCW2(laserForward);
		local laserHalfWidth = scale2(laserRight,laserWidth/2);
		
		local br = add2(laserStartPos,laserHalfWidth);
		local bl = sub2(laserStartPos,laserHalfWidth);
		local tr = add2(laserEndPos,laserHalfWidth);
		local tl = sub2(laserEndPos,laserHalfWidth);
		
		additiveBlending(true);
		image(getArcadePrefix("FinityFlight")+"data/Laser.png",1,1);
		local alpha = 1;
		if(lifeSpan<0.2) {
			alpha = lifeSpan/0.2;
		}
		//fillColor(0.9,0.8,1,alpha*0.6);
		fillColor(1,1,1,alpha);
		
		beginTriangles();
		textureCoord(0,0+textureCounter);
		vertex(br[0],br[1]);
		textureCoord(1,0+textureCounter);
		vertex(bl[0],bl[1]);
		textureCoord(1,5+textureCounter);
		vertex(tl[0],tl[1]);
		
		textureCoord(0,0+textureCounter);
		vertex(br[0],br[1]);
		textureCoord(1,5+textureCounter);
		vertex(tl[0],tl[1]);
		textureCoord(0,5+textureCounter);
		vertex(tr[0],tr[1]);
		endTriangles();
		
		textureCounter-= 5.0 * t;
		
		local imageSize = image(img,1,1);
		modifyWindow(0,0,imageSize[0],imageSize[1],2,-owner.r,false);
		fillColor(0.7,0.4,1,alpha);
		rect(0,0,imageSize[0],imageSize[1]);
		revertWindow();
		
		modifyWindow(0,0,imageSize[0],imageSize[1],7,-owner.r,false);
		fillColor(0.7,0.4,1,alpha*0.4);
		rect(0,0,imageSize[0],imageSize[1]);
		revertWindow();
	}
}
