/*

		Will mirror the translations taken on vertecies in Editable Poly

*/

-- Cleanup
unregisterRedrawViewsCallback GW_marker
callbackItem = undefined
callbackItemTopology = undefined
gc light:true

-- Variables
tollerance = 0.2
vertArray = #()
centerPos = undefined
curObj = undefined
markerCol = yellow
axis = "x"
axisMarkerSize = 5.0

/*
	Callback dealing with finding mirrored verts
*/
fn CallbackSubSel ev nd = 
(
	if getSelectionLevel curObj == #vertex do
	(
		-- clears the stored vertArray
		vertArray = #()
		ver = getVertSelection curObj as array
		-- loop through selected verts to find a match
		for sv = 1 to ver.count do
		(
			selVPos = curObj.center - (polyop.getVert curObj ver[sv])
			-- if nothing is found undefined is added to the array so as to not confuse itself.
			mirroredVert = undefined
			for tv = 1 to curObj.numVerts do
			(
				-- checks if vert is itself
				if tv != ver[sv] do
				(
					vPos = curObj.center - (polyop.getVert curObj tv)
					-- finds the difference between the two vector 3s and sees if it falls within a certain tollerance
					difference = [(selVPos.x + vPos.x), (selVPos.y - vPos.y), (selVPos.z - vPos.z)]
					if (abs difference.x) <= tollerance and (abs difference.y) <= tollerance and (abs difference.z) <= tollerance do
					(
						--if a match is found asign it to a variable which will be added to the stored array
						format "% and % are a match !!!\n" ver[sv] tv
						format "% is the total difference between % and %\n" difference ver[sv] tv
						mirroredVert = tv
						
					)
				)
			)
			append vertArray mirroredVert
			
		)
		-- updates the center of translation only when the vert selection is changed, otherwise the center will 
		-- change before the mirroring process will have had time to take place
		centerPos = curObj.center
		
	)
)

/*
	Callback dealing with the translation of the mirrored verts
*/
fn CallbackTopology ev nd =
(
	if getSelectionLevel curObj == #vertex do
	(
		ver = (getVertSelection curObj) as array
		if vertArray != undefined and centerPos != undefined do
		(
			for i = 1 to ver.count do
			(
				if vertArray[i] != undefined do
				(	
					-- grabs the verts position and moves the mirrored on the the negative relative position
					tempPos = polyop.getVert curObj ver[i]
					negPos = centerPos - (tempPos - centerPos)
					-- Seems like a lot of unnecessary variables but this is is waiting for the case of each axis
					newPos = [negPos.x, tempPos.y, tempPos.z]
					polyop.setVert curObj #{vertArray[i]} newPos
				)
				
			)	
		)		
	)
)

/*
	View port drawing
*/
fn GW_marker =
(	
	gw.setTransform(Matrix3 1)
	if centerPos != undefined do
	(
		if axis == "x" do
		(
			rectArray = #([centerPos.x, centerPos.y - axisMarkerSize, centerPos.z - axisMarkerSize], [centerPos.x, centerPos.y - axisMarkerSize, centerPos.z + axisMarkerSize], \
			[centerPos.x, centerPos.y + axisMarkerSize, centerPos.z + axisMarkerSize], [centerPos.x, centerPos.y +  axisMarkerSize, centerPos.z - axisMarkerSize])
		)
		gw.Polyline rectArray true
	)
	if getSelectionLevel curObj == #vertex do
	(
		-- Drawing a small box for each mirrored vert
		if vertArray != undefined do
		(
			for i = 1 to vertArray.count do
			(
				if vertArray[i] != undefined do
				(
					markerPos = polyop.getVert curObj vertArray[i]
					gw.marker markerPos #bigBox color:markerCol
				)
				
			)
		)
	)
	-- just a couple of on screen reminders that it's running & for testing
	gw.marker [0,0,0] #circle color:green
	gw.hText [50,10,10] ("activeSym running on: " + curobj.name + ",  mode: " + (getSelectionLevel curobj) as string) color:markerCol
	gw.enlargeUpdateRect #whole
	gw.updateScreen()
)

/*
	Master callback
*/
fn CallbackSel ev nd =
(
	-- Checks for only one selection and that it's an editable poly, for this to work
	theSel = for obj in selection where not obj.isHiddenInVpt collect obj
	if theSel.count == 1 and classOf theSel[1] == Editable_Poly then
	(
		-- Starts the relevant callbacks 
		callbackItem = NodeEventCallback mouseUp:true delay:1000 subobjectSelectionChanged:CallbackSubSel 
		callbackItemTopology = NodeEventCallback mouseUp:true delay:1000 geometryChanged:CallbackTopology
		registerRedrawViewsCallback GW_marker
		curObj = theSel[1]
	)
	else
	(
		-- Garbage clean up and stopping the callbacks
		unregisterRedrawViewsCallback GW_marker
		callbackItem = undefined
		callbackItemTopology = undefined
		curObj = undefined
		gc light:true
	)
)

callbackItemSelection = NodeEventCallback mouseUp:true delay:1000 selectionChanged:CallbackSel
CallbackSel undefined undefined

