//
//  RunAppleScript.h
//  StatusItem
//
//  Created by Zack Smith on 7/20/11.
//  Copyright 2011 318. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Constants.h"


@interface RunAppleScript : NSObject {
	// Reference to this bundle
	NSBundle *mainBundle;
	IBOutlet NSWindow *window;
	NSDictionary *settings;

}

- (void)runAppleScript;
- (void)runAppleScriptTask;
- (void)readInSettings;
- (void)displayDialog:(NSString *)message;
@end
