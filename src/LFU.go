package main

import (
	"container/heap"
)

type PageLFU struct {
	id        int
	frequency int
	index     int
}

type LFUMemory struct {
	capacity int
	memory   map[int]*PageLFU
	minHeap  PageHeap
}

func NewLFUMemory(capacity int) *LFUMemory {
	return &LFUMemory{
		capacity: capacity,
		memory:   make(map[int]*PageLFU),
		minHeap:  make(PageHeap, 0, capacity),
	}
}

func (lfu *LFUMemory) Add(pageLFUID int) bool {
	if pageLFU, found := lfu.memory[pageLFUID]; found {
		pageLFU.frequency++
		heap.Fix(&lfu.minHeap, pageLFU.index)
		return true
	}

	if len(lfu.memory) >= lfu.capacity {
		lfu.evict()
	}

	newPageLFU := &PageLFU{id: pageLFUID, frequency: 1}
	heap.Push(&lfu.minHeap, newPageLFU)
	lfu.memory[pageLFUID] = newPageLFU
	return false
}

func (lfu *LFUMemory) evict() {
	leastUsedPageLFU := heap.Pop(&lfu.minHeap).(*PageLFU)
	delete(lfu.memory, leastUsedPageLFU.id)
}

type PageHeap []*PageLFU

func (h PageHeap) Len() int           { return len(h) }
func (h PageHeap) Less(i, j int) bool { return h[i].frequency < h[j].frequency }
func (h PageHeap) Swap(i, j int) {
	h[i], h[j] = h[j], h[i]
	h[i].index = i
	h[j].index = j
}

func (h *PageHeap) Push(x interface{}) {
	pageLFU := x.(*PageLFU)
	pageLFU.index = len(*h)
	*h = append(*h, pageLFU)
}

func (h *PageHeap) Pop() interface{} {
	old := *h
	n := len(old)
	pageLFU := old[n-1]
	old[n-1] = nil
	pageLFU.index = -1
	*h = old[0 : n-1]
	return pageLFU
}
