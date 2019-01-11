primaryEnemyGun <- null;

class EnemyGun
{
	name=""
	owner=null;
	x=0;
	y=0;
	r=0;
	
	cooldown = 0;
	refire = 0.1;
	shotnum = 0;
	
	damage = 10;
	collisionRadius = 3;
	projectileSpeed = 900;
	projectileLifeSpan = 2;

	
	constructor(name, x, y, r)
	{
		this.name = name;
		this.x = x;
		this.y = y;
		this.r = r;
	}

	function update(t)
	{
		if(::primaryEnemyGun == this)
		{
			::primaryEnemyGun = null;
		}
		cooldown -=t;
		if(cooldown<0)
			cooldown = 0;
			
			return true;
	}
	
	function draw(t)
	{
	}
	
	function fire()
	{
		if(cooldown<=0)
		{
		
			local pos = add2(owner.pos,rotateDegrees2([x,y], owner.r-90));
			local vel = add2(owner.vel, scale2(setDegrees2(owner.r +r), projectileSpeed));
			
			local shot = Dyne(owner.name+name+shotnum, pos[0], pos[1], owner.r+r, 1, collisionRadius);
			
			shot.addMod(ShotPlasma("shot", damage, getArcadePrefix("FinityFlight")+"data/BlasterShot2bottom.png", getArcadePrefix("FinityFlight")+"data/BlasterShot2top.png", 0.8, projectileLifeSpan, ::level.friends),1);
			shot.push(vel);
			shot.mods[1]["shot"].color = [1.0, 0.0, 0.0];
			shot.mods[1]["shot"].isShotFlashy = false;
			::level.enemyShots.addDyne(shot);
			
			if(::primaryEnemyGun == null)
			{
				::primaryEnemyGun = this;
				sound(getArcadePrefix("FinityFlight")+"data/blaster2.wav")
			}
			
			shotnum+=1;
			
			cooldown = refire;
			
		}
	}
	
}
