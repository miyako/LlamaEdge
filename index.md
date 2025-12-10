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
var $LlamaEdge : cs.LlamaEdge.LlamaEdge

If (True)
    $LlamaEdge:=cs.LlamaEdge.LlamaEdge.new()  //default
Else 
    var $modelsFolder : 4D.Folder
    $modelsFolder:=Folder(fk home folder).folder(".LlamaEdge")
    var $file : 4D.File
    var $URL : Text
    var $models : Collection
    $models:=[]
    
    //Main model
    $file:=$modelsFolder.file("flux1-schnell-Q4_0.gguf")
    $URL:="https://huggingface.co/second-state/FLUX.1-schnell-GGUF/resolve/main/flux1-schnell-Q4_0.gguf"
    $models.push({file: $file; URL: $URL})
    
    //VAE file
    $file:=$modelsFolder.file("ae-f16.gguf")
    $URL:="https://huggingface.co/second-state/FLUX.1-schnell-GGUF/resolve/main/ae-f16.gguf"
    $models.push({file: $file; URL: $URL})
    
    //clip_l encoder
    $file:=$modelsFolder.file("clip_l-Q8_0.gguf")
    $URL:="https://huggingface.co/second-state/FLUX.1-schnell-GGUF/resolve/main/clip_l-Q8_0.gguf"
    $models.push({file: $file; URL: $URL})
    
    //t5xxl encoder
    $file:=$modelsFolder.file("t5xxl-Q2_K.gguf")
    $URL:="https://huggingface.co/second-state/FLUX.1-schnell-GGUF/resolve/main/t5xxl-Q2_K.gguf"
    $models.push({file: $file; URL: $URL})
    
    $port:=8080
    $LlamaEdge:=cs.LlamaEdge.LlamaEdge.new($port; $models; \
    {model_name: "flux1-schnell"; \
    diffusion_model: $models[0].file; \
    vae: $models[1].file; \
    clip_l: $models[2].file; \
    t5xxl: $models[3].file}; \
    Formula(ALERT(This.options.models.extract("file.name").join(",")+($1.success ? " started!" : " did not start..."))))
End if 
```

Unless the server is already running (in which case the costructor does nothing), the following procedure runs in the background:

1. The specified model is downloaded via HTTP
2. The `mistralrs-server` program is started

Now you can test the server:

```
curl -X POST 'http://localhost:8080/v1/images/generations' \
  --header 'Content-Type: application/json' \
  --data '{
      "model": "flux1-schnell",
      "prompt": "A futuristic city skyline at sunset"
  }'
```

Or, use AI Kit:

```4d
    var $AIClient : cs.AIKit.OpenAI
    $AIClient:=cs.AIKit.OpenAI.new()
    $AIClient.baseURL:="http://127.0.0.1:8080/v1"
    
    var $text : Text
    $text:="A futuristic city skyline at sunset"
    
    var $parameters : cs.AIKit.OpenAIImageParameters
    $parameters:=cs.AIKit.OpenAIImageParameters.new()
    
    var $result : cs.AIKit.OpenAIImagesResult
    $result:=$AIClient.images.generate($text; $parameters)
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

Not all models ara compatible with Apple Silicon.

Here are a few models smaller than a couple of gigabytes:

|Version|Quantisation|Size|
|-|-:|-:|
|[stable-diffusion-v1-5-pruned-emaonly-Q8_0.gguf](https://huggingface.co/second-state/stable-diffusion-v1-5-GGUF/resolve/main/stable-diffusion-v1-5-pruned-emaonly-Q8_0.gguf)|`Q8_0`|`1.76 GB`|

Typical error:

* v2-1_768-nonema-pruned-Q8_0.gguf

```
/Users/ss/workspace/wasi-nn-ggml-plugin/actions-runner/_work/wasi-nn-ggml-plugin/wasi-nn-ggml-plugin/build/_deps/stable-diffusion-src/ggml/src/ggml-metal.m:2418: GGML_ASSERT(ne00 % 4 == 0) failed
```

* sd3-medium-Q4_1.gguf

```
/home/runner/.cargo/registry/src/index.crates.io-6f17d22bba15001f/llama-core-0.26.1/src/lib.rs:539: Fail to create the context. INVALID_ARGUMENT (error 1)
```
