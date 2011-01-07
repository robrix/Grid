// HAXSystem.h
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Monochrome Industries

#import <Haxcessibility/HAXElement.h>

@class HAXApplication;

@interface HAXSystem : HAXElement

+(HAXSystem *)system;

@property (nonatomic, readonly) HAXApplication *focusedApplication;

@end
