package main

import (
	"log"
	"net/http"
)

// Consts ...
const (
	DocRoot string = "/public"
	Port    int    = 4488
	RootURL string = "/"
)

func main() {
	fs := http.FileServer(http.Dir(DocRoot))
	http.Handle(RootURL, fs)

	log.Printf("Listening on port %d ...", Port)
	http.ListenAndServe(":4488", nil)
}
