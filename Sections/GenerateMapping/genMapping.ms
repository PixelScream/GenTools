callNP = undefined

sourceFolder = trimRight (getFileNamePath (getThisScriptFilename())) "\\"
rootFolder = (getDir #userScripts) + "/GenTools"
preferencesIni = rootFolder + "/GenToolsPreferences.ini" 
		
fn ModTest callerID:#none =
(
callNP = callbacks.notificationParam()
modAdded = callNP[2]
 /*-- uncomment if you want to see modifiers being added / deleted from objects
case callerID of
(
#none: format "Function Called without Caller ID!\n"
#preadd: format "[%] About to be added to [%]\n" callNP[2] callNP[1]
#predelete: format "[%] About to be deleted from [%]\n" callNP[2] callNP[1]
)
*/
	genmapping = (getIniSetting preferencesIni "Mod Info" "genmapping") as booleanClass
	realworldmapping = (getIniSetting preferencesIni "Mod Info" "realworldmapping") as booleanClass
		try
		(
			if genmapping == true do
			(
				case classof modAdded  of
				(
					Bevel: (modAdded.Produce_Mapping_Coords = 1)
					Bevel_Profile: (modAdded.Produce_Mapping_Coords = 1)
					Extrude: (modAdded.mapcoords = true)
					Lathe: (modAdded.mapcoords = true)
					Sweep: (modAdded.GenerateMappingCoords = true)			
					Renderable_Spline: (modAdded.mapcoords = true)
				)
			)
		)catch()
		try
		(
			if realworldmapping == true and genmapping == true do
			(
				case classof modAdded  of
				(
						Bevel: (modAdded.realWorldMapSize = on)	
						Bevel_Profile: (modAdded.realWorldMapSize = on)	
						Extrude: (modAdded.realWorldMapSize = on)	
						Lathe: (modAdded.realWorldMapSize = on)	
						Sweep: (modAdded.realWorldMapSize = on)		
						Renderable_Spline: (modAdded.realWorldMapSize = on)	
						Uvwmap: (modAdded.realWorldMapSize = on)
				)
			)
		)catch()
		

)
callbacks.removeScripts id:#ModifierTest
callbacks.addScript #preModifierDeleted "ModTest callerID:#predelete" id:#ModifierTest
callbacks.addScript #preModifierAdded "ModTest callerID:#preadd" id:#ModifierTest
