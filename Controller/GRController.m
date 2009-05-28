// GRController.m
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Monochrome Industries

#import "GRApplicationUIElement.h"
#import "GRAreaSelectionView.h"
#import "GRController.h"
#import "GRWindowController.h"
#import "GRWindowUIElement.h"
#import <Carbon/Carbon.h>

OSStatus GRControllerShortcutWasPressed(EventHandlerCallRef nextHandler, EventRef event, void *userData);

@interface GRController () <GRWindowControllerDelegate>

@property GRWindowUIElement *windowElement;

@end

@implementation GRController

@synthesize windowElement;

-(void)awakeFromNib {
	NSMutableArray *tempControllers = [NSMutableArray array];
	for(NSScreen *screen in [NSScreen screens]) {
		GRWindowController *controller = [GRWindowController controllerWithScreen: screen];
		controller.delegate = self;
		[tempControllers addObject: controller];
	}
	controllers = tempControllers;
	
	EventTypeSpec eventType = {
		.eventClass = kEventClassKeyboard,
		.eventKind = kEventHotKeyPressed
	};
	InstallApplicationEventHandler(&GRControllerShortcutWasPressed, 1, &eventType, self, NULL);
	
	EventHotKeyID shortcutIdentifier = {
		.id = 1,
		.signature = 'GRSc'
	};
	EventHotKeyRef shortcutReference;
	RegisterEventHotKey(50, cmdKey+optionKey, shortcutIdentifier, GetApplicationEventTarget(), 0, &shortcutReference);
}


-(void)activate {
	[controllers makeObjectsPerformSelector: @selector(activate)];
}

-(void)deactivate {
	[controllers makeObjectsPerformSelector: @selector(deactivate)];
}


-(void)applicationDidResignActive:(NSNotification *)notification {
	[self deactivate];
}


-(void)windowController:(GRWindowController *)controller didSelectArea:(CGRect)selectedArea {
	selectedArea.origin.y = NSHeight(controller.screen.frame) - NSHeight(selectedArea) - selectedArea.origin.y;
	NSLog(@"Resizing to %@ within %@.", NSStringFromRect(selectedArea), NSStringFromRect(controller.screen.visibleFrame));
	self.windowElement.frame = selectedArea;
}

@end


OSStatus GRControllerShortcutWasPressed(EventHandlerCallRef nextHandler, EventRef event, void *userData) {
	GRController *controller = (GRController *)userData;
	
	GRWindowUIElement *windowElement = [GRApplicationUIElement focusedApplication].mainWindow;
	if(windowElement) {
		controller.windowElement = windowElement;
		[controller activate];
	} else {
		[controller deactivate];
	}
	
	return noErr;
}