package main

import (
	"container/list"
)

type LRUMemory struct {
	capacity int
	memory   map[int]*list.Element
	list     *list.List
}

type Page struct {
	id int
}

func NewLRUMemory(capacity int) *LRUMemory {
	return &LRUMemory{
		capacity: capacity,
		memory:   make(map[int]*list.Element),
		list:     list.New(),
	}
}

func (lru *LRUMemory) Add(id int) bool {
	if elem, found := lru.memory[id]; found {
		lru.list.MoveToFront(elem)
		return true
	}

	if lru.list.Len() == lru.capacity {
		lru.remove()
	}

	page := &Page{id: id}
	elem := lru.list.PushFront(page)
	lru.memory[id] = elem
	return false
}

func (lru *LRUMemory) remove() {
	elem := lru.list.Back()
	if elem != nil {
		page := elem.Value.(*Page)
		delete(lru.memory, page.id)
		lru.list.Remove(elem)
	}
}
