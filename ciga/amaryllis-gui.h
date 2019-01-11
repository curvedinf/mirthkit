#ifndef _AMARYLLIS_GUI_H
#define _AMARYLLIS_GUI_H

#define AM_GUI_STACK_DEPTH 256 // not limited by OpenGL

namespace ciga {
	
	enum BUTTON_STATE {BUTTON_OFF=0,BUTTON_OVER,BUTTON_JUST_DOWN,BUTTON_DOWN,BUTTON_JUST_UP};
	
	void _guiFlush();
	
	// Movement
	void guiMoveDown();
	void guiMoveRight();
	void guiMoveUp();
	void guiMoveLeft();
	
	// Box
	void guiBoxFill(float r,float g,float b,float a);
	void guiBoxBorder(float r,float g,float b,float a,float w);
	void guiPushBox(float width=-1, float height=-1, 
									float marginX=-1, float marginY=-1,
									float paddingX=-1, float paddingY=-1);
	void guiPopBox();
	void guiOriginBox();
	
	// Content
	void guiText(char* string,float vmargin=0);
	void guiImage(char* filepath,float width=-1,float height=-1,float vmargin=-1);
	
	// Button
	BUTTON_STATE guiBeginButton(char* name,float padding=-1);
	BUTTON_STATE guiEndButton();
	
	void guiButtonUpBorder(float r,float g, float b, float a, float w);
	void guiButtonOverBorder(float r,float g, float b, float a, float w);
	void guiButtonDownBorder(float r,float g, float b, float a, float w);
};
#endif /* _AMARYLLIS-GUI_H */
