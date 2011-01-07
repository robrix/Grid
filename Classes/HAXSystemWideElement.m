// HAXSystemWideElement.m
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Monochrome Industries

#import "HAXApplicationElement.h"
#import "HAXSystemWideElement.h"
#import "HAXElement+Protected.h"

@implementation HAXSystemWideElement

+(HAXSystemWideElement *)element {
	return [self elementWithElementRef:CFMakeCollectable(AXUIElementCreateSystemWide())];
}


-(HAXApplicationElement *)focusedApplication {
	AXError error = kAXErrorSuccess;
	return [HAXApplicationElement elementWithElementRef:[self elementRefForKey:(NSString *)kAXFocusedApplicationAttribute error:&error]];
}

@end
