	rollout snapRotation "Snap Rotations" width:176 height:296
	(
		local nintydegrees = 90
		local snappedangle = eulerangles 0 0 0
		GroupBox grp1 "X" pos:[4,0] width:164 height:48
		button rotatexpos "+" pos:[8,16] width:72 height:24
		button rotatexneg "-" pos:[88,16] width:72 height:24
		
		GroupBox grp2 "Y" pos:[4,48] width:164 height:48
		button rotateypos "+" pos:[8,64] width:72 height:24
		button rotateyneg "-" pos:[88,64] width:72 height:24
		GroupBox grp3 "Z" pos:[4,96] width:164 height:48
		button rotatezpos "+" pos:[8,112] width:72 height:24
		button rotatezneg "-" pos:[88,112] width:72 height:24
		on rotatexpos pressed do
		(
			snappedangle = eulerangles nintydegrees 0 0
			SnapRotateFN(snappedangle)
		)
		on rotatexneg pressed do
		(
			snappedangle = eulerangles -(nintydegrees) 0 0
			SnapRotateFN(snappedangle)
		)
		on rotateypos pressed do
		(
			snappedangle = eulerangles 0 nintydegrees 0
			SnapRotateFN(snappedangle)
		)
		on rotateyneg pressed do
		(
			snappedangle = eulerangles 0 -(nintydegrees) 0
			SnapRotateFN(snappedangle)
		)
		on rotatezpos pressed do
		(
			snappedangle = eulerangles 0 0 nintydegrees
			SnapRotateFN(snappedangle)
		)
		on rotatezneg pressed do
		(
			snappedangle = eulerangles 0 0 -(nintydegrees)
			SnapRotateFN(snappedangle)
		)
	)