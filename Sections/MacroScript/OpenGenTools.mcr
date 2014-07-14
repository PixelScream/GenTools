--preferencesIni = (getDir #userScripts) + "/GenTools/GenToolsPreferences.ini" 
--genTools = (getIniSetting preferencesIni "File Info" "source path") + "/GenTools.ms"

macroScript openGenTools
category:"GenTools"
tooltip:"Open up the GenTools Pannel"
buttonText:"GenTools"
(
	local preferencesIni = (getDir #userScripts) + "/GenTools/GenToolsPreferences.ini" 
	if prefrencesIni != undefined then
	(
		local genTools = (getIniSetting preferencesIni "File Info" "source path") + "/GenTools.ms"
		fileIn genTools
	)
	else
	(
		try( filein "Z:\Users\Dickie\GenTools/GenTools.ms")catch(messageBox "Can't find GenTools! go find Dickie *sadface*")
	)
)