//
//  StatusItemAppDelegate.m
//  StatusItem
//
//  Created by Zack Smith on 11/3/11.
//  Copyright 2011 318. All rights reserved.
//

#import "StatusItemAppDelegate.h"
#import "Constants.h"
#import "ScriptPlugins.h"
#import "RunAppleScript.h"

@class ScriptPlugins;


@implementation StatusItemAppDelegate

@synthesize window;
//Delegate Methods
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

//Overrides
-(id)init
{
    [ super init];
	// Set our mainBundle
	mainBundle = [NSBundle bundleForClass:[self class]];
	// Read in our Settings
	[ self readInSettings];
	// Grab our Debug Variable
	debugEnabled = [[ settings objectForKey:@"debugEnabled"] boolValue];
	
	// Load Our Plugins
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pluginsHaveLoaded:) 
                                                 name:PluginsHaveLoadedNotification
                                               object:nil];
	plugins	= [[ ScriptPlugins alloc] init];
	
	

	
	// and Return
	if (!self) return nil;
    return self;

}
- (void)awakeFromNib 
{
	// Load the Status Item
	[self createStatusItem];
	scriptTimer = [[NSTimer scheduledTimerWithTimeInterval:[[settings objectForKey:@"scriptTimer"] intValue]
														target:self
													  selector:@selector(updateScriptsOnInterval)
													  userInfo:nil
													   repeats:YES]retain];
	[scriptTimer fire];
	// Setup our applescript controller
	if (!appleScript) {
		appleScript = [[RunAppleScript alloc] init];
	}

}

//Our Methods



- (void)readInSettings 
{ 	
	NSString *settingsPath = [mainBundle pathForResource:MySettingsFileResourceID
												  ofType:@"plist"];
	settings = [[NSDictionary alloc] initWithContentsOfFile:settingsPath];
}

- (void)createStatusItem 
{ 
	// Setup our status Item
	statusItem = [[[NSStatusBar systemStatusBar] 
				   statusItemWithLength:NSVariableStatusItemLength] retain];
	[statusItem setHighlightMode:YES]; 
	// We set as not enabled until the plugins have loaded.
	[statusItem setEnabled:NO]; 
	[statusItem setToolTip:[settings objectForKey:@"toolTip"]];
	[statusItem setMenu:statusMenu];
	
	 // Update the menu text (if any) and set the icon
	[self updateMenuText];
	[self setMenuIcon];
}

- (void)updateMenuText
{ 
	NSColor *fontColor = [NSColor blackColor];
	NSDictionary *attrsDictionary =
	[NSDictionary dictionaryWithObject:fontColor 
								forKey:NSForegroundColorAttributeName];
	
	NSString *statusItemTitle = MyStatusText;
	
    NSAttributedString *statusItemTitleWithColor = [[NSAttributedString alloc] 
													initWithString:statusItemTitle
													attributes:attrsDictionary];
	
	[statusItem setAttributedTitle:statusItemTitleWithColor];
}

- (void)setMenuIcon
{ 
	NSString *path = [mainBundle pathForResource:MyLogo
										  ofType:@"png"]; 
	menuIcon= [[NSImage alloc] initWithContentsOfFile:path];
	[statusItem setImage:menuIcon];

}

-(NSInteger)addPluginMenuHeader:(NSString *)myTitle
{
	if(debugEnabled) NSLog(@"DEBUG: Adding Menu Header: %@",myTitle);
	NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:myTitle
												  action:@selector(headerMenuClicked:)
										   keyEquivalent:@""]; 
	
	// Check where our Updates menu is and add below
	updateMenuIndex = [statusMenu indexOfItem:pluginsPlaceHolder];
	NSInteger menuIndex = updateMenuIndex;
	if(debugEnabled) NSLog(@"DEBUG: Found Plugin Place holder at Index of %d",menuIndex);
	
	// Check if the current index already exists
	if (!currentMenuIndex){
		// Find one place above th quit menu option.
		if (menuIndex > 0) {
			menuIndex = menuIndex -1;
		}
		currentMenuIndex = menuIndex;
		if(debugEnabled) NSLog(@"DEBUG: Found Menu Index of %d",menuIndex);
	}
	// Insert the header
	[statusMenu insertItem:item atIndex:currentMenuIndex];	
	
	NSInteger menuTag = menuTag + 1 * MyHeaderMenuTag;
	//NSInteger sepTag = menuTag + 1;

	// Set the Menu Tag
	NSMenuItem *myMenuItem = [ statusMenu itemAtIndex:currentMenuIndex];
	[myMenuItem setTag:menuTag];
	return menuTag;
}

-(NSInteger)addPluginMenuChild:(NSString *)myTitle
				   withToolTip:(NSString *)myToolTip
				   asAlternate:(BOOL)alternate
{
	if(debugEnabled) NSLog(@"DEBUG: Adding Menu Header: %@",myTitle);
	NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:myTitle
												  action:NULL keyEquivalent:@""]; 
	
	// Check where our Updates menu is and add below
	updateMenuIndex = [statusMenu indexOfItem:quitMenuItem];
	NSInteger menuIndex = updateMenuIndex;
	if(debugEnabled) NSLog(@"DEBUG: Found Updates at Index of %d",menuIndex);
	
	// Check if the current index already exists
	if (!currentMenuIndex){
		// Find one place above the repair menu option.
		menuIndex = menuIndex -1;
		currentMenuIndex = menuIndex;
		if(debugEnabled) NSLog(@"Found Menu Index of %d",menuIndex);
		
	}
	[statusMenu insertItem:item atIndex:currentMenuIndex + 1];
	// Set Our Tag 100+ are Child Menu Items
	NSInteger menuTag = menuTag + 1 * MyChildMenuTag;
	[item setTag:menuTag];
	[item setToolTip:myToolTip];
	if(debugEnabled)NSLog(@"Checking is menu:%@ is alternate:%d",myTitle,alternate);
	if (alternate) {
		if(debugEnabled)NSLog(@"Was told YES menu: %@ is alternate: %d",myTitle,alternate);
		[ item setKeyEquivalent:@""];
		[ item setAlternate:YES];
		[ item setKeyEquivalentModifierMask:NSAlternateKeyMask];
	}
	// Add The Seperator
	if (currentMenuIndex == 1) {
		NSInteger sepTag = sepTag + 1 * MyChildMenuTag;
		NSInteger seperatorIndex = [statusMenu indexOfItem:[ statusMenu itemAtIndex:currentMenuIndex]] +1;
		[statusMenu insertItem:[NSMenuItem separatorItem] atIndex:seperatorIndex];
		[[statusMenu itemAtIndex:seperatorIndex] setTag:sepTag];
		currentMenuIndex = currentMenuIndex +1;
	}

	return menuTag;
}

- (void) pluginsHaveLoaded:(NSNotification *) notification
{
	// Enable the Status Menu now that plugins have loaded
	[statusItem setEnabled:YES];	
}

- (IBAction)headerMenuClicked:(id)sender
{
	// Post notification
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:RequestAppleScriptNotification
	 object:self];
}

-(void)updateScriptsOnInterval
{
	// This is kind of lame  way to do this but It works
	NSArray * menuItems = [ statusMenu itemArray];
	for (NSMenuItem *menuItem in menuItems){
		if ([menuItem respondsToSelector:@selector(tag)]) {
			NSInteger menuTag = [menuItem tag];
			if (menuTag >= MyHeaderMenuTag) {
				currentMenuIndex = 1;
				[statusMenu removeItem:[statusMenu itemWithTag:menuTag]];
			}

		}
		
	}
	[plugins runPluginScripts:self];

}


@end
