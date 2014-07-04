//
//  GRPreferencesController.m
//  Grid
//
//  Created by Rob Rix on 11-09-27.
//  Copyright 2011 Rob Rix. All rights reserved.
//

#import "GRPreferencesController.h"
#import <ShortcutRecorder/ShortcutRecorder.h>
#import <PTHotKey/PTHotKey+ShortcutRecorder.h>
#import <PTHotKey/PTHotKeyCenter.h>

NSString * const GRShortcutWasPressedNotification = @"GRShortcutWasPressedNotification";

OSStatus GRShortcutWasPressed(EventHandlerCallRef nextHandler, EventRef event, void *userData);

NSString * const GRShortcutKey = @"GRShortcut";
NSString * const GRShowDockIconKey = @"GRShowDockIcon";

@interface GRPreferencesController () <SRRecorderControlDelegate>

@property (nonatomic, strong) IBOutlet SRRecorderControl *shortcutRecorder;

@property (nonatomic, strong) PTHotKey *hotKey;
@property (nonatomic, copy) NSDictionary *shortcut;

@end

@implementation GRPreferencesController

+(void)initialize {
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
		[NSDictionary dictionaryWithObjectsAndKeys:
			@"`", @"characters",
			[NSNumber numberWithInteger:50], @"keyCode",
			[NSNumber numberWithUnsignedInteger:SRCarbonToCocoaFlags(cmdKey + optionKey)], @"modifierFlags",
		nil], GRShortcutKey,
		(id)kCFBooleanTrue, GRShowDockIconKey,
	nil]];
}


-(void)awakeFromNib {
	self.window.level = NSStatusWindowLevel;
	
	self.shortcutRecorder.objectValue = self.shortcut;
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:GRShowDockIconKey]) {
		ProcessSerialNumber psn = { 0, kCurrentProcess };
		TransformProcessType(&psn, kProcessTransformToForegroundApplication);
	}
	
	if (self.shortcut) {
		self.hotKey = [PTHotKey hotKeyWithIdentifier:GRShortcutKey keyCombo:self.shortcut target:self action:@selector(shortcutWasPressed:)];
		[[PTHotKeyCenter sharedCenter] registerHotKey:self.hotKey];
	}
}


-(IBAction)showWindow:(id)sender {
	[self.window center];
	[[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
	[self.window makeKeyAndOrderFront:self];
	[[NSApplication sharedApplication] arrangeInFront:self];
	[super showWindow:sender];
}


-(void)shortcutWasPressed:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:GRShortcutWasPressedNotification object:nil];
}


-(NSDictionary *)shortcut {
	return [[NSUserDefaults standardUserDefaults] dictionaryForKey:GRShortcutKey];
}

-(void)setShortcut:(NSDictionary *)shortcut {
	[[NSUserDefaults standardUserDefaults] setObject:shortcut forKey:GRShortcutKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[[PTHotKeyCenter sharedCenter] unregisterHotKey:self.hotKey];
	self.hotKey = nil;
	if (shortcut && ![shortcut isEqual:[NSNull null]]) {
		self.hotKey = [PTHotKey hotKeyWithIdentifier:GRShortcutKey keyCombo:shortcut target:self action:@selector(shortcutWasPressed:)];
		[[PTHotKeyCenter sharedCenter] registerHotKey:self.hotKey];
	}
}


-(BOOL)showDockIcon {
	return [[NSUserDefaults standardUserDefaults] boolForKey:GRShowDockIconKey];
}

-(void)setShowDockIcon:(BOOL)showDockIcon {
	[[NSUserDefaults standardUserDefaults] setBool:showDockIcon forKey:GRShowDockIconKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


-(BOOL)shortcutRecorderShouldBeginRecording:(SRRecorderControl *)aRecorder {
	[[PTHotKeyCenter sharedCenter] pause];
	return YES;
}

-(void)shortcutRecorderDidEndRecording:(SRRecorderControl *)recorder {
	self.shortcut = recorder.objectValue;
	[[PTHotKeyCenter sharedCenter] resume];
}

@end

