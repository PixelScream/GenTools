//
// Photoshop action for spliting up a cubemap
//
var suffix = ["Pos", "Neg"];

function split()
{
	var outputFolder = Folder.selectDialog("Select a folder to save to");
	var orDoc = app.activeDocument;
	var w = parseInt(orDoc.width, 10) / 4;
	var docName = orDoc.name;
	docName = (docName.match(/(.*)(\.[^\.]+)/) ? docName = docName.match(/(.*)(\.[^\.]+)/):docName = [docName, docName])[1];

	newDoc = app.documents.add(w,w,72,"Cubemap Split");

	var slides = ["x" + suffix[0], "x" + suffix[1], "y" + suffix[0], "y" + suffix[1], "z" + suffix[0], "z" + suffix[1]];
	var bounds = [[2,1], [0,1], [1,0], [1,2], [1,1], [3,1]];

	for (i = 0; i < slides.length; i++)
	{
		app.activeDocument = orDoc;
		
		x = (bounds[i])[0];
		y = (bounds[i])[1];
		var boundTemplate = [[w * x, w * y], [w * (x + 1), w * y], [w * (x + 1), w * (y + 1)], [w * x, w * (y + 1)]];
		orDoc.selection.select(boundTemplate);
		
		var savePath = new File(outputFolder + "/" + docName + "_" + slides[i] + ".png");
		orDoc.selection.copy(true);
		app.activeDocument = newDoc;
		newDoc.paste();
		savePNG(savePath);
	}
	activeDocument.close(SaveOptions.DONOTSAVECHANGES);
}

split();

function savePNG(savePath)
{
	pngSaveOptions = new PNGSaveOptions();
	activeDocument.saveAs(savePath, pngSaveOptions, true, Extension.LOWERCASE);

}