function MovePivotDirection dir = 
(
	if selection != undefined then (
		for i in selection do (	
			c = i.pivot
			case of
			(
				(dir == "directionup"): i.pivot = [c.x, c.y, i.max.z]
				(dir == "directiondown"): i.pivot = [c.x, c.y, i.min.z]
				(dir == "directionleft"): i.pivot = [i.min.x, c.y, c.z]
				(dir == "directionright"): i.pivot = [i.max.x, c.y, c.z]
				(dir == "directionforward"): i.pivot = [c.x, i.max.y, c.z]
				(dir == "directionback"): i.pivot = [c.x, i.min.y, c.z]
				default: print "pShift got confused"
			)
			/*
			if newpos != undefined then
			(
				if dir == "directionup" or dir == "directiondown" do
				(
					newz = [oldpos.x, oldpos.y, newpos.z]
				)
				if dir == "directionright" or dir == "directionleft" do
				(
					newz = [newpos.x, oldpos.y, oldpos.z]
				)
				if dir == "directionforward" or dir == "directionback" do
				(
					newz = [oldpos.x, newpos.y, oldpos.z]
				)
			)
			else
			(
				messageBox "Only works on Editable polys and Editbale meshes"
			)
			-- set the pivot
			if newz != undefined do
			(
				sel.pivot = newz
			)
			*/
		)
	)
	else 
	(
		messagebox "nothing selected"
	)
)
	rollout PShift "pShift" width:160 
	(
		local direction = "directiondown"
		global storedpivot 
		button downbtn "down" pos:[64,64] width:40 height:16
		button upbtn "up" pos:[64,16] width:40 height:16
		button centerbtn "Cen" pos:[64,40] width:40 height:16
		button rightbtn "right" pos:[112,40] width:40 height:16
		button leftbtn "Left" pos:[16,40] width:40 height:16
		button forwardbtn "Fwd" pos:[112,16] width:40 height:16
		button backbtn "back" pos:[16,16] width:40 height:16
		button pastebtn "paste" pos:[112,64] width:40 height:16 toolTip:"pastes the pivot location from the store"
		button copybtn "copy" pos:[16,64] width:40 height:16 toolTip:"Stores the pivot of the selected object"
		button scalebtn "Scale" pos:[16,104] width:40 height:16
		GroupBox grp23 "Reset" pos:[8,88] width:152 height:40
		button xformbtn "Xform" pos:[64,104] width:40 height:16
		button zerobtn "000" pos:[112,104] width:40 height:16 toolTip:"Moves pivot to 0, 0, 0"
		GroupBox grp45 "Pivot" pos:[8,0] width:152 height:88
		on downbtn pressed do
		(
			direction = "directiondown"
			MovePivotDirection(direction)
		)
		on upbtn pressed do
		(
			 direction = "directionup"
			MovePivotDirection(direction)
		)
		on centerbtn pressed do
		(
		local selection = $
		if selection != undefined then (
			for i in selection do (
				CenterPivot $
			)
		)
			else (
					messagebox "nothing Selected"
				)
		)
		on rightbtn pressed do
		(
			 direction = "directionright"
			MovePivotDirection(direction)
		)
		on leftbtn pressed do
		(
			 direction = "directionleft"
			MovePivotDirection(direction)
		)
		on forwardbtn pressed do
		(
			 direction = "directionforward"
			MovePivotDirection(direction)
		)
		on backbtn pressed do
		(
			 direction = "directionback"
			MovePivotDirection(direction)
		)
		on pastebtn pressed do
		( -- selection.pivot = storedpivot
			local selection = $
			if selection != undefined then 
			(
				for i in selection do 
				(
					if storedpivot != undefined then
					(
						selection.pivot = storedpivot
					)
					else
					(
						messagebox "no stored pivot"
					)
				)
			)
			else (
				messagebox "nothing Selected"
			)
		)
		on copybtn pressed do
		(
			local selection = $
			if selection != undefined then 
			(
				for i in selection do 
				(
					storedpivot = selection.pivot
				)
			)
			else (
				messagebox "nothing Selected"
			)
		)
		on scalebtn pressed do
		(
			local selection = $
			if selection != undefined then 
			(
				for i in selection do 
				(
					ResetScale selection 
				)
			)
			else (
				messagebox "nothing Selected"
			)
		)
		on xformbtn pressed do
		(
			local selection = $
			if selection != undefined then 
			(
				for i in selection do 
				(
					ResetXForm selection
				)
			)
			else (
				messagebox "nothing Selected"
			)
		)
		on zerobtn pressed do
		(
			local selection = $
			if selection != undefined then 
			(
				for i in selection do 
				(
					selection.pivot = [0,0,0]
				)
			)
			else (
				messagebox "nothing Selected"
			)
		)
	)
