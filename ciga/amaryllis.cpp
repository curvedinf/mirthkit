#include "amaryllis.h"
#include "NameTable.h"
#include "List.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

extern void exitPlayer();

namespace ciga {
		struct AM_WINDOW
	{
		float x,y,w,h,r,s;
		bool mask;
	};
	
	struct AM_TEXTURE
	{
		GLuint id;
		unsigned int w, h, tw, th;
		float s,t;
	};
	
	struct AM_IMAGE
	{
		AM_TEXTURE* texture;
		float repeatX, repeatY;
	};
	
	struct AM_GLYPH
	{
		AM_TEXTURE texture;
		int minx, maxx, miny, maxy, advance;
		GLuint displayList;
	};
	
	struct AM_FONT
	{
		NameTable<AM_GLYPH> glyphs;
		TTF_Font* file;
		int height, lineSpacing, ascent, descent;
	};
	
	struct AM_BRUSH
	{
		float fill[4];
		float line[5];
		AM_IMAGE image;
		AM_FONT* font;
		bool blendingMode;
	};
	
	AM_WINDOW _windowStack[AM_STACK_SIZE];
	AM_WINDOW* _windowStackPointer;
	AM_BRUSH _brushStack[AM_STACK_SIZE];
	AM_BRUSH* _brushStackPointer;
	NameTable<AM_TEXTURE> _images;
	NameTable<AM_FONT> _fonts;
	int _stencilDepth;
	GLuint _rectLineList, _lineList;
	
	bool _triangles;
	
	int _videoOptions;
 	int _depth;
	
	float _clearColor[3] = {0,0,0};
	
	void _loadTexture(SDL_Surface* surface, AM_TEXTURE* texture)
	{
		int w=1, h=1;
		while(w<surface->w) w<<=1;
		while(h<surface->h) h<<=1;
		
		Uint32 savedFlags = surface->flags&(SDL_SRCALPHA|SDL_RLEACCELOK);
		Uint8 savedAlpha = surface->format->alpha;
		if ( (savedFlags & SDL_SRCALPHA) == SDL_SRCALPHA ) SDL_SetAlpha(surface, 0, 0);
		
		SDL_Surface* formatted = SDL_CreateRGBSurface(SDL_SWSURFACE,w,h,32,
												#if SDL_BYTEORDER == SDL_LIL_ENDIAN
												0x000000FF, 
												0x0000FF00, 
												0x00FF0000, 
												0xFF000000
												#else
												0xFF000000,
												0x00FF0000, 
												0x0000FF00, 
												0x000000FF
												#endif
												);
		
		SDL_Rect area = {0,0,surface->w,surface->h};
		SDL_BlitSurface(surface, &area, formatted, &area);
		
		if ( (savedFlags & SDL_SRCALPHA) == SDL_SRCALPHA ) SDL_SetAlpha(surface, savedFlags, savedAlpha);
		
		glGenTextures(1, &texture->id);
		glBindTexture(GL_TEXTURE_2D, texture->id);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA,w,h,0,GL_RGBA,GL_UNSIGNED_BYTE,formatted->pixels);
		SDL_FreeSurface(formatted);
		
