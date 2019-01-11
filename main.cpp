#include <SDL/SDL.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <sys/stat.h>
#include <time.h>
#include <signal.h>
#include <unistd.h>

#ifndef WIN32
#include <execinfo.h>
#endif


#include <squirrel3/squirrel.h>
#include <squirrel3/sqstdblob.h>
#include <squirrel3/sqstdsystem.h>
#include <squirrel3/sqstdio.h>
#include <squirrel3/sqstdmath.h>
#include <squirrel3/sqstdstring.h>
#include <squirrel3/sqstdaux.h>

#ifdef WIN32
#include <direct.h>
#define F_OK 0
#define mkdir(x,y) (mkdir)(x)
#endif

#define MIRTHKIT_MAJOR_VERSION 1
#define MIRTHKIT_MINOR_VERSION 2

//#define DEFAULT_ENTRY "http://curved.dlinkddns.com/arcade.py?k=0&f=/Arcade/script/main.nut"
#define DEFAULT_ENTRY "http://cihs.local/arcade.py?k=0&f=/Arcade/script/main.nut"

//#define DEFAULT_DEV_ENTRY "main.nut"
//#define DEFAULT_FONT "DejaVuSans.ttf",12

#ifdef LINUX_32
#define DEFAULT_DEV_ENTRY "main.nut"
#define DEFAULT_FONT "/usr/share/mirthkit/DejaVuSans.ttf",12
#endif

#ifdef WIN32
#define DEFAULT_DEV_ENTRY "main.nut"
#define DEFAULT_FONT "C:/Program Files/MirthKit/DejaVuSans.ttf",12
#endif

#ifdef MAC_OSX
#define DEFAULT_DEV_ENTRY "main.nut"
#define DEFAULT_FONT "/Applications/MirthKit.app/Contents/MacOS/DejaVuSans.ttf",12
#endif

#define TITLE "MirthKit"

#include "squirrelBindings.h"

bool exiting = false;

HSQUIRRELVM v;
int w=800,h=600;

bool devMode = false;
bool redownload = false;
bool debug = false;

void printfunc(HSQUIRRELVM v,const SQChar *s,...)
{
	va_list vl;
	va_start(vl, s);
	vprintf( s, vl);
	va_end(vl);
}

void initSquirrel()
{
	v=sq_open(1024*128);
	sq_setprintfunc(v,printfunc,printfunc);
	sq_pushroottable(v);
	sqstd_register_systemlib(v);
	sqstd_register_mathlib(v);
	sqstd_register_stringlib(v);
	sqstd_seterrorhandlers(v);
	/*if(devMode)
	{
		sqstd_register_iolib(v);
		sqstd_register_bloblib(v);
	}*/
}

void initPlayer()
{
	#ifdef LINUX_32
	char* homestr = getenv("HOME");
	char fullpath[2048];
	sprintf(fullpath,"%s/.mirthkit",homestr);
	mkdir(fullpath,S_IRWXU|S_IRGRP|S_IROTH);
	#endif
	
	char* size = retrieve((char*)"Config",(char*)"WindowSize");
	if(size) sscanf(size,"%d,%d",&w,&h);
	
	if(debug)
		printf("Retrieved window size preference: %ix%i\n", w, h);
	
	srand(millis());
	
	initSquirrel();
	
	if(debug)
		printf("Initialized Squirrel\n");
	
	if(debug)
		printf("Initialized curl\n");
	
	initCurl();
	
	if(debug)
		printf("Initializing MirthKit subsystems...\n");
	
	initialize((char*)TITLE,w,h,32,false);
	
	if(debug)
		printf("Initializing MirthKit subsystems complete\n");
}

void exitPlayer()
{
	char size[1024];
	sprintf(size,"%d,%d",w,h);
	store((char*)"Config",(char*)"WindowSize",size);
	
	
	sq_close(v);
	ciga::exit();
	exitCurl();
	exiting = true;
}

