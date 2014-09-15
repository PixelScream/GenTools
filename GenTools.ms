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
		defaultProfile = sourceFolder + "/source/preferences/DefaultPreferences.ini"
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
	
		Prefrences!
	
*/
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
/*
		Functions!
*/

		function MovePivotDirection dir = 
	(
			if selection != undefined then (
				for i in selection do (
					if classof i == Editable_Poly then 
					(
						local newpos = [0,0,0]
						local oldpos = [0,0,0]
						sel = i
						oldpos = sel.pivot
						newpos  = oldpos 
						selverts = sel.numverts
						for v = 1 to sel.numverts do
						(
							p = polyop.getVert sel v
							if dir == "directiondown" do
							(
								if p.z <= newpos.z do
								(
									newpos = p
								)
							)
							
							if dir == "directionup" do
							(
								if p.z >= newpos.z do
								(
									newpos = p
								)
							)
							
							if dir == "directionright" do
							(
								if p.x >= newpos.x do
								(
									newpos = p
								)
							)
							
							if dir == "directionleft" do
							(
								if p.x <= newpos.x do
								(
									newpos = p
								)
							)
							if dir == "directionforward" do
							(
								if p.y <= newpos.y do
								(
									newpos = p
								)
							)
							
							if dir == "directionback" do
							(
								if p.y >= newpos.y do
								(
									newpos = p
								)
							)
						)
					)
					if classof i == Editable_Mesh then 
					(
						local newpos = [0,0,0]
						local oldpos = [0,0,0]
						sel = i
						oldpos = sel.pivot
						newpos  = oldpos 
						selverts = sel.numverts
						for v = 1 to sel.numverts do
						(
							p = getVert sel v
							if dir == "directiondown" do
							(
								if p.z <= newpos.z do
								(
									newpos = p
								)
							)
							
							if dir == "directionup" do
							(
								if p.z >= newpos.z do
								(
									newpos = p
								)
							)
							
							if dir == "directionright" do
							(
								if p.x >= newpos.x do
								(
									newpos = p
								)
							)
							
							if dir == "directionleft" do
							(
								if p.x <= newpos.x do
								(
									newpos = p
								)
							)
							if dir == "directionforward" do
							(
								if p.y <= newpos.y do
								(
									newpos = p
								)
							)
							
							if dir == "directionback" do
							(
								if p.y >= newpos.y do
								(
									newpos = p
								)
							)
						)
					)
						-- determin which direction to shift the pivot
						if newpos != undefined then
						(
							if dir == "directionup" or dir == "directiondown" do
							(
								newz = [oldpos.x, oldpos.y, newpos.z]
							)
							if dir == "directionright" or dir == "directionleft" do
							(
								newz = [newpos.x, oldpos.y, oldpos.z]
							)
							if dir == "directionforward" or dir == "directionback" do
							(
								newz = [oldpos.x, newpos.y, oldpos.z]
							)
						)
						else
						(
							messageBox "Only works on Editable polys and Editbale meshes"
						)
						-- set the pivot
						if newz != undefined do
						(
							sel.pivot = newz
						)
					
				)
			)
			else 
			(
				messagebox "nothing selected"
			)
	)
	function AttatchToSpline curve=
	(
		-- Attaches to spline and spaces evenly along it
		local increment = (100 / (spheres.count - 1))
		local curpos = (increment * 0.5)
		
		for o in spheres do
		(
			o.pos.controller = Path_Constraint ()
			o.pos.controller.path = curve
			o.pos.controller.PERCENT = curpos
			o.pos.controller.follow = on
			curpos += increment
		)
		print "Attached to Spline yay" 
	)

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
				if rolled != undefined then
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
			createDialog mainPrefrences
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