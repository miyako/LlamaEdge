---
layout: default
---

![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-arm&color=blue)
[![license](https://img.shields.io/github/license/miyako/LlamaEdge)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/LlamaEdge/total)

# Use LlamaEdge from 4D

#### Abstract

[LlamaEdge](https://llamaedge.com) is an open-source framework / platform for running large language models (LLMs) — locally or on edge devices. Built with a stack using Rust + WebAssembly, the runtime is lightweight, portable, and dependency-free.

The [`llama-api-server`](https://github.com/LlamaEdge/LlamaEdge/tree/main/llama-api-server) runtime supports the Open AI compatible web service endpoint `/v1/chat/completions` and `/v1/embeddings`.

#### Usage

Instantiate `cs.LlamaEdge.LlamaEdge` in your *On Startup* database method:

```4d
var $TEI : cs.TEI.TEI

If (False)
    $TEI:=cs.TEI.TEI.new()  //default
Else 
    var $homeFolder : 4D.Folder
    $homeFolder:=Folder(fk home folder).folder(".TEI")
    var $file : 4D.File
    var $URL : Text
    var $port : Integer
    
    var $event : cs.event.event
    $event:=cs.event.event.new()
    /*
        Function onError($params : Object; $error : cs.event.error)
        Function onSuccess($params : Object; $models : cs.event.models)
        Function onData($request : 4D.HTTPRequest; $event : Object)
        Function onResponse($request : 4D.HTTPRequest; $event : Object)
        Function onTerminate($worker : 4D.SystemWorker; $params : Object)
    */
    
    $event.onError:=Formula(ALERT($2.message))
    $event.onSuccess:=Formula(ALERT($2.models.extract("name").join(",")+" loaded!"))
    $event.onData:=Formula(LOG EVENT(Into 4D debug message; "download:"+String((This.range.end/This.range.length)*100; "###.00%")))
    $event.onResponse:=Formula(LOG EVENT(Into 4D debug message; "download complete"))
    $event.onTerminate:=Formula(LOG EVENT(Into 4D debug message; (["process"; $1.pid; "terminated!"].join(" "))))
    
    /*
        embeddings
    */
    
    If (False)  //Hugging Face mode (recommended)
        $folder:=$homeFolder.folder("dangvantuan/sentence-camembert-base")
        $URL:="dangvantuan/sentence-camembert-base"
    Else   //HTTP mode (must be .zip)
        $folder:=$homeFolder.folder("dangvantuan/sentence-camembert-base")
        $URL:="https://github.com/miyako/TEI/releases/download/models/sentence-camembert-base.zip"
    End if 
    
    $port:=8085
    $TEI:=cs.TEI.TEI.new($port; $folder; $URL; {\
    max_concurrent_requests: 512}; $event)
    
End if  
```

Unless the server is already running (in which case the costructor does nothing), the following procedure runs in the background:

1. The specified model is downloaded via HTTP
2. The `wasmedge` runtime starts the `llama-api-server` program

Now you can test the server:

```
curl -X POST http://127.0.0.1:8080/v1/embeddings \
     -H "Content-Type: application/json" \
     -d '{"input":"The quick brown fox jumps over the lazy dog."}'
```

```
curl -X POST http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama",
    "messages": [
      {
        "role": "system",
        "content": "You are a helpful assistant."
      },
      {
        "role": "user",
        "content": "Hello! can you tell me a fun fact about 4th Dimension?"
      }
    ],
    "stream": false
  }'
```

Or use the Web UI at `http://127.0.0.1:8080`

Or, use AI Kit:

```4d
var $AIClient : cs.AIKit.OpenAI
$AIClient:=cs.AIKit.OpenAI.new()
$AIClient.baseURL:="http://127.0.0.1:8080/v1"

var $text : Text
$text:="The quick brown fox jumps over the lazy dog."

var $responseEmbeddings : cs.AIKit.OpenAIEmbeddingsResult
$responseEmbeddings:=$AIClient.embeddings.create($text)
```

Finally to terminate the server:

```4d
var $LlamaEdge : cs.LlamaEdge.LlamaEdge
$LlamaEdge:=cs.LlamaEdge.LlamaEdge.new()
$LlamaEdge.terminate()
```

#### AI Kit compatibility

The API is compatibile with [Open AI](https://platform.openai.com/docs/api-reference/). 

|Class|API|Availability|
|-|-|:-:|
|Models|`/v1/models`|✅|
|Chat|`/v1/chat/completions`|✅|
|Images|`/v1/images/generations`||
|Moderations|`/v1/moderations`||
|Embeddings|`/v1/embeddings`|✅|
|Files|`/v1/files`|✅|
