package main

import (
	"github.com/nick96/flask-monitoring/flask-app"
)

func main() {
	if err := flaskApp.flaskApp(); err != nil {
		log.Fatalf("Error: %v", err)
	}
}
