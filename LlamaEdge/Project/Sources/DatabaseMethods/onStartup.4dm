var $LlamaEdge : cs:C1710.LlamaEdge

If (False:C215)
	$LlamaEdge:=cs:C1710.LlamaEdge.new()  //default
Else 
	var $modelsFolder : 4D:C1709.Folder
	$modelsFolder:=Folder:C1567(fk home folder:K87:24).folder(".LlamaEdge")
	var $file : 4D:C1709.File
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
	$LlamaEdge:=cs:C1710.LlamaEdge.new($port; $models; \
		{model_name: "flux1-schnell"; \
		diffusion_model: $models[0].file; \
		vae: $models[1].file; \
		clip_l: $models[2].file; \
		t5xxl: $models[3].file}; \
		Formula:C1597(ALERT:C41(This:C1470.options.models.exract("name").join(",")+($1.success ? " started!" : " did not start..."))))
End if 