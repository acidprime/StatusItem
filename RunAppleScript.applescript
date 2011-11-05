-- AttemptToRepair.applescript

-- Created by Zack Smith @acidprime on 7/21/11.
--  Copyright 2011 318. All rights reserved.

property returnValue : ""
-- All Repairs completed successfully

script AttemptToRepair
	display dialog "This is a crappy AppleScript Dialog"
	do shell script "echo \"Apple Script ran this shell code!\" | /usr/bin/open -f"
	set returnValue to "Look in RunAppleScript.applescript to change this message"
end script
run AttemptToRepair
return returnValue