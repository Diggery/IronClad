#pragma strict

var crewMembers   			: CrewMemberControl[];

function Start () {

}

function Update () {

}

function gotoRoom(room : RoomManager) {
	for (var i : int = 0; i < crewMembers.Length; i++) {
		crewMembers[i].gotoRoom(room, i);
	}
}