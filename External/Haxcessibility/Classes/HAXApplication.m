// HAXApplication.m
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Rob Rix

#import "HAXApplication.h"
#import "HAXElement+Protected.h"
#import "HAXWindow.h"

@implementation HAXApplication

+(instancetype)applicationWithPID:(pid_t)pid; {
	AXUIElementRef app = AXUIElementCreateApplication(pid);
	id result = nil;
	if (app) {
		result = [self elementWithElementRef:app];
		CFRelease(app);
	}
	return result;
}

-(HAXWindow *)focusedWindow {
	NSError *error = nil;
	return [self elementOfClass:[HAXWindow class] forKey:(__bridge NSString *)kAXFocusedWindowAttribute error:&error];
}

-(NSArray *)windows {
	NSArray *axWindowObjects = CFBridgingRelease([self copyAttributeValueForKey:(__bridge NSString *)kAXWindowsAttribute error:nil]);
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:[axWindowObjects count]];
	for (id axObject in axWindowObjects) {
		[result addObject:[HAXWindow elementWithElementRef:(AXUIElementRef)axObject]];
	}
	return result;
}


-(NSString *)localizedName {
	return (NSString *)[self attributeValueForKey:(NSString *)kAXTitleAttribute error:NULL];
}


-(pid_t)processIdentifier {
	pid_t processIdentifier = 0;
	AXUIElementGetPid(self.elementRef, &processIdentifier);
	return processIdentifier;
}

@end
