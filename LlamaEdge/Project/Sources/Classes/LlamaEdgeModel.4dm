property prompt_template : Text
property ctx_size : Integer
property path : Text
property model_name : Text
property model_alias : Text

Class extends _model

Class constructor($file : 4D:C1709.File; \
$URL : Text; \
$path : Text; \
$prompt_template : Text; \
$ctx_size : Integer; \
$model_name : Text; \
$model_alias : Text)
	
	Super:C1705($file; $URL)
	
	This:C1470.path:=$path
	This:C1470.prompt_template:=$prompt_template
	This:C1470.ctx_size:=$ctx_size
	This:C1470.model_name:=$model_name
	This:C1470.model_alias:=$model_alias
	