//This modifier creates a dyne that controls where in the gameworld the screen is centered on.
class Camera
{
	name="";
	owner=null;
	
	//cameraMode refers to how the camera moves in relation to the player.
	// 0 - Normal movement: camera follows the player
	// 1 - Return movement: camera interpolates toward to the player
	// 2 - Boost movment: camera moves at a set velocity independent of player
	// 3 - Death movement:  camera moves at a velocity independent of player and slows down.
	mode = 0;
	
	vecToTarget = null;
	
	interpolateTo = false;
	
	stayAheadOfPlayer = true;
	
	constructor(name)
	{	
		this.name = name;
	}
	
	function update(t)
	{
		if(!(::level.friends.dynes.rawin("player")))
			return false;
		local player = ::level.friends.dynes["player"];
		
		local camTarget = player.pos;
		if (stayAheadOfPlayer)
			camTarget = add2(player.pos, scale2(player.vel, 0.1));
		
		if(interpolateTo)
		{
			if (mode == 0)
			{
				local correction;
				correction = sub2(camTarget, owner.pos);
				correction = scale2(correction, 0.1);
				if(length2(correction) < 0.1)
					interpolateTo = false;
				owner.pos = add2(correction, owner.pos);
				owner.vel[0] = player.vel[0];
				owner.vel[1] = player.vel[1];
			}
			if (mode == 1)
			{
				
				if(vecToTarget == null)
				{
					vecToTarget = sub2(owner.pos, camTarget);
				}
				
				vecToTarget = scale2(vecToTarget, 0.9999); //This smaller this scalar, the more quickly the camera catches up with the player.
				owner.pos = add2(camTarget, vecToTarget);
				
				if (lengthSq2(vecToTarget) < 10)
				{
					mode = 0;
					vecToTarget = null;
				}
				interpolateTo = false;
				
			}
			if (mode == 2)
			{
				interpolateTo = false;
			}
			if (mode == 3)
			{
				owner.vel = sub2(owner.vel, scale2(owner.vel, 0.4*t));
				interpolateTo = false;	
			}
		}
		else
		{		
			if (mode == 0)
			{
				owner.pos[0] = camTarget[0];
				owner.pos[1] = camTarget[1];
				owner.vel[0] = player.vel[0];
				owner.vel[1] = player.vel[1];
			}
			if (mode == 1)
			{
				
				if(vecToTarget == null)
				{
					vecToTarget = sub2(owner.pos, camTarget);
				}
				
				vecToTarget = scale2(vecToTarget, 0.9); //This smaller this scalar, the more quickly the camera catches up with the player.
				owner.pos = add2(camTarget, vecToTarget);
				
				if (lengthSq2(vecToTarget) < 10)
				{
					mode = 0;
					vecToTarget = null;
				}
				
			}
			if (mode == 2)
			{
				
			}
			if (mode == 3)
			{
				owner.vel = sub2(owner.vel, scale2(owner.vel, 0.4*t));
				
			}
		}
		return true;
	}
	
	function draw(t)
	{
		return true;
	}
	
	function getOffset()
	{
		return scale2(owner.pos, -1.0);
	}
}
