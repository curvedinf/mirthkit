#ifndef _DOWNLOAD_H
#define _DOWNLOAD_H

#include "ciga.h"

#include <stdio.h>
#include <sys/stat.h>
#include <curl/curl.h>

extern void exitPlayer();

//#define DL_CACHE_PREFIX "local/cache/"
//#define DL_BG_PIC "downloadBG.png"
//#define DL_FG_PIC "downloadFG.png"

#ifdef LINUX_32
#define DL_BG_PIC "/usr/share/mirthkit/downloadBG.png"
#define DL_FG_PIC "/usr/share/mirthkit/downloadFG.png"
#endif

#ifdef WIN32
#define DL_BG_PIC "C:/Program Files/MirthKit/downloadBG.png"
#define DL_FG_PIC "C:/Program Files/MirthKit/downloadFG.png"
#endif

#ifdef MAC_OSX
#define DL_BG_PIC "/Applications/MirthKit.app/Contents/MacOS/downloadBG.png"
#define DL_FG_PIC "/Applications/MirthKit.app/Contents/MacOS/downloadFG.png"
#endif

CURL *c = 0;
FILE* f = 0;
char filepathBuffer[4096];
char* filepath;

ciga::NameTable<char> urls;

int totalProgress = -1;
int totalFiles = -1;

extern int w,h;
extern bool redownload;
extern bool debug;

bool downloading = true;

SQInteger sb_progress(HSQUIRRELVM v)
{
	SQInteger p,f;
	sq_getinteger(v,2,&p);
	sq_getinteger(v,3,&f);
	totalProgress = p;
	totalFiles = f;
	return 0;
}

void setProgress(int progress, int files)
{
	if(totalProgress<0||totalFiles<1)
	{
		totalProgress = -1;
		totalFiles = -1;
	} else {
		totalProgress = progress;
		totalFiles = files;
	}
}

extern int w,h;

size_t writeFunc(void *ptr,size_t size,size_t count,void *stream)
{
	if(!f)
	{
		f=fopen(filepath,"wb");
	}
	return fwrite(ptr,size,count,f);
}

int progressFunc(void *clientp, double dltotal, double dlnow, double ultotal,double ulnow)
{
	if(!downloading)
		return 0;	
	
	while(ciga::popWindow());
	ciga::pushBrush();
	ciga::additiveBlending(false);
	ciga::fillColor(1,1,1,1);
	ciga::lineColor(0,0,0,0,0);
	ciga::font((char*)DEFAULT_FONT);
	ciga::image((char*)DL_BG_PIC,1,1);
	ciga::rect(0,0,w,h);
	ciga::image((char*)DL_FG_PIC,1,1);
	ciga::additiveBlending(false);
	ciga::fillColor(1,1,1,0.5);
	float fileProgress = (dlnow/dltotal);
	if(dlnow==0||dltotal==0) fileProgress = 0;
	if(totalProgress!=-1)
	{
		float totalPercent = totalProgress/(float)totalFiles;
		if(totalProgress == 0) totalPercent = 0;
		ciga::rect(0,0,w*totalPercent,h);
		ciga::fillColor(1,1,1,1);
		ciga::rect(0,h-(h/50.0),w*totalPercent*fileProgress,(h/50.0));
	} else {
		float fileProgress = (dlnow/dltotal);
		if(dlnow==0||dltotal==0) fileProgress = 1;
		ciga::rect(0,0,w*fileProgress,h);
	}
	ciga::fillColor(0,0,0,0.3);
	ciga::text((char*)"Hold on a moment,",w/2-100,h/2,1000);
	if(downloading)
	{
		if(fileProgress==0) ciga::text((char*)"Checking files...",w/2-10,h/2+12,1000);
		else ciga::text((char*)"Downloading files...",w/2-10,h/2+12,1000);
	} else {
		ciga::text((char*)"Communicating with the server...",w/2-10,h/2+12,1000);
	}
	ciga::popBrush();
	ciga::update(&w,&h);
	if(ciga::rawKey(SDLK_ESCAPE))
	{
		exitPlayer();
		exit(0);
	}
	return 0;
}

void initCurl()
{
	c=curl_easy_init();
	curl_easy_setopt(c,CURLOPT_ENCODING,"");
	curl_easy_setopt(c,CURLOPT_TIMECONDITION,CURL_TIMECOND_IFMODSINCE);
	curl_easy_setopt(c,CURLOPT_WRITEFUNCTION,writeFunc);
	curl_easy_setopt(c,CURLOPT_NOPROGRESS,false);
	curl_easy_setopt(c,CURLOPT_PROGRESSFUNCTION,progressFunc);
	curl_easy_setopt(c,CURLOPT_WRITEDATA,f);
	curl_easy_setopt(c,CURLOPT_TIMEOUT,10);
}

void exitCurl()
{
	curl_easy_cleanup(c);
}

