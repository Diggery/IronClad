using UnityEngine;
using System.Collections;

public class ParticleGroup : MonoBehaviour {

	public bool addParticleKillers;

	void Start () {
		if (addParticleKillers) {
			foreach (Transform child in transform) 
				child.gameObject.AddComponent<ParticleKiller>();
		}
		
		transform.DetachChildren();
		Destroy(gameObject);
	}
}
