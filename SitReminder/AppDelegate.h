//
//  AppDelegate.h
//  SitReminder
//
//  Created by silentcloud on 8/15/14.
//  Copyright (c) 2014 silentcloud. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (IBAction)exitApplication:(id)sender;
- (IBAction)showAbout:(id)sender;
- (IBAction)toggleServiceStatus:(id)sender;
- (IBAction)showMainWindow:(id)sender;

@end

