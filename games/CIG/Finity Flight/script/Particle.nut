class Particle
{
	name="";
	owner=null;
	
	img="";
	life=1;
	originalLife=1;
	startScale=1;
	endScale=1;
	r=0;
	g=1;
	b=0;
	a=1;
	additive=false;
	
	constructor(name,life,img,startScale,endScale,r,g,b,a,additive)
	{
		this.name = name;
		this.life = life;
		originalLife = life;
		this.img = img;
		this.startScale = startScale;
		this.endScale = endScale;
		
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
		this.additive = additive;
	}
	
	function update(t)
	{
		life -= t;
		if(life<=0)
		{
			owner.remove = true;
			return true;
		}
		
		owner.vel[0] -= owner.vel[0]*t*0.9;
		owner.vel[1] -= owner.vel[1]*t*0.9;
		owner.rv -= owner.rv*t*0.9;
				
		return 1;
	}
	
	function draw(t)
	{
    local progress = (originalLife-life)/originalLife;
    additiveBlending(additive);
    fillColor(r,g,b,a*(1-progress));

    local size = image(img,1,1);
    size = scale2(size,progress*(endScale-startScale)+startScale);

    rect(-size[0]/2,-size[1]/2,size[0],size[1]); 
  }
}
