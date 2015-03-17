using UnityEngine;
using System.Collections;

public class CrewMover : MonoBehaviour {


	public Transform posGoal;

	Rigidbody rigidBody;

	void Start () {
		rigidBody = GetComponent<Rigidbody>();
	}
	
	void Update () {
		Vector3 posGoalOffset = posGoal.position - transform.position;
		rigidBody.AddForce(posGoalOffset * 100);
	}
}
