package main

import (
	"container/list"
)

type Page2Lists struct {
	id         int
	inActive   bool
	referenced bool
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

func (lru *LRU2Lists) Add(Page2ListsID int) bool {
	if elem, found := lru.cache[Page2ListsID]; found {
		Page2Lists := elem.Value.(*Page2Lists)
		if Page2Lists.inActive {
			Page2Lists.referenced = true
			lru.activeList.MoveToFront(elem)
		} else {
			lru.inactiveList.Remove(elem)
			Page2Lists.inActive = true
			Page2Lists.referenced = true
			lru.activeList.PushFront(elem.Value)
			lru.cache[Page2ListsID] = lru.activeList.Front()
			if lru.activeList.Len() > lru.activeSize {
				lru.moveToInactive()
			}
		}
		return true
	}

	if len(lru.cache) >= lru.capacity {
		lru.evict()
	}

	Page2Lists := &Page2Lists{id: Page2ListsID, inActive: false, referenced: true}
	elem := lru.inactiveList.PushFront(Page2Lists)
	lru.cache[Page2ListsID] = elem
	if lru.inactiveList.Len() > lru.inactiveSize {
		lru.evict()
	}
	return false
}

func (lru *LRU2Lists) moveToInactive() {
	for {
		elem := lru.activeList.Back()
		if elem == nil {
			return
		}
		Page2Lists := elem.Value.(*Page2Lists)

		if Page2Lists.referenced {
			Page2Lists.referenced = false
			lru.activeList.MoveToFront(elem)
		} else {
			lru.activeList.Remove(elem)
			Page2Lists.inActive = false
			lru.inactiveList.PushFront(elem.Value)
			lru.cache[Page2Lists.id] = lru.inactiveList.Front()
			if lru.inactiveList.Len() > lru.inactiveSize {
				lru.evict()
			}
			break
		}
	}
}

func (lru *LRU2Lists) evict() {
	for {
		if lru.inactiveList.Len() > 0 {
			elem := lru.inactiveList.Back()
			if elem == nil {
				return
			}
			page := elem.Value.(*Page2Lists)
			// Verifica o bit de referência
			if page.referenced {
				// Se a página foi referenciada, move para o início da lista inativa
				page.referenced = false // Reseta o bit
				lru.inactiveList.MoveToFront(elem)
			} else {
				// Se a página não foi referenciada, remove do cache completamente
				lru.inactiveList.Remove(elem)
				delete(lru.cache, page.id)
				break
			}
		}
	}
}
