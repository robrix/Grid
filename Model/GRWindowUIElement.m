// GRWindowUIElement.m
// Created by Rob Rix on 2009-05-28
// Copyright 2009 Monochrome Industries

#import "GRWindowUIElement.h"

@implementation GRWindowUIElement

@synthesize windowRef;

-(CGRect)frame {
	CGRect frame = CGRectZero;
	AXError error = kAXErrorSuccess;
	
	CFTypeRef positionRef = NULL;
	error = AXUIElementCopyAttributeValue(self.windowRef, CFSTR("AXPosition"), &positionRef);
	if((error == kAXErrorSuccess) && (positionRef != NULL)) {
		CFMakeCollectable(positionRef);
		if(!AXValueGetValue(positionRef, kAXValueCGPointType, &frame.origin)) {
			NSLog(@"Couldn’t extract origin.");
		}
	} else {
		NSLog(@"Couldn’t get position.");
	}
	
	CFTypeRef sizeRef = NULL;
	error = AXUIElementCopyAttributeValue(self.windowRef, CFSTR("AXSize"), &sizeRef);
	if((error == kAXErrorSuccess) && (sizeRef != NULL)) {
		CFMakeCollectable(sizeRef);
		if(!AXValueGetValue(sizeRef, kAXValueCGSizeType, &frame.size)) {
			NSLog(@"Couldn’t extract size.");
		}
	} else {
		NSLog(@"Couldn’t get size.");
	}
	
	return frame;
}

-(void)setFrame:(CGRect)frame {
	
}

@end