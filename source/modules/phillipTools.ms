rollout phillipTools "Phil Tools" width:168 height:136
(
	button randomcolorbtn "rand. color" pos:[16,16] width:64 height:16
	button childselbtn "select child" pos:[16,36] width:64 height:16
	button uniquenamebtn "uniqu name" pos:[88,16] width:64 height:16
	button dummybtn "dummy" pos:[16,56] width:64 height:16
	button parentdummybtn "Parent" pos:[88,56] width:64 height:16 enabled:false
	button flipbtn "flip" pos:[88,80] width:64 height:16 enabled:false
	button selectparentbtn "select par" pos:[88,36] width:64 height:16
	button scaleuvbtn "Scale UV" pos:[16,80] width:64 height:17
 
	button isooffbtn "Iso Off" pos:[16,104] width:64 height:17
	button isoonbtn "Iso On" pos:[88,104] width:64 height:17
	groupBox grp1 "Phil tools" pos:[8,0] width:152 height:128
	
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
	on scaleuvbtn pressed do
	(
		tilesScale = 0.01
		u = UVW_XForm U_Tile:tilesScale V_Tile:tilesScale W_Tile:tilesScale name:"Scale UVS CM to M"
		for obj in selection where superClassOf obj == GeometryClass do addModifier obj (u)
	)
	on isooffbtn pressed do
	(
		for obj in selection do 
		( 
			for m in obj.modifiers do 
			( 
				if (classof m as string) == "TurboSmooth" do ( m.isolineDisplay = false)
				if (classof m as string) == "TurboSmooth_Pro" do ( m.isolineDisplay = 0)
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
				if (classof m as string) == "TurboSmooth_Pro" do ( m.isolineDisplay = 1)
			)
		)
	)
)
