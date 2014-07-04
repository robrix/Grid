// HAXElement.m
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Rob Rix

#import "HAXElement+Protected.h"

@implementation HAXElement

@synthesize elementRef = _elementRef;


+(instancetype)elementWithElementRef:(AXUIElementRef)elementRef {
	return [[[self alloc] initWithElementRef:elementRef] autorelease];
}

-(instancetype)initWithElementRef:(AXUIElementRef)elementRef {
	if((self = [super init])) {
		_elementRef = elementRef;
	}
	return self;
}


-(CFTypeRef)attributeValueForKey:(NSString *)key error:(NSError **)error {
	NSParameterAssert(key != nil);
	CFTypeRef attributeRef = NULL;
	AXError result = AXUIElementCopyAttributeValue(self.elementRef, (CFStringRef)key, &attributeRef);
	if((result != kAXErrorSuccess) && error) {
		*error = [NSError errorWithDomain:NSStringFromClass(self.class) code:result userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
			key, @"key",
			(id)self.elementRef, @"elementRef",
		nil]];
	}
	return CFMakeCollectable(attributeRef);
}

-(bool)setAttributeValue:(CFTypeRef)value forKey:(NSString *)key error:(NSError **)error {
	AXError result = AXUIElementSetAttributeValue(self.elementRef, (CFStringRef)key, value);
	if((result != kAXErrorSuccess) && error) {
		*error = [NSError errorWithDomain:NSStringFromClass(self.class) code:result userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
			key, @"key",
			(id)self.elementRef, @"elementRef",
		nil]];
	}
	return result == kAXErrorSuccess;
}


-(id)elementOfClass:(Class)klass forKey:(NSString *)key error:(NSError **)error {
	AXUIElementRef subelementRef = (AXUIElementRef)[self attributeValueForKey:key error:error];
	return (subelementRef != nil) ? [klass elementWithElementRef:subelementRef] : nil;
}

@end
