#include "acorn.h"

#include <memory.h>

namespace ciga {
	
	void zero2(float* v)
	{
		memset(v,0,sizeof(float)*2);
	}
	void set2(float* v, float x, float y)
	{
		v[0] = x;
		v[1] = y;
	}
	void copy2(float* in, float* out)
	{
		memcpy(out,in,sizeof(float)*2);
	}
	bool equals2(float* in1, float* in2)
	{
		return in1[0] == in2[0] && in1[1] == in2[1];
	}
	
	void add2(float* in1, float* in2, float* out)
	{
		out[0] = in1[0]+in2[0];
		out[1] = in1[1]+in2[1];
	}
	void sub2(float* in1, float* in2, float* out)
	{
		out[0] = in1[0]-in2[0];
		out[1] = in1[1]-in2[1];
	}
	void scale2(float* in, float s, float* out)
	{
		out[0] = in[0]*s;
		out[1] = in[1]*s;
	}
	
	float lengthSq2(float x, float y)
	{
		return x*x+y*y;
	}
	float length2(float x, float y)
	{
		return sqrtf(lengthSq2(x,y));
	}
	
	void normalize2(float* in,float* out)
	{
		scale2(in,1/length2(in[0],in[1]),out);
	}
	float dot2(float* in1,float* in2)
	{
		return in1[0]*in2[0]+in1[1]*in2[1];
	}
	
	float getDegrees2(float* in)
	{
		return getRadians2(in)*(180/M_PI);
	}
	float getRadians2(float* in)
	{
		return atan2f(in[0],in[1]);
	}
	
	void setDegrees2(float degrees, float* out)
	{
		setRadians2(degrees*(M_PI/180),out);
	}
	void setRadians2(float radians, float* out)
	{
		out[0] = cosf(radians);
		out[1] = sinf(radians);
	}
	
	float degreesBetween2(float* in1, float* in2)
	{
		return radiansBetween2(in1,in2)*(180/M_PI);
	}
	float radiansBetween2(float* in1, float* in2)
	{
		float fdot = dot2(in1,in2);
		float flengths = length2(in1[0],in1[1])*length2(in2[0],in2[1]);
		return (fdot==0||flengths==0) ? 0 : acosf(fdot/flengths);
	}
	
	void negate2(float* in, float* out)
	{
		out[0] = -in[0];
		out[1] = -in[1];
	}
	void quarterRight2(float* in, float* out)
	{
		float temp = in[0];
		out[0] = in[1];
		out[1] = -temp;
	}
	void quarterLeft2(float* in, float* out)
	{
		float temp = in[0];
		out[0] = -in[1];
		out[1] = temp;
	}
	
	void rotateDegrees2(float* in, float degrees, float* out)
	{
		float len = length2(in[0],in[1]);
		float current = getDegrees2(in);
		setDegrees2(current+degrees,out);
		scale2(out,len,out);
	}
	void rotateRadians2(float* in, float radians, float* out)
	{
		rotateDegrees2(in,radians*(M_PI/180),out);
	}
	
	float component2(float* in1, float* in2)
	{
		float n[2];
		normalize2(in2,n);
		return dot2(in1,n);
	}
	void project2(float* in1, float* in2, float *out)
	{
		float n[2];
		normalize2(in2,n);
		scale2(n,component2(in1,in2),out);
	}
	void reflect2(float* in1, float* in2, float* out)
	{
		float p[2];
		project2(in1,in2,p);
		sub2(p,in1,out);
		add2(out,p,out);
	}
	
	bool inCircle2(float* center, float radius, float* pos)
	{
		float v[2];
		sub2(center,pos,v);
		return lengthSq2(v[0],v[1]) <= radius*radius;
	}
	bool inRect2(float* topLeft, float* bottomRight, float* pos)
	{
		return pos[0] >= topLeft[0] && pos[0] < bottomRight[0] &&
					pos[1] >= topLeft[1] && pos[1] <bottomRight[1];
	}
	bool inTriangle2(float* verta, float* vertb, float* vertc, float* pos)
	{
		float ab[2],bc[2],ca[2],ap[2],bp[2];
		sub2(vertb,verta,ab);
		quarterRight2(ab,ab);
		sub2(pos,verta,ap);
		if(dot2(ab,ap)>0) return false;
		sub2(verta,vertc,ca);
		quarterRight2(ca,ca);
		if(dot2(ca,ap)>0) return false;
		sub2(vertc,vertb,bc);
		quarterRight2(bc,bc);
		sub2(pos,vertb,bp);
		if(dot2(bc,bp)>0) return false;
		return true;
	}
	bool circleInTriangle2(float* verta, float* vertb, float* vertc, float* center, float radius)
	{
		float ab[2],abn[2],ap[2];
		sub2(vertb,verta,abn);
		quarterRight2(abn,ab);
		sub2(center,verta,ap);
		if(dot2(ab,ap)>0)
		{
			if(dot2(abn,ap)>0)
			{
				sub2(center,vertb,ap);
				if(dot2(abn,ap)<=0)
				{
					float comp = component2(ap,ab);
					return comp<radius;
				}
				return inCircle2(center,radius,vertb);
			}
			return inCircle2(center,radius,verta);
		}
		float bc[2],bcn[2],bp[2];
		sub2(vertc,vertb,bcn);
		quarterRight2(bcn,bc);
		sub2(center,vertb,bp);
		if(dot2(bc,bp)>0)
		{
			if(dot2(bcn,bp)>0)
			{
				sub2(center,vertc,bp);
				if(dot2(bcn,bp)<=0)
				{
					float comp = component2(bp,bc);
					return comp<radius;
				}
				return inCircle2(center,radius,vertc);
			}
			return inCircle2(center,radius,vertb);
		}
		float ca[2],can[2],cp[2];
		sub2(verta,vertc,can);
		quarterRight2(can,ca);
		sub2(center,vertc,cp);
		if(dot2(ca,cp)>0)
		{
			if(dot2(can,cp)>0)
			{
				sub2(center,verta,cp);
				if(dot2(can,cp)<=0)
				{
					float comp = component2(cp,ca);
					return comp<radius;
				}
				return inCircle2(center,radius,verta);
			}
			return inCircle2(center,radius,vertc);
		}
		return true;
	}
	
	bool turnRight(float* pos, float* dir, float* target)
	{
		float right[2];
		quarterRight2(dir,right);
		float v[2];
		sub2(target,pos,v);
		return dot2(right,v) > 0;
	}
}
