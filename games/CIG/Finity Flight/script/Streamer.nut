class Streamer
{
	name="";
	owner=null;
	x=0;
	y=0;
	width=0;
	length=1;
	history=null;
	countdown=0;
	countdownLength = 0.1;
	
	constructor(name,x,y,width,length)
	{
		this.name = name;
		this.x = x;
		this.y = y;
		this.width = width;
		this.length = length;
		history = [];
	}
	
	function update(t)
	{
		countdown -= t;
		if(countdown<=0)
		{
			countdown = countdownLength;
			if(history.len()>=length)
			{
				history.pop();
			}
			history.insert(0,[0,0]);
		}
		history[0] = add2(owner.pos,rotateDegrees2([x,y],owner.r));
		::level.streamerDrawer.push(this);
		
		return true;
	}
	function draw(t)
	{
	}
}
