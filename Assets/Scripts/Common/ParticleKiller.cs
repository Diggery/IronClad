using UnityEngine;
using System.Collections;

public class ParticleKiller : MonoBehaviour {


	void Update () {
	
		if (!GetComponent<ParticleSystem>().IsAlive()) {
			Destroy (gameObject);    
	    }	
	}
}
