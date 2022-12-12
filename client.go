package main

import (
	"bytes"
	"io"
	"os"
	"strings"
	"fmt"
	"net/http"
	"mime/multipart"
)

func main() {
	urls := []string{
		"http://localhost:9292/content",
		"http://localhost:9292/redirect-301",
		"http://localhost:9292/redirect-302",
		"http://localhost:9292/redirect-307",
	}
	
	body := &bytes.Buffer{}
	writer := multipart.NewWriter(body)
	fw, err := writer.CreateFormField("hello")
	if err != nil {
		panic(err)
	}
	
	_, err = io.Copy(fw, strings.NewReader("world"))
	if err != nil {
		panic(err)
	}
	
	writer.Close()
	
	fmt.Println("--- Multipart Body:")
	io.Copy(os.Stdout, body)
	fmt.Println()
	
	for _, url := range urls {
		resp, err := http.Post(url, writer.FormDataContentType(), body)
		
		if err != nil {
			panic(err)
		}
		
		fmt.Println("--- Posting to url: " + url)
		fmt.Println(resp.Status)
		fmt.Println(resp.Header)
		fmt.Println(resp.Body)
		io.Copy(os.Stdout, resp.Body)
		fmt.Println()
	}
}
