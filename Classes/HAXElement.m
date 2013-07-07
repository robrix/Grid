// HAXElement.m
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Rob Rix

#import "HAXElement+Protected.h"

@interface HAXElement ()
@property (nonatomic, strong) AXObserverRef observer __attribute__((NSObject));
@end

@implementation HAXElement

@synthesize elementRef = _elementRef;


+(instancetype)elementWithElementRef:(AXUIElementRef)elementRef {
	return [[self alloc] initWithElementRef:elementRef];
}

-(instancetype)initWithElementRef:(AXUIElementRef)elementRef {
	if((self = [super init])) {
		_elementRef = CFRetain(elementRef);
		[self addAXObserver];
	}
	return self;
}

-(void)dealloc {
	if (_elementRef) {
		CFRelease(_elementRef);
		_elementRef = NULL;
	}
	if (_observer) {
		[self removeAXObserver];
	}
}


-(bool)isEqualToElement:(HAXElement *)other {
	return
		[other isKindOfClass:self.class]
	&&	CFEqual(self.elementRef, other.elementRef);
}

-(BOOL)isEqual:(id)object {
	return [self isEqualToElement:object];
}

-(NSUInteger)hash {
	return CFHash(self.elementRef);
}


-(CFTypeRef)copyAttributeValueForKey:(NSString *)key error:(NSError **)error {
	NSParameterAssert(key != nil);
	CFTypeRef attributeRef = NULL;
	AXError result = AXUIElementCopyAttributeValue(self.elementRef, (__bridge CFStringRef)key, &attributeRef);
	if((result != kAXErrorSuccess) && error) {
		*error = [NSError errorWithDomain:NSStringFromClass(self.class) code:result userInfo:@{
			@"key": key,
			@"elementRef": (id)self.elementRef}
		];
	}
	return attributeRef;
}

-(bool)setAttributeValue:(CFTypeRef)value forKey:(NSString *)key error:(NSError **)error {
	NSParameterAssert(value != nil);
	NSParameterAssert(key != nil);
	AXError result = AXUIElementSetAttributeValue(self.elementRef, (__bridge CFStringRef)key, value);
	if((result != kAXErrorSuccess) && error) {
		*error = [NSError errorWithDomain:NSStringFromClass(self.class) code:result userInfo:@{
			@"key": key,
			@"elementRef": (id)self.elementRef
		}];
	}
	return result == kAXErrorSuccess;
}

-(bool)performAction:(NSString *)action error:(NSError **)error {
	NSParameterAssert(action != nil);
	AXError result = AXUIElementPerformAction(self.elementRef, (__bridge CFStringRef)action);
	if ((result != kAXErrorSuccess) && error) {
		*error = [NSError errorWithDomain:NSStringFromClass(self.class) code:result userInfo:@{
			@"action": action,
			@"elementRef": (id)self.elementRef
		}];
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


-(void)addAXObserver {
	AXObserverRef observer;
	AXError err;
	pid_t pid;
	
	err = AXUIElementGetPid(self.elementRef, &pid);
	if (err != kAXErrorSuccess) { return; }
	
	err = AXObserverCreate(pid, axCallback, &observer);
	if (err != kAXErrorSuccess) { return; }
	
	err = AXObserverAddNotification(observer, self.elementRef, kAXUIElementDestroyedNotification, (__bridge void *)(self));
	if (err != kAXErrorSuccess) {
		CFRelease(observer);
		observer = NULL;
		return;
	}
	
	CFRunLoopAddSource([[NSRunLoop mainRunLoop] getCFRunLoop], AXObserverGetRunLoopSource(observer), kCFRunLoopDefaultMode);
	
	self.observer = observer;
	CFRelease(observer);
}

static void axCallback(AXObserverRef observer, AXUIElementRef element, CFStringRef notification, void *refcon) {
	[(__bridge HAXElement *)refcon didObserveNotification:(__bridge NSString *)notification];
}

-(void)didObserveNotification:(NSString *)notification {
	id<HAXElementDelegate> delegate = self.delegate;
	
	if ([notification isEqualToString:(__bridge NSString *)kAXUIElementDestroyedNotification] && [delegate respondsToSelector:@selector(elementWasDestroyed:)]) {
		[delegate elementWasDestroyed:self];
	}
}

-(void)removeAXObserver {
	if (!self.observer) { return; }
	
	(void)AXObserverRemoveNotification(self.observer, self.elementRef, kAXUIElementDestroyedNotification);
	
	CFRunLoopSourceRef observerRunLoopSource = AXObserverGetRunLoopSource(self.observer);
	if (observerRunLoopSource) {
		CFRunLoopRemoveSource([[NSRunLoop mainRunLoop] getCFRunLoop], observerRunLoopSource, kCFRunLoopDefaultMode);
	}
	
	self.observer = NULL;
}

@end
