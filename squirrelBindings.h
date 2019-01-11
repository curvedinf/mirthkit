#ifndef _SQUIRRELBINDINGS_H
#define _SQUIRRELBINDINGS_H

#include "download.h"

#include <squirrel3/squirrel.h>
#include <squirrel3/sqstdblob.h>
#include <squirrel3/sqstdsystem.h>
#include <squirrel3/sqstdio.h>
#include <squirrel3/sqstdmath.h>
#include <squirrel3/sqstdstring.h>
#include <squirrel3/sqstdaux.h>

#include <SDL/SDL_mouse.h>

using namespace ciga;

extern bool devMode;
extern bool debug;

// misc

SQInteger sb_srand(HSQUIRRELVM v)
{
	SQInteger seed;
	sq_getinteger(v,2,&seed);
	srand(seed);
	return 0;
}

// ciga

SQInteger sb_update(HSQUIRRELVM v)
{
	while(popWindow());
	
	/*if(devMode)
	{
		pushBrush();
		char path[] = "http://www.mirthkit.com/MirthKit.png";
		image(download(path),1,1);
		fillColor(1,1,1,1);
		lineColor(0,0,0,0,0);
		rect(0,h-40,120,40);
		popBrush();
	}*/
	
	if(update(&w,&h)) font((char*)DEFAULT_FONT);
	sq_newarray(v,0);
	sq_pushfloat(v,w);
	sq_arrayappend(v,-2);
	sq_pushfloat(v,h);
	sq_arrayappend(v,-2);
	return 1;
}

SQInteger sb_size(HSQUIRRELVM v)
{
	sq_newarray(v,0);
	sq_pushfloat(v,w);
	sq_arrayappend(v,-2);
	sq_pushfloat(v,h);
	sq_arrayappend(v,-2);
	return 1;
}

SQInteger sb_loadFile(HSQUIRRELVM v)
{
	SQChar* str;
	sq_getstring(v,2,((const SQChar**)&str));
	if(debug)
		printf("loadNut(%s)\n",str);
	str = download(str);
	sq_pushroottable(v);
	sqstd_loadfile(v,str,true);
	return 1;
}

SQInteger sb_doFile(HSQUIRRELVM v)
{
	SQChar* str;
	sq_getstring(v,2,((const SQChar**)&str));
	if(debug)
		printf("doNut(%s)\n",str);
	str = download(str);
	sq_pushroottable(v);
	sqstd_dofile(v,str,false,true);
	return 0;
}

SQInteger sb_writef(HSQUIRRELVM v)
{
	const SQChar* file,*str;
	sq_getstring(v,2,&file);
	sq_getstring(v,3,&str);
	
	FILE* f = fopen(file,"w");
	int len = strlen((char*)str);
	fwrite((char*)str,len,1,f);
	fclose(f);
	
	return 0;
}

SQInteger sb_readf(HSQUIRRELVM v)
{
	const SQChar* file;
	sq_getstring(v,2,&file);
	
	
	char* str = new char[1024*1024*5];
	str[0] = 0;
	
	FILE* f = fopen((char*)file,"r");
	if(f)
	{
		fread(str,1024*1024*5,1,f);
		fclose(f);
	}
	
	sq_pushstring(v,(const SQChar*)str,-1);
	
	delete [] str;
	
	return 1;
}

// andromeda
SQInteger sb_open(HSQUIRRELVM v)
{
	const SQChar* str;
	SQInteger p;
	sq_getstring(v,2,&str);
	sq_getinteger(v,3,&p);
	open((char*)str,(unsigned int)p);
	return 0;
}

SQInteger sb_close(HSQUIRRELVM v)
{
	const SQChar* str;
	sq_getstring(v,2,&str);
	close((char*)str);
	return 0;
}

SQInteger sb_send(HSQUIRRELVM v)
{
	const SQChar* name, *addr, *data;
	SQInteger p;
	sq_getstring(v,2,&name);
	sq_getstring(v,3,&addr);
	sq_getinteger(v,4,&p);
	sq_getstring(v,5,&data);
	
	int length = strlen((char*)data);
	if(length>0)
		send((char*)name,(char*)addr,p,(char*)data,length);
	return 0;
}

