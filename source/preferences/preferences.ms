/*
	
		Prefrences!
	
*/
--if classOf ::genToolsMain != RolloutClass do return 0

	rollout genToolsPreferencesRollout "GenTools Preferences" width:160 height:184
	(
		checkbox startupcheck "Load on Startup" pos:[16,8] width:136 height:16 checked:false
		button resetbtn "Reset GenTools" pos:[25,160] width:112 height:16 enabled:false
		radiobuttons dockedstateradio "Start Position-" pos:[16,32] width:89 height:62 labels:#("Floating", "Docked Left", "Docked Right")
		checkbox genmappingcheck "Generate Mapping" pos:[16,120] width:128 height:16 checked:true
		checkbox realworldcheck "Real World Scale" pos:[16,136] width:128 height:16 checked:true
		label lbl4 "Auto Gen Mapping on Modifiers" pos:[5,100] width:152 height:17
		on genToolsPreferencesRollout open do
		(
			/*
			startupcheck.checked = (getIniSetting preferencesIni "Startup" "startup" as booleanClass)
			dockedstateradio.state = (getIniSetting preferencesIni "Location and Position" "dockstate" as integer)
			genmappingcheck.state = (getIniSetting preferencesIni "Mod Info" "genmapping") as booleanClass
			realworldcheck.state = (getIniSetting preferencesIni "Mod Info" "realworldmapping") as booleanClass
			*/
		)
		on startupcheck changed state do
		(
			startupFolder = (GetDir #userStartupScripts) + "/GenTools/" -- startup folder
			startupFile = startupFolder + "GenToolsLoadOnStart.ms" -- startup file
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
				tempFileString = sourceFolder + "startup/GenToolsLoadOnStart.ms" -- external startup script
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
		on genmappingcheck changed state do
		(
			setIniSetting preferencesIni "Mod Info" "genmapping" (state as string)
			realworldcheck.enabled = state
		)
		on realworldcheck changed state do
		(
			setIniSetting preferencesIni "Mod Info" "realworldmapping" (state as string)
		)
	)
	
	
rollout suborder "Rollout Order" width:160 height:232
(
	listBox moduleslist "" pos:[10,11] width:142 height:13 items:modules
	button upbtn "up" pos:[40,197] width:32 height:22
	button downbtn "down" pos:[80,197] width:32 height:22
	on suborder close do
	(
		for i = 1 to modules.count do
		(
			setIniSetting rolloutIni modules[i] "order"  (i as string)
		)
	)
	on upbtn pressed  do
	(
		if moduleslist.selection > 1 do
		(
			print "up"
			storedMod = modules[moduleslist.selection-1]
			modules[moduleslist.selection-1] = modules[moduleslist.selection]
			modules[moduleslist.selection] = storedMod
			moduleslist.items = modules
			moduleslist.selection -= 1
		)
	)
	on downbtn pressed  do
	(
		if moduleslist.selection < modules.count do
		(
			print "down"
			storedMod = modules[moduleslist.selection+1]
			modules[moduleslist.selection+1] = modules[moduleslist.selection]
			modules[moduleslist.selection] = storedMod
			moduleslist.items = modules
			moduleslist.selection += 1
		)
	)
)
	
rollout mainPrefrences "Prefrences" width:184 height:404
(
	subRollout roSubA "" pos:[0,0] width:184 height:400
	
	on mainPrefrences open  do
	(
		AddSubRollout mainPrefrences.roSubA suborder
		AddSubRollout mainPrefrences.roSubA genToolsPreferencesRollout
	)
)
createDialog mainPrefrences