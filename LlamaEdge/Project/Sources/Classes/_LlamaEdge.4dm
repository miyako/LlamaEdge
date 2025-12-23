property port : Integer
property onData : 4D:C1709.Function
property onDataError : 4D:C1709.Function
property onTerminate : 4D:C1709.Function

Class extends _CLI

Class constructor($class : 4D:C1709.Class)
	
	var $controller : 4D:C1709.Class
	var $superclass : 4D:C1709.Class
	$superclass:=$class.superclass
	$controller:=cs:C1710._LlamaEdge_Controller
	
	While ($superclass#Null:C1517)
		If ($superclass.name=$controller.name)
			$controller:=$class
			break
		End if 
		$superclass:=$superclass.superclass
	End while 
	
	Super:C1705("wasmedge"; $controller)
	
Function bind($option : Object; $properties : Collection) : cs:C1710._CLI
	
	var $property : Text
	For each ($property; $properties)
		This:C1470[$property]:=$option[$property]
	End for each 
	
	return This:C1470
	
Function get worker() : 4D:C1709.SystemWorker
	
	return This:C1470.controller.worker
	
Function terminate()
	
	This:C1470.controller.terminate()