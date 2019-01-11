#include "amaryllis-gui.h"
#include "amaryllis.h"
#include "NameTable.h"
#include "acorn.h"

#include <string.h>

namespace ciga {
	
	struct AM_GUI_BUTTON 
	{
		float start[2];
		float end[2];
		float padding;
		bool previousDown;
		BUTTON_STATE previousState;
		AM_GUI_BUTTON()
		{
			memset(this,0,sizeof(AM_GUI_BUTTON));
		}
	};
	
	struct AM_GUI_BOX 
	{
		float x,y;
		float w,h;
		float mx,my;
		float px,py;
		float wyp;
		float boxFill[4];
		float boxBorder[5];
		float buBorder[5];
		float boBorder[5];
		float bdBorder[5];
		float imageVmargin;
		int movementDirection;
		AM_GUI_BUTTON* currentButton;
		AM_GUI_BOX()
		{
			memset(this,0,sizeof(AM_GUI_BOX));
		}
	};
	
	AM_GUI_BOX _boxStack[AM_GUI_STACK_DEPTH];
	AM_GUI_BOX* _boxStackPointer = _boxStack;
	NameTable<AM_GUI_BUTTON> _buttons;
	
	void _guiFlush()
	{
		List<AM_GUI_BUTTON> buttonList;
		_buttons.append(&buttonList);
		AM_GUI_BUTTON* button = buttonList.popFront();
		while(button)
		{
			delete button;
			button = buttonList.popFront();
		}
		_buttons.clear();
		_boxStackPointer = _boxStack;
		_boxStackPointer->currentButton = 0;
	}
	
	void _movementBefore(float direction = 1)
	{
		switch(_boxStackPointer->movementDirection)
		{
			case 2: //Up
			{
				_boxStackPointer->y -= direction*_boxStackPointer->my*2;
				_boxStackPointer->y -= direction*_boxStackPointer->h;
			}
			break;
			case 3: //Left
			{
				_boxStackPointer->x -= direction*_boxStackPointer->mx*2;
				_boxStackPointer->x -= direction*_boxStackPointer->w;
			}
			break;
			default:
			break;
		}
	}
	
	
	void _movementAfter(float direction = 1)
	{
		switch(_boxStackPointer->movementDirection)
		{
			case 0: //Down
			{
				_boxStackPointer->y += direction*_boxStackPointer->my*2;
				_boxStackPointer->y += direction*_boxStackPointer->h;
			}
			break;
			case 1: //Right
			{
				_boxStackPointer->x += direction*_boxStackPointer->mx*2;
				_boxStackPointer->x += direction*_boxStackPointer->w;
			}
			break;
			default:
			break;
		}
	}
	
	// Movement
	void guiMoveDown()
	{
		_boxStackPointer->movementDirection = 0;
	}
	void guiMoveRight()
	{
		_boxStackPointer->movementDirection = 1;
	}
	void guiMoveUp()
	{
		_boxStackPointer->movementDirection = 2;
	}
	void guiMoveLeft()
	{
		_boxStackPointer->movementDirection = 3;
	}
	
