private var killTimer				: float;

function Start() {

}

function Update() {
	if (killTimer > 0) killTimer -= Time.deltaTime;	
}

function touchDown(touchTarget : Transform, touchPosition : Vector3) {
	if (!touchTarget) return;

}


function touchDrag(touchDelta : Vector2, touchDistance : Vector2, touchPosition : Vector3, touchTarget : Transform, startTarget : Transform) {
	if (!startTarget) return;

}

function tap(touchTarget: Transform)  {
	if (!touchTarget) return;
	print(touchTarget.name);
	if (touchTarget.tag == "Room") (touchTarget.GetComponent(RoomManager) as RoomManager).select();
	

}

function touchUp(touchTarget : Transform, startTarget : Transform, touchDistance : Vector2) {
	if (!startTarget) return;

}

function swipeLeft(touchTime : float, startTarget : Transform, endTarget: Transform) {
	if (!startTarget) return;

}

function swipeRight(touchTime : float, startTarget : Transform, endTarget: Transform) {
	if (!startTarget) return;
	

}

function swipeUp(touchTime : float, startTarget : Transform, endTarget : Transform) {
	if (!startTarget) return;

}

function swipeDown(touchTime : float, startTarget : Transform, endTarget: Transform) {
	if (!startTarget) return;
}

function sweepLeft() {

}

function sweepRight() {

}

function sweepUp() {

}

function sweepDown() {

}


function longTouched(touchTarget : Transform) {
	if (!touchTarget) return;

}

function backPressed() {
}

function menuPressed() {
	if (killTimer > 0) {
		print("die");
		Application.Quit();
	}
	killTimer = 0.5;
}

