//%attributes = {}
#DECLARE($status : Object; $options : Object)

If ($status.success)
	
Else 
	
	var $error : cs:C1710.event.error
	$error:=cs:C1710.event.error.new(2; "failed to load model!"; This:C1470.models())
	
	//This is the _Model_ instance; its options do not carry the event
	This:C1470._notifyError($error)
	
End if 