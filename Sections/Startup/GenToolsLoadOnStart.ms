-- Load Gen Tools On Start
preferencesIni = (getDir #userScripts) + "/GenTools/GenToolsPreferences.ini" 

genTools = (getIniSetting preferencesIni "File Info" "source path") + "/GenTools.ms"
fileIn genTools