#pragma strict

var teams				: TeamControl[];

var selectedTeam		: int;

function Start () {

}

function Update () {

}

function addTeam(newTeam : TeamControl) {

}

function removeTeam(deadTeam : TeamControl) {

}

function selectTeam(newTeam : TeamControl) {
	for (var i : int = 0; i < teams.Length; i++) {
		if (teams[i] == newTeam) selectedTeam = i;
	}
}

function nextTeam() {

}

function prevTeam() {

}

function sendTeam(room : Transform) {
	var roomManager : RoomManager = room.GetComponent(RoomManager);
	teams[selectedTeam].gotoRoom(roomManager);
}