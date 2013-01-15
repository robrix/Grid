// HAXElement+Protected.h
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Rob Rix

#import "HAXElement.h"

@interface HAXElement ()

+(instancetype)elementWithElementRef:(AXUIElementRef)elementRef;
-(instancetype)initWithElementRef:(AXUIElementRef)elementRef;

@property (nonatomic, readonly) AXUIElementRef elementRef;

-(CFTypeRef)attributeValueForKey:(NSString *)key error:(NSError **)error;
-(void)setAttributeValue:(CFTypeRef)value forKey:(NSString *)key error:(NSError **)error;

-(id)elementOfClass:(Class)klass forKey:(NSString *)key error:(NSError **)error;

@end
