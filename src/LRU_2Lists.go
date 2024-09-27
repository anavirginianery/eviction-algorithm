package main

import (
	"container/list"
)

type PageLRULists struct {
	id       int
	inActive bool
}

type LRU2Lists struct {
	capacity     int
	activeSize   int
	inactiveSize int
	activeList   *list.List
	inactiveList *list.List
	cache        map[int]*list.Element
}

func NewLRU2Lists(capacity int) *LRU2Lists {
	return &LRU2Lists{
		capacity:     capacity,
		activeSize:   (2 * capacity) / 3,
		inactiveSize: capacity / 3,
		activeList:   list.New(),
		inactiveList: list.New(),
		cache:        make(map[int]*list.Element),
	}
}

func (lru *LRU2Lists) Add(PageLRUListsID int) bool {
	if elem, found := lru.cache[PageLRUListsID]; found {
		PageLRULists := elem.Value.(*PageLRULists)
		if PageLRULists.inActive {
			lru.activeList.MoveToFront(elem)
		} else {
			lru.inactiveList.Remove(elem)
			PageLRULists.inActive = true
			lru.activeList.PushFront(elem.Value)
			lru.cache[PageLRUListsID] = lru.activeList.Front()
			if lru.activeList.Len() > lru.activeSize {
				lru.moveToInactive()
			}
		}
		return true
	}

	if len(lru.cache) >= lru.capacity {
		lru.evict()
	}

	PageLRULists := &PageLRULists{id: PageLRUListsID, inActive: false}
	elem := lru.inactiveList.PushFront(PageLRULists)
	lru.cache[PageLRUListsID] = elem
	if lru.inactiveList.Len() > lru.inactiveSize {
		lru.removeFromInactive()
	}
	return false
}

func (lru *LRU2Lists) moveToInactive() {
	elem := lru.activeList.Back()
	if elem != nil {
		PageLRULists := elem.Value.(*PageLRULists)
		lru.activeList.Remove(elem)
		PageLRULists.inActive = false
		lru.inactiveList.PushFront(elem.Value)
		lru.cache[PageLRULists.id] = lru.inactiveList.Front()

		if lru.inactiveList.Len() > lru.inactiveSize {
			lru.removeFromInactive()
		}
	}
}

func (lru *LRU2Lists) removeFromInactive() {
	elem := lru.inactiveList.Back()
	if elem != nil {
		PageLRULists := elem.Value.(*PageLRULists)
		lru.inactiveList.Remove(elem)
		delete(lru.cache, PageLRULists.id)
	}
}

func (lru *LRU2Lists) evict() {
	if lru.inactiveList.Len() > 0 {
		lru.removeFromInactive()
		return
	}
	elem := lru.activeList.Back()
	if elem != nil {
		PageLRULists := elem.Value.(*PageLRULists)
		lru.activeList.Remove(elem)
		delete(lru.cache, PageLRULists.id)
	}
}
