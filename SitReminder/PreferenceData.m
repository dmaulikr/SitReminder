//
//  PreferenceData.m
//  SitReminder
//
//  Created by silentcloud on 8/17/14.
//  Copyright (c) 2014 silentcloud. All rights reserved.
//

#import "PreferenceData.h"

NSString * const SRLaunchAtLoginKey = @"SRLaunchAtLoginKey";
NSString * const SRCountTimeKey = @"SRCountTimeKey";

@implementation PreferenceData

+ (void)load
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:SRLaunchAtLoginKey]) {
        [defaults  setObject:@NO forKey:SRLaunchAtLoginKey];
    }
    if (![defaults objectForKey:SRCountTimeKey] || [[defaults objectForKey:SRCountTimeKey] intValue] == 0) {
        [defaults  setObject:@60 forKey:SRCountTimeKey];
    }
}

+ (BOOL)preferenceLaunchAtLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isLaunchAtLogin = [[defaults objectForKey:SRLaunchAtLoginKey] boolValue];
    return isLaunchAtLogin;
}

+ (void)setPreferenceLaunchAtLogin:(BOOL)isLaunchAtLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:isLaunchAtLogin] forKey:SRLaunchAtLoginKey];
}

+ (NSNumber *)preferenceCountDownTime
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *countDownTime = [defaults objectForKey:SRCountTimeKey];
    return countDownTime;
}

+ (void)setPreferenceCountDownTime:(NSNumber *)countDownTime
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:countDownTime forKey:SRCountTimeKey];
}

@end
