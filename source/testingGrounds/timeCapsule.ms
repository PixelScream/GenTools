/*

		Incremental save system with a time stamp

*/

-- save file
curFile = maxfilepath + maxfilename
savemaxfile curFile
t = getLocalTime()
for i = 1 to t.count do
(
	t[i] = t[i] as string
)
fileName = getFilenameFile maxfilename
newSave = maxfilepath + (getFilenameFile maxfilename) + "_" + t[4] + t[2] + t[1] + "_" + t[5] + t[6] + ".max"
copyFile curFile newSave