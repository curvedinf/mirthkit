class Shot
{
	name="";
	owner=null;
	img="";
	img2="";
	creator=null;
	scale=1.0;
	life=0.5;
	originalLife=0.5
	damage=1;
	targetLayer=null;
	color = null;		//Only has RGB.  Alpha determined by lifespan.
	isShotFlashy = true;
	
	collidesTimer=0;
	
	imgSwap=false;
	imgSwapTime = 0;
	
	constructor(name,damage,img,img2,scale,life,targetLayer) // img2=HACK
	{
		this.damage = damage;
		this.name = name;
		this.img = img;
		this.img2 = img2;
		this.scale = scale;
		this.life = life;
		this.originalLife = life;
		this.targetLayer = targetLayer;
		imgSwap=false;
		color = [1.0, 1.0, 1.0];
	}
	
	function update(t)
	{
		life -= t;
		if(life<0)
			owner.remove = true;
		
		collidesTimer -= t;
		if(collidesTimer<=0)
		{
			collidesTimer = 0.05;
			local collidesList = targetLayer.collides(1, owner.pos, owner.radius, scale2(owner.vel, t));
			foreach(node in collidesList)
			{
				local dyne = node.dyne;
				if(node.collType == 1)
				{
					if(dyne.mods[1]["ship"].typeID == "Player" && dyne.mods[0]["pilot"].boosting)
					{
						local vectorToReflect = normalize2(sub2(owner.pos, dyne.pos));
						vectorToReflect = scale2(vectorToReflect, 2.0 * dot2(vectorToReflect, sub2(dyne.vel, owner.vel)));
						owner.vel = add2(vectorToReflect, owner.vel);
						owner.forward = normalize2(sub2(dyne.vel, owner.vel));
						owner.r = -getDegrees2(owner.forward);
						targetLayer = ::level.enemies;
						this.damage = 60;
						this.color = [0.1, 1.0, 0.1];
						this.scale += 0.1;
						owner.radius = 15.0;
					}
					else
						damage = dyne.mods[4]["shield"].damage(damage, 1);
				}
				else
				{
					local capDamage = damage;
					if (capDamage > 5)
						capDamage = 5;
					local dir = scale2(owner.forward,capDamage*3);
					damage = dyne.mods[1]["ship"].damage(damage,dir);
				}
				if(damage==0)
				{
					owner.remove = true;
					break;
				}
				
			}
		}
		
		return true;
	}
	
	function draw(t)
	{
		local size;
		local tempLifeValue = life * 1.75;
		if(img2!=null&&imgSwap) {
			size = image(img2,1,1);
			additiveBlending(false);
			fillColor(color[0],color[1],color[2],tempLifeValue/originalLife);
		} else {
			size = image(img,1,1);
			additiveBlending(isShotFlashy);
			fillColor(color[0],color[1],color[2],tempLifeValue/originalLife);
		}
		imgSwapTime += t;
		if (imgSwapTime > 0.02)
		{
			imgSwap = !imgSwap;
			imgSwapTime = 0;
		}
		size = scale2(size,scale);
		rect(-size[0]/2,-size[1]/2,size[0],size[1]);
	}
}
	
