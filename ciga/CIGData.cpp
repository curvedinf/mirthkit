#include "MemoryBlock.h"
#include "Node.h"

namespace ciga {
	MemoryBlock _nodes(sizeof(Node<int>),1024*16);
}
