#pragma strict

var heading						: float;
var currentAngle				: float;
var manuveringPower 			: float;

var enginePower					: HUDPower;
var steeringWheel				: Transform;

var joint						: ConfigurableJoint;


function Start () {

}

function FixedUpdate () {
	if (!joint) {
		//point ship to match the steering wheel
		heading = steeringWheel.eulerAngles.y;
		if (heading > 180) heading = -360 + heading;
		
		currentAngle = transform.localEulerAngles.y;
		if (currentAngle > 180) currentAngle = -360 + currentAngle;
		
		var turnLeft : boolean;
		
		if (currentAngle - heading > 0) turnLeft = true;
		
		if (Mathf.Abs(currentAngle - heading) > 180 ) turnLeft = !turnLeft;
		
		if (turnLeft) {
			rigidbody.AddTorque(0, -manuveringPower, 0);
		} else {
			rigidbody.AddTorque(0, manuveringPower, 0);
		}
		
		//set the power of the ship
		
		rigidbody.AddRelativeForce(0, 0, 10000 * enginePower.getPowerLevel());
	} else {
		joint.targetRotation = steeringWheel.localRotation;
	}	
}