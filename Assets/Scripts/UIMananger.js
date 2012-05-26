#pragma strict


function Start() {
}

function Update () {
	
}


function touchDown(touchTarget : Transform, fingerID : int) {


}

function longTouched(touchTarget : Transform) {

}

function touchDrag(touchDelta : Vector2, touchDistance : Vector2, touchPosition : Vector2, touchTarget : Transform, startTarget : Transform, fingerID : int) {
	var ray	: Ray;
	var hit	: RaycastHit;
	var layerMask : LayerMask;
	var worldPos : Vector2;
	
	if (!startTarget) return;
	if (startTarget.name == "Wheel") (startTarget.GetComponent(HUDWheel) as HUDWheel).setAngle(touchPosition);
	
}

function touchUp(touchTarget : Transform, startTarget : Transform, fingerID : int) {

}

function tap(touchTarget : Transform, fingerID : int) {


}

function swipeLeft(startTarget : Transform, endTarget: Transform, fingerID : int) {

}

function swipeRight(startTarget : Transform, endTarget: Transform, fingerID : int) {

}

function swipeDown(startTarget : Transform, endTarget: Transform, fingerID : int) {

}

function swipeUp(startTarget : Transform, endTarget : Transform, fingerID : int) {
}

function backPressed() {
}

function menuPressed() {

}
