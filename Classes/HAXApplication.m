// HAXApplication.m
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Rob Rix

#import "HAXApplication.h"
#import "HAXElement+Protected.h"
#import "HAXWindow.h"

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

+ (instancetype)applicationWithPID:(pid_t)pid;
{
    AXUIElementRef app = AXUIElementCreateApplication(pid);
    id result = nil;
    if (app) {
        result = [self elementWithElementRef:app];
        CFRelease(app);
    }
    return result;
}

-(HAXWindow *)focusedWindow {
	NSError *error = nil;
	return [self elementOfClass:[HAXWindow class] forKey:(NSString *)kAXFocusedWindowAttribute error:&error];
}

-(NSArray *)windows {
    NSArray *axWindowObjects = CFBridgingRelease([self copyAttributeValueForKey:(NSString *)kAXWindowsAttribute error:nil]);
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[axWindowObjects count]];
    for (id axObject in axWindowObjects) {
        [result addObject:[HAXWindow elementWithElementRef:(AXUIElementRef)axObject]];
    }
    return result;
}

@end
