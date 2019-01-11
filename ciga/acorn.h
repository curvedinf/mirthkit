#ifndef _ACORN_H
#define _ACORN_H

// This is a 2D math library. All float pointers should point to an array of two floats.

#define _USE_MATH_DEFINES

#include <math.h>

namespace ciga {
	// Zeros v's components
	void zero2(float* v);
	
	// Set v's components to x and y
	void set2(float* v, float x, float y);
	
	// copy in's components into out
	void copy2(float* in, float* out);
	
	// check to see if in1 and in2 have the same components
	bool equals2(float* in1, float* in2);
	
	
	// add in1's components to in2's and put the output in out
	void add2(float* in1, float* in2, float* out);
	
	// as add3fv, but subtraction
	void sub2(float* in1, float* in2, float* out);
	
	// multiply in's components by s and put the output in out
	void scale2(float* in, float s, float* out);
	
	
	// get the squared length of the vector <x,y>
	float lengthSq2(float x, float y); // much faster than lengthf
	
	// get the length of a vector
	float length2(float x, float y);
	
	
	// make in have a length of 1, and put the output in out
	void normalize2(float* in,float* out);
	
	// a very fast method of finding how in1's direction relates to in2's
	// if they are both normalized (as above), the following are true:
	// if in1 and in2 are the same, output is 1
	// if in1 and in2 are perpendicular, output is 0
	// if in1 and in2 are opposites, output is -1
	float dot2(float* in1,float* in2);
	
	
	// find the degrees of in
	float getDegrees2(float* in);
	
	// find the radians of in
	float getRadians2(float* in);
	
	
	// create a new vector that points in the direction of degrees
	void setDegrees2(float degrees, float* out);
	
	// create a new vector that points in the direction of radians
	void setRadians2(float radians, float* out);
	
	
	// get the degrees between in1 and in2
	float degreesBetween2(float* in1, float* in2);
	
	// get the radians between in1 and in2
	float radiansBetween2(float* in1, float* in2);
	
	
	// get the opposing vector of in
	void negate2(float* in, float* out);
	
	// Turn in 90 degrees to the right -- much faster than rotateDegrees2fvf
	void quarterRight2(float* in, float* out); // in a top-right positive space
	
	// Turn in 90 degrees to the left -- much faster than rotateDegrees2fvf
	void quarterLeft2(float* in, float* out); // in a top-right positive space
	
	
	// Rotate in by degrees and put the output in out
	void rotateDegrees2(float* in, float degrees, float* out);
	
	// Rotate in by radians and put the output in out
	void rotateRadians2(float* in, float radians, float* out);
	
	
	// If in2 is the direction of the earth's surface, and it is noon, the
	// output is the length of in1's shadow.
	float component2(float* in1, float* in2);
	
	// If in2 is the direction of the earth's surface, and it is noon, the
	// out is the vector of in1's shadow.
	void project2(float* in1, float* in2, float *out);
	
	// out is the reflection of in1 across in2
	void reflect2(float* in1, float* in2, float* out);
	
	
	// test to see if pos is inside a circle
	bool inCircle2(float* center, float radius, float* pos);
	
	// test to see if pos is inside a rectangle
	bool inRect2(float* topLeft, float* bottomRight, float* pos);
	
	// test to see if pos is inside a triangle
	bool inTriangle2(float* verta, float* vertb, float* vertc, float* pos);
	
	// test to see if a circle is inside a triangle
	bool circleInTriangle2(float* verta, float* vertb, float* vertc, float* center, float radius);
	
	// test to see if a person standing at pos and pointing in dir needs to turn right
	// to face the target position (he needs to turn left if false)
	bool turnRight2(float* pos, float* dir, float* target);
}

#endif /* _ACORN_H */
