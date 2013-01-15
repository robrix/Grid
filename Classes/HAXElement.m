// HAXElement.m
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Rob Rix

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


-(CFTypeRef)attributeValueForKey:(NSString *)key error:(NSError **)error {
	NSParameterAssert(key != nil);
	CFTypeRef attributeRef = NULL;
	AXError result = AXUIElementCopyAttributeValue(elementRef, (CFStringRef)key, &attributeRef);
	if((result != kAXErrorSuccess) && error) {
		*error = [NSError errorWithDomain:NSStringFromClass(self.class) code:result userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
			key, @"key",
			elementRef, @"elementRef",
		nil]];
	}
	return CFMakeCollectable(attributeRef);
}

-(void)setAttributeValue:(CFTypeRef)value forKey:(NSString *)key error:(NSError **)error {
	AXError result = AXUIElementSetAttributeValue(elementRef, (CFStringRef)key, value);
	if((result != kAXErrorSuccess) && error) {
		*error = [NSError errorWithDomain:NSStringFromClass(self.class) code:result userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
			key, @"key",
			elementRef, @"elementRef",
		nil]];
	}
}


-(id)elementOfClass:(Class)klass forKey:(NSString *)key error:(NSError **)error {
	AXUIElementRef subelementRef = (AXUIElementRef)[self attributeValueForKey:key error:error];
	return (subelementRef != nil) ? [klass elementWithElementRef:subelementRef] : nil;
}

@end
