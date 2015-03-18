using UnityEngine;
using System.Collections;

public class CrewMover : MonoBehaviour {



	public float moveSpeed = 100;
	public float groundDrag = 3;



	Rigidbody rigidBody;
	CrewTargeting crewTargeting;

	bool onGround;
	bool attacking = true;
	bool moving;

	Vector3 facingDirection = Vector3.forward;

	void Start () {
		crewTargeting = gameObject.AddComponent<CrewTargeting> ();
		rigidBody = GetComponent<Rigidbody>();
	}
	
	void FixedUpdate () {
		Transform target = crewTargeting.GetTarget ();

		Vector3 posGoal = transform.position;

		if (target && attacking) {// move to goal
			posGoal = target.position;
		}

		Vector3 posGoalOffset = posGoal - transform.position;
		if (posGoalOffset.sqrMagnitude > 1.5) {
			posGoalOffset.y = 0; // remove any y force
			posGoalOffset.Normalize ();
			facingDirection = posGoalOffset;
			rigidBody.AddForce (posGoalOffset * moveSpeed);
			moving = true;
		} else {
			moving = false;
		}
	}

	void Update () {

		// rotate along path
		if (onGround) {
			Quaternion rotGoal = Quaternion.LookRotation (facingDirection);
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
