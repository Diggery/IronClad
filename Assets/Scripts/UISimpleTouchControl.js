private var uiManager			: UIMananger;
private var menuCamera			: Camera;
private var menuUp				: boolean;

var tapTime						: float;

private var touchTime			: float;

private var lastTime 			: double; 
private var currentTime 		: double; 
private var deltaTime 			: float; 

function Start() {
	lastTime = Time.realtimeSinceStartup;
	menuCamera = transform.GetComponent(Camera);
}	
	
function Update() {

	if (menuUp) { 
		if (Application.platform != RuntimePlatform.IPhonePlayer || Application.platform != RuntimePlatform.Android) {
			var ray: Ray = menuCamera.ScreenPointToRay(Input.mousePosition);
			var hit: RaycastHit;		
			
			if (Input.GetMouseButtonDown(0)) {
				touchTime = 0;
				Physics.Raycast(ray, hit);
			}
			
			touchTime += deltaTime;
				
			if (Input.GetMouseButtonUp(0)) {
				Physics.Raycast(ray, hit);
				if (touchTime < tapTime) {
					uiManager.tap(hit.transform, -1);
				}
			}	
	
		} else {
	
			var touchInput : Touch[] = Input.touches;
		
			var touch : Touch = touchInput[0];
			ray = menuCamera.ScreenPointToRay(touch.position);
	
			if (touch.phase == TouchPhase.Began) {	
				touchTime = 0;
				Physics.Raycast(ray, hit);
			}
			
			touchTime += deltaTime;
				
			if (touch.phase == TouchPhase.Ended) {	
				Physics.Raycast(ray, hit);
				if (touchTime < tapTime) {
					uiManager.tap(hit.transform, -1);
				}
			}
		}
	}
}

function openMenu() {
}

function closeMenu() {
}