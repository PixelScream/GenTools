/*

		returns the viewport direction

*/
/*
fn PosOrNeg viewDir dir =
(
	case of
	(

	)
	pon = undefined
	if absDir.(dir) > 0 then
	(
		pon = "+"
	)
	else
	(
		pon = "-"
	)
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
		(absDir.x > absDir.y and absDir.x > absDir.z): dir = "x"
		(absDir.y > absDir.x and absDir.y > absDir.z): dir = "y"
		default: dir = "z"
	)
	--pon = PosOrNeg viewDir dir
	--dir = pon + dir
	
	return dir
)

GetViewDirection()