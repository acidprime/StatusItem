//
//  StatusItemAppDelegate.h
//  StatusItem
//
//  Created by Zack Smith on 11/3/11.
//  Copyright 2011 318. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Constants.h"
#import "ScriptPlugins.h"

@class ScriptPlugins;
@class RunAppleScript;


@interface StatusItemAppDelegate : NSObject <NSApplicationDelegate> {
	// Our outlets
	IBOutlet NSMenu *statusMenu;
	IBOutlet NSMenuItem *pluginsPlaceHolder;
	IBOutlet NSMenuItem *quitMenuItem;
	
    NSWindow *window;
	NSStatusItem *statusItem;
	NSImage *menuIcon;
	NSBundle *mainBundle;
	NSDictionary *settings;
	NSTimer *scriptTimer;
	
	BOOL debugEnabled;
	
	// Used for Keeping track of the menu for plugins
	NSInteger currentMenuIndex;
	NSInteger updateMenuIndex; 
	// Our custo classes
	ScriptPlugins *plugins;
	RunAppleScript *appleScript;


}

@property (assign) IBOutlet NSWindow *window;
- (void)createStatusItem;
- (void)updateMenuText;
- (void)setMenuIcon;
- (void)readInSettings;

// Plugin Methods
- (NSInteger)addPluginMenuHeader:(NSString *)myTitle;
- (NSInteger)addPluginMenuChild:(NSString *)myTitle
					withToolTip:(NSString *)myToolTip
					asAlternate:(BOOL)alternate;
- (void) pluginsHaveLoaded:(NSNotification *) notification;
- (IBAction)headerMenuClicked:(id)sender;


@end
