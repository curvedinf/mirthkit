#ifndef _ANDROMEDA_H
#define _ANDROMEDA_H

// a minimal UDP api

#include "andromeda-linux.h"
#include "andromeda-windows.h"

#include "NameTable.h"

#define AN_MAX_SIZE ((unsigned short)-1)

namespace ciga
{
	NameTable<PLATFORM_SOCK> _sockets;
	
	void _anInitialize()
	{
		platformInit();
	}
	void _anFlush()
	{
		List<PLATFORM_SOCK> sockList;
		_sockets.append(&sockList);
		PLATFORM_SOCK* currentSock = sockList.popFront();
		while(currentSock)
		{
			closesocket(*currentSock);
			delete currentSock;
			currentSock = sockList.popFront();
		}
		_sockets.clear();
	}
	
	void open(char* name, unsigned short port)
	{
		PLATFORM_SOCK** sock = _sockets.get(name);
		*sock = new PLATFORM_SOCK;
		**sock = socket(AF_INET,SOCK_DGRAM,IPPROTO_UDP);
		platformBind(**sock,(char*)"",port);
	}
	void close(char* name)
	{
		PLATFORM_SOCK** sock = _sockets.getExisting(name);
		if(!sock) return;
		closesocket(**sock);
		delete *sock;
		_sockets.remove(name);
	}
	void send(char* name, char* address, unsigned short port, char* data, unsigned short length)
	{
		PLATFORM_SOCK sock = **_sockets.getExisting(name);
		if(!sock) return;
		platformSendto(sock,address,port,data,length);
	}
	bool receive(char* name, char* address, unsigned short* port, char* data, unsigned short* length)
	{
		PLATFORM_SOCK sock = **_sockets.getExisting(name);
		if(!sock) return false;
		*length = platformRecvfrom(sock,address,port,data,AN_MAX_SIZE);
		return *length != 0 && *length != (unsigned short)-1;
	}
}

#endif
