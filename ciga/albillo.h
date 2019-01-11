#ifndef _ALBILLO_H
#define _ALBILLO_H

namespace ciga {
	// Internal
	void _alInitialize();
	void _alExit();
	void _alFlush(); // clears sound/music cache
	void _alUpdate();
	
	// Control
	void sound(char* filepath,float angle,float distance);
	void soundVolume(float sound);
	
	void music(char* filepath);
	void musicVolume(float music);
	void musicFade(float volume,float seconds);
	
	//float musicLength();
	//int musicLoopNum();
	//float musicPlaytime();
}

#endif /* _ALBILLO_H */
