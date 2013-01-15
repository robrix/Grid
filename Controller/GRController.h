// GRController.h
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Rob Rix

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

@class HAXWindow, SRRecorderControl;

@interface GRController : NSObject {
	NSArray *_controllers;
	NSUInteger _activeControllerIndex;
	HAXWindow *_windowElement;
}

-(IBAction)nextController:(id)sender;
-(IBAction)previousController:(id)sender;

@end
