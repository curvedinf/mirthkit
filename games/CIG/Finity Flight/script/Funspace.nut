//Funspace represents a location that something else is trying to track.  The "tracker" is imperfect on purpose, and will usually be inacurrate if the target behaves erratically.
class FunSpace
{
	target = null;
	pos = null;
	vel = null;
	
	posStickiness = 1;//0.003;
	velStickiness = 1;//0.05;
	
	constructor(centeredOn)
	{
	
		target = centeredOn;
		
		this.pos = [target.pos[0], target.pos[1]];
		this.vel = [target.vel[0], target.vel[1]];
	}

	function update(t) 
	{
	
		this.pos[0] += vel[0] * t;
		this.pos[1] += vel[1] * t;
		
		//Important:  The below method of interpolation only works consistently with a steady framerate.
		//funPos -> targetPos
		this.pos[0] = ((target.pos[0] - this.pos[0]) * posStickiness) + this.pos[0];
		this.pos[1] = ((target.pos[1] - this.pos[1]) * posStickiness) + this.pos[1];
		//funVel -> targetVel
		this.vel[0] = ((target.vel[0] - this.vel[0]) * velStickiness) + this.vel[0];
		this.vel[1] = ((target.vel[1] - this.vel[1]) * velStickiness) + this.vel[1];
		
		return true;
	}
	
	function funToGlobal(funCoords)
	{
		local rot = getDegrees2(vel);
		funCoords = rotateDegrees2(funCoords, -rot);
		return add2(funCoords, this.pos);
	}
	
	function funToGlobal_noRot(funCoords)
	{
		return add2(funCoords, this.pos);
	}
	
	function globalToFun(globalCoords)
	{
		local vec = sub2(globalCoords, this.pos);
		local rot = getDegrees2(vel)
		return rotateDegrees2(vec, -rot);
	}
	
	function globalToFun_noRot(globalCoords)
	{
		return sub2(globalCoords, this.pos);
	}
	
}
