// GRController.m
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Monochrome Industries

#import "GRAreaSelectionView.h"
#import "GRController.h"
#import "GRWindowController.h"

@implementation GRController

-(void)awakeFromNib {
	[NSApplication sharedApplication].delegate = self;
	
	NSMutableArray *tempControllers = [NSMutableArray array];
	for(NSScreen *screen in [NSScreen screens]) {
		GRWindowController *controller = [GRWindowController controllerWithScreen: screen];
		[tempControllers addObject: controller];
	}
	controllers = tempControllers;
	// [controllers makeObjectsPerformSelector: @selector(showWindow:) withObject: nil];
}

-(void)applicationDidBecomeActive:(NSNotification *)notification {
	[controllers makeObjectsPerformSelector: @selector(showWindow:) withObject: nil];
}

-(void)applicationDidResignActive:(NSNotification *)notification {
	[controllers makeObjectsPerformSelector: @selector(hideWindow:) withObject: nil];
}

@end