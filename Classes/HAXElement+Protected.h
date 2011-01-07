// HAXElement+Protected.h
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Monochrome Industries

#import "HAXElement.h"

@interface HAXElement ()

+(id)elementWithElementRef:(AXUIElementRef)_elementRef;
-(id)initWithElementRef:(AXUIElementRef)_elementRef;

@property (nonatomic, readonly) AXUIElementRef elementRef;

-(AXUIElementRef)elementRefForKey:(NSString *)key error:(AXError *)error;

@end
