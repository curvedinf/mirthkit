class ShipJanusBaby extends Ship
{
		twinName = "";
		isDominant = false;
		laserRadius = 8.0;
		laserDamage = 10.0;
		laserLength = 0.0;
		laserCollided = false;
		
		invincibilityTimer = 1;
		laserStartTime = -0.2;
		invincibilityFrameTimer = 0.0;
		invincibilityFlashRate = 0.1
		isFlashing = false;
		hasDrawnLaserThisFrame = false;
		
		textureCounter = 0.0;
		
		constructor(name,health,img,scale,thrustMax,friction,turnMax,rotFriction, twin, isDom)
		{
			base.constructor(name, health, img, scale, thrustMax, friction, turnMax, rotFriction)
			this.twinName = twin;
			isDominant = isDom;
			invincibilityFrameTimer = invincibilityFlashRate;
		}
		
		function update(t)
		{
			invincibilityTimer -= t;
			
			if(health<=0)
			{
				owner.remove = true;
				makeDeathExplosion();
				//Find our twin and kill him, too.
				if (twinName in ::level.enemies.dynes)
					::level.enemies.dynes[twinName].mods[1]["ship"].health = 0;
				if (isDominant)
				{
					::level.enemyKilled(owner.pos, owner.vel, scoreAmount, typeID);
				}
				return true;
			}
		
			if (invincibilityTimer < laserStartTime)
			{
				fireLaser(t);
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
		
		function draw(t)
		{	
			hasDrawnLaserThisFrame = false;
		
			if (twinName in ::level.enemies.dynes && invincibilityTimer < laserStartTime)
			{
				local twin = ::level.enemies.dynes[twinName];
				
				if(laserCollided || !twin.mods[1]["ship"].hasDrawnLaserThisFrame)
				{	
					local vecToTwin = sub2(twin.pos, owner.pos);
					local laserStartPos = [0, 0];
					local laserDirection = normalize2(vecToTwin);
					vecToTwin = scale2(laserDirection, laserLength);
					local laserRight = quarterCW2(laserDirection);
					local laserDrawRadius = scale2(laserRight,laserRadius*2);
					local laserExpand = laserLength / 160.0;
					
					local br = add2(laserStartPos,laserDrawRadius);
					local bl = sub2(laserStartPos,laserDrawRadius);
					local tr = add2(vecToTwin,laserDrawRadius);
					local tl = sub2(vecToTwin,laserDrawRadius);
					
					modifyWindow(0, 0, 0, 0, 1, -owner.r, false);
					modifyBrush();
					additiveBlending(true);
					image(getArcadePrefix("FinityFlight")+"data/Laser.png",1,1);
					fillColor(1,0.4,0.4,0.8);
					
					for (local i = 0; i < 2; i++)
					{
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
					}
					revertWindow();
					revertBrush();
					textureCounter-= 5.0 * t;
					
					
					if(laserCollided)
					{
						local laserEnd = add2(laserStartPos, vecToTwin);
						local laserRot = getDegrees2(laserEnd);
						local laserLen = length2(laserEnd);
						laserEnd = rotateDegrees2(laserEnd, -laserRot);
						local imageSize = image(getArcadePrefix("FinityFlight")+"data/flare.png",1,1);
						modifyWindow(0, 0, 0, 0, 1, -laserRot - owner.r, false);
						fillColor(1.0,0.15,0.15,0.5);
						additiveBlending(true)
						for (local i = 0; i < 3; i++)
							rect(-imageSize[0]/2,-imageSize[1]/2 + laserLen,imageSize[0],imageSize[1]);
						additiveBlending(false);
						revertWindow();
					}
					if(!twin.mods[1]["ship"].hasDrawnLaserThisFrame)
						hasDrawnLaserThisFrame = true;
				}
				twin.mods[1]["ship"].hasDrawnLaserThisFrame = false;
			}
			
			base.draw(t);
			if (invincibilityTimer > 0.0)
			{
				invincibilityFrameTimer -= t;
				if (invincibilityFrameTimer <= 0)
				{
					invincibilityFrameTimer = invincibilityFlashRate;
					isFlashing = !isFlashing;
				}
				modifyBrush();
				if (isFlashing)
				{
					local img = owner.mods[1]["ship"].img;
					local size = image(img,1,1);	
					size = scale2(size,owner.mods[1]["ship"].scale);
					additiveBlending(true);
					fillColor(1.0, 1.0, 1.0, 0.5);
					rect(-size[0]/2,-size[1]/2,size[0],size[1]);
					rect(-size[0]/2,-size[1]/2,size[0],size[1]);
				}
				revertBrush();
			}
		}
		
		function fireLaser(t)
		{
			laserCollided = false;
			local twin = ::level.enemies.dynes[twinName];
			local vecToTwin = sub2(twin.pos, owner.pos);
			local laserDirection = normalize2(vecToTwin);
			
			//vecToTwin = sub2(vecToTwin, scale2(laserDirection, 30));
			laserLength = length2(vecToTwin);
			local laserStartPos = owner.pos;
			
			local collidesList = ::level.friends.collides(0, laserStartPos, laserDirection, laserLength, laserRadius);
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
				if(collidedShield.mods[1]["ship"].typeID != "Player" || !collidedShield.mods[0]["pilot"].boosting)
					collidedShield.mods[4]["shield"].damage(laserDamage * t, 2);
			}
			
			local insideCollidesList = ::level.friends.collidesInside(notShieldList, 51, laserStartPos, laserLength);
			
			foreach(node in insideCollidesList)
			{
				local dir = scale2(laserDirection,laserDamage*3*t);
				node.dyne.mods[1]["ship"].damage(laserDamage * t,dir);
			}
		}
		
	function damage(amount,direction) // direction=HACK
	{
		if (invincibilityTimer > 0.0)
			return 0;
		else
			return base.damage(amount, direction);
	}
}
