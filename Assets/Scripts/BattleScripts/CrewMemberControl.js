#pragma strict
private var navAgent			: NavMeshAgent;

function Start () {
	navAgent = GetComponent(NavMeshAgent);
}

function Update () {
	
}

function gotoRoom(room : RoomManager, slot : int) {
	var roomPos : Vector3 = room.getPos(slot);
	navAgent.SetDestination(roomPos);
}