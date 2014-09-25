unregisterRedrawViewsCallback GW_displayObjectNames
fn GW_displayObjectNames =
(
  gw.setTransform (matrix3 1)
  for o in objects where not o.isHiddenInVpt do
    gw.text (o.center) (o as string) color:yellow
   
  
--gw.triangle #([0,0,0], [50,0,0], [50,50,0]) #(red,red,red)
--gw.triangle #([0,10,0], [50,50,0], [0,50,0]) #(green,green,green)
  for obj in selection do
  (
	gw.startTriangles()
	for f = 1 to obj.mesh.numFaces do
	(
		tris = meshop.getVertsUsingFace obj.mesh #{f}
		triPos = for v in tris collect polyop.getVert obj v
		--format "% % %\n" triPos[1] triPos[2] triPos[3]
		gw.triangle #(triPos[1], triPos[2], triPos[3]) #(green,green,green)
	)
	gw.endTriangles()
  )

  gw.enlargeUpdateRect #whole 
  gw.updateScreen()
)
registerRedrawViewsCallback GW_displayObjectNames