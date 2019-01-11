#ifndef _MEMORYBLOCK_H
#define _MEMORYBLOCK_H

namespace ciga {
	class MemoryBlock
	{
		struct Segment
		{
			void *start;
		};
		void *start;
		int segmentSize;
		Segment *firstFree;
	public:
		MemoryBlock(int _segmentSize = 4, int _numSegments = 256, void *startAddress = 0);
		~MemoryBlock(void);
		
		void Create(int _segmentSize, int _numSegments = 256, void *startAddress = 0);
		void Destroy(void);
	
		void *Allocate(int size = 0);
		void Deallocate(void *vp);
	
		void *GetStart(void);
	};
}
#endif