SQInteger sb_receive(HSQUIRRELVM v)
{
	const SQChar* name;
	sq_getstring(v,2,&name);
	
	char addr[64], data[(int)((unsigned short)-1)+1];
	unsigned short port, length;
	
	if(receive((char*)name,addr,&port,data,&length))
	{
		data[length] = 0;
		sq_newarray(v,0);
		sq_pushstring(v,addr,-1);
		sq_arrayappend(v,-2);
		sq_pushinteger(v,port);
		sq_arrayappend(v,-2);
		sq_pushstring(v,data,-1);
		sq_arrayappend(v,-2);
		return 1;
	}
	sq_pushnull(v);
	return 1;
}

// amaryllis
SQInteger sb_background(HSQUIRRELVM v)
{
	SQFloat r,g,b;
	sq_getfloat(v,2,&r);
	sq_getfloat(v,3,&g);
	sq_getfloat(v,4,&b);
	clearColor(r,g,b);
	return 0;
}

SQInteger sb_pushWindow(HSQUIRRELVM v)
{
	SQFloat x,y,w,h,s,r;
	SQBool m;
	sq_getfloat(v,2,&x);
	sq_getfloat(v,3,&y);
	sq_getfloat(v,4,&w);
	sq_getfloat(v,5,&h);
	sq_getfloat(v,6,&s);
	sq_getfloat(v,7,&r);
	sq_getbool(v,8,&m);
	pushWindow(x,y,w,h,s,r,m);
	return 0;
}

SQInteger sb_popWindow(HSQUIRRELVM v)
{
	popWindow();
	return 0;
}

SQInteger sb_line(HSQUIRRELVM v)
{
	SQFloat x,y,w,h;
	sq_getfloat(v,2,&x);
	sq_getfloat(v,3,&y);
	sq_getfloat(v,4,&w);
	sq_getfloat(v,5,&h);
	line(x,y,w,h);
	return 0;
}

SQInteger sb_rect(HSQUIRRELVM v)
{
	SQFloat x,y,w,h;
	sq_getfloat(v,2,&x);
	sq_getfloat(v,3,&y);
	sq_getfloat(v,4,&w);
	sq_getfloat(v,5,&h);
	rect(x,y,w,h);
	return 0;
}

SQInteger sb_text(HSQUIRRELVM v)
{
	const SQChar* str;
	SQFloat x,y,w;
	sq_getstring(v,2,&str);
	sq_getfloat(v,3,&x);
	sq_getfloat(v,4,&y);
	sq_getfloat(v,5,&w);
	sq_pushfloat(v,text((char*)str,x,y,w));
	return 1;
}

SQInteger sb_cursorText(HSQUIRRELVM v)
{
	const SQChar* str;
	SQFloat x,y,mw,cx,cy;
	sq_getstring(v,2,&str);
	sq_getfloat(v,3,&x);
	sq_getfloat(v,4,&y);
	sq_getfloat(v,5,&mw);
	sq_getfloat(v,6,&cx);
	sq_getfloat(v,7,&cy);
	float h = text((char*)str,x,y,mw,&cx,&cy);
	sq_newarray(v,0);
	sq_pushfloat(v,cx);
	sq_arrayappend(v,-2);
	sq_pushfloat(v,cy);
	sq_arrayappend(v,-2);
	sq_pushfloat(v,h);
	sq_arrayappend(v,-2);
	return 1;
}

SQInteger sb_fillColor(HSQUIRRELVM v)
{
	SQFloat r,g,b,a;
	sq_getfloat(v,2,&r);
	sq_getfloat(v,3,&g);
	sq_getfloat(v,4,&b);
	sq_getfloat(v,5,&a);
	fillColor(r,g,b,a);
	return 0;
}

SQInteger sb_lineColor(HSQUIRRELVM v)
{
	SQFloat r,g,b,a,w;
	sq_getfloat(v,2,&r);
	sq_getfloat(v,3,&g);
	sq_getfloat(v,4,&b);
	sq_getfloat(v,5,&a);
	sq_getfloat(v,6,&w);
	lineColor(r,g,b,a,w);
	return 0;
}

SQInteger sb_image(HSQUIRRELVM v)
{
	SQChar* str;
	SQFloat x,y;
	float w,h;
	sq_getstring(v,2,((const SQChar**)&str));
	sq_getfloat(v,3,&x);
	sq_getfloat(v,4,&y);
	str = download(str);
	image(str,x,y,&w,&h);
	sq_newarray(v,0);
	sq_pushfloat(v,w);
	sq_arrayappend(v,-2);
	sq_pushfloat(v,h);
	sq_arrayappend(v,-2);
	return 1;
}

SQInteger sb_font(HSQUIRRELVM v)
{
	SQChar* str;
	SQInteger s;
	sq_getstring(v,2,(const SQChar**)&str);
	sq_getinteger(v,3,&s);
	str = download(str);
	font((char*)str,s);
	return 0;
}

