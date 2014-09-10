	rollout renamer "Renamer" width:162 height:99
	(
		local prefix
		button renamebtn "Rename" pos:[24,64] width:120 height:24
		edittext nameprefixtext "" pos:[16,32] width:136 height:24
		label lbl1 "Prefix -" pos:[16,16] width:56 height:16
		GroupBox grp5 "Rename Selection" pos:[8,0] width:154 height:95
		on renamebtn pressed do
			for obj in selection do obj.name = uniqueName prefix
		on nameprefixtext entered text do
		(
		prefix = text
		for obj in selection do obj.name = uniqueName prefix
		)
	)