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
extern NSString * const GRShortcutKey;

@class SRRecorderControl;

@interface GRPreferencesController : NSWindowController

@property (nonatomic, assign) BOOL showDockIcon;

@end
