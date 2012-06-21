#pragma strict
private var gameController 			: GameController;

var idlePositions 					: Transform[];
var workPositions 					: Transform[];

function Start () {
	gameController = GameObject.Find("GameController").GetComponent(GameController);
	transform.tag = "Room";
	
	//gather up the spots for players to stand
	idlePositions = new Transform[4];
	for (var i : int = 0; i < idlePositions.Length; i++) {
		idlePositions[i] = transform.Find("Idle" + i);
		// put up an error if we didnt find any
		if (!idlePositions[i]) Debug.Log("ERROR: need idle slots on " + transform.name);
		idlePositions[i].renderer.enabled = false;
	}

}

function Update () {
	var colorCheck : float = renderer.material.color.r + renderer.material.color.g + renderer.material.color.b + renderer.material.color.a;
	if (colorCheck > 0.01) {
		renderer.material.color = Color.Lerp(renderer.material.color, Color.clear, GameClock.deltaTime * 8);
	} else {
		renderer.enabled = false;
	}
}

function select() {
	renderer.enabled = true;
	renderer.material.color = Color.yellow;
	gameController.crewManager.sendTeam(transform);
}

function getPos(slot) : Vector3 {
	return idlePositions[slot].position;
}