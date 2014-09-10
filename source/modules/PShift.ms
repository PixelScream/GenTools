
	rollout PShift "pShift" width:162 height:196
	(
		local direction = "directiondown"
		global storedpivot 
		button downbtn "down" pos:[64,96] width:40 height:32
		button upbtn "up" pos:[64,16] width:40 height:32
		button centerbtn "Cen" pos:[64,56] width:40 height:32
		button rightbtn "right" pos:[112,56] width:40 height:32
		button leftbtn "Left" pos:[16,56] width:40 height:32
		button forwardbtn "Fwd" pos:[112,16] width:40 height:32
		button backbtn "back" pos:[16,16] width:40 height:32
		button pastebtn "paste" pos:[112,96] width:40 height:32 toolTip:"pastes the pivot location from the store"
		button copybtn "copy" pos:[16,96] width:40 height:32 toolTip:"Stores the pivot of the selected object"
		button scalebtn "Scale" pos:[16,152] width:40 height:32
		GroupBox grp23 "Reset" pos:[8,136] width:152 height:56
		button xformbtn "Xform" pos:[64,152] width:40 height:32
		button zerobtn "000" pos:[112,152] width:40 height:32 toolTip:"Moves pivot to 0, 0, 0"
		GroupBox grp45 "Pivot" pos:[8,0] width:152 height:136
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