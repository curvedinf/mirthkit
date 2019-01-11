class StreamerDrawer
{
	drawList=null;
	constructor()
	{
		drawList = [];
	}
	function push(streamer)
	{
		drawList.append(streamer);
	}
	function draw()
	{
		modifyBrush();
		foreach(streamer in drawList)
		{
			local historyLen = streamer.history.len();
			for(local i=0;i<historyLen-1;i++)
			{
				lineColor(1,1,1,1-(i*1.0/(historyLen-1)),streamer.width);
				line(streamer.history[i][0],streamer.history[i][1],streamer.history[i+1][0],streamer.history[i+1][1]);
			}
		}
		revertBrush();
		drawList = [];
	}
}
