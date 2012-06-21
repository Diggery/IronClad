private var touchManager				: TouchManager;
		
private var touchPosition 				: Vector3;

private var touchDistance				: Vector2;
private var touchTime					: float;
private var gestureArmed				: boolean;

private var longTouchTarget				: Transform;

var tapTime								: float = 0.15;
var gestureTime							: float = 0.25;
var swipeDistance						: float = 30;

function Start() {
	touchManager = GameObject.Find("TouchController").GetComponent(TouchManager);
}

function Update() {
	if (Application.platform != RuntimePlatform.Android || Application.platform != RuntimePlatform.IPhonePlayer) {
		var ray: Ray = Camera.main.ScreenPointToRay(Input.mousePosition);
		var hit: RaycastHit;
		var lastTouchPosition : Vector3 = touchPosition;
		touchPosition = Input.mousePosition;
		var touchDelta : Vector2;
		touchDelta.x = touchPosition.x - lastTouchPosition.x;
		touchDelta.y = touchPosition.y - lastTouchPosition.y;
		touchPosition.z = Camera.main.transform.position.z;
		
		
		if (Input.GetMouseButtonDown(0)) {
			touchDelta = Vector2.zero;
			touchDistance = Vector2.zero;
			touchTime = 0;
			Physics.Raycast(ray, hit);
			touchManager.touchDown(hit.transform, touchPosition);
			longTouchTarget = hit.transform;
			gestureArmed = true;
		}
	
		if (Input.GetMouseButton(0)) {
			Physics.Raycast(ray, hit);
			touchManager.touchDrag(touchDelta, touchDistance, touchPosition, hit.transform, longTouchTarget);
			touchDistance += touchDelta;
			touchTime += Time.deltaTime;
			if (gestureArmed) {
				if (touchTime > gestureTime) {
					if (longTouchTarget == hit.transform && (touchDistance.x + touchDistance.y) < 5) {
						touchManager.longTouched(longTouchTarget);
					}
					gestureArmed = false;
				}
			}
	
		}
			
		if (Input.GetMouseButtonUp(0)) {
			Physics.Raycast(ray, hit);
			touchManager.touchUp(hit.transform, longTouchTarget, normalizedDistance(touchDistance));
			if (touchDistance.x < -swipeDistance) {
				touchManager.swipeLeft(touchTime, longTouchTarget, hit.transform);
			}
			if (touchDistance.x > swipeDistance) {
				touchManager.swipeRight(touchTime, longTouchTarget, hit.transform);
			}
			if (touchDistance.y < -swipeDistance) {
				touchManager.swipeDown(touchTime, longTouchTarget, hit.transform);
			}
			if (touchDistance.y > swipeDistance) {
				touchManager.swipeUp(touchTime, longTouchTarget, hit.transform);
			}
			longTouchTarget = null;
			if (touchTime < tapTime) {
				touchManager.tap(hit.transform);
			}
			gestureArmed = false;

		}	

} else {

		var touchInput : Touch[] = Input.touches;
	
		if (touchInput.Length > 0) {	
			var touch : Touch = touchInput[0];
			ray = Camera.main.ScreenPointToRay(touch.position);
	
			lastTouchPosition = touchPosition;
			touchPosition = touch.position;

			touchDelta.x = touchPosition.x - lastTouchPosition.x;
			touchDelta.y = touchPosition.y - lastTouchPosition.y;
			touchPosition.z = Camera.main.transform.position.z;
				
	
			if (touch.phase == TouchPhase.Began) {	
				touchDelta = Vector2.zero;
				touchDistance = Vector2.zero;
				touchTime = 0;
				Physics.Raycast(ray, hit);
				touchManager.touchDown(hit.transform, touchPosition);
				longTouchTarget = hit.transform;
				gestureArmed = true;
			}
		
			if (touchInput.Length > 0) {
				Physics.Raycast(ray, hit);
				touchManager.touchDrag(touchDelta, touchDistance, touchPosition, hit.transform, longTouchTarget);
				touchDistance += touchDelta;
				touchTime += Time.deltaTime;
				
				if (gestureArmed) {
					if (touchTime > gestureTime) {
						if (longTouchTarget == hit.transform && (touchDistance.x + touchDistance.y) < 5) {
							touchManager.longTouched(longTouchTarget);
							gestureArmed = false;
						} else {
							touchManager.longTouched(null);
						}
						gestureArmed = false;
					}
				}
			}
				
			if (touch.phase == TouchPhase.Ended) {	
				Physics.Raycast(ray, hit);
				touchManager.touchUp(hit.transform, longTouchTarget, touchDistance);

				if (gestureArmed) {
					touchManager.tap(hit.transform);
					if (touchDistance.x < -swipeDistance) {
						
						if (touchInput.Length > 2) {
							touchManager.sweepLeft();
							return;	
						}
						touchManager.swipeLeft(touchTime, longTouchTarget, hit.transform);
					}
					if (touchDistance.x > swipeDistance) {
						if (touchInput.Length > 2) {
							touchManager.sweepRight();
							return;	
						}
						touchManager.swipeRight(touchTime, longTouchTarget, hit.transform);
					}
					if (touchDistance.y < -swipeDistance) {
						if (touchInput.Length > 2) {
							touchManager.sweepDown();
							return;	
						}						
						touchManager.swipeDown(touchTime, longTouchTarget, hit.transform);
					}
					if (touchDistance.y > swipeDistance) {
						if (touchInput.Length > 2) {
							touchManager.sweepUp();
							return;	
						}						
						touchManager.swipeUp(touchTime, longTouchTarget, hit.transform);
					}
				}
				longTouchTarget = null;
				gestureArmed = false;
			}
		}
	}
	
	if (Input.GetKeyUp(KeyCode.Escape)) {
		touchManager.backPressed();
	}
	if (Input.GetKeyUp(KeyCode.A) || Input.GetKeyUp(KeyCode.Menu)) {
		touchManager.menuPressed();
	}

}


function normalizedDistance(distance : Vector2) : Vector2 {
	var newDistance : Vector2 = Vector2((distance.x/Screen.width), (distance.y/Screen.height));
	return newDistance;
}