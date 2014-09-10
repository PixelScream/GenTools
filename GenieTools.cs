using UnityEditor;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class GenieTools : EditorWindow {

	Vector2 scrollPosition;
	Vector3 storedPos;
	Quaternion storedRotation;

	[MenuItem("Window/Genie Tools")]
	public static void ShowWindow () 
	{
		EditorWindow.GetWindow(typeof(GenieTools));
	}
	 
	void OnGUI()
	{
		scrollPosition = GUILayout.BeginScrollView (scrollPosition, GUILayout.Width (Screen.width), GUILayout.Height (Screen.height - 24));
		EditorGUILayout.LabelField("Create");

		if (GUILayout.Button("Create Level Holder"))
		{
			string sceneName = EditorApplication.currentScene.Substring(EditorApplication.currentScene.LastIndexOf("/") + 1);
			sceneName = sceneName.Remove(sceneName.Length - 6);

			new GameObject(sceneName);
		}

		if (GUILayout.Button("Create Product Holder"))
		{
			GameObject holder = new GameObject();

			GameObject[] gos = Selection.gameObjects;
			string goName = "";

			int x = 0;
			while (x < gos.Length)
			{
				string[] obna = (gos[x].name).Split('_');

				goName += obna[1] + "_";
				gos[x].gameObject.transform.parent = holder.transform;
				x ++;
			}
			//gos = gos.Remove(gos.Length - 1);
			Debug.Log("Making gameobject holder " + goName)	;
			//string sceneName = EditorApplication.currentScene.Substring(EditorApplication.currentScene.LastIndexOf("/") + 1);
			//sceneName = sceneName.Remove(sceneName.Length - 6);
			
			holder.name = goName;
		}

		EditorGUILayout.LabelField("Rotate");

		if (GUILayout.Button("Reset Rotation"))
		{
			Transform[] gos = Selection.transforms;
			int x = 0;
			while (x < gos.Length)
			{
				gos[x].rotation = Quaternion.identity;
				x ++;
			}
			Debug.Log(string.Format("{0} objects just reset to zero rotation", gos.Length));
		}

		if (GUILayout.Button("Floor base"))
		{
			Transform[] gos = Selection.transforms;
			int x = 0;
			while (x < gos.Length)
			{
				gos[x].rotation = Quaternion.Euler (new Vector3(-90,0,0));
				x ++;
			}
			Debug.Log(string.Format("{0} objects for placement on floor", gos.Length));
		}
		if (GUILayout.Button("Ceiling base"))
		{
			Transform[] gos = Selection.transforms;
			int x = 0;
			while (x < gos.Length)
			{
				gos[x].rotation = Quaternion.Euler (new Vector3(90,0,0));
				x ++;
			}
			Debug.Log(string.Format("{0} objects for placement on ceiling", gos.Length));
		}

		EditorGUILayout.LabelField("Copy");

		if (GUILayout.Button("Copy transform"))
		{
			string name = Selection.activeTransform.name;
			storedPos = Selection.activeTransform.position;
			storedRotation = Selection.activeTransform.rotation;
			Debug.Log(string.Format("{0} is at {1}, and rotated to {2}", name, storedPos, storedRotation));
		}
		if (GUILayout.Button("Copy child transform"))
		{
			Transform baseObject = Selection.activeTransform;
			Transform[] baseChildren = baseObject.GetComponentsInChildren<Transform>();
			Transform childPivot = null;

			int c = 0;
			while (c < baseChildren.Length)
			{
				//Debug.Log(baseChildren[c].name);
				if (baseChildren[c].name == "C_0")
					childPivot = baseChildren[c];
				c += 1;
			}
			if (childPivot != null)
			{
				Debug.Log(string.Format("{0} has a child at {1}", baseObject.name, childPivot.position));
				storedPos = childPivot.position;
				storedRotation = childPivot.rotation;
			}
			else
				Debug.Log("No C_0 found");
		}

		EditorGUILayout.LabelField("Paste");

		if (GUILayout.Button("Paste Transform"))
		{
			string name = Selection.activeTransform.name;
			Selection.activeTransform.position = storedPos;
			Selection.activeTransform.rotation = storedRotation;
			
			Debug.Log(string.Format("{0} was moved to {1}, and rotated to {2}", name, storedPos, storedRotation));
		}
		if (GUILayout.Button("Paste Position"))
		{
			string name = Selection.activeTransform.name;
			Selection.activeTransform.position = storedPos;
			
			Debug.Log(string.Format("{0} was moved to {1}", name, storedPos));
		}
		if (GUILayout.Button("Paste Rotation"))
		{
			string name = Selection.activeTransform.name;
			Selection.activeTransform.rotation = storedRotation;
			
			Debug.Log(string.Format("{0} was rotated to {1}", name, storedRotation));
		}

		GUILayout.EndScrollView ();
	}

}
