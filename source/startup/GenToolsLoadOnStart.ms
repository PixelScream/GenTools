-- Load Gen Tools On Start
preferencesIni = (getDir #userScripts) + "/GenTools/GenToolsPreferences.ini" 

fn setIni =
(
	sourcePath = getSavePath "Can't find Genie Tools folder"
	print sourcePath
	
	if sourcePath != undefined and sourcePath != 0 then
	(
		setIniSetting preferenceIni "File Info" "source path" sourcePath
	)
	else
	(
		return false
	)
)



if doesFileExist preferencesIni != true do
(
	setIni()
)

genToolsSourceFolder = getIniSetting preferencesIni "File Info" "source path"


if genToolsSourceFolder[1] == "" or genToolsSourceFolder[1] == undefined do
(
	setIni()
	genToolsSourceFolder = getIniSetting preferencesIni "File Info" "source path"
)


genToolsSubStrings = filterString genToolsSourceFolder "\/"

genToolsFolder = subString genToolsSourceFolder 1 (genToolsSourceFolder.count - genToolsSubStrings[genToolsSubStrings.count].count - 1)

genTools = genToolsFolder + "GenTools.ms"


if doesFileExist genTools != true then
(
	messageBox "Genie tools script doesn't exist or can't find it!"
)
else
(
	fileIn genTools
)
