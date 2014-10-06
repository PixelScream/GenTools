//
// Photoshop action for merging the 6 sides of a cubemap
//

function merge()
{
	if (!app.documents.length == 6)
	{
		alert("Please only have the 6 cubemape faces open in photoshop, sorry!")
	}
	else
	{
		var w = parseInt(app.activeDocument.width, 10);
		newDoc = app.documents.add(w*4, w*3, 72, "Cubemap");
		for (i = 0; i < app.documents.length; i++)
		{
			if ( app.documents[i] != newDoc )
			{
				app.activeDocument = app.documents[i];
				var curDoc = app.activeDocument;
				curDoc.selection.selectAll()
				//var bounds = [[0,0], [w,0], [w,w], [0,w]];
				//curDoc.selection.select(bounds);
				curDoc.selection.copy();
				app.activeDocument = newDoc;

				pastedLayer = newDoc.paste();
				pastedLayer.name = curDoc.name;
			}
		}
	}
	/*
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
	*/
}

merge();