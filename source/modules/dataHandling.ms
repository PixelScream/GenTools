	rollout dataHandling "Data handling" width:168 height:136
	(
		local isFrozenInGray = true
		GroupBox miscgroup "Time Capsule" pos:[8,0] width:152 height:40 ps:[8,712]
		button saveplusbtn "Save +" pos:[88,16] width:64 height:16 toolTip:""

		
		GroupBox grp5 "XRef" pos:[8,40] width:152 height:88 ps:[8,712]
		button xoffbtn "XRef Off" pos:[88,80] width:64 height:16 toolTip:""
		button xonbtn "XRef On" pos:[16,80] width:64 height:16 toolTip:""
		button savebtn "Save" pos:[16,16] width:64 height:16 toolTip:""
		button xinbtn "XRef" pos:[16,56] width:64 height:16 enabled:false toolTip:""
		button overlaybtn "Overlay" pos:[88,56] width:64 height:16 toolTip:""
		button btn13 "Translucent" pos:[16,104] width:64 height:16 toolTip:""
		button btn14 "Solid" pos:[88,104] width:64 height:16 toolTip:""
		on saveplusbtn pressed do
		(
			local timeCapsuleSubFolder = "time capsule/"
			-- save file blah
			curFile = maxfilepath + maxfilename
			savemaxfile curFile
			
			-- get and format the time stamp
			t = getLocalTime()
			for i = 1 to t.count do
			(
				t[i] = t[i] as string
			)
			fileName = getFilenameFile maxfilename
			newSave = (getFilenameFile maxfilename) + "_" + t[4] + t[2] + t[1] + "_" + t[5] + t[6] + ".max"
			format "Saving % and making a copy called %\n" maxfilename (timeCapsuleSubFolder + newSave)
			newSave = maxfilepath + timeCapsuleSubFolder + newSave
			
			-- check time capsule folder exists
			if (doesFileExist (maxFilePath + timeCapsuleSubFolder) != true) do
			(
				makedir (maxFilePath + timeCapsuleSubFolder)
			)
			
			-- copies file with time stamp
			copyFile curFile newSave
		)
		on xoffbtn pressed do
		(
			for i = 1 to (xrefs.getXRefFileCount()) do 
			(
				x = xrefs.getXRefFile i
				print x
				x.hidden = true
			)
		)
		on xonbtn pressed do
		(
			for i = 1 to (xrefs.getXRefFileCount()) do 
			(
				x = xrefs.getXRefFile i
				print x
				x.hidden = false
			)
		)
		on savebtn pressed do
		(
			for i = 1 to (xrefs.getXRefFileCount()) do 
			(
				x = xrefs.getXRefFile i
				x.hidden = true
			)
			curFile = maxfilepath + maxfilename
			savemaxfile curFile
		)
		on xinbtn pressed do
		(
		p = getsavepath()
		if p != undefined do
		(
			for i = 1 to (xrefs.getXRefFileCount()) do 
			(
				x = xrefs.getXRefFile i
				print x
				x.hidden = false
			)
		)
		)
		on overlaybtn pressed do
		(
			for i = 1 to (xrefs.getXRefFileCount()) do 
			(
				x = xrefs.getXRefFile i
				x.overlay = true
			)
		)
		on btn13 pressed do
		(
		for i = 1 to (xrefs.getXRefFileCount()) do 
		(
			x = xrefs.getXRefFile i
			xObjs = x.tree.children
			for obj in xObjs do
			(
				obj.xray = on
				obj.backfacecull = on
			)
		)
		)
		on btn14 pressed do
		(
		for i = 1 to (xrefs.getXRefFileCount()) do 
		(
			x = xrefs.getXRefFile i
			xObjs = x.tree.children
			for obj in xObjs do
			(
				obj.xray = off
				obj.backfacecull = on
			)
		)
		)
	)
