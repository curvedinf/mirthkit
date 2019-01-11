class ShotPlasma extends Shot
{
	function draw(t)
	{
		local size;
		local tempLifeValue = life * 1.75;
		
		//Bottom Image
		size = image(img, 1, 1);
		additiveBlending(false)
		fillColor(color[0],color[1],color[2],tempLifeValue/originalLife);
		size = scale2(size,scale);
		rect(-size[0]/2,-size[1]/2,size[0],size[1]);
		//Top Image
		size = image(img2, 1, 1);
		additiveBlending(true)
		fillColor(color[0],color[1],color[2],tempLifeValue/originalLife);
		size = scale2(size,scale);
		rect(-size[0]/2,-size[1]/2,size[0],size[1]);
	}
}
