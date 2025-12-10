var $LlamaEdge : cs:C1710.LlamaEdge

If (True:C214)
	$LlamaEdge:=cs:C1710.LlamaEdge.new()  //default
Else 
	var $modelsFolder : 4D:C1709.Folder
	$modelsFolder:=Folder:C1567(fk home folder:K87:24).folder(".LlamaEdge")
	var $file : 4D:C1709.File
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
	$LlamaEdge:=cs:C1710.LlamaEdge.new($port; $models; \
		{model_name: "flux1-schnell"; \
		home: Folder:C1567(fk home folder:K87:24); \
		diffusion_model: "./.LlamaEdge/flux1-schnell/"+$models[0].fullName; \
		vae: "./.LlamaEdge/flux1-schnell/"+$models[1].fullName; \
		clip_l: "./.LlamaEdge/flux1-schnell/"+$models[2].fullName; \
		t5xxl: "./.LlamaEdge/flux1-schnell/"+$models[3].fullName}; \
		Formula:C1597(ALERT:C41(This:C1470.options.models.extract("file.name").join(",")+($1.success ? " started!" : " did not start..."))))
End if 