	rollout selectByModifier "Select By Modifier" 
	(
		--"sweep", "symmetry", "Edit_Poly", "Uvwmap", "UVW_Mapping_Add", "Lathe"
		dropdownList modList "" pos:[8,8] width:144 height:21 items:#(" ") selection:1
		on selectByModifier open do
		(
			modArr = sort (for i in modifier.classes collect i as string)
			modList.items = modArr
		)
		on modList selected i do
		(
			format "you selected '%'!\n" modList.items[i]
			S = #()
			for O in objects do
			(
				for m in O.modifiers do
				(
					if ((classof M) as string) == modList.items[i] do( Append S O)	
				)
			)
			Select S
		)
	)
