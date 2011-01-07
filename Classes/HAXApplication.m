// HAXApplication.m
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Monochrome Industries

#import "HAXApplication.h"
#import "HAXElement+Protected.h"
#import "HAXWindowElement.h"

@implementation HAXApplication

/*
#define kAXMenuBarAttribute                     CFSTR("AXMenuBar")
#define kAXWindowsAttribute                     CFSTR("AXWindows")
#define kAXFrontmostAttribute                   CFSTR("AXFrontmost")
#define kAXHiddenAttribute                      CFSTR("AXHidden")
#define kAXMainWindowAttribute                  CFSTR("AXMainWindow")
#define kAXFocusedWindowAttribute               CFSTR("AXFocusedWindow")
#define kAXFocusedUIElementAttribute        CFSTR("AXFocusedUIElement")
*/

-(HAXWindowElement *)focusedWindow {
	NSError *error = nil;
	return [self elementOfClass:[HAXWindowElement class] forKey:(NSString *)kAXFocusedWindowAttribute error:&error];
}

@end
