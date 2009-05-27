// GRWindowController.m
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Monochrome Industries

#import "GRWindowController.h"

@implementation GRWindowController

+(GRWindowController *)controllerWithScreen:(NSScreen *)s {
	GRWindowController *controller = [[self alloc] initWithWindowNibName: @"GRWindow"];
	[controller loadWindow];
	controller.screen = s;
	return controller;
}

@synthesize screen;

-(void)awakeFromNib {
	[self.window setExcludedFromWindowsMenu: NO];
	[self.window setCollectionBehavior: NSWindowCollectionBehaviorCanJoinAllSpaces];
}


-(void)showWindow:(id)sender {
	self.window.alphaValue = 0;
	[self.window setFrameOrigin: NSMakePoint(NSMinX(self.screen.visibleFrame), self.window.frame.origin.y)];
	[super showWindow: sender];
	[self.window center];
	
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration: 0.15];
	[self.window.animator setAlphaValue: 1.0];
	[NSAnimationContext endGrouping];
}

-(void)hideWindow:(id)sender {
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration: 0.15];
	[self.window.animator setAlphaValue: 0];
	[NSAnimationContext endGrouping];
}


-(NSUInteger)maximumHorizontalFractions {
	return 6;
}

-(NSUInteger)maximumVerticalFractions {
	return 3;
}


-(NSUInteger)horizontalSelectedFractionIndex {
	return NSMakeRange(0, 0);
}

-(NSUInteger)verticalSelectedFractionIndex {
	return NSMakeRange(0, 0);
}


-(NSUInteger)horizontalSelectedFractionLevel {
	return 3;
}

-(NSUInteger)verticalSelectedFractionLevel {
	return 2;
}

@end