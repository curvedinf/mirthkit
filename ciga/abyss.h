#ifndef _ABYSS_H
#define _ABYSS_H

// This is a compression and cryptography utility that's safe with null terminated strings

#include <zlib.h>
#include <openssl/sha.h>
#include <openssl/aes.h>

#include "NameTable.h"

#define ABYSS_BUFFER_SIZE 5*1024*1024 // 5 megabytes
#define ABYSS_HASH_SIZE (SHA_DIGEST_LENGTH*4)

namespace ciga
{
	void _abFlush();
	char _encChar64(unsigned char u);
	void _enc64(char* buffer, int length, char* string);
	unsigned char _decChar64(char c);
	void _dec64(char* string, char* buffer, int* length);
	
	void compress(char* string, char* compressed, int level);
	void decompress(char* compressed, char* string);
	void hash(char* string,char* hash);
	void encrypt(char* string, char* password, char* encrypted);
	void decrypt(char* encrypted, char* password, char* string);
}

#endif
