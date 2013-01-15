// HAXWindow.m
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Rob Rix

#import "HAXWindow.h"
#import "HAXElement+Protected.h"

@implementation HAXWindow

-(CGPoint)origin {
	CGPoint origin = {0};
	CFTypeRef originRef = [self attributeValueForKey:(NSString *)kAXPositionAttribute error:NULL];
	if(originRef) {
		AXValueGetValue(originRef, kAXValueCGPointType, &origin);
	}
	return origin;
}

-(void)setOrigin:(CGPoint)origin {
	AXValueRef originRef = CFMakeCollectable(AXValueCreate(kAXValueCGPointType, &origin));
	[self setAttributeValue:originRef forKey:(NSString *)kAXPositionAttribute error:NULL];
	[(id)originRef release];
}


-(CGSize)size {
	CGSize size = {0};
	CFTypeRef sizeRef = [self attributeValueForKey:(NSString *)kAXSizeAttribute error:NULL];
	if(sizeRef) {
		AXValueGetValue(sizeRef, kAXValueCGSizeType, &size);
	}
	return size;
}

-(void)setSize:(CGSize)size {
	AXValueRef sizeRef = CFMakeCollectable(AXValueCreate(kAXValueCGSizeType, &size));
	[self setAttributeValue:sizeRef forKey:(NSString *)kAXSizeAttribute error:NULL];
	[(id)sizeRef release];
}


-(CGRect)frame {
	return (CGRect){ .origin = self.origin, .size = self.size };
}

-(void)setFrame:(CGRect)frame {
	self.origin = frame.origin;
	self.size = frame.size;
}

@end
