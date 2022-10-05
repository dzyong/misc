package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/cgi"
	"os"
	"strings"
)

func main() {
	var username = os.Getenv("USER")
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		//fmt.Println(r.URL.Path)
		x := strings.Split(r.URL.Path, "/")
		switch x[1] {
		case "":
			http.ServeFile(w, r, "pub/login.html")
		case "favicon.ico":
			http.ServeFile(w, r, "pub/favicon.ico")
		case "public":
			y := strings.Replace(r.URL.Path, "/public", "pub", 1)
			http.ServeFile(w, r, y)
		case "cgi":
			handler := new(cgi.Handler)
			handler.Path = "/home/" + username + "/bin/go"
			r.ParseForm()
			//fmt.Println(r.Header, r.Form)
			para, _ := json.Marshal(r.Form)
			args := []string{"run", "/home/" + username + "/test/temp/mnt/test/go/myapp" + r.URL.Path, string(para)}
			//fmt.Println(args)
			handler.Args = append(handler.Args, args...)
			handler.Env = append(handler.Env, "GOPATH=/home/"+username+"/go")
			handler.Env = append(handler.Env, "GOCACHE=/home/"+username+"/.cache/go-build")
			handler.Env = append(handler.Env, "USER="+username)
			handler.ServeHTTP(w, r)
		default:
			w.Write([]byte("Can't find " + r.URL.Path))
		}
	})

	fmt.Println(http.ListenAndServe(":8080", nil))
}
