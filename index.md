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

The [`sd-api-server`](https://github.com/LlamaEdge/sd-api-server) runtime supports the Open AI compatible web service endpoint `/v1/images/generations`.

#### Usage

Instantiate `cs.LlamaEdge.LlamaEdge` in your *On Startup* database method:

```4d
var $LlamaEdge : cs.LlamaEdge

If (False)
    $LlamaEdge:=cs.LlamaEdge.new()  //default
Else 
    var $modelsFolder : 4D.Folder
    $modelsFolder:=Folder(fk home folder).folder(".LlamaEdge")
    var $URL : Text
    var $file : 4D.File
    $URL:="https://huggingface.co/second-state/stable-diffusion-2-1-GGUF/resolve/main/v2-1_768-nonema-pruned-Q4_0.gguf"
    $file:=$modelsFolder.file("v2-1_768-nonema-pruned-Q4_0.gguf")
    $port:=8080
    $LlamaEdge:=cs.LlamaEdge.new($port; $file; $URL; {model_name: "sd3"}; Formula(ALERT(This.file.name+($1.success ? " started!" : " did not start..."))))
End if 
```

Unless the server is already running (in which case the costructor does nothing), the following procedure runs in the background:

1. The specified model is download via HTTP
2. The `mistralrs-server` program is started

Now you can test the server:

```
curl -X POST http://127.0.0.1:8080/v1/embeddings \
     -H "Content-Type: application/json" \
     -d '{"input":"The quick brown fox jumps over the lazy dog."}'
```

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

The API is compatibile with [Open AI](https://platform.openai.com/docs/api-reference/embeddings). 

|Class|API|Availability|
|-|-|:-:|
|Models|`/v1/models`|✅|
|Chat|`/v1/chat/completions`|✅|
|Images|`/v1/images/generations`|✅|
|Moderations|`/v1/moderations`||
|Embeddings|`/v1/embeddings`|✅|
|Files|`/v1/files`||

#### Models

You can find quantised stable diffusion models on [Hugging Face](https://huggingface.co/second-state).

Here are a few models smaller than a couple of gigabytes:

|Version|Quantisation|Size|
|-|-:|-:|
|[2.1](https://huggingface.co/second-state/stable-diffusion-2-1-GGUF/resolve/main/v2-1_768-nonema-pruned-f16.gguf)|`f16`|`2.61 GB`|