SQInteger sb_additiveBlending(HSQUIRRELVM v)
{
	SQBool on;
	sq_getbool(v,2,&on);
	additiveBlending(on);
	return 0;
}

SQInteger sb_pushBrush(HSQUIRRELVM v)
{
	pushBrush();
	return 0;
}

SQInteger sb_popBrush(HSQUIRRELVM v)
{
	popBrush();
	return 0;
}

SQInteger sb_beginTriangles(HSQUIRRELVM v)
{
	beginTriangles();
	return 0;
}

SQInteger sb_endTriangles(HSQUIRRELVM v)
{
	endTriangles();
	return 0;
}

SQInteger sb_textureCoord(HSQUIRRELVM v)
{
	SQFloat u,_v;
	sq_getfloat(v,2,&u);
	sq_getfloat(v,3,&_v);
	textureCoord(u,_v);
	return 0;
}

SQInteger sb_vertex(HSQUIRRELVM v)
{
	SQFloat x,y;
	sq_getfloat(v,2,&x);
	sq_getfloat(v,3,&y);
	vertex(x,y);
	return 0;
}

// Mouse Input

SQInteger sb_mousePos(HSQUIRRELVM v)
{
	int x,y;
	SDL_GetMouseState(&x,&y);
	SQInteger sx=x;
	SQInteger sy=y;
	sq_newarray(v,0);
	sq_pushinteger(v,sx);
	sq_arrayappend(v,-2);
	sq_pushinteger(v,sy);
	sq_arrayappend(v,-2);
	return 1;
}

SQInteger sb_mouseButton(HSQUIRRELVM v)
{
	SQInteger buttonNumber;
	sq_getinteger(v,2,&buttonNumber);
	int buttonStates = SDL_GetMouseState(0,0);
	sq_pushbool(v,buttonStates&SDL_BUTTON(buttonNumber));
	return 1;
}

SQInteger sb_toggleCursor(HSQUIRRELVM v)
{
	SQInteger toggle;
	sq_getinteger(v,2,&toggle);
	SDL_ShowCursor(toggle);
	return 0;
}

// Key Input

SQInteger sb_key(HSQUIRRELVM v)
{
	SQInteger k;
	sq_getinteger(v,2,&k);
	sq_pushbool(v,key(k));
	return 1;
}

SQInteger sb_rawKey(HSQUIRRELVM v)
{
	SQInteger k;
	sq_getinteger(v,2,&k);
	sq_pushbool(v,rawKey(k));
	return 1;
}

SQInteger sb_bind(HSQUIRRELVM v)
{
	SQInteger k,b;
	sq_getinteger(v,2,&k);
	sq_getinteger(v,3,&b);
	bind(k,b);
	return 0;
}

SQInteger sb_binding(HSQUIRRELVM v)
{
	SQInteger k;
	sq_getinteger(v,2,&k);
	sq_pushinteger(v,binding(k));
	return 1;
}

SQInteger sb_catchKey(HSQUIRRELVM v)
{
	sq_pushinteger(v,catchKey());
	return 1;
}

SQInteger sb_keyName(HSQUIRRELVM v)
{
	SQInteger k;
	SQChar keyString[AR_KEY_NAME_LEN];
	sq_getinteger(v,2,&k);
	keyName(keyString,k);
	sq_pushstring(v,keyString,-1);
	return 1;
}

SQInteger sb_keyCode(HSQUIRRELVM v)
{
	const SQChar* str;
	sq_getstring(v,2,&str);
	sq_pushinteger(v,keyCode((char*)str));
	return 1;
}

SQInteger sb_modifiedKey(HSQUIRRELVM v)
{
	SQInteger k;
	sq_getinteger(v,2,&k);
	sq_pushinteger(v,modifiedKey(k));
	return 1;
}

SQInteger sb_catchType(HSQUIRRELVM v)
{
	int* keysPressed = catchType();
	
	sq_newarray(v,0);
	
	int i=0;
	while(true) {
		int thisKey = keysPressed[i];
		if(!thisKey) break;
		sq_pushinteger(v,thisKey);
		sq_arrayappend(v,-2);
		i++;
	}
	return 1;
}

SQInteger sb_time(HSQUIRRELVM v)
{	
	sq_pushinteger(v,time());
	return 1;
}

SQInteger sb_micros(HSQUIRRELVM v)
{	
	sq_pushinteger(v,micros());
	return 1;
}

// Sound

