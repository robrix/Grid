// GRController.m
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Monochrome Industries

#import "GRAreaSelectionView.h"
#import "GRController.h"
#import "GRWindowController.h"
#import <Carbon/Carbon.h>

OSStatus GRControllerShortcutWasPressed(EventHandlerCallRef nextHandler, EventRef event, void *userData);

@implementation GRController

-(void)awakeFromNib {
	NSMutableArray *tempControllers = [NSMutableArray array];
	for(NSScreen *screen in [NSScreen screens]) {
		GRWindowController *controller = [GRWindowController controllerWithScreen: screen];
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

@end


OSStatus GRControllerShortcutWasPressed(EventHandlerCallRef nextHandler, EventRef event, void *userData) {
	GRController *controller = (GRController *)userData;
	[controller activate];
	return noErr;
}