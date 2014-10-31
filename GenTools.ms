/*
	Welcome to GenTools!
*/

-- Check for existing instance and destroy it
try( 	cui.UnRegisterDialogbar genToolsMain) catch()
if classOf ::genToolsMain == RolloutClass do DestroyDialog ::genToolsMain

/*

		Variables!
		
*/
	defaultErrorMessage = "Nothing Selected"
	rootFolder = (getDir #userScripts) + "\\GenTools"
	preferencesIni = rootFolder + "\\GenToolsPreferences.ini" 
	rolloutIni = rootFolder + "\\RolloutPreferences.ini"
		
	scriptFolder = getFileNamePath (getThisScriptFilename())
	sourceFolder = scriptFolder + "source\\"
	modulesFolder = "modules\\"
		
	if doesFileExist rootFolder == false do
	(
		makeDir rootFolder
	)
	if doesFileExist preferencesIni == false do
	(
		defaultProfile = sourceFolder + "source\\preferences\\DefaultPreferences.ini"
		copyFile defaultProfile preferencesIni
		format "Copied % to % \n" defaultProfile preferencesIni
	)
	modules = #()
	modulesDir = #()
/*

		General Menu Settings
	
*/
	menuHeight = (getIniSetting preferencesIni "Location and Position" "height") as integer
	menuWidth = 190
	getMenuWidth = (getIniSetting preferencesIni "Location and Position" "x") as integer
	getMenuHeight = (getIniSetting preferencesIni "Location and Position" "y") as integer
	subMenuBuffer = 89
	bottomBtnHeight = 26





 /*
		Main Menu Section!
*/
(
	rollout genToolsMain "GenTools" width:184 height:760
	(
		--- Main UI
		ImgTag mainLogo "" pos:[0,0] bitmap:(BitMap 184 25)
		checkbutton chbShowA "Tools" pos:[32,32] width:53 height:21 checked:true across:2
		checkbutton chbShowB "Export" pos:[88,32] width:53 height:21 checked:false
		subRollout roSubA "" pos:[0,56] width:184 height:672
		subRollout roSubB "" pos:[0,56] width:184 height:672 visible:false
		button dockbtn "<" pos:[40,736] width:32 height:19
		button undockbtn "x" pos:[72,736]  width:32 height:19
		button dockrightbtn ">" pos:[104,736] width:32 height:19
		button prefsbtn "Preferences" pos:[160,32] width:22 height:20 images:#("Pref_Icons.bmp", "undefined", 2, 1, 2, 1, 1)
		--- Functions
		fn repositionUI =
		(
			setIniSetting preferencesIni "Location and Position" "height" (menuHeight as string)
			roSubA.height = menuHeight - subMenuBuffer
			roSubB.height = menuHeight - subMenuBuffer
			dockbtn.pos.y = menuHeight - bottomBtnHeight
			undockbtn.pos.y = menuHeight - bottomBtnHeight
			dockrightbtn.pos.y = menuHeight - bottomBtnHeight
		)
		on genToolsMain open do
		(		
			setIniSetting preferencesIni "File Info" "source path" sourceFolder 
			mainLogo.bitmap = (openBitmap (sourceFolder + "/GenToolsLogo.bmp"))
			repositionUI()
			-- Add all the sub rollouts
			--AddSubRollout genToolsMain.roSubA mainTools
			modulesDir = getFiles (sourceFolder + modulesFolder + "*.ms")
			for i = 1 to modulesDir.count do
			(
				
			)
			for i in modulesDir do
			(
				fileIn i
				rolloutName = getFilenameFile i
				append modules (rolloutName as string)
				print rolloutName
				
				try(a = (execute rolloutName).cat)catch()
				if a == "GT_Export" then
				(
					AddSubRollout genToolsMain.roSubB (execute rolloutName)
				)
				else
				(
					AddSubRollout genToolsMain.roSubA (execute rolloutName)
				)
				
				--AddSubRollout genToolsMain.roSubA (execute rolloutName)
				rolled = getIniSetting rolloutIni rolloutName "rolledUp" 
				if rolled != "" then
				(
					(execute rolloutName).open = rolled as booleanClass
				)
				else
				(
					(execute rolloutName).open = true
				)
			)
			format "modules : %" modules
		)
		on genToolsMain close do
		(
			for i in modules do
			(
				setIniSetting rolloutIni i "rolledUp" ((execute i).open as string)
			)
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
			cui.DockDialogBar genToolsMain #cui_dock_left
		)
		on undockbtn pressed do
		(
			cui.FloatDialogBar genToolsMain
		)
		on dockrightbtn pressed do
		(
			cui.DockDialogBar genToolsMain #cui_dock_right
		)
		on prefsbtn pressed do
		(
			try(destroyDialog mainPrefrences)catch() 
			--createDialog mainPrefrences
			filein (sourceFolder + "preferences\\preferences.ms")
		)
	)
)

/*
		Generate the Dialog!
*/

	createDialog genToolsMain menuWidth  style:#(#style_toolwindow, #style_sysmenu, #style_minimizebox)
	cui.RegisterDialogBar genToolsMain style:#(#cui_dock_vert, #cui_floatable, #cui_handels) minSize:[menuWidth, 350] maxSize:[menuWidth,1600]
	/*
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