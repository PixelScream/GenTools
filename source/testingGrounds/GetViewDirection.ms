/*

		returns the viewport direction

*/
/*
fn GetViewportDirection =
(
	
)
*/
fn GetViewDirection =
(
	local coordSysTM = Inverse(getViewTM())
	local viewDir = -coordSysTM.row3
	print viewDir
	absDir = [abs viewDir.x, abs viewDir.y, abs viewDir.z]
	dir = undefined
	case of
	(
		(absDir.y > absDir.x and absDir.y > absDir.z): dir = "y"
		(absDir.x > absDir.y and absDir.x > absDir.z): dir = "x"
		default: dir = "z"
	)
	/*
	pon = PosOrNeg viewDir dir
	if absDir.(execute dir)
	dir = pon + dir
	*/
	return dir
)

GetViewDirection()