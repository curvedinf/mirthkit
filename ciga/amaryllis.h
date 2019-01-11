#ifndef _AMARYLLIS_H
#define _AMARYLLIS_H

// The ultra-simple 2D graphics library

// text strings support UTF-8 and ASCII

#ifdef WIN32
#include <windows.h>
#endif

#include <GL/gl.h>

#include <SDL/SDL.h>
#include <SDL/SDL_image.h>
#include <SDL/SDL_ttf.h>

#include "argillite.h"
#include "NameTable.h"

#define AM_STRING_LEN 512
#define AM_STACK_SIZE 32 // if higher, OpenGL will blow up

namespace ciga
{
	// Internal
	void _amInitialize(int w, int h, int depth, bool fullscreen,bool resizable=true);
	void _amExit();
	bool _amUpdate(int* width=0,int* height=0);
	void _amFlush();
	
	//
	void clearColor(float r,float g,float b);
	
	// Windows
	void pushWindow(float x,float y,float w,float h,float scale,float rotation,bool mask=false);
	bool popWindow();
	
	// Primitives
	void line(float sx, float sy, float ex, float ey);
	void rect(float x, float y, float w, float h);
	float text(char* string, float x, float y, float maxw,float* cursorX=0,float* cursorY=0); // returns rendered height, pointers are to the initial cursor position, and are updated before returning
	
	// Brushes
	void fillColor(float r, float g, float b, float a);
	void lineColor(float r, float g, float b, float a, float w);
	void image(char *filepath, float repeatX=1, float repeatY=1, float* w=0, float* h=0); // w&h are filled with correct values
	void font(char *filepath, int size);
	void additiveBlending(bool on);
	
	void pushBrush(); // the new brush will have the same characteristics as the previous brush
	bool popBrush();
	
	// Raw Triangles
	void beginTriangles();
	void endTriangles();
	void textureCoord(float u, float v);
	void vertex(float x, float y);
};

#endif