SQInteger sb_lineInterupt(HSQUIRRELVM v)
{
	SQInteger t;
	sq_getinteger(v,2,&t);
	static int previous = 0;
	static int frames = 0;
	frames++;
	if(frames>10)
	{		
		//delay(5);
		frames=0;
	}
	int time = ciga::time();
	if(time-previous>5)
	{
		frames=0;
		previous = ciga::time();
		SDL_PumpEvents();
		if(rawKey(SDLK_ESCAPE))
		{
			exitPlayer();
			exit(0);
		}
	}
	return 0;
}

SQInteger sb_version(HSQUIRRELVM v)
{
	sq_newarray(v,0);
	sq_pushinteger(v,MIRTHKIT_MAJOR_VERSION);
	sq_arrayappend(v,-2);
	sq_pushinteger(v,MIRTHKIT_MINOR_VERSION);
	sq_arrayappend(v,-2);
	return 1;
}

SQInteger sb_flush(HSQUIRRELVM v);

void registerBindings(HSQUIRRELVM v)
{
	// ciga
	sb_register(v,sb_update,"update");
	sb_register(v,sb_size,"screen");
	sb_register(v,sb_flush,"flush");
	
	// misc
	sb_register(v,sb_srand,"srand");
	sb_register(v,sb_version,"version");
	
	// scripts
	sb_register(v,sb_loadFile,"loadNut");
	sb_register(v,sb_doFile,"doNut");
	
	// download
	sb_register(v,sb_http,"http"); // does not cache
	sb_register(v,sb_progress,"progress");
	
	// andromeda
	sb_register(v,sb_open,"open");
	sb_register(v,sb_close,"close");
	sb_register(v,sb_send,"send");
	sb_register(v,sb_receive,"receive");
	
	// amaryllis
	sb_register(v,sb_background,"background");
	sb_register(v,sb_pushWindow,"modifyWindow");
	sb_register(v,sb_popWindow,"revertWindow");
	sb_register(v,sb_line,"line");
	sb_register(v,sb_rect,"rect");
	sb_register(v,sb_text,"text");
	sb_register(v,sb_cursorText,"cursorText");
	sb_register(v,sb_fillColor,"fillColor");
	sb_register(v,sb_lineColor,"lineColor");
	sb_register(v,sb_image,"image");
	sb_register(v,sb_font,"font");
	sb_register(v,sb_additiveBlending,"additiveBlending");
	sb_register(v,sb_pushBrush,"modifyBrush");
	sb_register(v,sb_popBrush,"revertBrush");
	sb_register(v,sb_beginTriangles,"beginTriangles");
	sb_register(v,sb_endTriangles,"endTriangles");
	sb_register(v,sb_textureCoord,"textureCoord");
	sb_register(v,sb_vertex,"vertex");
	
	// mouse
	sb_register(v,sb_mousePos,"mouse");
	sb_register(v,sb_mouseButton,"mouseButton");
	sb_register(v,sb_toggleCursor,"cursor");
	
	// argillite
	sb_register(v,sb_key,"key");
	sb_register(v,sb_rawKey,"rawKey");
	sb_register(v,sb_bind,"bind");
	sb_register(v,sb_binding,"binding");
	sb_register(v,sb_catchKey,"catchKey");
	sb_register(v,sb_keyName,"keyName");
	sb_register(v,sb_keyCode,"keyCode");
	sb_register(v,sb_modifiedKey,"modifiedKey");
	sb_register(v,sb_catchType,"catchType");
	sb_register(v,sb_time,"millis");
	sb_register(v,sb_micros,"micros");
	
	// albillo
	sb_register(v,sb_musicVolume,"musicVolume");
	sb_register(v,sb_musicFade,"musicFade");
	sb_register(v,sb_soundVolume,"soundVolume");
	sb_register(v,sb_sound,"sound");
	sb_register(v,sb_music,"music");
	
	// avocado
	sb_register(v,sb_store,"store");
	sb_register(v,sb_retrieve,"retrieve");
	
	// amaryllis-gui
	sb_register(v,sb_guiMoveDown,"guiMoveDown");
	sb_register(v,sb_guiMoveRight,"guiMoveRight");
	sb_register(v,sb_guiMoveUp,"guiMoveUp");
	sb_register(v,sb_guiMoveLeft,"guiMoveLeft");
	sb_register(v,sb_guiBoxFill,"guiStripFill");
	sb_register(v,sb_guiBoxBorder,"guiStripBorder");
	sb_register(v,sb_guiPushBox,"guiNewStrip");
	sb_register(v,sb_guiPopBox,"guiPreviousStrip");
	sb_register(v,sb_guiOriginBox,"guiOriginStrip");
	sb_register(v,sb_guiText,"guiText");
	sb_register(v,sb_guiImage,"guiImage");
	sb_register(v,sb_guiBeginButton,"guiBeginButton");
	sb_register(v,sb_guiEndButton,"guiEndButton");
	sb_register(v,sb_guiButtonUpBorder,"guiButtonUpBorder");
	sb_register(v,sb_guiButtonOverBorder,"guiButtonOverBorder");
	sb_register(v,sb_guiButtonDownBorder,"guiButtonDownBorder");
	
	// abyss
	sb_register(v,sb_compress,"compress");
	sb_register(v,sb_decompress,"decompress");
	sb_register(v,sb_hash,"hash");
	sb_register(v,sb_encrypt,"encrypt");
	sb_register(v,sb_decrypt,"decrypt");
	
	if(devMode)
	{
		sb_register(v,sb_readf,"readfile");
		sb_register(v,sb_writef,"writefile");
	}
	
	// Enable per-line interupts
	//sb_debugHook(v,sb_lineInterupt,"debugHook");
	//sq_enabledebuginfo(v,true);
}

