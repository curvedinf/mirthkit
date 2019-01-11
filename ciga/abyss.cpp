// This is a compression and cryptography utility that's safe with null terminated strings

#include <zlib.h>
#include <openssl/sha.h>
#include <openssl/aes.h>

#include "NameTable.h"

#define ABYSS_BUFFER_SIZE 20*1024*1024 // 20 megabytes
#define ABYSS_HASH_SIZE (SHA_DIGEST_LENGTH*4)

namespace ciga
{
	NameTable<AES_KEY> _aesEncryptKeys;
	NameTable<AES_KEY> _aesDecryptKeys;
	
	void _abFlush()
	{
		List<AES_KEY> aesKeyList;
		_aesEncryptKeys.append(&aesKeyList);
		_aesDecryptKeys.append(&aesKeyList);
		AES_KEY* aesKey = aesKeyList.popFront();
		while(aesKey)
		{
			delete aesKey;
			aesKey = aesKeyList.popFront();
		}
		_aesEncryptKeys.clear();
		_aesDecryptKeys.clear();
	}
	
	char _encChar64(unsigned char u)
	{
		if(u < 26)	return 'A'+u;
		if(u < 52)	return 'a'+(u-26);
		if(u < 62)	return '0'+(u-52);
		if(u == 62) return '+';
		return '/';
	}
	
	void _enc64(char* buffer, int length, char* string)
	{
		unsigned char* p = (unsigned char*)string;
		
		for(int i=0; i<length; i+=3) {
			
			unsigned char b1=0,b2=0,b3=0,b4=0,b5=0,b6=0,b7=0;
			
			b1 = buffer[i];
			
			if(i+1<length)
				b2 = buffer[i+1];
			
			if(i+2<length)
				b3 = buffer[i+2];
			
			b4= b1>>2;
			b5= ((b1&0x3)<<4)|(b2>>4);
			b6= ((b2&0xf)<<2)|(b3>>6);
			b7= b3&0x3f;
			
			*p++= _encChar64(b4);
			*p++= _encChar64(b5);
			
			if(i+1<length) {
				*p++= _encChar64(b6);
			} else {
				*p++= '=';
			}
			
			if(i+2<length) {
				*p++= _encChar64(b7);
			} else {
				*p++= '=';
			}
		}
		*p=0;
	}
	
	unsigned char _decChar64(char c) 
	{
		if(c >= 'A' && c <= 'Z') return(c - 'A');
		if(c >= 'a' && c <= 'z') return(c - 'a' + 26);
		if(c >= '0' && c <= '9') return(c - '0' + 52);
		if(c == '+') return 62;
		return 63;

	}
	
	void _dec64(char* string, char* buffer, int* length)
	{
		unsigned char *p= (unsigned char*)buffer;
		int l= strlen(string)+1;
		
		for(int k=0; k<l; k+=4) {
		
			char c1='A', c2='A', c3='A', c4='A';
			unsigned char b1=0, b2=0, b3=0, b4=0;
		
			c1 = string[k];
		
			if(k+1<l) c2 = string[k+1];
			if(k+2<l) c3 = string[k+2];
			if(k+3<l) c4 = string[k+3];
		
			b1 = _decChar64(c1);
			b2 = _decChar64(c2);
			b3 = _decChar64(c3);
			b4 = _decChar64(c4);
		
			*p++=((b1<<2)|(b2>>4));
		
			if(c3 != '=') *p++=(((b2&0xf)<<4)|(b3>>2) );
			if(c4 != '=') *p++=(((b3&0x3)<<6)|b4 );
		}
		
		*length = (int)(((char*)p)-buffer);
	}
	
	void compress(char* string, char* compressed, int level)
	{
		char* temp = new char[ABYSS_BUFFER_SIZE];
		int tempLen = ABYSS_BUFFER_SIZE;
		compress2((Bytef*)temp,(uLongf*)&tempLen,(const Bytef*)string,strlen(string),level);
		_enc64(temp,tempLen,compressed);
		delete [] temp;
	}
	
	void decompress(char* compressed, char* string)
	{
		char* temp = new char[ABYSS_BUFFER_SIZE];
		int tempLen = 0;
		_dec64(compressed,temp,&tempLen);
		int stringLen = ABYSS_BUFFER_SIZE;
		uncompress((Bytef*)string,(uLongf*)&stringLen,(const Bytef*)temp,tempLen);
		delete [] temp;
	}
	
	void hash(char* string,char* hash)
	{
		char* digest = (char*)SHA1((const unsigned char*)string,strlen(string),0);
		_enc64(digest,SHA_DIGEST_LENGTH,hash);
	}
	
	void encrypt(char* string, char* password, char* encrypted)
	{
		int len = strlen(string);
		
		AES_KEY** key = _aesEncryptKeys.get(password);
		if(!*key)
		{
			*key = new AES_KEY;
			AES_set_encrypt_key((const unsigned char*)password,128,*key);
		}
		
		char* temp = new char[ABYSS_BUFFER_SIZE];
		memset(temp,0,ABYSS_BUFFER_SIZE);
		
		memset(encrypted,0,ABYSS_BUFFER_SIZE);
		strcpy(encrypted,string);
		
		int i=0;
		for(;i<len;i+=AES_BLOCK_SIZE)
		{
			AES_encrypt((const unsigned char*)(encrypted+i),(unsigned char*)(temp+i),*key);
		}
		
		_enc64(temp,i,encrypted);
		
		delete [] temp;
	}
	
	void decrypt(char* encrypted, char* password, char* string)
	{
		AES_KEY** key = _aesDecryptKeys.get(password);
		if(!*key)
		{
			*key = new AES_KEY;
			AES_set_decrypt_key((const unsigned char*)password,128,*key);
		}
		
		char* temp = new char[ABYSS_BUFFER_SIZE];
		int len;
		_dec64(encrypted,temp,&len);
		temp[len] = 0;
		
		int i=0;
		for(;i<len;i+=AES_BLOCK_SIZE)
		{
			AES_decrypt((const unsigned char*)(temp+i),(unsigned char*)(string+i),*key);
		}
		string[i] = 0;
		
		delete [] temp;
	}
}
