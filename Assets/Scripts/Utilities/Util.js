class Util {
    
    static function Ellipsize(text:String, maxChars:int) {
        if (text.length > maxChars) {
            return text.Substring(0, maxChars) + "...";
        }
        return text;
    }

    static function getDirection(transform1 : Transform, transform2 : Transform) {
		var currentPos : Vector2 = Vector2(transform1.position.x, transform1.position.z);
		var targetPos : Vector2 = Vector2(transform2.position.x, transform2.position.z);
		var direction : float = Vector2.Angle(Vector2.up, (targetPos-currentPos));
		if (currentPos.x > targetPos.x) {
			direction = 360 - direction;
		}
		return direction;
    }
    static function getDirection(point1 : Vector2, point2 : Vector2) {
		var direction : float = Vector2.Angle(Vector2.up, (point2-point1));
		if (point1.x > point2.x) {
			direction = 360 - direction;
		}
		return direction;
    }
     static function getDirection(vector : Vector2) {
		var direction : float = Vector2.Angle(Vector2.up, vector);
		if (vector.x < 0) {
			direction = 360 - direction;
		}
		return direction;
    }
    static function getDirection(vector : Vector3) {
		var direction : float = Vector2.Angle(Vector2.up, Vector2(vector.x, vector.z));
		if (vector.x < 0) {
			direction = 360 - direction;
		}
		return direction;
    }

	static function BallisticVel(launchPoint : Vector3, targetPoint: Vector3): Vector3 {
		var dir = targetPoint - launchPoint; // get target direction
		dir.y = 0;  // retain only the horizontal direction
		var dist = dir.magnitude ;  // get horizontal distance
		dir.y = dist;  // set elevation to 45 degrees
		var vel = Mathf.Sqrt(dist * Physics.gravity.magnitude);
		return vel * dir.normalized;  // returns Vector3 velocity
	}    
    
 	static function secondsToTime(allSeconds : int) {
 	 	var hoursInt : int = Mathf.Floor(allSeconds / 3600);
		var minutesInt : int = Mathf.Floor((allSeconds - (hoursInt * 3600))/60);
	 	var minutesString : String = minutesInt + '';
	 	var hoursString : String;
		if (hoursInt > 0) {
			hoursString = hoursInt + ':';
			while (minutesString.length < 2) {minutesString = '0' + minutesString;}
		} else {
			hoursString = '';
		}

		allSeconds -= ((hoursInt * 3600) + (minutesInt * 60));
		var secondsString : String = allSeconds + '';
		while (secondsString.length < 2) {secondsString = '0' + secondsString;}

		return hoursString + minutesString + ':' + secondsString;
 	}
 	
	static function intToWords(number : int) : String {
		var prefix : String;
		var suffix : String;
		var numberString : String;
        var max_size : int = Mathf.Pow(10,9);
        if (!number || number == 0) return "zero";
        if (number < Mathf.Abs(max_size)) {    
        	if (number < 20) {        
	            switch (number) {
	                // set up some rules for converting digits to words
	                case 1:
	                    numberString = "one";
	                    break;
	                case 2:
	                    numberString = "two";
	                    break;
	                case 3:
	                    numberString = "three";
	                    break;
	                case 4: 
	                    numberString = "four";
	                    break;
	                case 5:
	                    numberString = "five";
	                    break;
	                case 6:
	                    numberString = "six";
	                    break;
	                case 7:
	                    numberString = "seven";
	                    break;
	                case 8:
	                    numberString = "eight";
	                    break;
	                case 9:
	                    numberString = "nine";
	                    break;                
	                case 10:
	                    numberString = "ten";
	                    break;            
	                case 11:
	                    numberString = "eleven";
	                    break;            
	                case 12:
	                    numberString = "twelve";
	                    break;            
	                case 13:
	                    numberString = "thirteen";
	                    break;            
	                case 13:
	                    numberString = "thirteen";
	                    break; 
	                case 15:
	                    numberString = "fifteen";
	                    break;            
	                default:
	                    print ("less than 20");
	                    numberString = intToWords(number%10);
	                    // eighteen only has one "t"
	                    if (number == 18) {
	                    suffix = "een";
	                    } else {
	                    suffix = "teen";
	                    }
	                    numberString += suffix;
	                    break; 
	            }
			} else if (number < 100) {   
				switch (number) {
	                case 20:
	                    numberString = "twenty";
	                    break;            
	                case 30:
	                    numberString = "thirty";
	                    break;            
	                case 40:
	                    numberString = "forty";
	                    break;            
	                case 50:
	                    numberString = "fifty";
	                    break;            
	                case 60:
	                    numberString = "sixty";
	                    break;            
	                case 70:
	                    numberString = "seventy";
	                    break;            
	                case 80:
	                    numberString = "eighty";
	                    break;            
	                case 90:
	                    numberString = "ninety";
	                    break;                
	                default:
	                    prefix = intToWords(number-number%10);
	                    suffix = intToWords(number%10);
	                    numberString = prefix + "-" + suffix;
	                    break;
				}
            } else if (number < Mathf.Pow(10,3)) {
                   prefix = intToWords(Mathf.Floor(number/Mathf.Pow(10,2))) + " hundred";
                   if (number%Mathf.Pow(10,2)) suffix = " and " + intToWords(number%Mathf.Pow(10,2));
                   numberString = prefix + suffix;
            } else if (number < Mathf.Pow(10,6)) {
                   prefix = intToWords(Mathf.Floor(number/Mathf.Pow(10,3))) + " thousand";
                   if (number%Mathf.Pow(10,3)) suffix = intToWords(number%Mathf.Pow(10,3));
                   numberString = prefix + " " + suffix;
            } else if (number < Mathf.Pow(10,9)) {
                   prefix = intToWords(Mathf.Floor(number/Mathf.Pow(10,6))) + " million";
                   if (number%Mathf.Pow(10,6)) suffix = intToWords(number%Mathf.Pow(10,6));
                   numberString = prefix + " " + suffix;
            } else if (number < Mathf.Pow(10,12)) {
                   prefix = intToWords(Mathf.Floor(number/Mathf.Pow(10,9))) + " billion";
                   if (number%Mathf.Pow(10,9)) suffix = intToWords(number%Mathf.Pow(10,9));
                   numberString = prefix + " " + suffix;    
            } else if (number < Mathf.Pow(10,15)) {
                   prefix = intToWords(Mathf.Floor(number/Mathf.Pow(10,12))) + " trillion";
                   if (number%Mathf.Pow(10,12)) suffix = intToWords(number%Mathf.Pow(10,12));
                   numberString = prefix + " " + suffix;    
            }                   
        } else {
            print("error");
        }
        return numberString;    
    }    
}
