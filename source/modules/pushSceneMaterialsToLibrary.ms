/*

		Pushes all materials in scene to library

*/

-- check material exists

rollout pushSceneMaterialsToLibrary "pushSceneMaterialsToLibrary" width:172 height:52
(
	local libraryDirectory 
	local lib
	
	edittext libname "" pos:[8,8] width:88 height:16 enabled:false
	button getdirbtn "..." pos:[104,8] width:56 height:16
	button updatebtn "Scene" pos:[8,32] width:72 height:16
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
			/*
			-- checks if it's a multimaterial and disregards
			if classof m != Multimaterial do
			(
				PushMaterials m
			)
			*/
			if classof m == Multimaterial then
			(
				print "multi mat!"
				for i = 1 to m.count do
				(
					PushMaterials m[i]
				)
			)
			else
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
			if classof m == Multimaterial then
			(
				print "multi mat!"
				for i = 1 to m.count do
				(
					PushMaterials m[i]
				)
			)
			else
			(
				PushMaterials m
			)
		)
		saveTempMaterialLibrary lib libraryDirectory
	)
	/*
		Button events
	*/
	button updateselectedbtn "Selected" pos:[88,32] width:72 height:16
	on getdirbtn pressed do
	(
		(
			libraryDirectory = getOpenFileName()
			--print (getFilenameFile libraryDirectory)
			if libraryDirectory != undefined do
			(
				libname.text = (getFilenameFile libraryDirectory)
			)
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