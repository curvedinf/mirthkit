#ifndef _WINDOWS__H__
#define _WINDOWS__H__

#ifdef WIN32
//#include <winsock2>
#include <windows.h>
#include <ws2tcpip.h>
#include <stdio.h>
#include <time.h>
#include <fcntl.h>

#define PLATFORM_SOCK SOCKET

/*const char *inet_ntop(int af, const void *src, char *dst, int cnt)
{
        if (af == AF_INET)
        {
                struct sockaddr_in in;
                memset(&in, 0, sizeof(in));
                in.sin_family = AF_INET;
                memcpy(&in.sin_addr, src, sizeof(struct in_addr));
                getnameinfo((struct sockaddr *)&in, sizeof(struct
sockaddr_in), dst, cnt, NULL, 0, 1);
                return dst;
        }
        else if (af == AF_INET6)
        {
                struct sockaddr_in6 in;
                memset(&in, 0, sizeof(in));
                in.sin6_family = AF_INET6;
                memcpy(&in.sin6_addr, src, sizeof(struct in_addr6));
                getnameinfo((struct sockaddr *)&in, sizeof(struct
sockaddr_in6), dst, cnt, NULL, 0, 1);
                return dst;
        }
        return NULL;
}

int inet_pton(int af, const char *src, void *dst)
{
        struct addrinfo hints, *res, *ressave;

        memset(&hints, 0, sizeof(struct addrinfo));
        hints.ai_family = af;

        if (getaddrinfo(src, NULL, &hints, &res) != 0)
        {
              //  dolog(3, "Couldn't resolve host %s\n", src);
                return -1;
        }

        ressave = res;

        while (res)
        {
                memcpy(dst, res->ai_addr, res->ai_addrlen);
                res = res->ai_next;
        }

        freeaddrinfo(ressave);
        return 0;
}*/

void platformInit(void)
{
	WSADATA wsaData;
	WSAStartup(MAKEWORD(2,5), &wsaData);
}

int platformBind(SOCKET sock,char* IP,unsigned short port)
{
	u_long mode = 1;
	ioctlsocket(sock, FIONBIO, &mode);
	sockaddr_in address;
	if(IP[0]==0)
		address.sin_addr.s_addr = htonl(INADDR_ANY);
	else
		address.sin_addr.s_addr = inet_addr(IP);
	address.sin_port = htons(port);
	address.sin_family = AF_INET;
	return bind(sock,(sockaddr*)&address,sizeof(address));
}

int platformBind6(SOCKET sock,char* IP,unsigned short port) {return -1;}

PLATFORM_SOCK platformAccept(SOCKET sock)
{
	sockaddr_in address;
	int addressLength = sizeof(address);
	return accept(sock,(sockaddr*)&address,&addressLength);
}

PLATFORM_SOCK platformAccept6(SOCKET sock) { return (SOCKET)-1; }

int platformConnect(SOCKET sock,char* IP,unsigned short port)
{
	sockaddr_in address;
	address.sin_addr.s_addr = inet_addr(IP);
	address.sin_port = htons(port);
	address.sin_family = AF_INET;
	return connect(sock,(sockaddr*)&address,sizeof(address));
}

int platformConnect6(SOCKET sock,char* IP,unsigned short port) { return -1; }

int platformRecvfrom(int sock,char* IP,unsigned short* port,char* buffer,unsigned short bufferLength)
{
	sockaddr_in address;
	address.sin_addr.s_addr = htonl(INADDR_ANY);
	address.sin_port = htons(0);
	address.sin_family = AF_INET;
	int addressLength = sizeof(address);
	int amount = recvfrom(sock,buffer,bufferLength,0,(sockaddr*)&address,&addressLength);
	if(amount<=0)
		return amount;
	inet_ntop(AF_INET,&address.sin_addr.s_addr,IP,64);
	*port = ntohs(address.sin_port);
	return amount;
}

int platformRecvfrom6(SOCKET sock,char* buffer,unsigned short bufferLength) { return -1; }

int platformSendto(SOCKET sock,char* IP,unsigned short port,char* buffer,unsigned short size)
{
	sockaddr_in address;
	address.sin_addr.s_addr = inet_addr(IP);
	address.sin_port = htons(port);
	address.sin_family = AF_INET;
	return sendto(sock,buffer,size,0,(sockaddr*)&address,sizeof(address));
}

int platformSendto6(SOCKET sock,char* IP,unsigned short port,char* buffer,unsigned short size) {return -1;}

unsigned int millis()
{
	return GetTickCount();
}

unsigned long long int micros(void)
{
	LARGE_INTEGER freq,count;
	QueryPerformanceFrequency(&freq);
	QueryPerformanceCounter(&count);
	return count.QuadPart*1000000/freq.QuadPart;
}

void sleep(int time)
{
	Sleep(time);
}

void microWait(unsigned long long int u)
{
	unsigned long long int waitEnd = micros()+u;
	while(micros()<waitEnd) {}
}

void makeDirectory(char* path)
{
	CreateDirectory(path,0);
}

#endif

#endif

