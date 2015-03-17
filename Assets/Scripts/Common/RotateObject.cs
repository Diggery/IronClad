using UnityEngine;
using System.Collections;

public class RotateObject : MonoBehaviour {

	float rotTimer = 0;
	float rotSpeed = 1;
	Quaternion from;
	Quaternion to;
	
	void Update() {
		if (rotTimer < 0) {
			Destroy (this);
			return;
		}
		rotTimer -= Time.deltaTime * rotSpeed;
		transform.rotation = Quaternion.Lerp (from, to, 1 - rotTimer);

	}

	public void SetRotation(Quaternion _from, Quaternion _to) {
		rotTimer = 1.0f;
		to = _to;
		from = _from;
	}


}

