#include "argillite.h"

#include <SDL/SDL.h>

#include <string.h>

namespace ciga {
	
	struct AR_BINDING
	{
		int binding;
		AR_BINDING()
		{
			static int num=0;
			binding = num;
			num++;
		}
	};
	
	AR_BINDING _bindings[SDLK_LAST];
	
	NameTable<SDL_KeyboardEvent> _typeStates;
	int _keysPressed[1024];
	
	// Internal
	void _arKeyEvent(SDL_KeyboardEvent *key)
	{
		char keyName[8];
		_enc64((char*)&key->keysym.sym,sizeof(SDLKey),keyName);
		SDL_KeyboardEvent** typeState = _typeStates.get(keyName);
		if(!*typeState)
		{
			*typeState = new SDL_KeyboardEvent;
		}
		
		printf("%i,%i\n",key->keysym.sym,key->keysym.unicode);
		
		**typeState = *key;
	}
	
	// Key Functions
	bool key(int key)
	{
		Uint8* keystate = SDL_GetKeyState(0);
		return keystate[_bindings[key].binding];
	}
	bool rawKey(int key)
	{
		Uint8* keystate = SDL_GetKeyState(0);
		return keystate[key];
	}
	void bind(int key, int binding)
	{
		_bindings[key].binding = binding;
	}
	int binding(int key)
	{
		return _bindings[key].binding;
	}
	int catchKey()
	{
		Uint8* keystate = SDL_GetKeyState(0);
		for(int i=0; i<SDLK_LAST; i++)
		{
			if(keystate[i]) return i;
		}
		return 0;
	}
	void keyName(char* destination, int key)
	{
		switch(key) {
			case 8: strcpy(destination,"BACKSPACE"); break;
			case 9: strcpy(destination,"TAB"); break;
			case 12: strcpy(destination,"CLEAR"); break;
			case 13: strcpy(destination,"RETURN"); break;
			case 19: strcpy(destination,"PAUSE"); break;
			case 27: strcpy(destination,"ESCAPE"); break;
			case 32: strcpy(destination,"SPACE"); break;
			case 33: strcpy(destination,"EXCLAIM"); break;
			case 34: strcpy(destination,"QUOTEDBL"); break;
			case 35: strcpy(destination,"HASH"); break;
			case 36: strcpy(destination,"DOLLAR"); break;
			case 38: strcpy(destination,"AMPERSAND"); break;
			case 39: strcpy(destination,"QUOTE"); break;
			case 40: strcpy(destination,"LEFTPAREN"); break;
			case 41: strcpy(destination,"RIGHTPAREN"); break;
			case 42: strcpy(destination,"ASTERISK"); break;
			case 43: strcpy(destination,"PLUS"); break;
			case 44: strcpy(destination,"COMMA"); break;
			case 45: strcpy(destination,"MINUS"); break;
			case 46: strcpy(destination,"PERIOD"); break;
			case 47: strcpy(destination,"SLASH"); break;
			case 48: strcpy(destination,"0"); break;
			case 49: strcpy(destination,"1"); break;
			case 50: strcpy(destination,"2"); break;
			case 51: strcpy(destination,"3"); break;
			case 52: strcpy(destination,"4"); break;
			case 53: strcpy(destination,"5"); break;
			case 54: strcpy(destination,"6"); break;
			case 55: strcpy(destination,"7"); break;
			case 56: strcpy(destination,"8"); break;
			case 57: strcpy(destination,"9"); break;
			case 58: strcpy(destination,"COLON"); break;
			case 59: strcpy(destination,"SEMICOLON"); break;
			case 60: strcpy(destination,"LESS"); break;
			case 61: strcpy(destination,"EQUALS"); break;
			case 62: strcpy(destination,"GREATER"); break;
			case 63: strcpy(destination,"QUESTION"); break;
			case 64: strcpy(destination,"AT"); break;
			case 91: strcpy(destination,"LEFTBRACKET"); break;
			case 92: strcpy(destination,"BACKSLASH"); break;
			case 93: strcpy(destination,"RIGHTBRACKET"); break;
			case 94: strcpy(destination,"CARET"); break;
			case 95: strcpy(destination,"UNDERSCORE"); break;
			case 96: strcpy(destination,"BACKQUOTE"); break;
			case 97: strcpy(destination,"A"); break;
			case 98: strcpy(destination,"B"); break;
			case 99: strcpy(destination,"C"); break;
			case 100: strcpy(destination,"D"); break;
			case 101: strcpy(destination,"E"); break;
			case 102: strcpy(destination,"F"); break;
			case 103: strcpy(destination,"G"); break;
			case 104: strcpy(destination,"H"); break;
			case 105: strcpy(destination,"I"); break;
			case 106: strcpy(destination,"J"); break;
			case 107: strcpy(destination,"K"); break;
			case 108: strcpy(destination,"L"); break;
			case 109: strcpy(destination,"M"); break;
			case 110: strcpy(destination,"N"); break;
			case 111: strcpy(destination,"O"); break;
			case 112: strcpy(destination,"P"); break;
			case 113: strcpy(destination,"Q"); break;
			case 114: strcpy(destination,"R"); break;
			case 115: strcpy(destination,"S"); break;
			case 116: strcpy(destination,"T"); break;
			case 117: strcpy(destination,"U"); break;
			case 118: strcpy(destination,"V"); break;
			case 119: strcpy(destination,"W"); break;
			case 120: strcpy(destination,"X"); break;
			case 121: strcpy(destination,"Y"); break;
			case 122: strcpy(destination,"Z"); break;
			case 127: strcpy(destination,"DELETE"); break;
			// end ascii-mapped goodness
			case 256: strcpy(destination,"KP0"); break;
			case 257: strcpy(destination,"KP1"); break;
			case 258: strcpy(destination,"KP2"); break;
			case 259: strcpy(destination,"KP3"); break;
			case 260: strcpy(destination,"KP4"); break;
			case 261: strcpy(destination,"KP5"); break;
			case 262: strcpy(destination,"KP6"); break;
			case 263: strcpy(destination,"KP7"); break;
			case 264: strcpy(destination,"KP8"); break;
			case 265: strcpy(destination,"KP9"); break;
			case 266: strcpy(destination,"KPPERIOD"); break;
			case 267: strcpy(destination,"KPDIVIDE"); break;
			case 268: strcpy(destination,"KPMULTIPLY"); break;
			case 269: strcpy(destination,"KPMINUS"); break;
			case 270: strcpy(destination,"KPPLUS"); break;
			case 271: strcpy(destination,"KPENTER"); break;
			case 272: strcpy(destination,"KPEQUALS"); break;
			case 273: strcpy(destination,"UP"); break;
			case 274: strcpy(destination,"DOWN"); break;
			case 275: strcpy(destination,"RIGHT"); break;
			case 276: strcpy(destination,"LEFT"); break;
			case 277: strcpy(destination,"INSERT"); break;
			case 278: strcpy(destination,"HOME"); break;
			case 279: strcpy(destination,"END"); break;
			case 280: strcpy(destination,"PAGEUP"); break;
			case 281: strcpy(destination,"PAGEDOWN"); break;
			case 282: strcpy(destination,"F1"); break;
			case 283: strcpy(destination,"F2"); break;
			case 284: strcpy(destination,"F3"); break;
			case 285: strcpy(destination,"F4"); break;
			case 286: strcpy(destination,"F5"); break;
			case 287: strcpy(destination,"F6"); break;
			case 288: strcpy(destination,"F7"); break;
			case 289: strcpy(destination,"F8"); break;
			case 290: strcpy(destination,"F9"); break;
			case 291: strcpy(destination,"F10"); break;
			case 292: strcpy(destination,"F11"); break;
			case 293: strcpy(destination,"F12"); break;
			case 294: strcpy(destination,"F13"); break;
			case 295: strcpy(destination,"F14"); break;
			case 296: strcpy(destination,"F15"); break;
			case 300: strcpy(destination,"NUMLOCK"); break;
			case 301: strcpy(destination,"CAPSLOCK"); break;
			case 302: strcpy(destination,"SCROLLOCK"); break;
			case 303: strcpy(destination,"RSHIFT"); break;
			case 304: strcpy(destination,"LSHIFT"); break;
			case 305: strcpy(destination,"RCTRL"); break;
			case 306: strcpy(destination,"LCTRL"); break;
			case 307: strcpy(destination,"RALT"); break;
			case 308: strcpy(destination,"LALT"); break;
			case 309: strcpy(destination,"RMETA"); break;
			case 310: strcpy(destination,"LMETA"); break;
			case 311: strcpy(destination,"LSUPER"); break;
			case 312: strcpy(destination,"RSUPER"); break;
			case 313: strcpy(destination,"MODE"); break;
			case 314: strcpy(destination,"COMPOSE"); break;
			case 315: strcpy(destination,"HELP"); break;
			case 316: strcpy(destination,"PRINT"); break;
			case 317: strcpy(destination,"SYSREQ"); break;
			case 318: strcpy(destination,"BREAK"); break;
			case 319: strcpy(destination,"MENU"); break;
			case 320: strcpy(destination,"POWER"); break;
			case 321: strcpy(destination,"EURO"); break;
			case 322: strcpy(destination,"UNDO"); break;
			default: strcpy(destination,"UNKNOWN"); break;
		}
	}
	
