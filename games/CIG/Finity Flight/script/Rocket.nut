class Rocket
{
	name="";
	owner=null;
	img="";
	creator=null;
	scale=1.0;
	life=0.5;
	originalLife=0.5
	damage=0;
	targetLayer=null;
	
	collidesTimer=0;
	explosionRadius = 70;
	
	rotFriction = 0;
	friction = 1;
	
	initialBoostTimer = 0.25;
	
	constructor(name,damage,img,scale,life,targetLayer)
	{
		this.damage = damage;
		this.name = name;
		this.img = img;
		this.scale = scale;
		this.life = life;
		this.originalLife = life;
		this.targetLayer = targetLayer;
	}
	
	function update(t)
	{
		life -= t;
		if(life<0)
			owner.remove = true;
		
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

				owner.remove = true;
				
				local particle = Dyne("p" + ::particleNum,owner.pos[0],owner.pos[1],0,1,32);
				::particleNum += 1;
				particle.addMod(Particle("particle",0.5,getArcadePrefix("FinityFlight")+"data/shockwave.png",0.5,0.1,1,1,1,0.5,true),1);
				::level.topParticles.addDyne(particle);
				
			}
		}
		
		if(initialBoostTimer>0)
			initialBoostTimer -= t;
		else
			owner.push(scale2(owner.forward,t*6000));
		
		local proj = scale2(project2(owner.vel,quarterCW2(owner.forward)),rotFriction*t);
		local directedVel = sub2(owner.vel,proj);
		local velMag = length2(proj)*0.4+length2(directedVel)*(1-(friction*t));
		owner.vel = scale2(normalize2(directedVel),velMag);
		
		owner.rv -= owner.rv*rotFriction*t;
		
		return true;
	}
	
	function draw(t)
	{
		local size = image(img,1,1);		
		size = scale2(size,scale);
		fillColor(1,1,1,1);
		rect(-size[0]/2,-size[1]/2,size[0]/2,size[1]/2);
		
		if (initialBoostTimer <= 0)
		{
			local imageSize = image(getArcadePrefix("FinityFlight")+"data/flare.png",1,1);
			modifyWindow(-3,3,imageSize[0],imageSize[1],0.5,-owner.r,false);
			additiveBlending(true);
			fillColor(0.7,0.5,0.3,1);
			rect(0,0,imageSize[0],imageSize[1]);
			revertWindow();
		}
	}
}
