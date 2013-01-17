// GRController.m
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Rob Rix

#import "GRAreaSelectionView.h"
#import "GRController.h"
#import "GRPreferencesController.h"
#import "GRWindowController.h"
#import <Carbon/Carbon.h>
#import <Haxcessibility/Haxcessibility.h>
#import "SRCommon.h"
#import "SRKeyCodeTransformer.h"
#import "SRValidator.h"
#import "SRRecorderCell.h"
#import "SRRecorderControl.h"

@interface GRController () <GRWindowControllerDelegate, NSApplicationDelegate>

@property (nonatomic, strong) HAXWindow *windowElement;

-(void)shortcutKeyWasPressed:(NSNotification *)notification;

-(void)activate;
-(void)deactivate;

@property (nonatomic, assign) NSUInteger activeControllerIndex;

@property (nonatomic, copy) NSArray *controllers;

@end

@implementation GRController

@synthesize windowElement = _windowElement;
@synthesize activeControllerIndex = _activeControllerIndex;
@synthesize controllers = _controllers;


-(void)awakeFromNib {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shortcutKeyWasPressed:) name:GRShortcutWasPressedNotification object:nil];
	
	NSMutableArray *tempControllers = [NSMutableArray array];
	for(NSScreen *screen in [NSScreen screens]) {
		GRWindowController *controller = [GRWindowController controllerWithScreen:screen];
		controller.delegate = self;
		[tempControllers addObject:controller];
	}
	self.controllers = tempControllers;
}

-(void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:GRShortcutWasPressedNotification object:nil];
	[super dealloc];
}


-(NSUInteger)indexOfWindowControllerForWindowElementWithFrame:(CGRect)frame {
	CGPoint topLeft = CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame));
	NSUInteger result = 0;
	NSUInteger index = 0;
	for(GRWindowController *controller in self.controllers) {
		if(CGRectContainsPoint(controller.screen.frame, topLeft)) {
			result = index;
			break;
		}
		index++;
	}
	return result;
}


-(void)shortcutKeyWasPressed:(NSNotification *)notification {
	if (self.windowElement) {
		[self deactivate];
	} else {
		if ((self.windowElement = [HAXSystem system].focusedApplication.focusedWindow)) {
			CGRect frame = self.windowElement.frame;
			[self activate];
			self.activeControllerIndex = [self indexOfWindowControllerForWindowElementWithFrame:frame];
		} else {
			[self deactivate];
		}
	}
}


-(void)activate {
	[self.controllers makeObjectsPerformSelector:@selector(activate)];
}

-(void)deactivate {
	[self.controllers makeObjectsPerformSelector:@selector(deactivate)];
	self.windowElement = nil;
}


-(void)setActiveControllerIndex:(NSUInteger)index {
	_activeControllerIndex = index;
	[[self.controllers objectAtIndex:self.activeControllerIndex] showWindow:nil]; // focus on the active screen (by default, the one the window is on; can be switched with ⌘` and ⇧⌘`)
}


-(void)applicationDidResignActive:(NSNotification *)notification {
	[self deactivate];
}


-(void)windowController:(GRWindowController *)controller didSelectArea:(CGRect)selectedArea {
	selectedArea.origin.y = NSHeight(controller.screen.frame) - NSHeight(selectedArea) - selectedArea.origin.y; // flip the selected area
	self.windowElement.frame = selectedArea;
}


-(IBAction)nextController:(id)sender {
	self.activeControllerIndex = (self.activeControllerIndex + 1) % self.controllers.count;
}

-(IBAction)previousController:(id)sender {
	self.activeControllerIndex = (self.activeControllerIndex > 0)?
		self.activeControllerIndex - 1
	:	self.controllers.count - 1;
}

@end
