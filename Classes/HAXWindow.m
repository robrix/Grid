// HAXWindow.m
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Rob Rix

#import "HAXWindow.h"
#import "HAXElement+Protected.h"

@implementation HAXWindow

-(CGPoint)origin {
	CGPoint origin = {0};
	CFTypeRef originRef = [self copyAttributeValueForKey:(NSString *)kAXPositionAttribute error:NULL];
	if(originRef) {
		AXValueGetValue(originRef, kAXValueCGPointType, &origin);
		CFRelease(originRef);
		originRef = NULL;
	}
	return origin;
}

-(void)setOrigin:(CGPoint)origin {
	AXValueRef originRef = AXValueCreate(kAXValueCGPointType, &origin);
	[self setAttributeValue:originRef forKey:(NSString *)kAXPositionAttribute error:NULL];
	CFRelease(originRef);
}


-(CGSize)size {
	CGSize size = {0};
	CFTypeRef sizeRef = [self copyAttributeValueForKey:(NSString *)kAXSizeAttribute error:NULL];
	if(sizeRef) {
		AXValueGetValue(sizeRef, kAXValueCGSizeType, &size);
		CFRelease(sizeRef);
		sizeRef = NULL;
	}
	return size;
}

-(void)setSize:(CGSize)size {
	AXValueRef sizeRef = AXValueCreate(kAXValueCGSizeType, &size);
	[self setAttributeValue:sizeRef forKey:(NSString *)kAXSizeAttribute error:NULL];
	CFRelease(sizeRef);
}


-(CGRect)frame {
	return (CGRect){ .origin = self.origin, .size = self.size };
}

-(void)setFrame:(CGRect)frame {
	self.origin = frame.origin;
	self.size = frame.size;
}


-(NSString *)title {
	return CFBridgingRelease([self copyAttributeValueForKey:(NSString *)kAXTitleAttribute error:NULL]);
}


-(bool)raise {
	return [self performAction:(__bridge NSString *)kAXRaiseAction error:NULL];
}

-(bool)close {
	HAXElement *element = [self elementOfClass:[HAXElement class] forKey:(__bridge NSString *)kAXCloseButtonAttribute error:NULL];
	return [element performAction:(__bridge NSString *)kAXPressAction error:NULL];
}

@end
