package main

import (
	"encoding/csv"
	"fmt"
	"io/ioutil"
	"os"
	"strings"
)

func processTrace(filename string) {
	name := strings.Split(filename, ".")[0]

	policy := strings.Split(name, "_")[0]
	capacity := strings.Split(name, "_")[1]

	file, err := os.Open(os.Args[1] + "/" + filename)
	if err != nil {
		fmt.Println("Error opening file:", err)
		return
	}

	defer file.Close()

	reader := csv.NewReader(file)
	reader.Read()

	req := 0
	hits := 0

	for {
		row, err := reader.Read()
		if err != nil {
			break
		}
		req++

		status := row[2]
		if status == "HIT" {
			hits++
		}

	}

	fmt.Printf(
		"%s,%s,%f\n",
		policy,
		capacity,
		float64(hits)/float64(req),
	)

}

func main() {

	files, err := ioutil.ReadDir(os.Args[1])
	if err != nil {
		fmt.Println("Error:", err)
		return
	}

	fmt.Printf("policy,capacity,hitRatio\n")
	for _, file := range files {
		if strings.Contains(file.Name(), ".csv") {
			processTrace(file.Name())
		}
	}
}
