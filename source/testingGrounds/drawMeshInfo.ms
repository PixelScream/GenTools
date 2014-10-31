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
		screenCol = #()
		c = 1
		obj = theSel[1]
		append screenStat obj.name
		append screenCol undefined
		append screenStat  ("Height - " + units.formatValue (obj.max.z - obj.min.z) )
		append screenCol blue
		append screenStat  ("Width - " + units.formatValue (obj.max.x - obj.min.x) )
		append screenCol red
		append screenStat ("Depth - " + units.formatValue (obj.max.y - obj.min.y) )
		append screenCol green
		
		me = undefined
		try(me = obj.mesh)catch()
		if me != undefined and classof obj != Targetobject do
		(
			--format "% has a mesh %\n" obj.name me
			append screenStat ("Tris - " + me.numFaces as string)
			append screenCol undefined
			append screenStat ("Maps - " + meshop.getNumMaps me as string)
			append screenCol undefined
			if obj.material != undefined do
			(
				if classof obj.material == Multimaterial then
				(
					matList = for m = 1 to obj.material.count where obj.material[m] != undefined collect
					(
						obj.material[m].name
					)
					append screenStat ("Materials - " + matList as string)
					append screenCol undefined
				)
				else
				(
					append screenStat ("Material - " + obj.material.name)
					append screenCol undefined
				)
			)
		)
		if superclassof obj == shape do 
		(
			append screenStat ("Spline Length - " + (curveLength obj) as string)
			append screenCol undefined
			
		)
		for i = 1 to screenStat.count do
		(
			textCol = yellow
			if screenCol[i] != undefined  and classOf screenCol[i] == Color do
			(
				textCol = screenCol[i]
			)
			gw.hText [ofs, i * mul, 0] screenStat[i] color:textCol
		)
		
	)
  gw.enlargeUpdateRect #whole 
  gw.updateScreen()
)
registerRedrawViewsCallback GW_displayObjectNames