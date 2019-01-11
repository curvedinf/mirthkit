class DyneLayer
{
	dynes=null;
	
	constructor()
	{
		dynes = {};
	}
	
	function update(t)
	{
		foreach(dyne in dynes)
			if(!dyne.update(t))
				delete dynes[dyne.name];
	}
	
	function draw(t)
	{
		foreach(dyne in dynes)
			dyne.draw(t);
	}
	
	function addDyne(dyne)
	{
		dyne.owner = this;
		dynes[dyne.name] <- dyne;
	}
	
	function collides(type,...)
	{
		local collidesList = {};
		foreach(dyne in dynes)
			if(vargv.len()==2)
			{
				local collisionNode = dyne.collides(type,vargv[0],vargv[1]);
				if(collisionNode)
					collidesList[dyne.name] <- collisionNode;
			}
			else if(vargv.len()==3)
			{
				local collisionNode =  dyne.collides(type,vargv[0],vargv[1], vargv[2]);
				if(collisionNode)
					collidesList[dyne.name] <- collisionNode;
			}
			else if(vargv.len()==4)
			{
				local collisionNode = dyne.collides(type,vargv[0],vargv[1],vargv[2],vargv[3]);
				if(collisionNode)
					collidesList[dyne.name] <- collisionNode;
			}
		return collidesList;
	}
	
	function collidesInside(oldCollideList, type,...)
	{
		local collidesList = {};
		foreach(node in oldCollideList)
		{
			local dyne = node.dyne;
			if(vargv.len()==2)
			{
				local collisionNode = dyne.collides(type,vargv[0],vargv[1]);
				if(collisionNode)
					collidesList[dyne.name] <- collisionNode;
			}
			else if(vargv.len()==3)
			{
				local collisionNode =  dyne.collides(type,vargv[0],vargv[1], vargv[2]);
				if(collisionNode)
					collidesList[dyne.name] <- collisionNode;
			}
			else if(vargv.len()==4)
			{
				local collisionNode = dyne.collides(type,vargv[0],vargv[1],vargv[2],vargv[3]);
				if(collisionNode)
					collidesList[dyne.name] <- collisionNode;
			}
		}
		return collidesList;
	}
}
