rollout phillipTools "Phil Tools" width:160 height:184
(
	button randomcolorbtn "rand. color" pos:[8,8] width:64 height:16
	button childselbtn "select child" pos:[8,32] width:64 height:16
	button uniquenamebtn "uniqu name" pos:[80,8] width:64 height:16
	button dummybtn "dummy" pos:[8,56] width:64 height:16
	button parentdummybtn "Parent" pos:[80,56] width:64 height:16 enabled:false
	button flipbtn "flip" pos:[80,80] width:64 height:16 enabled:false
	button selectparentbtn "select par" pos:[80,32] width:64 height:16
	button scaledownbtn "scale down" pos:[80,104] width:64 height:16
	button scaleuvbtn "Scale UV" pos:[8,104] width:64 height:17
	button checkerbtn "Checker" pos:[8,128] width:64 height:17
	button dummyresizebtn "resize d" pos:[8,80] width:64 height:16 
	button isooffbtn "Iso Off" pos:[8,152] width:64 height:17
	button isoonbtn "Iso On" pos:[80,152] width:64 height:17
	button lmpbtn "LM Pack" pos:[8,176] width:64 height:17
	on randomcolorbtn pressed do
	(
	for i in selection do ( i.wirecolor = random white black ) 
	)
	on childselbtn pressed do
	(
	for obj in selection do selectMore obj.children
	)
	on uniquenamebtn pressed do
	(
	for i in selection do ( i.name = uniqueName "Mesh" ) 
	)
	on dummybtn pressed do
	(
		theSel = for obj in selection collect obj
		if theSel.count != 0 then
		(
			for obj in theSel do ( dummy pos:obj.pos )
		)
		else 
		(
			dummy()
		)
	)
	on parentdummybtn pressed do
	(
		theSel = for obj in selection collect obj
		if theSel.count != 0 then
		(
			for obj in theSel do 
			( 
				parentDummy = dummy pos:obj.pos name:("P_" + obj.name) size:1
				childDummy = dummy pos:obj.pos name:("ro_for" + obj.name) size:0.5
				obj.parent = childDummy
				childDummy.parent = parentDummy
				childDummy.rotation += unityRot as quat
				
				for o in obj.children do
				(
					if classOf o == Dummy do
						ResetXform o
				)
			)
		)
		else 
		(
			dummy()
		)
	)
	on flipbtn pressed do
	(
	Flip()
	)
	on selectparentbtn pressed do
	(
		curSel = $
		node = curSel[1]
		while node.parent != undefined do node = node.parent
		select node
	)
	on scaledownbtn pressed do
	(
		x = Xform name:"Scale down Mavig"
		scaleVal = 0.1
		newSale = [scaleVal,scaleVal,scaleVal]
		max modify mode
		modPanel.addModToSelection (x) ui:on
		x.gizmo.scale = newSale
	)
	on scaleuvbtn pressed do
	(
		tilesScale = 0.01
		u = UVW_XForm U_Tile:tilesScale V_Tile:tilesScale W_Tile:tilesScale name:"Scale UVS CM to M"
		for obj in selection where superClassOf obj == GeometryClass do addModifier obj (u)
	)
	on checkerbtn pressed do
	(
	c = Checker color2:(color 200 200 200) color1:(color 50 50 50)

	for obj in selection where superClassOf obj == GeometryClass do 
	(
		theMaterial = obj.material
		if classOf theMaterial == Standard do
		(
			c = Checker color2:(color 200 200 200) color1:(color 50 50 50)
			theMaterial.diffuseMap = c
			theMaterial.diffuseMapEnable = on
		)
		showTextureMap theMaterial true
	)
	)
	on uncheckerbtn pressed do
	(
		for obj in selection do 
		(
			theMaterial = obj.material
			if classOf theMaterial == Standard do
			(
				theMaterial.diffuseMapEnable = off
			)
		)
	)
	on dummyresizebtn pressed do
	(
		theSel = selection as array
		if theSel.length == 1 do
		(
			$.boxsize = [20,20,20]
		)
	)
	
	on isooffbtn pressed do
	(
		for obj in selection do 
		( 
			for m in obj.modifiers do 
			( 
				if (classof m as string) == "TurboSmooth" do ( m.isolineDisplay = false)
			)
		)
	)
	on isoonbtn pressed do
	(
		for obj in selection do 
		( 
			for m in obj.modifiers do 
			( 
				if (classof m as string) == "TurboSmooth" do ( m.isolineDisplay = true)
				if (classof m as string) == "TurboSmooth_Pro" do ( m.isolineDisplay = 0)
			)
		)
	)
		on lmpbtn pressed do
	(
		createDialog progressRollout
		theNodes = selection as array
		lmName = "lightmap pack"
		max modify mode
		with redraw off
		count = 1
		for obj in theNodes do
		(
			select obj
			if obj.modifiers[1] == undefined or obj.modifiers[1].name != lmName do
			(
				ConvertToPoly obj
				--format "lightmapping %" obj.name
				channelInfo.addChannel obj
				channelInfo.CopyChannel obj 3 1
				channelInfo.PasteChannel obj 3 2
				channelInfo.NameChannel obj 3 2 "-lm-"
				nUV = Unwrap_UVW name:lmName
				addModifier obj nUV
				obj.modifiers[lmName].unwrap.setMapChannel 2
				subobjectLevel = 3
				max select all
				obj.modifiers[lmName].pack 0 0.02 true false false
				subobjectLevel = 0
				max select none
				prog = (count as float /theNodes.count as float) * 100.0
				print prog
				count += 1
				progressRollout.progressb.value = prog
			)
		)
		destroyDialog progressRollout
	)
)