using UnityEngine;
using System.Collections;

public class CrewMover : MonoBehaviour {


	public Transform posGoal;

	public float moveSpeed = 100;
	public float groundDrag = 3;

	Rigidbody rigidBody;
	bool onGround;

	void Start () {
		rigidBody = GetComponent<Rigidbody>();
	}
	
	void FixedUpdate () {

		// move to goal
		Vector3 posGoalOffset = Vector3.ClampMagnitude ((posGoal.position - transform.position), 1);
		posGoalOffset.y = 0; // remove any y force
		rigidBody.AddForce (posGoalOffset * moveSpeed);
	}

	void Update () {

		// rotate along path
		Vector3 moveDirection = rigidBody.velocity;
		moveDirection.y = 0;
		if (onGround && moveDirection.magnitude > 0.1f) {
			moveDirection.Normalize ();
			Quaternion rotGoal = Quaternion.LookRotation (moveDirection);
			transform.rotation = Quaternion.Lerp(transform.rotation, rotGoal, Time.deltaTime * 8);
		}
	}

	void OnCollisionEnter(Collision collision) {
		if (collision.gameObject.layer == LayerMask.NameToLayer("Ground")) {
			print ("On Ground");
			rigidBody.drag = groundDrag;
			rigidBody.constraints = RigidbodyConstraints.FreezeRotation;
			onGround = true;
		}
	}

	void OnCollisionExit(Collision collision) {
		if (collision.gameObject.layer == LayerMask.NameToLayer("Ground")) {
			print ("Off Ground");
			rigidBody.drag = 0.5f;
			rigidBody.constraints = RigidbodyConstraints.None;
			onGround = false;
		}		
	}
}