	int keyCode(char* name)
	{
		if(strcmp(name,"BACKSPACE")==0) return 8;
		if(strcmp(name,"TAB")==0) return 9;
		if(strcmp(name,"CLEAR")==0) return 12;
		if(strcmp(name,"RETURN")==0) return  13;
		if(strcmp(name,"PAUSE")==0) return 19;
		if(strcmp(name,"ESCAPE")==0) return 27;
		if(strcmp(name,"SPACE")==0) return 32;
		if(strcmp(name,"EXCLAIM")==0) return 33;
		if(strcmp(name,"QUOTEDBL")==0) return 34;
		if(strcmp(name,"HASH")==0) return 35;
		if(strcmp(name,"DOLLAR")==0) return  36;
		if(strcmp(name,"AMPERSAND")==0) return 38;
		if(strcmp(name,"QUOTE")==0) return 39;
		if(strcmp(name,"LEFTPAREN")==0) return 40;		
		if(strcmp(name,"RIGHTPAREN")==0) return 41;
		if(strcmp(name,"ASTERISK")==0) return 42;
		if(strcmp(name,"PLUS")==0) return 43;
		if(strcmp(name,"COMMA")==0) return  44;
		if(strcmp(name,"MINUS")==0) return 45;
		if(strcmp(name,"PERIOD")==0) return 46;
		if(strcmp(name,"SLASH")==0) return 47;
		if(strcmp(name,"0")==0) return 48;
		if(strcmp(name,"1")==0) return 49;
		if(strcmp(name,"2")==0) return 50;
		if(strcmp(name,"3")==0) return  51;
		if(strcmp(name,"4")==0) return 52;
		if(strcmp(name,"5")==0) return 53;
		if(strcmp(name,"6")==0) return 54;
		if(strcmp(name,"7")==0) return 55;
		if(strcmp(name,"8")==0) return 56;
		if(strcmp(name,"9")==0) return 57;
		if(strcmp(name,"COLON")==0) return 58;
		if(strcmp(name,"SEMICOLON")==0) return 59;
		if(strcmp(name,"LESS")==0) return 60;
		if(strcmp(name,"EQUALS")==0) return 61;
		if(strcmp(name,"GREATER")==0) return 62;
		if(strcmp(name,"QUESTION")==0) return 63;
		if(strcmp(name,"AT")==0) return 64;
		if(strcmp(name,"LEFTBRACKET")==0) return  91;
		if(strcmp(name,"BACKSLASH")==0) return 92;
		if(strcmp(name,"RIGHTBRACKET")==0) return 93;
		if(strcmp(name,"CARET")==0) return 94;
		if(strcmp(name,"UNDERSCORE")==0) return 95;
		if(strcmp(name,"BACKQUOTE")==0) return 96;
		if(strcmp(name,"A")==0) return 97;
		if(strcmp(name,"B")==0) return  98;
		if(strcmp(name,"C")==0) return 99;
		if(strcmp(name,"D")==0) return 100;
		if(strcmp(name,"E")==0) return 101;
		if(strcmp(name,"F")==0) return 102;
		if(strcmp(name,"G")==0) return 103;
		if(strcmp(name,"H")==0) return 104;
		if(strcmp(name,"I")==0) return  105;
		if(strcmp(name,"J")==0) return 106;
		if(strcmp(name,"K")==0) return 107;
		if(strcmp(name,"L")==0) return 108;
		if(strcmp(name,"M")==0) return 109;
		if(strcmp(name,"N")==0) return  110;
		if(strcmp(name,"O")==0) return 111;
		if(strcmp(name,"P")==0) return 112;
		if(strcmp(name,"Q")==0) return 113;
		if(strcmp(name,"R")==0) return 114;
		if(strcmp(name,"S")==0) return 115;
		if(strcmp(name,"T")==0) return 116;
		if(strcmp(name,"U")==0) return  117;
		if(strcmp(name,"V")==0) return 118;
		if(strcmp(name,"W")==0) return 119;
		if(strcmp(name,"X")==0) return 120;
		if(strcmp(name,"Y")==0) return 121;
		if(strcmp(name,"Z")==0) return 122;
		if(strcmp(name,"Z")==0) return 122;
		if(strcmp(name,"DELETE")==0) return 127;
		// end ascii-mapped goodness
		if(strcmp(name,"KP0")==0) return 256;
		if(strcmp(name,"KP1")==0) return 257;
		if(strcmp(name,"KP2")==0) return 258;
		if(strcmp(name,"KP3")==0) return 259;
		if(strcmp(name,"KP4")==0) return 260;
		if(strcmp(name,"KP5")==0) return 261;
		if(strcmp(name,"KP6")==0) return 262;
		if(strcmp(name,"KP7")==0) return 263;
		if(strcmp(name,"KP8")==0) return 264;
		if(strcmp(name,"KP9")==0) return 265;
		if(strcmp(name,"KPPERIOD")==0) return 266;
		if(strcmp(name,"KPDIVIDE")==0) return 267;
		if(strcmp(name,"KPMULTIPLY")==0) return 268;
		if(strcmp(name,"KPMINUS")==0) return 269;
		if(strcmp(name,"KPPLUS")==0) return 270;
		if(strcmp(name,"KPENTER")==0) return 271;
		if(strcmp(name,"KPEQUALS")==0) return 272;
		if(strcmp(name,"UP")==0) return 273;
		if(strcmp(name,"DOWN")==0) return 274;
		if(strcmp(name,"RIGHT")==0) return 275;
		if(strcmp(name,"LEFT")==0) return 276;
		if(strcmp(name,"INSERT")==0) return 277;
		if(strcmp(name,"HOME")==0) return 278;
		if(strcmp(name,"END")==0) return 279;
		if(strcmp(name,"PAGEUP")==0) return 280;
		if(strcmp(name,"PAGEDOWN")==0) return 281;
		if(strcmp(name,"F1")==0) return 282;
		if(strcmp(name,"F2")==0) return 283;
		if(strcmp(name,"F3")==0) return 284;
		if(strcmp(name,"F4")==0) return 285;
		if(strcmp(name,"F5")==0) return 286;
		if(strcmp(name,"F6")==0) return 287;
		if(strcmp(name,"F7")==0) return 288;
		if(strcmp(name,"F8")==0) return 289;
		if(strcmp(name,"F9")==0) return 290;
		if(strcmp(name,"F10")==0) return 291;
		if(strcmp(name,"F11")==0) return 292;
		if(strcmp(name,"F12")==0) return 293;
		if(strcmp(name,"F13")==0) return 294;
		if(strcmp(name,"F14")==0) return 295;
		if(strcmp(name,"F15")==0) return 296;
		if(strcmp(name,"NUMLOCK")==0) return 300;
		if(strcmp(name,"CAPSLOCK")==0) return 301;
		if(strcmp(name,"SCROLLOCK")==0) return 302;
		if(strcmp(name,"RSHIFT")==0) return 303;
		if(strcmp(name,"LSHIFT")==0) return 304;
		if(strcmp(name,"RCTRL")==0) return 305;
		if(strcmp(name,"LCTRL")==0) return 306;
		if(strcmp(name,"RALT")==0) return 307;
		if(strcmp(name,"LALT")==0) return 308;
		if(strcmp(name,"RMETA")==0) return 309;
		if(strcmp(name,"LMETA")==0) return 310;
		if(strcmp(name,"LSUPER")==0) return 311;
		if(strcmp(name,"RSUPER")==0) return 312;
		if(strcmp(name,"MODE")==0) return 313;
		if(strcmp(name,"COMPOSE")==0) return 314;
		if(strcmp(name,"HELP")==0) return 315;
		if(strcmp(name,"PRINT")==0) return 316;
		if(strcmp(name,"SYSREQ")==0) return 317;
		if(strcmp(name,"BREAK")==0) return 318;
		if(strcmp(name,"MENU")==0) return 319;
		if(strcmp(name,"POWER")==0) return 320;
		if(strcmp(name,"EURO")==0) return 321;
		if(strcmp(name,"UNDO")==0) return 322;
		return 0;
	}

