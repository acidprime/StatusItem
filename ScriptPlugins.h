//
// ScriptPlugins.h
// StatusItem
//
//  Created by Zack Smith on 8/15/11.
//  Copyright 2011 318. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Constants.h"


@interface ScriptPlugins : NSObject {
	// UI Elements
	IBOutlet NSMenu *statusMenu;

	
	NSBundle *mainBundle;
	NSDictionary *settings;
	NSMutableArray *configScriptArguments;
	NSMutableArray *menuItems;

	BOOL scriptIsRunning;
	BOOL debugEnabled;
}
//void
- (void)readInSettings ;
- (void)waitForLastScriptToFinish;
- (void)addConfigScriptArguments;
- (void)runPluginScripts:(id)sender;
- (void)setFailedEndStatusFromScript:(NSDictionary *)scriptDictionary
						  withError:(NSString *)errorMessage
					   withExitCode:(int)exitStatus
							forMenu:(NSInteger)menuTag
						  controller:(id)sender;

-(void)setStatus:(NSString *)scriptTitle
	 withMessage:(NSString *)scriptDescription 
		 forMenu:(NSInteger)menuTag
	  controller:(id)sender
	 asAlternate:(BOOL)alternate;

-(void)setEndStatusFromScript:(NSDictionary *)scriptDictionary
				   withOutPut:scriptOutput
					  forMenu:(NSInteger)menuTag
				   controller:(id)sender;
// BOOL
- (BOOL)runScript:(NSDictionary *)scriptDictionary
	withArguments:(NSMutableArray *)scriptArguments
		  forMenu:(NSInteger)menuTag
	   controller:(id)sender;

// IBActions
- (IBAction)updatePluginMenus:(id)sender;
@end
