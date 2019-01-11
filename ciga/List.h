#ifndef _LIST_H
#define _LIST_H

#include "Node.h"

extern bool exiting;

namespace ciga {
	
	template <typename TYPE>
	class List
	{
		public:
		Node<TYPE> *tail;
		Node<TYPE> *root;
		unsigned int size;
	
		List(void)
		{
			tail = 0;
			root = 0;
			size = 0;
		}
		~List(void)
		{
			if(!exiting) clear();
		}
		void clear(void)
		{
			while(popFront());
		}
		void pushFront(TYPE* value)
		{
			Node<TYPE>::insert(&root,value);
			if(!tail) tail = root;
			size++;
		}
		void pushBack(TYPE* value)
		{
			Node<TYPE>::insert(&tail,value);
			if(!root) root = tail;
			size++;
		}
		TYPE* peekFront()
		{
			return root->value;
		}
		TYPE* popFront()
		{
			if(!root) return 0;
			TYPE* value = Node<TYPE>::remove(&root);
			if(!root) tail = 0;
			size--;
			return value;
		}
		void append(List* list)
		{
			Node<TYPE> *current = list->root;
			while(current)
			{
				this->pushBack(current->value);
				current = Node<TYPE>::getNext(current);
			}
		}
		void insert(Node<TYPE>** node, TYPE* inserted)
		{
			Node<TYPE>::insert(node,inserted);
			size++;
		}
		TYPE* remove(Node<TYPE>** node)
		{
			if(!*node) return 0;
			if(tail==*node)
			{
				if(&root==node)
				{
					tail=0;
				}
				else
				{
					Node<TYPE>* previous = 0;
					Node<TYPE>* current = root;
					while(current)
					{
						previous = current;
						current = Node<TYPE>::getNext(current);
					}
					tail=previous;
				}
			}
			TYPE* value = Node<TYPE>::remove(node);
			size--;
			return value;
		}
	};
}
#endif
