for i = 1 to (xrefs.getXRefFileCount()) do 
(
	x = xrefs.getXRefFile i
	print x
	x.hidden = true
)