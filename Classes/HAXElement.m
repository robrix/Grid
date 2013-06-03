// HAXElement.m
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Rob Rix

#import "HAXElement+Protected.h"

@interface HAXElement ()
@property (nonatomic, assign) AXUIElementRef _elementRef;
@end

@implementation HAXElement

@synthesize elementRef = _elementRef;


+(instancetype)elementWithElementRef:(AXUIElementRef)elementRef {
	return [[self alloc] initWithElementRef:elementRef];
}

-(instancetype)initWithElementRef:(AXUIElementRef)elementRef {
	if((self = [super init])) {
		_elementRef = CFRetain(elementRef);
	}
	return self;
}

-(void)dealloc {
    if (_elementRef) {
        CFRelease(_elementRef);
        _elementRef = NULL;
    }
}


-(CFTypeRef)copyAttributeValueForKey:(NSString *)key error:(NSError **)error {
	NSParameterAssert(key != nil);
	CFTypeRef attributeRef = NULL;
	AXError result = AXUIElementCopyAttributeValue(self.elementRef, (__bridge CFStringRef)key, &attributeRef);
	if((result != kAXErrorSuccess) && error) {
		*error = [NSError errorWithDomain:NSStringFromClass(self.class) code:result userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
			key, @"key",
			(id)self.elementRef, @"elementRef",
		nil]];
	}
	return attributeRef;
}

-(bool)setAttributeValue:(CFTypeRef)value forKey:(NSString *)key error:(NSError **)error {
	AXError result = AXUIElementSetAttributeValue(self.elementRef, (__bridge CFStringRef)key, value);
	if((result != kAXErrorSuccess) && error) {
		*error = [NSError errorWithDomain:NSStringFromClass(self.class) code:result userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
			key, @"key",
			(id)self.elementRef, @"elementRef",
		nil]];
	}
	return result == kAXErrorSuccess;
}

- (bool)performAction:(NSString *)action error:(NSError **)error {
    AXError result = AXUIElementPerformAction(self.elementRef, (__bridge CFStringRef)action);
    if ((result != kAXErrorSuccess) && error) {
        *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:result userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
            action, @"action",
            (id)self.elementRef, @"elementRef",
        nil]];
    }

    return result == kAXErrorSuccess;
}


-(id)elementOfClass:(Class)klass forKey:(NSString *)key error:(NSError **)error {
	AXUIElementRef subelementRef = (AXUIElementRef)[self copyAttributeValueForKey:key error:error];
    id result = nil;
    if (subelementRef) {
        result = [klass elementWithElementRef:subelementRef];
        CFRelease(subelementRef);
        subelementRef = NULL;
    }
    return result;
}

@end
