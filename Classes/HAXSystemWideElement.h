// HAXSystemWideElement.h
// Created by Rob Rix on 2011-01-06
// Copyright 2011 Monochrome Industries

#import <Haxery/HAXElement.h>

@class HAXApplicationElement;

@interface HAXSystemWideElement : HAXElement

+(HAXSystemWideElement *)element;

-(HAXApplicationElement *)focusedApplication;

@end
