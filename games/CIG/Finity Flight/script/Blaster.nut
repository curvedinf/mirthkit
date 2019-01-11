primaryBlaster <- null;

class Blaster
{
	name="";
	owner=null;
	x=0;
	y=0;
	r=0;
	
	cooldown=0;
	refire=0.5;
	shotnum=0;
	
	constructor(name,x,y,r)
	{
		this.name = name;
		this.x = x;
		this.y = y;
		this.r = r;
	}
	
	function update(t)
	{
		if(::primaryBlaster == this)
		{
			::primaryBlaster = null;
		}
		cooldown -= t;
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
			local pos = add2(owner.pos,rotateDegrees2([x,y],owner.r-90));
			local vel = add2(owner.vel,scale2(setDegrees2(owner.r+r),200));
			
			local shot = Dyne(owner.name+name+shotnum,pos[0],pos[1],owner.r+r,1,32);
			shot.addMod(Shot("shot",20,getArcadePrefix("FinityFlight")+"data/BlasterShot.png",1.5,2,::enemies),1);
			shot.push(vel);
			::friendsShots.addDyne(shot);
			
			if(::primaryBlaster == null)
			{
				::primaryBlaster = this;
				sound(getArcadePrefix("FinityFlight")+"data/blaster.wav");
			}
			
			shotnum+=1;
			
			cooldown = refire;
		}
	}
}
