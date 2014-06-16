macroScript openGenTools
category:"GenTools"
tooltip:"Open up the GenTools Pannel"
buttonText:"GenTools"
(
	preferencesIni = (getDir #userScripts) + "/GenTools/GenToolsPreferences.ini" 
	genTools = (getIniSetting preferencesIni "File Info" "source path") + "/GenTools.ms"
	
	fileIn genTools
)