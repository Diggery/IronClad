#pragma strict

private var lastTime 			: double; 
private var currentTime 		: double; 
static var deltaTime 			: float; 


function Start () {
	lastTime = Time.realtimeSinceStartup;

}

function Update () {
	//track our own time so we can move when paused.
	currentTime = Time.realtimeSinceStartup;
	deltaTime = currentTime - lastTime;
	lastTime = Time.realtimeSinceStartup;
}

static function getDeltaTime() : float {
	return deltaTime;
}