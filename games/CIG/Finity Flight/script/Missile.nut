class Missile
{
	name="";
	owner=null;
	creator=null;
	scale=1.00;
	life=0.5;
	originalLife=0.5
	damage=0;
	targetLayer=null;
	
	fakingDeath = false;
	fakeDeathTimer = 5.0;
	
	collidesTimer=0;
	explosionRadius = 70;
	
	rotFriction = 0;
	friction = 2;
	
	initialBoostTimer = 0.25;
	
	targetName = null;
	
	constructor(name,damage,scale,life,targetLayer)
	{
		this.damage = damage;
		this.name = name;
		this.scale = scale;
		this.life = life;
		this.originalLife = life;
		this.targetLayer = targetLayer;
		targetName = "";
	}
	
	function update(t)
	{
		if (fakingDeath)
		{
			owner.vel = [0,0];
			
			fakeDeathTimer -= t;
			if (fakeDeathTimer <= 0)
			{
				owner.remove = true;
			}
			return true;
		}
		
		life -= t;
		if(life<0)
			fakingDeath = true;
			
		local target;
	
		//Make sure we don't already have a target
		if(targetName == "")
		{
			local closestTurn = 1;
			//Check for a target to chase
			foreach(dyne in ::level.enemies.dynes)
			{
				local turn = howMuchLeft2(owner.forward,owner.pos,dyne.pos);
				if(turn < 0)
					turn *= -1;
					
				if(turn < closestTurn)
				{
					closestTurn = turn;
					target = dyne;
					targetName = target.name;
				}
			}
		}
		else
		{
			//Search for the target we were following
			if(::level.enemies.rawin(targetName))
				target = ::level.enemies[targetName];
			else
				targetName = "";
		}
	
	
		collidesTimer -= t;
		if(collidesTimer<=0)
		{
			collidesTimer = 0.1;
			local collidesList = targetLayer.collides(1, owner.pos, owner.radius, scale2(owner.vel, t));
			if (collidesList.len() > 0)
			{
				local explosionCollidesList = targetLayer.collides(1, owner.pos, explosionRadius, scale2(owner.vel, t));
				::lastRocketHitNumber = explosionCollidesList.len();
				foreach(node in explosionCollidesList)
				{
					local dyne = node.dyne;
					local dir = scale2(owner.vel,0.02);
					if(node.collType == 1)
					{
						if(dyne.mods[1]["ship"].typeID == "Player" && dyne.mods[0]["pilot"].boosting)
						{
							local vectorToReflect = normalize2(sub2(owner.pos, dyne.pos));
							vectorToReflect = scale2(vectorToReflect, 2.0 * dot2(vectorToReflect, sub2(dyne.vel, owner.vel)));
							owner.vel = add2(vectorToReflect, owner.vel);
							targetLayer = ::level.enemies;
						}
						else
							dyne.mods[4]["shield"].damage(damage, 3);
					}
					else
					{
						dyne.mods[1]["ship"].damage(damage,dir);
					}
				}

				fakingDeath = true;
				
				local particle = Dyne("p" + ::particleNum,owner.pos[0],owner.pos[1],0,1,32);
				::particleNum += 1;
				particle.addMod(Particle("particle",0.5,getArcadePrefix("FinityFlight")+"data/BlasterShot.png",18,1,1,1,1,0.5,true),1);
				::level.topParticles.addDyne(particle);
				
			}
		}
		
		if(initialBoostTimer>0)
			initialBoostTimer -= t;
		else
		{
			owner.push(scale2(owner.forward,t*3000));
			if(target)
			{
				local distanceToTarget = length2(sub2(owner.pos, target.pos));
				local targetProjPosition = scale2(target.vel, distanceToTarget/10000);
				targetProjPosition = add2(targetProjPosition, target.pos);
				owner.rv = (howMuchLeft2(owner.forward,owner.pos,targetProjPosition) * 3000);
			}
		}
		
		local proj = scale2(project2(owner.vel,quarterCW2(owner.forward)),rotFriction*t);
		local directedVel = sub2(owner.vel,proj);
		local velMag = length2(proj)*0.4+length2(directedVel)*(1-(friction*t));
		owner.vel = scale2(normalize2(directedVel),velMag);
		
		owner.rv -= owner.rv*rotFriction*t;
		
		return true;
	}
	
	function draw(t)
	{
		if (!fakingDeath)
		{
			additiveBlending(true);
			
			local size = image(getArcadePrefix("FinityFlight")+"data/sparkle.png",1,1);
			fillColor(0.7,0.5,0.3,0.5);
			
			modifyWindow(0,0,size[0],size[1],scale,-owner.r+(life*100),false);
			rect(0,0,size[0],size[1]);
			revertWindow();
			
			size = image(getArcadePrefix("FinityFlight")+"data/flare.png",1,1);
			modifyWindow(0,0,size[0],size[1],scale*1.5,-owner.r-(life*360),false);
			rect(0,0,size[0],size[1]);
			revertWindow();
		}
		
		/*size = image(getArcadePrefix("FinityFlight")+"data/flare.png",1,1);
		fillColor(0.7,0.5,0.3,1);
		
		modifyWindow(0,0,size[0],size[1],scale,-owner.r,false);
		rect(0,0,size[0],size[1]);
		revertWindow();*/
	}
}
