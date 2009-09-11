// GRController.h
// Created by Rob Rix on 2009-05-25
// Copyright 2009 Monochrome Industries

@class GRWindowUIElement;

@interface GRController : NSObject {
	NSArray *controllers;
	NSUInteger activeControllerIndex;
	GRWindowUIElement *windowElement;
}

-(IBAction)nextController:(id)sender;
-(IBAction)previousController:(id)sender;

@end