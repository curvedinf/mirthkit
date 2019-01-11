primaryMG <- null;

class Machinegun
{
	name="";
	owner=null;
	x=0;
	y=0;
	r=0;
	
	cooldown=0;
	refire=0.1;
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
		if(::primaryMG == this)
		{
			::primaryMG = null;
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
			local vel = add2(owner.vel,scale2(setDegrees2(owner.r+r),1000));
			
			local shot = Dyne(owner.name+name+shotnum,pos[0],pos[1],owner.r+r,1,32);
			shot.addMod(Shot("shot",5,getArcadePrefix("FinityFlight")+"data/AutoShot.png", getArcadePrefix("FinityFlight")+"data/AutoShot.png", 2, 3,::enemies),1);
			shot.push(vel);
			::friendsShots.addDyne(shot);
			
			if(::primaryMG == null)
			{
				::primaryMG = this;
				sound(getArcadePrefix("FinityFlight")+"data/blaster.wav");
			}
			
			shotnum+=1;
			
			cooldown = refire;
		}
	}
}
