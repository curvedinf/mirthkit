primaryNaiadGun <- null;

class NaiadGun
{
	name=""
	owner=null;
	x=0;
	y=0;
	r=0;
	
	color = null;
	recoil = 0.0;
	
	cooldown = 0;
	refire = 0.1;
	shotnum = 0;
	
	damage = 10;
	collisionRadius = 3;
	projectileSpeed = 600;
	projectileLifeSpan = 2;

	turretImage = "";
	
	
	constructor(name, x, y, r, turretImage)
	{
		this.name = name;
		this.x = x;
		this.y = y;
		this.r = r;
		this.turretImage = turretImage;
		color = [1.0, 1.0, 1.0];
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
		
		recoil -= t * 60.0;
		if(recoil < 0)
			recoil = 0;
		
			return true;
	}
	
	function draw(t)
	{
		local ship = owner.mods[1]["ship"];
		local size = image(turretImage,1,1);	
		size = scale2(size,ship.scale);
		
		fillColor(color[0],color[1],color[2],ship.color[3]);
		
		modifyWindow(x,y,0,0,1,r-owner.r,false);
		
		rect((-size[0]/2),-size[1]/2 + recoil,size[0],size[1]);
		
		if(ship.damaged>0)
		{
			additiveBlending(true);
			rect((-size[0]/2),-size[1]/2 + recoil,size[0],size[1]);
			rect((-size[0]/2),-size[1]/2 + recoil,size[0],size[1]);
			additiveBlending(false);
		}
		
		revertWindow();
	}
	
	function fire()
	{
		if(cooldown<=0)
		{
			recoil = 20.0;
			local pos = add2(owner.pos,rotateDegrees2([x,y], owner.r-90));
			local vel = add2(::level.player.vel, scale2(setDegrees2(r), projectileSpeed));
			
			local shot = Dyne(owner.name+name+shotnum, pos[0], pos[1], r, 1, collisionRadius);
			
			shot.addMod(ShotPlasma("shot", damage, getArcadePrefix("FinityFlight")+"data/BlasterShot2bottom.png", getArcadePrefix("FinityFlight")+"data/BlasterShot2top.png", 0.8, projectileLifeSpan, ::level.friends),1);
			shot.mods[1]["shot"].color = [1.0, 0.0, 0.0];
			shot.mods[1]["shot"].isShotFlashy = true;
			shot.push(vel);
			
			::level.enemyShots.addDyne(shot);
			
			if(::primaryEnemyGun == null)
			{
				::primaryEnemyGun = this;
				sound(getArcadePrefix("FinityFlight")+"data/blaster.wav")
			}
			
			shotnum+=1;
			
			cooldown = refire;
			
		}
	}
	
}
