package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Request struct {
	Timestamp int64
	Page      int
}

func readTrace(reqChan chan Request) {
	scanner := bufio.NewScanner(os.Stdin)
	if scanner.Scan() {
		_ = scanner.Text()
	}

	for scanner.Scan() {
		row := strings.Split(scanner.Text(), ",")
		timestamp, _ := strconv.ParseInt(row[0], 10, 64)
		page, _ := strconv.Atoi(row[1])
		reqChan <- Request{Timestamp: timestamp, Page: page}
	}

	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "Erro ao ler a entrada:", err)
	}

	close(reqChan)
}

func simulate(memorySimulator interface{}, trace chan Request, output chan string) {
	for req := range trace {
		status := "MISS"
		switch sim := memorySimulator.(type) {
		case *LRUMemory:
			if sim.Add(req.Page) {
				status = "HIT"
			}
		case *ClockMemory:
			if sim.Add(req.Page) {
				status = "HIT"
			}
		case *LFUMemory:
			if sim.Add(req.Page) {
				status = "HIT"
			}
		case *LRU2Lists:
			if sim.Add(req.Page) {
				status = "HIT"
			}
		}

		output <- fmt.Sprintf("%d,%d,%s", req.Timestamp, req.Page, status)
	}

	close(output)
}

func main() {
	algorithm := flag.String("eviction_algo", "LRU", "Escolha o algoritmo de substituição: LRU, Clock, LFU")
	cacheSize := flag.Int("memory_size", 4, "Capacidade do cache")
	flag.Parse()

	var memorySimulator interface{}

	switch *algorithm {
	case "LRU":
		memorySimulator = NewLRUMemory(*cacheSize)
	case "Clock":
		memorySimulator = NewClockMemory(*cacheSize)
	case "LFU":
		memorySimulator = NewLFUMemory(*cacheSize)
	case "2Lists":
		memorySimulator = NewLRU2Lists(*cacheSize)
	default:
		fmt.Println("Algoritmo inválido. Escolha entre LRU, Clock ou LFU.")
		return
	}

	reqChan := make(chan Request, 10000)
	outputChan := make(chan string, 10000)

	go readTrace(reqChan)
	go simulate(memorySimulator, reqChan, outputChan)

	fmt.Println("timestamp,page,status")
	for res := range outputChan {
		fmt.Println(res)
	}
}