	// Box
	void guiBoxFill(float r,float g,float b,float a)
	{
		_boxStackPointer->boxFill[0] = r;
		_boxStackPointer->boxFill[1] = g;
		_boxStackPointer->boxFill[2] = b;
		_boxStackPointer->boxFill[3] = a;
	}
	void guiBoxBorder(float r,float g,float b,float a,float w)
	{
		_boxStackPointer->boxBorder[0] = r;
		_boxStackPointer->boxBorder[1] = g;
		_boxStackPointer->boxBorder[2] = b;
		_boxStackPointer->boxBorder[3] = a;
		_boxStackPointer->boxBorder[4] = w;
	}
	void guiPushBox(float width, float height, 
									float marginX, float marginY,float paddingX, float paddingY)
	{
		if(_boxStackPointer-_boxStack>=AM_GUI_STACK_DEPTH-1) return;
		_movementAfter();
		_boxStackPointer += 1;
		
		memcpy(_boxStackPointer,_boxStackPointer-1,sizeof(AM_GUI_BOX));
		
		if(width!=-1) _boxStackPointer->w = width;
		if(height!=-1) _boxStackPointer->h = height;
		if(marginX!=-1) _boxStackPointer->mx = marginX;
		if(marginY!=-1) _boxStackPointer->my = marginY;
		if(paddingX!=-1) _boxStackPointer->px = paddingX;
		if(paddingY!=-1) _boxStackPointer->py = paddingY;
		_boxStackPointer->wyp = 0;
		_movementBefore();
		
		float x = _boxStackPointer->x+_boxStackPointer->mx;
		float y = _boxStackPointer->y+_boxStackPointer->my;
		
		pushBrush();
		image((char*)"",0,0);
		fillColor(_boxStackPointer->boxFill[0],_boxStackPointer->boxFill[1],
					_boxStackPointer->boxFill[2],_boxStackPointer->boxFill[3]);
		lineColor(_boxStackPointer->boxBorder[0],_boxStackPointer->boxBorder[1],
					_boxStackPointer->boxBorder[2],_boxStackPointer->boxBorder[3],
					_boxStackPointer->boxBorder[4]);
		rect(x,y,_boxStackPointer->w,_boxStackPointer->h);
		popBrush();
	}
	void guiPopBox()
	{
		if(_boxStackPointer==_boxStack) return;
		_boxStackPointer-=1;
		_movementAfter(-1);
	}
	void guiOriginBox()
	{
		_boxStackPointer = _boxStack;
		_movementAfter(-1);
	}
	
	// Size
	void guiMargin(float horizontal,float vertical)
	{
		_boxStackPointer->mx = horizontal;
		_boxStackPointer->my = vertical;
	}
	void guiPadding(float horizontal,float vertical)
	{
		_boxStackPointer->px = horizontal;
		_boxStackPointer->py = vertical;
	}
	
	// Content
	void guiText(char* string,float lineSpacing)
	{
		
		float x = _boxStackPointer->x+_boxStackPointer->px+_boxStackPointer->mx;
		float y = _boxStackPointer->wyp+_boxStackPointer->y+
						_boxStackPointer->py+_boxStackPointer->my;
		
		_boxStackPointer->wyp +=  text(string,x,y,_boxStackPointer->w-(_boxStackPointer->px*2));
		_boxStackPointer->wyp += lineSpacing;
	}
	void guiImage(char* filepath,float width,float height,float vmargin)
	{
		pushBrush();
		float iw=0,ih=0;
		image(filepath,1,1,&iw,&ih);
		float rw=iw,rh=ih;
		if(width!=-1) rw = width;
		if(height!=-1) rh = height;
		
		if(vmargin==-1)
		{
			vmargin = _boxStackPointer->imageVmargin;
		} else {
			_boxStackPointer->imageVmargin = vmargin;
		}
		
		float x = _boxStackPointer->x+_boxStackPointer->px+_boxStackPointer->mx;
		float y = _boxStackPointer->wyp+_boxStackPointer->y+
						_boxStackPointer->py+_boxStackPointer->my+vmargin;
		
		float maxw = _boxStackPointer->w-_boxStackPointer->px*2;
		if(rw>maxw)
		{
			float coef = maxw/rw;
			rw = maxw;
			rh *= coef;
		}
		
		rect(x,y,rw,rh);	
		popBrush();
		
		_boxStackPointer->wyp += rh + vmargin*2;
	}
	
