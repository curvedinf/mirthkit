#ifndef _NODE_H
#define _NODE_H

#include "MemoryBlock.h"

namespace ciga {
	extern MemoryBlock _nodes;
	
	template <typename TYPE>
	class Node
	{
		public:
		Node* next;
		TYPE* value;
		
		Node(Node* next, TYPE* value)
		{
			this->next = next;
			this->value = value;
		}
		~Node()
		{
		}
		static Node* getNext(Node* node)
		{
			return node->next;
		}	
		static TYPE** getValue(Node* node)
		{
			return &(node->value);
		}
		static Node** getNext(Node** node)
		{
			return &((*node)->next);
		}
		static TYPE** getValue(Node** node)
		{
			return &(*node)->value;	
		}
		static void insert(Node** node, TYPE* inserted)
		{
			Node* temp = *node;
			*node = (Node<TYPE>*)_nodes.Allocate();
			(*node)->next = temp;
			(*node)->value = inserted;
		}
		static TYPE* remove(Node** node)
		{
			if(!*node) return 0;
			Node *next = (*node)->next;
			TYPE *nodeValue = (*node)->value;
			_nodes.Deallocate(*node);
			*node = next;
			return nodeValue;
		}
	};
}
#endif
