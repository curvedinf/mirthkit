class CollisionNode
{
	dyne = null;
	collType = 0;
	collPoint = null;
	
	constructor(dyne, type, point)
	{
		this.dyne = dyne;
		this.collType = type;
		this.collPoint = point;
	}
}