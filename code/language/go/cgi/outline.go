package main

import (
	"encoding/json"
	"fmt"
	"html/template"
	"os"
	"strconv"
)

type Hello struct {
	Name string
	Age  int
}

func main() {
	//fmt.Println(os.Args)
	var resMap map[string]interface{}
	json.Unmarshal([]byte(os.Args[1]), &resMap)
	age, _ := strconv.Atoi(resMap["age"].([]interface{})[0].(string))
	hello := Hello{resMap["name"].([]interface{})[0].(string), age}
	outline := template.Must(template.ParseFiles("/home/" + os.Getenv("USER") + "/test/temp/mnt/test/go/myapp/template/outline.html"))
	fmt.Print("Content-Type: text/html;charset=utf-8\n\n")
	err := outline.ExecuteTemplate(os.Stdout, "outline.html", hello)
	if err != nil {
		fmt.Println("error: ", err.Error())
	}
}
