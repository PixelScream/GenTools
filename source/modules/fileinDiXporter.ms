rollout fileinDiXporter "Open DiXporter" width:162 height:300
(
	button btn13 "DiXporter" pos:[24,8] width:120 height:16
	button btn15 "eXperimental" pos:[25,32] width:120 height:16
	on btn13 pressed do
	(
		filein @"Y:\Resources\2014\GenTools\DiXporter\DiXporter.ms"
	)
	on btn15 pressed do
	(
		filein @"Y:\Resources\2014\GenTools\DiXporter\DiXporter_Experimental.ms"
	)
	/*
	on fileinDiXporter rolledUp bState do
	(
		print "yo"
		format "% \n setting rolled up % \n" preferencesIni bState
		setIniSetting preferencesIni "fileinDiXporter" "rolledUp" (bState as string)
	)
*/
)