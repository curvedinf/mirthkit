#include "MemoryBlock.h"

#include <stdlib.h>
#include <memory.h>

namespace ciga {
		
	MemoryBlock::MemoryBlock(int _segmentSize, int _numSegments, void *validStart)
	{
		start = 0;
		if(_segmentSize)
		{
			Create(_segmentSize, _numSegments, validStart);
		}
	}
	
	MemoryBlock::~MemoryBlock(void)
	{
		Destroy();
	}
	
	void MemoryBlock::Create(int _segmentSize, int _numSegments, void *validStart)
	{
		if(start) Destroy();
	
		segmentSize = _segmentSize;
	
		if(validStart) start = validStart;
		else start = malloc(_segmentSize*_numSegments);
		memset(start, 0, _segmentSize * _numSegments);
		
		firstFree = (Segment *)start;
		
		Segment **thisFree = &firstFree;
		for(int i=0; i<_numSegments; i++)
		{
			(*thisFree)->start = (*((char**)thisFree)+_segmentSize);
			thisFree = (Segment **)&(*thisFree)->start;
		}
		*thisFree = 0;
	}
	
	void MemoryBlock::Destroy(void)
	{
		if(start) free(start);
		start = 0;
	}
	
	void *MemoryBlock::Allocate(int size)
	{
		if(size>segmentSize || !firstFree) return 0;
		Segment *thisFree = firstFree;
		firstFree = (Segment *)thisFree->start;
		return &thisFree->start;
	}
	
	void MemoryBlock::Deallocate(void *vp)
	{
		((Segment *)vp)->start = firstFree;
		firstFree = (Segment *)vp;
	}
	
	void *MemoryBlock::GetStart(void)
	{
		return start;
	}
}
