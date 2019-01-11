#ifndef _LINUX__H__
#define _LINUX__H__

#ifndef WIN32
#include <arpa/inet.h>
#include <sys/times.h>
#include <sys/time.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <time.h>
#include <fcntl.h>

#define PLATFORM_SOCK int

void platformInit(void) {}

void closesocket(int) {}

int platformBind(int sock,char* IP,unsigned short port)
{
	fcntl(sock, F_SETFL, O_NONBLOCK);
	sockaddr_in address;
	if(IP[0]==0)
		address.sin_addr.s_addr = htonl(INADDR_ANY);
	else
		address.sin_addr.s_addr = inet_addr(IP);
	address.sin_port = htons(port);
	address.sin_family = AF_INET;
	return bind(sock,(sockaddr*)&address,sizeof(address));
}

int platformBind6(int sock,char* IP,unsigned short port)
{
	fcntl(sock, F_SETFL, O_NONBLOCK);
	sockaddr_in6 address;
	if(IP[0]==0)
		address.sin6_addr = in6addr_any;
	else
		inet_pton(AF_INET6,IP,&address.sin6_addr);
	address.sin6_port = htons(port);
	address.sin6_family = AF_INET6;
	return bind(sock,(sockaddr*)&address,sizeof(address));
}

PLATFORM_SOCK platformAccept(int sock)
{
	sockaddr_in address;
	socklen_t addressLength = sizeof(address);
	return accept(sock,(sockaddr*)&address,&addressLength);
}

PLATFORM_SOCK platformAccept6(int sock)
{
	sockaddr_in6 address;
	socklen_t addressLength = sizeof(address);
	return accept(sock,(sockaddr*)&address,&addressLength);
}

int platformConnect(int sock,char* IP,unsigned short port)
{
	sockaddr_in address;
	address.sin_addr.s_addr = inet_addr(IP);
	address.sin_port = htons(port);
	address.sin_family = AF_INET;
	return connect(sock,(sockaddr*)&address,sizeof(address));
}

int platformConnect6(int sock,char* IP,unsigned short port)
{
	sockaddr_in6 address;
	inet_pton(AF_INET6,IP,&address.sin6_addr);
	address.sin6_port = htons(port);
	address.sin6_family = AF_INET6;
	return connect(sock,(sockaddr*)&address,sizeof(address));
}

int platformRecvfrom(int sock,char* IP,unsigned short* port,char* buffer,unsigned short bufferLength)
{
	sockaddr_in address;
	address.sin_addr.s_addr = htonl(INADDR_ANY);
	address.sin_port = htons(0);
	address.sin_family = AF_INET;
	socklen_t addressLength = sizeof(address);
	int amount = recvfrom(sock,buffer,bufferLength,0,(sockaddr*)&address,&addressLength);
	if(amount<=0)
		return amount;
	inet_ntop(AF_INET,&address.sin_addr.s_addr,IP,64);
	*port = ntohs(address.sin_port);
	return amount;
}

int platformRecvfrom6(int sock,char* buffer,unsigned short bufferLength)
{
	sockaddr_in6 address;
	address.sin6_addr = in6addr_any;
	address.sin6_port = htons(0);
	address.sin6_family = AF_INET6;
	socklen_t addressLength = sizeof(address);
	return recvfrom(sock,buffer,bufferLength,0,(sockaddr*)&address,&addressLength);
}

int platformSendto(int sock,char* IP,unsigned short port,char* buffer,unsigned short size)
{
	sockaddr_in address;
	address.sin_addr.s_addr = inet_addr(IP);
	address.sin_port = htons(port);
	address.sin_family = AF_INET;
	return sendto(sock,buffer,size,0,(sockaddr*)&address,sizeof(address));
}

int platformSendto6(int sock,char* IP,unsigned short port,char* buffer,unsigned short size)
{
	sockaddr_in6 address;
	inet_pton(AF_INET6,IP,&address.sin6_addr);
	address.sin6_port = htons(port);
	address.sin6_family = AF_INET6;
	return sendto(sock,buffer,size,0,(sockaddr*)&address,sizeof(address));
}

unsigned int millis()
{
	tms tm;
	return times(&tm)*10;
}

unsigned long long int micros(void)
{
	timeval time;
	gettimeofday(&time,0);
	return (unsigned long long int)time.tv_usec + time.tv_sec*1000000;
}

void microWait(unsigned long long int u)
{
	setpriority(PRIO_PROCESS,0,20);
	unsigned long long int waitEnd = micros()+u;
	while(micros()<waitEnd) {}
	setpriority(PRIO_PROCESS,0,0);
}

void makeDirectory(char* path)
{
	mkdir(path,S_IRWXU|S_IRGRP|S_IROTH);
}

#endif

#endif

