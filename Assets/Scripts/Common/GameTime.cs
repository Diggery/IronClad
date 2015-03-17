using UnityEngine;
using System.Collections;
//using Events;

public class GameTime : MonoBehaviour {

	// GameTime component of a game object used to track 
	// the unpaused delta time in its update
	static GameTime theGameTime;
	static bool gamePaused = false;

	public float currentDeltaTime = 0;
	float lastUpdateTime = 0;
	float fixedTime = 0;
	
	float currentTimeScale = 1.0f;
	float timeScaleGoal = 1.0f;
	
	
	static void Initialize() {
		if (!theGameTime) {
			GameObject go = new GameObject("GameTime");
			theGameTime = go.AddComponent(typeof(GameTime)) as GameTime;
		}
	}
	
	public static float deltaTime { 
		get { 
			if (!theGameTime) {
				Initialize();
			}
			if (theGameTime) 
				return theGameTime.currentDeltaTime;
			return 0;
		}
	}
	
	public static bool paused {
		get { return gamePaused; }
		set {
			if (gamePaused != value) {
				gamePaused = value;
				theGameTime.timeScaleGoal = gamePaused ? 0.0f : 1.0f;
			    Events.Send(theGameTime.gameObject, "OnPauseChanged", (object)gamePaused);
				if (gamePaused)
				    Events.Send(theGameTime.gameObject, "OnPauseGame");
				else 		
				    Events.Send(theGameTime.gameObject, "OnResumeGame");
			}	
		}
	}
	
	void Update() {
		currentDeltaTime = Time.realtimeSinceStartup - lastUpdateTime;
		lastUpdateTime = Time.realtimeSinceStartup;
		
		fixedTime += 0.016f;
		Shader.SetGlobalFloat("fixedTime", fixedTime);
		
		currentTimeScale = Mathf.Lerp(currentTimeScale, timeScaleGoal, currentDeltaTime * 4);
		Time.timeScale = currentTimeScale;
		
	}
}
