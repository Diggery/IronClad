#pragma strict

var power			: float;

function Start () {

}

function Update () {
	transform.localEulerAngles.x = Mathf.LerpAngle(transform.localEulerAngles.x, power - 45, Time.deltaTime * 8);
}

function setPower(touchDelta : float) {
	power = Mathf.Clamp((power + touchDelta) * 1, 0, 90);
}

function getPowerLevel() : float {
	return (power/90);
}