	int modifiedKey(int _key)
	{
		bool upshifted = key(301);	//caps lock
		if(key(303) || key(304))
			upshifted = !upshifted;

		//Stop at invalid keys
		switch(_key)
		{
			case 8: //strcpy(destination,"BACKSPACE"); break;
			case 9: //strcpy(destination,"TAB"); break;
			case 12: //strcpy(destination,"CLEAR"); break;
			case 13: //strcpy(destination,"RETURN"); break;
			case 19: //strcpy(destination,"PAUSE"); break;
			case 27: //strcpy(destination,"ESCAPE"); break;
			case 127: //strcpy(destination,"DELETE"); break;
			case 256: //strcpy(destination,"KP0"); break;
			case 257: //strcpy(destination,"KP1"); break;
			case 258: //strcpy(destination,"KP2"); break;
			case 259: //strcpy(destination,"KP3"); break;
			case 260: //strcpy(destination,"KP4"); break;
			case 261: //strcpy(destination,"KP5"); break;
			case 262: //strcpy(destination,"KP6"); break;
			case 263: //strcpy(destination,"KP7"); break;
			case 264: //strcpy(destination,"KP8"); break;
			case 265: //strcpy(destination,"KP9"); break;
			case 266: //strcpy(destination,"KPPERIOD"); break;
			case 267: //strcpy(destination,"KPDIVIDE"); break;
			case 268: //strcpy(destination,"KPMULTIPLY"); break;
			case 269: //strcpy(destination,"KPMINUS"); break;
			case 270: //strcpy(destination,"KPPLUS"); break;
			case 271: //strcpy(destination,"KPENTER"); break;
			case 272: //strcpy(destination,"KPEQUALS"); break;
			case 273: //strcpy(destination,"UP"); break;
			case 274: //strcpy(destination,"DOWN"); break;
			case 275: //strcpy(destination,"RIGHT"); break;
			case 276: //strcpy(destination,"LEFT"); break;
			case 277: //strcpy(destination,"INSERT"); break;
			case 278: //strcpy(destination,"HOME"); break;
			case 279: //strcpy(destination,"END"); break;
			case 280: //strcpy(destination,"PAGEUP"); break;
			case 281: //strcpy(destination,"PAGEDOWN"); break;
			case 282: //strcpy(destination,"F1"); break;
			case 283: //strcpy(destination,"F2"); break;
			case 284: //strcpy(destination,"F3"); break;
			case 285: //strcpy(destination,"F4"); break;
			case 286: //strcpy(destination,"F5"); break;
			case 287: //strcpy(destination,"F6"); break;
			case 288: //strcpy(destination,"F7"); break;
			case 289: //strcpy(destination,"F8"); break;
			case 290: //strcpy(destination,"F9"); break;
			case 291: //strcpy(destination,"F10"); break;
			case 292: //strcpy(destination,"F11"); break;
			case 293: //strcpy(destination,"F12"); break;
			case 294: //strcpy(destination,"F13"); break;
			case 295: //strcpy(destination,"F14"); break;
			case 296: //strcpy(destination,"F15"); break;
			case 300: //strcpy(destination,"NUMLOCK"); break;
			case 301: //strcpy(destination,"CAPSLOCK"); break;
			case 302: //strcpy(destination,"SCROLLOCK"); break;
			case 303: //strcpy(destination,"RSHIFT"); break;
			case 304: //strcpy(destination,"LSHIFT"); break;
			case 305: //strcpy(destination,"RCTRL"); break;
			case 306: //strcpy(destination,"LCTRL"); break;
			case 307: //strcpy(destination,"RALT"); break;
			case 308: //strcpy(destination,"LALT"); break;
			case 309: //strcpy(destination,"RMETA"); break;
			case 310: //strcpy(destination,"LMETA"); break;
			case 311: //strcpy(destination,"LSUPER"); break;
			case 312: //strcpy(destination,"RSUPER"); break;
			case 313: //strcpy(destination,"MODE"); break;
			case 314: //strcpy(destination,"COMPOSE"); break;
			case 315: //strcpy(destination,"HELP"); break;
			case 316: //strcpy(destination,"PRINT"); break;
			case 317: //strcpy(destination,"SYSREQ"); break;
			case 318: //strcpy(destination,"BREAK"); break;
			case 319: //strcpy(destination,"MENU"); break;
			case 320: //strcpy(destination,"POWER"); break;
			case 321: //strcpy(destination,"EURO"); break;
			case 322: //strcpy(destination,"UNDO"); break;
				return 0;
		};

		if(upshifted)
		{
			//Simple letters
			if(_key >= 97 && _key <= 122)
				return _key-32;

			switch(_key)
			{
				case 32: return 32;	//SPACE
				case 39: return 34;	//"
				case 44: return 60;	//<
				case 45: return 95; 	//_
				case 46: return 62;	//>
				case 47: return 63;	//?
				case 48: return 41; 	//)
				case 49: return 33;	//!
				case 50: return 64;	//@
				case 51: return 35;	//#
				case 52: return 36;	//$
				case 53: return 37;	//%
				case 54: return 94;	//^
				case 55: return 38;	//&
				case 56: return 42;	//*
				case 57: return 40;	//(
				case 59: return 58;	//:
				case 61: return 43;	//+
				case 91: return 123;	//{
				case 92: return 124;	//|
				case 93: return 125;	//}
				case 96: return 126;	//~

				default: return 0;
			};
		}

		return _key;
	}
	
	int* catchType()
	{
		List<SDL_KeyboardEvent> typeStateList;
		_typeStates.append(&typeStateList);
		
		int i = 0;
		
		SDL_KeyboardEvent* thisTypeState = typeStateList.popFront();
		while(thisTypeState)
		{
			if(thisTypeState->state==SDL_PRESSED)
			{
				_keysPressed[i] = thisTypeState->keysym.unicode;
				i++;
			}
			thisTypeState = typeStateList.popFront();
		}
		
		_keysPressed[i] = 0;
		
		return _keysPressed;
	}
	
	// Time Functions
	int time()
	{
		return SDL_GetTicks();
	}
	void delay(int milliseconds)
	{
		SDL_Delay(milliseconds);
	}
}
