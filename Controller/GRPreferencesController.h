//
//  GRPreferencesController.h
//  Grid
//
//  Created by Rob Rix on 11-09-27.
//  Copyright 2011 Rob Rix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

extern NSString * const GRShortcutWasPressedNotification;

@class SRRecorderControl;

@interface GRPreferencesController : NSWindowController {
	NSView *shortcutView;
	SRRecorderControl *shortcutRecorder;
	EventHotKeyRef shortcutReference;
}

@property (nonatomic, assign) IBOutlet NSView *shortcutView;

@property (nonatomic, assign) BOOL showDockIcon;

@end
