//
//  PreferenceData.h
//  SitReminder
//
//  Created by silentcloud on 8/17/14.
//  Copyright (c) 2014 silentcloud. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SRLaunchAtLoginKey;
extern NSString * const SRCountTimeKey;

@interface PreferenceData : NSObject

+ (BOOL)preferenceLaunchAtLogin;
+ (void)setPreferenceLaunchAtLogin:(BOOL)isLaunchAtLogin;
+ (NSNumber *)preferenceCountDownTime;
+ (void)setPreferenceCountDownTime:(NSNumber *)countDownTime;

@end
