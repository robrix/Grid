// HAXElement.m
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Monochrome Industries

#import "HAXElement+Protected.h"

@implementation HAXElement

+(id)elementWithElementRef:(AXUIElementRef)_elementRef {
	return [[[self alloc] initWithElementRef:_elementRef] autorelease];
}

-(id)initWithElementRef:(AXUIElementRef)_elementRef {
	if(self = [super init]) {
		elementRef = (AXUIElementRef)[(id)_elementRef retain];
	}
	return self;
}

-(void)dealloc {
	[(id)elementRef release];
	[super dealloc];
}


@synthesize elementRef;


-(AXUIElementRef)elementRefForKey:(NSString *)key error:(AXError *)error {
	NSParameterAssert(key != nil);
	AXUIElementRef attributeRef = NULL;
	AXError localError = AXUIElementCopyAttributeValue(elementRef, (CFStringRef)key, (CFTypeRef *)&attributeRef);
	if(error) *error = localError;
	return  CFMakeCollectable(attributeRef);
}

@end