SQInteger sb_soundVolume(HSQUIRRELVM v)
{
	SQFloat s;
	sq_getfloat(v,2,&s);
	soundVolume(s);
	return 0;
}

SQInteger sb_musicVolume(HSQUIRRELVM v)
{
	SQFloat m;
	sq_getfloat(v,2,&m);
	musicVolume(m);
	return 0;
}

SQInteger sb_musicFade(HSQUIRRELVM v)
{
	SQFloat vol,seconds;
	sq_getfloat(v,2,&vol);
	sq_getfloat(v,3,&seconds);
	musicFade(vol,seconds);
	return 0;
}

SQInteger sb_sound(HSQUIRRELVM v)
{
	SQChar* file;
	SQFloat a,d;
	sq_getstring(v,2,(const SQChar**)&file);
	sq_getfloat(v,3,&a);
	sq_getfloat(v,4,&d);
	file = download(file);
	sound(file,a,d);
	return 0;
}

SQInteger sb_music(HSQUIRRELVM v)
{
	SQChar* file;
	sq_getstring(v,2,(const SQChar**)&file);
	file = download(file);
	music(file);
	return 0;
}

// Storage

SQInteger sb_store(HSQUIRRELVM v)
{
	SQChar* vaultName;
	SQChar* name;
	SQChar* value;
	sq_getstring(v,2,(const SQChar**)&vaultName);
	sq_getstring(v,3,(const SQChar**)&name);
	sq_getstring(v,4,(const SQChar**)&value);
	
	store(vaultName,name,value);
	return 0;
}

SQInteger sb_retrieve(HSQUIRRELVM v)
{
	SQChar* vaultName;
	SQChar* name;
	sq_getstring(v,2,(const SQChar**)&vaultName);
	sq_getstring(v,3,(const SQChar**)&name);
	SQChar* value = retrieve(vaultName,name);
	
	sq_pushstring(v,value,-1);
	return 1;
}

// Simple Gui

SQInteger sb_guiMoveDown(HSQUIRRELVM v)
{
	guiMoveDown();
	return 0;
}

SQInteger sb_guiMoveRight(HSQUIRRELVM v)
{
	guiMoveRight();
	return 0;
}

SQInteger sb_guiMoveUp(HSQUIRRELVM v)
{
	guiMoveUp();
	return 0;
}

SQInteger sb_guiMoveLeft(HSQUIRRELVM v)
{
	guiMoveLeft();
	return 0;
}

SQInteger sb_guiBoxFill(HSQUIRRELVM v)
{
	SQFloat r,g,b,a;
	sq_getfloat(v,2,&r);
	sq_getfloat(v,3,&g);
	sq_getfloat(v,4,&b);
	sq_getfloat(v,5,&a);
	guiBoxFill(r,g,b,a);
	return 0;
}

SQInteger sb_guiBoxBorder(HSQUIRRELVM v)
{
	SQFloat r,g,b,a,w;
	sq_getfloat(v,2,&r);
	sq_getfloat(v,3,&g);
	sq_getfloat(v,4,&b);
	sq_getfloat(v,5,&a);
	sq_getfloat(v,6,&w);
	guiBoxBorder(r,g,b,a,w);
	return 0;
}

SQInteger sb_guiPushBox(HSQUIRRELVM v)
{
	SQFloat w,h,mx,my,px,py;
	sq_getfloat(v,2,&w);
	sq_getfloat(v,3,&h);
	sq_getfloat(v,4,&mx);
	sq_getfloat(v,5,&my);
	sq_getfloat(v,6,&px);
	sq_getfloat(v,7,&py);
	guiPushBox(w,h,mx,my,px,py);
	return 0;
}

SQInteger sb_guiPopBox(HSQUIRRELVM v)
{
	guiPopBox();
	return 0;
}

SQInteger sb_guiOriginBox(HSQUIRRELVM v)
{
	guiOriginBox();
	return 0;
}

SQInteger sb_guiText(HSQUIRRELVM v)
{
	SQChar* str;
	SQFloat vmargin;
	sq_getstring(v,2,(const SQChar**)&str);
	sq_getfloat(v,3,&vmargin);
	guiText(str,vmargin);
	return 0;
}

SQInteger sb_guiImage(HSQUIRRELVM v)
{
	SQChar* str;
	SQFloat w,h,vmargin;
	sq_getstring(v,2,(const SQChar**)&str);
	sq_getfloat(v,3,&w);
	sq_getfloat(v,4,&h);
	sq_getfloat(v,5,&vmargin);
	guiImage(str,w,h,vmargin);
	return 0;
}

