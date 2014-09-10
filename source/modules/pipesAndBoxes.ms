
	rollout pipesAndBoxes "Pipes & Boxes" width:162 height:164
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