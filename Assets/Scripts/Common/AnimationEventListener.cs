using UnityEngine;
using System.Collections;

public class AnimationEventListener : MonoBehaviour {

	public void playSound(string soundName) {
		
		switch (soundName) {
		case "runningFootStep" :
			Vector4 soundData = new Vector4(transform.position.x, transform.position.y, transform.position.z, 1.0f);
			Events.Send(gameObject, "SoundEvents", soundData);
			break;
		}
	}
	
	public void DoDamage() {
		transform.parent.gameObject.SendMessage("DoDamage");
	}
	
}
