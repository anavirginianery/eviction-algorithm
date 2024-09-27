package main

import (
	"container/heap"
)

type PageLRU struct {
	id        int
	frequency int
	index     int
}

type LFUMemory struct {
	capacity int
	cache    map[int]*PageLRU
	minHeap  PageHeap
}

func NewLFUMemory(capacity int) *LFUMemory {
	return &LFUMemory{
		capacity: capacity,
		cache:    make(map[int]*PageLRU),
		minHeap:  make(PageHeap, 0, capacity),
	}
}

func (lfu *LFUMemory) Add(pageLRUID int) bool {
	if pageLRU, found := lfu.cache[pageLRUID]; found {
		pageLRU.frequency++
		heap.Fix(&lfu.minHeap, pageLRU.index)
		return true
	}

	if len(lfu.cache) >= lfu.capacity {
		lfu.evict()
	}

	newPageLRU := &PageLRU{id: pageLRUID, frequency: 1}
	heap.Push(&lfu.minHeap, newPageLRU)
	lfu.cache[pageLRUID] = newPageLRU
	return false
}

func (lfu *LFUMemory) evict() {
	leastUsedPageLRU := heap.Pop(&lfu.minHeap).(*PageLRU)
	delete(lfu.cache, leastUsedPageLRU.id)
}

type PageHeap []*PageLRU

func (h PageHeap) Len() int           { return len(h) }
func (h PageHeap) Less(i, j int) bool { return h[i].frequency < h[j].frequency }
func (h PageHeap) Swap(i, j int) {
	h[i], h[j] = h[j], h[i]
	h[i].index = i
	h[j].index = j
}

func (h *PageHeap) Push(x interface{}) {
	pageLRU := x.(*PageLRU)
	pageLRU.index = len(*h)
	*h = append(*h, pageLRU)
}

func (h *PageHeap) Pop() interface{} {
	old := *h
	n := len(old)
	pageLRU := old[n-1]
	old[n-1] = nil
	pageLRU.index = -1
	*h = old[0 : n-1]
	return pageLRU
}