	// Button
	BUTTON_STATE guiBeginButton(char* name,float padding)
	{
		AM_GUI_BUTTON** button = _buttons.get(name);
		if(!*button)
		{
			*button = new AM_GUI_BUTTON();
		}
		
		(*button)->start[0] = _boxStackPointer->x+_boxStackPointer->px+_boxStackPointer->mx;
		(*button)->start[1] = _boxStackPointer->y+_boxStackPointer->py+
										_boxStackPointer->my+_boxStackPointer->wyp;
		
		if((*button)->end[0] == 0) (*button)->end[0] = (*button)->start[0];
		if((*button)->end[1] == 0) (*button)->end[1] = (*button)->start[1];
		
		(*button)->padding = padding;
		_boxStackPointer->px += padding;
		_boxStackPointer->wyp += padding;
		_boxStackPointer->currentButton = *button;
		
		return (*button)->previousState;
	}
	BUTTON_STATE guiEndButton()
	{
		AM_GUI_BUTTON* button = _boxStackPointer->currentButton;
		if(!button) return BUTTON_OFF;
		
		_boxStackPointer->px -= button->padding;
		_boxStackPointer->wyp += button->padding;
		
		button->end[0] = _boxStackPointer->x+_boxStackPointer->mx+
									_boxStackPointer->w-_boxStackPointer->px;
		button->end[1] = _boxStackPointer->y+_boxStackPointer->py+
										_boxStackPointer->my+_boxStackPointer->wyp;
		
		int mx,my;
		Uint8 mousestate = SDL_GetMouseState(&mx,&my);
		float mouse[2] = {mx,my};
		
		bool clicked = SDL_BUTTON(SDL_BUTTON_LEFT) & mousestate;
		bool over = inRect2(button->start,button->end,mouse);
		
		BUTTON_STATE state;
		
		if(!clicked && button->previousDown) state = BUTTON_JUST_UP;
		else if(!over) state = BUTTON_OFF;
		else if(clicked && !button->previousDown) state = BUTTON_JUST_DOWN;
		else if(clicked) state = BUTTON_DOWN;
		else state = BUTTON_OVER;
			
		button->previousState = state;
		
		pushBrush();
		image((char*)"",0,0);
		fillColor(0,0,0,0);
		if(state == BUTTON_DOWN || state == BUTTON_JUST_DOWN)
		{
			lineColor(_boxStackPointer->bdBorder[0],_boxStackPointer->bdBorder[1],
								_boxStackPointer->bdBorder[2],_boxStackPointer->bdBorder[3],
								_boxStackPointer->bdBorder[4]);
			button->previousDown = true;
		}
		else if(state == BUTTON_OVER)
		{
			lineColor(_boxStackPointer->boBorder[0],_boxStackPointer->boBorder[1],
								_boxStackPointer->boBorder[2],_boxStackPointer->boBorder[3],
								_boxStackPointer->boBorder[4]);
			button->previousDown = false;
		}
		else
		{
			lineColor(_boxStackPointer->buBorder[0],_boxStackPointer->buBorder[1],
								_boxStackPointer->buBorder[2],_boxStackPointer->buBorder[3],
								_boxStackPointer->buBorder[4]);
			button->previousDown = false;
		}
		rect(button->start[0],button->start[1],
					button->end[0]-button->start[0],
					button->end[1]-button->start[1]);
		popBrush();
		
		_boxStackPointer->currentButton = 0;
		return state;
	}
	void guiButtonUpBorder(float r,float g, float b, float a, float w)
	{
		_boxStackPointer->buBorder[0] = r;
		_boxStackPointer->buBorder[1] = g;
		_boxStackPointer->buBorder[2] = b;
		_boxStackPointer->buBorder[3] = a;
		_boxStackPointer->buBorder[4] = w;
	}
	void guiButtonOverBorder(float r,float g, float b, float a, float w)
	{
		_boxStackPointer->boBorder[0] = r;
		_boxStackPointer->boBorder[1] = g;
		_boxStackPointer->boBorder[2] = b;
		_boxStackPointer->boBorder[3] = a;
		_boxStackPointer->boBorder[4] = w;
	}
	void guiButtonDownBorder(float r,float g, float b, float a, float w)
	{
		_boxStackPointer->bdBorder[0] = r;
		_boxStackPointer->bdBorder[1] = g;
		_boxStackPointer->bdBorder[2] = b;
		_boxStackPointer->bdBorder[3] = a;
		_boxStackPointer->bdBorder[4] = w;
	}
}
