var uiManager					: UIMananger;
private var touchDistance		: Vector2;

private var startTargets		: Transform[];
private var gestureArmed		: boolean[];
private var touchTime			: float[];
var tapTime						: float;

private var lastTime 			: double; 
private var currentTime 		: double; 
private var deltaTime 			: float; 

function Start() {
	lastTime = Time.realtimeSinceStartup;
	
	startTargets = new Transform[10];
	gestureArmed = new boolean[10];
	touchTime = new float[10];

}	
	
function Update() {
	//track our own time so we can move when paused.
	currentTime = Time.realtimeSinceStartup;
	deltaTime = currentTime - lastTime;
	lastTime = Time.realtimeSinceStartup;
	
	if (Application.platform != RuntimePlatform.IPhonePlayer || Application.platform != RuntimePlatform.Android) {
		var ray: Ray = Camera.main.ScreenPointToRay(Input.mousePosition);
		var hit: RaycastHit;
		var touchDelta : Vector2;
		touchDelta.x = Input.GetAxis("Mouse X") * 2;
		touchDelta.y = Input.GetAxis("Mouse Y");
		var touchPosition : Vector3 = Input.mousePosition;
		touchPosition.z = Camera.main.transform.position.z;
		
		
		if (Input.GetMouseButtonDown(0)) {
			touchDelta = Vector2.zero;
			touchDistance = Vector2.zero;
			touchTime[0] = 0;
			Physics.Raycast(ray, hit);
			uiManager.touchDown(hit.transform, 0);
			startTargets[0] = hit.transform;
			gestureArmed[0] = true;
		}
	
		if (Input.GetMouseButton(0)) {
			Physics.Raycast(ray, hit);
			uiManager.touchDrag(touchDelta, touchDistance, touchPosition, hit.transform, startTargets[0], 0);
			touchDistance += touchDelta;
			touchTime[0] += deltaTime;
			
			if (gestureArmed) {
				if (touchDistance.x < -5) {
					uiManager.swipeLeft(startTargets[0], hit.transform, 0);
					gestureArmed[0] = false;
				}
				if (touchDistance.x > 5) {
					uiManager.swipeRight(startTargets[0], hit.transform, 0);
					gestureArmed[0] = false;
				}
				if (touchDistance.y < -5) {
					uiManager.swipeDown(startTargets[0], hit.transform, 0);
					gestureArmed[0] = false;
				}
				if (touchDistance.y > 5) {
					uiManager.swipeUp(startTargets[0], hit.transform, 0);
					gestureArmed[0] = false;
				}
			
				if (touchTime[0] > tapTime) {
					if (startTargets[0] == hit.transform && (touchDistance.x + touchDistance.y) < 5) {
						uiManager.longTouched(startTargets[0]);
						gestureArmed[0] = false;
					} else {
						uiManager.longTouched(null);
						gestureArmed[0] = false;
					}
				}
			}
	
		}
			
		if (Input.GetMouseButtonUp(0)) {
			Physics.Raycast(ray, hit);
			uiManager.touchUp(hit.transform, startTargets[0], 0);
			startTargets[0] = null;
			if (gestureArmed[0]) {
				uiManager.tap(hit.transform, 0);
			}
		}	

} else {

		var touchInput : Touch[] = Input.touches;
	
		for (var i : int = 0; i < touchInput.Length; i++) {	
			var touch : Touch = touchInput[i];
			ray = Camera.main.ScreenPointToRay(touch.position);
			touchDelta = touch.deltaPosition * 0.15;
			touchPosition = touch.position;
			touchPosition.z = Camera.main.transform.position.z;
	
			if (touch.phase == TouchPhase.Began) {	
				touchDelta = Vector2.zero;
				touchDistance = Vector2.zero;
				touchTime[0] = 0;
				Physics.Raycast(ray, hit);
				uiManager.touchDown(hit.transform, i);
				startTargets[i] = hit.transform;
				gestureArmed[i] = true;
			}
		
			if (touchInput.Length > 0) {
				Physics.Raycast(ray, hit);
				uiManager.touchDrag(touchDelta, touchDistance, touchPosition, hit.transform, startTargets[i], i);
				touchDistance += touchDelta;
				touchTime[0] += deltaTime;
				
				if (gestureArmed) {
					if (touchDistance.x < -5) {
						uiManager.swipeLeft(startTargets[i], hit.transform, i);
						gestureArmed[i] = false;
					}
					if (touchDistance.x > 5) {
						uiManager.swipeRight(startTargets[i], hit.transform, i);
						gestureArmed[i] = false;
					}
					if (touchDistance.y < -5) {
						uiManager.swipeDown(startTargets[i], hit.transform, i);
						gestureArmed[i] = false;
					}
					if (touchDistance.y > 5) {
						uiManager.swipeUp(startTargets[i], hit.transform, i);
						gestureArmed[i] = false;
					}
				
					if (touchTime[i] > tapTime) {
						if (startTargets[i] == hit.transform && (touchDistance.x + touchDistance.y) < 5) {
							uiManager.longTouched(startTargets[i]);
							gestureArmed[i] = false;
						} else {
							uiManager.longTouched(null);
							gestureArmed[i] = false;
						}
					}
				}
			}
				
			if (touch.phase == TouchPhase.Ended) {	
				Physics.Raycast(ray, hit);
				uiManager.touchUp(hit.transform, startTargets[i], i);
				startTargets[i] = null;
				if (gestureArmed[i]) {
					uiManager.tap(hit.transform, i);
				}
			}
		}
	}
	
	if (Input.GetKeyUp(KeyCode.Escape)) {
		uiManager.backPressed();
	}
	if (Input.GetKeyUp(KeyCode.A) || Input.GetKeyUp(KeyCode.Menu)) {
		uiManager.menuPressed();
	}

}