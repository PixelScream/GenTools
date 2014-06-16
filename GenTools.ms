/*
	Welcome to GenTools!
*/
-- First need to check if an instance of the rollout's already open, unregister it and destroy it to avoid duplicates
try( 	cui.UnRegisterDialogbar genToolsMain) catch()
if classOf ::genToolsMain == RolloutClass do DestroyDialog ::genToolsMain

/*
		Variables!
*/

	defaultErrorMessage = "Nothing Selected"
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

	getMenuWidth = (getIniSetting preferencesIni "Location and Position" "x") as integer
	getMenuHeight = (getIniSetting preferencesIni "Location and Position" "y") as integer
	
	-- Export Stuffs
	compartmentlistini = "Z:/Projects/V&T/MaxScript/DickTools/Source/compartmentlist.ini"
	compartmentlistarray = getIniSetting compartmentlistini
	selectedcompartment = ""

/*
		Prefrences!
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
		Functions!
*/

		function MovePivotDirection dir = 
	(
			local selection = $
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
	fn ExportThis layer directory =
	(
		if LayerManager.getLayerFromName(layer) != undefined then -- checks if the main layer is named correctly
		(
			exportTo = directory + "\\" + layer
			(LayerManager.getLayerFromName(layer)).nodes &nodes
			originals = nodes
			select nodes
				
			objs = selection
			if objs.count != 0 then
			(
				--createDialog progressBarRollout
				objArray = 
				(
					for i = 1 to objs.count collect
					(
						--progressBarRollout.progress.value = ((100 / objs.count) * i)
						copiedMesh = copy objs[i]
						convertToMesh = copiedMesh
					)
				)
				--convertToMesh ObjArray
				select ObjArray
				exportFile exportTo  selectedOnly:true #noPrompt
				delete ObjArray
				select originals
				--try(destroyDialog progressBarRollout)catch()
			)
			else
			(
				messagebox "a layer had no meshes in it"
			)
		)
		else
		(
			messageBox "couldn't find the layer"
		)
	)

/*
		Sub Rollouts!
*/
 -- Tools
	rollout mainTools "Tools" width:162 height:228
	(
		button boxmap "Box" pos:[16,144] width:56 height:24 toolTip:"Box map to real world scale"
		button collapseto "Collapse To" pos:[88,96] width:64 height:24 toolTip:"Runs 'Collapse to' for selection"
		button collapsepoly "CollapsePoly" pos:[16,96] width:64 height:24 toolTip:"Collapses to Editable poly"
		button deletetop "Delete Top" pos:[16,192] width:64 height:24 toolTip:"Deletes the top modifier off the stack"
		GroupBox uvgroup "UV Presets" pos:[8,128] width:153 height:48
		GroupBox polygroup "Poly" pos:[8,80] width:152 height:48
		GroupBox modifiergroup "Modifiers" pos:[8,176] width:152 height:48
		button cylindricalmap "Cylindrical" pos:[80,144] width:72 height:24 enabled:false toolTip:"Cylindrical map to real world scale"
		GroupBox miscgroup "Misc" pos:[8,0] width:152 height:80 ps:[8,712]
		button backfacebtn "BF Culling" pos:[16,16] width:64 height:24 toolTip:"Toggles back face culling on selection"
		button iterationbtn "Save Iteration" pos:[72,48] width:80 height:24 toolTip:"Saves out an iteration of your max file"

		button clearbtn "Clear Mat" pos:[88,192] width:64 height:24 toolTip:"Deletes the top modifier off the stack"
		button gantrybtn "Gantry" pos:[16,48] width:48 height:24 enabled:false toolTip:"Close Containers"
		button frozenbtn "Frozen Gray" pos:[88,16] width:64 height:24 toolTip:"makes all models not frozen in gray"
		on boxmap pressed do
		(
			for obj in selection do addModifier obj (uvwMap maptype:4 realWorldMapSize:on)
			)
		on collapseto pressed do
			maxOps.CollapseNodeTo $ 1 off
		on collapsepoly pressed do
			macros.run "Modifier Stack" "Convert_to_Poly"
		on deletetop pressed do
		(
			local selection = $
			if selection != undefined then 
			(
				for i in selection do 
				(
					if i.modifiers[1] != undefined do
					(
						deleteModifier i 1
					)
				)
			)
			else (
				messagebox defaultErrorMessage
			)
			
		)
		on cylindricalmap pressed do
		(
			for obj in selection do addModifier obj (uvwMap maptype:1 realWorldMapSize:on)
		)
		on backfacebtn pressed do
		(
				max backface cull toggle
			)
		on iterationbtn pressed do
		(
				max saveplus
			)
		on clearbtn pressed do
		(
			local selection = $
			if selection != undefined then 
			(
				for i in selection do 
				(
					i.material = undefined
				)
			)
			else (
				messagebox defaultErrorMessage
			)
			
		)
		on gantrybtn pressed do
		(
		for obj in selection do
		(
			modifierCount = obj.modifiers.count
			with redraw off
			(
			SelectUpFaces obj modifierCount
			)
		)
		)
		on frozenbtn pressed do
		(
			for o in objects do
			(
				o.showFrozeninGray = false
			)
			frozenAsGray = false
			print "Objects are nolonger frozen in gray"
		)
	)
	rollout pipesandboxesrollout "Pipes & Boxes" width:162 height:164
	(
		button editsmoothbtn "Edit + Smooth" pos:[16,48] width:72 height:24 toolTip:"Adds Edit Poly mod, Smooths all and selects all edges"
		button quadchambtn "Quad Cham" pos:[88,16] width:67 height:24 toolTip:"Adds a Quad Chamfer Modifier and sets it to smooth"
		button makeboxbtn "Make Box" pos:[16,16] width:64 height:24 toolTip:"Creates a 1m box at the world center"
		button smoothbtn "Smooth" pos:[96,48] width:56 height:24 toolTip:"Smooths all and selects all edges for an Editable Poly"
		button wireuv "Wire UV" pos:[16,128] width:64 height:24 toolTip:"UVXform for wires"
		button sweepuv "Sweep UV" pos:[88,96] width:64 height:24 toolTip:"Real world mapping coords for sweep"
		GroupBox boxgroup "Box Stuff" pos:[8,0] width:152 height:80
		button addsweep "Sweep" pos:[16,96] width:64 height:24 toolTip:"Adds a cylindrical sweep "
		GroupBox pipegroup "Pipe stuff" pos:[8,80] width:152 height:80

		button addknotbtn "Add Knot" pos:[88,128] width:64 height:24 toolTip:"Adds a knot to end of a spline, Warning! only works on single splines"
		on editsmoothbtn pressed do
		(
		local selection = $
		if selection != undefined then (
			for i in selection do (
					modPanel.addModToSelection (Edit_Poly ()) ui:on
					subobjectLevel = 4
					max select all
					$.modifiers[#Edit_Poly].SetOperation #SetSmooth
					$.modifiers[#Edit_Poly].smoothingGroupsToSet = 0
					$.modifiers[#Edit_Poly].smoothingGroupsToClear = -1
					$.modifiers[#Edit_Poly].smoothingGroupsToSet = 1
					subobjectLevel = 2
					$.modifiers[#Edit_Poly].smoothingGroupsToSet = 0
					$.modifiers[#Edit_Poly].smoothingGroupsToClear = 0
					max select all
					subobjectLevel = 0
			)
		)
			else (
					messagebox defaultErrorMessage
				)
			)
		on quadchambtn pressed do
		(
		local selection = $
		if selection != undefined then (
			for i in selection do (
				modPanel.addModToSelection (Quad_Chamfer ()) ui:on
					$.modifiers[#Quad_Chamfer].amount = 0.005
					$.modifiers[#Quad_Chamfer].shading_type = 2
			)
		)
			else (
					messagebox defaultErrorMessage
				)
			)
		on makeboxbtn pressed do
			Box lengthsegs:1 widthsegs:1 heightsegs:1 length:1 width:1 height:1 mapcoords:on realWorldMapSize:on pos:[0,0,0] isSelected:on
		on smoothbtn pressed do
		(
		for obj in selection where classOf obj == Editable_poly do 
		(
		subobjectLevel = 4
		max select all
		polyOp.setFaceSmoothGroup $ #all 1
		subobjectLevel = 2
		max select all
		)
			)
		on wireuv pressed do
		(
		local meshes = $
		if meshes != undefined then (
			for i in meshes do (
				modPanel.addModToSelection (UVW_Xform ()) ui:on
					$.modifiers[#UVW_Xform].U_Tile = 4
					$.modifiers[#UVW_Xform].V_Tile = 4
					$.modifiers[#UVW_Xform].Rotation_Angle = 90
			)
		)
			else (
					messagebox defaultErrorMessage
				)
			)
		on sweepuv pressed do
		(
		local meshes = $
		if meshes != undefined then (
			for i in meshes do (
				try
				(
					i.modifiers[#Sweep].GenerateMappingCoords = on
					i.modifiers[#Sweep].realWorldMapSize = on
				)catch()
			)
		)
			else (
					messagebox defaultErrorMessage
				)
		)
		on addsweep pressed do
		(
				addModifier $(sweep())
					$.modifiers[#Sweep].CurrentBuiltInShape = 4
			)
		on addknotbtn pressed do
		(
			spl = selection[1]
			if spl != undefined then (
				oldknotpos = (getKnotPoint spl 1( getKnotSelection spl 1) [1])
				newknotpos = [oldknotpos.x, oldknotpos.y, oldknotpos.z + 0.1]
				addKnot spl 1 #corner #line newknotpos
				updateShape spl
				spl
			)
			else (
				messagebox defaultErrorMessage
			)
		)
	)
	rollout PShiftRollout "pShift" width:162 height:196
	(
		local direction = "directiondown"
		global storedpivot 
		button downbtn "down" pos:[64,96] width:40 height:32
		button upbtn "up" pos:[64,16] width:40 height:32
		button centerbtn "Cen" pos:[64,56] width:40 height:32
		button rightbtn "right" pos:[112,56] width:40 height:32
		button leftbtn "Left" pos:[16,56] width:40 height:32
		button forwardbtn "Fwd" pos:[112,16] width:40 height:32
		button backbtn "back" pos:[16,16] width:40 height:32
		button pastebtn "paste" pos:[112,96] width:40 height:32 toolTip:"pastes the pivot location from the store"
		button copybtn "copy" pos:[16,96] width:40 height:32 toolTip:"Stores the pivot of the selected object"
		button scalebtn "Scale" pos:[16,152] width:40 height:32
		GroupBox grp23 "Reset" pos:[8,136] width:152 height:56
		button xformbtn "Xform" pos:[64,152] width:40 height:32
		button zerobtn "000" pos:[112,152] width:40 height:32 toolTip:"Moves pivot to 0, 0, 0"
		GroupBox grp45 "Pivot" pos:[8,0] width:152 height:136
		on downbtn pressed do
		(
			direction = "directiondown"
			MovePivotDirection(direction)
		)
		on upbtn pressed do
		(
			 direction = "directionup"
			MovePivotDirection(direction)
		)
		on centerbtn pressed do
		(
		local selection = $
		if selection != undefined then (
			for i in selection do (
				CenterPivot $
			)
		)
			else (
					messagebox "nothing Selected"
				)
		)
		on rightbtn pressed do
		(
			 direction = "directionright"
			MovePivotDirection(direction)
		)
		on leftbtn pressed do
		(
			 direction = "directionleft"
			MovePivotDirection(direction)
		)
		on forwardbtn pressed do
		(
			 direction = "directionforward"
			MovePivotDirection(direction)
		)
		on backbtn pressed do
		(
			 direction = "directionback"
			MovePivotDirection(direction)
		)
		on pastebtn pressed do
		( -- selection.pivot = storedpivot
			local selection = $
			if selection != undefined then 
			(
				for i in selection do 
				(
					if storedpivot != undefined then
					(
						selection.pivot = storedpivot
					)
					else
					(
						messagebox "no stored pivot"
					)
				)
			)
			else (
				messagebox "nothing Selected"
			)
		)
		on copybtn pressed do
		(
			local selection = $
			if selection != undefined then 
			(
				for i in selection do 
				(
					storedpivot = selection.pivot
				)
			)
			else (
				messagebox "nothing Selected"
			)
		)
		on scalebtn pressed do
		(
			local selection = $
			if selection != undefined then 
			(
				for i in selection do 
				(
					ResetScale selection 
				)
			)
			else (
				messagebox "nothing Selected"
			)
		)
		on xformbtn pressed do
		(
			local selection = $
			if selection != undefined then 
			(
				for i in selection do 
				(
					ResetXForm selection
				)
			)
			else (
				messagebox "nothing Selected"
			)
		)
		on zerobtn pressed do
		(
			local selection = $
			if selection != undefined then 
			(
				for i in selection do 
				(
					selection.pivot = [0,0,0]
				)
			)
			else (
				messagebox "nothing Selected"
			)
		)
	)
	rollout snapRotationDialog "Snap Rotations" width:176 height:296
	(
		local nintydegrees = 90
		local snappedangle = eulerangles 0 0 0
		GroupBox grp1 "X" pos:[4,0] width:164 height:48
		button rotatexpos "+" pos:[8,16] width:72 height:24
		button rotatexneg "-" pos:[88,16] width:72 height:24
		
		GroupBox grp2 "Y" pos:[4,48] width:164 height:48
		button rotateypos "+" pos:[8,64] width:72 height:24
		button rotateyneg "-" pos:[88,64] width:72 height:24
		GroupBox grp3 "Z" pos:[4,96] width:164 height:48
		button rotatezpos "+" pos:[8,112] width:72 height:24
		button rotatezneg "-" pos:[88,112] width:72 height:24
		on rotatexpos pressed do
		(
			snappedangle = eulerangles nintydegrees 0 0
			SnapRotateFN(snappedangle)
		)
		on rotatexneg pressed do
		(
			snappedangle = eulerangles -(nintydegrees) 0 0
			SnapRotateFN(snappedangle)
		)
		on rotateypos pressed do
		(
			snappedangle = eulerangles 0 nintydegrees 0
			SnapRotateFN(snappedangle)
		)
		on rotateyneg pressed do
		(
			snappedangle = eulerangles 0 -(nintydegrees) 0
			SnapRotateFN(snappedangle)
		)
		on rotatezpos pressed do
		(
			snappedangle = eulerangles 0 0 nintydegrees
			SnapRotateFN(snappedangle)
		)
		on rotatezneg pressed do
		(
			snappedangle = eulerangles 0 0 -(nintydegrees)
			SnapRotateFN(snappedangle)
		)
	)
	rollout renamerRollout "Renamer" width:162 height:99
	(
		local prefix
		button renamebtn "Rename" pos:[24,64] width:120 height:24
		edittext nameprefixtext "" pos:[16,32] width:136 height:24
		label lbl1 "Prefix -" pos:[16,16] width:56 height:16
		GroupBox grp5 "Rename Selection" pos:[8,0] width:154 height:95
		on renamebtn pressed do
			for obj in selection do obj.name = uniqueName prefix
		on nameprefixtext entered text do
		(
		prefix = text
		for obj in selection do obj.name = uniqueName prefix
		)
	)
	rollout PipeTool "Bibs Valve Placer" width:160 height:160
	(
		global spheres = #()
		local hasnotcreated = true
		
		spinner count "count" pos:[52,7] width:97 height:16 range:[1,50,5] type:#integer
		pickbutton detail "Pick Detail" pos:[16,48] width:128 height:21 enabled:false 
	 
	 
	 

		button create "Create Pipe" pos:[32,104] width:100 height:21 enabled:false
		button cancel "Cancel" pos:[8,128] width:70 height:21 toolTip:"I'm temprimental"
		button commit "Commit" pos:[80,128] width:70 height:21 enabled:false
		pickbutton curve "Pick Curve" pos:[16,26] width:128 height:18
		checkbox widthcheck "widthcheck" pos:[136,80] width:16 height:16


		spinner widthspinner "Width" pos:[24,80] width:105 height:16 range:[1,50,5] type:#integer


		on detail picked obj do
		(
			detail.text = obj.name
			print obj.name
			create.enabled = true
		)
		on create pressed do
		(
			if hasnotcreated then
			(
				spheres = for i in int 1 to count.value collect
					 instance detail.object pos:[0,0, i ] 
						 
					AttatchToSpline(curve.object)
					 hasnotcreated = false
		
			)
			else
			(
				delete spheres
				print "has created"
				create.text = "Reload"
				spheres = for i in int 1 to count.value collect
					 instance detail.object pos:[0,0, i ] 
						 
				AttatchToSpline(curve.object)
		
			)
				 
		)
		on cancel pressed do
		(	
			if spheres.count > 0 do
			(
				try(delete spheres)catch()
			)
		)
		on commit pressed do
		(	
			if spheres.count > 0 do
			(
				max spacebar
				DestroyDialog(PipeTool)
			)
		)
		on curve picked obj do
		(
			curve.text = obj.name
			detail.enabled = true
		local curveobject = obj
		)
		on widthspinner changed val do
		(
		if curve.object != null then
		(
				local curveject 
				curveject = curve.object
				curveject.render_displayRenderMesh = true
				curveject.render_mapcoords = true
				curveject.realWorldMapSize = true
				
				local curvewidth
				curvewidth = widthspinner.value
				curveject.render_thickness = 0.01 * curvewidth
			)
			else
			(
				messageBox "pick a curve"
			)
		)
	)

 -- Export
	rollout diXporterRollout "DiXporter" width:162 height:161
	(
		
		local exportlabel = "Export_To" 
	 
		checkbox prefabscheck "Prefab" pos:[62,32] width:62 height:24 checked:true
		checkbox pipescheck "Pipes" pos:[120,32] width:56 height:24 checked:true
		checkbox scenecheck "Scene" pos:[8,32] width:48 height:24 checked:true
		--dropdownList compartmentlist "" pos:[8,8] width:160 height:21 items:compartmentlistarray
		button exportbtn "export" pos:[24,56] width:128 height:21 toolTip:""
		label lbl3 "Remember to prefix your layers with 'P^' and 'Prefabs^'. Main layer should be named as the same as the compartment." pos:[8,80] width:168 height:56
		button reloadbtn "Reload list" pos:[24,136] width:128 height:21
		on compartmentlist selected sel do
		(
			selectedcompartment = compartmentlist.selected
		)
		on exportbtn pressed do
		(
			with redraw off 
			(
				if compartmentlist.selection != 1 then --check for a selected compartments
				(
					mainLayer = LayerManager.getLayerFromName(selectedcompartment) 
					if mainLayer != undefined then -- checks if the main layer is named correctly
					(
						local exportlocation = getIniSetting compartmentlistini selectedcompartment exportlabel
						--print exportlocation
						if scenecheck.checked == true do -- export the static geometry
						(	
							ExportThis selectedcompartment exportlocation
						)
						if prefabscheck.checked == true do -- export the prefabs/hotspots
						(
							toexport = "Prefabs^" + selectedcompartment
							ExportThis toexport exportlocation
						)
						if pipescheck.checked == true do -- export the pipes
						(
							toexport = "P^" + selectedcompartment
							ExportThis toexport exportlocation
						)
					)
					else 
					(
						messageBox "layers not set up with proper names!"
					)
				)
				else
				(
					messageBox "pick a compartment"
				)
			)
		)
		on reloadbtn pressed do
		(
			compartmentlist.items = getIniSetting compartmentlistini
		)
	)
	rollout addCompartmentRollout "Add Compartment" 
	(
		
		local exportlabel = "Export_To" 
		local newcompartmentname
		local newcompartmentlocation
		button puttobtn "Put to list" pos:[24,152] width:128 height:21 enabled:true toolTip:""
		edittext nametext "" pos:[4,80] width:160 height:24 enabled:true 
	 
	 
		edittext dirtext "" pos:[4,120] width:160 height:24 enabled:true
		label lbl3 "Add the compartments name, should be the name of the layer of the static meshes in your scene and the export location." pos:[8,8] width:160 height:56
		label lbl7 "Compartment" pos:[8,64] width:80 height:16
		label lbl8 "Export Location -" pos:[8,104] width:96 height:16
		on puttobtn pressed do
		(
			-- puts the compartment details to the ini file
			if newcompartmentname != undefined then
			( -- two checks to see if information's there
				if newcompartmentlocation != undefined then
				(
					setINISetting compartmentlistini newcompartmentname exportlabel newcompartmentlocation
					local compartmentnames
					compartmentnames = getIniSetting compartmentlistini
					nametext.text = "" -- clears the fields to give player feedback
					dirtext.text = ""
					local addmessage = newcompartmentname + " added to compartments"
					messagebox addmessage 
				)
				else
				(
					messagebox "Please Choose an Export Destination"
				)
			)
			else
			(
				messagebox "Please Choose a Compartment name"
			)
		)
		on nametext entered text do
		(
			newcompartmentname = text
		)
		on dirtext entered text do
		(
		newcompartmentlocation = text
		)
	)
	rollout packer "Pipe Packer" width:162 height:177
	(
		button packbtn "Pack" pos:[72,151] width:80 height:21
		button loadlayersbtn "Load layers" pos:[32,8] width:104 height:21 
	 
	 
		listbox layerlistbox "Layers" pos:[8,32] width:144 height:7
		button unpackbtn "Unpack" pos:[8,152] width:56 height:21
		on packbtn pressed do
		(
			if layerlistbox.selection != 0 then
			(
		holdMaxFile()
				local layernumber
				layernumber = (layerlistbox.selection - 1)
				local nodes
				(LayerManager.getLayer(layerlistbox.selection - 1)).nodes &nodes
				select nodes
					
				local selection = $
				if selection != undefined then (
					for i in selection do (
						channelInfo.addChannel i
						channelInfo.CopyChannel i 3 1
						channelInfo.PasteChannel i 3 2
						channelInfo.NameChannel i 3 2 "-light map-"
					)
					modPanel.addModToSelection (Unwrap_UVW ()) ui:on
					selection[1].modifiers[#unwrap_uvw].unwrap.setMapChannel 2
						
					padding = 0.02 -- padding scale
					uv = selection[1].modifiers[#unwrap_uvw]
					actionMan.executeAction 2077580866 "40075"  -- All Commands: Pack Dialog
						-- uv.unwrap2.pack 1 padding true false false -- action for packing but doesn't rescale
				)
				else (
					messagebox "nothing selected"
				)
			)
			else
			(
				messageBox "Please pick a layer"
			)
		)
		on loadlayersbtn pressed do
		(
			for i = 0 to layermanager.count-1 do
			(
				ilayer = layermanager.getlayer i
				layerlistbox.items = append layerlistbox.items ilayer.name
			)
			print layerlistbox.items
		)
		on unpackbtn pressed do
		(
			local layernumber
			layernumber = (layerlistbox.selection - 1)
			local nodes
			(LayerManager.getLayer(layerlistbox.selection - 1)).nodes &nodes
			select nodes
			
			local selection = $
			if selection != undefined then 
			(
				for i in selection do 
				(
					deleteModifier i 1
					deleteModifier i 1
					deleteModifier i 1
				)
			)
			
		)
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
			-- Add all the sub rollouts
			AddSubRollout genToolsMain.roSubA mainTools
			AddSubRollout genToolsMain.roSubA pipesandboxesrollout
			AddSubRollout genToolsMain.roSubA PShiftRollout rolledUp:true 
			AddSubRollout genToolsMain.roSubA snapRotationDialog rolledUp:true 
			AddSubRollout genToolsMain.roSubA renamerRollout rolledUp:true 
			AddSubRollout genToolsMain.roSubA PipeTool rolledUp:true 
			-- B rollout
			AddSubRollout genToolsMain.roSubB diXporterRollout enabled:false
			AddSubRollout genToolsMain.roSubB addCompartmentRollout rolledUp:true enabled:false
			AddSubRollout genToolsMain.roSubB packer rolledUp:true enabled:false
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
)

/*
		Generate the Dialog!
*/

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
