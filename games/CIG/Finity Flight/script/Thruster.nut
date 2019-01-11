class Thruster
{
	name="";
	owner=null;
	x=0;
	y=0;
	size=0;
	thrust=0.5;
	r=0;
	g=1;
	b=0;
	
	constructor(name,x,y,size,hue,saturation)
	{
		this.name = name;
		this.x = x;
		this.y = y;
		this.size = size;
		
		local rgb = hsvToRgb([hue,saturation,1]);
		r = rgb[0];
		g = rgb[1];
		b = rgb[2];
	}
	
	function update(t)
	{
		return true;
	}
	
	function draw(t)
	{
    	local ship = owner.mods[1]["ship"];		
		if(ship==null)
			return false;
		
		local frameThrust = ship.thrustAmount-thrust;
		if(frameThrust>t)
			frameThrust=t;
		if(frameThrust< -t)
			frameThrust=-t;
		thrust+=frameThrust;
		
		local imageSize = image(getArcadePrefix("FinityFlight")+"data/flare.png",1,1);
		additiveBlending(true);
		modifyWindow(x,y,0,0,size,-owner.r,false);
		fillColor(1,1,1,1);
		rect(-imageSize[0]/2,-imageSize[1]/2,imageSize[0],imageSize[1]);
		fillColor(r,g,b,0.6*thrust);
		rect(-imageSize[0],-imageSize[1],imageSize[0]*2,imageSize[1]*2);
		fillColor(r,g,b,0.3*thrust);
		rect(-imageSize[0]*4,-imageSize[1]*4,imageSize[0]*8,imageSize[1]*8);
		revertWindow();
	}
}
