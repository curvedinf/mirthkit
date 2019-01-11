class Dyne
{
	name="";
	owner=null;
	
	pos=null;
	vel=null;
	r=0;
	rv=0;
	mass=1;
	radius=1;
	collType=0;
	tangible=true;
	//0 - Ship
	//1 - Shield
	
	forward=null;
	remove=false;
	
	mods=null;
	//Important note about mods:
	//Each table in the mods array (see constructor below) is intended for a specific type of mod.
	//mods[0] = ship controller (AI, pilots)
	//mods[1] = Dyne "main mod" (this controls the type of Dyne:  ship, bullet, etc.)
	//mods[2] = graphic stuff (streamers, thrusters)
	//mods[3] = weapons
	//mods[4] = shields
	//mods[5] = miscellaneous - nothing should be assumed about these mods except an update(t) and draw(t) function.
	
	
	constructor(name,x,y,r,mass,radius)
	{
		this.name = name;
		this.pos = [x,y];
		this.vel = [0,0];
		this.r = r;
		this.mass = mass;
		this.radius = radius;
		mods = [{},{},{},{},{},{}];
		update(0.01);
	}
	
	function update(t)
	{
		forward = setDegrees2(r);
		
		foreach(modLayer in mods)
			foreach(mod in modLayer)
			{
				if(!mod.update(t))
					delete modLayer[mod.name];
			}
		
		pos[0] += vel[0]*t;
		pos[1] += vel[1]*t;
		r += rv*t;
		
		return !remove;
	}
	
	function draw(t)
	{
		foreach(modLayer in mods)
			foreach(mod in modLayer)
			{
				modifyWindow(pos[0],pos[1],0,0,1,r,false);
				modifyBrush();
				mod.draw(t);
				revertBrush();
				revertWindow();
			}
	}
	
	function push(v)
	{
		vel = add2(vel,scale2(v,1/mass));
	}
	
	function spin(r)
	{
		rv += r/mass;
	}
	
	function addMod(mod,layer)
	{
		mod.owner = this;
		mods[layer][mod.name] <- mod;
	}
	
	function removeMod(name)
	{
		delete mods[name];
	}
	
	function collides(type,...)
	{
		collType = 0;
		if(!tangible)
			return 0;
		//If there is a shield, let it handle collision
		if("shield" in this.mods[4] && type < 50)
		{
			if(type == 0) //line to shield collision
			{
				// vargsv: 0=start position, 1 = direction, 2=length, 3=width
				local shotPosition = vargv[0];
				local shotDirection = vargv[1];
				local shotLength = vargv[2];
				local shotWidth = vargv[3];
				local vectToCenter = sub2(pos, shotPosition);
				local projLength = component2(vectToCenter, shotDirection);
				local shieldRadius = this.mods[4]["shield"].radius;
				
				if(projLength > shotLength) projLength = shotLength;
				else if (projLength < 0) projLength = 0;
				
				local projVector= scale2(normalize2(shotDirection), projLength);
				
				local closestPoint = add2(shotPosition, projVector);
				local vectorTo = sub2(pos, closestPoint);
				local distanceApartSq = lengthSq2(vectorTo);
				local outerRing = shieldRadius + shotWidth;
				local hitPoint = 0.0;
				
				if(distanceApartSq <= (outerRing * outerRing))
				{
				
					local shieldArc = (1 - (0.0 + this.mods[4]["shield"].health) / this.mods[4]["shield"].maxHealth);
					//shieldArc = (-cos(PI * (shieldArc)));
					//shieldArc = (shieldArc + 1) / 2;
					//shieldArc = shieldArc - (shotWidth / (shieldRadius * 2));
					//if(shieldArc < 0)
					//	shieldArc = 0;
					//shieldArc = (shieldArc * 2) - 1;
					//shieldArc = acos(-shieldArc) / PI;
					local innerRing = shieldRadius - shotWidth;
					local entrance = sqrt((outerRing * outerRing) - distanceApartSq);
					local outerDifference = scale2(shotDirection, entrance);
					entrance = howMuchLeft2(this.mods[4]["shield"].currentAngle, this.pos, sub2(closestPoint, outerDifference));
					local exit = entrance;
					if((innerRing * innerRing) <= distanceApartSq)
					{
						exit = howMuchLeft2(this.mods[4]["shield"].currentAngle, this.pos, add2(closestPoint, outerDifference));
						if((entrance * exit) < 0)
						{
							if(abs(entrance) > 0.5)
							{
								return CollisionNode(this, 1, closestPoint);
							}
						}
						entrance = absVal(entrance);
						exit = absVal(exit);
						hitPoint = max2(entrance, exit);
						if(hitPoint > shieldArc)
						{
							return CollisionNode(this, 1, closestPoint);
						}
						if(inCircle2(pos,closestPoint,radius+shotWidth))
							return CollisionNode(this, 0, 0);
						return 0;
					}
					else
					{
						exit = sqrt((innerRing * innerRing) - distanceApartSq);
						local innerDifference = scale2(shotDirection, exit);
						local distanceToCenter = scale2(add2(innerDifference, outerDifference), 0.5);
						exit = howMuchLeft2(this.mods[4]["shield"].currentAngle, this.pos, sub2(closestPoint, innerDifference));
						if(dot2(sub2(sub2(closestPoint, innerDifference), shotPosition), shotDirection) > 0)
						{
							if((entrance * exit) < 0)
							{
								if(abs(entrance) > 0.5)
								{
									return CollisionNode(this, 1, sub2(closestPoint, distanceToCenter));
								}
							}
							entrance = absVal(entrance);
							exit = absVal(exit);
							hitPoint = max2(entrance, exit);
							if(hitPoint > shieldArc)
							{
								return CollisionNode(this, 1, sub2(closestPoint, distanceToCenter));
							}
						}
						if(inCircle2(pos,closestPoint,radius+shotWidth))
							return CollisionNode(this, 0, 0);
						entrance = howMuchLeft2(this.mods[4]["shield"].currentAngle, this.pos, add2(closestPoint, outerDifference));
						exit = howMuchLeft2(this.mods[4]["shield"].currentAngle, this.pos, add2(closestPoint, innerDifference));
						if((entrance * exit) < 0)
						{
							if(abs(entrance) > 0.5)
							{
								return CollisionNode(this, 1, add2(closestPoint, distanceToCenter));
							}
						}
						entrance = absVal(entrance);
						exit = absVal(exit);
						hitPoint = max2(entrance, exit);
						if(hitPoint > shieldArc)
						{
							return CollisionNode(this, 1, add2(closestPoint, distanceToCenter));
						}
					}
					//collType = 1;
					return 0;
				}
			}
			else if(type == 1)
			{
				local shotPosition = vargv[0];
				local shotWidth = vargv[1];
				if(inCircle2(pos,shotPosition,this.mods[4]["shield"].radius+this.mods[4]["shield"].thickness+shotWidth))
				{
					local circleTestThickness = (this.mods[4]["shield"].radius-this.mods[4]["shield"].thickness)-shotWidth;
					if(circleTestThickness < 0)
						circleTestThickness = 0;
					if(!inCircle2(pos,shotPosition,circleTestThickness))
					{
						local turnAmount = howMuchLeft2(this.mods[4]["shield"].currentAngle, this.pos, shotPosition);
						if(turnAmount < 0)
							turnAmount *= -1;
						if(turnAmount > (1 - (0.0 + this.mods[4]["shield"].health) / this.mods[4]["shield"].maxHealth))
							return CollisionNode(this, 1, 0);
					}
				}
			}
		}
		if(type > 50)
			type -= 50;
		//If the shield above either wasn't hit or isn't there, use the Dyne's internal collision detection.
		{
			if(type==0) // line to circle
			{
				// vargsv: 0=start position, 1 = direction, 2=length, 3=width
				local vectToCenter = sub2(pos, vargv[0]);
				local projLength = component2(vectToCenter, vargv[1]);
				
				if(projLength > vargv[2]) projLength = vargv[2];
				else if (projLength < 0) projLength = 0;
				
				local projVector= scale2(normalize2(vargv[1]), projLength);
				
				local closestPoint = add2(vargv[0], projVector);
				
				if(inCircle2(pos,closestPoint,radius+vargv[3]))
					return CollisionNode(this, 0, 0);
				
			} 
			else if(type==1) //circle to circle
			{
				// vargsv: 0=circle position, 1 = radius
				if(inCircle2(pos,vargv[0],radius+vargv[1]))
					return CollisionNode(this, 0, 0);
			}
		}	
	}
	
}
