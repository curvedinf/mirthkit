#include "albillo.h"
#include "argillite.h"
#include "NameTable.h"
#include "List.h"

#include <SDL/SDL_mixer.h>
#include <SDL/SDL.h>

#include <stdlib.h>

#define MIX_EFFECTSMAXSPEED  "MIX_EFFECTSMAXSPEED"

#define AL_CHANNELS 32

namespace ciga {
	
	Mix_Music* _music;
	NameTable<Mix_Chunk> _sounds;
	
	float _soundVolume,_musicVolume;
	float _musicFadeStartVolume,_musicFadeToVolume;
	unsigned int _musicFadeStartTime,_musicFadeEndTime;
	bool _noAudio;
	
	//control
	void _alInitialize()
	{
		if(Mix_OpenAudio(MIX_DEFAULT_FREQUENCY,MIX_DEFAULT_FORMAT,2,1536)>=0)
		{
			_noAudio = false;
			Mix_AllocateChannels(AL_CHANNELS);
			soundVolume(1);
			musicVolume(1);
			_music = 0;
		} else {
			_noAudio = true;
			printf("No audio device found. Audio disabled\n");
		}
	}
	void _alExit()
	{
		_alFlush();
	}
	void _alFlush()
	{
		if(_noAudio) return;
		if(_music)
		{
			Mix_HaltMusic();
			Mix_FreeMusic(_music);
		}
		Mix_HaltChannel(-1);
		List<Mix_Chunk> sounds;
		_sounds.append(&sounds);
		Mix_Chunk* sound = sounds.popFront();
		while(sound)
		{
			Mix_FreeChunk(sound);
			sound = sounds.popFront();
		}
		_music = 0;
		_sounds.clear();
		soundVolume(1);
		musicVolume(1);
	}
	void _alUpdate()
	{
		if(_musicFadeEndTime!=0)
		{
			unsigned int now = time();
			float percent = (now-_musicFadeStartTime)/(_musicFadeEndTime-_musicFadeStartTime);
			float volumeNow = (_musicFadeToVolume-_musicFadeStartVolume)*percent+_musicFadeStartVolume;
			Mix_VolumeMusic((int)(255*volumeNow));
		}
	}
	
	//sound
	void sound(char* filepath,float angle,float distance)
	{
		if(_noAudio) return;
		distance = 1-((1-distance)*_soundVolume);
		if(distance>=1) return;
		Mix_Chunk** sound = _sounds.get(filepath);
		if(!*sound)
		{
			*sound = Mix_LoadWAV(filepath);
		}
		int channel = Mix_PlayChannel(rand()%AL_CHANNELS, *sound,0);
		if(channel==-1)
		{
			channel = rand()%AL_CHANNELS;
			Mix_HaltChannel(channel);
			Mix_PlayChannel(channel, *sound,0);
		}
		if(distance<0) distance=0;
		Mix_SetPosition(channel,(Sint16)angle,(Uint8)(distance*255));
	}
	void music(char* filepath)
	{
		if(_noAudio) return;
		if(_music)
		{
			Mix_HaltMusic();
			Mix_FreeMusic(_music);
		}
		Mix_SetMusicCMD(getenv("MUSIC_CMD"));
		_music = Mix_LoadMUS(filepath);
		if(_music)
		{
			Mix_FadeInMusic(_music,0,2000);
			Mix_PlayMusic(_music,-1);
			Mix_VolumeMusic((int)(255*_musicVolume));
		}
	}
	void soundVolume(float volume)
	{
		if(_noAudio) return;
		if(volume>1) volume=1;
		if(volume<0) volume=0;
		_soundVolume = volume;
	}
	void musicVolume(float volume)
	{
		if(_noAudio) return;
		if(volume>1) volume=1;
		if(volume<0) volume=0;
		_musicVolume = volume;
		_musicFadeEndTime = 0;
		Mix_VolumeMusic((int)(255*_musicVolume));
	}
	void musicFade(float volume,float seconds)
	{
		if(_noAudio) return;
		_musicFadeStartVolume = _musicVolume;
		_musicFadeToVolume = volume;
		_musicFadeStartTime = time();
		_musicFadeEndTime = (int) (_musicFadeStartTime+(seconds*1000));
	}
}
