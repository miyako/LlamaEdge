//%attributes = {"invisible":true}
var $LlamaEdge : cs:C1710.LlamaEdge

If (False:C215)
	$LlamaEdge:=cs:C1710.LlamaEdge.new()  //default
Else 
	var $modelsFolder : 4D:C1709.Folder
	$modelsFolder:=Folder:C1567(fk home folder:K87:24).folder(".LlamaEdge")
	var $URL : Text
	var $file : 4D:C1709.File
	$URL:="https://huggingface.co/second-state/stable-diffusion-2-1-GGUF/resolve/main/v2-1_768-nonema-pruned-Q8_0.gguf"
	$file:=$modelsFolder.file("v2-1_768-nonema-pruned-Q8_0.gguf")
	$port:=8080
	$LlamaEdge:=cs:C1710.LlamaEdge.new($port; $file; $URL; {model_name: "sd-v2.1"}; Formula:C1597(ALERT:C41(This:C1470.file.name+($1.success ? " started!" : " did not start..."))))
End if 