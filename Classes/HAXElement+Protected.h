// HAXElement+Protected.h
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Rob Rix

#import "HAXElement.h"

@interface HAXElement ()

+(id)elementWithElementRef:(AXUIElementRef)_elementRef;
-(id)initWithElementRef:(AXUIElementRef)_elementRef;

@property (nonatomic, readonly) AXUIElementRef elementRef;

-(CFTypeRef)attributeValueForKey:(NSString *)key error:(NSError **)error;
-(void)setAttributeValue:(CFTypeRef)value forKey:(NSString *)key error:(NSError **)error;

-(id)elementOfClass:(Class)klass forKey:(NSString *)key error:(NSError **)error;

@end
