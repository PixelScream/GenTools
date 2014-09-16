/*

		Pushes all materials in scene to library

*/

-- check material exists

rollout pushSceneMaterialsToLibrary "updateMaterialLibrary" width:180 
(
	local libraryDirectory 
	local lib
	
	edittext libname "" pos:[8,8] width:96 height:16 enabled:false
	button getdirbtn "..." pos:[112,8] width:56 height:16
	button updatebtn "Scene" pos:[16,32] width:64 height:16
	/*
		Functions
	*/
	fn MaterialExisting mat =
	(
		for m in lib do
		(
			if mat.name == m.name do return m
		)
		return undefined
	)

	fn PushMaterials m =
	(

		--check if exits
		libraryMat = MaterialExisting m
		
		-- if it doesn't create
		if libraryMat == undefined then
		(
			format "% doesn't exist! Creating now\n" m.name
			append lib m
		)
		else
		(
			-- if it does update
			format "% exists! Updating now\n" m.name
			lib[libraryMat.name] = m
		)
	)
	fn PushScene =
	(
		for m in sceneMaterials do
		(
			-- checks if it's a multimaterial and disregards
			if classof m != Multimaterial do
			(
				PushMaterials m
			)
		)
		saveTempMaterialLibrary lib libraryDirectory
	)
	
	fn PushSelected =
	(
		for obj in selection do
		(
			m = obj.material
			-- checks if it's a multimaterial and disregards
			if classof m != Multimaterial do
			(
				PushMaterials m
			)
		)
		saveTempMaterialLibrary lib libraryDirectory
	)
	/*
		Button events
	*/
	button updateselectedbtn "Selected" pos:[104,32] width:64 height:16
	on getdirbtn pressed do
	(
		(
			libraryDirectory = getOpenFileName()
			print (getFilenameFile libraryDirectory)
			libname.text = (getFilenameFile libraryDirectory)
		)
	)
	on updatebtn pressed do
	(
		if libraryDirectory != undefined do
		(
			lib = loadTempMaterialLibrary libraryDirectory
			--if lib == undefined do return 0
			PushScene()
		)
	)
	on updateselectedbtn pressed do
	(
		if libraryDirectory != undefined do
		(
			lib = loadTempMaterialLibrary libraryDirectory
			--if lib == undefined do return 0
			PushSelected()
		)
	)
)
