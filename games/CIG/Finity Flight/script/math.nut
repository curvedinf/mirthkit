function copy2(v)
{
	return [v[0],v[1]];
}

function add2(v1,v2)
{
	return [v1[0]+v2[0],v1[1]+v2[1]];
}

function sub2(v1,v2)
{
	return [v1[0]-v2[0],v1[1]-v2[1]];
}

function scale2(v,s)
{
	return [v[0]*s,v[1]*s];
}

function lengthSq2(v)
{
	return v[0]*v[0]+v[1]*v[1];
}

function length2(v)
{
	return sqrt(v[0]*v[0]+v[1]*v[1]);
}

function normalize2(v)
{
	local len = length2(v);
	if(len==0)
		len = 0.001;
	return scale2(v,1/len);
}

function dot2(v1,v2)
{
	return v1[0]*v2[0]+v1[1]*v2[1];
}

function component2(v1, v2)
{
	return dot2(v1,normalize2(v2));
}

function project2(v1, v2)
{
	local n = normalize2(v2)
	return scale2(n,dot2(v1, n));
}

function reflect2(v1, v2)
{
	local proj = project2(v1,v2);
	return add2(proj,add2(proj,negate2(v1)));
}

function degreesToRadians(degrees)
{
	return (degrees / 180) * 2 * PI;
}

function radiansToDegrees(radians)
{
	return (radians / (2 * PI)) * 180;
}

function getRadians2(v)
{
	return atan2(v[0],v[1]);
}

function getDegrees2(v)
{
	return getRadians2(v)/PI*180;
}

function setRadians2(radians)
{
	return quarterCW2([cos(radians),sin(radians)]);
}

function setDegrees2(degrees)
{
	return setRadians2(degrees/180.0*PI);
}

function radiansBetween2(v1,v2)
{
	return acos(dot2(normalize2(v1),normalize2(v2)));
}

function degreesBetween2(v1,v2)
{
	return radiansBetween2(v1,v2)/PI*180;
}

function negate2(v)
{
	return [-v[0],-v[1]]; 
}

function quarterCW2(v)
{
	return [v[1],-v[0]];
}

function quarterCCW2(v)
{
	return [-v[1],v[0]];
}

function rotateRadians2(v,radians)
{
	return scale2(setRadians2(getRadians2(v)+radians),length2(v));
}

function rotateDegrees2(v,degrees)
{
	return rotateRadians2(v,(degrees/180.0)*PI);
}

function doTurnLeft2(forward,position,target)
{
	return dot2(quarterCCW2(forward),sub2(target,position))<0;
}

function howMuchLeft2(forward,position,target)
{
	local direction = normalize2(sub2(target,position));
	local solution = dot2(quarterCCW2(forward),direction);
	if(dot2(forward,direction)>0)
	{
		solution = solution/2;
	} else {
		if(solution>0)
			solution = 1-solution/2;
		else
			solution = -1-solution/2;
	}
	return solution;
}

function inCircle2(position,center,radius)
{
	return lengthSq2(sub2(position,center)) < radius*radius;
}

function hsvToRgb(hsv)
{
	// HSV to RGB Calculation
	local hi = floor(hsv[0]*6.0) % 6;
	local f = hsv[0]*6.0 - hi;
	local p = hsv[2]*(1 - hsv[1]);
	local q = hsv[2]*(1 - f * hsv[1]);
	local t = hsv[2]*(1 - (1-f) * hsv[1]);
	
	local rgb = [0,0,0];
	
	if(hi==0)
	{
		rgb[0] = hsv[2];
		rgb[1] = t;
		rgb[2] = p;
	}
	else if(hi==1)
	{
		rgb[0] = q;
		rgb[1] = hsv[2];
		rgb[2] = p;
	}
	else if(hi==2)
	{
		rgb[0] = p;
		rgb[1] = hsv[2];
		rgb[2] = t;
	}
	else if(hi==3)
	{
		rgb[0] = p;
		rgb[1] = q;
		rgb[2] = hsv[2];
	}
	else if(hi==4)
	{
		rgb[0] = t;
		rgb[1] = p;
		rgb[2] = hsv[2];
	}
	else if(hi==5)
	{
		rgb[0] = hsv[2];
		rgb[1] = p;
		rgb[2] = q;
	}
	
	return rgb;
}

//Gives a point a certain percentage (0 - 1.00) between two points
function pointPercentAlongLine(pointA,pointB,percent)
{
	local vectorBetween = sub2(pointB,pointA);
	return add2(scale2(vectorBetween,percent),pointA);
}

//Returns a random number between the first and second number.
function randBetween(min, max)
{
	if (min > max)
	{
		local tempNum = max;
		max = min;
		min = tempNum;
	}
	
	return (rand() % (max - min + 1) ) + min;
}

function min2(s1, s2)
{
	if(s1 < s2)
		return s1;
	return s2;
}

function max2(s1, s2)
{
	if(s1 > s2)
		return s1;
	return s2;
}

function absVal(s)
{
	if(s > 0)
		return s;
	return -s;
}
