using UnityEngine;
using System.Collections;

public class CrewTargeting : MonoBehaviour {

	Transform target;

	void Start () {
	
	}
	
	void Update () {
		if (!target) {
			target = FindClosest();
		}
	
	}

	Transform FindClosest() {
		string tagName = gameObject.tag.Equals("Player") ? "Enemy" : "Player";
		GameObject[] allTargets = GameObject.FindGameObjectsWithTag(tagName);

		float closestDistance = Mathf.Infinity;
		GameObject closestObject = null;
		foreach (GameObject target in allTargets) {
			float distance = (transform.position - target.transform.position).sqrMagnitude;
			if (distance < closestDistance) {
				closestObject = target;
				closestDistance = distance;
			}
		}
		return closestObject.transform;

	}

	public Transform GetTarget() {
		return target;
	}
}