SQInteger sb_guiBeginButton(HSQUIRRELVM v)
{
	SQChar* str;
	SQFloat padding;
	sq_getstring(v,2,(const SQChar**)&str);
	sq_getfloat(v,3,&padding);
	sq_pushinteger(v,guiBeginButton(str,padding));
	return 1;
}

SQInteger sb_guiEndButton(HSQUIRRELVM v)
{
	sq_pushinteger(v,guiEndButton());
	return 1;
}

SQInteger sb_guiButtonUpBorder(HSQUIRRELVM v)
{
	SQFloat r,g,b,a,w;
	sq_getfloat(v,2,&r);
	sq_getfloat(v,3,&g);
	sq_getfloat(v,4,&b);
	sq_getfloat(v,5,&a);
	sq_getfloat(v,6,&w);
	guiButtonUpBorder(r,g,b,a,w);
	return 0;
}

SQInteger sb_guiButtonOverBorder(HSQUIRRELVM v)
{
	SQFloat r,g,b,a,w;
	sq_getfloat(v,2,&r);
	sq_getfloat(v,3,&g);
	sq_getfloat(v,4,&b);
	sq_getfloat(v,5,&a);
	sq_getfloat(v,6,&w);
	guiButtonOverBorder(r,g,b,a,w);
	return 0;
}

SQInteger sb_guiButtonDownBorder(HSQUIRRELVM v)
{
	SQFloat r,g,b,a,w;
	sq_getfloat(v,2,&r);
	sq_getfloat(v,3,&g);
	sq_getfloat(v,4,&b);
	sq_getfloat(v,5,&a);
	sq_getfloat(v,6,&w);
	guiButtonDownBorder(r,g,b,a,w);
	return 0;
}

// Compression & Encryption

SQInteger sb_compress(HSQUIRRELVM v)
{
	SQChar* str;
	SQInteger l;
	sq_getstring(v,2,(const SQChar**)&str);
	sq_getinteger(v,3,&l);
	char* out = new char[ABYSS_BUFFER_SIZE];
	compress(str,out,l);
	sq_pushstring(v,out,-1);
	delete [] out;
	return 1;
}

SQInteger sb_decompress(HSQUIRRELVM v)
{
	SQChar* comp;
	sq_getstring(v,2,(const SQChar**)&comp);
	char* out = new char[ABYSS_BUFFER_SIZE];
	decompress(comp,out);
	sq_pushstring(v,out,-1);
	delete [] out;
	return 1;
}

SQInteger sb_hash(HSQUIRRELVM v)
{
	SQChar* string;
	sq_getstring(v,2,(const SQChar**)&string);
	char* out = new char[ABYSS_HASH_SIZE];
	hash(string,out);
	sq_pushstring(v,out,-1);
	delete [] out;
	return 1;
}

SQInteger sb_encrypt(HSQUIRRELVM v)
{
	SQChar* str;
	SQChar* pass;
	sq_getstring(v,2,(const SQChar**)&str);
	sq_getstring(v,3,(const SQChar**)&pass);
	char* out = new char[ABYSS_BUFFER_SIZE];
	encrypt(str,pass,out);
	sq_pushstring(v,out,-1);
	delete [] out;
	return 1;
}

SQInteger sb_decrypt(HSQUIRRELVM v)
{
	SQChar* enc;
	SQChar* pass;
	sq_getstring(v,2,(const SQChar**)&enc);
	sq_getstring(v,3,(const SQChar**)&pass);
	char* out = new char[ABYSS_BUFFER_SIZE];
	out[0] = 0;
	decrypt(enc,pass,out);
	sq_pushstring(v,out,-1);
	delete [] out;
	return 1;
}

// Squirrel Specific

SQInteger sb_register(HSQUIRRELVM v,SQFUNCTION f,const char *fname)
 {
	if(debug)
		printf("Registering binding: %s\n",fname);
    sq_pushroottable(v);
    sq_pushstring(v,fname,-1);
    sq_newclosure(v,f,0);
    sq_createslot(v,-3);
    sq_pop(v,1);
    return 0;
 }
 
 SQInteger sb_debugHook(HSQUIRRELVM v,SQFUNCTION f,const char *fname)
 {
    sq_pushroottable(v);
    sq_pushstring(v,fname,-1);
    sq_newclosure(v,f,0);
    sq_setdebughook(v);
    sq_pop(v,1);
    return 0;
 }

#endif /* _SQUIRRELBINDINGS_H */
