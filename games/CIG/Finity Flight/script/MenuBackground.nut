class MenuBackground {
	
	pos = 0;
	posShadow = 0.5;
	
	constructor() {
	}
	
	function updateAndDraw(t) {
		local size = image(getArcadePrefix("FinityFlight")+"data/Sky.png",1,1);
		local screenRatio = ::screenSize[1] / size[1];
		size[0] = screenRatio*size[0];
		size[1] = screenRatio*size[1];
		
		posShadow += (pos-posShadow)*(t/10);
		if(pos==0 && posShadow < 0.02) pos = 1;
		if(pos==1 && posShadow > 0.98) pos = 0;
		
		local totalMovementWidth = -(size[0] - ::screenSize[0]);
		
		rect(posShadow * totalMovementWidth,0,size[0],size[1]);
		
		//Cloud 1
		size = image(getArcadePrefix("FinityFlight")+"data/Cloud1.png",1,1);
		size[0] = screenRatio*size[0];
		size[1] = screenRatio*size[1];
		
		local modifier = 0.15;
		local modPos = posShadow * (modifier+1) - (modifier/2);
		local xOffset = -0.2;
		local yOffset = 0.6;
		local scale = 0.2;
		rect(modPos * totalMovementWidth + (::screenSize[0]*xOffset),
			yOffset*::screenSize[1],size[0]*scale,size[1]*scale);
		
		//Cloud 2
		modifier = 0.5;
		modPos = posShadow * (modifier+1) - (modifier/2);
		xOffset = 0.05;
		yOffset = 0.6;
		scale = 0.3;
		rect(modPos * totalMovementWidth + (::screenSize[0]*xOffset),
			yOffset*::screenSize[1],size[0]*scale,size[1]*scale);
		
		//Cloud 3
		modifier = 0.6;
		modPos = posShadow * (modifier+1) - (modifier/2);
		xOffset = 1.7;
		yOffset = 0.5;
		scale = 0.4;
		rect(modPos * totalMovementWidth + (::screenSize[0]*xOffset),
			yOffset*::screenSize[1],size[0]*scale,size[1]*scale);
		
		//Cloud 4
		modifier = 0.8;
		modPos = posShadow * (modifier+1) - (modifier/2);
		xOffset = 0.4;
		yOffset = 0.1;
		scale = 0.5;
		rect(modPos * totalMovementWidth + (::screenSize[0]*xOffset),
			yOffset*::screenSize[1],size[0]*scale,size[1]*scale);
			
		//Cloud 5
		modifier = 1.5;
		modPos = posShadow * (modifier+1) - (modifier/2);
		xOffset = 3.4;
		yOffset = -0.1;
		scale = 0.7;
		rect(modPos * totalMovementWidth + (::screenSize[0]*xOffset),
			yOffset*::screenSize[1],size[0]*scale,size[1]*scale);
	}
}
