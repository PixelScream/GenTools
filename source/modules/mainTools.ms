	rollout mainTools "Tools" 
	(
		local isFrozenInGray = true
		button boxmap "Box" pos:[16,144] width:56 height:24 toolTip:"Box map to real world scale"
		button collapseto "Collapse To" pos:[88,96] width:64 height:24 toolTip:"Runs 'Collapse to' for selection"
		button collapsepoly "CollapsePoly" pos:[16,96] width:64 height:24 toolTip:"Collapses to Editable poly"
		button deletetop "Delete Top" pos:[16,192] width:64 height:24 toolTip:"Deletes the top modifier off the stack"
		GroupBox uvgroup "UV Presets" pos:[8,128] width:153 height:48
		GroupBox polygroup "Poly" pos:[8,80] width:152 height:48
		GroupBox modifiergroup "Modifiers" pos:[8,176] width:152 height:48
		button cylindricalmap "Cylindrical" pos:[80,144] width:72 height:24 enabled:false toolTip:"Cylindrical map to real world scale"
		GroupBox miscgroup "Misc" pos:[8,0] width:152 height:80 ps:[8,712]
		button backfacebtn "BF Culling" pos:[16,16] width:64 height:24 toolTip:"Toggles back face culling on selection"
		button iterationbtn "Save Iteration" pos:[72,48] width:80 height:24 toolTip:"Saves out an iteration of your max file"

		button clearbtn "Clear Mat" pos:[88,192] width:64 height:24 toolTip:"Deletes the top modifier off the stack"
		button gantrybtn "Gantry" pos:[16,48] width:48 height:24 enabled:false toolTip:"Close Containers"
		button frozenbtn "Frozen Gray" pos:[88,16] width:64 height:24 toolTip:"makes all models not frozen in gray"
		on boxmap pressed do
		(
			for obj in selection do addModifier obj (uvwMap maptype:4 realWorldMapSize:on)
			)
		on collapseto pressed do
			maxOps.CollapseNodeTo $ 1 off
		on collapsepoly pressed do
			macros.run "Modifier Stack" "Convert_to_Poly"
		on deletetop pressed do
		(
			local selection = $
			if selection != undefined then 
			(
				for i in selection do 
				(
					if i.modifiers[1] != undefined do
					(
						deleteModifier i 1
					)
				)
			)
			else (
				messagebox defaultErrorMessage
			)
			
		)
		on cylindricalmap pressed do
		(
			for obj in selection do addModifier obj (uvwMap maptype:1 realWorldMapSize:on)
		)
		on backfacebtn pressed do
		(
				max backface cull toggle
			)
		on iterationbtn pressed do
		(
				max saveplus
			)
		on clearbtn pressed do
		(
			local selection = $
			if selection != undefined then 
			(
				for i in selection do 
				(
					i.material = undefined
				)
			)
			else (
				messagebox defaultErrorMessage
			)
			
		)
		on gantrybtn pressed do
		(
		for obj in selection do
		(
			modifierCount = obj.modifiers.count
			with redraw off
			(
			SelectUpFaces obj modifierCount
			)
		)
		)
		
		on frozenbtn pressed do
		(
			if isFrozenInGray != false then
			(
				for o in objects do
				(
					o.showFrozeninGray = false
				)
				isFrozenInGray = false
				print "Objects are nolonger frozen in gray"
			)
			else  
			(
					for o in objects do
					(
						o.showFrozeninGray = true
					)
					isFrozenInGray = true
					print "Objects are now frozen in gray"
			)
		)
	)