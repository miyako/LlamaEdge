Class extends _LlamaEdge

Class constructor($controller : 4D:C1709.Class)
	
	Super:C1705($controller)
	
Function start($option : Object) : 4D:C1709.SystemWorker
	
	If (Not:C34(Is macOS:C1572)) || (Get system info:C1571.processor#"@Apple@")
		return 
	End if 
	
	var $command : Text
	$command:=This:C1470.escape(This:C1470.executablePath)
	
	var $home : 4D:C1709.Folder
	If (Value type:C1509($option.home)=Is object:K8:27)\
		 && (OB Instance of:C1731($option.home; 4D:C1709.Folder))\
		 && ($option.home.exists)
		$home:=$option.home
	Else 
		$home:=Folder:C1567(fk home folder:K87:24)
	End if 
	
	This:C1470.controller.currentDirectory:=$home
	
	//.:/Users/miyako
	
	$command+=" --dir .:"+This:C1470.escape(This:C1470.controller.currentDirectory.path)
	$command+=" "
	$command+=This:C1470.escape(This:C1470.executableFile.parent.file("sd-api-server.wasm").path)
	$command+=" "
	
	var $arg : Object
	var $valueType : Integer
	var $key : Text
	
	For each ($arg; OB Entries:C1720($option))
		Case of 
			: (["diffusion_model"; "vae"; "clip_l"; "t5xxl"].includes($arg.key))
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
						$command+=(" --"+$key+" "+This:C1470.escape(This:C1470.expand($arg.value).path))
					Else 
						//
				End case 
			Else 
				continue
		End case 
	End for each 
	
	For each ($arg; OB Entries:C1720($option))
		Case of 
			: (["home"; "diffusion_model"; "vae"; "clip_l"; "t5xxl"; "help"].includes($arg.key))
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
				$command+=(" --"+$key+" "+This:C1470.escape(This:C1470.expand($arg.value).path))
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
	
	return This:C1470.controller.execute($command; Null:C1517; $option.data).worker
	