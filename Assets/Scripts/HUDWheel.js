#pragma strict

var heading			: float;

function Start () {

}

function Update () {
	transform.localEulerAngles.y = Mathf.LerpAngle(transform.localEulerAngles.y, heading, Time.deltaTime * 8);
}

function setAngle(touchPos : Vector2) {

    var wheelToScreen : Vector3 = Camera.main.WorldToScreenPoint (transform.position);
    var wheelCenter : Vector2 = Vector2( wheelToScreen.x, wheelToScreen.y);


	heading = (Util.getDirection(touchPos - wheelCenter));
}