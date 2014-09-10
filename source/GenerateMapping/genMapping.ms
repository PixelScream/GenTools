callNP = undefined
		
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
callbacks.removeScripts id:#ModifierTest
callbacks.addScript #preModifierDeleted "ModTest callerID:#predelete" id:#ModifierTest
callbacks.addScript #preModifierAdded "ModTest callerID:#preadd" id:#ModifierTest
