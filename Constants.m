//
//  Constants.m
//  StatusItem
//
//  Created by Zack Smith on 11/3/11.
//  Copyright 2011 318. All rights reserved.
//

#import "Constants.h"


@implementation Constants
NSString * const MySettingsFileResourceID = @"settings";
NSString * const MyLogo = @"menuLogo";
NSString * const MyStatusText = @"";
NSString * const MyAppleScriptFile = @"RunAppleScript";
NSString * const MyScriptEndTitle = @"AppleScript Completed (Constants.m)";
// Menu Tags
NSInteger const MyChildMenuTag = 2000;
NSInteger const MyHeaderMenuTag = 1000;

//Script Plugin Notifications
NSString * const PluginsHaveLoadedNotification = @"PluginsHaveLoadedNotification";
NSString * const RequestAppleScriptNotification = @"RequestAppleScriptNotification";
NSString * const CompletedAppleScriptNotification = @"CompletedAppleScriptNotification";

@end
