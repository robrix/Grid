// HAXSystemWideElement.h
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Monochrome Industries

#import <Haxcessibility/HAXElement.h>

@class HAXApplication;

@interface HAXSystemWideElement : HAXElement

+(HAXSystemWideElement *)element;

@property (nonatomic, readonly) HAXApplication *focusedApplication;

@end
