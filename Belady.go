package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Access struct {
	Timestamp int
	PageID    int
}

type BeladyMemory struct {
	capacity int
	trace    []Access
	memory   map[int]bool
}

func NewBeladyMemory(capacity int, trace []Access) BeladyMemory {
	return BeladyMemory{
		capacity: capacity,
		trace:    trace,
		memory:   make(map[int]bool),
	}
}

func findNextUse(trace []Access, currentIndex int, pageID int) int {
	for i := currentIndex + 1; i < len(trace); i++ {
		if trace[i].PageID == pageID {
			return i
		}
	}
	return -1
}

func (bc BeladyMemory) findPageToEvict(currentIndex int) int {
	farthestIndex := -1
	pageToEvict := -1

	for page := range bc.memory {
		nextUse := findNextUse(bc.trace, currentIndex, page)
		if nextUse == -1 {
			return page
		}
		if nextUse > farthestIndex {
			farthestIndex = nextUse
			pageToEvict = page
		}
	}
	return pageToEvict
}

func (bc BeladyMemory) Simulate() {
	hits, misses := 0, 0

	for i, access := range bc.trace {
		pageID := access.PageID

		if _, found := bc.memory[pageID]; found {
			fmt.Printf("%d,%d,HIT\n", access.Timestamp, pageID)
			hits++
		} else {
			fmt.Printf("%d,%d,MISS\n", access.Timestamp, pageID)
			misses++

			if len(bc.memory) >= bc.capacity {
				pageToEvict := bc.findPageToEvict(i)
				delete(bc.memory, pageToEvict)
			}

			bc.memory[pageID] = true
		}
	}

	fmt.Printf("Total Hits: %d, Total Misses: %d\n", hits, misses)
}

func readTraceBelady(filename string) ([]Access, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var trace []Access
	scanner := bufio.NewScanner(file)
	scanner.Scan()

	for scanner.Scan() {
		line := scanner.Text()
		fields := strings.Split(line, ",")
		timestamp, _ := strconv.Atoi(fields[0])
		pageID, _ := strconv.Atoi(fields[1])
		trace = append(trace, Access{Timestamp: timestamp, PageID: pageID})
	}

	if err := scanner.Err(); err != nil {
		return nil, err
	}

	return trace, nil
}

func main() {
	capacity := flag.Int("capacity", 4, "Capacidade do memory de Belady")
	inputFile := flag.String("input", "trace.csv", "Arquivo CSV contendo o trace de acessos")
	flag.Parse()

	trace, err := readTraceBelady(*inputFile)
	if err != nil {
		fmt.Println("Erro ao ler o trace:", err)
		return
	}

	BeladyMemory := NewBeladyMemory(*capacity, trace)
	BeladyMemory.Simulate()
}
