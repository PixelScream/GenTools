--try(destroyDialog lazyRollout)catch()
rollout surfaceCleanup "surfaceCleanup" 
(
	spinner tolspin "Tolerance" pos:[16,8] width:136 height:16 range:[-1,1,0.98] scale:0.01
	button vertbtn "Delete Coplanar Verts" pos:[8,32] width:140 height:14
	button tribtn "Triangulate NonQuads" pos:[8,56] width:140 height:14
	button quadbtn "Vis Specific Edge" pos:[8,80] width:96 height:14
	dropdownList edgedrop "" pos:[112,77] width:32 height:21 items:#("1", "2", "3") selection:2
	on vertbtn pressed do
	(
		theSel = selection
		max modify mode
		with undo on
		(
			for obj in theSel where classOf obj == Editable_Poly do
			(
				vertSel = obj.numverts
				l = #()
					for i = vertSel to 1 by -1 do
					(
						v = i
						select obj.verts[v]
						nVerts = (polyop.getedgesusingvert obj v) as array
						if nVerts.count == 2 do
						(
							vertsToDot = (polyop.getVertsUsingEdge obj nVerts) as array
							v1 =  obj.verts[vertsToDot[2]].pos - obj.verts[vertsToDot[1]].pos
							v2 = obj.verts[vertsToDot[3]].pos - obj.verts[vertsToDot[1]].pos
							d = dot (normalize v1) (normalize v2)
							--print d
							if d >= tolspin.value do
								append l v
						)
					)
					select obj
					subobjectlevel = 1
					select obj.verts[l]
					format "Deleting % redundant verts from %\n" l.count obj.name
					obj.EditablePoly.buttonOp #Remove
					subobjectlevel = 0
			)
		)
	)
	on tribtn pressed do
	(
		max modify mode
		with undo on
		(
			theSel = selection
			for obj in theSel where classOf obj == Editable_Poly do
			(
				faceCount = obj.numfaces
				nonQuads = #()
					for f = 1 to faceCount do
					(
						faceVerts = polyop.getFaceDeg obj f
						if faceVerts != 4 do append nonQuads f
					)
					polyop.setFaceSelection obj nonQuads
					format "Triangulating % many faces on %\n" nonQuads.count obj.name
					ConvertToMesh obj		
					selectedFaces = getFaceSelection obj as array
					for i in selectedFaces do 
					(
						setEdgeVis obj i 1 true
						setEdgeVis obj i 2 true
						setEdgeVis obj i 3 true
					)
					ConvertToPoly obj
			)
		)
	)
	on quadbtn pressed do
	(
		max modify mode
		with undo on
		(
			theSel = selection
			for obj in theSel where classOf obj == Editable_Poly do
			(
				faceCount = obj.numfaces
				nonQuads = #()
					for f = 1 to faceCount do
					(
						faceVerts = polyop.getFaceDeg obj f
						if faceVerts != 4 do append nonQuads f
					)
					polyop.setFaceSelection obj nonQuads
					format "Triangulating % many faces on %\n" nonQuads.count obj.name
					ConvertToMesh obj		
					selectedFaces = getFaceSelection obj as array
					for i in selectedFaces do 
					(
						setEdgeVis obj i edgedrop.selection true
					)
					ConvertToPoly obj
			)
		)
	)
)

--CreateDialog lazyRollout