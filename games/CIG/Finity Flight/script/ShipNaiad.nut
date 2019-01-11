class ShipNaiad extends Ship
{
	propImage = "";
	propRotation = 0;
	
	constructor(name,health,img,scale,thrustMax,friction,turnMax,rotFriction, propImage)
	{
		base.constructor(name,health,img,scale,thrustMax,friction,turnMax,rotFriction);
		this.propImage = propImage;
	}
	
	function draw(t)
	{
		base.draw(t);
		
		local size = image(propImage,1,1);	
		size = scale2(size,scale);
		
		local prop1Offset = 37.5 * scale;
		local prop2Offset = -36.5 * scale;
		
		propRotation += t * 1440;
		
		fillColor(color[0],color[1],color[2],color[3]);
		
		modifyWindow(prop1Offset,0,0,0,1,-propRotation,false);
		rect((-size[0]/2),-size[1]/2,size[0],size[1]);
		
		if(damaged>0)
		{
			additiveBlending(true);
			rect((-size[0]/2),-size[1]/2,size[0],size[1]);
			rect((-size[0]/2),-size[1]/2,size[0],size[1]);
			additiveBlending(false);
		}
		
		revertWindow();
		
		modifyWindow(prop2Offset,0,0,0,1,propRotation,false);
		rect((-size[0]/2),-size[1]/2,size[0],size[1]);
		
		if(damaged>0)
		{
			additiveBlending(true);
			rect((-size[0]/2),-size[1]/2,size[0],size[1]);
			rect((-size[0]/2),-size[1]/2,size[0],size[1]);
			additiveBlending(false);
		}
		
		revertWindow();
	}
}
