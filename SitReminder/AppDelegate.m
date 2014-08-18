//
//  AppDelegate.m
//  SitReminder
//
//  Created by silentcloud on 8/15/14.
//  Copyright (c) 2014 silentcloud. All rights reserved.
//

#import "AppDelegate.h"
#import "PreferenceData.h"

@interface AppDelegate () <NSWindowDelegate>
{
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSTimer *_countTimer;
    NSTimer *_idleTimer;
    BOOL _isRuning;
    IBOutlet NSMenuItem *toggleItem;
    IBOutlet NSButton *_launchCheckBox;
    IBOutlet NSTextField *_timeField;
    NSTimeInterval _timer;
}
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)awakeFromNib
{
    statusItem = [[NSStatusBar systemStatusBar]
                   statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setEnabled:YES];
    [statusItem setToolTip:@"SitReminder"];
    [statusItem setMenu:statusMenu];
    [statusItem setTarget:self];
    [statusItem setHighlightMode:YES];
    [statusItem setImage:[NSImage imageNamed:@"status-icon"]];
    
    [toggleItem setOffStateImage:nil];
    [toggleItem setImage:[NSImage imageNamed:@"reminder_on"]];
    BOOL isLaunchAtLogin = [PreferenceData preferenceLaunchAtLogin];
    [_launchCheckBox setState:isLaunchAtLogin ? 1 : 0];
    NSNumber *countDownTime = [PreferenceData preferenceCountDownTime];
    [_timeField setIntValue:[countDownTime intValue]];
    _timer = [countDownTime intValue] * 60;
}

- (IBAction)showMainWindow:(id)sender
{
    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:nil];
}

- (IBAction)exitApplication:(id)sender
{
    [NSApp terminate:nil];
}

- (IBAction)showAbout:(id)sender
{
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:nil];
}

- (IBAction)toggleServiceStatus:(id)sender
{
    if (_isRuning) {
        [self stopTimeCountDown];
    } else {
        [self startTimeCountDown:_timer];
//        toggleItem.title = NSLocalizedString(@"已启动", nil);
        toggleItem.title = @"已启动";
        toggleItem.image = [NSImage imageNamed:@"reminder_on"];
        _isRuning = YES;
    }
}

- (void)startTimeCountDown:(NSTimeInterval)time
{
    if (_countTimer) {
        [_countTimer invalidate];
        _countTimer = nil;
    }
    _countTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(showReminder) userInfo:nil repeats:NO];
}

- (void)stopTimeCountDown
{
    if (_countTimer) {
        [_countTimer invalidate];
    }
    _countTimer = nil;
//  toggleItem.title = NSLocalizedString(@"已停止", nil);
    toggleItem.title = @"已停止";
    toggleItem.image = [NSImage imageNamed:@"reminder_off"];
    _isRuning = NO;
}

- (CFTimeInterval)getIdleTime
{
    CFTimeInterval idleTime = CGEventSourceSecondsSinceLastEventType(kCGEventSourceStateCombinedSessionState, kCGAnyInputEventType);
    return idleTime;
}

- (void)showReminder
{
    NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"SitReminder 提醒您休息一下吧", nil) defaultButton:NSLocalizedString(@"去休息了",nil) alternateButton:NSLocalizedString(@"停止提醒",nil) otherButton:nil informativeTextWithFormat:NSLocalizedString(@"为了您的身体健康，建议您起来活动活动!", nil)];
    [alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

-(void)alertDidEnd:(NSAlert *)alert returnCode:(int)choice contextInfo:(void *)v
{
    if (choice == NSAlertDefaultReturn) {
        //if within 60 seconds idleTime <= 30 seconds, remind user again to have rest! only once,then start timer
        _idleTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(remindAgain) userInfo:nil repeats:NO];
    } else if (choice ==  NSAlertAlternateReturn){
        //stop timer
        [self stopTimeCountDown];
    }
}

- (void)remindAgain
{
    CFTimeInterval idleTime = CGEventSourceSecondsSinceLastEventType(kCGEventSourceStateCombinedSessionState, kCGAnyInputEventType);
    if (idleTime <= 30) {
        NSRunAlertPanel(@"SitReminder", NSLocalizedString(@"发现你并没有休息或者休息时间太短，建议您注意休息!", nil), NSLocalizedString(@"我知道啦！", nil), nil, nil);
    }
    [_idleTimer invalidate];
    _idleTimer = nil;
    //restart timer, -30 because the idleTimer
    [self startTimeCountDown:(_timer - 30)];
}

- (void)savePreferenceData
{
    [PreferenceData setPreferenceLaunchAtLogin:[_launchCheckBox state] == 1 ? YES : NO];
    [PreferenceData setPreferenceCountDownTime:[NSNumber numberWithInt:[_timeField intValue]]];
    _timer = [_timeField intValue] * 60;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _isRuning = YES;
    [self startTimeCountDown:_timer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [self savePreferenceData];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowWillClose:(NSNotification *)notification
{
    [self savePreferenceData];
}


@end
