package main

type PageClock struct {
	id      int
	usedBit bool
}

type ClockMemory struct {
	capacity int
	pages    []*PageClock
	pointer  int
}

func NewClockMemory(capacity int) *ClockMemory {
	return &ClockMemory{
		capacity: capacity,
		pages:    make([]*PageClock, 0, capacity),
		pointer:  0,
	}
}

func (clock *ClockMemory) Add(PageClockID int) bool {
	for _, PageClock := range clock.pages {
		if PageClock.id == PageClockID {
			PageClock.usedBit = true
			return true
		}
	}

	if len(clock.pages) < clock.capacity {
		clock.pages = append(clock.pages, &PageClock{id: PageClockID, usedBit: true})
		return false
	}

	clock.replace(PageClockID)
	return false
}

func (clock *ClockMemory) replace(PageClockID int) {
	for {
		if !clock.pages[clock.pointer].usedBit {
			clock.pages[clock.pointer] = &PageClock{id: PageClockID, usedBit: true}
			clock.pointer = (clock.pointer + 1) % clock.capacity
			break
		} else {
			clock.pages[clock.pointer].usedBit = false
			clock.pointer = (clock.pointer + 1) % clock.capacity
		}
	}
}
