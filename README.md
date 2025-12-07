![version](https://img.shields.io/badge/version-20%2B-E23089)
![platform](https://img.shields.io/static/v1?label=platform&message=mac-arm&color=blue)
[![license](https://img.shields.io/github/license/miyako/LlamaEdge)](LICENSE)
![downloads](https://img.shields.io/github/downloads/miyako/LlamaEdge/total)

# LlamaEdge
Local inference engine

* [WasmEdge](https://wasmedge.org) supports [Windows](https://wasmedge.org/docs/contribute/source/os/windows/) but [LlamaEdge](https://llamaedge.com) or its [stable-diffusion plugin](https://wasmedge.org/docs/start/wasmedge/extensions/plugins/) is for macOS and Linux only.

* Intel Mac is presumably supported but seemingly inpossible to compile on Apple Silicon+Rosetta toolset.

# Stable Diffusion Models in GGUF format

| Version | Quantisation | Size |
|-|-:|-:|
| 1.4 | [Q4_0](https://huggingface.co/second-state/stable-diffusion-v-1-4-GGUF/resolve/main/stable-diffusion-v1-4-Q4_0.gguf) | `1.57 GB` |
| 1.5 | [Q4_0](https://huggingface.co/second-state/stable-diffusion-v1-5-GGUF/resolve/main/stable-diffusion-v1-5-pruned-emaonly-Q4_0.gguf)  | `1.57 GB` |
| 2.1 | [Q4_0](https://huggingface.co/second-state/stable-diffusion-2-1-GGUF/resolve/main/v2-1_768-nonema-pruned-Q4_0.gguf) | `1.7 GB` |
| 3.0 | [Q4_0](https://huggingface.co/second-state/stable-diffusion-3-medium-GGUF/resolve/main/sd3-medium-Q4_0.gguf) | `4.55 GB`  |

# Client 

```
curl -X POST 'http://localhost:8080/v1/images/generations' \
  --header 'Content-Type: application/json' \
  --data '{
      "model": "sd-v1.4",
      "prompt": "A cute baby sea otter"
  }'
```

```
install_name_tool -add_rpath "@executable_path/../plugin" wasmedge
install_name_tool -add_rpath "@loader_path/../plugin" 
install_name_tool -change @rpath/libwasmedge.0.dylib @loader_path/../lib/libwasmedge.0.dylib 
install_name_tool -change @rpath/libwasmedgePluginWasmEdgeStableDiffusion.dylib 
install_name_tool -change /opt/homebrew/opt/llvm@18/lib/libLLVM.dylib @loader_path/libLLVM.dylib 
```
