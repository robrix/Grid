// GRApplicationUIElement.m
// Created by Rob Rix on 2009-05-28
// Copyright 2009 Monochrome Industries

#import "GRApplicationUIElement.h"
#import "GRWindowUIElement.h"

@implementation GRApplicationUIElement

@synthesize applicationRef;

+(GRApplicationUIElement *)focusedApplication {
	GRApplicationUIElement *focusedApplication = nil;
	if((AXAPIEnabled() || AXIsProcessTrusted())) {
		AXError error = kAXErrorSuccess;
		AXUIElementRef systemWideElement = CFMakeCollectable(AXUIElementCreateSystemWide());
		if(systemWideElement) {
			AXUIElementRef focusedApplicationRef = NULL;
			error = AXUIElementCopyAttributeValue(systemWideElement, (CFStringRef)@"AXFocusedApplication", (CFTypeRef *)&focusedApplicationRef);
			if((error == kAXErrorSuccess) && (focusedApplicationRef != NULL)) {
				CFMakeCollectable(focusedApplicationRef);
				focusedApplication = [[self alloc] init];
				focusedApplication.applicationRef = focusedApplicationRef;
			} else {
				NSLog(@"Couldn’t get focused application.");
			}
		} else {
			NSLog(@"Couldn’t get system-wide element.");
		}
	}
	return focusedApplication;
}


-(void)setApplicationRef:(AXUIElementRef)ref {
	AXUIElementRef old = applicationRef;
	applicationRef = ref ? CFRetain(ref) : NULL;
	if(old) CFRelease(old);
}


-(GRWindowUIElement *)focusedWindow {
	GRWindowUIElement *window = nil;
	AXError error = kAXErrorSuccess;
	AXUIElementRef focusedWindowRef = NULL;
	error = AXUIElementCopyAttributeValue(self.applicationRef, (CFStringRef)@"AXFocusedWindow", (CFTypeRef *)&focusedWindowRef);
	if((error == kAXErrorSuccess) && (focusedWindowRef != NULL)) {
		CFMakeCollectable(focusedWindowRef);
		window = [[GRWindowUIElement alloc] init];
		window.windowRef = focusedWindowRef;
	} else {
		NSLog(@"Couldn’t get focused window.");
	}
	return window;
}

@end