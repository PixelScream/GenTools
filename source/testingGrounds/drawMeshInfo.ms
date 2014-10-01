mul = 12
ofs = 45
unregisterRedrawViewsCallback GW_displayObjectNames
fn GW_displayObjectNames =
(
  gw.setTransform (matrix3 1)
	theSel = for obj in selection where not obj.isHiddenInVpt collect obj
	if theSel.count == 1 do
	(
		screenStat = #()
		c = 1
		obj = theSel[1]
		append screenStat obj.name
		append screenStat  ("Height - " + units.formatValue (obj.max.z - obj.min.z) )
		append screenStat  ("Width - " + units.formatValue (obj.max.x - obj.min.x) )
		append screenStat ("Depth - " + units.formatValue (obj.max.y - obj.min.y) )
		
		me = undefined
		try(me = obj.mesh)catch()
		if me != undefined do
		(
			--format "% has a mesh %\n" obj.name me
			append screenStat ("Tris - " + me.numFaces as string)
			append screenStat ("Maps - " + meshop.getNumMaps me as string)
			if obj.material != undefined do
			(w
				if classof obj.material == Multimaterial then
				(
					matList = for m = 1 to obj.material.count collect
					(
						obj.material[m].name
					)
					append screenStat ("Materials - " + matList as string)
				)
				else
				(
					append screenStat ("Material - " + obj.material.name)
				)
			)
		)
		
		for i = 1 to screenStat.count do
		(
			gw.hText [ofs, i * mul, 0] screenStat[i] color:yellow
		)
		
	)
  gw.enlargeUpdateRect #whole 
  gw.updateScreen()
)
registerRedrawViewsCallback GW_displayObjectNames