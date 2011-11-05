//
//  Constants.h
//  StatusItem
//
//  Created by Zack Smith on 8/22/11.
//  Copyright 2011 318. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//String Constants
extern NSString * const MySettingsFileResourceID;
extern NSString * const MyLogo;
extern NSString * const MyStatusText;
extern NSString * const MyScriptEndTitle;
extern NSString * const MyAppleScriptFile;

// Menu Tags
extern NSInteger const MyChildMenuTag;
extern NSInteger const MyHeaderMenuTag;

//Script Plugin Notification String Constants
extern NSString * const PluginsHaveLoadedNotification;
extern NSString * const RequestAppleScriptNotification;
extern NSString * const CompletedAppleScriptNotification;
@interface Constants : NSWindowController {
	
}

@end
