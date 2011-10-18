// GRController.m
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Monochrome Industries

#import "GRAreaSelectionView.h"
#import "GRController.h"
#import "GRPreferencesController.h"
#import "GRWindowController.h"
#import <Carbon/Carbon.h>
#import <ShortcutRecorder/ShortcutRecorder.h>
#import <Haxcessibility/Haxcessibility.h>

@interface GRController () <GRWindowControllerDelegate, NSApplicationDelegate>

@property HAXWindow *windowElement;

-(void)shortcutKeyWasPressed:(NSNotification *)notification;

-(void)activate;
-(void)deactivate;

@property (nonatomic) NSUInteger activeControllerIndex;

@end

@implementation GRController

@synthesize windowElement, activeControllerIndex;


-(void)awakeFromNib {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shortcutKeyWasPressed:) name:GRShortcutWasPressedNotification object:nil];
	
	NSMutableArray *tempControllers = [NSMutableArray array];
	for(NSScreen *screen in [NSScreen screens]) {
		GRWindowController *controller = [GRWindowController controllerWithScreen:screen];
		controller.delegate = self;
		[tempControllers addObject:controller];
	}
	controllers = tempControllers;
}


-(NSUInteger)indexOfWindowControllerForWindowElementWithFrame:(CGRect)frame {
	CGPoint topLeft = CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame));
	NSUInteger result = 0;
	NSUInteger index = 0;
	for(GRWindowController *controller in controllers) {
		if(CGRectContainsPoint(controller.screen.frame, topLeft)) {
			result = index;
			break;
		}
		index++;
	}
	return result;
}


-(void)shortcutKeyWasPressed:(NSNotification *)notification {
	if((self.windowElement = [HAXSystem system].focusedApplication.focusedWindow)) {
		CGRect frame = self.windowElement.frame;
		[self activate];
		self.activeControllerIndex = [self indexOfWindowControllerForWindowElementWithFrame:frame];
	} else {
		[self deactivate];
	}
}


-(void)activate {
	[controllers makeObjectsPerformSelector: @selector(activate)];
}

-(void)deactivate {
	[controllers makeObjectsPerformSelector: @selector(deactivate)];
}


-(void)setActiveControllerIndex:(NSUInteger)index {
	activeControllerIndex = index;
	[[controllers objectAtIndex: activeControllerIndex] showWindow: nil]; // focus on the active screen (by default, the one the window is on; can be switched with ⌘` and ⇧⌘`)
}


-(void)applicationDidResignActive:(NSNotification *)notification {
	[self deactivate];
}


-(void)windowController:(GRWindowController *)controller didSelectArea:(CGRect)selectedArea {
	selectedArea.origin.y = NSHeight(controller.screen.frame) - NSHeight(selectedArea) - selectedArea.origin.y; // flip the selected area
	self.windowElement.frame = selectedArea;
}


-(IBAction)nextController:(id)sender {
	self.activeControllerIndex = (activeControllerIndex + 1) % controllers.count;
}

-(IBAction)previousController:(id)sender {
	self.activeControllerIndex = (activeControllerIndex > 0)?
		activeControllerIndex - 1
	:	controllers.count - 1;
}

@end