// returns the local filepath in the passed-in string
char* download(char* url)
{	
	char temp[4096];
	char temp2[4096];
	
	strcpy(temp,url);	
	
	// Replace backslashes with slashes
	char* bslash = strchr(temp,'\\');
	while(bslash)
	{
		*bslash = '/';
		bslash = strchr(temp,'\\');
	}
	
	// take out server arguments
	char* question = strchr(temp,'?');
	while(question)
	{
		char* slash = strchr(question,'/');
		if(slash) {
			strcpy(temp2,slash);
			strcpy(question,temp2);
		} else
			*question = 0;
		
		question = strchr(question,'?');
	}
	
	char** thisUrl = urls.get(temp);
	
	if(!*thisUrl)
	{	
		*thisUrl = new char[4096];
		
		char* http = strstr(temp,"http://");
		if(http == temp) // We are using http
		{
			strcpy(*thisUrl,http+7); // 7 characters for "http://"
			
			// append the path prefix
			//strcpy(temp,DL_CACHE_PREFIX); // Default
			
			#ifdef LINUX_32
			char* homestr = getenv("HOME");
			sprintf(temp,"%s/.mirthkit/cache/",homestr);
			#endif
			
			#ifdef WIN32
			char* homestr = getenv("HOMEPATH");
			sprintf(temp,"%s/MirthKit/cache/",homestr);
			#endif
			
			#ifdef MAC_OSX
			char* homestr = getenv("HOME");
			sprintf(temp,"%s/.mirthkit/cache/",homestr);
			#endif
			
			strcat(temp,*thisUrl);
			strcpy(*thisUrl,temp);
			
			// make all the directories
			char* actualFile = strrchr(*thisUrl,'/')+1;
			strcpy(temp2,*thisUrl);
			char* dir = strtok(temp2,"/");
			
			//strcpy(temp,"");
			
			#ifdef LINUX_32
			strcpy(temp,"/");
			#endif
			
			#ifdef WIN32
			strcpy(temp,"C:/");
			#endif
			
			#ifdef MAC_OSX
			strcpy(temp,"/");
			#endif
			
			while(dir && strcmp(dir,actualFile))
			{
				strcat(temp,dir);
				mkdir(temp,S_IRWXU|S_IRGRP|S_IROTH);
				strcat(temp,"/");
				
				dir = strtok(0,"/");
			}
			
			strcpy(filepathBuffer,*thisUrl);
			filepath = filepathBuffer;
			
			int lastDownloadTime=0;
			char* result = ciga::retrieve((char*)"Cache",*thisUrl);
			if(result)
				sscanf(result,"%d",&lastDownloadTime);
			
			// get the modified time of the file
			struct stat filestats;
			int modifiedTime = 0;
			if(!stat(filepath,&filestats))
			{
				modifiedTime = filestats.st_mtime;
			}
			curl_easy_setopt(c,CURLOPT_TIMEVALUE,modifiedTime);
			
			int now = time(0);
			if(lastDownloadTime+60*60*24*3<now||modifiedTime==0||redownload)
			{
				if(debug)
					printf("Downloading URL: %s\n",url);
				
				// download
				downloading = true;
				curl_easy_setopt(c,CURLOPT_WRITEFUNCTION,writeFunc);
				curl_easy_setopt(c,CURLOPT_URL,url);
				curl_easy_perform(c);
				if(f) fclose(f);
				f=0;
				filepath=0;
				char timeString[128];
				sprintf(timeString,"%i",(int)time(0));
				
				ciga::store((char*)"Cache",*thisUrl,timeString);
			} else {
				if(debug)
					printf("Using cached URL: %s\n",url);
			}
			
		} else { // We are using a normal file
			strcpy(*thisUrl,url);
		}
	}
	
	return *thisUrl;
}

char* getBuf=0;
int getBufSize=0;
int getBufUsedSize=0;

size_t getFunc(void *ptr,size_t size,size_t count,void *stream)
{
	if(getBufSize==0)
	{
		if(getBuf) delete [] getBuf;
		getBuf= new char[1024*32];
		getBufSize = 1024*32;
		memset(getBuf,0,getBufSize);
	}
	
	int newGetBufUsedSize = getBufUsedSize + size*count;
	if(newGetBufUsedSize>=getBufSize-1)
	{
		while(newGetBufUsedSize>=getBufSize-1)
			getBufSize += 1024*32;
		char* temp = new char[getBufSize];
		memset(temp,0,getBufSize);
		strcpy(temp,getBuf);
		delete [] getBuf;
		getBuf = temp;
	}
	memcpy(getBuf+getBufUsedSize,ptr,size*count);
	getBufUsedSize = newGetBufUsedSize;
	getBuf[getBufUsedSize] = 0;
	
	return count;
}

// returns the url in a null-terminated string
char* getURL(char* url)
{
	// download
	downloading = false;
	if(getBufSize>0)
	{
		delete [] getBuf;
		getBuf = 0;
		getBufSize = 0;
		getBufUsedSize = 0;
	}
	curl_easy_setopt(c,CURLOPT_WRITEFUNCTION,getFunc);
	curl_easy_setopt(c, CURLOPT_SSL_VERIFYPEER, false);
	curl_easy_setopt(c, CURLOPT_SSL_VERIFYHOST, 1);
	curl_easy_setopt(c,CURLOPT_URL,url);
	CURLcode error = curl_easy_perform(c);
	if(!getBuf)
		printf("Error code %i for \"%s\"\n",error,url);
	return getBuf;
}

SQInteger sb_http(HSQUIRRELVM v)
{
	SQChar* str;
	SQChar* ret;
	sq_getstring(v,2,(const SQChar**)&str);
	ret = getURL(str);
	if(ret)
		sq_pushstring(v,ret,strlen(ret));
	else
		sq_pushstring(v,"",0);
	return 1;
}

#endif /* _DOWNLOAD_H */
