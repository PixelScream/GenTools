/*

		Incremental save system with a time stamp

*/

macroScript timeCapsulse
category:"Genie Tools"
buttonText:"Save +"
tooltip:"Saves + saves out a time stamped copy"
(
	if maxfilename != "" then
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
	else
	(
		messagebox "Save scene somewhere first"
	)
)