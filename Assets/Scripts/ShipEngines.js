#pragma strict

var heading						: float;
var currentAngle					: float;
var manuveringPower 			: float;
var engines						: float;

var steeringWheel				: Transform;


function Start () {

}

function Update () {
	//add torque to the ship to point it at the heading
	heading = steeringWheel.eulerAngles.y;
	if (heading > 180) heading = -360 + heading;
	
	currentAngle = transform.localEulerAngles.y;
	if (currentAngle > 180) currentAngle = -360 + currentAngle;
	
	if (currentAngle - heading > 0) {
		rigidbody.AddTorque(0, -manuveringPower, 0);
	} else {
		rigidbody.AddTorque(0, manuveringPower, 0);
	}
}