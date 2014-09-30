unregisterRedrawViewsCallback GW_marker
tollerance = 0.2
vertArray = #()

fn CallbackFn1 ev nd = 
(
	--format "Event Detected: Event%, Nodes %\n" ev nd 
	theSel = for obj in selection where not obj.isHiddenInVpt collect obj
	if theSel.count == 1 and classOf theSel[1] == Editable_Poly  and getSelectionLevel theSel[1] == #vertex do
	(
		vertArray = #()
		vertPosArray = #()
		curObj = theSel[1]
		--vertArray = getVertSelection theSel[1] as array
		-- mirror bit
		ver = getVertSelection curObj as array
		for sv = 1 to ver.count do
		(
			selVPos = polyop.getVert curObj ver[sv]
			for tv = 1 to curObj.numVerts do
			(
				vPos = polyop.getVert curObj tv
				if (close_enough (curObj.center.x - selVPos.x) vPos.x tollerance) == true  and close_enough selVPos.y vPos.y tollerance and close_enough selVPos.z vPos.z tollerance then
				(
					--format "vert % is at the mirrored position for vert %\n" tv ver[sv]
					append vertArray tv
					
				)
				else
				(
					append vertArray undefined
				)
				
			)
			
		)
	)
)


fn CallbackTopology ev nd =
(
format "Event Detected: Event%, Nodes %\n" ev nd 
	theSel = for obj in selection where not obj.isHiddenInVpt collect obj
	if theSel.count == 1 and classOf theSel[1] == Editable_Poly  and getSelectionLevel theSel[1] == #vertex do
	(
		curObj = theSel[1]
		ver = (getVertSelection curObj) as array
		print ver
		if vertArray != undefined do
		(
			for i = 1 to vertArray.count do
			(
				if vertArray[i] != undefined do
				(
					
					print i
					print vertArray[i]
					print ver[i]
					
					--		fuuuuuuuuuuuuuu why can't i find ver[i] it should exist
					
					
					--newPos = polyop.getVert curObj ver[i]
					--print newPos
					--newPos = polyop.getVert curObj ver[i]
					--polyop.setVert curObj vertArray[i] [curObj.center.x - newPos.x, newPos.y, newPos.z]
				)
			)
		)
	)
)

fn GW_marker =
(	
	gw.setTransform(Matrix3 1)

	theSel = for obj in selection where not obj.isHiddenInVpt collect obj
	if theSel.count == 1 and classOf theSel[1] == Editable_Poly  and getSelectionLevel theSel[1] == #vertex do
	(

		--drawing bit
		if vertArray != undefined do
		(
			for i = 1 to vertArray.count do
			(
				if vertArray[i] != undefined do
				(
					markerPos = polyop.getVert theSel[1] vertArray[i]
					gw.marker markerPos #bigBox color:green
				)
			)
		)
		gw.marker [0,0,0] #circle color:green
		gw.enlargeUpdateRect #whole
		gw.updateScreen()
	
	)
)
callbackItem = NodeEventCallback mouseUp:true delay:1000 subobjectSelectionChanged:CallbackFn1 
callbackItemTopology = NodeEventCallback mouseUp:true delay:1000 geometryChanged:CallbackTopology
registerRedrawViewsCallback GW_marker
