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
    $LlamaEdge:=cs.LlamaEdge.LlamaEdge.new()  //default
Else 
    var $modelsFolder : 4D.Folder
    $modelsFolder:=Folder(fk home folder).folder(".LlamaEdge")
    var $file : 4D.File
    var $URL : Text
    var $models : Collection
    $models:=[]
    
    //Main model
    $file:=$modelsFolder.file("flux1-schnell/flux1-schnell-Q4_0.gguf")
    $URL:="https://huggingface.co/second-state/FLUX.1-schnell-GGUF/resolve/main/flux1-schnell-Q4_0.gguf"
    $models.push({file: $file; URL: $URL})
    
    //VAE file
    $file:=$modelsFolder.file("flux1-schnell/ae-f16.gguf")
    $URL:="https://huggingface.co/second-state/FLUX.1-schnell-GGUF/resolve/main/ae-f16.gguf"
    $models.push({file: $file; URL: $URL})
    
    //clip_l encoder
    $file:=$modelsFolder.file("flux1-schnell/clip_l-Q8_0.gguf")
    $URL:="https://huggingface.co/second-state/FLUX.1-schnell-GGUF/resolve/main/clip_l-Q8_0.gguf"
    $models.push({file: $file; URL: $URL})
    
    //t5xxl encoder
    $file:=$modelsFolder.file("flux1-schnell/t5xxl-Q2_K.gguf")
    $URL:="https://huggingface.co/second-state/FLUX.1-schnell-GGUF/resolve/main/t5xxl-Q2_K.gguf"
    $models.push({file: $file; URL: $URL})
    
    /*
        model paths are relative to $home which is mapped to . in wasm
    */
    
    $port:=8080
    $LlamaEdge:=cs.LlamaEdge.LlamaEdge.new($port; $models; \
    {model_name: "flux1-schnell"; \
    home: Folder(fk home folder); \
    diffusion_model: "./.LlamaEdge/flux1-schnell/"+$models[0].file.fullName; \
    vae: "./.LlamaEdge/flux1-schnell/"+$models[1].file.fullName; \
    clip_l: "./.LlamaEdge/flux1-schnell/"+$models[2].file.fullName; \
    t5xxl: "./.LlamaEdge/flux1-schnell/"+$models[3].file.fullName}; \
    Formula(ALERT(This.options.models.extract("file.name").join(",")+($1.success ? " started!" : " did not start..."))))
End if  
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

#### Image Generation Models

You can find quantised stable diffusion models on [Hugging Face](https://huggingface.co/second-state). Not all models ara compatible with Apple Silicon.
