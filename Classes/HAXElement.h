// HAXElement.h
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Monochrome Industries

#import <Foundation/Foundation.h>

@class HAXSystemWideElement;

@interface HAXElement : NSObject {
	AXUIElementRef elementRef;
}

+(HAXSystemWideElement *)systemWideElement;

@end
