--function that will print out selected object names:
--try(destroyDialog feedback)catch()
 

rollout showTricount "showTricount" 
(
	label objlbl "name:" pos:[8,8] width:144 height:24
	label countlbl "count" pos:[8,32] width:144 height:24
	
	fn printSelName=
	(
		curObj = selection[1]
		if selection[1] != undefined do 
		(
			curObj = selection[1]
			print curObj.name
			objlbl.text = curObj.name
			if superclassof curObj == geometryClass then
			(
				countlbl.text = curObj.mesh.numFaces as string
			)
			else
			(
				countlbl.text = "none mesh"
			)
		)
	)--end fn
	
	on feedback close do 
	(
		callbacks.removescripts #selectionSetChanged id:#myCallbackID
		print "closing"
	)
)
--add the callback that executes the function:
callbacks.addScript #selectionSetChanged "showTricount.printSelName()" id:#myCallbackID


--createDialog feedback
 
--see if your callback has been registered:
--callbacks.show()