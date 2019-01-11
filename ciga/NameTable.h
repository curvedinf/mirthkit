#ifndef _NAMETABLE_H
#define _NAMETABLE_H

#include "List.h"

#include <string.h>
#include <stdlib.h>

extern bool exiting;

namespace ciga {
		
	template <typename TYPE>
	class NameTable
	{
		public:
		struct NamedData
		{
			char name[256];
			TYPE* data;
		};
		
		List<NamedData>* buckets;
		unsigned int bucketsSize;
		unsigned int size;
		
		static unsigned int hash(char* string)
		{
			unsigned int hash = 2000000009;
			unsigned int i=0;
			while(string[i])
			{
				for(int j=0;j<4&&string[i];j++)
				{
					hash ^= ((int)string[i])<<j;
					i++;
				}
			}
			return hash;
		}
		
		NameTable(unsigned int bucketsSize = 127)
		{
			this->bucketsSize = bucketsSize;
			buckets = new List<NamedData>[bucketsSize];
		}
		
		~NameTable(void)
		{
			if(!exiting) clear();
			delete [] buckets;
		}
		
		TYPE** get(char* name)
		{
			List<NamedData>* bucket = &(buckets[hash(name)%bucketsSize]);
			Node<NamedData>* current = bucket->root;
			while(current && strcmp(current->value->name, name)!=0)
			{
				current = Node<NamedData>::getNext(current);
			}
			if(!current) {
				NamedData *named = new NamedData();
				named->data = 0;
				strcpy(named->name, name);
				bucket->pushFront(named);
				current = bucket->root;
				size++;
			}
			return &current->value->data;
		}
		
		TYPE** getExisting(char* name)
		{
			List<NamedData>* bucket = &buckets[hash(name)%bucketsSize];
			Node<NamedData>* current = bucket->root;
			while(current && strcmp(current->value->name, name)!=0)
			{
				current = Node<NamedData>::getNext(current);
			}
			if(current) {
				return &current->value->data;
			}
			return 0;
		}
		
		TYPE* remove(char* name)
		{
			List<NamedData>* bucket = &buckets[hash(name)%bucketsSize];
			Node<NamedData>** current = &bucket->root;
			while((*current) && strcmp(((*current)->value)->name, name)!=0)
			{
				current = Node<NamedData>::getNext(current);
			}
			if(*current) {
				NamedData* named = bucket->remove(current);
				TYPE* data = named->data;
				delete named;
				size--;
				return data;
			}
			return 0;
		}
		
		void clear(void)
		{
			for(unsigned int i=0; i<bucketsSize; i++)
			{
				NamedData *named;
				do
				{
					named = (NamedData *)buckets[i].popFront();
					delete named;
				} while(named);
			}
			size=0;
		}
		
		void append(List<TYPE>* list)
		{
			for(unsigned int i=0; i<bucketsSize; i++)
			{
				Node<NamedData>* current = buckets[i].root;
				while(current)
				{
					list->pushFront(current->value->data);
					current = Node<NamedData>::getNext(current);
				}
			}
		}
		
		void appendNot(List<TYPE>* list,char* name)
		{
			for(unsigned int i=0; i<bucketsSize; i++)
			{
				Node<NamedData>* current = buckets[i].root;
				while(current)
				{
					if(strcmp(current->value->name,name)!=0)
						list->pushFront(current->value->data);
					current = Node<NamedData>::getNext(current);
				}
			}
		}
	};
}
#endif
