/*
	Welcome to GenTools
*/

-- First need to check if an instance of the rollout's already open, unregister it and destroy it to avoid duplicates
try( 	cui.UnRegisterDialogbar genToolsMain) catch()
if classOf ::genToolsMain == RolloutClass do DestroyDialog ::genToolsMain

/*
		Variables
*/
sourceFolder = trimRight (getFileNamePath (getThisScriptFilename())) "\\"
rootFolder = (getDir #userScripts) + "/GenTools"
preferencesIni = rootFolder + "/GenToolsPreferences.ini" 
	
if doesFileExist rootFolder == false do
(
	makeDir rootFolder
)
if doesFileExist preferencesIni == false do
(
	defaultProfile = sourceFolder + "/Sections/Preferences/DefaultPreferences.ini"
	copyFile defaultProfile preferencesIni
	format "Copied % to % \n" defaultProfile preferencesIni
)

menuHeight = (getIniSetting preferencesIni "Location and Position" "height") as integer
menuWidth = (getIniSetting preferencesIni "Location and Position" "width") as integer
subMenuBuffer = 89
bottomBtnHeight = 26
	
/*
		Prefrences
*/
rollout genToolsPreferencesRollout "GenTools Preferences" width:160 height:152
(
	checkbox startupcheck "Load on Startup" pos:[16,8] width:136 height:16 checked:false
	button resetbtn "Reset GenTools" pos:[24,128] width:112 height:16
	radioButtons dockedstateradio "Start -" pos:[16,32] width:89 height:62 labels:#("Floating", "Docked Left", "Docked Right")
	on genToolsPreferencesRollout open do
	(
		startupcheck.checked = (getIniSetting preferencesIni "Startup" "startup" as booleanClass)
		dockedstateradio.state = (getIniSetting preferencesIni "Location and Position" "dockstate" as integer)
	)
	on startupcheck changed state do
	(
		startupFolder = (GetDir #userStartupScripts) + "/GenTools" -- startup folder
		startupFile = startupFolder + "/GenToolsLoadOnStart.ms" -- startup file
		setIniSetting preferencesIni "Startup" "startup" (startupcheck.checked as string)
		if startupcheck.checked == true do -- if startup on, checks if file exists and creates it
		(
			if doesFileExist startupFolder == false do -- checks to see if the startup folder is there
			(
				makeDir startupFolder
			)
			if doesFileExist startupFile == true do
			(
				deleteFile startupFile
			)
			tempFileString = sourceFolder + "/Sections/Startup/GenToolsLoadOnStart.ms" -- external startup script
			copyFile tempFileString startupFile
			format "% copied to % \n" tempFileString startupFile
		)
		
		if startupcheck.checked == false do -- if start up is off, checks for startup script and deletes it
		(
			if doesFileExist startupFile == true do
			(
				deleteFile startupFile
				format "% deleted \n" startupFile
			)
		)
	)
	on resetbtn pressed do
	(
		if queryBox "Are you sure you want to completely delete all your prefrences for GenTools?" beep:false do
		(
			try(cui.UnRegisterDialogbar genToolsMain) catch()
			if classOf ::genToolsMain == RolloutClass do DestroyDialog ::genToolsMain
			deleteFile preferencesIni
			try( destroyDialog genToolsPreferencesRollout)catch()
		)
	)
	on dockedstateradio changed stat do
	(
		setIniSetting preferencesIni "Location and Position" "dockstate" (stat as string)
	)
)

 /*

		Main Menu Section!

*/
rollout genToolsMain "GenTools" width:184 height:760
(
	--- Main UI
	ImgTag mainLogo "" pos:[0,0] bitmap:(BitMap 184 25)
	checkbutton chbShowA "Tools" pos:[32,32] width:53 height:21 checked:true across:2
	checkbutton chbShowB "Export" pos:[88,32] width:53 height:21 checked:false
	subRollout roSubA "" pos:[0,56] width:184 height:672
	subRollout roSubB "" pos:[0,56] width:184 height:672 visible:false
	button dockbtn "<" pos:[56,736] width:32 height:19
	button undockbtn ">" pos:[88,736] width:32 height:19
	button prefsbtn "Preferences" pos:[160,32] width:22 height:20 images:#("Pref_Icons.bmp", "undefined", 2, 1, 2, 1, 1)
	--- Functions
	fn repositionUI =
	(
		setIniSetting preferencesIni "Location and Position" "height" (menuHeight as string)
		roSubA.height = menuHeight - subMenuBuffer
		roSubB.height = menuHeight - subMenuBuffer
		dockbtn.pos.y = menuHeight - bottomBtnHeight
		undockbtn.pos.y = menuHeight - bottomBtnHeight
	)
	on genToolsMain open do
	(		
		setIniSetting preferencesIni "File Info" "source path" sourceFolder 
		mainLogo.bitmap = (openBitmap (sourceFolder + "/GenToolsLogo.bmp"))
		repositionUI()
	)
	on genToolsMain close do
	(
		try(destroyDialog genToolsPreferencesRollout)catch() 
	)
	on genToolsMain resized size do
	(
		menuHeight = size.y
		repositionUI()
	)
	on genToolsMain moved pos do
	(
		setIniSetting preferencesIni "Location and Position" "x" (pos.x as string)
		setIniSetting preferencesIni "Location and Position" "y" (pos.y as string)
	)
	on chbShowA changed state do
	(
		chbShowB.state = not state
		genToolsMain.roSubA.visible = state
		genToolsMain.roSubB.visible = not state
	)
	on chbShowB changed state do
	(
		chbShowA.state = not state
		genToolsMain.roSubA.visible = not state
		genToolsMain.roSubB.visible = state
	)
	on dockbtn pressed do
	(

	)
	on undockbtn pressed do
	(

	)
	on prefsbtn pressed do
	(
		try(destroyDialog genToolsPreferencesRollout)catch() 
		createDialog genToolsPreferencesRollout
	)
)

getMenuWidth = (getIniSetting preferencesIni "Location and Position" "x") as integer
getMenuHeight = (getIniSetting preferencesIni "Location and Position" "y") as integer
createDialog genToolsMain menuWidth menuHeight getMenuWidth getMenuHeight style:#(#style_toolwindow, #style_sysmenu, #style_minimizebox)
cui.RegisterDialogBar genToolsMain style:#(#cui_dock_vert, #cui_floatable, #cui_handels) minSize:[menuWidth, 350] maxSize:[menuWidth,1600]
if getIniSetting preferencesIni "Location and Position" "dockstate" as integer != 1 do
(
	if getIniSetting preferencesIni "Location and Position" "dockstate" as integer == 2 do
	(
		dockto = "#cui_dock_left"
	)
	if getIniSetting preferencesIni "Location and Position" "dockstate" as integer == 3 do
	(
		dockto = "#cui_dock_right"
	)
	cui.DockDialogBar genToolsMain (execute (dockto))
)
