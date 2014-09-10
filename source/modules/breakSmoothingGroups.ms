--try(destroyDialog breakSmoothingGroups)catch()
rollout breakSmoothingGroups "Break Smoothing Groups" 
(
	--local sgcount = 32
	progressBar pb "" pos:[0,48] width:168 height:8
	label pblb "" pos:[8,61] width:160 height:16
	button bsgselectedbtn "Faces" pos:[88,28] width:72 height:16
	button bsgwholebtn "Mesh" pos:[8,28] width:72 height:16
	spinner sgcount "Smoothing Group count" pos:[48,8] width:120 height:16 range:[0,32,32] type:#integer scale:1
	
	fn getFaceSmoothGroupB obj face =
	(
		local sgroup_val=getFaceSmoothGroup obj face
		local sg_bitarray=#{}
		if sgroup_val < 0 do
		(
			sg_bitarray[32]=true
			sgroup_val -= 2^31
		)
		for i = 1 to 31 do
		(
			sg_bitarray[i]= (mod sgroup_val 2 > .5)
			sgroup_val /= 2
		)
		sg_bitarray
	)
	
	fn breakBySG obj faces=
	(
		count = 1
		while count < sgcount.value do
		(
			sg = #{}
			for f in faces do
			(
				sg_bit = getFaceSmoothGroupB obj f
				--print sg_array
				sg_array = sg_bit as array
				for s in sg_array do if s == count do append sg f
			)
			pblb.text = ( sg.count as string + " faces in smoothing group " + count as string)
			
			--format "faces % are in smoothing group %\n" sg.count count
			
			meshop.detachFaces obj sg delete:true
			--detatch bit here
			count += 1
			prog = (count as float / sgcount.value as float) * 100.0
			pb.value = prog
		)
	)
	

	
	on bsgselectedbtn pressed do
	(
		theSel = selection
		for obj in theSel  where classof obj == Editable_Mesh do
		(
			faces_bit = getFaceSelection obj
			faces = faces_bit as array
			breakBySG obj faces
			pb.value = 0
			pblb.text = "Done splitting Selected faces"
		)
	)
	on bsgwholebtn pressed do
	(
		theSel = selection
		for obj in theSel where classof obj == Editable_Mesh do 
		(
			faces = #()
			faces = for f = 1 to getNumFaces obj collect f
			breakBySG obj faces
			pb.value = 0
			pblb.text = "Done splitting entire mesh"
		)
	)
)
--createDialog breakSmoothingGroups