SQInteger sb_flush(HSQUIRRELVM v)
{
	flush();
	registerBindings(v);
	while(popWindow());
	while(popBrush());
	guiOriginBox();
	image((char*)"",0,0);
	font((char*)DEFAULT_FONT);
	
	return 0;
}

#ifndef WIN32
void handler(int sig) {
	void *array[10];
	size_t size;

	// get void*'s for all entries on the stack
	size = backtrace(array, 10);

	// print out all the frames to stderr
	fprintf(stderr, "Error: signal %d:\n", sig);
	backtrace_symbols_fd(array, size, STDERR_FILENO);
	exit(1);
}
#endif

int main(int argc, char **argv)
{
#ifndef WIN32
	signal(SIGSEGV, handler);
#endif
	
	devMode = true; // always run ./ main.nut
	
	for(int i=1; i<argc; i++) {
		if(strcmp(argv[i],"-dev")==0)
			devMode = true;
		else if(strcmp(argv[i],"-fresh")==0)
			redownload = true;
		else if(strcmp(argv[i],"-debug")==0)
			debug = true;
		else if(strcmp(argv[i],"-help")==0)
		{
			printf("Usage: mirthkit [OPTIONS]\n");
			printf("Options are:\n");
			printf("Usage: mirthkit [OPTIONS]\n");
			printf("\t-dev\t\trun ./main.nut\n");
			printf("\t-debug\t\tprint debug information\n");
			printf("\t-fresh\t\tdownload all new copies of cached files\n");
			printf("\t-help\t\tprint this help information\n");
		} else
			printf("Use -help for a list of options\n");
	}
	
	if(debug)
		printf("Initializing client...\n");
	
	initPlayer();
	
	if(debug)
		printf("Initialization complete\n");
	
	if(debug)
		printf("Registering Squirrel bindings...\n");
	
	registerBindings(v);
	
	if(debug)
		printf("Bindings registered\n");
	
	font((char*)DEFAULT_FONT);
	
	if(debug)
		printf("Default font loaded: %s,%i\n",DEFAULT_FONT);
	
	if(devMode) {
		if(debug)
			printf("Entering local Squirrel flow: %s\n",DEFAULT_DEV_ENTRY);
		sqstd_dofile(v,DEFAULT_DEV_ENTRY,SQFalse,SQTrue);
	} else {
		if(debug)
			printf("Downloading remote Squirrel flow: %s\n",DEFAULT_ENTRY);
		char* file = download((char*)DEFAULT_ENTRY);
		if(debug)
			printf("Entering downloaded remote Squirrel flow: %s\n",file);
		sqstd_dofile(v,file,SQFalse,SQTrue);
	}
	
	exitPlayer();
	return 0;
}
