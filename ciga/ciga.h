#ifndef _CIGA_H
#define _CIGA_H

#include "albillo.h"
#include "amaryllis.h"
#include "amaryllis-gui.h"
#include "argillite.h"
#include "acorn.h"
#include "andromeda.h"
#include "avocado.h"
#include "abyss.h"

#include "MemoryBlock.h"
#include "Node.h"
#include "List.h"
#include "NameTable.h"
#include "SpaceTree.h"

extern bool debug;

namespace ciga {
	void initialize(char* title,int width, int height, int depth, bool fullscreen)
	{
		if(debug)
			printf("Initializing amaryllis subsystem\n");
		_amInitialize(width,height,depth,fullscreen);
		SDL_WM_SetCaption(title,0);
		if(debug)
			printf("Initializing albillo subsystem\n");
		_alInitialize();
		if(debug)
			printf("Initializing andromeda subsystem\n");
		_anInitialize();
	}
	bool update(int* width=0,int* height=0)
	{
		_alUpdate();
		return _amUpdate(width,height);
	}
	void flush()
	{
		_avFlush();
		_alFlush();
		_amFlush();
		_guiFlush();
		_anFlush();
		_abFlush();
	}
	void exit()
	{
		flush();
		_alExit();
		_amExit();
	}
}

#endif /* _CIGA_H */
