mul = 12
ofs = 45
unregisterRedrawViewsCallback GW_displayObjectNames
fn GW_displayObjectNames =
(
  gw.setTransform (matrix3 1)
	theSel = for obj in selection where not obj.isHiddenInVpt collect obj
	if theSel.count == 1 do
	(
		c = 1
		obj = theSel[1]
		gw.hText [ofs, c * mul, 0] obj.name
		c += 1
		--gw.hText [ofc, c * mul, 0] (obj.pos as string)
		c += 1
		me = undefined
		try(me = obj.mesh)catch()
		if me != undefined do
		(
			--format "% has a mesh %\n" obj.name me
			gw.hText [ofs, c * mul, 0] ("Tris - " + me.numFaces as string)
			c += 1
			gw.hText [ofs, c * mul, 0] ("UV Sets - " + meshop.getNumMaps me as string)
			
		)

		
	)
  gw.enlargeUpdateRect #whole 
  gw.updateScreen()
)
registerRedrawViewsCallback GW_displayObjectNames