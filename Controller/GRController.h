// GRController.h
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Monochrome Industries

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

@class GRWindowUIElement, SRRecorderControl;

@interface GRController : NSObject {
	NSArray *controllers;
	NSUInteger activeControllerIndex;
	GRWindowUIElement *windowElement;
	
	IBOutlet SRRecorderControl *shortcutRecorder;
	EventHotKeyRef shortcutReference;
}

-(IBAction)nextController:(id)sender;
-(IBAction)previousController:(id)sender;

@property (nonatomic, retain) NSDictionary *shortcut;

@end
