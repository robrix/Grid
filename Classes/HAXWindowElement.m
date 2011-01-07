// HAXWindowElement.m
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Monochrome Industries

#import "HAXWindowElement.h"
#import "HAXElement+Protected.h"

@implementation HAXWindowElement

-(NSPoint)origin {
	NSPoint origin = {0};
	CFTypeRef originRef = [self attributeValueForKey:(NSString *)kAXPositionAttribute error:NULL];
	if(originRef) {
		AXValueGetValue(originRef, kAXValueCGPointType, &origin);
	}
	return origin;
}

-(void)setOrigin:(NSPoint)origin {
	AXValueRef originRef = CFMakeCollectable(AXValueCreate(kAXValueCGPointType, &origin));
	[self setAttributeValue:originRef forKey:(NSString *)kAXPositionAttribute error:NULL];
	[(id)originRef release];
}


-(NSSize)size {
	NSSize size = {0};
	CFTypeRef sizeRef = [self attributeValueForKey:(NSString *)kAXSizeAttribute error:NULL];
	if(sizeRef) {
		AXValueGetValue(sizeRef, kAXValueCGSizeType, &size);
	}
	return size;
}

-(void)setSize:(NSSize)size {
	AXValueRef sizeRef = CFMakeCollectable(AXValueCreate(kAXValueCGSizeType, &size));
	[self setAttributeValue:sizeRef forKey:(NSString *)kAXSizeAttribute error:NULL];
	[(id)sizeRef release];
}


-(NSRect)frame {
	return (NSRect){ .origin = self.origin, .size = self.size };
}

-(void)setFrame:(NSRect)frame {
	self.origin = frame.origin;
	self.size = frame.size;
}

@end
