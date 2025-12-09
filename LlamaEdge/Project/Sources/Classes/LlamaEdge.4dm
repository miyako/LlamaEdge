Class constructor($port : Integer; $models : Collection; $options : Object; $formula : 4D:C1709.Function)
	
	var $LlamaEdge : cs:C1710._worker
	$LlamaEdge:=cs:C1710._worker.new()
	
	If (Not:C34($LlamaEdge.isRunning($port)))
		
		If ($models=Null:C1517)
			$models:=[]
		End if 
		
		If ($models.length=0)
			var $modelsFolder : 4D:C1709.Folder
			$modelsFolder:=Folder:C1567(fk home folder:K87:24).folder(".LlamaEdge")
			var $file : 4D:C1709.File
			var $URL : Text
			$file:=$modelsFolder.file("stable-diffusion-v1-5-pruned-emaonly-Q8_0.gguf")
			$URL:="https://huggingface.co/second-state/stable-diffusion-v1-5-GGUF/resolve/main/stable-diffusion-v1-5-pruned-emaonly-Q8_0.gguf"
			$models.push({file: $file; URL: $URL})
		End if 
		
		If ($port=0) || ($port<0) || ($port>65535)
			$port:=8080
		End if 
		
		CALL WORKER:C1389(OB Class:C1730(This:C1470).name; This:C1470._Start; $port; $models; $options; $formula)
		
	End if 
	
Function _Start($port : Integer; $models : Collection; $options : Object; $formula : 4D:C1709.Function)
	
	var $model : cs:C1710.Model
	$model:=cs:C1710.Model.new($port; $models; $options; $formula)
	
Function terminate()
	
	var $LlamaEdge : cs:C1710._worker
	$LlamaEdge:=cs:C1710._worker.new()
	$LlamaEdge.terminate()