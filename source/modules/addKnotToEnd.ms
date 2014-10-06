/*

		Rollout will add knots to selected end knots of splines

*/

rollout addKnotToEnd "Add Knot" width:180 
(
	groupBox grp1 "Add Knot to Spline" pos:[8,0] width:168 height:40
	spinner mulspin "Multiplier" pos:[30,16] width:72 height:16 range:[0,100,5] scale:0.5
	button addbtn "Add" pos:[112,16] width:56 height:16
	/*
		Functions
	*/
	fn NewKnotBack sp s k=
	(
		dir = (getKnotPoint  sp s k) - (getKnotPoint  sp s (k - 1))
		normalDir = normalize dir
		--print normalDir
		addKnot sp s #corner #curve ((getKnotPoint  sp s k) + (normalDir * mulspin.value)) 
		updateShape sp
		setKnotSelection sp s #(numKnots sp s)
	)

	fn NewKnotFront sp s =
	(
		knotCount = numKnots sp s
		dir = (getKnotPoint  sp s 1) - (getKnotPoint  sp s 2)
		normalDir = normalize dir
		--print normalDir
		addKnot sp s #corner #curve ((getKnotPoint  sp s 1) + (normalDir * mulspin.value)) 
		setFirstKnot sp s (numKnots sp s)
		updateShape sp
	)

	fn AddNewKnot sp =
	(
		for s = 1 to numSplines sp do
		(
			knotSel =  (getknotSelection sp s)
			if knotSel.count < 2 then
			(
				for k = 1 to knotSel.count do
				(
					case of
					(
						(knotSel[k] == numKnots sp s): NewKnotBack sp s knotSel[k]
						(knotSel[k] == 1): NewKnotFront sp s
						default: format "spline %'s knot % is not the end of the line\n" s knotSel[k]
					)
					
				)
			)
			else
			(
				format "more than 1 knot selected on spline %\n" s
			)
		)
	)
	on addbtn pressed  do
	(
		for obj in selection do
		(
			AddNewKnot obj
		)
	)
)