		texture->w = surface->w;
		texture->h = surface->h;
		texture->tw = w;
		texture->th = h;
		texture->s = surface->w/(float)w;
		texture->t = surface->h/(float)h;
	}
	
	void _setupTexRepeat()
	{
		/*#ifdef MAC_OSX
		if(_brushStackPointer->image.repeatX!=0)
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
		else
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
			
		if(_brushStackPointer->image.repeatY!=0)
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
		else
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
		#else*/
		if(_brushStackPointer->image.repeatX!=0)
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
		else
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
			
		if(_brushStackPointer->image.repeatY!=0)
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
		else
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
		//#endif
	}
	
	// Control
	bool _amInitGL(int w, int h)
	{
		bool success = SDL_SetVideoMode(w,h,_depth,_videoOptions);
		
		glViewport(0,0,w,h);
		glMatrixMode( GL_PROJECTION );
		glLoadIdentity();
		glOrtho(0,w,h,0,-1,1);
		glMatrixMode( GL_MODELVIEW );
		glLoadIdentity();
		
		//glEnable(GL_ALPHA_TEST);
		//glAlphaFunc(GL_GEQUAL,0.01f);
		
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		
		glEnable(GL_COLOR_MATERIAL);
		glColorMaterial(GL_FRONT, GL_DIFFUSE);
		
		glEnable(GL_STENCIL_TEST);
		
		glClearColor(_clearColor[0],_clearColor[1],_clearColor[2],1);
		glClearStencil(0);
		glClear( GL_COLOR_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
		return success;
	}
	
	void _amInitialize(int w, int h, int depth, bool fullscreen,bool resizable)
	{
		// SDL
		if ( SDL_Init(SDL_INIT_VIDEO | SDL_INIT_AUDIO) != 0 ) return;
		SDL_GL_SetAttribute( SDL_GL_DOUBLEBUFFER, 1 );
		SDL_GL_SetAttribute(SDL_GL_STENCIL_SIZE,8);
		if( TTF_Init() < 0) return;
		
		SDL_EnableUNICODE(true);
		
		_depth=depth;
		_videoOptions = SDL_OPENGL;
		if(resizable) _videoOptions |= SDL_RESIZABLE;
		if(fullscreen) _videoOptions |= SDL_FULLSCREEN;
			
		if (!_amInitGL(w,h)) return;
		
		// Stacks
		_stencilDepth = 0;
		_windowStackPointer = _windowStack;
		_windowStackPointer->x = w/2;
		_windowStackPointer->y = h/2;
		_windowStackPointer->w = w;
		_windowStackPointer->h = h;
		_windowStackPointer->s = 1;
		_windowStackPointer->r = 0;
		_windowStackPointer->mask = false;
		
		_triangles = false;
		
		_brushStackPointer = _brushStack;
		fillColor(1,1,1,1);
		lineColor(0,0,0,0,0);
		image(0,0,0);
		font(0,0);
		additiveBlending(false);
	}
	void _amExit()
	{
		SDL_Quit();
	}
	void _amFlush()
	{
		for(int i=0; i<_windowStackPointer-_windowStack; i++)
		{
			glPopMatrix();
		}
		_windowStackPointer = _windowStack;
		_brushStackPointer = _brushStackPointer;
		
		// delete cached images
		List<AM_TEXTURE> imageList;
		_images.append(&imageList);
		AM_TEXTURE* currentTex = imageList.popFront();
		while(currentTex)
		{
			glDeleteTextures(1,&currentTex->id);
			delete currentTex;
			currentTex = imageList.popFront();
		}
		_images.clear();
		
		// delete cached fonts
		List<AM_FONT> fontList;
		_fonts.append(&fontList);
		AM_FONT* currentFont = fontList.popFront();
		while(currentFont)
		{
			List<AM_GLYPH> glyphList;
			currentFont->glyphs.append(&glyphList);
			AM_GLYPH* currentGlyph = glyphList.popFront();
			while(currentGlyph)
			{
				glDeleteTextures(1,&currentGlyph->texture.id);
				glDeleteLists(currentGlyph->displayList,1);
				delete currentGlyph;
				currentGlyph = glyphList.popFront();
			}
			//currentFont->glyphs.clear();
			TTF_CloseFont(currentFont->file);
			delete currentFont;
			currentFont = fontList.popFront();
		}
		_fonts.clear();
		
		_brushStackPointer->font = 0;
		
		clearColor(0,0,0);
		lineColor(0,0,0,0,0);
		fillColor(1,1,1,1);
	}
	bool _amUpdate(int* width,int* height)
	{
		for(int i=0; i<_windowStackPointer-_windowStack; i++)
		{
			glPopMatrix();
		}
		_windowStackPointer = _windowStack;
		_brushStackPointer = _brushStackPointer;
		
		// Normal Stuff
		SDL_PumpEvents();
		SDL_GL_SwapBuffers();
		
		bool windowResized=false;
		int w=0,h=0;
		
		SDL_Event event;
		while(SDL_PollEvent(&event))
		{
			if(event.type == SDL_VIDEORESIZE)
			{
				windowResized=true;
				w=event.resize.w;
				h=event.resize.h;
				_amFlush();
			}
			else if(event.type == SDL_QUIT)
			{
				exitPlayer();
				exit(0);
			}
			else if(event.type == SDL_KEYDOWN || event.type == SDL_KEYUP)
			{
				_arKeyEvent(&event.key);
			}
		}
		
		if(windowResized)
		{
			_amInitGL(w,h);
			if(width) *width = w;
			if(height) *height = h;
			glClearColor(_clearColor[0],_clearColor[1],_clearColor[2],1);
		}
		
		glClear(GL_COLOR_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
		return windowResized;
	}
	
	void clearColor(float r,float g,float b)
	{
		_clearColor[0] = r;
		_clearColor[1] = g;
		_clearColor[2] = b;
		glClearColor(r,g,b,1);
	}
	
	// Windows
	void pushWindow(float x,float y,float w,float h,float s,float r,bool mask)
	{
		if(_windowStackPointer-_windowStack>=AM_STACK_SIZE-1) return;
		_windowStackPointer += 1;
		_windowStackPointer->x = x;
		_windowStackPointer->y = y;
		_windowStackPointer->w = w;
		_windowStackPointer->h = h;
		_windowStackPointer->s = s;
		_windowStackPointer->r = r;
		_windowStackPointer->mask = mask;
		
		glPushMatrix();
		glTranslatef(x,y,0);
		glScalef(s,s,1);
		glRotatef(r,0,0,1);
		glTranslatef(-w/2,-h/2,0);
		
		if(mask)
		{
			glDisable(GL_TEXTURE_2D);
			glEnable(GL_STENCIL_TEST);
			glColorMask(0, 0, 0, 0);
			glColor4f(1,1,1,0.2);
			glStencilFunc(GL_ALWAYS, 1, 0xffffffff);
			glStencilOp(GL_KEEP, GL_KEEP, GL_INCR);
			glColor4f(1,1,1,0.2);
			
			glRectf(0,0,w,h);
			_stencilDepth++;
			
			glColorMask(1, 1, 1, 1);
			glStencilFunc(GL_EQUAL, _stencilDepth, 0xffffffff);
			glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);
		}
	}
	bool popWindow()
	{
		if(_windowStackPointer-_windowStack<=0) return false;
			
		if(_windowStackPointer->mask)
		{
			_stencilDepth--;
			glDisable(GL_TEXTURE_2D);
			
			glColorMask(0, 0, 0, 0);
			glStencilFunc(GL_ALWAYS, 1, 0xffffffff);
			glStencilOp(GL_KEEP, GL_KEEP, GL_DECR);
			
			glRectf(0,0,_windowStackPointer->w,_windowStackPointer->h);
			
			glColorMask(1, 1, 1, 1);
			glStencilFunc(GL_EQUAL, _stencilDepth, 0xffffffff);
			glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP);
		}
		
		glPopMatrix();
		
		_windowStackPointer -= 1;
		
		if(!_windowStackPointer->mask)
		{
			glDisable(GL_STENCIL_TEST);
		}
		
		return true;
	}
	
	// Primitives
	void line(float sx, float sy, float ex, float ey)
	{
		endTriangles();
		
		if(_brushStackPointer->line[3] <= 0 || _brushStackPointer->line[4] <= 0) return;
		
		glColor4fv(_brushStackPointer->line);
		
		glDisable(GL_TEXTURE_2D);
		glBegin(GL_LINES);
		glVertex2f(sx,sy);
		glVertex2f(ex,ey);
		glEnd();
	}
	void rect(float x, float y, float w, float h)
	{
		endTriangles();
			
		if(_brushStackPointer->fill[3] > 0)
		{
			glColor4fv(_brushStackPointer->fill);
			if(_brushStackPointer->image.texture) 
			{
				glEnable(GL_TEXTURE_2D);
				glBindTexture( GL_TEXTURE_2D, _brushStackPointer->image.texture->id);
				_setupTexRepeat();
				glBegin(GL_QUADS);
				glTexCoord2f(0,0);
				glVertex2f(x,y);
				float repeatX = _brushStackPointer->image.repeatX;
				float repeatY = _brushStackPointer->image.repeatY;
				if(repeatX==0) repeatX=1;
				if(repeatY==0) repeatY=1;
				glTexCoord2f(repeatX*_brushStackPointer->image.texture->s-0.002,0);
				glVertex2f(x+w,y);
				glTexCoord2f(repeatX*_brushStackPointer->image.texture->s-0.002,
								repeatY*_brushStackPointer->image.texture->t-0.002);
				glVertex2f(x+w,y+h);
				glTexCoord2f(0,repeatY*_brushStackPointer->image.texture->t-0.002);
				glVertex2f(x,y+h);
				glEnd();
			} else {
				glDisable(GL_TEXTURE_2D);
				glRectf(x,y,x+w,y+h);
			}
		}
		if(_brushStackPointer->line[3] <= 0 || _brushStackPointer->line[4] <= 0) return;
		glColor4fv(_brushStackPointer->line);
		
		glDisable(GL_TEXTURE_2D);
		glBegin(GL_LINE_STRIP);
		glVertex2f(x,y+1);
		glVertex2f(x+w-1,y+1);
		glVertex2f(x+w-1,y+h);
		glVertex2f(x,y+h);
		glVertex2f(x,y+1);
		glEnd();
	}
	float text(char* string, float x, float y, float maxw,float* cursorX,float* cursorY)
	{
		//if(_brushStackPointer->fill[3] == 0) return 0;
		if(_brushStackPointer->font == 0) return 0;
		
		x = (int) x;
		y = (int) y;
		
		endTriangles();
			
		SDL_Color white = {255,255,255,255};
		
		// load glyphs if needed, and prepare an array of glyphs to render
		int size=strlen(string);
		AM_GLYPH*** glyphArray = new AM_GLYPH**[size];
		int utf8Offset = 0;
		for(int i=0;i+utf8Offset<size;i++)
		{
			char* characterStart = string+i+utf8Offset;
			
			Uint16 glyphCharacter = ((unsigned char *)characterStart)[0];
			
			// UTF-8 to UTF-16
			if(glyphCharacter>=0xF0) {
				glyphCharacter=(Uint16)(characterStart[0]&0x07)<<18;
				glyphCharacter|=(Uint16)(characterStart[1]&0x3F)<<12;
				glyphCharacter|=(Uint16)(characterStart[2]&0x3F)<<6;
				glyphCharacter|=(Uint16)(characterStart[3]&0x3F);
				utf8Offset+=3;
			} else if(glyphCharacter >= 0xE0) {
				glyphCharacter=(Uint16)(characterStart[0] & 0x0F)<<12;
				glyphCharacter|=(Uint16)(characterStart[1]&0x3F)<<6;
                glyphCharacter|=(Uint16)(characterStart[2]&0x3F);
				utf8Offset+=2;
			} else if ( glyphCharacter >= 0xC0 ) {
				glyphCharacter=(Uint16)(characterStart[0]&0x1F)<<6;
				glyphCharacter|=(Uint16)(characterStart[1]&0x3F);
			}
			
			char glyphName[3]={glyphCharacter&0xFF,glyphCharacter>>8,0};
			AM_GLYPH** glyph = _brushStackPointer->font->glyphs.get(glyphName);
			glyphArray[i] = glyph;
			if(!*glyph)
			{
				*glyph = new AM_GLYPH();
				SDL_Surface* renderedGlyph = TTF_RenderGlyph_Blended(_brushStackPointer->font->file, glyphCharacter, white);
				_loadTexture(renderedGlyph,&(*glyph)->texture);
				SDL_FreeSurface(renderedGlyph);
				TTF_GlyphMetrics(_brushStackPointer->font->file,glyphCharacter,&(*glyph)->minx,&(*glyph)->maxx,
											&(*glyph)->miny,&(*glyph)->maxy,&(*glyph)->advance);
				
				int left = (*glyph)->minx;
				int right = (*glyph)->maxx;
				int top = (*glyph)->maxy;
				int bottom = (*glyph)->miny;
				
				(*glyph)->displayList = glGenLists(1);
				glNewList((*glyph)->displayList,GL_COMPILE);
				
				glBindTexture( GL_TEXTURE_2D, (*glyph)->texture.id);
				glBegin(GL_QUADS);
				glTexCoord2f(0,0);
				glVertex2f(left,-top);
				glTexCoord2f((*glyph)->texture.s,0);
				glVertex2f(right,-top);
				glTexCoord2f((*glyph)->texture.s,(*glyph)->texture.t);
				glVertex2f(right,-bottom);
				glTexCoord2f(0,(*glyph)->texture.t);
				glVertex2f(left,-bottom);
				glEnd();
				
				glEndList();
			}
		}
		
		// Draw glyphs
		glEnable(GL_TEXTURE_2D);
		int posX=0, posY=_brushStackPointer->font->ascent;
		if(cursorX) posX+=(int)*cursorX;
		if(cursorY) posY+=(int)*cursorY;
		for(int i=0;i<size;i++)
		{
			AM_GLYPH* glyph = *(glyphArray[i]);
			// line wrap/white space
			if(string[i]=='	') {continue;}
			if(string[i]=='\n')
			{
				posY += _brushStackPointer->font->lineSpacing;
				posX = 0;
				continue;
			}
			if(string[i]==' ')
			{
				int length = glyph->advance;
				for(int j=i+1;j<size&&string[j]!=' ';j++) length += (*(glyphArray[j]))->advance;
				if(length+posX>maxw)
				{
					posY += _brushStackPointer->font->lineSpacing;
					posX = 0;
					continue;
				}
			}
			glColor4fv(_brushStackPointer->fill);
			glTranslatef(posX+x,posY+y,0);
			glCallList(glyph->displayList);
			glTranslatef(-posX-x,-posY-y,0);
			posX += glyph->advance;
		}
		delete [] glyphArray;
		
		if(cursorX) *cursorX = posX;
		if(cursorY) *cursorY = posY-_brushStackPointer->font->ascent;
		
		posY -= _brushStackPointer->font->descent;
		
		return posY;
	}
	
	// Brushes
	void fillColor(float r, float g, float b, float a)
	{
		_brushStackPointer->fill[0] = r;
		_brushStackPointer->fill[1] = g;
		_brushStackPointer->fill[2] = b;
		_brushStackPointer->fill[3] = a;
	}
	void lineColor(float r, float g, float b, float a, float w)
	{
		_brushStackPointer->line[0] = r;
		_brushStackPointer->line[1] = g;
		_brushStackPointer->line[2] = b;
		_brushStackPointer->line[3] = a;
		_brushStackPointer->line[4] = w;
		
		glLineWidth(w);
	}
	void image(char *filepath, float repeatX, float repeatY, float* w, float* h)
	{
		_brushStackPointer->image.repeatX = repeatX;
		_brushStackPointer->image.repeatY = repeatY;
		
		if(!filepath || strlen(filepath)==0)
		{
			_brushStackPointer->image.texture = 0;
			return;
		}
		
		if(strlen(filepath)>=AM_STRING_LEN) filepath[AM_STRING_LEN-1] = 0;
		AM_TEXTURE** texture = _images.get(filepath);
		
		if(!*texture)
		{
			SDL_Surface* surface = IMG_Load(filepath);
			if(!surface)
			{
				_images.remove(filepath);
				SDL_FreeSurface(surface);
				return;
			}
			*texture = new AM_TEXTURE();
			_loadTexture(surface, *texture);		
			SDL_FreeSurface(surface);
		}
		_brushStackPointer->image.texture = *texture;
		
		if(w) *w = (*texture)->w;
		if(h) *h = (*texture)->h;
	}
	void font(char *filepath, int size)
	{
		if(filepath==0 || size==0) return;
		
		char fontName[256];
		if(strlen(filepath)>=256) filepath[255]=0;
		sprintf(fontName,"%i~%s",size,filepath);
		AM_FONT** font = _fonts.get(fontName);
		if(!*font)
		{
			TTF_Font* file = TTF_OpenFont(filepath,size);
			if(!file)
			{
				_fonts.remove(fontName);
				return;
			}
			*font = new AM_FONT();
			(*font)->file = file;
			(*font)->height = TTF_FontHeight(file);
			(*font)->ascent = TTF_FontAscent(file);
			(*font)->descent = TTF_FontDescent(file);
			(*font)->lineSpacing = TTF_FontLineSkip(file);
		}
		_brushStackPointer->font = *font;
		TTF_SetFontStyle((*font)->file,0);
	}
	void additiveBlending(bool on)
	{
		_brushStackPointer->blendingMode = on;
		if(on) glBlendFunc(GL_SRC_ALPHA, GL_ONE);
		else glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	}
	
	void pushBrush()
	{
		if(_brushStackPointer-_brushStack>=AM_STACK_SIZE-1) return;
		AM_BRUSH *previousBrush = _brushStackPointer;
		_brushStackPointer += 1;
		memcpy(_brushStackPointer,previousBrush,sizeof(AM_BRUSH));
	}
	bool popBrush()
	{
		if(_brushStackPointer-_brushStack<=0) return false;
		_brushStackPointer -= 1;
		
		fillColor(_brushStackPointer->fill[0],_brushStackPointer->fill[1],
				_brushStackPointer->fill[2],_brushStackPointer->fill[3]);
		lineColor(_brushStackPointer->line[0],_brushStackPointer->line[1],
				_brushStackPointer->line[2],_brushStackPointer->line[3],
				_brushStackPointer->line[4]);
		if(_brushStackPointer->image.texture)
		{
			glEnable(GL_TEXTURE_2D);
			glBindTexture(GL_TEXTURE_2D, _brushStackPointer->image.texture->id);
		} else {
			glDisable(GL_TEXTURE_2D);
		}
		additiveBlending(_brushStackPointer->blendingMode);
		return true;
	}
	
	
	// Raw Triangles
	void beginTriangles()
	{
		if(_brushStackPointer->image.texture) 
		{
			glEnable(GL_TEXTURE_2D);
			glBindTexture( GL_TEXTURE_2D, _brushStackPointer->image.texture->id);\
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
		} else {
			glDisable(GL_TEXTURE_2D);
		}
		glBegin(GL_TRIANGLES);
		_triangles = true;
	}
	
	void endTriangles()
	{
		if(_triangles)
		{
			glEnd();
		}
	}
	
	void textureCoord(float u, float v)
	{
		if(_brushStackPointer->image.texture)
		{
			glTexCoord2f(u*_brushStackPointer->image.texture->s,v*_brushStackPointer->image.texture->t);
		}
	}
	
	void vertex(float x, float y)
	{
		glColor4fv(_brushStackPointer->fill);
		glVertex2f(x,y);
	}
}
