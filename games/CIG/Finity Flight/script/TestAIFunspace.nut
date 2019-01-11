class TestAIFunspace
{
	name="";
	owner=null;
	
	constructor(name)
	{
		this.name = name;
	}
	
	function update(t)
	{
	
		local ship = owner.mods[1]["ship"];		
		if(ship==null)
			return false;
		
		owner.pos[0] = ::funspace.pos[0];
		owner.pos[1] = ::funspace.pos[1];
		
		return true;
		
	}
	
	function draw(t)
	{
		
		additiveBlending(false);
		lineColor(1,1,1,1,3);
		line(0,0,::funspace.vel[0],::funspace.vel[1]);
		local point = ::funspace.funToGlobal([200,200]);
		lineColor(0,0,1,1,3);
		line(0, 0, point[0] - ::funspace.pos[0], point[1] - ::funspace.pos[1]);
		fillColor(1, 0, 0, 1);
		text("FunPoint: " + point[0] + ", " + point[1], 20, 20, 400);
		
		return true;
	}
}
