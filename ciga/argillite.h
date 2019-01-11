#ifndef _ARGILLITE_H
#define _ARGILLITE_H

#include <SDL/SDL.h>

#include "abyss.h"

#include "NameTable.h"

#define AR_KEY_NAME_LEN 32

namespace ciga {
	// Internal
	void _arKeyEvent(SDL_KeyboardEvent *key);
	
	// Key Functions
	bool key(int key);
	bool rawKey(int key);
	void bind(int key, int binding);
	int binding(int key);
	int catchKey();
	void keyName(char* destination, int key);
	int keyCode(char* name); // this is slow -- store the result
	int modifiedKey(int key);
	int* catchType();
	
	// Time Functions
	int time();
	void delay(int milliseconds);
}

#endif /* _ARGILLITE_H */
