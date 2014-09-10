--function that will print out selected object names:
--try(destroyDialog feedback)catch()
 

rollout showTricount "showTricount" 
(
	label objlbl "name:" pos:[8,8] width:144 height:24
	label countlbl "count" pos:[8,32] width:144 height:24
	
	fn printSelName=
	(
		if selection[1] != undefined do 
		(
			print selection[1].name
			objlbl.text = selection[1].name
		)
	)--end fn
	
	on feedback close do 
	(
		callbacks.removescripts #selectionSetChanged id:#myCallbackID
		print "closing"
	)
)
--add the callback that executes the function:
--callbacks.addScript #selectionSetChanged "feedback.printSelName()" id:#myCallbackID


--createDialog feedback
 
--see if your callback has been registered:
--callbacks.show()