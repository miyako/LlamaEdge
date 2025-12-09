Class extends _LlamaEdge

Class constructor($controller : 4D:C1709.Class)
	
	Super:C1705($controller)
	
Function start($option : Object) : 4D:C1709.SystemWorker
	
	If (Not:C34(Is macOS:C1572)) || (Get system info:C1571.processor#"@Apple@")
		return 
	End if 
	
	var $command : Text
	$command:=This:C1470.escape(This:C1470.executablePath)
	
	$command+=" --dir .:. sd-api-server.wasm "
	
	var $arg : Object
	var $valueType : Integer
	var $key : Text
	
	Case of 
		: (Value type:C1509($option.model)=Is object:K8:27)\
			 && ((OB Instance of:C1731($option.model; 4D:C1709.File)) || (OB Instance of:C1731($option.model; 4D:C1709.Folder)))\
			 && ($option.model.exists)
			
			If (Value type:C1509($option.model_name)=Is text:K8:3) && ($option.model_name="@sd3@")
				$command+=" --diffusion-model "
			Else 
				$command+=" --model "
			End if 
			$command+=This:C1470.escape(This:C1470.expand($option.model).path)
			$command+=" "
	End case 
	
	For each ($arg; OB Entries:C1720($option))
		Case of 
			: (["model"; "help"].includes($arg.key))
				continue
		End case 
		$valueType:=Value type:C1509($arg.value)
		$key:=Replace string:C233($arg.key; "_"; "-"; *)
		Case of 
			: ($valueType=Is real:K8:4)
				$command+=(" --"+$key+" "+String:C10($arg.value)+" ")
			: ($valueType=Is text:K8:3)
				$command+=(" --"+$key+" "+This:C1470.escape($arg.value)+" ")
			: ($valueType=Is boolean:K8:9) && ($arg.value)
				$command+=(" --"+$key+" ")
			: ($valueType=Is object:K8:27) && ((OB Instance of:C1731($arg.value; 4D:C1709.File)) || (OB Instance of:C1731($arg.value; 4D:C1709.Folder)))
				$command+=(" --"+$key+" "+This:C1470.escape(This:C1470.expand($option.model).path))
			Else 
				//
		End case 
	End for each 
	
	var $models : Collection
	$models:=[]
	
	If ($option.models#Null:C1517)
		var $model : cs:C1710._model
		For each ($model; $option.models)
			If (OB Instance of:C1731($model.file; 4D:C1709.File))
				If (Value type:C1509($model.file)=Is object:K8:27) && (OB Instance of:C1731($model.file; 4D:C1709.File)) && ($model.file.exists)
					$models.push(This:C1470.escape(This:C1470.expand($model.file).path))
				End if 
			End if 
		End for each 
	End if 
	
/*
wasmedge --dir .:. sd-api-server.wasm \
--model-name flux1-schnell \
--diffusion-model flux1-schnell-Q4_0.gguf \
--vae ae-f16.gguf \
--clip-l clip_l-Q8_0.gguf \
--t5xxl t5xxl-Q2_K.gguf
*/
	
/*
wasmedge --dir .:. sd-api-server.wasm --model-name sd3 --model ./models/sd3-medium-Q4_1.gguf
*/
	
	//This.controller.currentDirectory:=This.escape(This.expand($option.model).parent.path)
	
	SET TEXT TO PASTEBOARD:C523($command)
	
	return This:C1470.controller.execute($command; $isStream ? $option.model : Null:C1517; $option.data).worker
	