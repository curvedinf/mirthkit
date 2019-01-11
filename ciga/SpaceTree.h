#ifndef _SPACETREE_H
#define _SPACETREE_H

// This tree does not allow multiple data with the same position
// To make up for this, use another datastructure as its type (SpaceTree<List<...> >)

#include "List.h"

namespace ciga {
	
	template <typename TYPE>
	class SpaceTree
	{
		public:
		struct PositionedData
		{
			int position;
			PositionedData* greater;
			PositionedData* lesser;
			TYPE* data;
		};
		
		PositionedData* root;
		int size;
		
		// helper functions
		void _clearRec(PositionedData** current)
		{
			if((*current)->lesser)	_clearRec(&(*current)->lesser);
			if((*current)->greater) _clearRec(&(*current)->greater);
			delete *current;
		}
		void _appendRec(List<TYPE>* list,PositionedData* current)
		{
			if(current->lesser) _appendRec(list,current->lesser);
			list->pushBack(current->data);
			if(current->greater) _appendRec(list,current->greater);
		}
		void _appendReverseRec(List<TYPE>* list,PositionedData* current)
		{
			if(current->greater) _appendReverseRec(list,current->greater);
			list->pushBack(current->data);
			if(current->lesser) _appendReverseRec(list,current->lesser);
		}
		
		// methods
		SpaceTree()
		{
			size=0;
			root=0;
		}
		~SpaceTree()
		{
			clear();
		}
		void clear()
		{
			if(root) _clearRec(&root);
			size=0;
		}
		TYPE** get(int position)
		{
			PositionedData** parent = &root;
			while(*parent)
			{
				if(position==(*parent)->position)
				{
					return &(*parent)->data;
				}
				else if(position>(*parent)->position)
				{
					parent = &(*parent)->greater;
				}
				else
				{
					parent = &(*parent)->lesser;
				}
			}
			
			*parent = new PositionedData();
			(*parent)->position = position;
			(*parent)->greater = 0;
			(*parent)->lesser = 0;
			(*parent)->data = 0;
			
			size++;
			
			return &(*parent)->data;
		}
		TYPE** getExisting(int position)
		{
			PositionedData** parent = &root;
			while(*parent)
			{
				if(position==(*parent)->position)
				{
					return &(*parent)->data;
				}
				else if(position>(*parent)->position)
				{
					parent = &(*parent)->greater;
				}
				else
				{
					parent = &(*parent)->lesser;
				}
			}
			return 0;
		}
		TYPE* remove(int position)
		{
			PositionedData** parent = &root;
			while(*parent)
			{
				if(position==(*parent)->position)
				{
					break;
				}
				else if(position>(*parent)->position)
				{
					parent = &(*parent)->greater;
				}
				else
				{
					parent = &(*parent)->lesser;
				}
			}
			
			PositionedData* lesserTree = (*parent)->lesser;
			PositionedData* greaterTree = (*parent)->greater;
			TYPE* data = (*parent)->data;
			
			delete *parent;
			*parent = greaterTree;
			
			PositionedData** current = &greaterTree->lesser;
			while(*current)
			{
				current = &(*current)->lesser;
			}
			*current = lesserTree;
			
			size--;
			return data;
		}
		void append(List<TYPE>* list) // in order, lowest to highest
		{
			_appendRec(list,root);
		}
		void appendReverse(List<TYPE>* list)
		{
			_appendReverseRec(list,root);
		}
	};
}
#endif /* _SPACETREE_H */
