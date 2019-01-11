class Ship
{
	name="";
	owner=null;
	img="";
	color=null;
	scale=1;
	thrustMax=1000;
	friction=0.9;
	turnMax=30;
	rotFriction=1.8;
	thrustAmount=0;
	turnAmount=0;
	sliding=false;
	health=10;
	originalHealth=10;
	damaged=0;
	lastDamageDirection=null;
	typeID = "Generic";
	scoreAmount = 100;
	isDeadPlayer = false;
	isGnat = false;
	isHoplite = false;
	hopliteFacing = 0;
	firework = false;
	
	constructor(name,health,img,scale,thrustMax,friction,turnMax,rotFriction)
	{
		this.health = health;
		this.originalHealth = health;
		this.name = name;
		this.img = img;
		this.color=[1.0,1.0,1.0,1.0];
		this.scale = scale;
		this.thrustMax = thrustMax;
		this.friction = friction;
		this.turnMax = turnMax;
		this.rotFriction = rotFriction;
		this.lastDamageDirection = [0,0];
	}
	
	function update(t)
	{
		local isPlayer = false;
		if (owner.name == "player")
			isPlayer = true;
				
		if(health<=0 && !isPlayer && !isGnat)
		{
			::level.enemyKilled(owner.pos, owner.vel, scoreAmount, typeID);
			owner.remove = true;
			makeDeathExplosion();
			return true;
		}
		else if (health <= 0 && !isPlayer && isGnat)
		{
			::level.enemyKilled(owner.pos, owner.vel, scoreAmount, typeID);
			owner.remove = true;
			makeDeathExplosion();
			owner.mods[0]["pilot"].gnatKilled();
			owner.mods[0]["pilot"].swarm.lastDamageDirection = lastDamageDirection;
			if(!firework)
			{
				local spark = Dyne(owner.name+"Spark", owner.pos[0], owner.pos[1], 0, 1, 50.0);
				spark.vel[0] = this.owner.vel[0];
				spark.vel[1] = this.owner.vel[1];
				spark.addMod(ShieldSpark("spark"), 1);
				spark.spin(rand()%300-150);
				::level.enemyShots.addDyne(spark);
			}
			return true;
		}
		else if (health <= 0 && isPlayer && !isDeadPlayer)
		{
			::level.killPlayer();
			makeDeathExplosion();
			isDeadPlayer = true;
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
	
	function draw(t)
	{
		if(isHoplite)
			modifyWindow(0,0,0,0,1,hopliteFacing,false);
		
		local size = image(img,1,1);	
		size = scale2(size,scale);
		
		fillColor(color[0],color[1],color[2],color[3]);
		rect(-size[0]/2,-size[1]/2,size[0],size[1]);
		
		if(damaged>0)
		{
			additiveBlending(true);
			rect(-size[0]/2,-size[1]/2,size[0],size[1]);
			rect(-size[0]/2,-size[1]/2,size[0],size[1]);
			damaged -= t;
		}
		
		if(isHoplite)
			revertWindow();
	}
	
	function thrust(amount)
	{
		thrustAmount = amount;
		if(thrustAmount>1)
			thrustAmount = 1;
		else if(thrustAmount<0)
			thrustAmount = 0;
	}
	
	function turn(amount)
	{
		turnAmount = amount;
		if(turnAmount>1)
			turnAmount = 1;
		else if(turnAmount < -1)
			turnAmount = -1;
	}
	
	function slide()
	{
		sliding = true;
	}
	
	function damage(amount,direction) // direction=HACK
	{
		if(amount>0)
		{	
			if (owner.name == "player")
			{
				::level.scoreKeeper.playerHit();
			}
			
			damagedThisFrame = true;//sound(getArcadePrefix("FinityFlight")+"data/hit.wav")
			lastDamageDirection = [direction[0]*60,direction[1]*60];
			
			if (this.typeID != "Player")
				owner.pos = add2(direction,owner.pos);
					
			if(damaged<=0)
			{
				damaged = 0.1;
			}
			if(amount>health)
			{
				local leftover = amount-health;
				health = 0;
				return leftover;
			}
			else
			{
				health -= amount;
				return 0;
			}
		}
	}
	
	function makeDeathExplosion()
	{
		local particle = Dyne("p" + ::particleNum,owner.pos[0],owner.pos[1],0,1,32);
		::particleNum += 1;
		particle.addMod(Particle("particle",0.05,getArcadePrefix("FinityFlight")+"data/flare.png",6,1,1,1,1,0.1,true),1);
		::level.topParticles.addDyne(particle);
		
		if(firework)
		{
			local colorR = (rand() % 256) / 255.0;
			local colorG = (rand() % 256) / 255.0;
			local colorB = (rand() % 256) / 255.0;
			
			for(local i=0;i<30;i++)
			{
				particle = Dyne("p" + ::particleNum,owner.pos[0],owner.pos[1],0,1,32);
				::particleNum += 1;
				particle.addMod(Particle("particle",1,getArcadePrefix("FinityFlight")+"data/sparkle.png",0.5,0.1,colorR,colorG,colorB,1,true),1);
				local vel = [(rand()%500)*((rand()%2)*2 - 1), 0];
				vel = rotateDegrees2(vel, rand()%360);
				particle.push([vel[0]+owner.vel[0],vel[1]+owner.vel[1]]);
				particle.spin(rand()%300-150);
				::level.bottomParticles.addDyne(particle);
			}
		}
		else
		{
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
		}
		
		particle = Dyne("p" + ::particleNum,owner.pos[0],owner.pos[1],0,1,32);
		::particleNum += 1;
		particle.addMod(Particle("particle",0.1,getArcadePrefix("FinityFlight")+"data/flare.png",10,0.1,1,1,1,1,true),1);
		particle.push([rand()%40-20+lastDamageDirection[0],rand()%40-20+lastDamageDirection[1]]);
		::level.topParticles.addDyne(particle);
		
		local particle = Dyne("p" + ::particleNum,owner.pos[0]+lastDamageDirection[0]/5,owner.pos[1]+lastDamageDirection[1]/5,0,1,32);
		::particleNum += 1;
		particle.addMod(Particle("particle",0.25,getArcadePrefix("FinityFlight")+"data/debris.png",6,10,0.5,0.5,1,1,true),1);
		particle.r = -getDegrees2(lastDamageDirection);
		particle.rv = 0;
		particle.push(scale2(lastDamageDirection,2));
		::level.bottomParticles.addDyne(particle);
		
		//
		
		local myPos = owner.pos;
		local playerPos = ::level.friends.dynes["player"].pos;
		
		local playerToMe = sub2(myPos,playerPos);
		local normalizedDistance = scale2(playerToMe,1/100.0);
		local directionDegrees = getDegrees2(playerToMe);
		
		sound(getArcadePrefix("FinityFlight")+"data/explosion.wav",directionDegrees,normalizedDistance);
	}
}

damagedThisFrame <- false;
